var express = require('express');

var router = express.Router();

exports.attachIOServer = function(ioServer) {
	this.ioServer = ioServer;
};

router.post('/:id/value/:value', (req, res, next) => {

	console.log('[Switches POST] Value ' + req.params.value + ' seted for Switch ' + req.params.id + '.');

	let eventParameters = {
		switch: req.params.id,
		value: req.params.value
	};

	this.ioServer.emit('switchValueChanged', eventParameters);

	res.sendStatus(200);
});

exports.router = router;
