// https://nodejs.org/api/http.html
// https://nodejs.org/en/learn/modules/anatomy-of-an-http-transaction
//
const { createServer } = require('node:http');

const hostname = '0.0.0.0';
const port = 3000;

const server = createServer((req, res) => {
  const headers = {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "OPTIONS, POST, GET, PUT",
    "Access-Control-Max-Age": 2592000,
    "Access-Control-Allow-Headers": "*",
  };

  if (req.method == "OPTIONS") {
    res.writeHead(204, headers);
    res.end();
    return;
  }

  if (["GET", "POST", "PUT"].indexOf(req.method) > -1) {
    res.writeHead(200, headers);
    let body = [];
    req.on('data', (chunk) => {
      body.push(chunk);
    }).on('end', () => {
      body = Buffer.concat(body).toString();

      console.log(`=== ${req.method} ${req.url}`);
      console.log('> Headers');
      console.log(req.headers);
      console.log('> Body');
      console.log(body);

      res.write(`${req.method} ${req.url}\n`);
      res.write('HEADERS:\n');
      res.write(JSON.stringify(req.headers, undefined, 2));
      res.write('\nBODY:\n');
      res.write(body);
      res.end('\n');
    });
    return;
  }

  res.writeHead(405, headers);
  res.end(`${req.method} is not allowed for this request.`);
});

server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});
