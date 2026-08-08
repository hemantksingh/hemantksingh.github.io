# Running the website locally

```sh
docker run -it -v $(pwd):/site -w /site -p 3000:4000 ruby:3.3 sh -c "bundle install && bundle exec jekyll serve --host 0.0.0.0"
```

The `Gemfile` pins the `github-pages` gem, so the local build uses the same Jekyll version and plugins (including `jekyll-seo-tag` and `jekyll-redirect-from`) as GitHub Pages.

The website can then be accessed on <http://localhost:3000>

## Domain configuration

The website uses a [custom domain configured on Github pages](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site). After setting up the A, AAAA and CNAME records on your DNS provider, you can confirm that the DNS records have been configured correctly using the `dig` command:

* For `A` records

  ```sh
  dig hemantkumar.net +noall +answer -t A
    ; <<>> DiG 9.10.6 <<>> hemantkumar.net +noall +answer -t A
    ;; global options: +cmd
    hemantkumar.net. 1799 IN A 185.199.108.153
    hemantkumar.net. 1799 IN A 185.199.109.153
    hemantkumar.net. 1799 IN A 185.199.111.153
    hemantkumar.net. 1799 IN A 185.199.110.153
  ```

* For `AAAA` records
  
  ```sh
  dig hemantkumar.net +noall +answer -t AAAA

    ; <<>> DiG 9.10.6 <<>> hemantkumar.net +noall +answer -t AAAA
    ;; global options: +cmd
    hemantkumar.net.	1799	IN	AAAA	2606:50c0:8000::153
    hemantkumar.net.	1799	IN	AAAA	2606:50c0:8003::153
    hemantkumar.net.	1799	IN	AAAA	2606:50c0:8001::153
    hemantkumar.net.	1799	IN	AAAA	2606:50c0:8002::153
  ```