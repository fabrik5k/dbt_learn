# 🌱 Seeds no dbt

## 📘 O que são Seeds?

**Seeds** no dbt são arquivos `.csv` que você coloca dentro do diretório `/seeds` do seu projeto. Eles são carregados diretamente no seu seeds warehouse como tabelas, podendo ser usados como tabelas de lookup, configuração, parâmetros ou dados estático

Eles são ideais para:

- Pequenas tabelas de referência (ex: códigos de estado, categorias, faixas de desconto)
- Dados que mudam pouco e são mantidos por analistas
- Configurações parametrizadas aplicadas nos modelos dbt

---

## 📂 Estrutura esperada

Coloque seus arquivos `.csv` no diretório `/seeds`:

```
my_dbt_project/
├── seeds/
│   └── paises.csv
```

---

## 🛠️ Como carregar os seeds

Rode o seguinte comando:

```bash
dbt seed
```

Isso criará uma tabela no seu schema alvo (ex: `DEV.paises`) com os dados do CSV.

---

## ⚙️ Exemplo de configuração no `dbt_project.yml`

```yaml
seeds:
  my_dbt_project:
    paises:
      schema: ref_seeds
      quote_columns: false
```

| Chave           | Descrição |
|------------------|-----------|
| `schema`         | Schema de destino no seeds warehouse. |
| `quote_columns`  | Se `true`, força aspas nos nomes das colunas (útil se colunas têm nomes reservados). |

---

## 🧪 Exemplo prático

### Arquivo `seeds/paises.csv`

```csv
id,nome,sigla
1,Brasil,BR
2,Argentina,AR
3,Chile,CL
```

Após executar `dbt seed`, o dbt criará a tabela `ref_seeds.paises` com os seguintes dados:

| id | nome      | sigla |
|----|-----------|--------|
| 1  | Brasil    | BR     |
| 2  | Argentina | AR     |
| 3  | Chile     | CL     |

---

## 🔗 Usando a seed em um modelo

```sql
SELECT
    f.id_cliente,
    f.valor_compra,
    p.nome AS pais_cliente
FROM {{ ref('fato_compras') }} f
JOIN {{ ref('paises') }} p
  ON f.id_pais = p.id
```

---

## ✅ Boas práticas

- Seeds devem conter poucos registros (idealmente < 1000 linhas).
- Mantenha formatação consistente (sem colunas vazias ou valores ambíguos).
- Use para parametrizar comportamentos (ex: aplicar regras por faixa etária, região, etc).

---

## 🔄 Atualizando dados

Para atualizar os dados de uma seed:

1. Edite o `.csv` dentro da pasta `/seeds`
2. Rode novamente:

```bash
dbt seed --full-refresh
```

Isso recria as tabelas seed no banco, substituindo os dados antigos.

---

## 🧠 Resumo

| Vantagem dos Seeds       | Detalhes |
|--------------------------|----------|
| Fácil versionamento      | Controlados via Git |
| Rápida carga             | São apenas arquivos CSV |
| Integração total com dbt | Podem ser referenciados via `ref()` |

---

## ▶️ Comando final

```bash
dbt seed --full-refresh
```

Use este comando sempre que precisar recarregar os dados dos seus arquivos seed para o warehouse.

