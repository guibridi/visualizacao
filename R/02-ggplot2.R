# Carregar pacotes --------------------------------------------------------

library(tidyverse)
library(dados)

temperatura_por_mes <- clima %>%
  mutate(mes = lubridate::floor_date(data_hora, "month")) %>%
  group_by(
    origem,
    mes
  ) %>%
  summarise(
    temperatura_media = (mean(temperatura, na.rm = TRUE)-30)/2
  ) %>%
  ungroup()

# Filosofia ---------------------------------------------------------------

# Um gráfico estatístico é uma representação visual dos dados
# por meio de atributos estéticos (posição, cor, forma,
# tamanho, ...) de formas geométricas (pontos, linhas,
# barras, ...). Leland Wilkinson, The Grammar of Graphics

# Layered grammar of graphics: cada elemento do
# gráfico pode ser representado por uma camada e
# um gráfico seria a sobreposição dessas camadas.
# Hadley Wickham, A layered grammar of graphics

# Gráfico de linhas -------------------------------------------

# Apenas o canvas
temperatura_por_mes %>%
  ggplot()

# Salvando em um objeto
p <- temperatura_por_mes %>%
  ggplot()

# Adicionando eixo X
temperatura_por_mes %>%
  ggplot() +
  aes(x = mes)

# Adicionando eixo Y
temperatura_por_mes %>%
  ggplot() +
  aes(x = mes, y = temperatura_media)

# Gráfico de dispersão da temperatura média do mês ao longo do tempo
temperatura_por_mes %>%
  ggplot() +
  aes(x = mes, y = temperatura_media, color = origem) +
  geom_line() +
  geom_point()

# Mesma informação, apenas trocando os mapeamentos estétiticos
temperatura_por_mes %>%
  ggplot() +
  geom_line(
    aes(x = mes, y = origem, color = temperatura_media),
    size = 10
  )

# Salvando um gráfico em um arquivo
p <- temperatura_por_mes %>%
  ggplot() +
  geom_line(aes(x = mes, y = origem, color = temperatura_media), size = 10)

ggsave("meu_grafico.png", plot = p, width = , height = )

# Tema e labels --------------------------------------------------------------------

# Temas prontos
temperatura_por_mes %>%
  ggplot() +
  geom_line(aes(x = mes, y = origem, color = temperatura_media), size = 10) +
  # theme_light()
  # theme_classic()
  # theme_dark()
  theme_minimal() +
  theme()

# A função theme()
temperatura_por_mes %>%
  ggplot() +
  geom_line(aes(x = mes, y = origem, color = temperatura_media), size = 10) +
  labs(
    title = "Gráfico de dispersão",
    subtitle = "Receita vs Orçamento",
    x = "Mês",
    y = "Aeroporto mais próximo do ponto de medição",
    color = "Temperatura média (ºC)"
  ) +
  theme(
    plot.title = element_text(hjust = 0.5, ),
    plot.subtitle = element_text(hjust = 0.5),
    legend.position = c(.5, .5)
  )

grafico_base <- temperatura_por_mes %>%
  ggplot() +
  geom_line(aes(x = mes, y = origem, color = temperatura_media), size = 10) +
  labs(
    title = "Gráfico de dispersão",
    subtitle = "Receita vs Orçamento",
    x = "Mês",
    y = "Aeroporto mais próximo do ponto de medição",
    color = stringr::str_wrap("Temperatura média (ºC)", 10),
    caption = "Fonte: ASOS download from Iowa Environmental Mesonet"
  )

# Vamos explorar os componentes mais importantes do theme

# Esses componentes têm vários subcomponentes, que podem ser consultados
# em help(theme)

# o padrão dos nomes é, por exemplo, theme(axis.text.x)
# Praticamente todos os componentes devem ser parametrizados como um

# (a) element_text, para componentes textuais como por exemplo axis.text.x , axis.text.y e legend.title

# Exemplos:

# mudando o tamanho e a cor dos textos dos eixos

grafico_base +
  theme(
    axis.text = element_text(color = 'red', size = 20)
  )

# mudando o tamanho e a cor do texto do título da legenda

grafico_base +
  theme(
    legend.title = element_text(color = 'red', size = 20)
  )

# mudando o tamanho e a cor do texto do texto da legenda

grafico_base +
  theme(
    legend.text = element_text(color = 'red', size = 20)
  )

# (b) element_rect, para bordas e fundos, como panel.background
# Exemplos

