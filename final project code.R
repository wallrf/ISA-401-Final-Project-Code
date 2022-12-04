library(tidyverse)

gdp = read_csv('gdp-per-capita-worldbank.csv')
diet = read_csv('number-calorie-diet-unaffordable (1).csv')
poverty = read_csv('total-population-in-extreme-poverty.csv')
population = read_csv('population.csv')
CPI = read_csv('WorldCPI.csv')
child_mortality = read_csv('the-decline-of-child-mortality-by-level-of-prosperity-endpoints.csv')
food_price = read_csv('food-prices.csv')
foodaid_received = read_csv('food-aid-received.csv')
food_supply = read_csv('daily-per-capita-caloric-supply.csv')

#transform data
CPI_final = pivot_longer(CPI, cols = 5:66, names_to = 'Year', values_drop_na = TRUE, values_to = 'CPI') 
colnames(CPI_final) = c('Entity', 'Code', 'Inflation', '', 'Year', 'CPI')

class(CPI_final$Year)
CPI_final$Year = as.double(CPI_final$Year)

?mutate
?as.double
#data joining to compare GDP, Extreme Poverty Tota
df = filter(left_join(x = gdp, y = poverty,
                      by = c('Entity', 'Code', 'Year')), total_number_of_people_below_poverty_line != 'NA' )
df2 = left_join(x = df, y= population,
                by = c('Entity', 'Code', 'Year'))
df3 = subset(left_join(x = df2, y = CPI_final,
                by = c('Entity', 'Code', 'Year')), select = -7:-8) %>%
  mutate(frct_ppl_below_poverty = total_number_of_people_below_poverty_line/`Population (historical estimates)`)



options(scipen = 999)



#food price and food aid
food_df = filter(left_join(x = food_supply, y = foodaid_received,
                    by = c('Entity', 'Code', 'Year')), `Developmental Food Aid (million 2016 USD)` != 'NA')

#write merged data to a csv for tableau

write.csv(df3,"M:/ISA 401/final project\\rcode.csv", row.names = FALSE)
write.csv(food_df, "M:/ISA 401/final project\\food_df.csv", row.names = FALSE)

##the other csvs loaded in r but not merged are still used in tableau by connecting all of it together in tableau
