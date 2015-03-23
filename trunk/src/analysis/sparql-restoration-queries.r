restoration.count.by.tooth.query.string <- function (limit=0) {
  query.string <- "
select distinct  ?toothtype (count(?toothtype) as ?count)
where
{
  ## patient's sex and birth date
  ?patienti rdf:type patient: .
  ?patienti asserted_type: ?patienttypei .
  ?patienti birth_date: ?birthdate .
  
  ## patient's tooth & tooth type
  ?toothi rdf:type tooth: .
  ?toothi asserted_type: ?toothtypei .
  ?toothi is_part_of: ?patienti .

  ## restoration procedure and tooth be restored role
  ?proci rdf:type tooth_restoration_procedure: .
  ?rolei rdf:type tooth_to_be_restored_role: .
  
  ## the tooth to be restored role inheres in the tooth
  ## and is realized by the procedure
  ?rolei inheres_in: ?toothi .
  ?proci realizes: ?rolei .
  
  ## assign labels
  ?toothi rdfs:label ?tooth .
  ?toothtypei tooth_number: ?toothtype .
} 
group by ?toothtype
"
  
  if (limit > 0)
    query.string <- paste(query.string,"limit ", limit, "\n", sep="")
  
  ## return query string
  query.string
}

total.number.of.tooth.restorations.by.type.query.string <- function (limit=0) {
  query.string = "
select ?restoration_procedure (count(*) as ?count)
where 
{
  ## patient and patient's tooth
  ?patienti rdf:type patient: .  
  ?toothi rdf:type tooth: .
  ?toothi is_part_of: ?patienti .
  
  ## surfaces that are part of tooth
  ?surfacei rdf:type tooth_surface: .
  ?surfacei is_part_of: ?toothi .
  
  ## restoration procedure and tooth be restored role
  ?proct rdfs:subClassOf tooth_restoration_procedure: .
  ?proci rdf:type ?proct .
  ?rolei rdf:type tooth_to_be_restored_role: .
  
  ## the tooth to be restored role inheres in the tooth
  ## and is realized by the procedure
  ?rolei inheres_in: ?toothi .
  ?proci realizes: ?rolei .
  
  ## the tooth's surface participated in the procedure
  ?surfacei participates_in: ?proci .
  
  ## assign labels
  ?proct rdfs:label ?restoration_procedure .
  
}
group by ?restoration_procedure
  "
  if (limit > 0)
    query.string <- paste(query.string,"limit ", limit, "\n", sep="")
  
  ## return query string
  query.string
}

total.number.of.tooth.restorations.per.suface.query.string <- function(limit = 0) {
  query.string <- "
select ?restoration_procedure ?surface (count(*) as ?count)
where 
{
 ## patient and patient's tooth
 ?patienti rdf:type patient: .  
 ?tootht rdfs:subClassOf tooth: .
 ?toothi asserted_type: ?tootht .
 ?toothi is_part_of: ?patienti .

 ## surfaces that are part of tooth
 ?surfacet rdfs:subClassOf tooth_surface: .
 ?surfacei asserted_type: ?surfacet .
 ?surfacei is_part_of: ?toothi .

  ## restoration procedure and tooth be restored role
  ?proct rdfs:subClassOf tooth_restoration_procedure: .
  ?proci asserted_type: ?proct .
  ?rolei rdf:type tooth_to_be_restored_role: .

  ## the tooth to be restored role inheres in the tooth
  ## and is realized by the procedure
  ?rolei inheres_in: ?toothi .
  ?proci realizes: ?rolei .

  ## the tooth's surface participated in the procedure
 ?surfacei participates_in: ?proci .

 ## assign labels
 ?proct rdfs:label ?restoration_procedure .
 ?surfacet rdfs:label ?surface .

}
group by ?restoration_procedure ?surface
order by ?restoration_procedure"

if (limit > 0)
  query.string <- paste(query.string,"limit ", limit, "\n", sep="")

## return query string
query.string
}
  
