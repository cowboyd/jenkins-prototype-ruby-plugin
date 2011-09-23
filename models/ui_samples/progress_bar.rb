module UISamples

  class ProgressBar < BaseAction
    description "Shows you how to use the progress bar widget that's used in the executor view and other places"
  end
end

Jenkins::Plugin.instance.register_extension(UISamples::ProgressBar)
