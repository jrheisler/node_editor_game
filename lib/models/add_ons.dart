class AddOns {
  String? id;
  String? path;
  String? name;
  String? usedOnPath;
  String? masterPath;
  String? subType;
  String? description;
  String? image;
  String? vault;
  String? url;
  String? urlLabel;
  String? vaultFileName;
  String? udf1;
  String? udf2;
  String? udf3;
  String? udf4;
  String? udf5;
  String? udf6;
  bool? udf7;
  bool? udf8;
  DateTime? udf9;
  DateTime? udf10;
  String? rev;
  String? ver;
  String? versionPath;
  String? pocName;
  String? pocPhone;
  String? pocEmail;

  AddOns({
    this.id = '',
    this.path = '',
    this.name = '',
    this.usedOnPath = '',
    this.masterPath = '',
    this.subType = '',
    this.description = '',
    this.image = '',
    this.vault = '',
    this.url = '',
    this.urlLabel = '',
    this.vaultFileName = '',
    this.udf1 = '',
    this.udf2 = '',
    this.udf3 = '',
    this.udf4 = '',
    this.udf5 = '',
    this.udf6 = '',
    this.udf7 = false,
    this.udf8 = false,
    this.udf9,
    this.udf10,
    this.rev = '',
    this.ver = '',
    this.versionPath = '',
    this.pocName = '',
    this.pocPhone = '',
    this.pocEmail = '',
  });

  // Factory constructor to create an instance from JSON
  factory AddOns.fromJson(Map<String, dynamic> json) {
    return AddOns(
      id: json['id'],
      path: json['path'],
      name: json['name'],
      usedOnPath: json['usedOnPath'],
      masterPath: json['masterPath'],
      subType: json['subType'],
      description: json['description'],
      image: json['image'],
      vault: json['vault'],
      url: json['url'],
      urlLabel: json['urlLabel'],
      vaultFileName: json['vaultFileName'],
      udf1: json['udf1'],
      udf2: json['udf2'],
      udf3: json['udf3'],
      udf4: json['udf4'],
      udf5: json['udf5'],
      udf6: json['udf6'],
      udf7: json['udf7'],
      udf8: json['udf8'],
      udf9: json['udf9'] != null ? DateTime.parse(json['udf9']) : null,
      udf10: json['udf10'] != null ? DateTime.parse(json['udf10']) : null,
      rev: json['rev'],
      ver: json['ver'],
      versionPath: json['versionPath'],
      pocName: json['pocName'],
      pocPhone: json['pocPhone'],
      pocEmail: json['pocEmail'],
    );
  }

  // Method to serialize the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'path': path,
      'name': name,
      'usedOnPath': usedOnPath,
      'masterPath': masterPath,
      'subType': subType,
      'description': description,
      'image': image,
      'vault': vault,
      'url': url,
      'urlLabel': urlLabel,
      'vaultFileName': vaultFileName,
      'udf1': udf1,
      'udf2': udf2,
      'udf3': udf3,
      'udf4': udf4,
      'udf5': udf5,
      'udf6': udf6,
      'udf7': udf7,
      'udf8': udf8,
      'udf9': udf9?.toIso8601String(),
      'udf10': udf10?.toIso8601String(),
      'rev': rev,
      'ver': ver,
      'versionPath': versionPath,
      'pocName': pocName,
      'pocPhone': pocPhone,
      'pocEmail': pocEmail,
    };
  }
}
