guard 'rspec', :cli => "--color --fail-fast" do
  watch(%r{^spec/comprise/.+_spec\.rb$})
  watch(%r{^lib/comprise/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
end
