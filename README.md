![](https://travis-ci.org/ajanauskas/pronto-tailor.svg?branch=master)

# Pronto::Tailor

[Pronto](https://github.com/mmozuras/pronto) runner for [Tailor](https://github.com/sleekbyte/tailor), Swift static analyser and lint tool.

Tailor is needed to be installed for this runner to work.

# Configuring runner

Runner can be configured by passing additional ENV variables e.g.

`PRONTO_TAILOR_EXCEPT_RULE=trailing-whitespace pronto run --index`

Availables ENV variables are:

* `PRONTO_TAILOR_EXCEPT_RULE` - for specifying `--except` tailor parameter
* `PRONTO_TAILOR_CONFIG_FILE` - for specifying `--config` tailor parameter
* `PRONTO_TAILOR_TAILOR_PATH` - for specifying `tailor` executable path. By default `tailor` is used

