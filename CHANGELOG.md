# Changelog

## v0.0.12 (2022-03-07)
- Add support for array fields

## v0.0.11 (2021-08-12)
- Update dependencies
- Allow custom error messages to be set on cast (#35)

## v0.0.10 (2021-02-25)
- (typo) attachements -> attachments (#24)
- Fix compile warning in Elixir 1.11 (#30)
- Move to GtiHub CI from CodeShip CI (#31)
- Use elixir v1.11 as base image


## v0.0.9 (2020-05-25)
  * add logo (#17)
  * follow all waffle minor version updates (#18)

## v0.0.8 (2020-03-16)
  * Fix typo (#14)
  * trim binary path and skip upload handling for empty values (#15)
  * add reference to help pages (#16)

## v0.0.7 (2020-02-04)
  * upgrade `waffle` to `v1.0.0`

## v0.0.6 (2020-02-03)
  * update dependencies

## v0.0.5 (2019-12-12)
  * add documentation for `cast_attachemets` (#11)

## v0.0.4 (2019-12-01)
  * add tutorial about using id within filepath (#10)
  * add credo (#8)

## v0.0.3 (2019-09-21)
  * Pass binary to `cast_attachments` (#7)

## v0.0.2 (2019-09-14)
  * Handle nil urls for skipped versions (#6)
  * Check for the new using block in Ecto 3.2 (#5)
  * update dependencies (#4)
  * add a development documentation (#3)
  * add CI integration (#2)

## v0.0.1 (2019-08-25)
  * Move project to a new repository and change name to `WaffleEcto`

## v0.11.2 (2019-05-18)
* (Dependency Relax) Require `ecto >= 2.1.0`
* (Enhancement) Add `allow_urls` as an an alternative to `allow_paths` for fetching remote files
* (Bugfix) updated_at timestamps now truncate to the second
* (Bugfix) Fix Dialyzer warning
* (Bugfix) Add missing Dialyzer type

## v0.11.1 (2018-11-18)
* (Dependency Update) Require `ecto ~> 2.1 or ~> 3.0`

## v0.11.0 (2018-10-04)
* (Dependency Update) Require `arc ~> 0.11.0`

## v0.10.0 (2018-06-19)
* (Dependency Update) Require `arc ~> 0.10.0`

## v0.9.0 (2018-06-19)
* (Dependency Update) Require `arc ~> 0.9.0`

## v0.8.0 (2018-05-10)
* (Enhancement) Use `NaiveDateTime` instead of `Ecto.DateTime`.
* (Dependency Update) Require `ecto ~> 2.1`

## v0.7.0 (2017-03-10)
* (Enhancement) Add `delete` override to the ArcEcto module.
* (Dependency Update) Require `arc ~> 0.8.0`

## v0.6.0 (2017-03-10)
* (Dependency Update) Require `arc ~> 0.7.0`

## v0.5.0 (2016-12-19)
* (Dependency Update) Require `arc ~> 0.6.0`
* (Behavior Change) Only allow casting a `%Plug.Upload{}` by default.  If you would like to cast local paths (take caution), you may pass in `allow_paths: true`.  Note: This should be used with caution, as there are security implications with uploading local paths from a user-submitted form.

Example:

```elixir
params = "/path/to/my/file.png"
cast_attachments(%User{}, params, ~w(avatar), allow_paths: true)
```

## v0.4.4 (2016-06-14)
* (Bugfix) Set column to `nil` when casting a `nil` avatar

## v0.4.3 (2016-06-14)
* Relax Ecto dependency to `~> 2.0`

## v0.4.2 (2016-06-14)
* (Bugfix) Don't add version timestamp to signed urls

## v0.4.1 (2016-04-25)
* (Enhancement) Allow database columns to be loaded without a timestamp. Useful for migrations from other image upload systems or formats.

## v0.4.0 (2016-04-25)
* (Enhancement) Upgrade to Ecto 2.0rc-3

Upgrade instructions from 0.3.x to 0.4.x:

1. ArcEcto follows Ecto in the renaming of `Model` to `Schema`.  In your definitions, wherever you had `use Arc.Ecto.Model`, replace with `use Arc.Ecto.Schema`
2. ArcEcto follows Ecto in the usage of a singular `params` hash to `cast_attachments` rather than a set of `optional` and `required` params.  ArcEcto encourages the usage of a `cast_attachments` call followed by a `validate_required`.


## v0.3.2
* (Bugfix) Relax Arc dependency to ~> 0.2 to support 0.3.0

## v0.3.1
* (Bugfix) Allow params objects with atom keys.

## v0.3.0
* (Dependency Update) Require v0.2.0 of arc.

## v0.2.0

* (Behavior Change) `arc_ecto` will now apply all `%Ecto.Changeset{}` changes within `cast_attachments` to the root model prior to passing the model to `arc` as a scope.

## v0.1.2

* (Bugfix) Support the `:empty` value for given params

## v0.1.1

* Relax `ecto` dependency to `>= 0.10.0` to support Ecto v1.0.0
