<!-- omit in toc -->
# Contributing to AU Core Tests

Thanks for taking the time to contribute! All kinds of contributions are welcome: bug reports, ideas, documentation and code.

## Code of Conduct

This project and everyone participating in it is governed by the [FHIR Frog Code of Conduct](https://gitlab.com/fhirfrog/au-core-tests/-/blob/main/CODE_OF_CONDUCT.md). By participating, you are expected to uphold it. Please report unacceptable behaviour to <joernguy.suess@csiro.au>.

## I have a question

Please read the [README](https://gitlab.com/fhirfrog/au-core-tests/-/blob/main/README.md) and search the existing [issues](https://gitlab.com/fhirfrog/au-core-tests/-/issues) first. If you still need help, open an issue and say what you tried, what you expected and what happened (operating system, tool versions, and the relevant output).

## Reporting bugs and suggesting enhancements

> Never report security issues, vulnerabilities or anything containing sensitive information in the public issue tracker. Send them by email to <joernguy.suess@csiro.au>.

Open an [issue](https://gitlab.com/fhirfrog/au-core-tests/-/issues/new) with the steps to reproduce (a reduced example is ideal), the behaviour you expected and the behaviour you got. For an enhancement, explain the use case and why it would help most users.

## Your first contribution

1. Fork the project and create a branch from `main`.
2. Make your change, with tests or documentation where it applies.
3. Open a merge request that describes what changed and why, and link the issue it closes (`Closes #123`).

Test IGs follow the conventions of the existing tests: please read a neighbouring test before adding one, and run it against a server before opening a merge request.

## Commit messages

We use [conventional commits](https://www.conventionalcommits.org/): `<type>(<scope>): <subject>` with the types `feat`, `fix`, `docs`, `style`, `refactor`, `test` and `chore`. Use the imperative mood, no trailing period, at most 72 characters in the subject line.

## Licence

This project is licensed under the Apache License 2.0 (see [LICENSE](https://gitlab.com/fhirfrog/au-core-tests/-/blob/main/LICENSE)). By contributing you agree that your contribution is licensed under the same terms.

More detail about how FHIR Frog projects work is in the [FHIR Frog contribution guide](https://gitlab.com/fhirfrog/fhir-frog/-/blob/main/CONTRIBUTING.md).
