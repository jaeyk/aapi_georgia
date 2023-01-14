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

1. ~~Plot the monthly publication patterns~~ (time series)

2. Discover the mostly frequently mentioned locations over time across the two corpora (time series)
