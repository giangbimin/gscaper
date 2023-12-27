# Project Checklist

## Web UI

- **Authentication:**
  - [x] Sign in.
  - [x] Sign up.

- **Keyword Management:**
  - [x] Upload a keyword file.
  - [x] View list of keywords.
  - [x] View the search result information for each keyword.
  - [x] Search across all reports.

## API

- **Authentication:**
  - [x] Sign in.

- **Keyword Operations:**
  - [x] Get the list of keywords.
  - [x] Upload a keyword file.
  - [x] Get the search result information for each keyword.

## Requirements

- **User Actions:**
  - [x] Authenticated users can upload a CSV file of keywords. The file can contain 1 to 100 keywords.
  - [x] The uploaded keywords initiate searches on [Google](http://www.google.com) automatically.

- **Data Storage:**
  - [x] Store information for each search result/keyword page on Google:
    - Total number of AdWords advertisers.
    - Total number of links on the page.
    - Total search results for the keyword (e.g., About 21,600,000 results in 0.42 seconds).
    - HTML code of the page/cache.

- **User Interface:**
  - [x] Allow users to view the list of their uploaded keywords.
  - [x] Provide detailed search result information for each keyword stored in the database.

## Tech Stack

- **Frameworks:**
  - [x] Use Ruby on Rails (7.x.x).
  - [x] Utilize front-end frameworks such as Bootstrap, Tailwind, or Foundation.
  - [x] Use SASS as the CSS preprocessor.

- **Database:**
  - [x] Use PostgreSQL.

- **Version Control:**
  - [x] Use Git during the development process.
  - [x] Push to a public repository on Github or Gitlab.
  - [x] Make regular commits and merge code using pull requests.

- **Testing:**
  - [x] Write tests using your framework of choice.

- **Deployment:**
  - [ ] Deploy the application to a cloud provider (e.g., Heroku, AWS, Google Cloud, or Digital Ocean).

Note: The checklist indicates the completion status of each task. Update the checklist as tasks are completed, and consider deploying the application to a cloud provider for production use.

## Feedback

- **Refresh token**

  - [x] endpoint POST api/refresh
  - [x] endpoint POST api/sign_out
  - [x] expired time of jwt: 15 mins
  - [x] expired time of refresh token: 7 days
  - [x] add refresh token to api/login response and cover with payload: data: {}
  - [x] add block jwt with sign_out or block request from jwt

- **Update Keyword Logic**
  - [x] Refactor using Form Object and Validator object
  - [x] Change Logic Keywords for user can create same keyword for difference orders
  - [x] Remove old models and useless codes
  - [x] Do not Check unique for keywords
  - [x] Update Test Cases

- **Json format and Source Code Organization**
  - [x] add Json Format Standard
  - [x] Source Code Organization Refactor
  - [x] Follow Design Pattern for Services
  - [x] Improve testing data definition
  - [ ] create api documentation
