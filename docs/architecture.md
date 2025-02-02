# Architecture

### Docker Containerization

- **Purpose:**  
  Docker was chosen to ensure that there is consistency when navigating different environments by loading the application's architecture and dependencies inside of containers. This approach will simplify deployment and scaling while making it easier and more consistent for other engineers to build and run. 

### HTTP Web Server

- **Framework:**  
  [Kemal Web Framework](https://kemalcr.com/)

- **Reasons for Choosing Kemal:**
    - **Well-Maintained:** Regularly updated and maintained
    - **Documentation:** Well documented, includes guides, built using Crystal's ECR templating language. 
    - **Lightweight:** Not a bloated design. Built for performance 
    - **Routing:** Easy to use syntax for routing and middleware capability
    - **Websockets** Built in support that would come in handy in the future, removing the need to manually reload the page to see if changes to the chart are made. 
    - **Syntax** Pretty straightforward syntax and easy to integrate and get up and running.

### Web Scraper

[Lexbor](https://github.com/kostya/lexbor)
  - Chose because I wanted a html5 parser that came with CSS selectors. 
  - Been around for years and still maintained. 
  - decent documentation and guides in the README and `examples` directory

### SQLite Database

- **Design Decisions:**
    - **Schema Design:**  
      [View Schema](database_design.md)

### Frontend Interface

- **Technologies Used:**
    - **Tailwind CSS:** loaded with CDN for reliability.
    - **Tailwind Templates:** Free template component to accelerate frontend styling.
    - **Chart.js:** Integrated via CDN to render dynamic and interactive line graphs depicting the price trends.
    - **Javascript** Just native javascript to handle the button click and send a POST request to /scrape endpoint.

- **Note:**
    - Ideally I would have wanted to load these assets with `NPM` to manage package dependencies but time was a factor so CDN's seemed like the best approach.

### Migration and Data Handling

- **Migrations:**  
  Finding a reliable migration library that was compatible with the latest version of Crystal ended up being challenging. Most libraries that I found were either packaged in other web frameworks like Amber or weren't being actively maintened like birdie, migrate, or micrate. I ended up just writing some migration logic that creates a table, pulls any migration files from the `db/migrations` directory and will run them as long as they start with a numeric value and haven't been previously ran before. 

- **Database Driven Application:**  
  Instead of hardcoding values, the application relies on the database to manage which sites and products to scrape. This should allow for future UI components to be able to manage whether to scrape sites, which products to scrape, and the frequency in which to scrape the site. The database tables are represented by structs for data integrity by enforcing the correct data types on the properties. 

### Testing

- **Unit Tests** 
  [Crystal Spec Module](https://crystal-lang.org/reference/1.15/guides/testing.html)
  - Comes built into Crystal so didn't have to worry about another dependency management or adding anymore overhead to the application.
  - straight forward syntax with plenty of options and examples for testing values, exceptions, etc.  

---
