## Reviews API
**Objective**: Create an API service that collects and returns reviews found from the website Feefo.

## Get Started
```bash
# access a terminal
# navigate to the application root
# ensure you have bundle installed

# install dependencies
bundle install

# run the service
rails s 

# rubocop
bundle exec rubocop

# rspec
bundle exec rspec
```

### Collect Reviews 
**Description**: Collects reviews from a provided `target_url` by parsing the reviews HTML content and fetching specified keys at the application level.
- http://127.0.0.1:3000/api/v1/reviews/collect

### Request
```json
{
  "target_url": "https://www.feefo.com/en-US/reviews/ashes-memorial-jewellery"
}
```

### Response
```json
{
    "url": "https://www.feefo.com/en-US/reviews/ashes-memorial-jewellery",
    "count": 10,
    "reviews": [
        {
            "author": "Anita Mann",
            "content": "Date of purchase: 03/27/2023",
            "location": "Milton Keynes",
            "purchase_date": "The service was brilliant. They sent me an envelope to put the ashes in and I sent it back to them recorded signed for and I got an email from them to say that they’d received the ashes. It took appro",
            "rating": 5,
            "review_date": "1 year ago"
        },
        {
            "author": "Jane Blake",
            "content": "Date of purchase: 01/16/2023",
            "location": null,
            "purchase_date": "Really lovely jewellery. I’m very pleased.",
            "rating": 5,
            "review_date": "2 years ago"
        },
        {
            "author": "Jane Blake",
            "content": "Date of purchase: 01/23/2023",
            "location": null,
            "purchase_date": "I really like my jewellery.",
            "rating": 5,
            "review_date": "2 years ago"
        },
        {
            "author": "Tracey Hick",
            "content": "Date of purchase: 01/03/2023",
            "location": null,
            "purchase_date": "Excellent service answered all emails very quickly item arrive before the date they said everything was wrapped so nothing would get broken and was secure very happy with my necklace will recommend to",
            "rating": 5,
            "review_date": "2 years ago"
        },
        {
            "author": "Rebecca Smith",
            "content": "Date of purchase: 12/01/2022",
            "location": null,
            "purchase_date": "The work is amazing",
            "rating": 5,
            "review_date": "2 years ago"
        },
        {
            "author": "Trusted Customer",
            "content": "Date of purchase: 11/05/2022",
            "location": null,
            "purchase_date": "Great service, especially as you are going through an emotional time. Ordering was easy and good contact throughout. Delivery was within the stated timeframe and the items we well made and packaged.",
            "rating": 5,
            "review_date": "2 years ago"
        },
        {
            "author": "Trusted Customer",
            "content": "Date of purchase: 11/08/2022",
            "location": null,
            "purchase_date": "First class service, very pleased with my purchase.",
            "rating": 5,
            "review_date": "2 years ago"
        },
        {
            "author": "Trusted Customer",
            "content": "Date of purchase: 11/07/2022",
            "location": null,
            "purchase_date": "The earrings are beautiful. The fingerprint is so clear.\nDefinitely recommend Ashes Memorial👍",
            "rating": 5,
            "review_date": "2 years ago"
        },
        {
            "author": "Ruth Harwood",
            "content": "Date of purchase: 11/05/2022",
            "location": null,
            "purchase_date": "I received the necklace from you\ntoday and I'm so happy with it. The\ntime and patience on the telephone\nexplaining things to me. When I\nreceived it it was so well packed\nand inside were clear detailed",
            "rating": 5,
            "review_date": "2 years ago"
        },
        {
            "author": "Nichola Wojtylo",
            "content": "Date of purchase: 10/06/2022",
            "location": null,
            "purchase_date": "Service was good snowflake is nice and key ring but on small side but it’s nice",
            "rating": 5,
            "review_date": "2 years ago"
        }
    ]
}
```