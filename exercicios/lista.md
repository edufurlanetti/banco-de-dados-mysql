# Lista de exercícios — Loja Virtual (MySQL)

Execute antes `scripts/01_schema.sql` e `scripts/02_dados.sql`.
As respostas estão em [`solucoes.sql`](solucoes.sql); tente resolver antes de consultar.

## Nível 1 — Consultas básicas
1. Liste nome e cidade de todos os clientes de São Paulo (`uf = 'SP'`), em ordem alfabética.
2. Mostre os produtos com estoque inferior a 10 unidades.
3. Quantos produtos existem em cada categoria?

## Nível 2 — Junções e agregações
4. Liste cada pedido com o nome do cliente e a quantidade total de itens.
5. Qual é o valor total vendido por categoria (considere apenas pedidos não cancelados)?
6. Mostre os clientes cujo valor total de compras ultrapassa R$ 1.000,00.

## Nível 3 — Recursos avançados
7. Crie uma *view* `vw_estoque_critico` com produtos de estoque abaixo de 10.
8. Usando uma função de janela, mostre para cada pedido o total e o total acumulado por cliente.
9. Crie uma *function* `fn_total_pedido(id)` que retorne o valor total de um pedido.
10. Explique, com um exemplo, a diferença entre `DELETE`, `TRUNCATE` e `DROP`.
