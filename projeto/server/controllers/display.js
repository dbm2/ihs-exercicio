var express = require('express');

var router = express.Router();

var currentDisplayValue = 0;

exports.attachIOServer = function(ioServer) { this.ioServer = ioServer };

exports.handleNewConnection = function (ioSocket) {

	ioSocket.on('DisplaySetValue', function(value) {

		console.log('Value ' + value + ' seted for Display.');

		currentDisplayValue = value;
	});

};

router.get('/value', (req, res, next) => {
	
	console.log('Consulting Display current value (' + currentDisplayValue + ').');

	res.status(200).send(''+currentDisplayValue); //send the number as String
});

exports.router = router;
