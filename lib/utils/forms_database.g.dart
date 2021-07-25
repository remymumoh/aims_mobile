// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forms_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class DbForm extends DataClass implements Insertable<DbForm> {
  final String id;
  final String form_name;
  final String section_names;
  final String data_content;
  final String updated_by;
  final String date_created;
  final String date_updated;
  final String user_location;
  final String imei;
  final String server_id;
  final bool synced;
  final String facility;
  final String dateOfSurvey;
  final String processType;
  final String initiator;
  final bool submittedToTeamLead;
  final String leadId;
  final bool reviewedByLead;
  final bool leadAccepted;
  final String leadComments;
  final String rfcId;
  final bool reviewedByRfc;
  final bool rfcAccepted;
  final String rfcComments;
  final String satelliteLeadId;
  final bool reviewedBySatelliteLead;
  final bool satelliteLeadAccepted;
  final String satelliteLeadComments;
  final String ethicsId;
  final bool reviewedByEthics;
  final bool ethicsAccepted;
  final String ethicsComments;
  final String techLeadId;
  final bool reviewedByTechLead;
  final bool techLeadAccepted;
  final String techLeadComments;
  final String ethicsAssistantId;
  final bool reviewedByEthicsAssistant;
  final bool ethicsAssistantAccepted;
  final String ethicsAssistantComments;
  final String projectLeadId;
  final bool reviewedByProjectLead;
  final bool projectLeadReturned;
  final String projectLeadComments;
  DbForm(
      {@required this.id,
      this.form_name,
      this.section_names,
      @required this.data_content,
      this.updated_by,
      this.date_created,
      this.date_updated,
      this.user_location,
      this.imei,
      this.server_id,
      this.synced,
      this.facility,
      this.dateOfSurvey,
      this.processType,
      this.initiator,
      this.submittedToTeamLead,
      this.leadId,
      this.reviewedByLead,
      this.leadAccepted,
      this.leadComments,
      this.rfcId,
      this.reviewedByRfc,
      this.rfcAccepted,
      this.rfcComments,
      this.satelliteLeadId,
      this.reviewedBySatelliteLead,
      this.satelliteLeadAccepted,
      this.satelliteLeadComments,
      this.ethicsId,
      this.reviewedByEthics,
      this.ethicsAccepted,
      this.ethicsComments,
      this.techLeadId,
      this.reviewedByTechLead,
      this.techLeadAccepted,
      this.techLeadComments,
      this.ethicsAssistantId,
      this.reviewedByEthicsAssistant,
      this.ethicsAssistantAccepted,
      this.ethicsAssistantComments,
      this.projectLeadId,
      this.reviewedByProjectLead,
      this.projectLeadReturned,
      this.projectLeadComments});
  factory DbForm.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    return DbForm(
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      form_name: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}form_name']),
      section_names: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}section_names']),
      data_content: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}data_content']),
      updated_by: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_by']),
      date_created: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}date_created']),
      date_updated: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}date_updated']),
      user_location: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}user_location']),
      imei: stringType.mapFromDatabaseResponse(data['${effectivePrefix}imei']),
      server_id: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}server_id']),
      synced:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}synced']),
      facility: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}facility']),
      dateOfSurvey: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}date_of_survey']),
      processType: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}process_type']),
      initiator: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}initiator']),
      submittedToTeamLead: boolType.mapFromDatabaseResponse(
          data['${effectivePrefix}submitted_to_team_lead']),
      leadId:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}lead_id']),
      reviewedByLead: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}reviewed_by_lead']),
      leadAccepted: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}lead_accepted']),
      leadComments: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}lead_comments']),
      rfcId:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}rfc_id']),
      reviewedByRfc: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}reviewed_by_rfc']),
      rfcAccepted: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}rfc_accepted']),
      rfcComments: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}rfc_comments']),
      satelliteLeadId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}satellite_lead_id']),
      reviewedBySatelliteLead: boolType.mapFromDatabaseResponse(
          data['${effectivePrefix}reviewed_by_satellite_lead']),
      satelliteLeadAccepted: boolType.mapFromDatabaseResponse(
          data['${effectivePrefix}satellite_lead_accepted']),
      satelliteLeadComments: stringType.mapFromDatabaseResponse(
          data['${effectivePrefix}satellite_lead_comments']),
      ethicsId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}ethics_id']),
      reviewedByEthics: boolType.mapFromDatabaseResponse(
          data['${effectivePrefix}reviewed_by_ethics']),
      ethicsAccepted: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}ethics_accepted']),
      ethicsComments: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}ethics_comments']),
      techLeadId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}tech_lead_id']),
      reviewedByTechLead: boolType.mapFromDatabaseResponse(
          data['${effectivePrefix}reviewed_by_tech_lead']),
      techLeadAccepted: boolType.mapFromDatabaseResponse(
          data['${effectivePrefix}tech_lead_accepted']),
      techLeadComments: stringType.mapFromDatabaseResponse(
          data['${effectivePrefix}tech_lead_comments']),
      ethicsAssistantId: stringType.mapFromDatabaseResponse(
          data['${effectivePrefix}ethics_assistant_id']),
      reviewedByEthicsAssistant: boolType.mapFromDatabaseResponse(
          data['${effectivePrefix}reviewed_by_ethics_assistant']),
      ethicsAssistantAccepted: boolType.mapFromDatabaseResponse(
          data['${effectivePrefix}ethics_assistant_accepted']),
      ethicsAssistantComments: stringType.mapFromDatabaseResponse(
          data['${effectivePrefix}ethics_assistant_comments']),
      projectLeadId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}project_lead_id']),
      reviewedByProjectLead: boolType.mapFromDatabaseResponse(
          data['${effectivePrefix}reviewed_by_project_lead']),
      projectLeadReturned: boolType.mapFromDatabaseResponse(
          data['${effectivePrefix}project_lead_returned']),
      projectLeadComments: stringType.mapFromDatabaseResponse(
          data['${effectivePrefix}project_lead_comments']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<String>(id);
    }
    if (!nullToAbsent || form_name != null) {
      map['form_name'] = Variable<String>(form_name);
    }
    if (!nullToAbsent || section_names != null) {
      map['section_names'] = Variable<String>(section_names);
    }
    if (!nullToAbsent || data_content != null) {
      map['data_content'] = Variable<String>(data_content);
    }
    if (!nullToAbsent || updated_by != null) {
      map['updated_by'] = Variable<String>(updated_by);
    }
    if (!nullToAbsent || date_created != null) {
      map['date_created'] = Variable<String>(date_created);
    }
    if (!nullToAbsent || date_updated != null) {
      map['date_updated'] = Variable<String>(date_updated);
    }
    if (!nullToAbsent || user_location != null) {
      map['user_location'] = Variable<String>(user_location);
    }
    if (!nullToAbsent || imei != null) {
      map['imei'] = Variable<String>(imei);
    }
    if (!nullToAbsent || server_id != null) {
      map['server_id'] = Variable<String>(server_id);
    }
    if (!nullToAbsent || synced != null) {
      map['synced'] = Variable<bool>(synced);
    }
    if (!nullToAbsent || facility != null) {
      map['facility'] = Variable<String>(facility);
    }
    if (!nullToAbsent || dateOfSurvey != null) {
      map['date_of_survey'] = Variable<String>(dateOfSurvey);
    }
    if (!nullToAbsent || processType != null) {
      map['process_type'] = Variable<String>(processType);
    }
    if (!nullToAbsent || initiator != null) {
      map['initiator'] = Variable<String>(initiator);
    }
    if (!nullToAbsent || submittedToTeamLead != null) {
      map['submitted_to_team_lead'] = Variable<bool>(submittedToTeamLead);
    }
    if (!nullToAbsent || leadId != null) {
      map['lead_id'] = Variable<String>(leadId);
    }
    if (!nullToAbsent || reviewedByLead != null) {
      map['reviewed_by_lead'] = Variable<bool>(reviewedByLead);
    }
    if (!nullToAbsent || leadAccepted != null) {
      map['lead_accepted'] = Variable<bool>(leadAccepted);
    }
    if (!nullToAbsent || leadComments != null) {
      map['lead_comments'] = Variable<String>(leadComments);
    }
    if (!nullToAbsent || rfcId != null) {
      map['rfc_id'] = Variable<String>(rfcId);
    }
    if (!nullToAbsent || reviewedByRfc != null) {
      map['reviewed_by_rfc'] = Variable<bool>(reviewedByRfc);
    }
    if (!nullToAbsent || rfcAccepted != null) {
      map['rfc_accepted'] = Variable<bool>(rfcAccepted);
    }
    if (!nullToAbsent || rfcComments != null) {
      map['rfc_comments'] = Variable<String>(rfcComments);
    }
    if (!nullToAbsent || satelliteLeadId != null) {
      map['satellite_lead_id'] = Variable<String>(satelliteLeadId);
    }
    if (!nullToAbsent || reviewedBySatelliteLead != null) {
      map['reviewed_by_satellite_lead'] =
          Variable<bool>(reviewedBySatelliteLead);
    }
    if (!nullToAbsent || satelliteLeadAccepted != null) {
      map['satellite_lead_accepted'] = Variable<bool>(satelliteLeadAccepted);
    }
    if (!nullToAbsent || satelliteLeadComments != null) {
      map['satellite_lead_comments'] = Variable<String>(satelliteLeadComments);
    }
    if (!nullToAbsent || ethicsId != null) {
      map['ethics_id'] = Variable<String>(ethicsId);
    }
    if (!nullToAbsent || reviewedByEthics != null) {
      map['reviewed_by_ethics'] = Variable<bool>(reviewedByEthics);
    }
    if (!nullToAbsent || ethicsAccepted != null) {
      map['ethics_accepted'] = Variable<bool>(ethicsAccepted);
    }
    if (!nullToAbsent || ethicsComments != null) {
      map['ethics_comments'] = Variable<String>(ethicsComments);
    }
    if (!nullToAbsent || techLeadId != null) {
      map['tech_lead_id'] = Variable<String>(techLeadId);
    }
    if (!nullToAbsent || reviewedByTechLead != null) {
      map['reviewed_by_tech_lead'] = Variable<bool>(reviewedByTechLead);
    }
    if (!nullToAbsent || techLeadAccepted != null) {
      map['tech_lead_accepted'] = Variable<bool>(techLeadAccepted);
    }
    if (!nullToAbsent || techLeadComments != null) {
      map['tech_lead_comments'] = Variable<String>(techLeadComments);
    }
    if (!nullToAbsent || ethicsAssistantId != null) {
      map['ethics_assistant_id'] = Variable<String>(ethicsAssistantId);
    }
    if (!nullToAbsent || reviewedByEthicsAssistant != null) {
      map['reviewed_by_ethics_assistant'] =
          Variable<bool>(reviewedByEthicsAssistant);
    }
    if (!nullToAbsent || ethicsAssistantAccepted != null) {
      map['ethics_assistant_accepted'] =
          Variable<bool>(ethicsAssistantAccepted);
    }
    if (!nullToAbsent || ethicsAssistantComments != null) {
      map['ethics_assistant_comments'] =
          Variable<String>(ethicsAssistantComments);
    }
    if (!nullToAbsent || projectLeadId != null) {
      map['project_lead_id'] = Variable<String>(projectLeadId);
    }
    if (!nullToAbsent || reviewedByProjectLead != null) {
      map['reviewed_by_project_lead'] = Variable<bool>(reviewedByProjectLead);
    }
    if (!nullToAbsent || projectLeadReturned != null) {
      map['project_lead_returned'] = Variable<bool>(projectLeadReturned);
    }
    if (!nullToAbsent || projectLeadComments != null) {
      map['project_lead_comments'] = Variable<String>(projectLeadComments);
    }
    return map;
  }

  FormsCompanion toCompanion(bool nullToAbsent) {
    return FormsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      form_name: form_name == null && nullToAbsent
          ? const Value.absent()
          : Value(form_name),
      section_names: section_names == null && nullToAbsent
          ? const Value.absent()
          : Value(section_names),
      data_content: data_content == null && nullToAbsent
          ? const Value.absent()
          : Value(data_content),
      updated_by: updated_by == null && nullToAbsent
          ? const Value.absent()
          : Value(updated_by),
      date_created: date_created == null && nullToAbsent
          ? const Value.absent()
          : Value(date_created),
      date_updated: date_updated == null && nullToAbsent
          ? const Value.absent()
          : Value(date_updated),
      user_location: user_location == null && nullToAbsent
          ? const Value.absent()
          : Value(user_location),
      imei: imei == null && nullToAbsent ? const Value.absent() : Value(imei),
      server_id: server_id == null && nullToAbsent
          ? const Value.absent()
          : Value(server_id),
      synced:
          synced == null && nullToAbsent ? const Value.absent() : Value(synced),
      facility: facility == null && nullToAbsent
          ? const Value.absent()
          : Value(facility),
      dateOfSurvey: dateOfSurvey == null && nullToAbsent
          ? const Value.absent()
          : Value(dateOfSurvey),
      processType: processType == null && nullToAbsent
          ? const Value.absent()
          : Value(processType),
      initiator: initiator == null && nullToAbsent
          ? const Value.absent()
          : Value(initiator),
      submittedToTeamLead: submittedToTeamLead == null && nullToAbsent
          ? const Value.absent()
          : Value(submittedToTeamLead),
      leadId:
          leadId == null && nullToAbsent ? const Value.absent() : Value(leadId),
      reviewedByLead: reviewedByLead == null && nullToAbsent
          ? const Value.absent()
          : Value(reviewedByLead),
      leadAccepted: leadAccepted == null && nullToAbsent
          ? const Value.absent()
          : Value(leadAccepted),
      leadComments: leadComments == null && nullToAbsent
          ? const Value.absent()
          : Value(leadComments),
      rfcId:
          rfcId == null && nullToAbsent ? const Value.absent() : Value(rfcId),
      reviewedByRfc: reviewedByRfc == null && nullToAbsent
          ? const Value.absent()
          : Value(reviewedByRfc),
      rfcAccepted: rfcAccepted == null && nullToAbsent
          ? const Value.absent()
          : Value(rfcAccepted),
      rfcComments: rfcComments == null && nullToAbsent
          ? const Value.absent()
          : Value(rfcComments),
      satelliteLeadId: satelliteLeadId == null && nullToAbsent
          ? const Value.absent()
          : Value(satelliteLeadId),
      reviewedBySatelliteLead: reviewedBySatelliteLead == null && nullToAbsent
          ? const Value.absent()
          : Value(reviewedBySatelliteLead),
      satelliteLeadAccepted: satelliteLeadAccepted == null && nullToAbsent
          ? const Value.absent()
          : Value(satelliteLeadAccepted),
      satelliteLeadComments: satelliteLeadComments == null && nullToAbsent
          ? const Value.absent()
          : Value(satelliteLeadComments),
      ethicsId: ethicsId == null && nullToAbsent
          ? const Value.absent()
          : Value(ethicsId),
      reviewedByEthics: reviewedByEthics == null && nullToAbsent
          ? const Value.absent()
          : Value(reviewedByEthics),
      ethicsAccepted: ethicsAccepted == null && nullToAbsent
          ? const Value.absent()
          : Value(ethicsAccepted),
      ethicsComments: ethicsComments == null && nullToAbsent
          ? const Value.absent()
          : Value(ethicsComments),
      techLeadId: techLeadId == null && nullToAbsent
          ? const Value.absent()
          : Value(techLeadId),
      reviewedByTechLead: reviewedByTechLead == null && nullToAbsent
          ? const Value.absent()
          : Value(reviewedByTechLead),
      techLeadAccepted: techLeadAccepted == null && nullToAbsent
          ? const Value.absent()
          : Value(techLeadAccepted),
      techLeadComments: techLeadComments == null && nullToAbsent
          ? const Value.absent()
          : Value(techLeadComments),
      ethicsAssistantId: ethicsAssistantId == null && nullToAbsent
          ? const Value.absent()
          : Value(ethicsAssistantId),
      reviewedByEthicsAssistant:
          reviewedByEthicsAssistant == null && nullToAbsent
              ? const Value.absent()
              : Value(reviewedByEthicsAssistant),
      ethicsAssistantAccepted: ethicsAssistantAccepted == null && nullToAbsent
          ? const Value.absent()
          : Value(ethicsAssistantAccepted),
      ethicsAssistantComments: ethicsAssistantComments == null && nullToAbsent
          ? const Value.absent()
          : Value(ethicsAssistantComments),
      projectLeadId: projectLeadId == null && nullToAbsent
          ? const Value.absent()
          : Value(projectLeadId),
      reviewedByProjectLead: reviewedByProjectLead == null && nullToAbsent
          ? const Value.absent()
          : Value(reviewedByProjectLead),
      projectLeadReturned: projectLeadReturned == null && nullToAbsent
          ? const Value.absent()
          : Value(projectLeadReturned),
      projectLeadComments: projectLeadComments == null && nullToAbsent
          ? const Value.absent()
          : Value(projectLeadComments),
    );
  }

  factory DbForm.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return DbForm(
      id: serializer.fromJson<String>(json['id']),
      form_name: serializer.fromJson<String>(json['form_name']),
      section_names: serializer.fromJson<String>(json['section_names']),
      data_content: serializer.fromJson<String>(json['data_content']),
      updated_by: serializer.fromJson<String>(json['updated_by']),
      date_created: serializer.fromJson<String>(json['date_created']),
      date_updated: serializer.fromJson<String>(json['date_updated']),
      user_location: serializer.fromJson<String>(json['user_location']),
      imei: serializer.fromJson<String>(json['imei']),
      server_id: serializer.fromJson<String>(json['server_id']),
      synced: serializer.fromJson<bool>(json['synced']),
      facility: serializer.fromJson<String>(json['facility']),
      dateOfSurvey: serializer.fromJson<String>(json['dateOfSurvey']),
      processType: serializer.fromJson<String>(json['processType']),
      initiator: serializer.fromJson<String>(json['initiator']),
      submittedToTeamLead:
          serializer.fromJson<bool>(json['submittedToTeamLead']),
      leadId: serializer.fromJson<String>(json['leadId']),
      reviewedByLead: serializer.fromJson<bool>(json['reviewedByLead']),
      leadAccepted: serializer.fromJson<bool>(json['leadAccepted']),
      leadComments: serializer.fromJson<String>(json['leadComments']),
      rfcId: serializer.fromJson<String>(json['rfcId']),
      reviewedByRfc: serializer.fromJson<bool>(json['reviewedByRfc']),
      rfcAccepted: serializer.fromJson<bool>(json['rfcAccepted']),
      rfcComments: serializer.fromJson<String>(json['rfcComments']),
      satelliteLeadId: serializer.fromJson<String>(json['satelliteLeadId']),
      reviewedBySatelliteLead:
          serializer.fromJson<bool>(json['reviewedBySatelliteLead']),
      satelliteLeadAccepted:
          serializer.fromJson<bool>(json['satelliteLeadAccepted']),
      satelliteLeadComments:
          serializer.fromJson<String>(json['satelliteLeadComments']),
      ethicsId: serializer.fromJson<String>(json['ethicsId']),
      reviewedByEthics: serializer.fromJson<bool>(json['reviewedByEthics']),
      ethicsAccepted: serializer.fromJson<bool>(json['ethicsAccepted']),
      ethicsComments: serializer.fromJson<String>(json['ethicsComments']),
      techLeadId: serializer.fromJson<String>(json['techLeadId']),
      reviewedByTechLead: serializer.fromJson<bool>(json['reviewedByTechLead']),
      techLeadAccepted: serializer.fromJson<bool>(json['techLeadAccepted']),
      techLeadComments: serializer.fromJson<String>(json['techLeadComments']),
      ethicsAssistantId: serializer.fromJson<String>(json['ethicsAssistantId']),
      reviewedByEthicsAssistant:
          serializer.fromJson<bool>(json['reviewedByEthicsAssistant']),
      ethicsAssistantAccepted:
          serializer.fromJson<bool>(json['ethicsAssistantAccepted']),
      ethicsAssistantComments:
          serializer.fromJson<String>(json['ethicsAssistantComments']),
      projectLeadId: serializer.fromJson<String>(json['projectLeadId']),
      reviewedByProjectLead:
          serializer.fromJson<bool>(json['reviewedByProjectLead']),
      projectLeadReturned:
          serializer.fromJson<bool>(json['projectLeadReturned']),
      projectLeadComments:
          serializer.fromJson<String>(json['projectLeadComments']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'form_name': serializer.toJson<String>(form_name),
      'section_names': serializer.toJson<String>(section_names),
      'data_content': serializer.toJson<String>(data_content),
      'updated_by': serializer.toJson<String>(updated_by),
      'date_created': serializer.toJson<String>(date_created),
      'date_updated': serializer.toJson<String>(date_updated),
      'user_location': serializer.toJson<String>(user_location),
      'imei': serializer.toJson<String>(imei),
      'server_id': serializer.toJson<String>(server_id),
      'synced': serializer.toJson<bool>(synced),
      'facility': serializer.toJson<String>(facility),
      'dateOfSurvey': serializer.toJson<String>(dateOfSurvey),
      'processType': serializer.toJson<String>(processType),
      'initiator': serializer.toJson<String>(initiator),
      'submittedToTeamLead': serializer.toJson<bool>(submittedToTeamLead),
      'leadId': serializer.toJson<String>(leadId),
      'reviewedByLead': serializer.toJson<bool>(reviewedByLead),
      'leadAccepted': serializer.toJson<bool>(leadAccepted),
      'leadComments': serializer.toJson<String>(leadComments),
      'rfcId': serializer.toJson<String>(rfcId),
      'reviewedByRfc': serializer.toJson<bool>(reviewedByRfc),
      'rfcAccepted': serializer.toJson<bool>(rfcAccepted),
      'rfcComments': serializer.toJson<String>(rfcComments),
      'satelliteLeadId': serializer.toJson<String>(satelliteLeadId),
      'reviewedBySatelliteLead':
          serializer.toJson<bool>(reviewedBySatelliteLead),
      'satelliteLeadAccepted': serializer.toJson<bool>(satelliteLeadAccepted),
      'satelliteLeadComments': serializer.toJson<String>(satelliteLeadComments),
      'ethicsId': serializer.toJson<String>(ethicsId),
      'reviewedByEthics': serializer.toJson<bool>(reviewedByEthics),
      'ethicsAccepted': serializer.toJson<bool>(ethicsAccepted),
      'ethicsComments': serializer.toJson<String>(ethicsComments),
      'techLeadId': serializer.toJson<String>(techLeadId),
      'reviewedByTechLead': serializer.toJson<bool>(reviewedByTechLead),
      'techLeadAccepted': serializer.toJson<bool>(techLeadAccepted),
      'techLeadComments': serializer.toJson<String>(techLeadComments),
      'ethicsAssistantId': serializer.toJson<String>(ethicsAssistantId),
      'reviewedByEthicsAssistant':
          serializer.toJson<bool>(reviewedByEthicsAssistant),
      'ethicsAssistantAccepted':
          serializer.toJson<bool>(ethicsAssistantAccepted),
      'ethicsAssistantComments':
          serializer.toJson<String>(ethicsAssistantComments),
      'projectLeadId': serializer.toJson<String>(projectLeadId),
      'reviewedByProjectLead': serializer.toJson<bool>(reviewedByProjectLead),
      'projectLeadReturned': serializer.toJson<bool>(projectLeadReturned),
      'projectLeadComments': serializer.toJson<String>(projectLeadComments),
    };
  }

  DbForm copyWith(
          {String id,
          String form_name,
          String section_names,
          String data_content,
          String updated_by,
          String date_created,
          String date_updated,
          String user_location,
          String imei,
          String server_id,
          bool synced,
          String facility,
          String dateOfSurvey,
          String processType,
          String initiator,
          bool submittedToTeamLead,
          String leadId,
          bool reviewedByLead,
          bool leadAccepted,
          String leadComments,
          String rfcId,
          bool reviewedByRfc,
          bool rfcAccepted,
          String rfcComments,
          String satelliteLeadId,
          bool reviewedBySatelliteLead,
          bool satelliteLeadAccepted,
          String satelliteLeadComments,
          String ethicsId,
          bool reviewedByEthics,
          bool ethicsAccepted,
          String ethicsComments,
          String techLeadId,
          bool reviewedByTechLead,
          bool techLeadAccepted,
          String techLeadComments,
          String ethicsAssistantId,
          bool reviewedByEthicsAssistant,
          bool ethicsAssistantAccepted,
          String ethicsAssistantComments,
          String projectLeadId,
          bool reviewedByProjectLead,
          bool projectLeadReturned,
          String projectLeadComments}) =>
      DbForm(
        id: id ?? this.id,
        form_name: form_name ?? this.form_name,
        section_names: section_names ?? this.section_names,
        data_content: data_content ?? this.data_content,
        updated_by: updated_by ?? this.updated_by,
        date_created: date_created ?? this.date_created,
        date_updated: date_updated ?? this.date_updated,
        user_location: user_location ?? this.user_location,
        imei: imei ?? this.imei,
        server_id: server_id ?? this.server_id,
        synced: synced ?? this.synced,
        facility: facility ?? this.facility,
        dateOfSurvey: dateOfSurvey ?? this.dateOfSurvey,
        processType: processType ?? this.processType,
        initiator: initiator ?? this.initiator,
        submittedToTeamLead: submittedToTeamLead ?? this.submittedToTeamLead,
        leadId: leadId ?? this.leadId,
        reviewedByLead: reviewedByLead ?? this.reviewedByLead,
        leadAccepted: leadAccepted ?? this.leadAccepted,
        leadComments: leadComments ?? this.leadComments,
        rfcId: rfcId ?? this.rfcId,
        reviewedByRfc: reviewedByRfc ?? this.reviewedByRfc,
        rfcAccepted: rfcAccepted ?? this.rfcAccepted,
        rfcComments: rfcComments ?? this.rfcComments,
        satelliteLeadId: satelliteLeadId ?? this.satelliteLeadId,
        reviewedBySatelliteLead:
            reviewedBySatelliteLead ?? this.reviewedBySatelliteLead,
        satelliteLeadAccepted:
            satelliteLeadAccepted ?? this.satelliteLeadAccepted,
        satelliteLeadComments:
            satelliteLeadComments ?? this.satelliteLeadComments,
        ethicsId: ethicsId ?? this.ethicsId,
        reviewedByEthics: reviewedByEthics ?? this.reviewedByEthics,
        ethicsAccepted: ethicsAccepted ?? this.ethicsAccepted,
        ethicsComments: ethicsComments ?? this.ethicsComments,
        techLeadId: techLeadId ?? this.techLeadId,
        reviewedByTechLead: reviewedByTechLead ?? this.reviewedByTechLead,
        techLeadAccepted: techLeadAccepted ?? this.techLeadAccepted,
        techLeadComments: techLeadComments ?? this.techLeadComments,
        ethicsAssistantId: ethicsAssistantId ?? this.ethicsAssistantId,
        reviewedByEthicsAssistant:
            reviewedByEthicsAssistant ?? this.reviewedByEthicsAssistant,
        ethicsAssistantAccepted:
            ethicsAssistantAccepted ?? this.ethicsAssistantAccepted,
        ethicsAssistantComments:
            ethicsAssistantComments ?? this.ethicsAssistantComments,
        projectLeadId: projectLeadId ?? this.projectLeadId,
        reviewedByProjectLead:
            reviewedByProjectLead ?? this.reviewedByProjectLead,
        projectLeadReturned: projectLeadReturned ?? this.projectLeadReturned,
        projectLeadComments: projectLeadComments ?? this.projectLeadComments,
      );
  @override
  String toString() {
    return (StringBuffer('DbForm(')
          ..write('id: $id, ')
          ..write('form_name: $form_name, ')
          ..write('section_names: $section_names, ')
          ..write('data_content: $data_content, ')
          ..write('updated_by: $updated_by, ')
          ..write('date_created: $date_created, ')
          ..write('date_updated: $date_updated, ')
          ..write('user_location: $user_location, ')
          ..write('imei: $imei, ')
          ..write('server_id: $server_id, ')
          ..write('synced: $synced, ')
          ..write('facility: $facility, ')
          ..write('dateOfSurvey: $dateOfSurvey, ')
          ..write('processType: $processType, ')
          ..write('initiator: $initiator, ')
          ..write('submittedToTeamLead: $submittedToTeamLead, ')
          ..write('leadId: $leadId, ')
          ..write('reviewedByLead: $reviewedByLead, ')
          ..write('leadAccepted: $leadAccepted, ')
          ..write('leadComments: $leadComments, ')
          ..write('rfcId: $rfcId, ')
          ..write('reviewedByRfc: $reviewedByRfc, ')
          ..write('rfcAccepted: $rfcAccepted, ')
          ..write('rfcComments: $rfcComments, ')
          ..write('satelliteLeadId: $satelliteLeadId, ')
          ..write('reviewedBySatelliteLead: $reviewedBySatelliteLead, ')
          ..write('satelliteLeadAccepted: $satelliteLeadAccepted, ')
          ..write('satelliteLeadComments: $satelliteLeadComments, ')
          ..write('ethicsId: $ethicsId, ')
          ..write('reviewedByEthics: $reviewedByEthics, ')
          ..write('ethicsAccepted: $ethicsAccepted, ')
          ..write('ethicsComments: $ethicsComments, ')
          ..write('techLeadId: $techLeadId, ')
          ..write('reviewedByTechLead: $reviewedByTechLead, ')
          ..write('techLeadAccepted: $techLeadAccepted, ')
          ..write('techLeadComments: $techLeadComments, ')
          ..write('ethicsAssistantId: $ethicsAssistantId, ')
          ..write('reviewedByEthicsAssistant: $reviewedByEthicsAssistant, ')
          ..write('ethicsAssistantAccepted: $ethicsAssistantAccepted, ')
          ..write('ethicsAssistantComments: $ethicsAssistantComments, ')
          ..write('projectLeadId: $projectLeadId, ')
          ..write('reviewedByProjectLead: $reviewedByProjectLead, ')
          ..write('projectLeadReturned: $projectLeadReturned, ')
          ..write('projectLeadComments: $projectLeadComments')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          form_name.hashCode,
          $mrjc(
              section_names.hashCode,
              $mrjc(
                  data_content.hashCode,
                  $mrjc(
                      updated_by.hashCode,
                      $mrjc(
                          date_created.hashCode,
                          $mrjc(
                              date_updated.hashCode,
                              $mrjc(
                                  user_location.hashCode,
                                  $mrjc(
                                      imei.hashCode,
                                      $mrjc(
                                          server_id.hashCode,
                                          $mrjc(
                                              synced.hashCode,
                                              $mrjc(
                                                  facility.hashCode,
                                                  $mrjc(
                                                      dateOfSurvey.hashCode,
                                                      $mrjc(
                                                          processType.hashCode,
                                                          $mrjc(
                                                              initiator
                                                                  .hashCode,
                                                              $mrjc(
                                                                  submittedToTeamLead
                                                                      .hashCode,
                                                                  $mrjc(
                                                                      leadId
                                                                          .hashCode,
                                                                      $mrjc(
                                                                          reviewedByLead
                                                                              .hashCode,
                                                                          $mrjc(
                                                                              leadAccepted.hashCode,
                                                                              $mrjc(leadComments.hashCode, $mrjc(rfcId.hashCode, $mrjc(reviewedByRfc.hashCode, $mrjc(rfcAccepted.hashCode, $mrjc(rfcComments.hashCode, $mrjc(satelliteLeadId.hashCode, $mrjc(reviewedBySatelliteLead.hashCode, $mrjc(satelliteLeadAccepted.hashCode, $mrjc(satelliteLeadComments.hashCode, $mrjc(ethicsId.hashCode, $mrjc(reviewedByEthics.hashCode, $mrjc(ethicsAccepted.hashCode, $mrjc(ethicsComments.hashCode, $mrjc(techLeadId.hashCode, $mrjc(reviewedByTechLead.hashCode, $mrjc(techLeadAccepted.hashCode, $mrjc(techLeadComments.hashCode, $mrjc(ethicsAssistantId.hashCode, $mrjc(reviewedByEthicsAssistant.hashCode, $mrjc(ethicsAssistantAccepted.hashCode, $mrjc(ethicsAssistantComments.hashCode, $mrjc(projectLeadId.hashCode, $mrjc(reviewedByProjectLead.hashCode, $mrjc(projectLeadReturned.hashCode, projectLeadComments.hashCode))))))))))))))))))))))))))))))))))))))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is DbForm &&
          other.id == this.id &&
          other.form_name == this.form_name &&
          other.section_names == this.section_names &&
          other.data_content == this.data_content &&
          other.updated_by == this.updated_by &&
          other.date_created == this.date_created &&
          other.date_updated == this.date_updated &&
          other.user_location == this.user_location &&
          other.imei == this.imei &&
          other.server_id == this.server_id &&
          other.synced == this.synced &&
          other.facility == this.facility &&
          other.dateOfSurvey == this.dateOfSurvey &&
          other.processType == this.processType &&
          other.initiator == this.initiator &&
          other.submittedToTeamLead == this.submittedToTeamLead &&
          other.leadId == this.leadId &&
          other.reviewedByLead == this.reviewedByLead &&
          other.leadAccepted == this.leadAccepted &&
          other.leadComments == this.leadComments &&
          other.rfcId == this.rfcId &&
          other.reviewedByRfc == this.reviewedByRfc &&
          other.rfcAccepted == this.rfcAccepted &&
          other.rfcComments == this.rfcComments &&
          other.satelliteLeadId == this.satelliteLeadId &&
          other.reviewedBySatelliteLead == this.reviewedBySatelliteLead &&
          other.satelliteLeadAccepted == this.satelliteLeadAccepted &&
          other.satelliteLeadComments == this.satelliteLeadComments &&
          other.ethicsId == this.ethicsId &&
          other.reviewedByEthics == this.reviewedByEthics &&
          other.ethicsAccepted == this.ethicsAccepted &&
          other.ethicsComments == this.ethicsComments &&
          other.techLeadId == this.techLeadId &&
          other.reviewedByTechLead == this.reviewedByTechLead &&
          other.techLeadAccepted == this.techLeadAccepted &&
          other.techLeadComments == this.techLeadComments &&
          other.ethicsAssistantId == this.ethicsAssistantId &&
          other.reviewedByEthicsAssistant == this.reviewedByEthicsAssistant &&
          other.ethicsAssistantAccepted == this.ethicsAssistantAccepted &&
          other.ethicsAssistantComments == this.ethicsAssistantComments &&
          other.projectLeadId == this.projectLeadId &&
          other.reviewedByProjectLead == this.reviewedByProjectLead &&
          other.projectLeadReturned == this.projectLeadReturned &&
          other.projectLeadComments == this.projectLeadComments);
}

class FormsCompanion extends UpdateCompanion<DbForm> {
  final Value<String> id;
  final Value<String> form_name;
  final Value<String> section_names;
  final Value<String> data_content;
  final Value<String> updated_by;
  final Value<String> date_created;
  final Value<String> date_updated;
  final Value<String> user_location;
  final Value<String> imei;
  final Value<String> server_id;
  final Value<bool> synced;
  final Value<String> facility;
  final Value<String> dateOfSurvey;
  final Value<String> processType;
  final Value<String> initiator;
  final Value<bool> submittedToTeamLead;
  final Value<String> leadId;
  final Value<bool> reviewedByLead;
  final Value<bool> leadAccepted;
  final Value<String> leadComments;
  final Value<String> rfcId;
  final Value<bool> reviewedByRfc;
  final Value<bool> rfcAccepted;
  final Value<String> rfcComments;
  final Value<String> satelliteLeadId;
  final Value<bool> reviewedBySatelliteLead;
  final Value<bool> satelliteLeadAccepted;
  final Value<String> satelliteLeadComments;
  final Value<String> ethicsId;
  final Value<bool> reviewedByEthics;
  final Value<bool> ethicsAccepted;
  final Value<String> ethicsComments;
  final Value<String> techLeadId;
  final Value<bool> reviewedByTechLead;
  final Value<bool> techLeadAccepted;
  final Value<String> techLeadComments;
  final Value<String> ethicsAssistantId;
  final Value<bool> reviewedByEthicsAssistant;
  final Value<bool> ethicsAssistantAccepted;
  final Value<String> ethicsAssistantComments;
  final Value<String> projectLeadId;
  final Value<bool> reviewedByProjectLead;
  final Value<bool> projectLeadReturned;
  final Value<String> projectLeadComments;
  const FormsCompanion({
    this.id = const Value.absent(),
    this.form_name = const Value.absent(),
    this.section_names = const Value.absent(),
    this.data_content = const Value.absent(),
    this.updated_by = const Value.absent(),
    this.date_created = const Value.absent(),
    this.date_updated = const Value.absent(),
    this.user_location = const Value.absent(),
    this.imei = const Value.absent(),
    this.server_id = const Value.absent(),
    this.synced = const Value.absent(),
    this.facility = const Value.absent(),
    this.dateOfSurvey = const Value.absent(),
    this.processType = const Value.absent(),
    this.initiator = const Value.absent(),
    this.submittedToTeamLead = const Value.absent(),
    this.leadId = const Value.absent(),
    this.reviewedByLead = const Value.absent(),
    this.leadAccepted = const Value.absent(),
    this.leadComments = const Value.absent(),
    this.rfcId = const Value.absent(),
    this.reviewedByRfc = const Value.absent(),
    this.rfcAccepted = const Value.absent(),
    this.rfcComments = const Value.absent(),
    this.satelliteLeadId = const Value.absent(),
    this.reviewedBySatelliteLead = const Value.absent(),
    this.satelliteLeadAccepted = const Value.absent(),
    this.satelliteLeadComments = const Value.absent(),
    this.ethicsId = const Value.absent(),
    this.reviewedByEthics = const Value.absent(),
    this.ethicsAccepted = const Value.absent(),
    this.ethicsComments = const Value.absent(),
    this.techLeadId = const Value.absent(),
    this.reviewedByTechLead = const Value.absent(),
    this.techLeadAccepted = const Value.absent(),
    this.techLeadComments = const Value.absent(),
    this.ethicsAssistantId = const Value.absent(),
    this.reviewedByEthicsAssistant = const Value.absent(),
    this.ethicsAssistantAccepted = const Value.absent(),
    this.ethicsAssistantComments = const Value.absent(),
    this.projectLeadId = const Value.absent(),
    this.reviewedByProjectLead = const Value.absent(),
    this.projectLeadReturned = const Value.absent(),
    this.projectLeadComments = const Value.absent(),
  });
  FormsCompanion.insert({
    @required String id,
    this.form_name = const Value.absent(),
    this.section_names = const Value.absent(),
    @required String data_content,
    this.updated_by = const Value.absent(),
    this.date_created = const Value.absent(),
    this.date_updated = const Value.absent(),
    this.user_location = const Value.absent(),
    this.imei = const Value.absent(),
    this.server_id = const Value.absent(),
    this.synced = const Value.absent(),
    this.facility = const Value.absent(),
    this.dateOfSurvey = const Value.absent(),
    this.processType = const Value.absent(),
    this.initiator = const Value.absent(),
    this.submittedToTeamLead = const Value.absent(),
    this.leadId = const Value.absent(),
    this.reviewedByLead = const Value.absent(),
    this.leadAccepted = const Value.absent(),
    this.leadComments = const Value.absent(),
    this.rfcId = const Value.absent(),
    this.reviewedByRfc = const Value.absent(),
    this.rfcAccepted = const Value.absent(),
    this.rfcComments = const Value.absent(),
    this.satelliteLeadId = const Value.absent(),
    this.reviewedBySatelliteLead = const Value.absent(),
    this.satelliteLeadAccepted = const Value.absent(),
    this.satelliteLeadComments = const Value.absent(),
    this.ethicsId = const Value.absent(),
    this.reviewedByEthics = const Value.absent(),
    this.ethicsAccepted = const Value.absent(),
    this.ethicsComments = const Value.absent(),
    this.techLeadId = const Value.absent(),
    this.reviewedByTechLead = const Value.absent(),
    this.techLeadAccepted = const Value.absent(),
    this.techLeadComments = const Value.absent(),
    this.ethicsAssistantId = const Value.absent(),
    this.reviewedByEthicsAssistant = const Value.absent(),
    this.ethicsAssistantAccepted = const Value.absent(),
    this.ethicsAssistantComments = const Value.absent(),
    this.projectLeadId = const Value.absent(),
    this.reviewedByProjectLead = const Value.absent(),
    this.projectLeadReturned = const Value.absent(),
    this.projectLeadComments = const Value.absent(),
  })  : id = Value(id),
        data_content = Value(data_content);
  static Insertable<DbForm> custom({
    Expression<String> id,
    Expression<String> form_name,
    Expression<String> section_names,
    Expression<String> data_content,
    Expression<String> updated_by,
    Expression<String> date_created,
    Expression<String> date_updated,
    Expression<String> user_location,
    Expression<String> imei,
    Expression<String> server_id,
    Expression<bool> synced,
    Expression<String> facility,
    Expression<String> dateOfSurvey,
    Expression<String> processType,
    Expression<String> initiator,
    Expression<bool> submittedToTeamLead,
    Expression<String> leadId,
    Expression<bool> reviewedByLead,
    Expression<bool> leadAccepted,
    Expression<String> leadComments,
    Expression<String> rfcId,
    Expression<bool> reviewedByRfc,
    Expression<bool> rfcAccepted,
    Expression<String> rfcComments,
    Expression<String> satelliteLeadId,
    Expression<bool> reviewedBySatelliteLead,
    Expression<bool> satelliteLeadAccepted,
    Expression<String> satelliteLeadComments,
    Expression<String> ethicsId,
    Expression<bool> reviewedByEthics,
    Expression<bool> ethicsAccepted,
    Expression<String> ethicsComments,
    Expression<String> techLeadId,
    Expression<bool> reviewedByTechLead,
    Expression<bool> techLeadAccepted,
    Expression<String> techLeadComments,
    Expression<String> ethicsAssistantId,
    Expression<bool> reviewedByEthicsAssistant,
    Expression<bool> ethicsAssistantAccepted,
    Expression<String> ethicsAssistantComments,
    Expression<String> projectLeadId,
    Expression<bool> reviewedByProjectLead,
    Expression<bool> projectLeadReturned,
    Expression<String> projectLeadComments,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (form_name != null) 'form_name': form_name,
      if (section_names != null) 'section_names': section_names,
      if (data_content != null) 'data_content': data_content,
      if (updated_by != null) 'updated_by': updated_by,
      if (date_created != null) 'date_created': date_created,
      if (date_updated != null) 'date_updated': date_updated,
      if (user_location != null) 'user_location': user_location,
      if (imei != null) 'imei': imei,
      if (server_id != null) 'server_id': server_id,
      if (synced != null) 'synced': synced,
      if (facility != null) 'facility': facility,
      if (dateOfSurvey != null) 'date_of_survey': dateOfSurvey,
      if (processType != null) 'process_type': processType,
      if (initiator != null) 'initiator': initiator,
      if (submittedToTeamLead != null)
        'submitted_to_team_lead': submittedToTeamLead,
      if (leadId != null) 'lead_id': leadId,
      if (reviewedByLead != null) 'reviewed_by_lead': reviewedByLead,
      if (leadAccepted != null) 'lead_accepted': leadAccepted,
      if (leadComments != null) 'lead_comments': leadComments,
      if (rfcId != null) 'rfc_id': rfcId,
      if (reviewedByRfc != null) 'reviewed_by_rfc': reviewedByRfc,
      if (rfcAccepted != null) 'rfc_accepted': rfcAccepted,
      if (rfcComments != null) 'rfc_comments': rfcComments,
      if (satelliteLeadId != null) 'satellite_lead_id': satelliteLeadId,
      if (reviewedBySatelliteLead != null)
        'reviewed_by_satellite_lead': reviewedBySatelliteLead,
      if (satelliteLeadAccepted != null)
        'satellite_lead_accepted': satelliteLeadAccepted,
      if (satelliteLeadComments != null)
        'satellite_lead_comments': satelliteLeadComments,
      if (ethicsId != null) 'ethics_id': ethicsId,
      if (reviewedByEthics != null) 'reviewed_by_ethics': reviewedByEthics,
      if (ethicsAccepted != null) 'ethics_accepted': ethicsAccepted,
      if (ethicsComments != null) 'ethics_comments': ethicsComments,
      if (techLeadId != null) 'tech_lead_id': techLeadId,
      if (reviewedByTechLead != null)
        'reviewed_by_tech_lead': reviewedByTechLead,
      if (techLeadAccepted != null) 'tech_lead_accepted': techLeadAccepted,
      if (techLeadComments != null) 'tech_lead_comments': techLeadComments,
      if (ethicsAssistantId != null) 'ethics_assistant_id': ethicsAssistantId,
      if (reviewedByEthicsAssistant != null)
        'reviewed_by_ethics_assistant': reviewedByEthicsAssistant,
      if (ethicsAssistantAccepted != null)
        'ethics_assistant_accepted': ethicsAssistantAccepted,
      if (ethicsAssistantComments != null)
        'ethics_assistant_comments': ethicsAssistantComments,
      if (projectLeadId != null) 'project_lead_id': projectLeadId,
      if (reviewedByProjectLead != null)
        'reviewed_by_project_lead': reviewedByProjectLead,
      if (projectLeadReturned != null)
        'project_lead_returned': projectLeadReturned,
      if (projectLeadComments != null)
        'project_lead_comments': projectLeadComments,
    });
  }

  FormsCompanion copyWith(
      {Value<String> id,
      Value<String> form_name,
      Value<String> section_names,
      Value<String> data_content,
      Value<String> updated_by,
      Value<String> date_created,
      Value<String> date_updated,
      Value<String> user_location,
      Value<String> imei,
      Value<String> server_id,
      Value<bool> synced,
      Value<String> facility,
      Value<String> dateOfSurvey,
      Value<String> processType,
      Value<String> initiator,
      Value<bool> submittedToTeamLead,
      Value<String> leadId,
      Value<bool> reviewedByLead,
      Value<bool> leadAccepted,
      Value<String> leadComments,
      Value<String> rfcId,
      Value<bool> reviewedByRfc,
      Value<bool> rfcAccepted,
      Value<String> rfcComments,
      Value<String> satelliteLeadId,
      Value<bool> reviewedBySatelliteLead,
      Value<bool> satelliteLeadAccepted,
      Value<String> satelliteLeadComments,
      Value<String> ethicsId,
      Value<bool> reviewedByEthics,
      Value<bool> ethicsAccepted,
      Value<String> ethicsComments,
      Value<String> techLeadId,
      Value<bool> reviewedByTechLead,
      Value<bool> techLeadAccepted,
      Value<String> techLeadComments,
      Value<String> ethicsAssistantId,
      Value<bool> reviewedByEthicsAssistant,
      Value<bool> ethicsAssistantAccepted,
      Value<String> ethicsAssistantComments,
      Value<String> projectLeadId,
      Value<bool> reviewedByProjectLead,
      Value<bool> projectLeadReturned,
      Value<String> projectLeadComments}) {
    return FormsCompanion(
      id: id ?? this.id,
      form_name: form_name ?? this.form_name,
      section_names: section_names ?? this.section_names,
      data_content: data_content ?? this.data_content,
      updated_by: updated_by ?? this.updated_by,
      date_created: date_created ?? this.date_created,
      date_updated: date_updated ?? this.date_updated,
      user_location: user_location ?? this.user_location,
      imei: imei ?? this.imei,
      server_id: server_id ?? this.server_id,
      synced: synced ?? this.synced,
      facility: facility ?? this.facility,
      dateOfSurvey: dateOfSurvey ?? this.dateOfSurvey,
      processType: processType ?? this.processType,
      initiator: initiator ?? this.initiator,
      submittedToTeamLead: submittedToTeamLead ?? this.submittedToTeamLead,
      leadId: leadId ?? this.leadId,
      reviewedByLead: reviewedByLead ?? this.reviewedByLead,
      leadAccepted: leadAccepted ?? this.leadAccepted,
      leadComments: leadComments ?? this.leadComments,
      rfcId: rfcId ?? this.rfcId,
      reviewedByRfc: reviewedByRfc ?? this.reviewedByRfc,
      rfcAccepted: rfcAccepted ?? this.rfcAccepted,
      rfcComments: rfcComments ?? this.rfcComments,
      satelliteLeadId: satelliteLeadId ?? this.satelliteLeadId,
      reviewedBySatelliteLead:
          reviewedBySatelliteLead ?? this.reviewedBySatelliteLead,
      satelliteLeadAccepted:
          satelliteLeadAccepted ?? this.satelliteLeadAccepted,
      satelliteLeadComments:
          satelliteLeadComments ?? this.satelliteLeadComments,
      ethicsId: ethicsId ?? this.ethicsId,
      reviewedByEthics: reviewedByEthics ?? this.reviewedByEthics,
      ethicsAccepted: ethicsAccepted ?? this.ethicsAccepted,
      ethicsComments: ethicsComments ?? this.ethicsComments,
      techLeadId: techLeadId ?? this.techLeadId,
      reviewedByTechLead: reviewedByTechLead ?? this.reviewedByTechLead,
      techLeadAccepted: techLeadAccepted ?? this.techLeadAccepted,
      techLeadComments: techLeadComments ?? this.techLeadComments,
      ethicsAssistantId: ethicsAssistantId ?? this.ethicsAssistantId,
      reviewedByEthicsAssistant:
          reviewedByEthicsAssistant ?? this.reviewedByEthicsAssistant,
      ethicsAssistantAccepted:
          ethicsAssistantAccepted ?? this.ethicsAssistantAccepted,
      ethicsAssistantComments:
          ethicsAssistantComments ?? this.ethicsAssistantComments,
      projectLeadId: projectLeadId ?? this.projectLeadId,
      reviewedByProjectLead:
          reviewedByProjectLead ?? this.reviewedByProjectLead,
      projectLeadReturned: projectLeadReturned ?? this.projectLeadReturned,
      projectLeadComments: projectLeadComments ?? this.projectLeadComments,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (form_name.present) {
      map['form_name'] = Variable<String>(form_name.value);
    }
    if (section_names.present) {
      map['section_names'] = Variable<String>(section_names.value);
    }
    if (data_content.present) {
      map['data_content'] = Variable<String>(data_content.value);
    }
    if (updated_by.present) {
      map['updated_by'] = Variable<String>(updated_by.value);
    }
    if (date_created.present) {
      map['date_created'] = Variable<String>(date_created.value);
    }
    if (date_updated.present) {
      map['date_updated'] = Variable<String>(date_updated.value);
    }
    if (user_location.present) {
      map['user_location'] = Variable<String>(user_location.value);
    }
    if (imei.present) {
      map['imei'] = Variable<String>(imei.value);
    }
    if (server_id.present) {
      map['server_id'] = Variable<String>(server_id.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (facility.present) {
      map['facility'] = Variable<String>(facility.value);
    }
    if (dateOfSurvey.present) {
      map['date_of_survey'] = Variable<String>(dateOfSurvey.value);
    }
    if (processType.present) {
      map['process_type'] = Variable<String>(processType.value);
    }
    if (initiator.present) {
      map['initiator'] = Variable<String>(initiator.value);
    }
    if (submittedToTeamLead.present) {
      map['submitted_to_team_lead'] = Variable<bool>(submittedToTeamLead.value);
    }
    if (leadId.present) {
      map['lead_id'] = Variable<String>(leadId.value);
    }
    if (reviewedByLead.present) {
      map['reviewed_by_lead'] = Variable<bool>(reviewedByLead.value);
    }
    if (leadAccepted.present) {
      map['lead_accepted'] = Variable<bool>(leadAccepted.value);
    }
    if (leadComments.present) {
      map['lead_comments'] = Variable<String>(leadComments.value);
    }
    if (rfcId.present) {
      map['rfc_id'] = Variable<String>(rfcId.value);
    }
    if (reviewedByRfc.present) {
      map['reviewed_by_rfc'] = Variable<bool>(reviewedByRfc.value);
    }
    if (rfcAccepted.present) {
      map['rfc_accepted'] = Variable<bool>(rfcAccepted.value);
    }
    if (rfcComments.present) {
      map['rfc_comments'] = Variable<String>(rfcComments.value);
    }
    if (satelliteLeadId.present) {
      map['satellite_lead_id'] = Variable<String>(satelliteLeadId.value);
    }
    if (reviewedBySatelliteLead.present) {
      map['reviewed_by_satellite_lead'] =
          Variable<bool>(reviewedBySatelliteLead.value);
    }
    if (satelliteLeadAccepted.present) {
      map['satellite_lead_accepted'] =
          Variable<bool>(satelliteLeadAccepted.value);
    }
    if (satelliteLeadComments.present) {
      map['satellite_lead_comments'] =
          Variable<String>(satelliteLeadComments.value);
    }
    if (ethicsId.present) {
      map['ethics_id'] = Variable<String>(ethicsId.value);
    }
    if (reviewedByEthics.present) {
      map['reviewed_by_ethics'] = Variable<bool>(reviewedByEthics.value);
    }
    if (ethicsAccepted.present) {
      map['ethics_accepted'] = Variable<bool>(ethicsAccepted.value);
    }
    if (ethicsComments.present) {
      map['ethics_comments'] = Variable<String>(ethicsComments.value);
    }
    if (techLeadId.present) {
      map['tech_lead_id'] = Variable<String>(techLeadId.value);
    }
    if (reviewedByTechLead.present) {
      map['reviewed_by_tech_lead'] = Variable<bool>(reviewedByTechLead.value);
    }
    if (techLeadAccepted.present) {
      map['tech_lead_accepted'] = Variable<bool>(techLeadAccepted.value);
    }
    if (techLeadComments.present) {
      map['tech_lead_comments'] = Variable<String>(techLeadComments.value);
    }
    if (ethicsAssistantId.present) {
      map['ethics_assistant_id'] = Variable<String>(ethicsAssistantId.value);
    }
    if (reviewedByEthicsAssistant.present) {
      map['reviewed_by_ethics_assistant'] =
          Variable<bool>(reviewedByEthicsAssistant.value);
    }
    if (ethicsAssistantAccepted.present) {
      map['ethics_assistant_accepted'] =
          Variable<bool>(ethicsAssistantAccepted.value);
    }
    if (ethicsAssistantComments.present) {
      map['ethics_assistant_comments'] =
          Variable<String>(ethicsAssistantComments.value);
    }
    if (projectLeadId.present) {
      map['project_lead_id'] = Variable<String>(projectLeadId.value);
    }
    if (reviewedByProjectLead.present) {
      map['reviewed_by_project_lead'] =
          Variable<bool>(reviewedByProjectLead.value);
    }
    if (projectLeadReturned.present) {
      map['project_lead_returned'] = Variable<bool>(projectLeadReturned.value);
    }
    if (projectLeadComments.present) {
      map['project_lead_comments'] =
          Variable<String>(projectLeadComments.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FormsCompanion(')
          ..write('id: $id, ')
          ..write('form_name: $form_name, ')
          ..write('section_names: $section_names, ')
          ..write('data_content: $data_content, ')
          ..write('updated_by: $updated_by, ')
          ..write('date_created: $date_created, ')
          ..write('date_updated: $date_updated, ')
          ..write('user_location: $user_location, ')
          ..write('imei: $imei, ')
          ..write('server_id: $server_id, ')
          ..write('synced: $synced, ')
          ..write('facility: $facility, ')
          ..write('dateOfSurvey: $dateOfSurvey, ')
          ..write('processType: $processType, ')
          ..write('initiator: $initiator, ')
          ..write('submittedToTeamLead: $submittedToTeamLead, ')
          ..write('leadId: $leadId, ')
          ..write('reviewedByLead: $reviewedByLead, ')
          ..write('leadAccepted: $leadAccepted, ')
          ..write('leadComments: $leadComments, ')
          ..write('rfcId: $rfcId, ')
          ..write('reviewedByRfc: $reviewedByRfc, ')
          ..write('rfcAccepted: $rfcAccepted, ')
          ..write('rfcComments: $rfcComments, ')
          ..write('satelliteLeadId: $satelliteLeadId, ')
          ..write('reviewedBySatelliteLead: $reviewedBySatelliteLead, ')
          ..write('satelliteLeadAccepted: $satelliteLeadAccepted, ')
          ..write('satelliteLeadComments: $satelliteLeadComments, ')
          ..write('ethicsId: $ethicsId, ')
          ..write('reviewedByEthics: $reviewedByEthics, ')
          ..write('ethicsAccepted: $ethicsAccepted, ')
          ..write('ethicsComments: $ethicsComments, ')
          ..write('techLeadId: $techLeadId, ')
          ..write('reviewedByTechLead: $reviewedByTechLead, ')
          ..write('techLeadAccepted: $techLeadAccepted, ')
          ..write('techLeadComments: $techLeadComments, ')
          ..write('ethicsAssistantId: $ethicsAssistantId, ')
          ..write('reviewedByEthicsAssistant: $reviewedByEthicsAssistant, ')
          ..write('ethicsAssistantAccepted: $ethicsAssistantAccepted, ')
          ..write('ethicsAssistantComments: $ethicsAssistantComments, ')
          ..write('projectLeadId: $projectLeadId, ')
          ..write('reviewedByProjectLead: $reviewedByProjectLead, ')
          ..write('projectLeadReturned: $projectLeadReturned, ')
          ..write('projectLeadComments: $projectLeadComments')
          ..write(')'))
        .toString();
  }
}

class $FormsTable extends Forms with TableInfo<$FormsTable, DbForm> {
  final GeneratedDatabase _db;
  final String _alias;
  $FormsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedTextColumn _id;
  @override
  GeneratedTextColumn get id => _id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _form_nameMeta = const VerificationMeta('form_name');
  GeneratedTextColumn _form_name;
  @override
  GeneratedTextColumn get form_name => _form_name ??= _constructFormName();
  GeneratedTextColumn _constructFormName() {
    return GeneratedTextColumn(
      'form_name',
      $tableName,
      true,
    );
  }

  final VerificationMeta _section_namesMeta =
      const VerificationMeta('section_names');
  GeneratedTextColumn _section_names;
  @override
  GeneratedTextColumn get section_names =>
      _section_names ??= _constructSectionNames();
  GeneratedTextColumn _constructSectionNames() {
    return GeneratedTextColumn(
      'section_names',
      $tableName,
      true,
    );
  }

  final VerificationMeta _data_contentMeta =
      const VerificationMeta('data_content');
  GeneratedTextColumn _data_content;
  @override
  GeneratedTextColumn get data_content =>
      _data_content ??= _constructDataContent();
  GeneratedTextColumn _constructDataContent() {
    return GeneratedTextColumn(
      'data_content',
      $tableName,
      false,
    );
  }

  final VerificationMeta _updated_byMeta = const VerificationMeta('updated_by');
  GeneratedTextColumn _updated_by;
  @override
  GeneratedTextColumn get updated_by => _updated_by ??= _constructUpdatedBy();
  GeneratedTextColumn _constructUpdatedBy() {
    return GeneratedTextColumn(
      'updated_by',
      $tableName,
      true,
    );
  }

  final VerificationMeta _date_createdMeta =
      const VerificationMeta('date_created');
  GeneratedTextColumn _date_created;
  @override
  GeneratedTextColumn get date_created =>
      _date_created ??= _constructDateCreated();
  GeneratedTextColumn _constructDateCreated() {
    return GeneratedTextColumn(
      'date_created',
      $tableName,
      true,
    );
  }

  final VerificationMeta _date_updatedMeta =
      const VerificationMeta('date_updated');
  GeneratedTextColumn _date_updated;
  @override
  GeneratedTextColumn get date_updated =>
      _date_updated ??= _constructDateUpdated();
  GeneratedTextColumn _constructDateUpdated() {
    return GeneratedTextColumn(
      'date_updated',
      $tableName,
      true,
    );
  }

  final VerificationMeta _user_locationMeta =
      const VerificationMeta('user_location');
  GeneratedTextColumn _user_location;
  @override
  GeneratedTextColumn get user_location =>
      _user_location ??= _constructUserLocation();
  GeneratedTextColumn _constructUserLocation() {
    return GeneratedTextColumn(
      'user_location',
      $tableName,
      true,
    );
  }

  final VerificationMeta _imeiMeta = const VerificationMeta('imei');
  GeneratedTextColumn _imei;
  @override
  GeneratedTextColumn get imei => _imei ??= _constructImei();
  GeneratedTextColumn _constructImei() {
    return GeneratedTextColumn(
      'imei',
      $tableName,
      true,
    );
  }

  final VerificationMeta _server_idMeta = const VerificationMeta('server_id');
  GeneratedTextColumn _server_id;
  @override
  GeneratedTextColumn get server_id => _server_id ??= _constructServerId();
  GeneratedTextColumn _constructServerId() {
    return GeneratedTextColumn(
      'server_id',
      $tableName,
      true,
    );
  }

  final VerificationMeta _syncedMeta = const VerificationMeta('synced');
  GeneratedBoolColumn _synced;
  @override
  GeneratedBoolColumn get synced => _synced ??= _constructSynced();
  GeneratedBoolColumn _constructSynced() {
    return GeneratedBoolColumn(
      'synced',
      $tableName,
      true,
    );
  }

  final VerificationMeta _facilityMeta = const VerificationMeta('facility');
  GeneratedTextColumn _facility;
  @override
  GeneratedTextColumn get facility => _facility ??= _constructFacility();
  GeneratedTextColumn _constructFacility() {
    return GeneratedTextColumn(
      'facility',
      $tableName,
      true,
    );
  }

  final VerificationMeta _dateOfSurveyMeta =
      const VerificationMeta('dateOfSurvey');
  GeneratedTextColumn _dateOfSurvey;
  @override
  GeneratedTextColumn get dateOfSurvey =>
      _dateOfSurvey ??= _constructDateOfSurvey();
  GeneratedTextColumn _constructDateOfSurvey() {
    return GeneratedTextColumn(
      'date_of_survey',
      $tableName,
      true,
    );
  }

  final VerificationMeta _processTypeMeta =
      const VerificationMeta('processType');
  GeneratedTextColumn _processType;
  @override
  GeneratedTextColumn get processType =>
      _processType ??= _constructProcessType();
  GeneratedTextColumn _constructProcessType() {
    return GeneratedTextColumn(
      'process_type',
      $tableName,
      true,
    );
  }

  final VerificationMeta _initiatorMeta = const VerificationMeta('initiator');
  GeneratedTextColumn _initiator;
  @override
  GeneratedTextColumn get initiator => _initiator ??= _constructInitiator();
  GeneratedTextColumn _constructInitiator() {
    return GeneratedTextColumn(
      'initiator',
      $tableName,
      true,
    );
  }

  final VerificationMeta _submittedToTeamLeadMeta =
      const VerificationMeta('submittedToTeamLead');
  GeneratedBoolColumn _submittedToTeamLead;
  @override
  GeneratedBoolColumn get submittedToTeamLead =>
      _submittedToTeamLead ??= _constructSubmittedToTeamLead();
  GeneratedBoolColumn _constructSubmittedToTeamLead() {
    return GeneratedBoolColumn(
      'submitted_to_team_lead',
      $tableName,
      true,
    );
  }

  final VerificationMeta _leadIdMeta = const VerificationMeta('leadId');
  GeneratedTextColumn _leadId;
  @override
  GeneratedTextColumn get leadId => _leadId ??= _constructLeadId();
  GeneratedTextColumn _constructLeadId() {
    return GeneratedTextColumn(
      'lead_id',
      $tableName,
      true,
    );
  }

  final VerificationMeta _reviewedByLeadMeta =
      const VerificationMeta('reviewedByLead');
  GeneratedBoolColumn _reviewedByLead;
  @override
  GeneratedBoolColumn get reviewedByLead =>
      _reviewedByLead ??= _constructReviewedByLead();
  GeneratedBoolColumn _constructReviewedByLead() {
    return GeneratedBoolColumn(
      'reviewed_by_lead',
      $tableName,
      true,
    );
  }

  final VerificationMeta _leadAcceptedMeta =
      const VerificationMeta('leadAccepted');
  GeneratedBoolColumn _leadAccepted;
  @override
  GeneratedBoolColumn get leadAccepted =>
      _leadAccepted ??= _constructLeadAccepted();
  GeneratedBoolColumn _constructLeadAccepted() {
    return GeneratedBoolColumn(
      'lead_accepted',
      $tableName,
      true,
    );
  }

  final VerificationMeta _leadCommentsMeta =
      const VerificationMeta('leadComments');
  GeneratedTextColumn _leadComments;
  @override
  GeneratedTextColumn get leadComments =>
      _leadComments ??= _constructLeadComments();
  GeneratedTextColumn _constructLeadComments() {
    return GeneratedTextColumn(
      'lead_comments',
      $tableName,
      true,
    );
  }

  final VerificationMeta _rfcIdMeta = const VerificationMeta('rfcId');
  GeneratedTextColumn _rfcId;
  @override
  GeneratedTextColumn get rfcId => _rfcId ??= _constructRfcId();
  GeneratedTextColumn _constructRfcId() {
    return GeneratedTextColumn(
      'rfc_id',
      $tableName,
      true,
    );
  }

  final VerificationMeta _reviewedByRfcMeta =
      const VerificationMeta('reviewedByRfc');
  GeneratedBoolColumn _reviewedByRfc;
  @override
  GeneratedBoolColumn get reviewedByRfc =>
      _reviewedByRfc ??= _constructReviewedByRfc();
  GeneratedBoolColumn _constructReviewedByRfc() {
    return GeneratedBoolColumn(
      'reviewed_by_rfc',
      $tableName,
      true,
    );
  }

  final VerificationMeta _rfcAcceptedMeta =
      const VerificationMeta('rfcAccepted');
  GeneratedBoolColumn _rfcAccepted;
  @override
  GeneratedBoolColumn get rfcAccepted =>
      _rfcAccepted ??= _constructRfcAccepted();
  GeneratedBoolColumn _constructRfcAccepted() {
    return GeneratedBoolColumn(
      'rfc_accepted',
      $tableName,
      true,
    );
  }

  final VerificationMeta _rfcCommentsMeta =
      const VerificationMeta('rfcComments');
  GeneratedTextColumn _rfcComments;
  @override
  GeneratedTextColumn get rfcComments =>
      _rfcComments ??= _constructRfcComments();
  GeneratedTextColumn _constructRfcComments() {
    return GeneratedTextColumn(
      'rfc_comments',
      $tableName,
      true,
    );
  }

  final VerificationMeta _satelliteLeadIdMeta =
      const VerificationMeta('satelliteLeadId');
  GeneratedTextColumn _satelliteLeadId;
  @override
  GeneratedTextColumn get satelliteLeadId =>
      _satelliteLeadId ??= _constructSatelliteLeadId();
  GeneratedTextColumn _constructSatelliteLeadId() {
    return GeneratedTextColumn(
      'satellite_lead_id',
      $tableName,
      true,
    );
  }

  final VerificationMeta _reviewedBySatelliteLeadMeta =
      const VerificationMeta('reviewedBySatelliteLead');
  GeneratedBoolColumn _reviewedBySatelliteLead;
  @override
  GeneratedBoolColumn get reviewedBySatelliteLead =>
      _reviewedBySatelliteLead ??= _constructReviewedBySatelliteLead();
  GeneratedBoolColumn _constructReviewedBySatelliteLead() {
    return GeneratedBoolColumn(
      'reviewed_by_satellite_lead',
      $tableName,
      true,
    );
  }

  final VerificationMeta _satelliteLeadAcceptedMeta =
      const VerificationMeta('satelliteLeadAccepted');
  GeneratedBoolColumn _satelliteLeadAccepted;
  @override
  GeneratedBoolColumn get satelliteLeadAccepted =>
      _satelliteLeadAccepted ??= _constructSatelliteLeadAccepted();
  GeneratedBoolColumn _constructSatelliteLeadAccepted() {
    return GeneratedBoolColumn(
      'satellite_lead_accepted',
      $tableName,
      true,
    );
  }

  final VerificationMeta _satelliteLeadCommentsMeta =
      const VerificationMeta('satelliteLeadComments');
  GeneratedTextColumn _satelliteLeadComments;
  @override
  GeneratedTextColumn get satelliteLeadComments =>
      _satelliteLeadComments ??= _constructSatelliteLeadComments();
  GeneratedTextColumn _constructSatelliteLeadComments() {
    return GeneratedTextColumn(
      'satellite_lead_comments',
      $tableName,
      true,
    );
  }

  final VerificationMeta _ethicsIdMeta = const VerificationMeta('ethicsId');
  GeneratedTextColumn _ethicsId;
  @override
  GeneratedTextColumn get ethicsId => _ethicsId ??= _constructEthicsId();
  GeneratedTextColumn _constructEthicsId() {
    return GeneratedTextColumn(
      'ethics_id',
      $tableName,
      true,
    );
  }

  final VerificationMeta _reviewedByEthicsMeta =
      const VerificationMeta('reviewedByEthics');
  GeneratedBoolColumn _reviewedByEthics;
  @override
  GeneratedBoolColumn get reviewedByEthics =>
      _reviewedByEthics ??= _constructReviewedByEthics();
  GeneratedBoolColumn _constructReviewedByEthics() {
    return GeneratedBoolColumn(
      'reviewed_by_ethics',
      $tableName,
      true,
    );
  }

  final VerificationMeta _ethicsAcceptedMeta =
      const VerificationMeta('ethicsAccepted');
  GeneratedBoolColumn _ethicsAccepted;
  @override
  GeneratedBoolColumn get ethicsAccepted =>
      _ethicsAccepted ??= _constructEthicsAccepted();
  GeneratedBoolColumn _constructEthicsAccepted() {
    return GeneratedBoolColumn(
      'ethics_accepted',
      $tableName,
      true,
    );
  }

  final VerificationMeta _ethicsCommentsMeta =
      const VerificationMeta('ethicsComments');
  GeneratedTextColumn _ethicsComments;
  @override
  GeneratedTextColumn get ethicsComments =>
      _ethicsComments ??= _constructEthicsComments();
  GeneratedTextColumn _constructEthicsComments() {
    return GeneratedTextColumn(
      'ethics_comments',
      $tableName,
      true,
    );
  }

  final VerificationMeta _techLeadIdMeta = const VerificationMeta('techLeadId');
  GeneratedTextColumn _techLeadId;
  @override
  GeneratedTextColumn get techLeadId => _techLeadId ??= _constructTechLeadId();
  GeneratedTextColumn _constructTechLeadId() {
    return GeneratedTextColumn(
      'tech_lead_id',
      $tableName,
      true,
    );
  }

  final VerificationMeta _reviewedByTechLeadMeta =
      const VerificationMeta('reviewedByTechLead');
  GeneratedBoolColumn _reviewedByTechLead;
  @override
  GeneratedBoolColumn get reviewedByTechLead =>
      _reviewedByTechLead ??= _constructReviewedByTechLead();
  GeneratedBoolColumn _constructReviewedByTechLead() {
    return GeneratedBoolColumn(
      'reviewed_by_tech_lead',
      $tableName,
      true,
    );
  }

  final VerificationMeta _techLeadAcceptedMeta =
      const VerificationMeta('techLeadAccepted');
  GeneratedBoolColumn _techLeadAccepted;
  @override
  GeneratedBoolColumn get techLeadAccepted =>
      _techLeadAccepted ??= _constructTechLeadAccepted();
  GeneratedBoolColumn _constructTechLeadAccepted() {
    return GeneratedBoolColumn(
      'tech_lead_accepted',
      $tableName,
      true,
    );
  }

  final VerificationMeta _techLeadCommentsMeta =
      const VerificationMeta('techLeadComments');
  GeneratedTextColumn _techLeadComments;
  @override
  GeneratedTextColumn get techLeadComments =>
      _techLeadComments ??= _constructTechLeadComments();
  GeneratedTextColumn _constructTechLeadComments() {
    return GeneratedTextColumn(
      'tech_lead_comments',
      $tableName,
      true,
    );
  }

  final VerificationMeta _ethicsAssistantIdMeta =
      const VerificationMeta('ethicsAssistantId');
  GeneratedTextColumn _ethicsAssistantId;
  @override
  GeneratedTextColumn get ethicsAssistantId =>
      _ethicsAssistantId ??= _constructEthicsAssistantId();
  GeneratedTextColumn _constructEthicsAssistantId() {
    return GeneratedTextColumn(
      'ethics_assistant_id',
      $tableName,
      true,
    );
  }

  final VerificationMeta _reviewedByEthicsAssistantMeta =
      const VerificationMeta('reviewedByEthicsAssistant');
  GeneratedBoolColumn _reviewedByEthicsAssistant;
  @override
  GeneratedBoolColumn get reviewedByEthicsAssistant =>
      _reviewedByEthicsAssistant ??= _constructReviewedByEthicsAssistant();
  GeneratedBoolColumn _constructReviewedByEthicsAssistant() {
    return GeneratedBoolColumn(
      'reviewed_by_ethics_assistant',
      $tableName,
      true,
    );
  }

  final VerificationMeta _ethicsAssistantAcceptedMeta =
      const VerificationMeta('ethicsAssistantAccepted');
  GeneratedBoolColumn _ethicsAssistantAccepted;
  @override
  GeneratedBoolColumn get ethicsAssistantAccepted =>
      _ethicsAssistantAccepted ??= _constructEthicsAssistantAccepted();
  GeneratedBoolColumn _constructEthicsAssistantAccepted() {
    return GeneratedBoolColumn(
      'ethics_assistant_accepted',
      $tableName,
      true,
    );
  }

  final VerificationMeta _ethicsAssistantCommentsMeta =
      const VerificationMeta('ethicsAssistantComments');
  GeneratedTextColumn _ethicsAssistantComments;
  @override
  GeneratedTextColumn get ethicsAssistantComments =>
      _ethicsAssistantComments ??= _constructEthicsAssistantComments();
  GeneratedTextColumn _constructEthicsAssistantComments() {
    return GeneratedTextColumn(
      'ethics_assistant_comments',
      $tableName,
      true,
    );
  }

  final VerificationMeta _projectLeadIdMeta =
      const VerificationMeta('projectLeadId');
  GeneratedTextColumn _projectLeadId;
  @override
  GeneratedTextColumn get projectLeadId =>
      _projectLeadId ??= _constructProjectLeadId();
  GeneratedTextColumn _constructProjectLeadId() {
    return GeneratedTextColumn(
      'project_lead_id',
      $tableName,
      true,
    );
  }

  final VerificationMeta _reviewedByProjectLeadMeta =
      const VerificationMeta('reviewedByProjectLead');
  GeneratedBoolColumn _reviewedByProjectLead;
  @override
  GeneratedBoolColumn get reviewedByProjectLead =>
      _reviewedByProjectLead ??= _constructReviewedByProjectLead();
  GeneratedBoolColumn _constructReviewedByProjectLead() {
    return GeneratedBoolColumn(
      'reviewed_by_project_lead',
      $tableName,
      true,
    );
  }

  final VerificationMeta _projectLeadReturnedMeta =
      const VerificationMeta('projectLeadReturned');
  GeneratedBoolColumn _projectLeadReturned;
  @override
  GeneratedBoolColumn get projectLeadReturned =>
      _projectLeadReturned ??= _constructProjectLeadReturned();
  GeneratedBoolColumn _constructProjectLeadReturned() {
    return GeneratedBoolColumn(
      'project_lead_returned',
      $tableName,
      true,
    );
  }

  final VerificationMeta _projectLeadCommentsMeta =
      const VerificationMeta('projectLeadComments');
  GeneratedTextColumn _projectLeadComments;
  @override
  GeneratedTextColumn get projectLeadComments =>
      _projectLeadComments ??= _constructProjectLeadComments();
  GeneratedTextColumn _constructProjectLeadComments() {
    return GeneratedTextColumn(
      'project_lead_comments',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        form_name,
        section_names,
        data_content,
        updated_by,
        date_created,
        date_updated,
        user_location,
        imei,
        server_id,
        synced,
        facility,
        dateOfSurvey,
        processType,
        initiator,
        submittedToTeamLead,
        leadId,
        reviewedByLead,
        leadAccepted,
        leadComments,
        rfcId,
        reviewedByRfc,
        rfcAccepted,
        rfcComments,
        satelliteLeadId,
        reviewedBySatelliteLead,
        satelliteLeadAccepted,
        satelliteLeadComments,
        ethicsId,
        reviewedByEthics,
        ethicsAccepted,
        ethicsComments,
        techLeadId,
        reviewedByTechLead,
        techLeadAccepted,
        techLeadComments,
        ethicsAssistantId,
        reviewedByEthicsAssistant,
        ethicsAssistantAccepted,
        ethicsAssistantComments,
        projectLeadId,
        reviewedByProjectLead,
        projectLeadReturned,
        projectLeadComments
      ];
  @override
  $FormsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'forms';
  @override
  final String actualTableName = 'forms';
  @override
  VerificationContext validateIntegrity(Insertable<DbForm> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('form_name')) {
      context.handle(_form_nameMeta,
          form_name.isAcceptableOrUnknown(data['form_name'], _form_nameMeta));
    }
    if (data.containsKey('section_names')) {
      context.handle(
          _section_namesMeta,
          section_names.isAcceptableOrUnknown(
              data['section_names'], _section_namesMeta));
    }
    if (data.containsKey('data_content')) {
      context.handle(
          _data_contentMeta,
          data_content.isAcceptableOrUnknown(
              data['data_content'], _data_contentMeta));
    } else if (isInserting) {
      context.missing(_data_contentMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(
          _updated_byMeta,
          updated_by.isAcceptableOrUnknown(
              data['updated_by'], _updated_byMeta));
    }
    if (data.containsKey('date_created')) {
      context.handle(
          _date_createdMeta,
          date_created.isAcceptableOrUnknown(
              data['date_created'], _date_createdMeta));
    }
    if (data.containsKey('date_updated')) {
      context.handle(
          _date_updatedMeta,
          date_updated.isAcceptableOrUnknown(
              data['date_updated'], _date_updatedMeta));
    }
    if (data.containsKey('user_location')) {
      context.handle(
          _user_locationMeta,
          user_location.isAcceptableOrUnknown(
              data['user_location'], _user_locationMeta));
    }
    if (data.containsKey('imei')) {
      context.handle(
          _imeiMeta, imei.isAcceptableOrUnknown(data['imei'], _imeiMeta));
    }
    if (data.containsKey('server_id')) {
      context.handle(_server_idMeta,
          server_id.isAcceptableOrUnknown(data['server_id'], _server_idMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced'], _syncedMeta));
    }
    if (data.containsKey('facility')) {
      context.handle(_facilityMeta,
          facility.isAcceptableOrUnknown(data['facility'], _facilityMeta));
    }
    if (data.containsKey('date_of_survey')) {
      context.handle(
          _dateOfSurveyMeta,
          dateOfSurvey.isAcceptableOrUnknown(
              data['date_of_survey'], _dateOfSurveyMeta));
    }
    if (data.containsKey('process_type')) {
      context.handle(
          _processTypeMeta,
          processType.isAcceptableOrUnknown(
              data['process_type'], _processTypeMeta));
    }
    if (data.containsKey('initiator')) {
      context.handle(_initiatorMeta,
          initiator.isAcceptableOrUnknown(data['initiator'], _initiatorMeta));
    }
    if (data.containsKey('submitted_to_team_lead')) {
      context.handle(
          _submittedToTeamLeadMeta,
          submittedToTeamLead.isAcceptableOrUnknown(
              data['submitted_to_team_lead'], _submittedToTeamLeadMeta));
    }
    if (data.containsKey('lead_id')) {
      context.handle(_leadIdMeta,
          leadId.isAcceptableOrUnknown(data['lead_id'], _leadIdMeta));
    }
    if (data.containsKey('reviewed_by_lead')) {
      context.handle(
          _reviewedByLeadMeta,
          reviewedByLead.isAcceptableOrUnknown(
              data['reviewed_by_lead'], _reviewedByLeadMeta));
    }
    if (data.containsKey('lead_accepted')) {
      context.handle(
          _leadAcceptedMeta,
          leadAccepted.isAcceptableOrUnknown(
              data['lead_accepted'], _leadAcceptedMeta));
    }
    if (data.containsKey('lead_comments')) {
      context.handle(
          _leadCommentsMeta,
          leadComments.isAcceptableOrUnknown(
              data['lead_comments'], _leadCommentsMeta));
    }
    if (data.containsKey('rfc_id')) {
      context.handle(
          _rfcIdMeta, rfcId.isAcceptableOrUnknown(data['rfc_id'], _rfcIdMeta));
    }
    if (data.containsKey('reviewed_by_rfc')) {
      context.handle(
          _reviewedByRfcMeta,
          reviewedByRfc.isAcceptableOrUnknown(
              data['reviewed_by_rfc'], _reviewedByRfcMeta));
    }
    if (data.containsKey('rfc_accepted')) {
      context.handle(
          _rfcAcceptedMeta,
          rfcAccepted.isAcceptableOrUnknown(
              data['rfc_accepted'], _rfcAcceptedMeta));
    }
    if (data.containsKey('rfc_comments')) {
      context.handle(
          _rfcCommentsMeta,
          rfcComments.isAcceptableOrUnknown(
              data['rfc_comments'], _rfcCommentsMeta));
    }
    if (data.containsKey('satellite_lead_id')) {
      context.handle(
          _satelliteLeadIdMeta,
          satelliteLeadId.isAcceptableOrUnknown(
              data['satellite_lead_id'], _satelliteLeadIdMeta));
    }
    if (data.containsKey('reviewed_by_satellite_lead')) {
      context.handle(
          _reviewedBySatelliteLeadMeta,
          reviewedBySatelliteLead.isAcceptableOrUnknown(
              data['reviewed_by_satellite_lead'],
              _reviewedBySatelliteLeadMeta));
    }
    if (data.containsKey('satellite_lead_accepted')) {
      context.handle(
          _satelliteLeadAcceptedMeta,
          satelliteLeadAccepted.isAcceptableOrUnknown(
              data['satellite_lead_accepted'], _satelliteLeadAcceptedMeta));
    }
    if (data.containsKey('satellite_lead_comments')) {
      context.handle(
          _satelliteLeadCommentsMeta,
          satelliteLeadComments.isAcceptableOrUnknown(
              data['satellite_lead_comments'], _satelliteLeadCommentsMeta));
    }
    if (data.containsKey('ethics_id')) {
      context.handle(_ethicsIdMeta,
          ethicsId.isAcceptableOrUnknown(data['ethics_id'], _ethicsIdMeta));
    }
    if (data.containsKey('reviewed_by_ethics')) {
      context.handle(
          _reviewedByEthicsMeta,
          reviewedByEthics.isAcceptableOrUnknown(
              data['reviewed_by_ethics'], _reviewedByEthicsMeta));
    }
    if (data.containsKey('ethics_accepted')) {
      context.handle(
          _ethicsAcceptedMeta,
          ethicsAccepted.isAcceptableOrUnknown(
              data['ethics_accepted'], _ethicsAcceptedMeta));
    }
    if (data.containsKey('ethics_comments')) {
      context.handle(
          _ethicsCommentsMeta,
          ethicsComments.isAcceptableOrUnknown(
              data['ethics_comments'], _ethicsCommentsMeta));
    }
    if (data.containsKey('tech_lead_id')) {
      context.handle(
          _techLeadIdMeta,
          techLeadId.isAcceptableOrUnknown(
              data['tech_lead_id'], _techLeadIdMeta));
    }
    if (data.containsKey('reviewed_by_tech_lead')) {
      context.handle(
          _reviewedByTechLeadMeta,
          reviewedByTechLead.isAcceptableOrUnknown(
              data['reviewed_by_tech_lead'], _reviewedByTechLeadMeta));
    }
    if (data.containsKey('tech_lead_accepted')) {
      context.handle(
          _techLeadAcceptedMeta,
          techLeadAccepted.isAcceptableOrUnknown(
              data['tech_lead_accepted'], _techLeadAcceptedMeta));
    }
    if (data.containsKey('tech_lead_comments')) {
      context.handle(
          _techLeadCommentsMeta,
          techLeadComments.isAcceptableOrUnknown(
              data['tech_lead_comments'], _techLeadCommentsMeta));
    }
    if (data.containsKey('ethics_assistant_id')) {
      context.handle(
          _ethicsAssistantIdMeta,
          ethicsAssistantId.isAcceptableOrUnknown(
              data['ethics_assistant_id'], _ethicsAssistantIdMeta));
    }
    if (data.containsKey('reviewed_by_ethics_assistant')) {
      context.handle(
          _reviewedByEthicsAssistantMeta,
          reviewedByEthicsAssistant.isAcceptableOrUnknown(
              data['reviewed_by_ethics_assistant'],
              _reviewedByEthicsAssistantMeta));
    }
    if (data.containsKey('ethics_assistant_accepted')) {
      context.handle(
          _ethicsAssistantAcceptedMeta,
          ethicsAssistantAccepted.isAcceptableOrUnknown(
              data['ethics_assistant_accepted'], _ethicsAssistantAcceptedMeta));
    }
    if (data.containsKey('ethics_assistant_comments')) {
      context.handle(
          _ethicsAssistantCommentsMeta,
          ethicsAssistantComments.isAcceptableOrUnknown(
              data['ethics_assistant_comments'], _ethicsAssistantCommentsMeta));
    }
    if (data.containsKey('project_lead_id')) {
      context.handle(
          _projectLeadIdMeta,
          projectLeadId.isAcceptableOrUnknown(
              data['project_lead_id'], _projectLeadIdMeta));
    }
    if (data.containsKey('reviewed_by_project_lead')) {
      context.handle(
          _reviewedByProjectLeadMeta,
          reviewedByProjectLead.isAcceptableOrUnknown(
              data['reviewed_by_project_lead'], _reviewedByProjectLeadMeta));
    }
    if (data.containsKey('project_lead_returned')) {
      context.handle(
          _projectLeadReturnedMeta,
          projectLeadReturned.isAcceptableOrUnknown(
              data['project_lead_returned'], _projectLeadReturnedMeta));
    }
    if (data.containsKey('project_lead_comments')) {
      context.handle(
          _projectLeadCommentsMeta,
          projectLeadComments.isAcceptableOrUnknown(
              data['project_lead_comments'], _projectLeadCommentsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbForm map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return DbForm.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $FormsTable createAlias(String alias) {
    return $FormsTable(_db, alias);
  }
}

class FormTemplate extends DataClass implements Insertable<FormTemplate> {
  final String id;
  final String form_name;
  final String form_content;
  final String form_sections;
  final String server_id;
  final bool synced;
  FormTemplate(
      {@required this.id,
      @required this.form_name,
      this.form_content,
      this.form_sections,
      this.server_id,
      this.synced});
  factory FormTemplate.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    return FormTemplate(
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      form_name: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}form_name']),
      form_content: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}form_content']),
      form_sections: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}form_sections']),
      server_id: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}server_id']),
      synced:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}synced']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<String>(id);
    }
    if (!nullToAbsent || form_name != null) {
      map['form_name'] = Variable<String>(form_name);
    }
    if (!nullToAbsent || form_content != null) {
      map['form_content'] = Variable<String>(form_content);
    }
    if (!nullToAbsent || form_sections != null) {
      map['form_sections'] = Variable<String>(form_sections);
    }
    if (!nullToAbsent || server_id != null) {
      map['server_id'] = Variable<String>(server_id);
    }
    if (!nullToAbsent || synced != null) {
      map['synced'] = Variable<bool>(synced);
    }
    return map;
  }

  FormTemplatesCompanion toCompanion(bool nullToAbsent) {
    return FormTemplatesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      form_name: form_name == null && nullToAbsent
          ? const Value.absent()
          : Value(form_name),
      form_content: form_content == null && nullToAbsent
          ? const Value.absent()
          : Value(form_content),
      form_sections: form_sections == null && nullToAbsent
          ? const Value.absent()
          : Value(form_sections),
      server_id: server_id == null && nullToAbsent
          ? const Value.absent()
          : Value(server_id),
      synced:
          synced == null && nullToAbsent ? const Value.absent() : Value(synced),
    );
  }

  factory FormTemplate.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return FormTemplate(
      id: serializer.fromJson<String>(json['id']),
      form_name: serializer.fromJson<String>(json['form_name']),
      form_content: serializer.fromJson<String>(json['form_content']),
      form_sections: serializer.fromJson<String>(json['form_sections']),
      server_id: serializer.fromJson<String>(json['server_id']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'form_name': serializer.toJson<String>(form_name),
      'form_content': serializer.toJson<String>(form_content),
      'form_sections': serializer.toJson<String>(form_sections),
      'server_id': serializer.toJson<String>(server_id),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  FormTemplate copyWith(
          {String id,
          String form_name,
          String form_content,
          String form_sections,
          String server_id,
          bool synced}) =>
      FormTemplate(
        id: id ?? this.id,
        form_name: form_name ?? this.form_name,
        form_content: form_content ?? this.form_content,
        form_sections: form_sections ?? this.form_sections,
        server_id: server_id ?? this.server_id,
        synced: synced ?? this.synced,
      );
  @override
  String toString() {
    return (StringBuffer('FormTemplate(')
          ..write('id: $id, ')
          ..write('form_name: $form_name, ')
          ..write('form_content: $form_content, ')
          ..write('form_sections: $form_sections, ')
          ..write('server_id: $server_id, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          form_name.hashCode,
          $mrjc(
              form_content.hashCode,
              $mrjc(form_sections.hashCode,
                  $mrjc(server_id.hashCode, synced.hashCode))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is FormTemplate &&
          other.id == this.id &&
          other.form_name == this.form_name &&
          other.form_content == this.form_content &&
          other.form_sections == this.form_sections &&
          other.server_id == this.server_id &&
          other.synced == this.synced);
}

class FormTemplatesCompanion extends UpdateCompanion<FormTemplate> {
  final Value<String> id;
  final Value<String> form_name;
  final Value<String> form_content;
  final Value<String> form_sections;
  final Value<String> server_id;
  final Value<bool> synced;
  const FormTemplatesCompanion({
    this.id = const Value.absent(),
    this.form_name = const Value.absent(),
    this.form_content = const Value.absent(),
    this.form_sections = const Value.absent(),
    this.server_id = const Value.absent(),
    this.synced = const Value.absent(),
  });
  FormTemplatesCompanion.insert({
    @required String id,
    @required String form_name,
    this.form_content = const Value.absent(),
    this.form_sections = const Value.absent(),
    this.server_id = const Value.absent(),
    this.synced = const Value.absent(),
  })  : id = Value(id),
        form_name = Value(form_name);
  static Insertable<FormTemplate> custom({
    Expression<String> id,
    Expression<String> form_name,
    Expression<String> form_content,
    Expression<String> form_sections,
    Expression<String> server_id,
    Expression<bool> synced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (form_name != null) 'form_name': form_name,
      if (form_content != null) 'form_content': form_content,
      if (form_sections != null) 'form_sections': form_sections,
      if (server_id != null) 'server_id': server_id,
      if (synced != null) 'synced': synced,
    });
  }

  FormTemplatesCompanion copyWith(
      {Value<String> id,
      Value<String> form_name,
      Value<String> form_content,
      Value<String> form_sections,
      Value<String> server_id,
      Value<bool> synced}) {
    return FormTemplatesCompanion(
      id: id ?? this.id,
      form_name: form_name ?? this.form_name,
      form_content: form_content ?? this.form_content,
      form_sections: form_sections ?? this.form_sections,
      server_id: server_id ?? this.server_id,
      synced: synced ?? this.synced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (form_name.present) {
      map['form_name'] = Variable<String>(form_name.value);
    }
    if (form_content.present) {
      map['form_content'] = Variable<String>(form_content.value);
    }
    if (form_sections.present) {
      map['form_sections'] = Variable<String>(form_sections.value);
    }
    if (server_id.present) {
      map['server_id'] = Variable<String>(server_id.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FormTemplatesCompanion(')
          ..write('id: $id, ')
          ..write('form_name: $form_name, ')
          ..write('form_content: $form_content, ')
          ..write('form_sections: $form_sections, ')
          ..write('server_id: $server_id, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }
}

class $FormTemplatesTable extends FormTemplates
    with TableInfo<$FormTemplatesTable, FormTemplate> {
  final GeneratedDatabase _db;
  final String _alias;
  $FormTemplatesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedTextColumn _id;
  @override
  GeneratedTextColumn get id => _id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _form_nameMeta = const VerificationMeta('form_name');
  GeneratedTextColumn _form_name;
  @override
  GeneratedTextColumn get form_name => _form_name ??= _constructFormName();
  GeneratedTextColumn _constructFormName() {
    return GeneratedTextColumn('form_name', $tableName, false,
        $customConstraints: 'UNIQUE');
  }

  final VerificationMeta _form_contentMeta =
      const VerificationMeta('form_content');
  GeneratedTextColumn _form_content;
  @override
  GeneratedTextColumn get form_content =>
      _form_content ??= _constructFormContent();
  GeneratedTextColumn _constructFormContent() {
    return GeneratedTextColumn(
      'form_content',
      $tableName,
      true,
    );
  }

  final VerificationMeta _form_sectionsMeta =
      const VerificationMeta('form_sections');
  GeneratedTextColumn _form_sections;
  @override
  GeneratedTextColumn get form_sections =>
      _form_sections ??= _constructFormSections();
  GeneratedTextColumn _constructFormSections() {
    return GeneratedTextColumn(
      'form_sections',
      $tableName,
      true,
    );
  }

  final VerificationMeta _server_idMeta = const VerificationMeta('server_id');
  GeneratedTextColumn _server_id;
  @override
  GeneratedTextColumn get server_id => _server_id ??= _constructServerId();
  GeneratedTextColumn _constructServerId() {
    return GeneratedTextColumn(
      'server_id',
      $tableName,
      true,
    );
  }

  final VerificationMeta _syncedMeta = const VerificationMeta('synced');
  GeneratedBoolColumn _synced;
  @override
  GeneratedBoolColumn get synced => _synced ??= _constructSynced();
  GeneratedBoolColumn _constructSynced() {
    return GeneratedBoolColumn(
      'synced',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, form_name, form_content, form_sections, server_id, synced];
  @override
  $FormTemplatesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'form_templates';
  @override
  final String actualTableName = 'form_templates';
  @override
  VerificationContext validateIntegrity(Insertable<FormTemplate> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('form_name')) {
      context.handle(_form_nameMeta,
          form_name.isAcceptableOrUnknown(data['form_name'], _form_nameMeta));
    } else if (isInserting) {
      context.missing(_form_nameMeta);
    }
    if (data.containsKey('form_content')) {
      context.handle(
          _form_contentMeta,
          form_content.isAcceptableOrUnknown(
              data['form_content'], _form_contentMeta));
    }
    if (data.containsKey('form_sections')) {
      context.handle(
          _form_sectionsMeta,
          form_sections.isAcceptableOrUnknown(
              data['form_sections'], _form_sectionsMeta));
    }
    if (data.containsKey('server_id')) {
      context.handle(_server_idMeta,
          server_id.isAcceptableOrUnknown(data['server_id'], _server_idMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced'], _syncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FormTemplate map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return FormTemplate.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $FormTemplatesTable createAlias(String alias) {
    return $FormTemplatesTable(_db, alias);
  }
}

class IncidentReport extends DataClass implements Insertable<IncidentReport> {
  final String id;
  final String formName;
  final String dateCreated;
  final String dateUpdated;
  final String updatedBy;
  final String userLocation;
  final String imei;
  final String dataContent;
  final bool approved;
  final bool synced;
  IncidentReport(
      {@required this.id,
      this.formName,
      this.dateCreated,
      this.dateUpdated,
      this.updatedBy,
      this.userLocation,
      this.imei,
      this.dataContent,
      this.approved,
      this.synced});
  factory IncidentReport.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    return IncidentReport(
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      formName: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}form_name']),
      dateCreated: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}date_created']),
      dateUpdated: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}date_updated']),
      updatedBy: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_by']),
      userLocation: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}user_location']),
      imei: stringType.mapFromDatabaseResponse(data['${effectivePrefix}imei']),
      dataContent: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}data_content']),
      approved:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}approved']),
      synced:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}synced']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<String>(id);
    }
    if (!nullToAbsent || formName != null) {
      map['form_name'] = Variable<String>(formName);
    }
    if (!nullToAbsent || dateCreated != null) {
      map['date_created'] = Variable<String>(dateCreated);
    }
    if (!nullToAbsent || dateUpdated != null) {
      map['date_updated'] = Variable<String>(dateUpdated);
    }
    if (!nullToAbsent || updatedBy != null) {
      map['updated_by'] = Variable<String>(updatedBy);
    }
    if (!nullToAbsent || userLocation != null) {
      map['user_location'] = Variable<String>(userLocation);
    }
    if (!nullToAbsent || imei != null) {
      map['imei'] = Variable<String>(imei);
    }
    if (!nullToAbsent || dataContent != null) {
      map['data_content'] = Variable<String>(dataContent);
    }
    if (!nullToAbsent || approved != null) {
      map['approved'] = Variable<bool>(approved);
    }
    if (!nullToAbsent || synced != null) {
      map['synced'] = Variable<bool>(synced);
    }
    return map;
  }

  IncidentReportsCompanion toCompanion(bool nullToAbsent) {
    return IncidentReportsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      formName: formName == null && nullToAbsent
          ? const Value.absent()
          : Value(formName),
      dateCreated: dateCreated == null && nullToAbsent
          ? const Value.absent()
          : Value(dateCreated),
      dateUpdated: dateUpdated == null && nullToAbsent
          ? const Value.absent()
          : Value(dateUpdated),
      updatedBy: updatedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedBy),
      userLocation: userLocation == null && nullToAbsent
          ? const Value.absent()
          : Value(userLocation),
      imei: imei == null && nullToAbsent ? const Value.absent() : Value(imei),
      dataContent: dataContent == null && nullToAbsent
          ? const Value.absent()
          : Value(dataContent),
      approved: approved == null && nullToAbsent
          ? const Value.absent()
          : Value(approved),
      synced:
          synced == null && nullToAbsent ? const Value.absent() : Value(synced),
    );
  }

  factory IncidentReport.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return IncidentReport(
      id: serializer.fromJson<String>(json['id']),
      formName: serializer.fromJson<String>(json['formName']),
      dateCreated: serializer.fromJson<String>(json['dateCreated']),
      dateUpdated: serializer.fromJson<String>(json['dateUpdated']),
      updatedBy: serializer.fromJson<String>(json['updatedBy']),
      userLocation: serializer.fromJson<String>(json['userLocation']),
      imei: serializer.fromJson<String>(json['imei']),
      dataContent: serializer.fromJson<String>(json['dataContent']),
      approved: serializer.fromJson<bool>(json['approved']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'formName': serializer.toJson<String>(formName),
      'dateCreated': serializer.toJson<String>(dateCreated),
      'dateUpdated': serializer.toJson<String>(dateUpdated),
      'updatedBy': serializer.toJson<String>(updatedBy),
      'userLocation': serializer.toJson<String>(userLocation),
      'imei': serializer.toJson<String>(imei),
      'dataContent': serializer.toJson<String>(dataContent),
      'approved': serializer.toJson<bool>(approved),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  IncidentReport copyWith(
          {String id,
          String formName,
          String dateCreated,
          String dateUpdated,
          String updatedBy,
          String userLocation,
          String imei,
          String dataContent,
          bool approved,
          bool synced}) =>
      IncidentReport(
        id: id ?? this.id,
        formName: formName ?? this.formName,
        dateCreated: dateCreated ?? this.dateCreated,
        dateUpdated: dateUpdated ?? this.dateUpdated,
        updatedBy: updatedBy ?? this.updatedBy,
        userLocation: userLocation ?? this.userLocation,
        imei: imei ?? this.imei,
        dataContent: dataContent ?? this.dataContent,
        approved: approved ?? this.approved,
        synced: synced ?? this.synced,
      );
  @override
  String toString() {
    return (StringBuffer('IncidentReport(')
          ..write('id: $id, ')
          ..write('formName: $formName, ')
          ..write('dateCreated: $dateCreated, ')
          ..write('dateUpdated: $dateUpdated, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('userLocation: $userLocation, ')
          ..write('imei: $imei, ')
          ..write('dataContent: $dataContent, ')
          ..write('approved: $approved, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          formName.hashCode,
          $mrjc(
              dateCreated.hashCode,
              $mrjc(
                  dateUpdated.hashCode,
                  $mrjc(
                      updatedBy.hashCode,
                      $mrjc(
                          userLocation.hashCode,
                          $mrjc(
                              imei.hashCode,
                              $mrjc(
                                  dataContent.hashCode,
                                  $mrjc(approved.hashCode,
                                      synced.hashCode))))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is IncidentReport &&
          other.id == this.id &&
          other.formName == this.formName &&
          other.dateCreated == this.dateCreated &&
          other.dateUpdated == this.dateUpdated &&
          other.updatedBy == this.updatedBy &&
          other.userLocation == this.userLocation &&
          other.imei == this.imei &&
          other.dataContent == this.dataContent &&
          other.approved == this.approved &&
          other.synced == this.synced);
}

class IncidentReportsCompanion extends UpdateCompanion<IncidentReport> {
  final Value<String> id;
  final Value<String> formName;
  final Value<String> dateCreated;
  final Value<String> dateUpdated;
  final Value<String> updatedBy;
  final Value<String> userLocation;
  final Value<String> imei;
  final Value<String> dataContent;
  final Value<bool> approved;
  final Value<bool> synced;
  const IncidentReportsCompanion({
    this.id = const Value.absent(),
    this.formName = const Value.absent(),
    this.dateCreated = const Value.absent(),
    this.dateUpdated = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.userLocation = const Value.absent(),
    this.imei = const Value.absent(),
    this.dataContent = const Value.absent(),
    this.approved = const Value.absent(),
    this.synced = const Value.absent(),
  });
  IncidentReportsCompanion.insert({
    @required String id,
    this.formName = const Value.absent(),
    this.dateCreated = const Value.absent(),
    this.dateUpdated = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.userLocation = const Value.absent(),
    this.imei = const Value.absent(),
    this.dataContent = const Value.absent(),
    this.approved = const Value.absent(),
    this.synced = const Value.absent(),
  }) : id = Value(id);
  static Insertable<IncidentReport> custom({
    Expression<String> id,
    Expression<String> formName,
    Expression<String> dateCreated,
    Expression<String> dateUpdated,
    Expression<String> updatedBy,
    Expression<String> userLocation,
    Expression<String> imei,
    Expression<String> dataContent,
    Expression<bool> approved,
    Expression<bool> synced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (formName != null) 'form_name': formName,
      if (dateCreated != null) 'date_created': dateCreated,
      if (dateUpdated != null) 'date_updated': dateUpdated,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (userLocation != null) 'user_location': userLocation,
      if (imei != null) 'imei': imei,
      if (dataContent != null) 'data_content': dataContent,
      if (approved != null) 'approved': approved,
      if (synced != null) 'synced': synced,
    });
  }

  IncidentReportsCompanion copyWith(
      {Value<String> id,
      Value<String> formName,
      Value<String> dateCreated,
      Value<String> dateUpdated,
      Value<String> updatedBy,
      Value<String> userLocation,
      Value<String> imei,
      Value<String> dataContent,
      Value<bool> approved,
      Value<bool> synced}) {
    return IncidentReportsCompanion(
      id: id ?? this.id,
      formName: formName ?? this.formName,
      dateCreated: dateCreated ?? this.dateCreated,
      dateUpdated: dateUpdated ?? this.dateUpdated,
      updatedBy: updatedBy ?? this.updatedBy,
      userLocation: userLocation ?? this.userLocation,
      imei: imei ?? this.imei,
      dataContent: dataContent ?? this.dataContent,
      approved: approved ?? this.approved,
      synced: synced ?? this.synced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (formName.present) {
      map['form_name'] = Variable<String>(formName.value);
    }
    if (dateCreated.present) {
      map['date_created'] = Variable<String>(dateCreated.value);
    }
    if (dateUpdated.present) {
      map['date_updated'] = Variable<String>(dateUpdated.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (userLocation.present) {
      map['user_location'] = Variable<String>(userLocation.value);
    }
    if (imei.present) {
      map['imei'] = Variable<String>(imei.value);
    }
    if (dataContent.present) {
      map['data_content'] = Variable<String>(dataContent.value);
    }
    if (approved.present) {
      map['approved'] = Variable<bool>(approved.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IncidentReportsCompanion(')
          ..write('id: $id, ')
          ..write('formName: $formName, ')
          ..write('dateCreated: $dateCreated, ')
          ..write('dateUpdated: $dateUpdated, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('userLocation: $userLocation, ')
          ..write('imei: $imei, ')
          ..write('dataContent: $dataContent, ')
          ..write('approved: $approved, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }
}

class $IncidentReportsTable extends IncidentReports
    with TableInfo<$IncidentReportsTable, IncidentReport> {
  final GeneratedDatabase _db;
  final String _alias;
  $IncidentReportsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedTextColumn _id;
  @override
  GeneratedTextColumn get id => _id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _formNameMeta = const VerificationMeta('formName');
  GeneratedTextColumn _formName;
  @override
  GeneratedTextColumn get formName => _formName ??= _constructFormName();
  GeneratedTextColumn _constructFormName() {
    return GeneratedTextColumn(
      'form_name',
      $tableName,
      true,
    );
  }

  final VerificationMeta _dateCreatedMeta =
      const VerificationMeta('dateCreated');
  GeneratedTextColumn _dateCreated;
  @override
  GeneratedTextColumn get dateCreated =>
      _dateCreated ??= _constructDateCreated();
  GeneratedTextColumn _constructDateCreated() {
    return GeneratedTextColumn(
      'date_created',
      $tableName,
      true,
    );
  }

  final VerificationMeta _dateUpdatedMeta =
      const VerificationMeta('dateUpdated');
  GeneratedTextColumn _dateUpdated;
  @override
  GeneratedTextColumn get dateUpdated =>
      _dateUpdated ??= _constructDateUpdated();
  GeneratedTextColumn _constructDateUpdated() {
    return GeneratedTextColumn(
      'date_updated',
      $tableName,
      true,
    );
  }

  final VerificationMeta _updatedByMeta = const VerificationMeta('updatedBy');
  GeneratedTextColumn _updatedBy;
  @override
  GeneratedTextColumn get updatedBy => _updatedBy ??= _constructUpdatedBy();
  GeneratedTextColumn _constructUpdatedBy() {
    return GeneratedTextColumn(
      'updated_by',
      $tableName,
      true,
    );
  }

  final VerificationMeta _userLocationMeta =
      const VerificationMeta('userLocation');
  GeneratedTextColumn _userLocation;
  @override
  GeneratedTextColumn get userLocation =>
      _userLocation ??= _constructUserLocation();
  GeneratedTextColumn _constructUserLocation() {
    return GeneratedTextColumn(
      'user_location',
      $tableName,
      true,
    );
  }

  final VerificationMeta _imeiMeta = const VerificationMeta('imei');
  GeneratedTextColumn _imei;
  @override
  GeneratedTextColumn get imei => _imei ??= _constructImei();
  GeneratedTextColumn _constructImei() {
    return GeneratedTextColumn(
      'imei',
      $tableName,
      true,
    );
  }

  final VerificationMeta _dataContentMeta =
      const VerificationMeta('dataContent');
  GeneratedTextColumn _dataContent;
  @override
  GeneratedTextColumn get dataContent =>
      _dataContent ??= _constructDataContent();
  GeneratedTextColumn _constructDataContent() {
    return GeneratedTextColumn(
      'data_content',
      $tableName,
      true,
    );
  }

  final VerificationMeta _approvedMeta = const VerificationMeta('approved');
  GeneratedBoolColumn _approved;
  @override
  GeneratedBoolColumn get approved => _approved ??= _constructApproved();
  GeneratedBoolColumn _constructApproved() {
    return GeneratedBoolColumn(
      'approved',
      $tableName,
      true,
    );
  }

  final VerificationMeta _syncedMeta = const VerificationMeta('synced');
  GeneratedBoolColumn _synced;
  @override
  GeneratedBoolColumn get synced => _synced ??= _constructSynced();
  GeneratedBoolColumn _constructSynced() {
    return GeneratedBoolColumn(
      'synced',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        formName,
        dateCreated,
        dateUpdated,
        updatedBy,
        userLocation,
        imei,
        dataContent,
        approved,
        synced
      ];
  @override
  $IncidentReportsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'incident_reports';
  @override
  final String actualTableName = 'incident_reports';
  @override
  VerificationContext validateIntegrity(Insertable<IncidentReport> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('form_name')) {
      context.handle(_formNameMeta,
          formName.isAcceptableOrUnknown(data['form_name'], _formNameMeta));
    }
    if (data.containsKey('date_created')) {
      context.handle(
          _dateCreatedMeta,
          dateCreated.isAcceptableOrUnknown(
              data['date_created'], _dateCreatedMeta));
    }
    if (data.containsKey('date_updated')) {
      context.handle(
          _dateUpdatedMeta,
          dateUpdated.isAcceptableOrUnknown(
              data['date_updated'], _dateUpdatedMeta));
    }
    if (data.containsKey('updated_by')) {
      context.handle(_updatedByMeta,
          updatedBy.isAcceptableOrUnknown(data['updated_by'], _updatedByMeta));
    }
    if (data.containsKey('user_location')) {
      context.handle(
          _userLocationMeta,
          userLocation.isAcceptableOrUnknown(
              data['user_location'], _userLocationMeta));
    }
    if (data.containsKey('imei')) {
      context.handle(
          _imeiMeta, imei.isAcceptableOrUnknown(data['imei'], _imeiMeta));
    }
    if (data.containsKey('data_content')) {
      context.handle(
          _dataContentMeta,
          dataContent.isAcceptableOrUnknown(
              data['data_content'], _dataContentMeta));
    }
    if (data.containsKey('approved')) {
      context.handle(_approvedMeta,
          approved.isAcceptableOrUnknown(data['approved'], _approvedMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced'], _syncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IncidentReport map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return IncidentReport.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $IncidentReportsTable createAlias(String alias) {
    return $IncidentReportsTable(_db, alias);
  }
}

abstract class _$FormsDatabase extends GeneratedDatabase {
  _$FormsDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $FormsTable _forms;
  $FormsTable get forms => _forms ??= $FormsTable(this);
  $FormTemplatesTable _formTemplates;
  $FormTemplatesTable get formTemplates =>
      _formTemplates ??= $FormTemplatesTable(this);
  $IncidentReportsTable _incidentReports;
  $IncidentReportsTable get incidentReports =>
      _incidentReports ??= $IncidentReportsTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [forms, formTemplates, incidentReports];
}
