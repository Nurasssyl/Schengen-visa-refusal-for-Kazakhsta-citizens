# Установите и загрузите необходимые библиотеки
install.packages("tidyverse")
install.packages("sf")
install.packages("rnaturalearth")
install.packages("rnaturalearthdata")
install.packages("cowplot")

library(tidyverse)
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)
library(cowplot)

# Загрузка данных
data <- read.csv("C:/Users/User/Desktop/R/Schengen_Visa_all_Refusal_in_2023_.csv")

# Переименование колонок для удобства
colnames(data) <- c("country", "refusal_rate")

# Загрузка географических данных
world <- ne_countries(scale = "medium", returnclass = "sf")

# Фильтрация данных для стран Шенгена
schengen_countries <- c("Austria", "Belgium", "Czechia", "Denmark", "Estonia", "Finland", 
                        "France", "Germany", "Greece", "Hungary", "Iceland", "Italy", "Latvia",
                        "Lithuania", "Luxembourg", "Malta", "Netherlands", "Norway", "Poland",
                        "Portugal", "Slovakia", "Slovenia", "Spain", "Sweden", "Switzerland")

world_schengen <- world %>%
  filter(name %in% schengen_countries)

# Объединение географических данных с данными отказов
world_data <- left_join(world_schengen, data, by = c("name" = "country"))

# Создание карты
p <- ggplot(data = world_data) +
  geom_sf(aes(fill = refusal_rate)) +
  coord_sf(xlim = c(-25, 40), ylim = c(30, 75), expand = FALSE) +
  scale_fill_continuous(name = "Refusal Rate (%)", low = "yellow", high = "red", na.value = "grey50") +
  theme_minimal() +
  labs(title = "Schengen Visa Refusal Rates (Kazakhstan, 2023)") +
  theme(legend.title = element_text(size = 10), 
        legend.text = element_text(size = 8))

# Отображение карты
print(p)











# Загрузка данных
data <- read.csv("C:/Users/User/Desktop/R/Schengen_Visa_all_Refusal_in_2023_.csv")

# Переименование колонок для удобства
colnames(data) <- c("country", "refusal_rate")

# Проверка на наличие данных для Чехии
print(data)

# Загрузка географических данных
world <- ne_countries(scale = "medium", returnclass = "sf")

# Фильтрация данных для стран Шенгена
schengen_countries <- c("Austria", "Belgium", "Czechia", "Denmark", "Estonia", "Finland", 
                        "France", "Germany", "Greece", "Hungary", "Iceland", "Italy", "Latvia",
                        "Lithuania", "Luxembourg", "Malta", "Netherlands", "Norway", "Poland",
                        "Portugal", "Slovakia", "Slovenia", "Spain", "Sweden", "Switzerland")

world_schengen <- world %>%
  filter(name %in% schengen_countries)

# Исправление названия страны "Czech Republic" на "Czechia"
data$country <- recode(data$country, "Czech Republic" = "Czechia")

# Объединение географических данных с данными отказов
world_data <- left_join(world_schengen, data, by = c("name" = "country"))

# Проверка на наличие данных для Чехии после объединения
print(world_data %>% filter(name == "Czechia"))

# Создание карты
p <- ggplot(data = world_data) +
  geom_sf(aes(fill = refusal_rate)) +
  coord_sf(xlim = c(-25, 40), ylim = c(30, 75), expand = FALSE) +
  scale_fill_continuous(name = "Рейтинг отказов (%)", low = "yellow", high = "red", na.value = "grey50") +
  theme_minimal() +
  labs(title = "") +
  theme(legend.title = element_text(size = 10), 
        legend.text = element_text(size = 8))

# Отображение карты
print(p)


# Сохранение карты на рабочий стол
ggsave("C:/Users/User/Desktop/R/Schengen_Visa_Refusal_Rates_Map.png", plot = p, width = 10, height = 7)



# Создание карты с процентами отказов
p <- ggplot(data = world_data) +
  geom_sf(aes(fill = refusal_rate)) +
  coord_sf(xlim = c(-25, 40), ylim = c(30, 75), expand = FALSE) +
  scale_fill_continuous(name = "Процент отказов (%)", low = "yellow", high = "red", na.value = "grey50") +
  theme_minimal() +
  labs(title = "") +
  theme(legend.title = element_text(size = 10), 
        legend.text = element_text(size = 8))

p <- p + geom_text(data = world_data, aes(label = round(refusal_rate, 1), geometry = geometry), 
                   stat = "sf_coordinates", size = 3, color = "black")

# Отображение карты
print(p)

ggsave("C:/Users/User/Desktop/R/Schengen_Visa_Refusal_Rates_Map_percent.png", plot = p, width = 10, height = 7)