first.and.second.restoration.query.string <- function (limit=0)
{
  query.string <- "
  select distinct ?patienttype ?birthdate ?tooth ?toothtype ?surface ?surfacetype ?procedure1 ?date1 ?procedure2 ?date2
  
  ## look for surface specific for now. Find two procedures and an optional third
  where
{
  ## patient's sex and birth date
  ?patienti rdf:type patient: .
  ?patienti asserted_type: ?patienttypei .
  ?patienti birth_date: ?birthdate .
  
  ## patient's tooth & tooth type
  ?toothi rdf:type tooth: .
  ?toothi asserted_type: ?toothtypei .
  ?toothi is_part_of: ?patienti .
  
  ## surfaces and their types that are part of tooth
  ?surfacei rdf:type tooth_surface: .
  ?surfacei asserted_type: ?surfacetypei .
  ?surfacei is_part_of: ?toothi .
  
  ##- get restoration procedure in general
  ## this is done by finding the procedures that realize
  ## some tooth to be resotred role that is borne by the tooth
  ## the procedures occurrence date (?date) is used to determine
  ## the first restoration date by taking the min of ?date
  ## see having clause below
  ?proci rdf:type tooth_restoration_procedure: .
  ?rolei rdf:type tooth_to_be_restored_role: .
  
  ## the tooth to be restored role inheres in the tooth
  ## and is realized by the procedure
  ?rolei inheres_in: ?toothi .
  ?proci realizes: ?rolei .
  ?proci occurrence_date: ?date . # date of procedure
  ?proci has_participant: ?surfacei . ## link surface to procedure

  ##- first procedure: the tooth is same as the general procedure above.
  ## the first procedure is determined in a manner similar to the
  ## general procedure above
  ?proci1 rdf:type tooth_restoration_procedure: .
  ?rolei1 rdf:type tooth_to_be_restored_role: .
  
  ## the tooth to be restored role inheres in the tooth
  ## and is realized by the procedure
  ?rolei1 inheres_in: ?toothi .
  ?proci1 realizes: ?rolei1 .
  ?proci1 occurrence_date: ?date1 . # date of procedure 1
  ?proci1 has_participant: ?surfacei . ## link surface to procedure

  ##- second process: the tooth and surface remain the same as the first
  ## but a new process that realizes a new role is searched for
  ?proci2 rdf:type tooth_restoration_procedure: .
  ?rolei2 rdf:type tooth_to_be_restored_role: .
  
  ## the tooth to be restored role inheres in the tooth
  ## and is realized by the procedure
  ?rolei2 inheres_in: ?toothi .
  ?proci2 realizes: ?rolei2 .
  ?proci2 occurrence_date: ?date2 . # date fo procedure 2
  ?proci2 has_participant: ?surfacei . ## link surface to procedure

  ## we only those second procedure that are after the first
  filter (?date2 > ?date1 && ?proci1 != ?proci2)
  
  ##- third process: the tooth and surface remain the same,
  ## but the date is between the other two
  ## (we check later that this doesn't succeed)
  optional {
  ?proci3 rdf:type tooth_restoration_procedure: .
  ?rolei3 rdf:type tooth_to_be_restored_role: .
  
  ## the tooth to be restored role inheres in the tooth
  ## and is realized by the procedure
  ?rolei3 inheres_in: ?toothi .
  ?proci3 realizes: ?rolei3 .
  ?proci3 occurrence_date: ?date3 . # date of procedure 3
  ?proci3 has_participant: ?surfacei . ## link surface to procedure

  ## we want only that procedures that are between
  ## two other procedures
  filter (?date3<?date2 && ?date3>?date1)}
  
  ## assign labels
  ?patienttypei rdfs:label ?patienttype .
  ?toothi rdfs:label ?tooth .
  ?toothtypei tooth_number: ?toothtype .
  ?surfacei rdfs:label ?surface .
  ?surfacetypei rdfs:label ?surfacetype .
  ?proci1 rdfs:label ?procedure1 .
  ?proci2 rdfs:label ?procedure2 .
  
  ## we only want those records where the in between date (?date3)
  ## is not bound, this gives us adjacent dates
  filter (!bound(?date3))
}
  group by ?patienttype ?birthdate ?tooth ?toothtype ?surface ?surfacetype ?procedure1 ?date1 ?procedure2 ?date2
  ## match the min and first procedure dates
  having (?date1 = min(?date))
  order by ?tooth ?surface ?date1
  
  "
  if (limit > 0)
     query.string <- paste(query.string,"limit ", limit, "\n", sep="")

query.string
}

