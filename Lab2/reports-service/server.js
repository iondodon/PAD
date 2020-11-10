let http = require('http')

http.createServer((req, res) => {
  res.write('Hello World!')
  res.end()
}).listen(9090)


console.log("Listening on port 9090.")