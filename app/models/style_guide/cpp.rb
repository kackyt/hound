require 'kconv'

module StyleGuide
  class Cpp < Base
  def violations(file)
    # TODO: cpplint in a gem is prefered
    cpplint_path = Rails.root.join('bin','cpplint.py')
    File.open('tmp.cpp', 'w') { |tmpfile| tmpfile.write file.content.toutf8 }
    cpplint_output = `python #{cpplint_path} tmp.cpp 2>&1`.split("\n")
    # cpplint does not print violations in the last two lines
    cpplint_output = cpplint_output[0..-3]
    cpplint_output.map do |line|
      (_, line_number, reason) = line.split(':',3)
      # mock model of RuboCop::Cop::Team#inspect_file
      OpenStruct.new(
        line: line_number.to_i,
        message: reason
      )
    end
  end
end
