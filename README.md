ProseVis Server-Side Code

Introduction: What is ProseVis?
-------------------------------------------------------------------------------
	ProseVis is a text visualization tool developed to identify other features 
	than the "word" to analyze texts. These features comprise sound including 
	parts-of-speech, accent, phoneme, stress, tone, break index. It facilitates a 
	reader to analyze and disseminate the results in human readable form. Recreating 
	the context of the page not only allows for the simultaneous consideration of 
	multiple representations of knowledge or readings but it also allows for a more 
	transparent view of the underlying textual data. If a human can read the data 
	within the context and is able to know the mappings back onto the full text, the 
	reader is empowered within this familiar context to read what might otherwise be 
	an unfamiliar tabular representation of the text. For these reasons, we developed 
	ProseVis Web Application as a reader interface and a gateway to supercomputers in 
	order to reach more audience. It allows scholars to work with the data in a 
	language or context in which we are used to saying things about the world.


Running Environment 
-------------------------------------------------------------------------------
	This program is testing with Java 1.7, Python 2.7.5, nodejs v0.10.13 and 
	Open-Mary (http://mary.dfki.de/)

Major API Components of This Program
-------------------------------------------------------------------------------
	The core script of this program is control.sh which is under the project root 
	directory. the input files must be stored in zip format at data/src/. The output
	files will be put under data/results/.  
	
	control.sh - the entry point of this application
	
	module/singleDoc.sh - Create a job for single-document analyzing
	
	module/compare.sh - Create a job for multiple-document comparison 
	
	publisher/download.js - Start a temporary web service for output file downloading
	
	publisher/noticeToUser.py - Send an email to the end user with a file URL
	