#!/home1/02492/duotacc/bin/node-v0.10.13-linux-x64/bin/node

var host_name = require('os').hostname();
var port_num = process.argv[2];
var http = require('http');
http.createServer(function (request, response) {
	var fs = require('fs');
	var path = require('path');
	var file_path = process.env['HOME'] + "/ProseVisService/data/results" + request.url
	if (request.url.substring(1,4) != 'rpv'){
		response.writeHead(403, {'Content-Type': 'text/plain'});
		response.end();
	}
	else try{
		var stat = fs.statSync(file_path);
		response.writeHead(200, {
			'Content-Type' : 'application/zip',
			'Content-Length': stat.size,
			"Content-Disposition": "attachment; filename=\"" + request.url + "\"" 
		});	
		var fileStream = fs.createReadStream(file_path);
		fileStream.pipe(response);		
	} catch (e){
		response.writeHead(404, {'Content-Type': 'text/html'});
		response.write("<h2> File Not Found: \"" + path.basename(request.url) + "\" does not exist! </h2>");
		response.end();
	}		

}).listen(port_num);

console.log('Server running at http://127.0.0.1:' + port_num + '/');
console.log('Server running at http://' + host_name + ':'  + port_num + '/');
