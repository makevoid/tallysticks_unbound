coffeescript_options = {
  input: 'coffee',
  output: 'js',
}

guard 'coffeescript', coffeescript_options do
  coffeescript_options[:patterns].each { |pattern| watch(pattern) }
end