restoration.followed.by.inlay.query.string <- function (limit=0)
{
  query.string <- "
  select distinct ?patienttype ?birthdate ?tooth ?toothtype ?surface ?surfacetype ?procedure1 ?date1 ?procedure2 ?date2
  
  ## look for surface specific for now. Find two procedures and an optional third
  where
{
  ## patient's sex and birth date
  ?patienti rdf:type patient: .
  ?patienti asserted_type: ?patienttypei .
  ?patienti birth_date: ?birthdate .
  
  ## patient's tooth & tooth type
  ?toothi rdf:type tooth: .
  ?toothi asserted_type: ?toothtypei .
  ?toothi is_part_of: ?patienti .
  
  ## surfaces and their types that are part of tooth
  ?surfacei rdf:type tooth_surface: .
  ?surfacei asserted_type: ?surfacetypei .
  ?surfacei is_part_of: ?toothi .
  
  ##- get restoration procedure in general
  ## this is done by finding the procedures that realize
  ## some tooth to be resotred role that is borne by the tooth
  ## the procedures occurrence date (?date) is used to determine
  ## the first restoration date by taking the min of ?date
  ## see having clause below
  ?proci rdf:type tooth_restoration_procedure: .
  ?rolei rdf:type tooth_to_be_restored_role: .
  
  ## the tooth to be restored role inheres in the tooth
  ## and is realized by the procedure
  ?rolei inheres_in: ?toothi .
  ?proci realizes: ?rolei .
  ?proci occurrence_date: ?date . # date of procedure
  ?proci has_participant: ?surfacei . ## link surface to procedure
  
  ##- first procedure: the tooth is same as the general procedure above.
  ## the first procedure is determined in a manner similar to the
  ## general procedure above
  ?proci1 rdf:type tooth_restoration_procedure: .
  ?rolei1 rdf:type tooth_to_be_restored_role: .
  
  ## the tooth to be restored role inheres in the tooth
  ## and is realized by the procedure
  ?rolei1 inheres_in: ?toothi .
  ?proci1 realizes: ?rolei1 .
  ?proci1 occurrence_date: ?date1 . # date of procedure 1
  ?proci1 has_participant: ?surfacei . ## link surface to procedure
  
  ##- second process: the tooth and surface remain the same as the first
  ## but a new process that realizes a new role is searched for
  ?proci2 rdf:type inlay_restoration: .
  ?rolei2 rdf:type tooth_to_be_restored_role: .
  
  ## the tooth to be restored role inheres in the tooth
  ## and is realized by the procedure
  ?rolei2 inheres_in: ?toothi .
  ?proci2 realizes: ?rolei2 .
  ?proci2 occurrence_date: ?date2 . # date fo procedure 2
  ?proci2 has_participant: ?surfacei . ## link surface to procedure
  
  ## we only those second procedure that are after the first
  filter (?date2 > ?date1 && ?proci1 != ?proci2)
  
  ##- third process: the tooth and surface remain the same,
  ## but the date is between the other two
  ## (we check later that this doesn't succeed)
  optional {
  ?proci3 rdf:type inlay_restoration: .
  ?rolei3 rdf:type tooth_to_be_restored_role: .
  
  ## the tooth to be restored role inheres in the tooth
  ## and is realized by the procedure
  ?rolei3 inheres_in: ?toothi .
  ?proci3 realizes: ?rolei3 .
  ?proci3 occurrence_date: ?date3 . # date of procedure 3
  ?proci3 has_participant: ?surfacei . ## link surface to procedure
  
  ## we want only that procedures that are between
  ## two other procedures
  filter (?date3<?date2 && ?date3>?date1)}
  
  ## assign labels
  ?patienttypei rdfs:label ?patienttype .
  ?toothi rdfs:label ?tooth .
  ?toothtypei tooth_number: ?toothtype .
  ?surfacei rdfs:label ?surface .
  ?surfacetypei rdfs:label ?surfacetype .
  ?proci1 rdfs:label ?procedure1 .
  ?proci2 rdfs:label ?procedure2 .
  
  ## we only want those records where the in between date (?date3)
  ## is not bound, this gives us adjacent dates
  filter (!bound(?date3))
}
  group by ?patienttype ?birthdate ?tooth ?toothtype ?surface ?surfacetype ?procedure1 ?date1 ?procedure2 ?date2
  ## match the min and first procedure dates
  having (?date1 = min(?date))
  order by ?tooth ?surface ?procedure1 ?date1
  
  "
  if (limit > 0)
     query.string <- paste(query.string,"limit ", limit, "\n", sep="")

query.string
}

