# 📸 Snapshots no dbt

## 📘 O que são Snapshots?

Snapshots no dbt permitem **registrar o histórico de mudanças em registros de uma tabela de origem** ao longo do tempo. Eles são ideais para acompanhar alterações em dados que normalmente seriam sobrescritos (como nomes, e-mails, status etc), aplicando conceitos como **Slowly Changing Dimensions (SCD) Tipo 2**.

Com snapshots, o dbt:

- Detecta mudanças em registros da tabela de origem
- Cria novas versões dos dados modificados
- Mantém o histórico com colunas como `dbt_valid_from`, `dbt_valid_to` e `dbt_scd_id`

---

## 📄 Exemplo 1 — Estratégia `check`

Utiliza comparação direta entre valores de colunas para identificar alterações.

### Tabela de origem no tempo T1:

| id_cliente | nome      | email          | status | updated_at          |
|------------|-----------|----------------|--------|----------------------|
| 1          | Ana Souza | ana@email.com  | ativo  | 2024-01-01 10:00:00 |
| 2          | João Lima | joao@email.com | ativo  | 2024-01-01 09:00:00 |

### Evento no tempo T2:
Cliente Ana muda o status para inativo.

### Snapshot:

```sql
{% snapshot clientes_snapshot_check %}
{{
    config(
        target_schema='snapshots',
        unique_key='id_cliente',
        strategy='check',
        check_cols=['nome', 'email', 'status'],
        invalidate_hard_deletes=True
    )
}}

SELECT id_cliente, nome, email, status
FROM {{ source('erp', 'clientes') }}

{% endsnapshot %}
```

### Resultado da tabela de snapshot:

| id_cliente | nome      | email          | status  | dbt_valid_from       | dbt_valid_to         |
|------------|-----------|----------------|---------|----------------------|----------------------|
| 1          | Ana Souza | ana@email.com  | ativo   | 2024-01-01 10:00:00  | 2024-02-01 08:00:00  |
| 1          | Ana Souza | ana@email.com  | inativo | 2024-02-01 08:00:00  | null                 |
| 2          | João Lima | joao@email.com | ativo   | 2024-01-01 09:00:00  | null                 |

---

## 📄 Exemplo 2 — Estratégia `timestamp`

Utiliza uma coluna `updated_at` como critério para identificar mudanças.

### Tabela de origem no tempo T1:

Mesma tabela inicial.

### Tabela no tempo T2:

Cliente Ana agora tem:

```text
status = inativo
updated_at = 2024-02-01 08:00:00
```

### Snapshot:

```sql
{% snapshot clientes_snapshot_timestamp %}
{{
    config(
        target_schema='snapshots',
        unique_key='id_cliente',
        strategy='timestamp',
        updated_at='updated_at',
        invalidate_hard_deletes=True
    )
}}

SELECT id_cliente, nome, email, status, updated_at
FROM {{ source('erp', 'clientes') }}

{% endsnapshot %}
```

### Resultado da tabela de snapshot:

| id_cliente | nome      | email          | status  | updated_at           | dbt_valid_from       | dbt_valid_to         |
|------------|-----------|----------------|---------|----------------------|----------------------|----------------------|
| 1          | Ana Souza | ana@email.com  | ativo   | 2024-01-01 10:00:00  | 2024-01-01 10:00:00  | 2024-02-01 08:00:00  |
| 1          | Ana Souza | ana@email.com  | inativo | 2024-02-01 08:00:00  | 2024-02-01 08:00:00  | null                 |
| 2          | João Lima | joao@email.com | ativo   | 2024-01-01 09:00:00  | 2024-01-01 09:00:00  | null                 |

---

## 🧠 Comparação rápida

| Estratégia   | Detecta mudanças quando...             | Use quando...                                  |
|--------------|----------------------------------------|------------------------------------------------|
| `check`      | Algum valor de coluna especificada mudar | Fonte **não possui** campo `updated_at` confiável |
| `timestamp`  | Campo `updated_at` tiver novo valor     | Fonte **tem** campo `updated_at` bem mantido     |

---

## ▶️ Execução

Para aplicar os snapshots, basta rodar:

```bash
dbt snapshot
```

As tabelas serão criadas no `target_schema` especificado (`snapshots`, por exemplo) com histórico completo dos registros.


---

## ⚙️ Explicação da estrutura `config()` no snapshot

Quando você define um snapshot no dbt, a função `config()` serve para configurar como o snapshot será executado. Aqui está um exemplo:

```jinja
{{
  config(
    target_schema='DEV',
    unique_key='id',
    strategy='timestamp',
    updated_at='updated_at',
    invalidate_hard_deletes=True
  )
}}
```

### 🔍 O que cada parâmetro faz:

| Parâmetro               | Descrição |
|-------------------------|-----------|
| `target_schema`         | O schema (esquema) do banco de dados onde o snapshot será salvo. Ex: `'DEV'`, `'snapshots'`, `'analytics'`. |
| `unique_key`            | A coluna (ou combinação de colunas) que identifica de forma única cada linha. Ex: `'id'`. |
| `strategy`              | Define a estratégia de detecção de mudanças: `'check'` (compara valores) ou `'timestamp'` (usa campo de data). |
| `updated_at`            | Campo de data usado para detectar atualizações quando `strategy='timestamp'`. Ignorado se usar `check`. |
| `invalidate_hard_deletes` | Se `True`, o dbt cria uma nova linha no snapshot se uma linha da origem "desaparece", assumindo que foi deletada. Se `False`, o snapshot ignora deleções. |

Essa configuração é passada no início do bloco `{% snapshot ... %}` e é essencial para controlar o comportamento e granularidade da captura histórica dos dados.
