(defmacro push-items (place &rest items)
  "macro used for pushing muliple items onto a list. 
For example, instead of doing multiple push operations like so:
  (push `(declaration (class !A)) axioms)
  (push `(declaration (class !B)) axioms)
  (push `(declaration (class !C)) axioms)

push-items can be called like so:
  (push-items axioms
              `(declaration (class !A))
              `(declaration (class !B))
              `(declaration (class !C))

created by Alan Ruttenberg 11/26/2013"
  `(setf ,place (append (list ,@items) ,place)))

(defmacro setf+ (string1 &rest string2)
  "A shortcut for str+:
 (setf x (str+ y z)) is the same as (setf+ x y z)"
  `(setf ,string1 (str+ ,string1 ,@string2)))

(defmacro with-axioms (axiom-list &body body)
  `(progn
     ;; the following set of labels provide bfo like language for building
     ;; the axiom list, the purpose of these so to make building instance
     ;; data more straightforward
     (labels
	 ((instance-of (instance class)
	    (push `(declaration (named-individual ,instance)) ,axiom-list)
	    (push `(class-assertion ,class ,instance) ,axiom-list)
	    (push `(annotation-assertion !'asserted type'@ohd ,instance ,class) ,axiom-list))

	  (has-label (uri label)
	    (push `(annotation-assertion !rdfs:label ,uri ,label) ,axiom-list))

	  (has-patient-id (patient-uri patient-id)
	    (push `(data-property-assertion
		    !'patient ID'@ohd ,patient-uri ,patient-id) ,axiom-list))

	  (has-code-value (uri code)
	    (push `(data-property-assertion
		    !'has code value'@ohd ,uri ,code) ,axiom-list))
	  
	  (participates-in (continuant process)
	    (push `(object-property-assertion
		    !'participates in'@ohd ,continuant ,process) ,axiom-list))
	  
	  (has-participant (process continuant)
	    (participates-in continuant process))
	  
	  (realizes (process realizable)
	    (push `(object-property-assertion
		    !'realizes'@ohd ,process ,realizable) ,axiom-list))
	  
	  (located-in (entity location)
	    (push `(object-property-assertion
		    !'is located in'@ohd ,entity ,location) ,axiom-list))
	  
	  (part-of (entity1 entity2)
	    (push `(object-property-assertion
		    !'is part of'@ohd ,entity1 ,entity2) ,axiom-list))
	  
	  (has-part (entity1 entity2)
	    (part-of entity2 entity1))

	  (inheres-in (dependent-entity independent-entity)
	    (push `(object-property-assertion
		    !'inheres in'@ohd ,dependent-entity ,independent-entity) ,axiom-list))

	  (has-role (entity role)
	    (push `(object-property-assertion
		    !'has role'@ohd ,entity ,role) ,axiom-list))

	  (is-about (ice entity)
	    (push `(object-property-assertion
		    !'is about'@ohd ,ice ,entity) ,axiom-list))

	  (is-referent-of (entity icd)
	    (push `(object-property-assertion
		    !'is referent of'@ohd ,entity ,ice) ,axiom-list))
		   
	  (is-dental-restoration-of (material surface)
	    (push `(object-property-assertion 
		    !'is dental restoration of'@ohd ,material ,surface) ,axiom-list))

	  (has-occurrence-date (entity date)
	    (push `(data-property-assertion
		    !'occurrence date'@ohd ,entity (:literal ,date !xsd:date)) ,axiom-list))

	  (occurs-in (process entity)
	    (push `(object-property-assertion
		    !'occurs in'@ohd ,process ,entity) ,axiom-list))

	  (has-birth-date (uri date)
	    (push `(data-property-assertion
		    !'birth_date'@ohd ,uri (:literal ,date !xsd:date)) ,axiom-list))

	  (has-birth-year (uri year)
	    (push `(data-property-assertion
		    !'birth year'@ohd ,uri (:literal ,year !xsd:gYear)) ,axiom-list))

	  (has-graduation-year (uri year)
	    (push `(data-property-assertion
		    !'graduation year'@ohd ,uri (:literal ,year !xsd:gYear)) ,axiom-list))

	  (has-specified-output (process entity)
	    (push `(object-property-assertion
		    !'has_specified_output'@ohd ,process ,entity) ,axiom-list))

	  (has-specified-input (process entity)
	    (push `(object-property-assertion
		    !'has_specified_input'@ohd ,process ,entity) ,axiom-list)))

       ;; in order for the above relations to work, each of the data/object properties have to be declared
       ;; putting this inside the macro means it will get inserted where ever the macro is used
       ;; however, having it here means I only have to maintain the declarations in one place
       (push `(declaration (annotation-property !'asserted type'@ohd)) ,axiom-list)
       (push `(declaration (annotation-property !rdfs:label)) ,axiom-list)
       (push `(declaration (data-property !'patient ID'@ohd)) ,axiom-list)
       (push `(declaration (data-property !'has code value'@ohd)) ,axiom-list)
       (push `(declaration (object-property !'participates in'@ohd)) ,axiom-list)
       (push `(declaration (object-property !'has participant'@ohd)) ,axiom-list)
       (push `(declaration (object-property !'realizes'@ohd)) ,axiom-list)
       (push `(declaration (object-property !'is located in'@ohd)) ,axiom-list)
       (push `(declaration (object-property !'is part of'@ohd)) ,axiom-list)
       (push `(declaration (object-property !'has part'@ohd)) ,axiom-list)
       (push `(declaration (object-property !'inheres in'@ohd)) ,axiom-list)
       (push `(declaration (object-property !'has role'@ohd)) ,axiom-list)
       (push `(declaration (object-property !'is about'@ohd)) ,axiom-list)
       (push `(declaration (object-property !'is referent of'@ohd)) ,axiom-list)
       (push `(declaration (object-property !'occurs in'@ohd)) ,axiom-list)
       (push `(declaration (object-property !'is dental restoration of'@ohd)) ,axiom-list)
       (push `(declaration (data-property !'occurrence date'@ohd)) ,axiom-list)
       (push `(declaration (data-property !'birth_date'@ohd)) ,axiom-list)
       (push `(declaration (data-property !'birth year'@ohd)) ,axiom-list)
       (push `(declaration (data-property !'graduation year'@ohd)) ,axiom-list)
       (push `(declaration (object-property !'has_specified_output'@ohd)) ,axiom-list)
       (push `(declaration (object-property !'has_specified_input'@ohd)) ,axiom-list)
       
       ,@body)))
