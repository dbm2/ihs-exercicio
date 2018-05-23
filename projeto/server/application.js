var express = require('express');
var bodyParser = require('body-parser');

var buttonsController = require('./controllers/buttons');
var switchesController = require('./controllers/switches');
var displayController = require('./controllers/display');

var app = express();

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

app.use('/buttons', buttonsController.router);
app.use('/switches', switchesController.router);
app.use('/display', displayController.router);

exports.prepareEndpoints = function(ioServer) {
	buttonsController.attachIOServer(ioServer);
	switchesController.attachIOServer(ioServer);
};

exports.instance = app;
