const http = require('http');
const fs = require('fs');

// making a server

const server = http.createServer((req, res) => {
	console.log(`request was made: ${req.method} ${req.url}`);
	switch (req.url) {
		case '/routing.scm.js':
			res.writeHead(200, { 'Content-Type': 'text/javascript' });
			const myReadStream2 = fs.createReadStream(__dirname + '/routing.scm.js', 'utf8');
			myReadStream2.pipe(res);
			break;
		default:
			res.writeHead(200, { 'Content-Type': 'text/html' });
			const myReadStream = fs.createReadStream(__dirname + '/index.html', 'utf8');
			myReadStream.pipe(res);
	}
});

// listening to the port 3000
server.listen(3000, 'localhost', () => {
	console.log('listening for requests on port 3000');
});

