JRuby Safe
=============

The JRuby safe is a clone of [jruby-sandbox](https://github.com/omghax/jruby-sandbox)

## Building

To build the JRuby extension, run `rake compile`. This will build the
`lib/sandbox/sandbox.jar` file, which `lib/sandbox.rb` loads.

## Testing

    bundle install --path vendor/bundle
    bundle exec rake spec

## Basic Usage

Sandbox gives you a self-contained JRuby interpreter in which to eval
code without polluting the host environment.

    >> require "sandbox"
    => true
    >> sand = Sandbox::Full.new
    => #<Sandbox::Full:0x46377e2a>
    >> sand.eval("x = 1 + 2") # we've defined x in the sandbox
    => 3
    >> sand.eval("x")
    => 3
    >> x # but it hasn't leaked out into the host interpreter
    NameError: undefined local variable or method `x' for #<Object:0x11cdc190>

There's also `Sandbox::Full#require`, which lets you invoke `Kernel#require`
directly for the sandbox, so you can load any trusted core libraries. Note that
this is a direct binding to `Kernel#require`, so it will only load ruby stdlib
libraries (i.e. no rubygems support yet).

## Sandbox::Safe usage

Sandbox::Safe exposes an `#activate!` method which will lock down the sandbox,
removing unsafe methods. Before calling `#activate!`, Sandbox::Safe is the same
as Sandbox::Full.

    >> require 'sandbox'
    => true
    >> sand = Sandbox.safe
    => #<Sandbox::Safe:0x17072b90>
    >> sand.eval %{`echo HELLO`}
    => "HELLO\n"
    >> sand.activate!
    >> sand.eval %{`echo HELLO`}
    Sandbox::SandboxException: NoMethodError: undefined method ``' for main:Object

Sandbox::Safe works by whitelisting methods to keep, and removing the rest.
Checkout sandbox.rb for which methods are kept.

Sandbox::Safe.activate! will also isolate the sandbox environment from the
filesystem using FakeFS.

     >> require 'sandbox'
     => true
     >> s = Sandbox.safe
     => #<Sandbox::Safe:0x3fdb8a73>
     >> s.eval('Dir["/"]')
     => ["/"]
     >> s.eval('Dir["/*"]')
     => ["/Applications", "/bin", "/cores", "/dev", etc.]
     > s.activate!
     >> s.eval('Dir["/*"]')
     => []
     > Dir['/*']
     => ["/Applications", "/bin", "/cores", "/dev", etc.]
