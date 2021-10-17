# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2021-10-10 (pre-release)

- Support Logux protocol 4 (BREAKING).
- Change Logux secret configuration parameter from `password` to `secret`.
- Change Rack app root path from `/logux` to `/` to allow mounting on an arbitrary path.
- Remove `rest-client` gem dependency.
- Remove `sinatra` gem dependency.
- Remove `configurations` gem dependency.

## [0.1.0] - 2019-08-29

- Initial public release.
