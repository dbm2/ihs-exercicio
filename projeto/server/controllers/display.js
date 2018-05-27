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

router.post('/value/:value', (req, res, next) => {
	
	currentDisplayValue = req.params.value;

	res.sendStatus(200);
});


router.get('/value', (req, res, next) => {
	
	//console.log('Consulting Display current value (' + currentDisplayValue + ').');

	res.status(200).send(currentDisplayValue.toString());
});

exports.router = router;