first.and.second.amalgam.restoration.query.string <- function (limit=0)
{
  query.string <- "
  select distinct ?patienttype ?birthdate ?tooth ?toothtype ?surface ?surfacetype ?procedure1 ?date1 ?procedure2 ?date2
  
  ## look for surface specific for now. Find two procedures and an optional third
  where
{
  ## patient's sex and birth date
  ?patienti rdf:type patient: .
  ?patienti asserted_type: ?patienttypei .
  ?patienti birth_date: ?birthdate .
  
  ## patient's tooth & tooth type
  ?toothi rdf:type tooth: .
  ?toothi asserted_type: ?toothtypei .
  ?toothi is_part_of: ?patienti .
  
  ## surfaces and their types that are part of tooth
  ?surfacei rdf:type tooth_surface: .
  ?surfacei asserted_type: ?surfacetypei .
  ?surfacei is_part_of: ?toothi .
  
  ##- get restoration procedure in general
  ## this is done by finding the procedures that realize
  ## some tooth to be resotred role that is borne by the tooth
  ## the procedures occurrence date (?date) is used to determine
  ## the first restoration date by taking the min of ?date
  ## see having clause below
  ##### ?proci rdf:type tooth_restoration_procedure: . ******
  ?proci rdf:type <http://purl.obolibrary.org/obo/OHD_0000041> . ## amalagam procedure
  ?rolei rdf:type tooth_to_be_restored_role: .
  
  ## the tooth to be restored role inheres in the tooth
  ## and is realized by the procedure
  ?rolei inheres_in: ?toothi .
  ?proci realizes: ?rolei .
  ?proci occurrence_date: ?date . # date of procedure
  
  ##- first procedure: the tooth is same as the general procedure above.
  ## the first procedure is determined in a manner similar to the
  ## general procedure above
  ####### ?proci1 rdf:type tooth_restoration_procedure: . ******
  ?proci1 rdf:type <http://purl.obolibrary.org/obo/OHD_0000041> . ## amalagam procedure
  ?rolei1 rdf:type tooth_to_be_restored_role: .
  
  ## the tooth to be restored role inheres in the tooth
  ## and is realized by the procedure
  ?rolei1 inheres_in: ?toothi .
  ?proci1 realizes: ?rolei1 .
  ?proci1 occurrence_date: ?date1 . # date of procedure 1
  
  ## surfaces that have been restored particpate in the procedure
  ?proci1 has_participant: ?surfacei .
  
  ##- second process: the tooth and surface remain the same as the first
  ## but a new process that realizes a new role is searched for
  ?proci2 rdf:type tooth_restoration_procedure: .
  ?rolei2 rdf:type tooth_to_be_restored_role: .
  
  ## the tooth to be restored role inheres in the tooth
  ## and is realized by the procedure
  ?rolei2 inheres_in: ?toothi .
  ?proci2 realizes: ?rolei2 .
  ?proci2 occurrence_date: ?date2 . # date fo procedure 2
  
  ## surfaces that have been restored particpate in the procedure
  ?proci2 has_participant: ?surfacei .
  
  ## we only those second procedure that are after the first
  filter (?date2 > ?date1 && ?proci1 != ?proci2)
  
  ##- third process: the tooth and surface remain the same,
  ## but the date is between the other two
  ## (we check later that this doesn't succeed)
  optional {
  ?proci3 rdf:type tooth_restoration_procedure: .
  ?rolei3 rdf:type tooth_to_be_restored_role: .
  
  ## the tooth to be restored role inheres in the tooth
  ## and is realized by the procedure
  ?rolei3 inheres_in: ?toothi .
  ?proci3 realizes: ?rolei3 .
  ?proci3 occurrence_date: ?date3 . # date of procedure 3
  
  ## surfaces that have been restored particpate in the procedure
  ?proci3 has_participant: ?surfacei .
  
  ## we want only that procedures that are between
  ## two other procedures
  filter (?date3<?date2 && ?date3>?date1)}
  
  ## assign labels
  ?patienttypei rdfs:label ?patienttype .
  ?toothi rdfs:label ?tooth .
  ?toothtypei tooth_number: ?toothtype .
  ?surfacei rdfs:label ?surface .
  ?surfacetypei rdfs:label ?surfacetype .
  ?proci1 rdfs:label ?procedure1 .
  ?proci2 rdfs:label ?procedure2 .
  
  ## we only want those records where the in between date (?date3)
  ## is not bound, this gives us adjacent dates
  filter (!bound(?date3))
}
  group by ?patienttype ?birthdate ?tooth ?toothtype ?surface ?surfacetype ?procedure1 ?date1 ?procedure2 ?date2
  ## match the min and first procedure dates
  having (?date1 = min(?date))
  order by ?tooth ?surface ?date1
  
  "
  if (limit > 0)
     query.string <- paste(query.string,"limit ", limit, "\n", sep="")

query.string
}

