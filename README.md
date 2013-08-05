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
	The computing server is currently hosted at stampede.tacc.utexas.edu. 
	There are four domains for this server, i.e. 
 		login{1, 2, 3, 4}.stampede.tacc.utexas.edu
	The Stampede server is supposed to be accessed via SSH protocol. 
	
	The project depends on user-level installed binaries, including
		JDK 1.7.0_25 - $WROK/bin/jdk1.7.0_25/bin/
		Python 2.7.5 - $WORK/bin/Python-2.7.5/bin/
		OpenMary - $HOME/bin/marytts-5.0/bin/
		NodeJS - $WORK/bin/node-v0.10.13-linux-x64/bin/
	The above path information is recommended to be included in the system path ($PATH)
	in order to properly execute the program. The python binaries are built and tested 
	from source. 
	
	In bash environment, $_JAVA_OPTIONS is supposed to be configured to include 
	-Xmx option. Currently, -Xmx2g is set to prevent the heap-oversize issues. 


Overview of the executing sequence and Running Requirements
-------------------------------------------------------------------------------


Major API Components of This Program
-------------------------------------------------------------------------------
	The core script of this program is control.sh which is under the project root 
	directory. the input files must be stored in zip format at data/src/. The output
	files will be put under data/results/.  
	
	control.sh - 
		control.sh is the entry point of this application, which is remotely invoked 
		by the gateway server. During the processing, a unique tracking taskId is 
		referenced for various stages. It is expected at most one ProseVis job is 
		executing at one time. The control.sh script sets up additional environment 
		variables, unzipping files and parses the meta-info JSON file. Distinguishing 
		two different tasks from the JSON file, it branches to either of the two 
		templates batch submission script for job processing. 
	
	module/ - 
		The functional module is put under the module directory. The singleDoc.sh and 
		compare.sh correspond to single document analysis and multiple document 
		comparison. The mary-close.sh script helps to shut down the entire job upon 
		job completion. 
	
	tookit/ - 
		The toolkit directory is designed for small tasks, including parsing and 
		extracting information from JSON files and detecting free port numbers. 
	
	publisher/ - 
		The publisher directory helps a user to access the output data. The current 
		working version is built on a simple NodeJS server. It opens an available port 
		on Stampede and listens on that port. Upon a valid request arrives on the port, 
		the server sends the file through the channel. While staring the NodeJS server, 
		the script disables the system hang up signal, and therefore a logout action 
		does not stop the service. To run download.js on the server side, the NodeJS 
		framwork is expected to be installed. Upon job completion, The python script 
		noticeToUser.py sends an notification email to the end user with a file URL.
	