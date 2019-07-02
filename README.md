# nslookupot

nslookupot is CLI that is `nslookup` over TLS.


## Usage

```bash
$ ruby bin/nslookupot.rb --help
Usage: nslookupot [options] name
    -s, --server VALUE               the name server IP address        (default 1.1.1.1)
    -p, --port VALUE                 the name server port number       (default 853)
    -h, --hostname VALUE             the name server hostname          (default cloudflare-dns.com)
    -t, --type VALUE                 the type of the information query (default A)
```

You can run it the following:

```bash
$ ruby bin/nslookupot.rb example.com
Address:        1.1.1.1#853
--
Name:           example.com
Address:        93.184.216.34
Ttl:            2860

```

If you need to resolve other than A type, you can run it the following:

```bash
$ ruby bin/nslookupot.rb --type=cname www.youtube.com
Address:        1.1.1.1#853
--
Name:           www.youtube.com
Name:           youtube-ui.l.google.com
Ttl:            1358

```

If you need to query to 8.8.8.8, you can run it the following:

```bash
$ ruby bin/nslookupot.rb --server=8.8.8.8 --port=853 --hostname=dns.google www.google.com
Address:        8.8.8.8#853
--
Name:           www.google.com
Address:        172.217.24.132
Ttl:            223

```

If you need to query to 9.9.9.9, you can run it the following:

```bash
$ ruby bin/nslookupot.rb --server=9.9.9.9 --port=853 --hostname=quad9.net www.quad9.net
Address:        9.9.9.9#853
--
Name:           www.quad9.net
Address:        216.21.3.77
Ttl:            1200

```


## License

The CLI is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
