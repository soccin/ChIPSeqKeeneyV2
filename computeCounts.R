require(tidyverse)
require(fs)
require(openxlsx)

xx <- dir_ls("out___",regex="_Count.*") %>%
    map(read_tsv) %>%
    bind_rows(.id="File") %>%
    mutate(Sample=gsub(".*s_","",File) %>% gsub("___MD.*","",.)) %>%
    mutate(PREFIX=substr(Contig,1,3)) %>%
    mutate(Species=case_when(
                        PREFIX=="chr" ~ "S.cer",
                        PREFIX=="S.e" ~ "S.eub",
                        PREFIX=="Smi" ~ "S.mik",
                        T ~ "Unmapped"))

xy=xx %>% select(Sample,Species,Count)

xt=xy %>%
    group_by(Sample) %>%
    summarize(Total=sum(Count)) %>%
    gather(Species,Count,Total)

tbl <- bind_rows(xy,xt) %>%
    group_by(Sample,Species) %>%
    summarize(TC=sum(Count)) %>%
    spread(Species,TC)

projNo=grep("Proj",strsplit(getwd(),"/")[[1]],value=T)

write.xlsx(as.data.frame(tbl),cc(projNo,"_SpeciesCounts.xlsx"))
