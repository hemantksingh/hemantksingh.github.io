# Running the website locally

```sh
docker run --rm \
    --volume="$PWD:/srv/jekyll" \
    -p 3000:4000 \
    -it jekyll/jekyll:3.5 jekyll serve
```

The website can then be accessed on http://localhost:3000