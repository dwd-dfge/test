library(topicmodels)
library(magrittr)

setwd("C:/Users/dwiegand/Desktop/KI/NLP/Korpus/")

#### Import zweizeiliges PDF ####

import <- pdf_text("CSR_EN.pdf") %>%
  str_replace_all("  +", "\r\n") %>% #"+" = The preceding item will be matched one or more times. Ersetzen von mehr als zwei Leerzeichen durch "\r\n"
  strsplit("\r\n")

for (i in 1:length(import)) {
  import[[i]] <- str_squish(import[[i]])  #Entfernen von unnötigen Leerzeichen
}

text_df<-rownames_to_column(data_frame(import)) #Seitenzahlen als Spalte
text_df<-unnest(text_df)
colnames(text_df) <- c("pagenum", "text")

text_df %<>%
  mutate(odd = seq_len(nrow(text_df)) %% 2) %>%
  mutate(pagenum = as.numeric(pagenum)) %>%
  group_by(pagenum) %>%
  arrange(pagenum, odd) %>%
  ungroup()
