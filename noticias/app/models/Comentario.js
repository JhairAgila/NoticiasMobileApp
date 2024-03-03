"use strict";


module.exports = ( 
    sequelize, DataTypes ) => {
        const comentario = sequelize.define('comentario', {
            cuerpo: {type: DataTypes.STRING},
            estado: {type: DataTypes.BOOLEAN, defaultValue: true},
            // fecha: {type: DataTypes.DATEONLY},
            longitud : {type: DataTypes.STRING},
            latitud: {type: DataTypes.STRING},
            external_id: {type: DataTypes.UUID, defaultValue: DataTypes.UUIDV4}
        }, {timestamps: true, freezeTableName: true});

        comentario.associate = function(models) {
            comentario.belongsTo(models.noticia, {
                foreignKey: "noticia_id"
            });
            comentario.belongsTo(models.persona, {
                foreignKey: "id_persona"
            });
        }   
        return comentario;
    }