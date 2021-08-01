const express = require('express');
const https = require('https');
const fs = require('fs');

const app = express();

app.get('/simple-api/v1/test', (req, res) => {
    console.log('test from v1 endpoint A');
    res.json({ response: 'test from v1 endpoint B' })
    res.status(200).end();
});

app.get('/simple-api/v1/health', (req, res) => {
    res.json({ response: 'I am alive' })
    res.status(200).end();
});

app.all('*', (req, res) => {
    res.status(405).end();
});

function startServer() {
    const certFile = '/tmp/simple-api-selfsigned.crt';
    const keyFile = '/tmp/simple-api-selfsigned.key';
    const cert = fs.readFileSync(certFile);
    const key = fs.readFileSync(keyFile);
    const server = https.createServer({ cert, key }, app);
    server.listen(8443, '0.0.0.0');
    console.log('https server is running');
}

startServer();


