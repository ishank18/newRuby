=begin
while(current_char != options[i][j])
      if(j == options[i].length - 1)
        break
      end
      j += 1
    end
    if(current_char == options[i][j])
      count += 1
    end
    if(j == options[i].length - 1)
      break
    end

=end


print "Number of options - "
num_option = gets.chomp.to_i
options = []
length_matched = []
print "\nWrong word - "
wrong_word = gets.chomp
i = 0
puts "Options - "
while( i < num_option )
  options[options.length] = gets.chomp
  i += 1
end
count = 0
curr_count = 0
for i in 0..num_option-1
  j = 0

  k = 0
  while(k < wrong_word.length)
    if(wrong_word[k] == options[i][j])
      while(wrong_word[k] == options[i][j])
        curr_count += 1
        if(j == options[i].length - 1)
          break
        end
        k += 1
        j += 1
        p wrong_word[k] + options[i][j]
      end
      if(curr_count > count)
      	count = curr_count
      end
    end
    curr_count = 0
    j += 1
    k += 1
  end
  puts count
  count = 0
  curr_count = 0
end


