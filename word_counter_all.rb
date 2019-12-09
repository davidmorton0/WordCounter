# Extracts chapter titles using chap_title_pattern
# chap_title_pattern must not match any other lines
# Counts all words by chapter and writes to a file

input = 'asos' #input file
input_file = input + ".txt" #input file
output_file_keyword = 'wordcount'

lines = File.readlines(input_file, encoding: "utf-8")
chapter_titles = []
chapter_wordcount = []
chap_title_pattern = Regexp.new(/^[\'A-Z]+\s?[\'A-Z]+?\s?[\'A-Z]+?\s?[\'A-Z]*?$/)
lines.each do |line|
	if line.match(chap_title_pattern) #new chapter
		chapter_titles.push(line.chomp!)
		chapter_wordcount.push(0)
	else
		words = line.split(/\s/)
		chapter_wordcount[-1] += words.select { |word| word != "" }.length
	end
end

output_file = input + output_file_keyword + ".txt"
f = File.new(output_file, 'w')
f.write("Word count: #{input_file}\n")

chapter_titles.each_with_index { |chapter, i|
	f.write("Chapter #{i}: #{chapter_titles[i]}; #{chapter_wordcount[i]}\n") }

f.write ("Total: #{chapter_wordcount.sum}")
f.close
