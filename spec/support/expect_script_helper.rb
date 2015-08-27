class ScriptOutput < RSpec::Matchers::BuiltIn::Output
  def matches?(block)
    @block = block
    return false unless Proc === block
    @source = block.call
    @actual = @stream_capturer.capture lambda { run_example(@source) }
    raise "Script exited with status: #{$?.exitstatus}, output:\n#{@actual}" unless $?.success?
    @expected ? values_match?(@expected, @actual) : captured?
  end

  def failure_message
    "expected:\n#{indented_source}\nto #{description}, but #{positive_failure_reason}"
  end

  def failure_message_when_negated
    "expected:\n#{indented_source}\nto not #{description}, but #{negative_failure_reason}"
  end

  def indented_source
    indent = @source.split("\n").select {|line| !line.strip.empty? }.map {|line| line.index(/[^\s]/) }.compact.min || 0
    @source.gsub(/^[[:blank:]]{#{indent}}/, '  ')
  end

  def in_tmpdir(&block)
    Dir.mktmpdir('bootscale') { |dir| Dir.chdir(dir, &block) }
  end

  def run_example(code)
    in_tmpdir do
      files = code.split(/^ +# (.*\.rb)\n/)[1..-1].each_slice(2).to_a
      files.each do |file, code|
        FileUtils.mkdir_p(File.dirname(file))
        File.write(file, code)
      end
      system("ruby #{files.last.first} 2>&1")
    end
  end
end

module ExpectScriptHelper
  def echo(expected)
    ScriptOutput.new(expected).to_stdout_from_any_process
  end

  def in_tmpdir(&block)
    Dir.mktmpdir('bootscale') { |dir| Dir.chdir(dir, &block) }
  end
end

RSpec.configure do |c|
  c.include ExpectScriptHelper
end
