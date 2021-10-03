# ShellFormance

## Introduction

The name ShellFormance comes from PowerShell and Performance.
This repo was created to find ways to optimize powershell code/scripts without going to lower level languages that is actually significantly faster.

Most of my work never really need the speed of C++ and can with ease use the CLI to do most of the work.
My interpretation of interpreted language is that it could endup as matryoshka dolls(doll in a doll in a doll...) and use loads of CPU on a something trivial matter.
It is more important how, what, why you need to write code in a certain way.

And the reason why i made a function/wrapper for measure-object command(not impossible to switch to something else), it looks more tidy, because i want it to be more repeatable AND to add more meta such as which PSVersion, PC/Mac/Linux as you want to know how code performs on these places as everyone is not using the best and latest, if that is the case per say.

## Contribute

Any contribution is welcome.
What is needed:
* Automate the runs.
* Add more tests for all kinds of stuff.
* Publish relevante results of the tests.
* Update functions to best practice and to what the results show.
* Linting.
* Add timeout feature to the test-function

## Secondary mission

Optimize the powershell code to find prime numbers at
[A Software Drag Race](https://github.com/PlummersSoftwareLLC/Primes)

## References, similar repos and sites

These focuses on similar objects and perhaps tell you how or why should code in specific ways.

* [Adam the Automator](https://adamtheautomator.com/powershell-speed/)
  General information, filter first, do what ever later
* [Performance](https://powershell.one/tricks/performance/pipeline)
   Extensive tests and shows what to do and not to do in certain situations. Mostly based on older .Net CRL i guess as lot of these things have changed.

## Discord

Powershell community discord that i'm active in: wcGvgQg4ZK
