var express = require('express');

var router = express.Router();

var currentDisplayValue = 0;

router.post('/value/:value', (req, res, next) => {

	console.log('[Display POST] Value ' + req.params.value + ' seted for Display.');

	currentDisplayValue = req.params.value;

	res.sendStatus(200);
});


router.get('/value', (req, res, next) => {
	
	console.log('[Display GET] Consulting Display current value (' + currentDisplayValue + ').');

	res.status(200).send({ value: currentDisplayValue });
});

exports.router = router;
