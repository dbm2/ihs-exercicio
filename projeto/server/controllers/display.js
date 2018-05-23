var express = require('express');

var router = express.Router();

var currentDisplayValue = 0;

exports.attachIOServer = function(ioServer) {

	this.ioServer = ioServer;

	this.ioServer.on('DisplaySetValue', function(value) {

		console.log('[Display POST] Value ' + req.params.value + ' seted for Display.');

		currentDisplayValue = value;
	});
};

router.get('/value', (req, res, next) => {
	
	console.log('[Display GET] Consulting Display current value (' + currentDisplayValue + ').');

	res.status(200).send({ value: currentDisplayValue });
});

exports.router = router;