# mudando a cor do fundo
grafico_base +
  theme(
    panel.background = element_rect(fill = 'white')
  )

# mudando a cor do fundo e as bordas
grafico_base +
  theme(
    panel.background = element_rect(fill = 'white', color = 'gray')
  )

# mudando a cor do fundo, das bordas e aumentando o tamanho das bordas
grafico_base +
  theme(
    panel.background = element_rect(fill = 'white', color = 'gray', size = 2)
  )

# por que as gradações de escala sumiram? porque a cor padrão do componente axis.ticks é branco.
# vamos ver como mexer nele:

# (c) element_line, para linhas como axis.line e axis.ticks e panel.grid

# mudando a cor do fundo, das bordas, aumentando o tamanho das bordas e trocando a cor das gradações de escala

# mudando a cor das linhas principais dos eixos x e y

grafico_base +
  theme(
    panel.background = element_rect(fill = 'white', color = 'gray', size = 2),
    panel.grid  = element_line(color = 'blue')
  )

# mudando a cor das linhas principais do eixo x

grafico_base +
  theme(
    panel.background = element_rect(fill = 'white', color = 'gray', size = 2),
    panel.grid.major.x  = element_line(color = 'gray')
  )

# mudando a cor das linhas secundárias do eixo x

grafico_base +
  scale_x_datetime(
    date_breaks = "10 week",
    date_labels = "%U"
  ) +
  theme(
    panel.background = element_rect(fill = 'white', color = 'gray', size = 2),
    panel.grid.major.x  = element_line(color = 'darkgray'),
    panel.grid.minor.x  = element_line(color = 'lightgray')
  )

# acabando com a diferença entre linhas major e minors

grafico_base +
  theme(
    panel.background = element_rect(fill = 'white', color = 'gray', size = 2),
    panel.grid.major.x  = element_line(color = 'lightgray'),
    panel.grid.minor.x  = element_line(color = 'blue', size = 10)
  )

# Mais temas
install.packages("ggthemes")

# Tema do fivethirthyeight
temperatura_por_mes %>%
  ggplot() +
  geom_line(aes(x = mes, y = origem, color = temperatura_media), size = 10) +
  labs(
    title = "Gráfico de dispersão",
    subtitle = "Receita vs Orçamento",
    x = "Mês",
    y = "Aeroporto mais próximo do ponto de medição",
    color = "Temperatura média (ºC)"
  ) +
  # ggthemes::theme_fivethirtyeight()

# Tema da Google Docs
temperatura_por_mes %>%
  ggplot() +
  geom_line(aes(x = mes, y = origem, color = temperatura_media), size = 10) +
  labs(
    title = "Gráfico de dispersão",
    subtitle = "Receita vs Orçamento",
    x = "Mês",
    y = "Aeroporto mais próximo do ponto de medição",
    color = "Temperatura média (ºC)"
  ) +
  ggthemes::theme_igray()

# Mais exemplos em
# https://yutannihilation.github.io/allYourFigureAreBelongToUs/ggthemes/

# Gráfico de barras -------------------------------------------------------

# até agora exploramos bastante o geom_lines

# vamos explorar outros geoms importantes:

# para destacar uma comparação entre quantidade ou valores de diferentes grupos, por exemplo, uma alternativa interessante é a barra
# geom_col

pinguins %>%
  count(especies) %>%
  ggplot(aes(x = especies, y = n,fill = especies)) +
  geom_col() +
  ggthemes::theme_fivethirtyeight()

# no dataset pinguins, tem bem mais pinguins-de-adélia do que pinguins-de-barbicha

# nesse tipo de gráfico é muito comum que a gente queira ordenar da maior barra para a menor barra, justamente
# para destacar a comparação nessa dimensão

# para esse tipo de operação usamos o pacote forcats
library(forcats)

# ordenando do maior para o menor
pinguins %>%
  count(especies) %>%
  mutate(especies = fct_reorder(especies, n)) %>%
  ggplot(aes(x = especies, y = n,fill = especies)) +
  geom_col() +
  ggthemes::theme_fivethirtyeight()

# ordenando do menor para o maior
pinguins %>%
  count(especies) %>%
  mutate(especies = fct_reorder(especies, -n)) %>%
  ggplot(aes(x = especies, y = n, fill = especies)) +
  geom_col() +
  geom_label(aes(label = n, y = n/2), fill = "white") +
  ggthemes::theme_fivethirtyeight()

