# Running the website locally

```sh
docker run -it -v $(pwd):/srv/jekyll -p 3000:4000 jekyll/jekyll:3.5 jekyll serve
```

The website can then be accessed on http://localhost:3000