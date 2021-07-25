import 'dart:async';
import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:undo/undo.dart';
import 'package:uuid/uuid.dart';
part 'forms_database.g.dart';

// this will generate a table called "forms" for us. The rows of that table will
// be represented by a class called "Forms".
// general information about form
// forms
@DataClassName("DbForm")
class Forms extends Table {
  TextColumn get id => text()();
  TextColumn get form_name => text().nullable()();
  TextColumn get section_names => text().nullable()();
  TextColumn get data_content => text()();
  TextColumn get updated_by => text().nullable()();
  TextColumn get date_created => text().nullable()();
  TextColumn get date_updated => text().nullable()();
  TextColumn get user_location => text().nullable()();
  TextColumn get imei => text().nullable()();
  TextColumn get server_id => text().nullable()();
  BoolColumn get synced => boolean().nullable()();
  TextColumn get facility => text().nullable()();
  TextColumn get dateOfSurvey => text().nullable()();
  TextColumn get processType => text().nullable()();
  // initiator
  TextColumn get initiator => text().nullable()();
  BoolColumn get submittedToTeamLead => boolean().nullable()();
  // team lead
  TextColumn get leadId => text().nullable()();
  BoolColumn get reviewedByLead => boolean().nullable()();
  BoolColumn get leadAccepted => boolean().nullable()();
  TextColumn get leadComments => text().nullable()();
  // rfc
  TextColumn get rfcId => text().nullable()();
  BoolColumn get reviewedByRfc => boolean().nullable()();
  BoolColumn get rfcAccepted => boolean().nullable()();
  TextColumn get rfcComments => text().nullable()();
  // satellite lead
  TextColumn get satelliteLeadId => text().nullable()();
  BoolColumn get reviewedBySatelliteLead => boolean().nullable()();
  BoolColumn get satelliteLeadAccepted => boolean().nullable()();
  TextColumn get satelliteLeadComments => text().nullable()();
  // ethics lead
  TextColumn get ethicsId => text().nullable()();
  BoolColumn get reviewedByEthics => boolean().nullable()();
  BoolColumn get ethicsAccepted => boolean().nullable()();
  TextColumn get ethicsComments => text().nullable()();
  // tech lead
  TextColumn get techLeadId => text().nullable()();
  BoolColumn get reviewedByTechLead => boolean().nullable()();
  BoolColumn get techLeadAccepted => boolean().nullable()();
  TextColumn get techLeadComments => text().nullable()();
  // ethics assistant
  TextColumn get ethicsAssistantId => text().nullable()();
  BoolColumn get reviewedByEthicsAssistant => boolean().nullable()();
  BoolColumn get ethicsAssistantAccepted => boolean().nullable()();
  TextColumn get ethicsAssistantComments => text().nullable()();
  // project lead
  TextColumn get projectLeadId => text().nullable()();
  BoolColumn get reviewedByProjectLead => boolean().nullable()();
  BoolColumn get projectLeadReturned => boolean().nullable()();
  TextColumn get projectLeadComments => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// form_templates
class FormTemplates extends Table {
  TextColumn get id => text()();
  TextColumn get form_name => text().customConstraint("UNIQUE")();
  TextColumn get form_content => text().nullable()();
  TextColumn get form_sections => text().nullable()();
  TextColumn get server_id => text().nullable()();
  BoolColumn get synced => boolean().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// incident_reports
class IncidentReports extends Table {
  TextColumn get id => text()();
  TextColumn get formName => text().nullable()();
  TextColumn get dateCreated => text().nullable()();
  TextColumn get dateUpdated => text().nullable()();
  TextColumn get updatedBy => text().nullable()();
  TextColumn get userLocation => text().nullable()();
  TextColumn get imei => text().nullable()();
  TextColumn get dataContent => text().nullable()();
  BoolColumn get approved => boolean().nullable()();
  BoolColumn get synced => boolean().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// this annotation tells moor to prepare a database class that uses both of the
// tables we just defined. We'll see how to use that database class in a moment.
@UseMoor(tables: [
  Forms,
  FormTemplates,
  IncidentReports
])
class FormsDatabase extends _$FormsDatabase {
  // we tell the database where to store the data with this constructor
  FormsDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(
            path: 'db.sqlite', logStatements: true));