nonfailed.restorations.count.query.string <- function(limit = 0) {
  query.string <- ""
  
  if (limit > 0)
    query.string <- paste(query.string,"limit ", limit, "\n", sep="")
  
  query.string
}

tooth.2.of.patient.690.query.string <- function() {
"PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX dental_patient: <http://purl.obolibrary.org/obo/OHD_0000012>
PREFIX birth_date:  <http://purl.obolibrary.org/obo/OHD_0000050>
PREFIX occurrence_date:  <http://purl.obolibrary.org/obo/OHD_0000015>
PREFIX inheres_in: <http://purl.obolibrary.org/obo/BFO_0000052>
PREFIX participates_in: <http://purl.obolibrary.org/obo/BFO_0000056>
PREFIX has_participant: <http://purl.obolibrary.org/obo/BFO_0000057>
PREFIX dental_procedure: <http://purl.obolibrary.org/obo/OHD_0000002>
PREFIX crown_restoration: <http://purl.obolibrary.org/obo/OHD_0000033>
PREFIX tooth_restoration_procedure: <http://purl.obolibrary.org/obo/OHD_0000004>
PREFIX intracoronal_restoration: <http://purl.obolibrary.org/obo/OHD_0000006>
PREFIX veneer_restoration: <http://purl.obolibrary.org/obo/OHD_0000027>
PREFIX inlay_restoration: <http://purl.obolibrary.org/obo/OHD_0000133>
PREFIX onlay_restoration: <http://purl.obolibrary.org/obo/OHD_0000134>
PREFIX surgical_procedure: <http://purl.obolibrary.org/obo/OHD_0000044>
PREFIX endodontic_procedure: <http://purl.obolibrary.org/obo/OHD_0000003>
PREFIX tooth_to_be_restored_role: <http://purl.obolibrary.org/obo/OHD_0000007>
PREFIX tooth_to_be_filled_role: <http://purl.obolibrary.org/obo/OHD_0000008>
PREFIX realizes: <http://purl.obolibrary.org/obo/BFO_0000055>
PREFIX tooth: <http://purl.obolibrary.org/obo/FMA_12516>
PREFIX is_part_of: <http://purl.obolibrary.org/obo/BFO_0000050>
PREFIX tooth_surface: <http://purl.obolibrary.org/obo/FMA_no_fmaid_Surface_enamel_of_tooth>
PREFIX mesial: <http://purl.obolibrary.org/obo/FMA_no_fmaid_Mesial_surface_enamel_of_tooth>
PREFIX distal: <http://purl.obolibrary.org/obo/FMA_no_fmaid_Distal_surface_enamel_of_tooth>
PREFIX occlusal: <http://purl.obolibrary.org/obo/FMA_no_fmaid_Occlusial_surface_enamel_of_tooth>
PREFIX buccal: <http://purl.obolibrary.org/obo/FMA_no_fmaid_Buccal_surface_enamel_of_tooth>
PREFIX labial: <http://purl.obolibrary.org/obo/FMA_no_fmaid_Labial_surface_enamel_of_tooth>
PREFIX lingual: <http://purl.obolibrary.org/obo/FMA_no_fmaid_Lingual_surface_enamel_of_tooth>
PREFIX is_dental_restoration_of: <http://purl.obolibrary.org/obo/OHD_0000091>
PREFIX dental_restoration_material: <http://purl.obolibrary.org/obo/OHD_0000000>
PREFIX has_specified_input: <http://purl.obolibrary.org/obo/OBI_0000293>
PREFIX has_specified_output: <http://purl.obolibrary.org/obo/OBI_0000299>
PREFIX asserted_type: <http://purl.obolibrary.org/obo/OHD_0000092>
PREFIX tooth_number: <http://purl.obolibrary.org/obo/OHD_0000065>
PREFIX female: <http://purl.obolibrary.org/obo/OHD_0000049>
PREFIX male: <http://purl.obolibrary.org/obo/OHD_0000054>
PREFIX patient: <http://purl.obolibrary.org/obo/OHD_0000012>

select ?tooth ?surface ?proc ?date
where 
{
## patient's sex and birth date
?patienti rdf:type patient: .
?patienti asserted_type: ?patienttypei .
?patienti birth_date: ?birthdate .

## patient's tooth & tooth type
?toothi rdf:type tooth: .
?toothi asserted_type: ?toothtypei .
?toothi is_part_of: ?patienti .

## surfaces and their types that are part of tooth
?surfacei rdf:type tooth_surface: .
?surfacei asserted_type: ?surfacetypei .
?surfacei is_part_of: ?toothi .

##- restoration procedure and tooth to be restored role
?proci rdf:type tooth_restoration_procedure: .
?rolei rdf:type tooth_to_be_restored_role: .

## the tooth to be restored role inheres in the tooth
## and is realized by the procedure
?rolei inheres_in: ?toothi .
?proci realizes: ?rolei .
?proci occurrence_date: ?date . # date of procedure
?proci has_participant: ?surfacei . ## link surface to procedure

## assign labels 
?toothi rdfs:label ?tooth .
?surfacei rdfs:label  ?surface .
?proci rdfs:label ?proc

filter(?tooth = \"tooth 2 of patient 690\")

}

order by ?tooth ?surface ?proc ?date
"
}