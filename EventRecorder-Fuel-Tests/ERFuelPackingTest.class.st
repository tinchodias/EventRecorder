Class {
	#name : #ERFuelPackingTest,
	#superclass : #EREventPackingTest,
	#category : #'EventRecorder-Fuel-Tests'
}

{ #category : #accessing }
ERFuelPackingTest >> packingClass [
	^ ERFuelPacking
]

{ #category : #tests }
ERFuelPackingTest >> testMigration [
	| oldClass oldObject |
	oldClass := Object newAnonymousSubclass.
	oldObject := oldClass new.
	collector := EREventCollector new.
	collector add: oldObject.
	bundle := collector asBundleWith: packing.
	packet := packing unpack: bundle data.
	self should: [ packet unpackedData ] raise: FLClassNotFound.
]

{ #category : #tests }
ERFuelPackingTest >> testMigration2 [
	| oldClass oldObject |
	oldClass := Object newAnonymousSubclass.
	oldObject := oldClass new.
	collector := EREventCollector new.
	collector add: oldObject.
	bundle := collector asBundleWith: packing.
	packing addMigration: [ :aMaterializer |
		aMaterializer migrateClassNamed: oldClass name asSymbol toClass: ERDummyEvent ].
	packet := packing unpack: bundle data.
	packet migrationRules: packing migrations.
	unpackedData := packet unpackedData.
	self assert: unpackedData isCollection.
	self assert: unpackedData size equals: 1.
	self assert: unpackedData anyOne class equals: ERDummyEvent.
]
