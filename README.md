ergoproxy
=========

Minimal Rack application that proxies client's request and caches server's response


Why I create
------

We usually access web API to get resource. But some API limited access rate because of server resource's limitation.

So I create this Rack application to proxy your request and cache server's response.


Setup
-------

```
bundle
```

and you need to describe cache configuration to `cache.yaml`. See the following.


Usage
------

When you want to get json of this README from Github api ( = `https://api.github.com/repos/hdemon/ergoproxy/contents/README.md`),

First, create `cache.yaml` with the following content

```yaml
"https://api.github.com:443":
  duration: 60 # second
```

and run this


```
$ rackup
$ curl -i "localhost:9292/?target_uri=https%3A%2F%2Fapi.github.com%2Frepos%2Fhdemon%2Fergoproxy%2Fcontents%2FREADME.md"
```

Github API's response will be cached 60 seconds.


TODO
------

- なんか改行コードが消える問題の解決
- Request Headerの"Host"を消したまま問題の解決
