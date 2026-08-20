# Running the website locally

## Prerequisites

* [Docker CLI](https://docs.docker.com/reference/cli/docker/) — used to run Jekyll in a container, so no local Ruby setup is needed. Only the client CLI is required (`brew install docker`); the daemon is provided by colima.
* [colima](https://github.com/abiosoft/colima) — a lightweight Linux VM that provides the Docker daemon on macOS (`brew install colima`), as a free alternative to Docker Desktop. Its docker context is selected automatically on first start.
* `make` — ships with the Xcode Command Line Tools on macOS.

## Serving the site

```sh
make            # or: make serve PORT=3000
```

The website can then be accessed on <http://localhost:4000> (or the port you chose).

The `serve` target starts colima if it isn't already running, then serves the site with Jekyll in a `ruby:3.3` container. Notes:

* The host and container ports must match. In development `jekyll serve` rewrites `site.url` to the local server address (`http://localhost:4000`), and the site references images via `{{ site.url }}` — with a mismatched mapping (e.g. `-p 3000:4000`) the pages load but the images 404. The Makefile keeps the two in sync via the `PORT` variable.
* The `hk_site_bundle` named Docker volume caches the installed gems, so `bundle install` is only slow on the first run.
* The `Gemfile` pins the `github-pages` gem, so the local build uses the same Jekyll version and plugins (including `jekyll-seo-tag` and `jekyll-redirect-from`) as GitHub Pages.
* The serve command includes `--force_polling` because file-watch events sometimes don't cross the macOS bind mount.

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