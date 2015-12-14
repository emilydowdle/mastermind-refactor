class Code
  def initialize
  end

  def generate(code=[])
    elements = ["R", "G", "B", "Y"]
    elements.count.times do
      code << elements.shuffle.sample
    end
    code
  end
end
