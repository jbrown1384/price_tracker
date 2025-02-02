# Resources

## Crystal Language

- I wanted to first get a handle on Crystal's basic syntax and getting started guide, installation, and how projects and dependencies are typically managed.

### Getting Started Guides
  - Went through the basic guide and kept the API documentation saved for reference throughout development. 
    - [Crystal Basics Tutorial](https://crystal-lang.org/reference/1.15/tutorials/basics/index.html)
    - [Crystal API Documentation](https://crystal-lang.org/api/1.15.0/)

### Dependency Management
Crystal uses [Shards](https://crystal-lang.org/reference/1.15/shards/) for dependency management. 

### Key Libraries and Tools
- While I was reading through the shards documentation it recommended a github repo for popular crystal libraries [Awesome Crystal](https://github.com/veelenga/awesome-crystal).
- This was helpful in seeing what was out there but I went through a few of the libraries to see how the code and modules were structured.

## Postman
I used postman to make sure that I could retrieve the html that I wanted and to see if there was any headers / params that I needed to include that would make scraping challenging. I also kept the return as a reference for when I needed to parse the html so I didn't have to continue to hit the endpoint and parse it in the application. 

#### HTTP Client
I used Crystal's built in HTTP client documentation as a reference and integrated it into the interface of the scraper so It can be reused by any future site scrapers. 
- [Crystal HTTP Client Documentation](https://crystal-lang.org/api/1.15.0/HTTP/Client.html)

## HTML Parser

### Challenges and Solutions
Initially, Crystal's built-in XML parser was considered but wasn't very intuitive and I wanted a libary that came with CSS selectors. Looking for the best option of CSS parser libraries led to discovering `myhtml` but had become deprecated. 

#### Lexbor
Lexbor emerged as a successor to myhtml. It's an HTML5 parser with CSS selectors. 
- [Lexbor GitHub Repository](https://github.com/kostya/lexbor)
- [Lexbor README](https://github.com/kostya/lexbor/blob/master/README.md)

## Kemal

#### References
- **API Routes**: [Kemal Routes Guide](https://kemalcr.com/guide/#routes)
- **Templating**: [Kemal Templating Guide](https://kemalcr.com/guide/#views-templates)

### Comparison with Other Frameworks
Other frameworks that were considered were **Amber** and **Lucky**. Kemal was selected based on its performance, ease of use, templating with ECR, and easy integration. 

#### Installation
Dependencies are managed using Shards. To include Kemal in your project, add the following to your `shard.yml`:

```yaml
dependencies:
  kemal:
    github: kemalcr/kemal
```

#### ECR (Embedded Crystal Renderer)
Kemal's templating and views allowed for integration with Crystal's ECR for passing crystal data directly to the view. 
- [Crystal ECR Documentation](https://crystal-lang.org/api/master/ECR.html)

#### Testing
Decided to use Crystal's built in Spec module for unit testing the application. 
- [Crystal Testing Guide](https://crystal-lang.org/reference/1.15/guides/testing.html)

#### Database
Throughout development I made reference of crystal's Database Query Methods.
- My application's commonly used [Crystal DB Query Methods](https://crystal-lang.github.io/crystal-db/api/0.4.0/DB/QueryMethods.html)
  - `query`
  - `exec`
  - `query_one`
---
