class Comida{
  int? id;//es opcion por que sera auto incrementable
  String plato;
  String tipo;
  String pais;
  int calificacion;
  String descripcion;

  Comida({
    this.id,
    required this.plato,
    required this.tipo,
    required this.pais,
    required this.calificacion,
    required this.descripcion
  });
  //convertir de map a objeto
  factory Comida.fromMap(Map<String,dynamic> json){
    return Comida(
      plato: json['plato'], 
      tipo:  json['tipo'],
      pais:  json['pais'],
      calificacion:json['calificacion'],
      descripcion:json['descripcion'],
    );
  }
  //convertir de objeto a map {}
  
  Map<String,dynamic> toMap(){
    return {
      'id':id,
      'plato': plato,
      'tipo':tipo,
      'pais': pais,
      'calificacion':calificacion,
      'descripcion':descripcion,
    };
  }
}