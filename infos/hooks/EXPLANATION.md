# 🪝 Hooks no dbt

## 📘 O que são Hooks?

**Hooks** no dbt são instruções SQL executadas automaticamente em momentos específicos do fluxo de execução do dbt.
Eles são úteis para executar tarefas adicionais, como gerenciamento de permissões, criação de logs ou limpeza de dados.

---

## Onde podem ser configurados?

Os hooks podem ser configurados:

- No nível do **projeto**
- No nível de **subpasta (folder)**
- No nível do **modelo específico**

A configuração é feita no `dbt_project.yml` ou dentro do `config()` em um modelo.

---

## Tipos de Hooks

### 1. **on_run_start**

- **Quando roda:** No início do comando `dbt run`, `dbt seed` ou `dbt snapshot`
- **Uso típico:** Preparar o ambiente antes da execução.

**Exemplo: Criar uma tabela temporária de log no início do processo**

```yaml
on-run-start:
  - "create table if not exists analytics.run_logs (run_id string, started_at timestamp)"
  - "insert into analytics.run_logs values('{{ invocation_id }}', current_timestamp)"
```

---

### 2. **on_run_end**

- **Quando roda:** No final do comando `dbt run`, `dbt seed` ou `dbt snapshot`
- **Uso típico:** Registrar finalização ou limpar recursos.

**Exemplo: Atualizar status da execução**

```yaml
on-run-end:
  - "update analytics.run_logs set finished_at = current_timestamp where run_id = '{{ invocation_id }}'"
```

---

### 3. **pre-hook**

- **Quando roda:** Antes da construção de cada **modelo/seed/snapshot**.
- **Uso típico:** Garantir que pré-requisitos estão prontos antes de um modelo específico ser construído.

**Exemplo: Remover dados antigos antes de popular uma tabela**

```yaml
models:
  my_project:
    staging:
      +pre-hook:
        - "delete from {{ this }}"
```

---

### 4. **post-hook**

- **Quando roda:** Após a construção de cada **modelo/seed/snapshot**.
- **Uso típico:** Ajustar permissões, criar índices, realizar grants.

**Exemplo: Dar permissão para um usuário acessar a tabela gerada**

```yaml
models:
  my_project:
    marts:
      +post-hook:
        - "grant select on {{ this }} to user BI_ANALYST"
```

Esse exemplo garante que, após a criação do modelo, o usuário `BI_ANALYST` tenha acesso de leitura.

---

## Como configurar hooks

1. **No arquivo `dbt_project.yml` (nível global):**

```yaml
on-run-start:
  - "insert into logs values('Execução iniciada em {{ run_started_at }}')"
on-run-end:
  - "insert into logs values('Execução finalizada em {{ run_started_at }}')"
```

2. **Dentro de um modelo específico (com `config()`):**

```sql
{{ config(
    post_hook=["grant select on {{ this }} to user BI_ANALYST"]
) }}

select * from {{ ref('clientes') }}
```

3. **Ou no nível da pasta (folder) no `dbt_project.yml`:**

```yaml
models:
  my_project:
    staging:
      +pre-hook:
        - "delete from {{ this }}"
```

---

## Exemplos práticos de uso para cada tipo

- **on_run_start:** Criar tabelas temporárias de log antes da execução
- **on_run_end:** Registrar execução ou enviar mensagem de finalização
- **pre-hook:** Limpar dados ou preparar índices antes de construir um modelo
- **post-hook:** Conceder permissões de acesso (ex: `grant`) ou criar índices após a criação da tabela

---

## Resumo

| Hook            | Momento de execução                                     |
|-----------------|----------------------------------------------------------|
| on_run_start    | No início do comando `dbt run/seed/snapshot`             |
| on_run_end      | No final do comando `dbt run/seed/snapshot`              |
| pre-hook        | Antes de construir um modelo/seed/snapshot específico    |
| post-hook       | Após construir um modelo/seed/snapshot específico        |
