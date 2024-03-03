function validarObjetoLleno(objeto) {
    for (const clave in objeto) {
      if (
        objeto.hasOwnProperty(clave) &&
        (objeto[clave] === undefined ||
          objeto[clave] === null ||
          objeto[clave] === "")
      ) {
        return false; // Si alguna propiedad está vacía, retorna falso
      }
    }
    return true; // Todas las propiedades están llenas
}

module.exports = { validarObjetoLleno };