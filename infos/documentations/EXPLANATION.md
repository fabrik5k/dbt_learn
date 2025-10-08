# 📝 Documentação no dbt

## 📘 O que é a documentação no dbt?

O dbt permite documentar **modelos, colunas, fontes, testes e exposições** usando arquivos YAML e arquivos Markdown.  
A documentação pode ser gerada automaticamente e visualizada em uma interface web interativa.

---

## 🛠 Onde documentar?

A documentação básica é feita no arquivo `schema.yml` dentro da pasta `models`.

---

## 🧩 Exemplo de documentação em `schema.yml`

```yaml
version: 2

models:
  - name: clientes
    description: "Tabela que armazena informações dos clientes finais"
    columns:
      - name: id
        description: "Identificador único do cliente"
      - name: nome
        description: "Nome completo do cliente"
      - name: status
        description: "Status do cliente: ativo ou inativo"
```

---

## 🔗 Documentação avançada com arquivos Markdown

Você pode apontar para um arquivo Markdown externo usando a sintaxe `docs()`:

```yaml
models:
  - name: clientes
    description: "{{ docs('clientes_doc') }}"
```

E criar o arquivo:

```
models/docs/clientes_doc.md
```

Com conteúdo:

```markdown
# Documentação do modelo clientes

Este modelo armazena dados dos clientes e suas informações de status.

- Atualizado diariamente
- Utilizado em dashboards de vendas
```

É possivel botar imagens tambem, para isso voce deve criar uma nova pasta no projeto, a pasta `assets` e referencia-la em dbt_project.yml desta forma:
```yaml
asset-paths: ["assets"]
```

---

## ▶️ Gerando a documentação

Para compilar a documentação:

```bash
dbt docs generate
```

Isso cria os arquivos necessários no diretório `target`.

---

## ▶️ Visualizando a documentação via web

Para abrir um servidor local:

```bash
dbt docs serve
```

A documentação ficará disponível em um endereço como:

```
http://localhost:8080
```

---

## 🔑 Comandos importantes de documentação

- `dbt docs generate`: gera os arquivos estáticos de documentação
- `dbt docs serve`: inicia um servidor web local para explorar a documentação
- `dbt build`: executa modelos, testes e snapshots e atualiza a documentação
- `dbt run`: gera modelos (documentação é atualizada junto)

---

## 📁 Estrutura sugerida para documentação

```
my_dbt_project/
├── models/
│   ├── docs/
│   │   └── clientes_doc.md
│   ├── clientes.sql
│   └── schema.yml
```

---

## ✅ Boas práticas

- Use `description` sempre para documentar modelos e colunas
- Para documentações mais extensas, use arquivos Markdown externos
- Atualize a documentação sempre que alterar a estrutura do modelo
- Utilize `dbt docs generate && dbt docs serve` regularmente para validar as informações

---

## Resumo final

1. Documente no `schema.yml`
2. Use `description` para descrições simples
3. Use `docs()` para descrever usando Markdown
4. Gere e visualize a documentação com:

```bash
dbt docs generate
dbt docs serve
```
