module StyleGuide
  class Cpp < Base
    def violations_in_file(file)
      # TODO: cpplint in a gem is prefered
      cpplint_path = Rails.root.join('bin','cpplint-0.0.3','cpplint','cpplint.py')
      cpplint_output = exec "python #{cpplint_path} #{file}"
      # cpplint does not print violations in the last two lines
      cpplint_output.to_a[0..-2].each do |line|
        (file, line_number, [reason]) = line.split(':')
        Violation.new(file, line_number, reason.join(':'))
      end
    end
  end
end
