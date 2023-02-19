# nslookupot

[![Gem Version](https://badge.fury.io/rb/nslookupot.svg)](https://badge.fury.io/rb/nslookupot)
[![CI](https://github.com/thekuwayama/nslookupot/workflows/CI/badge.svg)](https://github.com/thekuwayama/nslookupot/actions?workflow=CI)
[![Maintainability](https://api.codeclimate.com/v1/badges/5df9157757f5a0bf1623/maintainability)](https://codeclimate.com/github/thekuwayama/nslookupot/maintainability)

nslookupot is CLI that is `nslookup` over TLS (version 1.3 or 1.2).

- https://datatracker.ietf.org/doc/html/rfc7858


## Installation

The gem is available at [rubygems.org](https://rubygems.org/gems/nslookupot). You can install with:

```sh-session
$ gem install nslookupot
```


## Usage

```sh-session
$ nslookupot --help
Usage: nslookupot [options] name
    -s, --server VALUE               the name server IP address        (default 1.1.1.1)
    -p, --port VALUE                 the name server port number       (default 853)
    -h, --hostname VALUE             the name server hostname          (default cloudflare-dns.com)
    -n, --no-check-sni               no check SNI                      (default false)
    -t, --type VALUE                 the type of the information query (default A)
        --types                      print the list of query types
```

You can run it the following:

```sh-session
$ nslookupot example.com
Server:         1.1.1.1
Address:        1.1.1.1#853

Name:           example.com
Address:        93.184.216.34
Ttl:            83289

```

If you need to resolve other than A type, you can run it the following:

```sh-session
$ nslookupot --type=cname www.youtube.com
Server:         1.1.1.1
Address:        1.1.1.1#853

Name:           www.youtube.com
Name:           youtube-ui.l.google.com
Ttl:            86400

```

If you need to query to `8.8.8.8`, you can run it the following:

```sh-session
$ nslookupot --server=8.8.8.8 --port=853 --hostname=dns.google www.google.com
Server:         8.8.8.8
Address:        8.8.8.8#853

Name:           www.google.com
Address:        142.250.196.132
Ttl:            175

```

If you need to query to `9.9.9.9`, you can run it the following:

```sh-session
$ nslookupot --server=9.9.9.9 --port=853 --hostname=quad9.net www.quad9.net
Server:         9.9.9.9
Address:        9.9.9.9#853

Name:           www.quad9.net
Address:        216.21.3.77
Ttl:            100

```

Supported query types are:

```sh-session
$ nslookupot --types
** A, AAAA, CAA, CNAME, HINFO, HTTPS, LOC, MINFO, MX, NS, PTR, SOA, SRV, SVCB, TXT, WKS
```


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
