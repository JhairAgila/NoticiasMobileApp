"use strict";

var models = require("../models");
var comentario = models.comentario;
var persona = models.persona;
var noticia = models.noticia;
var uuid = require("uuid");
class ComentarioControl {
  async listar(req, res) {

    var lista = await comentario.findAll({
      include: [
        {
          model: noticia,
          as: noticia,
          attributes: ["titulo", "fecha"],
        },
        {
          model: persona,
          as: persona,
          attibutes: ["nombres", "apellidos"],
        },
      ],
      attributes: ["external_id", "cuerpo", "latitud", "longitud", "estado"],
    });

    if (lista == undefined || lista == null) {
      res.status(200);
      res.json({ msg: "OK", code: 200, datos: {} });
    } else {
      res.status(200);
      res.json({ msg: "OK", code: 200, datos: lista });
    }
  }

  async guardar(req, res) {
    if (
      req.body.hasOwnProperty("cuerpo") &&
      req.body.hasOwnProperty("estado") &&
      req.body.hasOwnProperty("id_persona") &&
      req.body.hasOwnProperty("longitud") &&
      req.body.hasOwnProperty("latitud") &&
      req.body.hasOwnProperty("noticia_id")
    ) {
      const noticiaA = await noticia.findOne({
        where: { external_id: req.body.noticia_id },
      });
      const usuarioA = await persona.findOne({
        where: { external_id: req.body.id_persona },
        include: [
          {
            model: models.rol,
            as: models.rol,
            attributes: ["nombre"],
          },
        ],
      });
      if (usuarioA == null || usuarioA == undefined) {
        res.status(400);
        res.json({ msg: "ERROR", tag: "Usuario no encontrada", code: 400 });
      } else {
        if (usuarioA.rol.nombre == "PERSONA" || usuarioA.rol.nombre == "EDITOR" || usuarioA.rol.nombre == "ADMINISTRADOR") {
          if (noticiaA == null || noticiaA == undefined) {
            res.status(400);
            res.json({ msg: "ERROR", tag: "Noticia no encontrada", code: 400 });
          } else {
            var data = {
              cuerpo: req.body.cuerpo,
              estado: req.body.estado,
              longitud: req.body.longitud,
              latitud: req.body.latitud,
              noticia_id: noticiaA.id,
              id_persona: usuarioA.id,
              external_id: uuid.v4(),
            };

            console.log(data);

            var result = await comentario.create(data);
            console.log(result.updatedAt);
            const userIdentification = {
              nombres: usuarioA.nombres,
              apellidos: usuarioA.apellidos,
              external_id: usuarioA.external_id,
              idComentario: result.external_id,
              updatedAt: result.updatedAt
            }
            if (result === null) {
              res.status(400);
              res.json({ msg: "ERROR", tag: "No se puede crear", code: 400 });
            } else {
              res.status(200);
              res.json({ msg: "OK", code: 200, datos: userIdentification});
            }
          }
        } else {
          res.status(400);
          res.json({ msg: "FORBIDEN", code: 400 });
        }
      }
    } else {
      res.json({ msg: "ERROR", tag: "Faltan datos", code: 400 });
    }
  }

  async actualizarComentario(req, res) {
    if (
      req.body.hasOwnProperty("cuerpo") &&
      req.body.hasOwnProperty("estado") &&
      req.body.hasOwnProperty("longitud") &&
      req.body.hasOwnProperty("latitud") &&
      req.body.hasOwnProperty("noticia_id") &&
      req.body.hasOwnProperty("usuario")
    ) {
      const external = req.params.external;
      var comentarioEncontrado = await comentario.findOne({
        where: { external_id: external },
      });
      const user = await persona.findOne({
        where: { external_id: req.body.usuario },
        include: [
          {
            model: models.rol,
            as: models.rol,
            attributes: ["nombre"],
          },
        ],
      });
      const noticiaA = await noticia.findOne({
        where: { external_id: req.body.noticia_id },
      });
      if(!noticiaA){

        res.status(400);
            res.json({
              msg: "ERROR",
              tag: "Noticia no encontrada",
              code: 400,
            });
      }else{
        if (user?.rol?.nombre == "PERSONA" || user?.rol?.nombre == "ADMINISTRADOR") {

          if (comentarioEncontrado == undefined || comentarioEncontrado == null) {
            console.log('DENTRO DE NOICIA');

            res.status(400);
            res.json({
              msg: "ERROR",
              tag: "Comentario no encontrado",
              code: 400,
            });
          } else {
            console.log('dentro de if')
            var data = {
              cuerpo: req.body.cuerpo,
              estado: req.body.estado,
              longitud: req.body.longitud,
              latitud: req.body.latitud,
              external_id: uuid.v4(),
            };

            await comentario.update(
              {
                cuerpo: data.cuerpo,
                estado: data.estado,
                longitud: data.longitud,
                latitud: data.latitud,
                external_id: data.external_id,
              },
              {
                where: { external_id: external },
              }
            );
            res.status(200);
            res.json({
              msg: "OK",
              tag: "Comentario actualizado",
              code: 200,
            });
        }
      } else {
        if (!user) {
          res.status(400);
          res.json({
            msg: "ERROR",
            tag: "Persona no encontrada no encontrado",
            code: 400,
          });
        }else{
          res.status(403);
          res.json({ msg: "FORBIDEN", code: 403 });
        }
        
      }
    }
    } else {
      res.status(400);
      res.json({
        msg: "ERROR",
        tag: "Datos incompletos",
        code: 400,
      });
    }
  }

  async eliminarComentario(req, res) {
    const external = req.params.external;
    var result = await comentario.destroy({
      where: {
        external_id: external,
      },
    });

    res.status(200);
    res.json({
      msg: "Comentario eliminido",
      code: 200,
      datos: result,
    });
  }

  async obtenerComentario(req, res) {
    const external = req.params.external;
    console.log(external);
    var lista = await comentario.findAll({
      where: { external_id: external },
      include: [
        {
          model: noticia,
          as: noticia,
          attributes: ["titulo", "fecha"],
        },
        {
          model: persona,
          as: persona,
          attributes: ["nombres", "apellidos"],
        },
      ],
      attributes: ["cuerpo"],
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

module.exports = ComentarioControl;
