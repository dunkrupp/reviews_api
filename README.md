**Objective**: Create an API service that collects and returns reviews found from the website Feefo.

**Requirements**:  
- Please write the project in Ruby.
- The service should output JSON
- The project and steps below should use this website: https://www.feefo.com
- API service should accept inbound requests that contain a target Feefo URL to collect reviews from (examples below)
- The service should collect all 'reviews' from the target URL
- The service should provide a response with the found reviews, containing the following: the content of review, author, star rating, date of review, and any other info you think would be relevant
- The service should handle errors and bad requests
- Write tests for your API service
- Storing reviews for future retrieval is not necessary

A few example target Feefo URLs:
- https://www.feefo.com/en-US/reviews/ashes-memorial-jewellery
- https://www.feefo.com/en-GB/reviews/online-motor-group-ltd
- https://www.feefo.com/en-us/reviews/aos-online-llp