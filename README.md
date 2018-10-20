# Nginx redirect

This is a very simple nginx docker image that helps you redirecting HTTP requests to the `www` sub-domain.

**Rationale:**<br>
It is a common use case to have a project on a hypothetical `www.example.com`. 
What about requests going to  `example.com`?<br>
Of course you can configure your project to redirect requests to the `www` sub-domain...<br> 
What is this should happen only for the "production/live" environment and for "staging"? 
(as most likely is going to look something as `www-staging.example.com`).<br>
On staging having `staging.example.com` to redirect to `www-staging.example.com` could make no sense and will 
require a different rule.

Redirecting to `www` is not responsibility of "your" application and can be done outside of it. 
Here it comes useful `goetas/nginx-redirect`. 


## Usage

Basic example, using a docker-compose file:

```yaml
services:
    www_redirector:
      image: goetas/nginx-redirect:latest
```

An more sophisticated use case is when used in combination with [jwilder/nginx-proxy](https://github.com/jwilder/nginx-proxy):

```yaml
services:
    web:
      image: jwilder/nginx-proxy
      ports:
        - "80:80"
  
    myproject:
      image: myproject
      environment:
        VIRTUAL_HOST: www.example.com
         
    www_redirector:
      image: goetas/nginx-redirect:latest
      environment:
        VIRTUAL_HOST: example.com
```

In this example:
- `web`: is listening on the port 80 (is the only container exposed to the outside)
- `myproject`: is the image that holds the code for your project, 
   and does not need to be aware which is going to be the hostname where the "project" will be exposed.
   <br>_The proxy will forward to it requests that are directed to the `www.example.com` host (thanks to `VIRTUAL_HOST=www.example.com`)_
- `www_redirector`: redirects eventual requests from `http://example.com` to `http://www.example.com`
   <br>_The proxy will forward to it requests that are directed to the `example.com` host (thanks to `VIRTUAL_HOST=example.com`)_
   
   
## Configuration variables

Using environment variables is possible to customize the redirect-behaviour.
All the configurations are optional.

- `REDIRECT_CODE`: HTTP redirect code (the default is 301)
- `REDIRECT_SUBDOMAIN`: to which sub-domain redirect (the default is to prepend `www.` to the original hostname)

## Other info

The project supports properly HTTPS redirects and respects the `X-Forwarded-Proto` and `X-Forwarded-Port` headers.
