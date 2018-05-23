var application = require('./application.js');

var server = require('http').createServer(application.instance);  

var io = require('socket.io')(server);

var port = process.env.PORT || 3000;

server.listen(port, function() {
  console.log('IHS Server listening on port ' + port + '...');
});

application.prepareEndpoints(io);

io.on('connection', function(socket) {
	console.log('New connection established.');

	application.handleNewConnection(socket);
});
