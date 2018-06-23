library(rgdal)
library(rgeos)
library(sf)
library(tidyverse)
library(tidyr)

empredimiento<-read.csv("data/Ecosistema-emprendimiento.csv")


comunas<-st_read("data/comunas_latlog.shp")

comunas<-comunas %>%
    left_join(empredimiento, by =c("comuna"="Comuna") ) %>%
    replace_na(list(Emprendimientos = 0))

mapTheme <- function() {
    theme_void() + 
        theme(
            text = element_text(size = 8),
            panel.grid.major = element_line(colour = "grey80"),
            # plot.title = element_text(size = 11, color = "#1c5074", hjust = 0, vjust = 2, face = "bold"), 
            # plot.subtitle = element_text(size = 8, color = "#3474A2", hjust = 0, vjust = 0),
            # axis.ticks = element_blank(),
            axis.text = element_text(colour = "grey50"),
            legend.direction = "vertical", 
            legend.position = "right",
            plot.margin = margin(1, 1, 1, 1, 'cm'),
            legend.key.height = unit(0.5, "cm"), legend.key.width = unit(0.5, "cm")
        ) 
}

p<-ggplot(comunas) +
    geom_sf(aes(fill = cut_number(Emprendimientos, 5)),color ="grey80")+
     scale_fill_brewer("Número de\nemprendimientos ", palette = "OrRd")+
    mapTheme()+
    ggtitle("Cantidad de emprendimientos culturales por comuna en Santiago de Cali")
    # theme_bw()+
    # theme(line = element_line(color = "grey80"))

ggsave(p,filename = "mapa-emprendimiento.svg",device = "svg")
