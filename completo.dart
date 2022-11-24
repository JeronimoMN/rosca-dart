import 'dart:html';
import 'dart:collection';

void main() {
  var rosco = Rosco();
  var primeraDefinicion = rosco.obtenerPregunta(
      true); //Con true estamos diciendo que nos va a devolver la primera pregunta

  document.querySelector("#pregunta")?.text = primeraDefinicion?.definicion;
  document.querySelector("#letra")?.text = primeraDefinicion?.letra;

  querySelector("#btnEnviar")!.onClick.listen((event) {
    //Capturar un evento OnClick de un boton
    var respuesta = (querySelector("#textRespuesta") as InputElement)
        .value; //Con query tomamos el valor que viene en el elemento de text respuesta y despues lo estamos conviertiendo a un InputElement, para obtener el value del input
    var letra = querySelector("#letra")!.text;

    String mensaje = rosco.evaluarRespuesta(letra!, respuesta!);

    var nuevaPregunta = rosco.obtenerPregunta(false);
    actualizarUI(nuevaPregunta!);
    print(mensaje);
  });
  document.querySelector("#btnPasapalabra")?.onClick.listen((event) {
    var nuevaPregunta =
        rosco.pasaPalabra(document.querySelector("#letra")!.text);
    actualizarUI(nuevaPregunta);
  });
}

void actualizarUI(Pregunta pregunta) {
  querySelector("#letra")?.text = pregunta.letra;
  querySelector("#pregunta")?.text = pregunta.definicion;
  querySelector("#textRespuesta")?.text = "";
}

class Rosco {
  late ListQueue<Pregunta> roscoPreguntas = ListQueue<
      Pregunta>(); //<> Dentro de los brakes va a estar el tipo de dato que queremos que almacena la lista, Ahora actualizamos por un nuevo tipo y es ListQueue, el cual tenemos que intanciarlo.
  List<String> respuestas = [];
  List<String> pasadas = [];

  Rosco() {
    roscoPreguntas.addAll(RoscoApi().obtenerRoscos());
  }

  Pregunta? obtenerPregunta(
      bool
          inicial) //Nos va a devolver el objeto Pregunta, debido que vamos a obtener una pregunta
  {
    if (inicial) return roscoPreguntas.first;
    var siguientePregunta = roscoPreguntas
        .firstWhere((rosco) => !respuestas.any((x) => x == rosco.letra));
    return siguientePregunta;
  }

  Pregunta pasaPalabra(
      String letraActual) //Nos va a pasar a la siguiente palabra
  {
    var siguientePregunta = roscoPreguntas.firstWhere((rosco) =>
        !(rosco.letra == letraActual) && !pasadas.any((x) => x == rosco.letra));

    //if(siguientePregunta == null){
    //  pasadas = [];
    //  return pasaPalabra("");
    //}

    //pasadas.add(letraActual);
    return siguientePregunta;
  }

  String evaluarRespuesta(
      String letra,
      String
          respuesta) //String para mostrar que la palabra es correcta o incorrecta
  {
    var pregunta = roscoPreguntas.firstWhere(
        (rosco) => //Devuelve la pregunta, contrario a any, que devuelve true o false
            rosco.letra ==
            letra); //rosco es cualquier variable, toma el elemento de la lista y sus datos, es decir, se almacena los datos. Con any buscamos coincidencias en roscoPreguntas, es decir, si letra es igual al parametro de entrada, así mismo con respuesa. //Otra forma de declarar una función Arrow function

    respuestas.add(pregunta.letra);

    print(respuestas);
    return pregunta.respuesta == respuesta
        ? "Letra $letra respuesta correcta"
        : "Letra $letra respuesta incorrecta";
  }
}

class Pregunta {
  String letra;
  String definicion;
  String respuesta;

  Pregunta(this.letra, this.definicion, this.respuesta);
}

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

class Db {
  static List<String> letras = const ["A", "B", "C", "D", "E", "F"];
  static List<String> definiciones = const [
    "Persona que tripula una Astronave o que esta entrenada para este trabajo",
    "Especie de Talega o Saco de tela y otro material que sirve para llevar o guardar algo",
    "Aparato destinado a registrar imágenes animadas para el cine o la tv",
    "Obra literaria escrita para ser representada",
    "Que se prolonga muchisimo o excesivamente",
    "Laboratorio y despacho del farmaceutico"
  ];
  static List respuestas = [
    "Astronauta",
    "Bolsa",
    "Camara",
    "Drama",
    "Eterno",
    "Farmacia"
  ];
}
