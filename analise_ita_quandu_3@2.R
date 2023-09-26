# packages ----------------------------------------------------------------------------------------------------------

# pacman::p_load(googledrive,
               lubridate,
               skimr,
               gridExtra,
               tidyverse,
               usethis)


# dados -------------------------------------------------------------------------------------------------------------

drive_auth()

ita_quandu = drive_get('https://drive.google.com/file/d/1DFM_ig0Uvl5eZvgapEbI-96hMttOeOnN/view?usp=drive_link') %>%
  drive_read_string() %>%
  read.csv(text = .)


# pre-processamento -------------------------------------------------------------------------------------------------

## Transformando variáveis numéricas
ita_quandu = ita_quandu |>
  mutate_at(c('direcao_do_vento_10m_graus', 'temperatura_do_ar_a_2m_c', 'umidade_relativa_do_ar_a_2m'), as.double)

## Criando a variável 'data_hora' com base em 'data' e 'hora_utc'
ita_quandu = ita_quandu |>
  mutate(data_hora = paste0(data, ' ', hora_utc), # juntando a coluna data e hora_utc
         data_hora = dmy_hms(data_hora), # transformando em um objeto de datetime
         data_hora = data_hora - hours(3)) # retirando 3 horas do fuso horário


# análise descritiva ------------------------------------------------------------------------------------------------

ita_quandu |> skim()


## análise gráfica --------------------------------------------------------------------------------------------------

p1 = ggplot(ita_quandu) +
  geom_line(aes(x=data_hora, y=precipitacao_pluviometrica_mm)) +
  labs(title='precipitacao_pluviometrica_mm')

p2 = ggplot(ita_quandu) +
  geom_line(aes(x=data_hora, y=pressao_atmosferica_h_pa)) +
  labs(title='pressao_atmosferica_h_pa')

p3 = ggplot(ita_quandu) +
  geom_line(aes(x=data_hora, y=radiacao_w_m)) +
  labs(title = 'radiacao_w_m')

p4 = ggplot(ita_quandu) +
  geom_line(aes(x=data_hora, y=velocidade_media_do_vento_10m_m_s)) +
  labs(title = 'velocidade_media_do_vento_10m_m_s')

p5 = ggplot(ita_quandu) +
  geom_line(aes(x=data_hora, y=direcao_do_vento_10m_graus)) +
  labs(title = 'direcao_do_vento_10m_graus')

p6 = ggplot(ita_quandu) +
  geom_line(aes(x=data_hora, y=temperatura_do_ar_a_2m_c)) +
  labs(title = 'temperatura_do_ar_a_2m_c')

p7 = ggplot(ita_quandu) +
  geom_line(aes(x=data_hora, y=umidade_relativa_do_ar_a_2m)) +
  labs(title = 'umidade_relativa_do_ar_a_2m')

grid.arrange(p1, p2, p3, p4, p5, p6, p7, ncol = 2)
