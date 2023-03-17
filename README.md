## 🐰 neo

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

Tool that relieves you of the burden of remembering long commands. Neo saves your commands to your system and makes them accessible to you.


## Getting Started 🚀

```sh
dart pub global activate neo
```

Or locally via:

```sh
dart pub global activate --source=path <path to this package>
```

## Usage

```sh
# list your saved commands
$ neo commands list

# select the command to exceute
$ neo commands select

# Show CLI version
$ neo --version

# Show usage help
$ neo --help
```

# Todo

- [ ] Add develop command that will listen to changes while developing a cli and automaticaly update the local path.
- [ ] Command Alias: Allow users to create an alias for a long command by giving it a shorter name. This can make it easier to remember and execute the command.
- [ ] Command History: Keep a history of executed commands and allow users to easily recall and execute them again.
- [ ] Command Templates: Allow users to save command templates that can be easily modified and executed. This can be useful for commands that require multiple arguments or options.
- [ ] Command Groups: Allow users to group related commands together so that they can be executed with a single command.
- [ ] Command Scheduler: Allow users to schedule commands to be executed at a later time or on a recurring basis.
- [ ] Command Export/Import: Allow users to export their saved commands to a file, and import them again later, or on another machine.
- [ ] Command Autocomplete: Provide autocomplete suggestions for saved commands, so that users can quickly and easily execute them without typing the full command.

[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
