# NumbersD


Table of Contents
-----------------

* [Introduction](#introduction)
* [Compatibility](#compatibility)
* [Install](#install)
* [Running](#running)
    - [Available Flags](#available-flags)
    - [Flag Types](#flag-types)
* [Contribute](#contribute)
* [Licence](#licence)


## Introduction

> TODO


## Compatibility

> TODO


## Install

At present, it is assumed the user knows some of the Haskell eco system and
in particular wrangling cabal-dev to obtain dependencies. I plan to offer pre-built binaries for x86_64 OSX and Linux in future.

You will need reasonably new versions of GHC and the Haskell Platform which
you can obtain [here](http://www.haskell.org/platform/), then run `make install` in the root directory to compile numbersd.


## Running

After a successful compile, the `./numbersd` symlink should be pointing to the built binary.


### Available Flags

Command line flags are used to configure numbersd, below is a table containing
the available settings and which statsd configuration keys they pertain to:

<table width="100%">

  <tr>
    <th>Flag</th>
    <th>Default</th>
    <th>Format</th>
    <th>About</th>
    <th>Statsd Equivalent</th>
  </tr>

  <tr>
    <td><code>--listeners</code></td>
    <td><code>udp://0.0.0.0:8125</code></td>
    <td><code>URI,....</code></td>
    <td>Incoming stats UDP address and port</td>
    <td><code>address</code>, <code>port</code></td>
  </tr>

  <tr>
    <td><code>--http</code></td>
    <td></td>
    <td><code>PORT</code></td>
    <td>HTTP port to serve the overview and time series on</code></td>
    <td><code>mgmt_address</code>, <code>mgmt_port</code></td>
  </tr>

  <tr>
    <td><code>--resolution</code></td>
    <td><code>60</code></td>
    <td><code>INT</code></td>
    <td>Resolution in seconds for time series data</code></td>
    <td></td>
  </tr>

  <tr>
    <td><code>--interval</code></td>
    <td><code>10</code></td>
    <td><code>INT</code></td>
    <td>Interval in seconds between key flushes to subscribed sinks</td>
    <td><code>flushInterval</code></td>
  </tr>

  <tr>
    <td><code>--percentiles</code></td>
    <td><code>90</code></td>
    <td><code>INT,...</code></td>
    <td>Calculate the Nth percentile(s) for timers</td>
    <td><code>percentThreshold</code></td>
  </tr>

  <tr>
    <td><code>--events</code></td>
    <td></td>
    <td><code>EVENT,...</code></td>
    <td>Combination of receive, invalid, parse, or flush events to log</td>
    <td><code>debug</code>, <code>dumpMessages</code></td>
  </tr>

  <tr>
    <td><code>--prefix</code></td>
    <td></td>
    <td><code>STR</code></td>
    <td>Prepended to keys in the http interfaces and graphite</td>
    <td><code>log</code></td>
  </tr>

  <tr>
    <td><code>--graphites</code></td>
    <td></td>
    <td><code>URI,...</code></td>
    <td>Graphite hosts to deliver metrics to</td>
    <td><code>graphiteHost</code>, <code>graphitePort</code></td>
  </tr>

  <tr>
    <td><code>--broadcasts</code></td>
    <td></td>
    <td><code>URI,...</code></td>
    <td>Hosts to broadcast raw, unaggregated packets to</td>
    <td><code>repeater</code></td>
  </tr>

  <tr>
    <td><code>--downstreams</code></td>
    <td></td>
    <td><code>URI,...</code></td>
    <td>Hosts to forward aggregated, statsd formatted counters to</td>
    <td><code>statsd-backend</code></td>
  </tr>

</table>


### Flag Types

* `URI` Combination of scheme, host, and port. The scheme must be one of `(tcp|udp)`.
* `PORT` Port number. Must be within the valid bindable range for non-root users.
* `INT` A valid Haskell [Int](http://www.haskell.org/ghc/docs/latest/html/libraries/base/Prelude.html#t:Int) type.
* `STR` An ASCII encoded string.
* `EVENT` Internal event types must be one of `(receive|invalid|parse|flush)`.
* `[...]` All list types are specified a comma seperated string containing no spaces. For example: `--listeners udp://0.0.0.0:8125,tcp://0.0.0.0:8126` is a valid `[URI]` list.


## Contribute

For any problems, comments or feedback please create an issue [here on GitHub](github.com/brendanhay/numbersd/issues).


## Licence

NumbersD is released under the [Mozilla Public License Version 2.0](http://www.mozilla.org/MPL/)
