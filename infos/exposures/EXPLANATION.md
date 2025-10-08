# 🌐 Exposures no dbt

## 📘 O que são Exposures?

No dbt, **Exposures** são uma forma de documentar e rastrear **ativos externos** que dependem dos dados produzidos pelos seus modelos dbt.  

Eles permitem relacionar **dashboards, relatórios, notebooks, pipelines e APIs externas** ao seu projeto dbt.

---

## Como funcionam?

- Os exposures são definidos em arquivos YAML (normalmente em `models/` ou `exposures/`).
- Cada exposure descreve um **ativo externo**, suas dependências e um responsável.
- Assim, é possível **visualizar no DAG do dbt Cloud** como os dashboards estão conectados aos modelos e fontes.

---

## Onde visualizar?

- Ao rodar `dbt docs generate && dbt docs serve`, os exposures aparecem na interface da documentação.
- No **dbt Cloud**, eles também aparecem como nós no DAG.

---

## Exemplo de Exposure

Arquivo: `models/dashboard.yml`

```yaml
version: 2

exposures:
  - name: Executive Dashboard
    type: dashboard
    maturity: low
    url: https://7e942fbd.us2a.app.preset.io:443/r/2
    description: Executive Dashboard about Airbnb listings and hosts
    depends_on:
      - ref('dim_listings_w_hosts')
      - ref('fullmoon_reviews')
    owner:
      name: Zoltan C. Toth
      email: hello@learndbt.com
```

---

### Campos principais:

| Campo          | Descrição |
|----------------|-----------|
| `name`         | Nome do exposure (aparece na documentação). |
| `type`         | Tipo de ativo externo (`dashboard`, `analysis`, `ml`, `application`, `notebook`). |
| `maturity`     | Nível de maturidade (`low`, `medium`, `high`). |
| `url`          | Link direto para o ativo (dashboard, notebook etc.). |
| `description`  | Descrição do propósito do ativo. |
| `depends_on`   | Lista de modelos/fonte usados pelo ativo. Usa `ref()` ou `source()`. |
| `owner`        | Responsável pelo ativo (nome e email). |

---

## Como rodar e visualizar:

1. Gere a documentação:

```bash
dbt docs generate
```

2. Sirva a documentação localmente:

```bash
dbt docs serve
```

3. Acesse no navegador:

```
http://localhost:8080
```

Você verá os **exposures** aparecendo como nós no grafo (DAG).

---

## Benefícios dos Exposures

- **Governança:** Permite rastrear quem depende dos seus dados.
- **Transparência:** Dá visibilidade para dashboards e outros ativos.
- **Impact Analysis:** Caso um modelo seja alterado, é possível ver quais relatórios serão impactados.

---

## Boas práticas

- Defina exposures para **todos os dashboards e pipelines críticos**.
- Sempre inclua um `owner`.
- Use `depends_on` para rastrear corretamente as dependências.

---

## Exemplo de fluxo:

1. Alteração em `dim_listings_w_hosts`
2. dbt atualiza a documentação
3. O DAG mostra que o **Executive Dashboard** depende desse modelo

Isso facilita entender o impacto de qualquer mudança.
