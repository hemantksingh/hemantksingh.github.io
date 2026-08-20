PORT ?= 4000

# Named Docker volume mounted over bundler's install dir (GEM_HOME) so gems
# persist between runs and `bundle install` is only slow the first time.
# Docker creates the volume automatically on first use; reset the cache with
# `docker volume rm hk_site_bundle`.
GEM_CACHE_VOLUME ?= hk_site_bundle

.DEFAULT_GOAL := serve

# Host and container ports must match: in development `jekyll serve` rewrites
# site.url to the local server address, and pages reference images via
# {{ site.url }} — a mismatched mapping makes the images 404.
.PHONY: serve
serve: colima
	docker run -it -v $(CURDIR):/site -w /site \
	  -v $(GEM_CACHE_VOLUME):/usr/local/bundle \
	  -p $(PORT):$(PORT) ruby:3.3 \
	  sh -c "bundle install && bundle exec jekyll serve --host 0.0.0.0 --port $(PORT) --force_polling"

.PHONY: colima
colima:
	@colima status >/dev/null 2>&1 || colima start
