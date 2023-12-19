# Check list

- Web UI

[x] Sign in.
[x] Sign up.
[x] Upload a keyword file.
[x] View list of keywords.
[x] View the search result information for each keyword.
[x] Search across all reports.

- API

[x] Sign in.
[x] Get the list of keywords.
[x] Upload a keyword file.
[x] Get the search result information for each keyword.

- Requirements

[x] Authenticated users can upload a CSV file of keywords. This upload file can be in any size from 1 to 100 keywords.
[x] The uploaded file contains keywords, each of those keywords will be used to search on <http://www.google.com> and they will start to run as soon as they’re uploaded.
[x] For each search result/keyword result page on Google, you will store the following information on the first page of results: Total number of AdWords advertisers on the page, Total number of links (all of them) on the page, Total of search results for this keyword e.g. About 21,600,000 results (0.42 seconds), HTML code of the page/cache of the page.
[x] Allow users to view the list of their uploaded keywords. For each keyword, users can also view the search result information stored in the database.

- Tech

[x] Use Ruby on Rails (7.x.x).
[x] Use PostgreSQL.
[x] For the interface, front-end frameworks such as Bootstrap, Tailwind or Foundation can be used. Use SASS as the CSS preprocessor
[x] Use Git during the development process. Push to a public repository on Github or Gitlab.  Make regular commits and merge code using pull requests.
[x] Write tests using your framework of choice.

[ ] Deploy the application to a cloud provider e.g. Heroku, AWS, Google Cloud or Digital Ocean.
