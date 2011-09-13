# A prototype Ruby plugin

There is no Java, only Ruby.

This is a sample ground for what a *pure* ruby Jenkins plugin would look like on its own. It is different
than the jenkins-ruby-plugins-playground in that it is not "embedded" inside a vanilla Java plugin. It has
its own structure that is completely independent.

Inside this plugin are several extension points.

# Running

1. use JRuby
1. `bundle`
1. `rake server`

# Extensions

## Logging Wrapper
 [`LoggingWrapper`](https://github.com/cowboyd/jenkins-prototype-ruby-plugin/blob/master/models/logging_wrapper.rb).

This is a trivial `BuildWrapper` that outputs a message to the console whenever a build starts and when it finishes.

## TestRootAction

 [`TestRootAction`](https://github.com/cowboyd/jenkins-prototype-ruby-plugin/blob/master/models/root_action.rb) demonstrates adding links to the main sidebar.

## ModelReloadAction

 ['ModelReloadAction'](https://github.com/cowboyd/jenkins-prototype-ruby-plugin/blob/master/models/root_action.rb#L50)

 reloads all of the Ruby classes in the plugin. Very useful for development!

## DirectoryListingAction

 https://github.com/cowboyd/jenkins-prototype-ruby-plugin/blob/master/models/root_action.rb#L72

 list the contents of the ruby plugin

