"use strict";

var _interopRequireDefault = require("@babel/runtime/helpers/interopRequireDefault");

var _express = _interopRequireDefault(require("express"));

var _cors = _interopRequireDefault(require("cors"));

var _pokemon = _interopRequireDefault(require("./routes/pokemon.js"));

var app = (0, _express["default"])();
app.use(_express["default"].json());
app.use((0, _cors["default"])());
app.use('/pokemon', _pokemon["default"]);
var PORT = process.env.PORT;
app.listen(PORT);
console.log('app running on port', PORT);