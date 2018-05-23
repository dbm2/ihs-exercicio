var application = require('./application.js');

var server = require('http').createServer(application.instance); 

var io = require('socket.io')(server);

application.prepareEndpoints(io);

var port = process.env.PORT || 3000;

io.on('connection', function(socket) {
	console.log('Received new connection.');
});

application.instance.listen(port, function() {
  console.log('IHS Server listening on port ' + port + '...');
});