  // static FormsDatabase _database;
  // static QueryExecutor exec;
  // static FormsDatabase queryExecutor(QueryExecutor e) {
  //   exec = e;
  // }
  // FormsDatabase(QueryExecutor e) : super(e);
  // FormsDatabase(QueryExecutor e) : super(e) {
  //   exec = e;
  // }
  final cs = ChangeStack();
  // FormsDatabase(QueryExecutor e) : super(e);
  // final cs = ChangeStack();

  static final FormsDatabase _database = new FormsDatabase();
  // static final FormsDatabase _database = new FormsDatabase(exec);
  int _schemaVersion = 58;
  // you should bump this number whenever you change or add a table definition. Migrations
  // are covered later in this readme.
  @override
  int get schemaVersion => _schemaVersion;

  @override
  MigrationStrategy get migration =>
      MigrationStrategy(onUpgrade: (migrator, from, to) async {
        if (from < _schemaVersion) {
          migrator.createTable(forms);
          // migrator.createTable(formTemplates);
          // migrator.createTable(incidentReports);
        }
      });

  // singleton instance method to try and avoid multiple databases
  static FormsDatabase getInstance() => _database;

  // get all forms
  Future<List<DbForm>> getAllForms() => select(forms).get();
  Stream<List<DbForm>> watchAllTasks() => select(forms).watch();
  Future<List<DbForm>> getUnsyncedForms() =>
      (select(forms)..where((t) => isNull(t.synced) | t.synced.equals(false)))
          .get();
  Future<DbForm> getFormById(String id) =>
      (select(forms)..where((t) => t.id.equals(id)))
          .getSingle();

  // get a specific type of form
  Future<List<DbForm>> getFormByName(String name) =>
      (select(forms)..where((t) => t.form_name.equals(name))).get();

  // get the different form types (BAISV, incident report, etc.)
  Future<List<FormTemplate>> getFormTemplates() => select(formTemplates).get();
  Future<FormTemplate> getFormTemplateByName(String name) => (select(formTemplates)..where((tbl) => tbl.form_name.equals(name))).getSingle();
  Future insertFormTemplate(FormTemplate template) =>
      into(formTemplates).insert(template);
  Future updateFormTemplate(FormTemplate template) =>
      (update(formTemplates)..where((t) => t.id.equals(template.id)))
          .write(template);

  // managing forms
  Future insertForm(DbForm form) =>
      into(forms).insert(form); // insert form data
  Future updateForm(DbForm form) =>
      (update(forms)..where((t) => t.id.equals(form.id)))
          .write(form); // update form data
  Future deleteForm(DbForm form) =>
      delete(forms).delete(form); // delete form data

  // managing forms and their accepted status
  // get unsynced forms
  // managing incident reports
  Future<List<IncidentReport>> getUnsyncedIncidents() =>
      (select(incidentReports)..where((t) => isNull(t.synced) | t.synced.equals(false)))
          .get();
  Future<List<IncidentReport>> getIncidentReports() => select(incidentReports).get();
  Future insertIndicentReport(IncidentReport incident) => into(incidentReports).insert(incident);
  Future updateIndicentReport(IncidentReport incident) => (update(incidentReports)
  ..where((t) => t.id.equals(incident.id))).write(incident);
  Future<FormTemplate> getTemplateByName(String name) =>
      (select(formTemplates)..where((t) => t.form_name.equals(name)))
          .getSingle();
  Future<IncidentReport> getIncidentById(String id) =>
      (select(incidentReports)..where((t) => t.formName.equals(id)))
          .getSingle();
}
