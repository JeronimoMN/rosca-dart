import 'Db.dart';
import 'Pregunta.dart';

class RoscoApi {
  late List<Pregunta> roscoPreguntas = [];

  List<Pregunta> obtenerRoscos() {
    for (var i in Db.letras) {
      //Estamos recorriendo cada dato en la lista de letras
      var index = Db.letras.indexOf(
          i); //indexOf() Tomamos la posicion del primer dato y la almacenamos en index
      var roscoPregunta = Pregunta(
          i,
          Db.definiciones[index],
          Db.respuestas[
              index]); //Instancia de pregunta. i:iteracipn, def[index]
      roscoPreguntas.add(
          roscoPregunta); //Agrega la instancia a la lista de roscaPreguntas
    }
    return roscoPreguntas;
  }
}
