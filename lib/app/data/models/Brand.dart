class Brand {
  int? id;
  String? name;
  String? svgLogo;

  Brand({ this.id, this.name, this.svgLogo });

  factory Brand.fromJon(Map<String, dynamic> json){
    return Brand(
      id: json['id'],
      name: json['name'],
      svgLogo: json['svg_logo'],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'name': name,
      'svg_logo': svgLogo, 
    };
  }
}