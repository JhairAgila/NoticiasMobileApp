var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express' });
});

router.get('/hola/:name/:apellido', function(req, res, next) {
  console.log(req.params); //<==== capture params
  
  res.send({"data": "holaaaa"});
  // res.render('index', { title: 'Express' });
});


router.post('/hola', function(req, res, next) {
  console.log(res.params); //<==== capture params
  // console.log(req.body);
  res.send({"dataaa": "holaaaa"});
  // res.render('index', { title: 'Express' });
});


module.exports = router;
