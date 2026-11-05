# Robot Framework API Automation

![API Tests](https://github.com/rudrasurti/Robot-Framework-API-Automation/actions/workflows/robot-tests.yml/badge.svg)

A clean, keyword-driven **API test automation framework** built with **Robot Framework** and **RequestsLibrary**, tested against the public [Restful-booker](https://restful-booker.herokuapp.com/apidoc/index.html) API.

It shows the approach I describe in my article [How I Automate API Testing with Robot Framework and Claude AI](https://medium.com/@rudrasurti98/how-i-automate-api-testing-with-robot-framework-and-claude-ai-e1a0d637836c): reusable keywords, layered test coverage and CI/CD on every push.

## What's covered

| Suite | Tests |
|---|---|
| `auth.robot` | Valid login returns a token · invalid credentials are rejected |
| `booking_crud.robot` | Health check · create · read · list · filter · full update (PUT) · partial update (PATCH) · delete |
| `booking_negative.robot` | Unknown id → 404 · missing fields · update/delete without token or with an invalid token → 403 |
| `booking_contract.robot` | Contract tests: responses validated against JSON Schemas in `schemas/` |
| `booking_data_driven.robot` | Data-driven template: 5 booking variations (zero/large price, no deposit, Unicode names) |

Tests are tagged `smoke`, `positive`, `negative`, `security`, `contract` and `data-driven`, so you can run any slice.

## Project structure

```
.
├── schemas/                        # JSON Schemas for contract tests
├── resources/
│   ├── variables.resource          # base URL, credentials, test data
│   └── booking_keywords.resource   # reusable keywords (session, auth, create, verify)
├── tests/
│   ├── auth.robot
│   ├── booking_crud.robot
│   ├── booking_negative.robot
│   ├── booking_contract.robot
│   └── booking_data_driven.robot
├── .github/workflows/robot-tests.yml   # CI: runs on every push + weekly
└── requirements.txt
```

## Run locally

```bash
pip install -r requirements.txt

# all tests
robot --outputdir results tests/

# only smoke tests
robot --outputdir results --include smoke tests/

# only security tests
robot --outputdir results --include security tests/
```

Open `results/report.html` for the full report.

## CI/CD

GitHub Actions runs the whole suite on every push, on pull requests, weekly, and on demand. The Robot Framework HTML report and log are uploaded as a build artifact for every run.

## Design choices

- **Keyword-driven:** tests read like plain English, so anyone on the team can review them
- **Reusable keywords:** `Get Auth Token`, `Build Booking Body`, `Create Booking`, `Booking Should Match`
- **Independent tests:** every test creates its own data, so tests can run in any order
- **Full assertions:** every response field is checked, not just the status code
- **Contract testing:** JSON Schema validation catches API contract drift early

---

**Rudra Surti** · Senior SDET · [LinkedIn](https://www.linkedin.com/in/rudra-surti/) · [Medium](https://medium.com/@rudrasurti98)
