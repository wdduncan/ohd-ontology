
(defparameter owlim-repository-id "OHD")
(defparameter sesame-owlim-repository (format nil "http://localhost:8080/openrdf-workbench/repositories/~a" owlim-repository-id))
(defparameter sesame-manager "http://localhost:8080/openrdf-sesame/")

(defun load-r21-to-owlim-sesame (&optional (endpoint (format nil "~a/update" sesame-owlim-repository)))
  (let ((files (append (directory "ohd:ontology;ohd.owl")
		       (directory "ohd:ontology;imports;BFO2;*.owl")
		       (directory "ohd:ontology;imports;*.owl")
		       (directory "ohd:ontology;dropbox;*.owl"))))
    (loop for file in files do
	 (format t "load <file://~a>;~%" file))))

#|
My loads:

Used to load snomed files
load <file:///Users/williamduncan/repos/git/iop/snomed-icd/UMLS-SNOMED/icd-to-snomed-mapping.owl>;
load <file:///Users/williamduncan/repos/git/iop/snomed-icd/UMLS-SNOMED/snomed-2013-09-01-xml.owl>;
load <file:///Users/williamduncan/repos/git/iop/snomed-icd/test-conversion/snomed-split1.ttl>;
load <file:///Users/williamduncan/repos/git/iop/snomed-icd/UMLS-SNOMED/snomed-reasoned/ntriple-split-300k/snomed-split1.n3>;
load <file:///Users/williamduncan/repos/git/iop/snomed-icd/UMLS-SNOMED/ontotex-triples/snomed-2013-09-01-xml.nt>;
load <file:///Users/williamduncan/Desktop/snomed-icd/split-300k/nsplit300k-1.nt>;
load <file:///Users/williamduncan/Desktop/snomed-icd/split-11-100k/nsplit-11-20k-1.nt>;
load <file:///Users/williamduncan/repos/ohd-ontology/src/ontology/pitt-ub-ohsu-r21/r21-eaglesoft-oral-evaluations.owl>;



-------

