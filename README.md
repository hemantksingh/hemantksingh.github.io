# Running the website locally

```sh
docker run -it -v $(pwd):/srv/jekyll -p 3000:4000 jekyll/jekyll:3.5 jekyll serve
```

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