ROMAN_NUMERALS = ["", "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X",
	"XI", "XII", "XIII", "XIV", "XV", "XVI", "XVII", "XVIII", "XIX", "XX"]
input_file = 'asos.txt' #input file
pattern = Regexp.new(/gold|golden|yellow/i) #find relevent words
word_desc = 'word_count'
lines = File.readlines(input_file)
chapter_titles = []
chapter = []
uniques = []
chap_head_pattern = Regexp.new(/^[\'A-Z]+\s?[\'A-Z]+?\s?[\'A-Z]+?\s?[\'A-Z]*?$/)
lines.each do |line|
	if line.match(chap_head_pattern)
		chapter_titles.push(line.chomp!)
		chapter.push("")
		uniques.push({})
	else
		chapter[-1] += line
		words = line.split(/\W/)
		words.select { |w| w.match(pattern) }.each do |word|
			word.downcase!
  			if uniques[-1][word]
    			uniques[-1][word] += 1
  			else
    			uniques[-1][word] = 1
  			end
  		end
	end
end
puts "Chapter number = ", chapter_titles.length

#make a list of all words
book_uniques = []
uniques.map { |uns| book_uniques += uns.keys }
book_uniques.uniq!.sort!

# make a hash for each chapter
book_uniques_hash = book_uniques.each_with_object({}) { |k, h| h[k] = 0 }
uniques.each_with_index { |uns, i| uniques[i] = book_uniques_hash.merge(uns) }

#format chapter titles
chapter_titles_formatted = []
chapter_titles.each_with_index do |chapter, i|
	num = (chapter_titles.count(chapter) > 1 ? chapter_titles.take(i + 1).count(chapter) : 0)
	chapter_titles_formatted.push("Chapter #{i} #{chapter}#{num > 0 ? " " : ""}#{ROMAN_NUMERALS[num]}")
end

#output results to file
output_file = input_file.match(/(^[A-Za-z\d]+)[.]/).captures[0] + "-wordcount.txt"
puts output_file
f = File.new(output_file, 'w')
f.write("Word count\n")
f.write("Title, Word Count\n")
uniques.each_with_index do |word_list, i|
	f.write("#{chapter_titles_formatted[1]}, #{chapter[i].split(/\s/).length}\n")
end
f.close
