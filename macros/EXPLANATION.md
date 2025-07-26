# 🧩 Macros no dbt

## 📘 O que são Macros?

**Macros** no dbt são blocos reutilizáveis de lógica escrita em **Jinja** (um motor de templates Python). Elas funcionam como **funções** em linguagens de programação: você define uma lógica uma vez e pode reutilizá-la em vários modelos, testes ou até mesmo dentro de outras macros.

---

## 🧠 Macros são como funções

Macros podem receber argumentos, fazer validações, usar condicionais, loops e retornar valores. Assim como funções, elas ajudam a evitar repetição de código e padronizar comportamentos no projeto.

---

## 🔄 Relação com Testes e Transformações Genéricas

Você pode usar macros para criar:

- Testes personalizados reutilizáveis
- Lógicas condicionais em modelos (ex: aplicar filtros por ambiente)
- Funções genéricas para tipos de dados, joins, tratamento de colunas etc.

---

## 📄 Exemplo de macro genérica

```sql
-- macros/limpar_texto.sql

{% macro limpar_texto(campo) %}
    lower(trim({{ campo }}))
{% endmacro %}
```

Você pode usar isso em qualquer modelo:

```sql
SELECT
    {{ limpar_texto('nome_cliente') }} AS nome_tratado
FROM {{ ref('clientes') }}
```

---

## 📦 Importando pacotes no `packages.yml`

O dbt permite importar **pacotes externos** que contêm macros, modelos e seeds reutilizáveis. Isso é útil para não reinventar a roda em funções comuns como SCD, testes genéricos, tratamento de datas etc.

### 📄 Exemplo de `packages.yml`:

```yaml
packages:
  - package: dbt-labs/dbt_utils
    version: 1.1.1
```

Depois de definir o pacote, execute:

```bash
dbt deps
```

Isso instala os pacotes definidos no seu projeto.

---

## 🔗 Importando macros de projetos de terceiros

Você pode encontrar projetos prontos para uso na [hub oficial do dbt](https://hub.getdbt.com/), como:

- [`dbt_utils`](https://hub.getdbt.com/dbt-labs/dbt_utils/latest/)
- [`dbt_date`](https://hub.getdbt.com/dbt-labs/dbt_date/latest/)
- [`codegen`](https://hub.getdbt.com/dbt-labs/codegen/latest/)

Esses pacotes fornecem macros poderosas, como:

```sql
-- Exemplo usando macro do dbt_utils
SELECT *
FROM {{ dbt_utils.union_relations(relations=[ref('tabela1'), ref('tabela2')]) }}
```

---

## 📁 Estrutura típica de macros

```
my_dbt_project/
├── macros/
│   ├── limpar_texto.sql
│   ├── gerar_chave_surrogate.sql
```

---

## ✅ Boas práticas

- Macros devem ser **simples, reutilizáveis e bem nomeadas**
- Centralize lógicas repetidas ou complexas dentro de macros
- Evite usar macros para lógica de transformação inteira — prefira modelos dbt
- Documente bem a entrada e saída das macros

---

## ▶️ Resumo

| Conceito         | Descrição |
|------------------|-----------|
| Macro            | Função Jinja que encapsula lógica reutilizável |
| Uso comum        | Padronizar expressões, colunas, filtros e validações |
| Pacotes externos | Disponíveis no [hub.getdbt.com](https://hub.getdbt.com/) |
| Exemplo prático  | `{{ limpar_texto('coluna') }}` |

---

## ▶️ Comando final

```bash
dbt deps
```

Use esse comando sempre que adicionar ou atualizar pacotes no seu `packages.yml`.