# às vezes queremos comparar, ao mesmo tempo, grupos e subgrupos. isso é, no mesmo "x" vão existir várias barras para serem plotadas

# aqui temos duas opções:

# empilhar (padrão);

pinguins %>%
  count(especies, sexo) %>%
  ggplot(aes(x = sexo, y = n,fill = especies)) +
  geom_col() +
  ggthemes::theme_fivethirtyeight()

# colocar lado a lado;

pinguins %>%
  count(especies, sexo) %>%
  mutate(especies = fct_reorder(especies, n)) %>%
  tidyr::drop_na(sexo) %>%
  ggplot(aes(x = n, y = sexo, fill = especies)) +
  geom_col(position = position_dodge2(preserve = "single")) +
  # "dodge" significa "desviar"
  ggthemes::theme_fivethirtyeight() +
  # mudando a ordem das cores da legenda em um gráfico de barras
  guides(fill = guide_legend(reverse = TRUE)) +
  theme(
    legend.position = "right",
    legend.direction = "vertical"
  )

# aqui podemos ver que não parece que há uma grande diferença entre o número de pinguis machos e fêmeas e nem da distribuição
# de espécies em cada grupo

# empilhar com relação aos valores relativos dentro de cada grupo:

pinguins %>%
  count(especies, sexo) %>%
  ggplot(aes(x = sexo, y = n, fill = especies)) +
  geom_col(position = 'fill') +
  # "fill" significa "preencher"
  ggthemes::theme_fivethirtyeight()


# Visualizando distribuições ----------------------------------------------

# Ás vezes queremos visualizar distribuições, no sentido estatístico mesmo

# para isso utilizaros geoms como geom_histogram ou geom_density

pinguins %>%
  ggplot(aes(x = comprimento_bico)) +
  geom_histogram()

# ajeitando o gráfico fica:

pinguins %>%
  ggplot(aes(x = comprimento_bico)) +
  geom_histogram(fill = 'royalblue', color = 'white') +
  theme_bw() +
  labs(x = "Comprimento do bico (cm)",
       y = "Contagem")

# usando a densidade (que suaviza o histograma para desconsiderar os picos)

pinguins %>%
  ggplot(aes(x = comprimento_bico)) +
  geom_density(fill = 'royalblue', color = 'white') +
  theme_bw() +
  labs(x = "Comprimento do bico (cm)",
       y = "Contagem")

# podemos também usar essas funções para comparar grupos

pinguins %>%
  ggplot(aes(x = comprimento_bico, fill = especies)) +
  geom_histogram(color = 'white') +
  theme_bw() +
  labs(x = "Comprimento do bico (cm)",
       y = "Contagem")

# a sobreposição atrapalha um pouco a visualização por histograma

# se quisermos suavizar a sobreposição a função geom_density parece adequada,
# pois aceita um parâmetros de transparência, que se chama "alpha", pois o seu uso aqui cria um sombreado

pinguins %>%
  ggplot(aes(x = comprimento_bico, fill = especies)) +
  geom_density(color = 'white', alpha = .8) +
  theme_bw() +
  labs(x = "Comprimento do bico (cm)",
       y = "Contagem")

# o efeito não é tão legal no geom_histogram, porque é como se uma barra estivesse à frente da outra

pinguins %>%
  ggplot(aes(x = comprimento_bico, fill = especies)) +
  geom_histogram(color = 'white', alpha = .7) +
  theme_bw() +
  labs(x = "Comprimento do bico (cm)",
       y = "Contagem")

# pontos ------------------------------------------------------------------

# essa é a representação que dá destaque total ao valor numérico dos dados. é a representação "mais crua" dos dados.
# a quantidade de tinta gasta por linha da base de dados é a menor possível

# serve para destacar o formato da nuve de pontos formada por dados numéricos
# só a nuvem em si não comunica nenhuma mensagem explicitamente. a intepretação fica a cargo de quem vê o gráfico

clima %>%
  filter(origem == "JFK") %>%
  group_by(dia_do_ano = lubridate::floor_date(data_hora, "day")) %>%
  summarise(temperatura = min(temperatura)) %>%
  ggplot(aes(x = dia_do_ano, y = temperatura)) +
  geom_point()

# é interessante complementar um gráfico de pontos com algum elemento de destaque

