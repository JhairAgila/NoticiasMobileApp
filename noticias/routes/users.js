var express = require('express');
let jwt = require("jsonwebtoken");
var router = express.Router();
const personaC = require('../app/controllers/PersonaControl');
let PersonaControl = new personaC();

const CredencialesControl  = require('../app/controllers/CredencialesControl')
let credencialC = new CredencialesControl();

const rolC = require('../app/controllers/RolControl');
let rolControl = new rolC();

const cuentaC = require('../app/controllers/CuentaControl');
let cuentaControl = new cuentaC();

const noticiaC = require('../app/controllers/NoticiaControl');
let noticiaControl = new noticiaC();


const comentarioC = require('../app/controllers/ComentarioControl');
let comentarioControl = new comentarioC();
//middleware
//TODO: Validar el rol para la practica
const auth = function middleware(req, res, next){
  const token = req.headers['news-token'];
  if( token === undefined){
    res.status(400);
    res.json({ msg: "ERROR", code: 400, error_msg: "FALTA TOKEN"});
  }else{
    require("dotenv").config();
    const key = process.env.KEY_JWT;
    jwt.verify(token, key, async(err, dec) => {
      if(err){
        res.status(400);
        res.json({ msg: "ERROR", code: 400, error_msg: "Token no valido o expirado"});
      }else{
        const models = require('../app/models');
        const cuenta = models.cuenta;
        const aux = await cuenta.findOne({
          where: {
            external_id: dec.external
          }
        });
        if(aux == null){
          res.status(401);
          res.json({ msg: "ERROR", code: 400, error_msg: "Token no valido!"});
        }else{
          next();
        }
      }
    });
    
  }
}


/* GET users listing. */
router.get('/', function(req, res, next) {
  res.send('respond with a resource');
});
//Credenciales
router.post('/admin/login', credencialC.inicio_sesion);

//api personas
router.get('/admin/personas', auth, PersonaControl.listar);
router.get('/admin/persona/get/:external', auth, PersonaControl.obtener);
router.post('/admin/persona/save', auth, PersonaControl.guardar);
router.post('/admin/persona/saveUser', auth, PersonaControl.guardarUser);
router.post('/admin/bandearUsuario/:external', auth, PersonaControl.bandearUsuario);
router.post('/admin/persona/actualizar/:external', auth, PersonaControl.actualizar);
//api rol
router.get('/admin/rol', rolControl.listar);
router.get('/admin/rol/get/:external', rolControl.obtener);
router.post('/admin/rol/save', rolControl.guardar);
//api cuenta
router.get('/admin/cuenta', cuentaControl.listar);
router.post('/admin/cuenta/save', cuentaControl.guardar);

//noticia
router.get('/noticias', noticiaControl.listar);
router.get('/noticiasActivas/', auth, noticiaControl.obtenerNoticiasActivas);
router.get('/noticias/get/:external', auth, noticiaControl.obtener);
router.post('/admin/noticias/save', auth, noticiaControl.guardar);
router.post('/admin/noticias/actualizar/:external', noticiaControl.actualizar);
router.post('/admin/noticias/file/save/', noticiaControl.guardarFoto);

//Comentarios 
router.post('/comentario', auth, comentarioControl.guardar);
router.get('/comentario/getAll', auth, comentarioControl.listar);
router.get('/comentario/get/:external', auth, comentarioControl.obtenerComentario);
router.put('/comentario/actualizar/:external', auth, comentarioControl.actualizarComentario);
router.delete('/comentario/eliminar/:external', auth, comentarioControl.eliminarComentario);
module.exports = router;
