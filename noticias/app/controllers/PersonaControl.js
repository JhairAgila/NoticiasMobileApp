"use strict";
var models = require("../models");
const { validarObjetoLleno } = require("../utils");
var persona = models.persona;
var rol = models.rol;
var cuenta = models.cuenta;
var uuid = require("uuid");

class PersonaControl {
  async listar(req, res) {
    var lista = await persona.findAll({
      include: [
        { model: models.cuenta, as: "cuenta", attributes: ["correo", "estado"] },
        { model: models.rol, as: "rol", attributes: ["nombre"] },
      ],
      attributes: [
        "apellidos",
        ["external_id", "id"],
        "nombres",
        "direccion",
        "celular",
        "fecha_nac",
      ],
    });
    res.status(200);
    res.json({ msg: "OK", code: 200, datos: lista });
  }
  
  async bandearUsuario(req, res){
    
    if(req.body.hasOwnProperty("estado") ){
      const {external} = req.params;
      var perA = await persona.findOne({
        where:{ external_id : external}
      });
      if(perA == undefined || perA == null){
        res.status(400);
        res.json({ msg: "Error", tag: "External id incorrecto", code: 400 });
      }else{
          var data = {
            estado: req.body.estado
          };
          await models.cuenta.update({
            estado: data.estado
          }, {
              where:{
                id_persona: perA.id
              }
            }
          );
          res.status(200);
          res.json({ msg: "Actualizado", code: 200, datos: data });
        }
    }else{
      res.status(400);
      res.json({ msg: "ERROR", tag: "Datos incompletos", code: 400 });
    }
    
    }
    
  async actualizar(req, res) {
    const external = req.params.external;
    var lista = await persona.findOne({
      where: { external_id: external },
    });
    if (lista == undefined || lista == null) {
      res.status(400);
      res.json({ msg: "Error", tag: "External id incorrecto", code: 400 });
    } else {
      var cuentaA = await cuenta.findOne({
        where: {id: lista.id}
      });
      var rolA = await rol.findOne({ where: { nombre: "PERSONA" } });
      var data = {
        nombres: req.body.nombres,
        apellidos: req.body.apellidos,
        direccion: req.body.direccion,
        celular: req.body.celular,
        fecha_nac: req.body.fecha_nac,
        rol_id: rolA.id,
        correo: req.body.correo,
      };
      if (validarObjetoLleno(data) == true) {
        if (rolA != undefined || rolA != null) {

          await cuenta.update(
            {
              correo: req.body.correo,
              clave: req.body.clave
            },{
              where: {external_id: cuentaA.external_id}
            }
          );
          await persona.update(
            {
              nombres: data.nombres,
              apellidos: data.apellidos,
              direccion: data.direccion,
              celular: data.celular,
              fecha_nac: data.fecha_nac,
              // external_id: uuid.v4(),
              id_rol: rolA.id,
            },
            {
              where: { external_id: external },
            }
          );
          delete data.rol_id;
          res.status(200);
          res.json({ msg: "Actualizado", code: 200, datos: data });
        } else {
          res.status(400);
          res.json({ msg: "Error", tag: "Id de rol no valido", code: 400 });
        }
      } else {
        res.status(400);
        res.json({ msg: "Error", tag: "Datos incompletos", code: 400 });
      }
    }
  }

  async guardar(req, res) {
    if (
      req.body.hasOwnProperty("nombres") &&
      req.body.hasOwnProperty("apellidos") &&
      req.body.hasOwnProperty("direccion") &&
      req.body.hasOwnProperty("celular") &&
      req.body.hasOwnProperty("fecha_nac") &&
      req.body.hasOwnProperty("correo") &&
      req.body.hasOwnProperty("clave") &&
      req.body.hasOwnProperty("rol")
    ) {
      var rolA = await rol.findOne({ where: { external_id: req.body.rol } });
      if (rolA != undefined) {
        var data = {
          nombres: req.body.nombres,
          external_id: uuid.v4(),
          apellidos: req.body.apellidos,
          celular: req.body.celular,
          fecha_nac: req.body.fecha_nac,
          direccion: req.body.direccion,
          id_rol: rolA.id,
          cuenta: {
            correo: req.body.correo,
            clave: req.body.clave,
          },
        };
        let transaction = await models.sequelize.transaction();
        try {
          var result = await persona.create(data, {
            include: [{ model: models.cuenta, as: "cuenta" }],
            transaction,
          });
          await transaction.commit();
          if (result === null) {
            res.status(401);
            res.json({ msg: "ERROR", tag: "No se puede crear", code: 401 });
          } else {
            rolA.external_id = uuid.v4();
            await rolA.save();
            res.status(200);
            res.json({ msg: "OK", code: 200, datos: 'Usuario guardado' });
          }
        } catch (error) {
          // if (transaction) await transaction.rollback();
          res.status(400);
          res.json({ msg: "ERROR", tag: "No se puede crearr", code: 401 });
        }
      } else {
        res.json({ msg: "ERROR", tag: "No existe external id", code: 400 });
      }
    } else {
      res.status(400);
      res.json({ msg: "ERROR", tag: "EL dato a buscar no existe", code: 400 });
    }
  }

  async guardarUser(req, res) {
    if (
      req.body.hasOwnProperty("nombres") &&
      req.body.hasOwnProperty("apellidos") &&
      req.body.hasOwnProperty("direccion") &&
      req.body.hasOwnProperty("celular") &&
      req.body.hasOwnProperty("fecha_nac") &&
      req.body.hasOwnProperty("correo") &&
      req.body.hasOwnProperty("clave")
    ) {
      var rolA = await rol.findOne({ where: { nombre: "PERSONA" } });
        var data = {
          nombres: req.body.nombres,
          external_id: uuid.v4(),
          apellidos: req.body.apellidos,
          celular: req.body.celular,
          fecha_nac: req.body.fecha_nac,
          direccion: req.body.direccion,
          id_rol: rolA.id,
          cuenta: {
            correo: req.body.correo,
            clave: req.body.clave,
          },
        };
        let transaction = await models.sequelize.transaction();
        try {
          var result = await persona.create(data, {
            include: [{ model: models.cuenta, as: "cuenta" }],
            transaction,
          });
          await transaction.commit();
          if (result === null) {
            res.status(401);
            res.json({ msg: "ERROR", tag: "No se puede crear", code: 400 });
          } else {
            rolA.external_id = uuid.v4();
            await rolA.save();
            res.status(200);
            res.json({ msg: "OK", code: 200, datos: 'Usuario guardado' });
          }
        } catch (error) {
          if (transaction) await transaction.rollback();
          res.status(400);
          res.json({ msg: error, tag: "No se puede crearr", code: 400 });
        }
    } else {
      res.status(400);
      res.json({ msg: "ERROR", tag: "EL dato a buscar no existe", code: 400 });
    }
  }

  async obtener(req, res) {
    const external = req.params.external;

    var lista = await persona.findOne({
      where: { external_id: external },
      include: [
        { model: models.cuenta, as: "cuenta", attributes: ["correo"] },
        { model: models.rol, as: "rol", attributes: ["nombre"] },
      ],
      attributes: [
        "apellidos",
        ["external_id", "id"],
        "nombres",
        "direccion",
        "celular",
        "fecha_nac",
      ],
    });

    if (lista == undefined || lista == null) {
      res.status(200);
      res.json({ msg: "OK", code: 200, datos: {} });
    } else {
      res.status(200);
      res.json({ msg: "OK", code: 200, datos: lista });
    }
  }
}

module.exports = PersonaControl;
