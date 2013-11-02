require 'rexml/document'
require 'fileutils'

#default to current directory if none provided
directory = ARGV[0] ? ARGV[0] : Dir.pwd

Dir.chdir(directory);

Dir.glob("*.xml") do |filename| 

	xml = REXML::Document.new(File.new(filename));
	workID = xml.root.elements["osisText"].attributes["osisIDWork"].downcase
	lang = xml.root.elements["osisText/header/work/language"].text.downcase
	
	#copy the original XML file to correct location
	FileUtils.mkdir_p(lang)
	file = File.new(lang+"/"+workID+".xml","w+")
	file.write(xml);
	
	#create individual files for each book
	FileUtils.mkdir_p(lang+"/"+workID)
	emptyBookXML = xml.deep_clone
	emptyBookXML.elements.delete_all("//div[@type='book']")
	REXML::XPath.each(xml, "//div[@type='book']") do |book|
		bookXML = emptyBookXML.deep_clone
		bookXML.root.elements["osisText"].add_element(book)
		bookID = book.attributes["osisID"].downcase
		bookFile = File.new(lang+"/"+workID+"/"+bookID+".xml","w+")
	    bookFile.write(bookXML)
	end
	
	puts workID+" complete"
end