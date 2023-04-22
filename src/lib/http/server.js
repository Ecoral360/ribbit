http = require('http')

// make an http server

const headers = ['Content-Type', 'text/plain', 'Content-Length', '11']

server = http.createServer(function(req, res) {
	// ... do something with the request
	// transform headers from a list of strings to an object
	headers = headers.reduce((acc, cur, i, arr) => {
		if (i % 2 === 0) {
			acc[cur] = arr[i + 1]
		}
		return acc
	}, {})

	res.writeHead(200, )
	res.end('Hello World')
})

// listen on port 3000
server.listen(3000)
