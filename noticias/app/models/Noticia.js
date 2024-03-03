"use strict";

module.exports = (sequelize, DataTypes) => {
  const noticia = sequelize.define(
    "noticia",
    {
      titulo: { type: DataTypes.STRING(100) },
      archivo: { type: DataTypes.STRING },
      tipo_archivo: {type: DataTypes.ENUM(['VIDEO', 'IMAGEN']), defaultValue: "IMAGEN"},
      tipo_noticia: {type: DataTypes.ENUM(['NORMAL', 'FLASH', 'DEPORTIVA', 'POLITICA', 'CULTURAL', 'CIENTIFICA']), defaultValue: "NORMAL"},
      cuerpo: { type: DataTypes.STRING },
      fecha: { type: DataTypes.DATEONLY },
      estado: {type: DataTypes.BOOLEAN, defaultValue: true},
      external_id: { type: DataTypes.UUID, defaultValue: DataTypes.UUIDV4 },
    },
    { timestamps: false, freezeTableName: true }
  );
  noticia.associate = function (models) {
    noticia.belongsTo(models.persona, {
      foreignKey: 'persona_id'
    });
    noticia.hasMany(models.comentario, {
      as: "pertenece_noticia",
      foreignKey: "noticia_id",
    });

  };

  return noticia;
};
