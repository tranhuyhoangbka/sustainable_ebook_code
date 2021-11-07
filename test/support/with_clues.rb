module TestSupport
  module WithClues
    # Wrap any assertion with this method to get more
    # useful context and diagnostics when a test is
    # unexpectedly failing
    def with_clues(&block)
      puts "xxxxxx"
      block.()

      rescue Exception => ex
        puts "[ with_clues ] Test failed: #{ex.message}"
        puts "[ with_clues ] HTML {"
        puts
        puts page.html
        puts
        puts "[ with_clues ] } END HTML"
        raise ex
    end
  end
end
