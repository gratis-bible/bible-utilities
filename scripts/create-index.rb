#script to create index files for each bible from files generated by rename.rb
#should be re-written to be included in rename.rb
require 'rexml/document'
require 'fileutils'

#default to current directory if none provided
directory = ARGV[0] ? ARGV[0] : Dir.pwd

#add flag if using split branch of osis-bibles
#will create index files for each bible individually
split = ARGV[1] && ARGV[1] == 'split' ? true : false

#get index of OSIS books
booksXML = REXML::Document.new(File.new("../data/books.xml"))

#get index of ISO languages
isoLangFile = File.new("../data/ISO-639-2_utf-8.txt",'r');
lang = Hash.new
while (line = isoLangFile.gets)
	a = line.split('|')
	id = a[2]; #using old ISO-639-1 codes for now
	if id
		lang[id] = a[3] #english title for language
	end
end
isoLangFile.close

Dir.chdir(directory);

indexFile = File.new("index.xml","w+");
indexXML = REXML::Document.new();
a = indexXML.add_element "bibles"
indexXML << REXML::XMLDecl.new

Dir.glob("*") do |lang_entry| 

	if File.directory? lang_entry 
		title = lang[lang_entry] ? lang[lang_entry] : "Other"
		b = a.add_element "language", {"id"=>lang_entry, "title"=>title}
		Dir.foreach(lang_entry) do |bible_entry|
			if bible_entry != '.' && bible_entry != '..' && (File.directory? lang_entry+'/'+bible_entry)
				books = Dir.glob(lang_entry+'/'+bible_entry+'/*.xml')
				firstBook = books[0]
				if firstBook
					firstBookXML = REXML::Document.new(File.new(firstBook))
					title = firstBookXML.root.elements["osisText/header/work/title"].text	
					title = title ? title : "Unknown"				
					puts lang_entry+'/'+bible_entry+': '+title
					b.add_element "bible", {"id"=>bible_entry,"title"=>title}
					#create individual bible index if needed
					if split
						bibleFile = File.new(lang_entry+"/"+bible_entry+".xml","w+");
						bibleXML = firstBookXML.deep_clone
						bibleXML.elements.delete_all("//div[@type='book']")
						books.each do |book|
							bookID = File.basename(book).split('.')[0]
							bookXML = REXML::XPath.first(booksXML,"//osisID[contains(translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'"+bookID+"')]/..")
							if bookXML
								osisID = REXML::XPath.first(bookXML,"osisID")
								osisID = osisID ? osisID.text : bookID
								title  = REXML::XPath.first(bookXML,"title")
								title = title ? title.text : "Unknown"
								puts bible_entry + ': '+osisID
								bibleXML.root.elements["osisText"].add_element "div", {"type"=>"book","osisID"=>osisID,"title"=>title,"id"=>bookID}
							end
						end
						bibleFile.write(bibleXML);
					end
				end
			end
		end
	end
end
indexFile.write(indexXML)