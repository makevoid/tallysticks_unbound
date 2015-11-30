coffeescript_options = {
  input: 'coffee',
  output: 'js',
  patterns: [%r{^coffee/(.+\.(?:coffee|coffee\.md|litcoffee))$}],
  bare: true
}

guard 'coffeescript', coffeescript_options do
  coffeescript_options[:patterns].each { |pattern| watch(pattern) }
end
