# Asian American Mobilization in Georgia

Authors: Jae Yeon Kim and Jen Wu

## Data collection

### AAAJ-Atlanta (Asian American Advancing Justice)

* The org built an email archive and shared it with me (as of Jan 13, 2023, the link seems not to be working any longer)
* I scraped these emails programmatically. 

## AAAF (Asian American Advocacy Fund)

* The org provided me a list of [eml](https://www.loc.gov/preservation/digital/formats/fdd/fdd000388.shtml#:~:text=EML%2C%20short%20for%20electronic%20mail,as%20some%20other%20email%20programs.) files, and I turned them into searchable PDFs using the [email to PDF converter](https://github.com/nickrussler/email-to-pdf-converter). (Note: this program requires Java installation.) 

```sh
for file in ~/aapi_georgia/raw_data/aaaf/newslettters/*.eml; 
do
  java -jar ./build/libs/emailconverter-2.5.3-all.jar "$file";
done
```

## Data analysis

1. Plot the monthly publication patterns (time series) (**Done**)

2. Discover the mostly frequently mentioned locations across the two corpora and over time (cross-sectional and overtime) (**Done**)

3. Discover the distribution of Asian American populations and votes in Georgia across counties (reference: [AAAJ-Atlanta and AAAF 2022 joint report](https://static1.squarespace.com/static/5f0cc12a064e9716d52e6052/t/62dff75d3738db631340742d/1658845029456/AAPI_Report_v4.pdf)) (**In progress**)

## Data dictionary 

### newsletter data 

- AAAJ - Atlanta (n = 78, missing text rate: 8%), 2018-2022
- AAAF (n = 1063, missing text rate: 37%), 2020-2022

### county frequency data 

county_freq.csv (12,551 * 6)
- `date` <date>: newsletter publication date (year-month-day).
- `subject` <chr>: newsletter subject 
- `source` <chr>: newsletter source. Either AAAJ-Atlanta/AAAF.
- `month` <S3: yearon>: newsletter publication year and month.
- `counties` <chr>: Georgia counties 
- `freq` <dbl>: the frequency in which a particualr Georgia country is mentioned in the newsletters 