# geom_smooth é interessante para destacar tendências
clima %>%
  filter(origem == "JFK") %>%
  group_by(dia_do_ano = lubridate::floor_date(data_hora, "day")) %>%
  summarise(temperatura = min(temperatura)) %>%
  ggplot(aes(x = dia_do_ano, y = temperatura)) +
  geom_point() +
  geom_smooth() +
  ggthemes::theme_wsj()

# geom_encircle é interessante para destacar pontos distantes da nuvem de pontos

library(ggalt)

dados <- clima %>%
  filter(origem == "JFK") %>%
  group_by(dia_do_ano = lubridate::floor_date(data_hora, "day")) %>%
  summarise(temperatura = min(temperatura))

dia_estranho <- dados %>%
  filter(dia_do_ano == as.Date("2013-05-08"))

dados %>%
  ggplot(aes(x = dia_do_ano, y = temperatura)) +
  geom_point() +
  ggalt::geom_encircle(
    data = dia_estranho,
    color = "red", s_shape = .1, expand = .01, size = 3
  )

# Também é possível obter resultados similares usando gghighlight

dados %>%
  mutate(dia_do_ano = as.Date(dia_do_ano)) %>%
  ggplot(aes(x = dia_do_ano, y = temperatura)) +
  geom_point() +
  gghighlight::gghighlight(
    dia_do_ano == as.Date("2013-05-08") & temperatura < 20,
    label_key = dia_do_ano,
    label_params = list(size = 10)
  ) +
  geom_label(aes(label = dia_do_ano), vjust = -1, colour = "blue")

mtcars %>%
  tibble::rownames_to_column() %>%
  ggplot(aes(disp, mpg)) +
  geom_point() +
  # geom_label(aes(label = rowname))
  ggrepel::geom_label_repel(aes(label = rowname))

# summarise()
# summarize()



# cores -----------------------------------------------------------------------

# Existem muitas, muitas paletas de cores para serem usadas.

# No {ggplot2}, temos já implementadas as paletas viridis e ColorBrewer
# Vamos mostrar alguns exemplos de cada

ggplot(diamante, aes(quilate, preco)) +
  geom_bin2d() +
  scale_x_log10() +
  scale_y_log10() +
  # _c() vem de "continuo"
  scale_fill_viridis_c(
    alpha = .99,
    begin = .2,
    end = .8,
    direction = 1,
    option = "D"
  ) +
  theme_minimal()

# variaveis ordinais já vem em viridis
diamante %>%
  ggplot(aes(corte, fill = cor)) +
  geom_bar()

diamante %>%
  dplyr::mutate(cor = factor(as.character(cor))) %>%
  ggplot(aes(corte, fill = cor)) +
  geom_bar()

diamante %>%
  dplyr::mutate(cor = factor(as.character(cor))) %>%
  ggplot(aes(corte, fill = cor)) +
  scale_fill_viridis_d(option = "A") +
  geom_bar()

p_base <- diamante %>%
  ggplot(aes(corte, fill = cor)) +
  geom_bar() +
  theme_minimal()

# ColorBrewer

# sequencial
p_base + scale_fill_brewer(palette = "BuPu")

# divergente
p_base + scale_fill_brewer(palette = "RdBu")

# qualitativo
p_base + scale_fill_brewer(palette = "Pastel1")


scale_fill_brewer()

## usando brewer para variáveis contínuas
# scale_fill_distiller()
# scale_fill_fermenter()

ggplot(diamante, aes(quilate, preco)) +
  geom_bin2d() +
  scale_fill_distiller(palette = "RdBu") +
  scale_x_log10() +
  scale_y_log10() +
  theme_minimal()

# veja a diferença na legenda
ggplot(diamante, aes(quilate, preco)) +
  geom_bin2d() +
  scale_fill_fermenter(palette = "RdBu") +
  scale_x_log10() +
  scale_y_log10() +
  theme_minimal()

# outros temas foram colocados nos exercícios!

# Fazendo seu próprio esquema de cores ------------------------------------

# O {thematic} é um novo pacote, lançado em 2021, para criar temas
# Nós ainda não estudamos esse pacote o suficiente para colocar em aula,
# Mas podemos trabalhar em uma live ou na aula extra.
#
# https://rstudio.github.io/thematic/articles/auto.html#rmd

library(bslib)
library(thematic)

bs_theme_preview(
  bs_theme(bg = "#444444", fg = "#E4E4E4", primary = "#E39777")
)



