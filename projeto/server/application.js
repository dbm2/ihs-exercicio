var express = require('express');
var bodyParser = require('body-parser');
var morgan = require('morgan');

var buttonsController = require('./controllers/buttons');
var switchesController = require('./controllers/switches');
var displayController = require('./controllers/display');

var app = express();

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

//app.use(morgan('dev'));

app.use('/buttons', buttonsController.router);
app.use('/switches', switchesController.router);
app.use('/display', displayController.router);

exports.handleNewConnection = function (ioSocket) {
	buttonsController.handleNewConnection(ioSocket);
	switchesController.handleNewConnection(ioSocket);
	displayController.handleNewConnection(ioSocket);
};

exports.prepareEndpoints = function(ioServer) {
	buttonsController.attachIOServer(ioServer);
	switchesController.attachIOServer(ioServer);
	displayController.attachIOServer(ioServer);
};

exports.instance = app;
