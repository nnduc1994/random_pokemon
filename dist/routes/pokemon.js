"use strict";

var _interopRequireDefault = require("@babel/runtime/helpers/interopRequireDefault");

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports["default"] = void 0;

var _regenerator = _interopRequireDefault(require("@babel/runtime/regenerator"));

var _asyncToGenerator2 = _interopRequireDefault(require("@babel/runtime/helpers/asyncToGenerator"));

var _express = _interopRequireDefault(require("express"));

var _axios = _interopRequireDefault(require("axios"));

var router = _express["default"].Router();

var min = 1;
var max = 808; // there are 807 pokemons

router.get('/', /*#__PURE__*/function () {
  var _ref = (0, _asyncToGenerator2["default"])( /*#__PURE__*/_regenerator["default"].mark(function _callee(req, res) {
    var randomNum, response, _response$data, id, height, name, weight, _response$data$sprite, front_default, back_default, pokemonResponse;

    return _regenerator["default"].wrap(function _callee$(_context) {
      while (1) {
        switch (_context.prev = _context.next) {
          case 0:
            _context.prev = 0;
            randomNum = Math.floor(Math.random() * (max - min) + min);
            _context.next = 4;
            return _axios["default"].get("https://pokeapi.co/api/v2/pokemon/".concat(randomNum));

          case 4:
            response = _context.sent;
            _response$data = response.data, id = _response$data.id, height = _response$data.height, name = _response$data.name, weight = _response$data.weight, _response$data$sprite = _response$data.sprites, front_default = _response$data$sprite.front_default, back_default = _response$data$sprite.back_default;
            pokemonResponse = {
              id: id,
              height: height,
              weight: weight,
              name: name,
              front_default: front_default,
              back_default: back_default,
              img: "https://pokeres.bastionbot.org/images/pokemon/".concat(randomNum, ".png")
            };
            return _context.abrupt("return", res.status(200).send(pokemonResponse));

          case 10:
            _context.prev = 10;
            _context.t0 = _context["catch"](0);
            console.log(_context.t0);
            return _context.abrupt("return", res.status(_context.t0.response.status).send());

          case 14:
          case "end":
            return _context.stop();
        }
      }
    }, _callee, null, [[0, 10]]);
  }));

  return function (_x, _x2) {
    return _ref.apply(this, arguments);
  };
}());
var _default = router;
exports["default"] = _default;