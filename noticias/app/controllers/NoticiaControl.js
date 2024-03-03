"use strict";
var formidable = require("formidable");
var uuid = require("uuid");
var models = require("../models");
var fs = require("fs");
const { validarObjetoLleno } = require("../utils");
var noticia = models.noticia;
var extensiones = ["jpg", "png", "mp4"];
class NoticiaControl {
  async listar(req, res) {
    var lista = await noticia.findAll({
      include: [
        {
          model: models.persona,
          as: "persona",
          attributes: ["apellidos", "nombres"],
        },
        {
          model: models.comentario,
          as: "pertenece_noticia",
          attributes: ["cuerpo", "latitud", "longitud", "estado"],
          include: [
            {
              model: models.persona,
              as: "persona",
              attributes: ["apellidos", "nombres"],
            },
          ],
        },
      ],
      attributes: [
        "titulo",
        ["external_id", "id"],
        "cuerpo",
        "tipo_archivo",
        "fecha",
        "tipo_noticia",
        "archivo",
        "estado",
      ],
    });
    res.status(200);
    res.json({ msg: "OK", code: 200, datos: lista });
  }
  async obtener(req, res) {
    const external = req.params.external;
    const page = req.query.page ? parseInt(req.query.page) : 1; // Obtener el número de página de la consulta
    const pageSize = 10; // Tamaño de cada página

    // Calcular el offset basado en el número de página
    const offset = (page - 1) * pageSize;
    var lista = await noticia.findAndCountAll({
      where: { external_id: external },
      include: [
        {
          model: models.persona,
          as: "persona",
          attributes: ["apellidos", "nombres", "external_id"],
        },
        {
          model: models.comentario,
          as: "pertenece_noticia",
          attributes: ["external_id", "cuerpo", "latitud", "longitud", "estado", "id_persona", "noticia_id", "updatedAt"],
          include: [
            {
              model: models.persona,
              as: "persona",
              attributes: ["apellidos", "nombres",  "external_id"],
            },
          ],
          offset: offset,
          limit: pageSize,
          order: [ [ 'createdAt', 'DESC' ] ]
        },
      ],
      attributes: [
        "titulo",
        "external_id",
        "cuerpo",
        "tipo_archivo",
        "fecha",
        "tipo_noticia",
        "archivo",
        "estado",
      ],
    });
    res.status(200);
    res.json({ msg: "OK", code: 200, datos: lista });
  }
  async obtenerP(req, res) {
    const external = req.params.external;

    var lista = await noticia.findAll({
      where: { external_id: external },
      include: [
        {
          model: models.persona,
          as: "persona",
          attributes: ["apellidos", "nombres"],
        },
        {
          model: models.comentario,
          as: "pertenece_noticia",
          attributes: ["cuerpo", "latitud", "longitud", "estado"],
          include: [
            {
              model: models.persona,
              as: "comentarios",
              attributes: ["apellidos", "nombres"],
            },
          ],
        },
      ],
      attributes: [
        "titulo",
        "cuerpo",
        "external_id",
        "tipo_archivo",
        "fecha",
        "tipo_noticia",
        "archivo",
        "estado",
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
  
  async obtenerNoticiasActivas(req, res){
    var lista = await noticia.findAndCountAll({
      where: { estado: true },
      include: [
        {
          model: models.persona,
          as: "persona",
          attributes: ["apellidos", "nombres", "external_id"],
        },
        {
          model: models.comentario,
          as: "pertenece_noticia",
          attributes: ["external_id", "cuerpo", "latitud", "longitud", "estado", "id_persona", "updatedAt"],
          include: [
            {
              model: models.persona,
              as: "persona",
              attributes: ["apellidos", "nombres",  "external_id"],
            },
          ],
          offset: 0,
          limit: 10,
          order: [ [ 'createdAt', 'DESC' ] ]
        },
      ],
      attributes: [
        "titulo",
        "external_id",
        "cuerpo",
        "tipo_archivo",
        "fecha",
        "tipo_noticia",
        "archivo",
        "estado",
      ],
      
      // distinct: true,
      // order: [ [ 'createdAt', 'DESC' ] ]
    });
    res.status(200);
    res.json({ msg: "OK", code: 200, datos: lista });
  }

  async guardar(req, res) {
    if (
      req.body.hasOwnProperty("titulo") &&
      req.body.hasOwnProperty("cuerpo") &&
      req.body.hasOwnProperty("fecha") &&
      req.body.hasOwnProperty("tipo_noticia") &&
      req.body.hasOwnProperty("persona")
    ) {
      var uuid = require("uuid");
      var perA = await models.persona.findOne({
        where: { external_id: req.body.persona },
        include: [
          {
            model: models.rol,
            as: "rol",
            attributes: ["nombre"],
          },
        ],
      });
      if (perA == undefined || perA == null) {
        res.status(401);
        res.json({
          msg: "ERROR",
          tag: "No se encontro el editor",
          code: 401,
        });
      } else {
        var data = {
          cuerpo: req.body.cuerpo,
          external_id: uuid.v4(),
          titulo: req.body.titulo,
          fecha: req.body.fecha,
          tipo_noticia: req.body.tipo_noticia,
          persona_id: perA.id,
          estado: true,
          archivo: req.body.archivo,
        };
        if (perA.rol.nombre == "EDITOR" || perA.rol.nombre == "ADMINISTRADOR") {
          var result = await noticia.create(data);
          if (result == null) {
            res.status(401);
            res.json({ msg: "ERROR", tag: "No se puede crear", code: 401 });
          } else {
            perA.external_id = uuid.v4();
            await perA.save();
            res.status(200);
            res.json({ msg: "OK", code: 200 });
          }
        } else {
          res.status(400);
          res.json({
            msg: "ERROR",
            tag: "La persona que quiere ingresar no es editor",
            code: 400,
          });
        }
      }
    } else {
      res.status(400);
      res.json({ msg: "ERROR", tag: "EL dato a buscar no existe", code: 400 });
    }
  }

  async actualizar(req, res) {
    if (
      req.body.hasOwnProperty("titulo") &&
      req.body.hasOwnProperty("cuerpo") &&
      req.body.hasOwnProperty("fecha") &&
      req.body.hasOwnProperty("tipo_noticia") &&
      req.body.hasOwnProperty("archivo") &&
      req.body.hasOwnProperty("persona")
    ) {
      const external = req.params.external;
      var noticiaEncontrada = await noticia.findOne({
        where: { external_id: external },
      });
      if (noticiaEncontrada == undefined || noticiaEncontrada == null) {
        res.status(400);
        res.json({
          msg: "ERROR",
          tag: "External id incorrecto",
          code: 400,
        });
      } else {
        var uuid = require("uuid");
        var perA = await models.persona.findOne({
          where: { external_id: req.body.persona },
          include: [
            {
              model: models.rol,
              as: models.rol,
              attributes: ["nombre"],
            },
          ],
        });
        if (perA == undefined || perA == null) {
          res.status(401);
          res.json({
            msg: "ERROR",
            tag: "No se encontro el editor",
            code: 401,
          });
        } else {
          if (perA.rol.nombre == "editor") {
            if (validarObjetoLleno(data) == false) {
              res.status(400);
              res.json({ msg: "Error", tag: "Datos incompletos", code: 400 });
            } else {
              var data = {
                cuerpo: req.body.cuerpo,
                titulo: req.body.titulo,
                fecha: req.body.fecha,
                tipo_noticia: req.body.tipo_noticia,
                persona_id: perA.external_id,
                estado: req.body.estado,
                archivo: req.body.archivo,
              };
              await noticia.update(
                {
                  cuerpo: data.cuerpo,
                  titulo: data.titulo,
                  fecha: data.fecha,
                  tipo_noticia: data.tipo_noticia,
                  persona_id: perA.id,
                  external_id: uuid.v4(),
                  estado: data.estado,
                  archivo: data.archivo,
                },
                {
                  where: { external_id: external },
                }
              );
            }
            perA.external_id = uuid.v4();
            await perA.save();
            res.status(200);
            res.json({ msg: "Actualizado", code: 200, datos: data });
          } else {
            res.status(400);
            res.json({
              msg: "ERROR",
              tag: "La persona que quiere ingresar no es editor",
              code: 401,
            });
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

  async guardarFoto(req, res) {
    // const externalId = req.params.external;
    var form = new formidable.IncomingForm(),
      files = [];
    form
      .on("file", function (field, file) {
        files.push(file);
      })
      .on("end", function () {
        console.log("OK");
      });

    form.parse(req, function (err, fields) {
      let listado = files;
      // let external = fields.external[0];
      for (let index = 0; index < listado.length; index++) {
        var file = listado[index];
        var tamanioFile = file.size;
        // console.log('FILEE '+ file.size);
        var nameCompleted = file.originalFilename;
        //console.log('NOMBRE ARCHIVO ', NAME)
        var extension = file.originalFilename.split(".").pop().toLowerCase();
        if (extensiones.includes(extension)) {
          if (tamanioFile < 2000000) {

            const name = nameCompleted ;
            // console.log("EXTENSION  ", extension);
            fs.rename(
              file.filepath,
              "public/multimedia/" + name,
              async function (err) {
                if (err) {
                  res.status(200);
                  res.json({
                    msg: "ERROR",
                    tag: "No se pudo guardar el archivo",
                    code: 200,
                  });
                } else {
                  // var data = {
                  //   archivo: nameCompleted,
                  // };
                  // // await noticia.update(
                  // //   {
                  // //     archivo: data.archivo,
                  // //     // external_id: uuid.v4()
                  // //   },
                  // //   {
                  // //     where: {
                  // //       external_id: externalId,
                  // //     },
                  // //   }
                  // // );
                  res.status(200);
                  res.json({ msg: "OK", tag: "Archivo guardado", code: 200 });
                }
              }
            );
          } else {
            res.status(400);
            res.json({
              msg: "ERROR",
              tag: "No se pudo guardar, excede 2Mb",
              code: 400,
            });
          }
        } else {
          res.status(400);
          res.json({ msg: "ERROR", tag: "Formato no aceptado", code: 400 });
        }
      }
    });
  }
}

module.exports = NoticiaControl;
