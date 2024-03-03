"use strict";
let jwt = require("jsonwebtoken");
var models = require("../models");
var persona = models.persona;
var cuenta = models.cuenta;

class CredencialesControl {
  async inicio_sesion(req, res) {
    if (req.body.hasOwnProperty("correo") && req.body.hasOwnProperty("clave")) {
      let cuentaA = await cuenta.findOne({
        where: { correo: req.body.correo },
        include: [
          {
            model: models.persona,
            as: "persona",
            include: [
              {
                model: models.rol,
                as: "rol",
                attributes: ["nombre"]
              }
            ],  
            attributes: ["apellidos", "nombres", "external_id", "id_rol"],
          },
        ],
        attributes: [
          "correo",
          "clave",
          "estado",
          "external_id"
        ],
      });
      if (cuentaA == null) {
        console.log('cuenta ' + cuentaA);
        res.status(400);
        res.json({ msg: "Cuenta no existe", code: 400, tag: "Credenciales incorrectas" });
      } else {
        if (cuentaA.estado == true) {
          if (cuentaA.clave == req.body.clave) {
            //TODO ...
            const token_data = {
              external: cuentaA.external_id,
              check: true,
            };
            require("dotenv").config();
            const key = process.env.KEY_JWT;
            const token = jwt.sign(token_data, key, {
              expiresIn: "2h",
            });
            var info = {
              token: token,
              user: cuentaA.persona.apellidos + " " + cuentaA.persona.nombres,
              id: cuentaA.persona.external_id,
              rol: cuentaA.persona.rol.nombre
            };
            res.status(200);
            res.json({ msg: "OK", tag: "Listo", datos: info, code: 200 });
          } else {
            res.status(400);
            res.json({ msg: "ERROR", tag: "Credenciales incorrectas", code: 400 });
          }
        } else {
          res.status(400);
          res.json({ msg: "ERROR", tag: "Cuenta desactivada", code: 400 });
        }
      }
    } else {
      res.status(400);
      res.json({ msg: "ERROR", tag: "No hay campos suficientes", code: 400 });
    }
  }
}

module.exports = CredencialesControl;
