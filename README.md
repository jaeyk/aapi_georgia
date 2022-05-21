# aapi_georgia

## AAAJ 

web scraping 

## AAAF 

pdf parsing 

Step 1. I batch converted EML files to searchable PDFs using the [email to PDF converter](https://github.com/nickrussler/email-to-pdf-converter). (Note: this program requires Java installation.) 

```sh
for file in ~/aapi_georgia/raw_data/aaaf/newslettters/*.eml; 
do
  java -jar ./build/libs/emailconverter-2.5.3-all.jar "$file";
done
```