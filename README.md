ergoproxy
=========

Minimal Rack Application that proxies client's request and caches server's response


Setup
-------

```
bundle
```

and create cache.yaml with the following content

```yaml
"https://api.github.com:443":
  duration: 60
```

Usage
------

When you want to get json of this README from github api,

```
$ rackup
$ curl -i "localhost:9292/?target_uri=https%3A%2F%2Fapi.github.com%2Frepos%2Fhdemon%2Fmy-site%2Fcontents%2FREADME.md"
```

Usually, github API limits access rate. But by accessing API through this Rack app, this app proxies your request and cache API's response.

Cache duration is configured by cache.yaml.


TODO
------

- なんか改行コードが消える問題の解決
- Request Headerの"Host"を消したまま問題の解決
