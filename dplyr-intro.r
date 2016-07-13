## dplyr-intro.r

## install the dplyr package
install.packages('dplyr') # install the package, quotes; one-time-thing (but need to check for updates)
library(dplyr) # load the package with library(), quotes not needed

## the way Julie would normally write this:
library(dplyr) # install.packages('dplyr')
# need to load library every time you want to use it, if update needed then just remove the hashtag before intall function

## load gapminder data
## before we used read.csv(), but Jenny Bryan made the gapminder package 
library(gapminder) # install.packages('gapminder')

str(gapminder)

## filter()!
dplyr::filter(gapminder, lifeExp < 29) # dplyr:: indicates the package being used, not essential but useful for reproducibility
filter(gapminder, country == 'Mexico')
filter(gapminder, country %in% c('Mexico', 'Ecuador')) # %in% operator for matching multiple hits, if use == then misses some of the data

## the pipe operator '%>%', shortcut shift + command + M

#say 'gapminder, then the head of it'
gapminder %>% head() # equivalent to head (gapminder)
gapminder %>% head(10) # equivalent to head (gapminder, 10)

## dplyr::select()
select(gapminder, year, lifeExp) # this is the same as...
gapminder %>% select(year, lifeExp) # ...this. But here looks more intuitive, start with the data then what you want to do with it

## chaining!
## says 'gapminder data, then select those columns, then take head 4 columns'
gapminder %>% 
  select(year, lifeExp) %>% 
  head(4)

## select a few variable for Cambodia
gapminder %>% 
  filter(country =='Cambodia') %>% 
  select(country, year, pop, gdpPercap) # typed out 4/6 column headers

# more efficient?
gapminder %>% 
  filter(country =='Cambodia') %>% 
  select(-continent, -lifeExp) # say what you don't want

## compare how this would look in base R
gapminder[gapminder$country == 'Cambodia', c('country', 'year', 'pop', 'gdpPercap')]

## dplyr::mutate()
gapminder %>% 
  mutate(gdp = pop * gdpPercap) # calculate gdp

## add a gdp column to the Cambodia example.
# subset of Cambodia rows, subset of columns (-continent, -lifeExp), new column gdp
gapminder %>% 
  filter(country == 'Cambodia') %>%
  select(-continent, -lifeExp) %>% 
  mutate(gdp = pop * gdpPercap) %>% 
  select(country, year, gdp, pop, gdpPercap) # select can be used to change order of columns, mutate will always add new column to end of list

## calculate mean gdp for Cambodia
gapminder %>% 
  # filter(country == 'Cambodia') %>%
  select(-continent, -lifeExp) %>% 
  mutate(gdp = pop * gdpPercap) %>% 
  select(country, year, gdp, pop, gdpPercap) %>% 
  group_by(country) %>%
  summarise(mean_gdp = mean(gdp)) # use sumarise() along with group_by()

## remember our for loop through all countries?
new_variable <- gapminder %>% 
  # filter(country == 'Cambodia') %>%
  select(-continent, -lifeExp) %>% 
  mutate(gdp = pop * gdpPercap) %>% 
  select(country, year, gdp, pop, gdpPercap) %>% 
  group_by(country) %>%
  summarise(mean_gdp = mean(gdp)) %>% # use sumarise() along with group_by()
  ungroup() # save heartache later by ungrouping data - best practice

## find the maximum life expectancy for countries in Asia. 
# What is the earliest year in this subset?
# Hints base::max() dplyr::arrange()

gapminder %>% 
  filter(continent == 'Asia') %>%
  group_by(country) %>% 
  filter(lifeExp == max(lifeExp)) %>% # filter for the maximum lifeExp
  arrange(desc(year)) %>% # arrange for year
  ungroup() %>% 
  tail()

# Some extra text to see what happens
