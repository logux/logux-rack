# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased

- Added Logux protocol 4 support (BREAKING).
- Changed Logux secret configuration parameter from `password` to `secret`.
- Changed Rack app root path from `/logux` to `/` to allow mounting on an arbitrary path.
- Removed `rest-client` gem dependency.
- Removed `sinatra` gem dependency.
- Removed `configurations` gem dependency.

## [0.1.0] - 2019-08-29

- Initial public release.
