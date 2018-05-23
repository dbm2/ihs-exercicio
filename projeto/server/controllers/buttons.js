var express = require('express');

var router = express.Router();
var ioServer;

exports.attachIOServer = function(ioServer) {
	this.ioServer = ioServer;
};

router.post('/:id/value/:value', (req, res, next) => {

	console.log('[Buttons POST] Value ' + req.params.value + ' seted for Button ' + req.params.id + '.');

	let eventParameters = {
		button: req.params.id,
		value: req.params.value
	};

	this.ioServer.emit('buttonValueChanged', eventParameters);

	res.sendStatus(200);
});

exports.router = router;
