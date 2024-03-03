"use strict";
var models = require("../models");
var rol = models.rol;
class RolControl {

  async listar(req, res) {
    var lista = await rol.findAll({
      attibutes: ["nombre", ["external_id", "id"]],
    });
    res.status(200);
    res.json({ msg: "OK", code: 200, datos: lista });
  }

  async obtener(req, res) {
    const external = req.params.external;
    var lista = await rol.findOne({
      where: { external_id: external},
      attibutes: ["nombre", ["external_id", "id"]],
    });
    res.status(200);
    res.json({ msg: "OK", code: 200, datos: lista });
  }

  async guardar(req, res) {
    if (req.body.hasOwnProperty("nombre")) {
      var uuid = require("uuid");
        
      var data = {
        nombre: req.body.nombre,
        external_id: uuid.v4(),
      };
      
      var result = await rol.create(data);

      if (result === null) {
        res.status(401);
        res.json({ msg: "ERROR", tag: "No se puede crear", code: 401 });
      } else {
        res.status(200);
        res.json({ msg: "OK", code: 200 });
      }

    }else{
        res.json({ msg: 'ERROR', tag: 'Faltan datos', code: 400})
    }
  }

}

module.exports = RolControl;
