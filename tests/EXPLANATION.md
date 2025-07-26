# ✅ Testes no dbt

## 📘 O que são testes no dbt?

O dbt permite escrever **testes automatizados** para garantir a integridade, consistência e validade dos dados transformados em seu warehouse. Eles ajudam a detectar erros antes que se tornem problemas nos dashboards ou análises.

Existem **dois tipos principais de testes**:

- **Testes genéricos** (declarativos): reutilizáveis e definidos no arquivo `schema.yml`
- **Testes singulares** (específicos): escritos como SQLs personalizados dentro da pasta `/tests`

---

## 🧪 Testes Genéricos

São **pré-definidos** pelo dbt e usados para regras comuns de qualidade dos dados.

### ✅ Exemplos de testes genéricos embutidos:

| Teste         | O que valida                                 |
|---------------|----------------------------------------------|
| `not_null`    | Nenhum valor nulo na coluna                  |
| `unique`      | Valores únicos na coluna                     |
| `accepted_values` | Valores pertencem a um conjunto permitido |
| `relationships` | Integridade referencial entre tabelas       |

### 📄 Exemplo de uso em `schema.yml`:

```yaml
version: 2

models:
  - name: clientes
    columns:
      - name: id
        tests:
          - not_null
          - unique

      - name: status
        tests:
          - accepted_values:
              values: ['ativo', 'inativo']

  - name: compras
    columns:
      - name: id_cliente
        tests:
          - relationships:
              to: ref('clientes')
              field: id
```

---

## 🧠 Testes Singulares (Personalizados)

São escritos manualmente como **consultas SQL** que retornam linhas **inválidas**. Se **alguma linha for retornada**, o teste falha.

### 📁 Estrutura:

Coloque os testes em:  
```
/tests/
  └── nome_do_teste.sql
```

### 📄 Exemplo:

```sql
-- tests/clientes_ativos_sem_nome.sql

SELECT *
FROM {{ ref('clientes') }}
WHERE status = 'ativo'
  AND (nome IS NULL OR nome = '')
```

Esse teste falhará se houver **clientes ativos sem nome preenchido**.

---

## ▶️ Rodando os testes

```bash
dbt test
```

Ou para testar apenas um modelo:

```bash
dbt test --select clientes
```

---

## 🔍 Verificando resultados

Após a execução, o dbt mostra quais testes passaram ou falharam. Em caso de falha, os registros que não obedecem à regra são listados.

---

## ✅ Boas práticas

- Use testes genéricos para validações comuns
- Crie testes singulares para regras de negócio específicas
- Nomeie bem seus arquivos de teste para facilitar rastreabilidade
- Use `dbt build` para rodar tudo (models + tests)

---

## 🧠 Resumo

| Tipo de Teste      | Definido em        | Exemplo                                 |
|--------------------|--------------------|-----------------------------------------|
| Genérico           | `schema.yml`       | `not_null`, `unique`, `relationships`   |
| Singular           | Arquivo `.sql`     | Regras específicas em `tests/*.sql`     |

---

## 🧪 Exemplo final de estrutura:

```
my_dbt_project/
├── models/
│   └── clientes.sql
├── tests/
│   └── clientes_ativos_sem_nome.sql
├── models/
│   └── schema.yml
```

---

## ▶️ Comando final

```bash
dbt test
```

Esse comando executa todos os testes definidos no seu projeto.
