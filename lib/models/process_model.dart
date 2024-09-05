/*
// Example JSON data (from API or Firestore)
Map<String, dynamic> jsonData = {
  "id": "process_1",
  "name": "Example Process",
  "dateCreated": 1633036800000, // Example timestamp
  // Other fields...
};

// Create an instance from JSON
ProcessData processData = ProcessData.fromJson(jsonData);

// Serialize the instance back to JSON
Map<String, dynamic> serializedData = processData.toJson();
 */

import 'add_ons.dart';

class ProcessData {
  String? path;
  String? id;
  String? name;
  String? desc;
  String? processOwner;
  String? estCycleTime;
  String? estCycleType;
  String? ownerPath;
  String? ownerEmail;
  String? owner;
  String? createdBy;
  DateTime? dateCreated;
  String? changeFrom;
  bool? parent;
  String? processType;
  String? status;
  String? parentId;
  String? processStep;
  List<AddOns> addOns = [AddOns()];
  num? usedOnCount;
  String? rev;
  String? ver;
  num? iteration;
  DateTime? createDate;
  String? objectState;
  num? day;
  num? hour;
  num? minute;
  num? startDay;
  String? versionPath;
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
  int? parkingLotIndex;
  String? resourceId;
  String? buildState;
  DateTime? startBuild;
  DateTime? endBuild;
  DateTime? releaseDate;
  String? buildNotes;
  String? usedOnPath;
  String? masterPath;
  String? version;
  double? estCost;
  String? inputsTypes;
  String? conditionsTypes;
  String? outputsTypes;
  String? businessTypes;
  String? performerTypes;
  String? requirementsTypes;
  String? lifecyclesTypes;
  String? measurementsTypes;
  String? knowledgeTypes;
  String? equipmentTypes;
  String? systemTypes;
  String? toolTypes;
  String? informationTypes;
  String? image;
  String? vault;
  String? vaultFileName;
  String? url;
  String? urlLabel;
  DateTime? dueDate;
  String? processVersion;
  int? nodeColor;
  int? nodeTextColor;
  String? offSheet;

  ProcessData({
    this.path,
    this.id,
    this.name,
    this.desc,
    this.processOwner,
    this.estCycleTime,
    this.estCycleType,
    this.ownerPath,
    this.ownerEmail,
    this.owner,
    this.createdBy,
    this.dateCreated,
    this.changeFrom,
    this.parent,
    this.processType,
    this.status,
    this.parentId,
    this.processStep,
    required this.addOns,
    this.usedOnCount,
    this.rev,
    this.ver,
    this.iteration,
    this.createDate,
    this.objectState,
    this.day,
    this.hour,
    this.minute,
    this.startDay,
    this.versionPath,
    this.udf1,
    this.udf2,
    this.udf3,
    this.udf4,
    this.udf5,
    this.udf6,
    this.udf7,
    this.udf8,
    this.udf9,
    this.udf10,
    this.parkingLotIndex,
    this.resourceId,
    this.buildState,
    this.startBuild,
    this.endBuild,
    this.releaseDate,
    this.buildNotes,
    this.usedOnPath,
    this.masterPath,
    this.version,
    this.estCost,
    this.inputsTypes,
    this.conditionsTypes,
    this.outputsTypes,
    this.businessTypes,
    this.performerTypes,
    this.requirementsTypes,
    this.lifecyclesTypes,
    this.measurementsTypes,
    this.knowledgeTypes,
    this.equipmentTypes,
    this.systemTypes,
    this.toolTypes,
    this.informationTypes,
    this.image,
    this.vault,
    this.vaultFileName,
    this.url,
    this.urlLabel,
    this.dueDate,
    this.processVersion,
    this.nodeColor,
    this.nodeTextColor,
    this.offSheet,
  });

