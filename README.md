# nslookupot

[![Gem Version](https://badge.fury.io/rb/nslookupot.svg)](https://badge.fury.io/rb/nslookupot)
[![CI](https://github.com/thekuwayama/nslookupot/workflows/CI/badge.svg)](https://github.com/thekuwayama/nslookupot/actions?workflow=CI)
[![Maintainability](https://api.codeclimate.com/v1/badges/5df9157757f5a0bf1623/maintainability)](https://codeclimate.com/github/thekuwayama/nslookupot/maintainability)

nslookupot is CLI that is `nslookup` over TLS (version 1.2).


## Installation

The gem is available at [rubygems.org](https://rubygems.org/gems/nslookupot). You can install with:

```bash
$ gem install nslookupot
```


## Usage

```bash
$ nslookupot --help
Usage: nslookupot [options] name
    -s, --server VALUE               the name server IP address        (default 1.1.1.1)
    -p, --port VALUE                 the name server port number       (default 853)
    -h, --hostname VALUE             the name server hostname          (default cloudflare-dns.com)
    -t, --type VALUE                 the type of the information query (default A)
```

You can run it the following:

```bash
$ nslookupot example.com
Address:        1.1.1.1#853
--
Name:           example.com
Address:        93.184.216.34
Ttl:            2860

```

If you need to resolve other than A type, you can run it the following:

```bash
$ nslookupot --type=cname www.youtube.com
Address:        1.1.1.1#853
--
Name:           www.youtube.com
Name:           youtube-ui.l.google.com
Ttl:            1358

```

If you need to query to `8.8.8.8`, you can run it the following:

```bash
$ nslookupot --server=8.8.8.8 --port=853 --hostname=dns.google www.google.com
Address:        8.8.8.8#853
--
Name:           www.google.com
Address:        172.217.24.132
Ttl:            223

```

If you need to query to `9.9.9.9`, you can run it the following:

```bash
$ nslookupot --server=9.9.9.9 --port=853 --hostname=quad9.net www.quad9.net
Address:        9.9.9.9#853
--
Name:           www.quad9.net
Address:        216.21.3.77
Ttl:            1200

```


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
