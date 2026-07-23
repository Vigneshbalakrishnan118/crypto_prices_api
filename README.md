# Crypto Prices API

A Ruby on Rails API that periodically fetches cryptocurrency prices from the CoinGecko API, caches them, and serves the latest available price with fallback support.

---

## Features

- Fetch cryptocurrency prices from the CoinGecko API
- Background job updates prices every minute
- Returns cached/latest available price
- Falls back to the last known price when the external API is unavailable
- Supports multiple cryptocurrencies
- RESTful API
- Automated test suite using RSpec

---

## Technology Stack

- Ruby on Rails 8 (API mode)
- PostgreSQL
- Active Job
- Solid Queue
- Rails Cache
- Faraday
- RSpec
- FactoryBot
- WebMock

---

## API Endpoint

### Get Latest Price

```
GET /prices/:symbol
```

Example:

```
GET /prices/bitcoin
```

Successful Response

```json
{
  "symbol": "bitcoin",
  "price": 118532.23,
  "currency": "usd",
  "updated_at": "2026-07-22T15:00:00Z",
  "cached": true
}
```

Unsupported Cryptocurrency

```
404 Not Found
```

```json
{
  "error": "Unsupported cryptocurrency."
}
```

No Data Available

```
503 Service Unavailable
```

```json
{
  "error": "Price currently unavailable."
}
```

---

# Architecture

```
                    CoinGecko API
                           │
                           │
                    CoinGeckoClient
                           │
                           ▼
                  CryptoPriceFetcher
                           │
          ┌────────────────┴──────────────┐
          │                               │
          ▼                               ▼
    PostgreSQL Database             Rails Cache
          ▲                               │
          └──────────────┬────────────────┘
                         │
                PriceLookupService
                         │
                         ▼
                 PricesController
                         │
                         ▼
                     API Response
```

---

## Background Job

A scheduled Active Job fetches the latest prices every minute.

Responsibilities:

- Fetch latest prices
- Update database
- Refresh cache
- Continue processing remaining symbols if one API request fails

---

## Caching Strategy

The application first checks Rails Cache.

If the value exists:

- Return cached value.

Otherwise:

- Read from PostgreSQL.
- Repopulate the cache.
- Return the latest stored value.

This reduces database queries while ensuring data is still available if the cache expires.

---

## Fallback Strategy

If CoinGecko becomes unavailable:

- Existing database records are preserved.
- Cache continues serving the last known price.
- Users continue receiving the latest successful price.

If no historical data exists:

- API returns HTTP 503.

---

## Supported Cryptocurrencies

Currently supported:

- bitcoin
- ethereum
- solana
- dogecoin

These are configured through a constant and can easily be extended.

---

## Running the Project

Install dependencies

```bash
bundle install
```

Create database

```bash
rails db:create
rails db:migrate
```

Populate initial prices

```bash
rails runner "FetchCryptoPricesJob.perform_now"
```

Run server

```bash
rails server
```

---

## Running Tests

```
bundle exec rspec
```

The test suite covers:

- CoinGecko client
- Background job
- Price fetcher
- Cache lookup
- Request specs
- Fallback behaviour

---

# Design Decisions

### Why Active Job + Solid Queue?

Rails 8 ships with Solid Queue as the default background job framework.

For this assignment, using Solid Queue keeps the implementation lightweight while remaining production-ready without additional infrastructure.

---

### Why PostgreSQL?

The application only needs to persist the latest successful price for each cryptocurrency.

PostgreSQL provides reliable persistence and allows the API to continue serving data during external API outages.

---

### Why Rails Cache?

Caching reduces repeated database lookups while improving response time.

The database remains the source of truth.

---

### Why separate Service Objects?

Responsibilities are divided into dedicated services:

- CoinGeckoClient
- CryptoPriceFetcher
- PriceLookupService
- CryptoPriceCache

This keeps controllers thin and makes the application easier to test and maintain.

---

# Alternative Approaches Considered

## Sidekiq + Redis

Instead of Solid Queue, Sidekiq could be used.

Advantages:

- Higher throughput
- Mature ecosystem
- Better monitoring
- Retry mechanisms
- Widely adopted in production

Scheduling could be handled using **sidekiq-cron**.

---

## Redis Cache

Instead of Rails Memory Cache, Redis could be used.

Advantages:

- Shared cache across multiple application instances
- Survives application restarts
- Better scalability

---

## Historical Price Storage

Instead of storing only the latest price, each fetch could create a historical record.

Advantages:

- Price history
- Trend analysis
- Charts
- Analytics

For this assignment, storing only the latest successful price keeps the implementation simple and satisfies the requirements.

---

# Assumptions

- Prices are fetched in USD.
- Only predefined cryptocurrencies are supported.
- Background job executes every minute.
- Database stores only the latest successful price.
- Cache expiration is one minute.

---