  // Factory constructor to create an instance from JSON
  factory ProcessData.fromJson(Map<String, dynamic> json) {
    return ProcessData(
      path: json['path'],
      id: json['id'],
      name: json['name'],
      desc: json['desc'],
      processOwner: json['processOwner'],
      estCycleTime: json['estCycleTime'],
      estCycleType: json['estCycleType'],
      ownerPath: json['ownerPath'],
      ownerEmail: json['ownerEmail'],
      owner: json['owner'],
      createdBy: json['createdBy'],
      dateCreated: json['dateCreated'] != null ? DateTime.fromMillisecondsSinceEpoch(json['dateCreated']) : null,
      changeFrom: json['changeFrom'],
      parent: json['parent'],
      processType: json['processType'],
      status: json['status'],
      parentId: json['parentId'],
      processStep: json['processStep'],
      usedOnCount: json['usedOnCount'],
      rev: json['rev'],
      ver: json['ver'],
      iteration: json['iteration'],
      createDate: json['createDate'] != null ? DateTime.fromMillisecondsSinceEpoch(json['createDate']) : null,
      objectState: json['objectState'],
      day: json['day'],
      hour: json['hour'],
      minute: json['minute'],
      startDay: json['startDay'],
      versionPath: json['versionPath'],
      udf1: json['udf1'],
      udf2: json['udf2'],
      udf3: json['udf3'],
      udf4: json['udf4'],
      udf5: json['udf5'],
      udf6: json['udf6'],
      udf7: json['udf7'],
      udf8: json['udf8'],
      udf9: json['udf9'] != null ? DateTime.fromMillisecondsSinceEpoch(json['udf9']) : null,
      udf10: json['udf10'] != null ? DateTime.fromMillisecondsSinceEpoch(json['udf10']) : null,
      parkingLotIndex: json['parkingLotIndex'],
      resourceId: json['resourceId'],
      buildState: json['buildState'],
      startBuild: json['startBuild'] != null ? DateTime.fromMillisecondsSinceEpoch(json['startBuild']) : null,
      endBuild: json['endBuild'] != null ? DateTime.fromMillisecondsSinceEpoch(json['endBuild']) : null,
      releaseDate: json['releaseDate'] != null ? DateTime.fromMillisecondsSinceEpoch(json['releaseDate']) : null,
      buildNotes: json['buildNotes'],
      usedOnPath: json['usedOnPath'],
      masterPath: json['masterPath'],
      version: json['version'],
      estCost: (json['estCost'] as num?)?.toDouble(),
      inputsTypes: json['inputsTypes'],
      conditionsTypes: json['conditionsTypes'],
      outputsTypes: json['outputsTypes'],
      businessTypes: json['businessTypes'],
      performerTypes: json['performerTypes'],
      requirementsTypes: json['requirementsTypes'],
      lifecyclesTypes: json['lifecyclesTypes'],
      measurementsTypes: json['measurementsTypes'],
      knowledgeTypes: json['knowledgeTypes'],
      equipmentTypes: json['equipmentTypes'],
      systemTypes: json['systemTypes'],
      toolTypes: json['toolTypes'],
      informationTypes: json['informationTypes'],
      image: json['image'],
      vault: json['vault'],
      vaultFileName: json['vaultFileName'],
      url: json['url'],
      urlLabel: json['urlLabel'],
      dueDate: json['dueDate'] != null ? DateTime.fromMillisecondsSinceEpoch(json['dueDate']) : null,
      processVersion: json['processVersion'],
      nodeColor: json['nodeColor'],
      nodeTextColor: json['nodeTextColor'],
      offSheet: json['offSheet'],
      addOns: json['addOns'] != null
          ? (json['addOns'] as List).map((e) => AddOns.fromJson(e)).toList()
          : [],
    );
  }

  // Method to serialize the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'id': id,
      'name': name,
      'desc': desc,
      'processOwner': processOwner,
      'estCycleTime': estCycleTime,
      'estCycleType': estCycleType,
      'ownerPath': ownerPath,
      'ownerEmail': ownerEmail,
      'owner': owner,
      'createdBy': createdBy,
      'dateCreated': dateCreated?.millisecondsSinceEpoch,
      'changeFrom': changeFrom,
      'parent': parent,
      'processType': processType,
      'status': status,
      'parentId': parentId,
      'processStep': processStep,
      'addOns': addOns?.map((e) => e.toJson()).toList(),
      'usedOnCount': usedOnCount,
      'rev': rev,
      'ver': ver,
      'iteration': iteration,
      'createDate': createDate?.millisecondsSinceEpoch,
      'objectState': objectState,
      'day': day,
      'hour': hour,
      'minute': minute,
      'startDay': startDay,
      'versionPath': versionPath,
      'udf1': udf1,
      'udf2': udf2,
      'udf3': udf3,
      'udf4': udf4,
      'udf5': udf5,
      'udf6': udf6,
      'udf7': udf7,
      'udf8': udf8,
      'udf9': udf9?.millisecondsSinceEpoch,
      'udf10': udf10?.millisecondsSinceEpoch,
      'parkingLotIndex': parkingLotIndex,
      'resourceId': resourceId,
      'buildState': buildState,
      'startBuild': startBuild?.millisecondsSinceEpoch,
      'endBuild': endBuild?.millisecondsSinceEpoch,
      'releaseDate': releaseDate?.millisecondsSinceEpoch,
      'buildNotes': buildNotes,
      'usedOnPath': usedOnPath,
      'masterPath': masterPath,
      'version': version,
      'estCost': estCost,
      'inputsTypes': inputsTypes,
      'conditionsTypes': conditionsTypes,
      'outputsTypes': outputsTypes,
      'businessTypes': businessTypes,
      'performerTypes': performerTypes,
      'requirementsTypes': requirementsTypes,
      'lifecyclesTypes': lifecyclesTypes,
      'measurementsTypes': measurementsTypes,
      'knowledgeTypes': knowledgeTypes,
      'equipmentTypes': equipmentTypes,
      'systemTypes': systemTypes,
      'toolTypes': toolTypes,
      'informationTypes': informationTypes,
      'image': image,
      'vault': vault,
      'vaultFileName': vaultFileName,
      'url': url,
      'urlLabel': urlLabel,
      'dueDate': dueDate?.millisecondsSinceEpoch,
      'processVersion': processVersion,
      'nodeColor': nodeColor,
      'nodeTextColor': nodeTextColor,
      'offSheet': offSheet,
    };
  }
}