Used for ohd owl files
load <file:///Users/williamduncan/repos/svn/ohd-ontology/src/ontology/pitt-ub-ohsu-r21/ohd.owl>;
load <file:///Users/williamduncan/repos/svn/ohd-ontology/src/ontology/pitt-ub-ohsu-r21/imports/BFO2/bfo2.owl>;
load <file:///Users/williamduncan/repos/svn/ohd-ontology/src/ontology/pitt-ub-ohsu-r21/imports/BFO2/bfo2-relations.owl>;
load <file:///Users/williamduncan/repos/svn/ohd-ontology/src/ontology/pitt-ub-ohsu-r21/imports/BFO2/bfo2-regions.owl>;
load <file:///Users/williamduncan/repos/svn/ohd-ontology/src/ontology/pitt-ub-ohsu-r21/imports/BFO2/bfo2-classes.owl>;
load <file:///Users/williamduncan/repos/svn/ohd-ontology/src/ontology/pitt-ub-ohsu-r21/imports/protege-dc.owl>;
load <file:///Users/williamduncan/repos/svn/ohd-ontology/src/ontology/pitt-ub-ohsu-r21/imports/ontology-metadata.owl>;
load <file:///Users/williamduncan/repos/svn/ohd-ontology/src/ontology/pitt-ub-ohsu-r21/imports/ogms.owl>;
load <file:///Users/williamduncan/repos/svn/ohd-ontology/src/ontology/pitt-ub-ohsu-r21/imports/obi-imports.owl>;
load <file:///Users/williamduncan/repos/svn/ohd-ontology/src/ontology/pitt-ub-ohsu-r21/imports/ncbi-imports.owl>;
load <file:///Users/williamduncan/repos/svn/ohd-ontology/src/ontology/pitt-ub-ohsu-r21/imports/iao-imports.owl>;
load <file:///Users/williamduncan/repos/svn/ohd-ontology/src/ontology/pitt-ub-ohsu-r21/imports/fma-jaws-teeth.owl>;
load <file:///Users/williamduncan/repos/svn/ohd-ontology/src/ontology/pitt-ub-ohsu-r21/imports/cdt-imports.owl>;
load <file:///Users/williamduncan/repos/svn/ohd-ontology/src/ontology/pitt-ub-ohsu-r21/imports/caro-imports.owl>;
load <file:///Users/williamduncan/repos/svn/ohd-ontology/src/ontology/pitt-ub-ohsu-r21/r21-eaglesoft-unerupted-teeth-findings.owl>;
load <file:///Users/williamduncan/repos/svn/ohd-ontology/src/ontology/pitt-ub-ohsu-r21/r21-eaglesoft-surgical-extractions.owl>;
load <file:///Users/williamduncan/repos/svn/ohd-ontology/src/ontology/pitt-ub-ohsu-r21/r21-eaglesoft-missing-teeth-findings.owl>;
load <file:///Users/williamduncan/repos/svn/ohd-ontology/src/ontology/pitt-ub-ohsu-r21/r21-eaglesoft-caries-findings.owl>;
load <file:///Users/williamduncan/repos/svn/ohd-ontology/src/ontology/pitt-ub-ohsu-r21/r21-eaglesoft-fillings.owl>;
load <file:///Users/williamduncan/repos/svn/ohd-ontology/src/ontology/pitt-ub-ohsu-r21/r21-eaglesoft-endodontics.owl>;
load <file:///Users/williamduncan/repos/svn/ohd-ontology/src/ontology/pitt-ub-ohsu-r21/r21-eaglesoft-dental-providers.owl>;
load <file:///Users/williamduncan/repos/svn/ohd-ontology/src/ontology/pitt-ub-ohsu-r21/r21-eaglesoft-dental-patients.owl>;
load <file:///Users/williamduncan/repos/svn/ohd-ontology/src/ontology/pitt-ub-ohsu-r21/r21-eaglesoft-crowns.owl>;
load <file:///Users/williamduncan/repos/svn/ohd-ontology/src/ontology/pitt-ub-ohsu-r21/r21-eaglesoft-inlays.owl>;
load <file:///Users/williamduncan/repos/svn/ohd-ontology/src/ontology/pitt-ub-ohsu-r21/r21-eaglesoft-onlays.owl>;
load <file:///Users/williamduncan/repos/svn/ohd-ontology/src/ontology/pitt-ub-ohsu-r21/r21-eaglesoft-veneers.owl>;

|#

(register-namespace "openrdf:" "http://www.openrdf.org/config/repository#")

(defun create-repo-from-ttl (&optional (endpoint "http://localhost:8080/openrdf-workbench/repositories/SYSTEM/update") name expressivity )
  (let
      ;;((files (append (directory "/Volumes/Big/Downloads/2012-08-13/owlim-lite-5.2.5331/getting-started/owlim.ttl"))))
      ((files (append (directory "/Users/williamduncan/owlim/owlim-lite-5.2.5331/getting-started/owlim.ttl"))))
    (with-ontology foo (:collecting t)
	((asq
	  (class-assertion !openrdf:RepositoryContext (:blank repocontext))
	  (class-assertion !openrdf:Repository (:blank repo))
	  (declaration (annotation-property !openrdf:repositoryID))
	  (annotation-assertion !openrdf:repositoryID (:blank repo) "name of ontology")))
      (to-owl-syntax foo :turtle))))




(defun sesame-repository-size (id)
  (parse-integer (get-url (format nil "http://localhost:8080/openrdf-sesame/repositories/~a/size" id))))

; http://answers.semanticweb.com/questions/16108/createdelete-a-sesame-repository-via-http
; http://www.openrdf.org/doc/sesame2/system/ch08.html

#| Needs a context, which is a unique IRI or bnode. It would be eq to the first [] in the template below.
(defun create-owlim-lite-repository
                    POST /openrdf-sesame/repositories/mem-rdf/statements?context=null HTTP/1.1
|#



#|
Template RDF for uploading to SYSTEM repository to create an OWLIM repo.

@prefix rep: <http://www.openrdf.org/config/repository#>.
@prefix sr: <http://www.openrdf.org/config/repository/sail#>.
@prefix sail: <http://www.openrdf.org/config/sail#>.
@prefix owlim: <http://www.ontotext.com/trree/owlim#>.


[] a rep:Repository ;
   rep:repositoryID "owlim" ;
   rdfs:label "OWLIM Getting Started" ;
   rep:repositoryImpl [
     rep:repositoryType "openrdf:SailRepository" ;
     sr:sailImpl [
       sail:sailType "swiftowlim:Sail" ;
       owlim:ruleset "owl-max" ;
       owlim:partialRDFS  "true" ;
       owlim:noPersist "true" ;
       owlim:storage-folder "junit-storage" ;
       owlim:base-URL "http://example.org#" ;
       owlim:new-triples-file "new-triples-file.nt" ;
       owlim:entity-index-size "200000" ;
       owlim:jobsize "200" ;
       owlim:repository-type "in-memory-repository" ;
       owlim:imports "./ontology/my_ontology.rdf" ;
       owlim:defaultNS "http://www.my-organisation.org/ontology#"
     ]
   ].

Traced doing an update in the interface, with packet peeper http://sourceforge.net/projects/packetpeeper/files/latest/download

Bottom line: The update needs to be made as a post at endpoint "/update" relative to repository
The query parameter/value "queryLn" "SPARQL" must be included in the post
The "update" parameter of the post is the SPARQL update statement.


POST /openrdf-workbench/repositories/OHD/update HTTP/1.1
Host: localhost:8080
Connection: keep-alive
Content-Length: 828
Cache-Control: max-age=0
Origin: http://localhost:8080
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_4) AppleWebKit/537.4 (KHTML, like Gecko) Chrome/22.0.1229.2 Safari/537.4
Content-Type: application/x-www-form-urlencoded
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Referer: http://localhost:8080/openrdf-workbench/repositories/OHD/update
Accept-Encoding: gzip,deflate,sdch
Accept-Language: en-US,en;q=0.8
Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.3


(#"decode" 'java.net.URLDecoder (coerce "

queryLn=SPARQL&update=PREFIX+dc%3A%3Chttp%3A%2F%2Fpurl.org%2Fdc%2Felements%2F1.1%2F%3E%0D%0APREFIX+%3A%3Chttp%3A%2F%2Fpurl.obolibrary.org%2Fobo%2Fbfo%2Fcore-classes.owl%23%3E%0D%0APREFIX+rdfs%3A%3Chttp%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23%3E%0D%0APREFIX+obo%3A%3Chttp%3A%2F%2Fpurl.obolibrary.org%2Fobo%2F%3E%0D%0APREFIX+psys%3A%3Chttp%3A%2F%2Fproton.semanticweb.org%2Fprotonsys%23%3E%0D%0APREFIX+owl%3A%3Chttp%3A%2F%2Fwww.w3.org%2F2002%2F07%2Fowl%23%3E%0D%0APREFIX+xsd%3A%3Chttp%3A%2F%2Fwww.w3.org%2F2001%2FXMLSchema%23%3E%0D%0APREFIX+rdf%3A%3Chttp%3A%2F%2Fwww.w3.org%2F1999%2F02%2F22-rdf-syntax-ns%23%3E%0D%0APREFIX+pext%3A%3Chttp%3A%2F%2Fproton.semanticweb.org%2Fprotonext%23%3E%0D%0Aload+%3Cfile%3A%2FUsers%2Falanr%2Frepos%2Fohd-ontology%2Ftrunk%2Fsrc%2Fontology%2Fpitt-ub-ohsu-r21%2Fimports%2FBFO2%2Fbfo2.owl%3E%3B

" 'simple-string))

->

queryLn=SPARQL&update=PREFIX dc:<http://purl.org/dc/elements/1.1/>
PREFIX :<http://purl.obolibrary.org/obo/bfo/core-classes.owl#>
PREFIX rdfs:<http://www.w3.org/2000/01/rdf-schema#>
PREFIX obo:<http://purl.obolibrary.org/obo/>
PREFIX psys:<http://proton.semanticweb.org/protonsys#>
PREFIX owl:<http://www.w3.org/2002/07/owl#>
PREFIX xsd:<http://www.w3.org/2001/XMLSchema#>
PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX pext:<http://proton.semanticweb.org/protonext#>
load <file:/Users/alanr/repos/ohd-ontology/trunk/src/ontology/pitt-ub-ohsu-r21/imports/BFO2/bfo2.owl>;

|#
