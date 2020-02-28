"
A GTEventBundleTest is a test class for testing the behavior of GTEventBundle
"
Class {
	#name : #EREventBundleTest,
	#superclass : #TestCase,
	#instVars : [
		'bundle',
		'data',
		'entity',
		'category',
		'url'
	],
	#category : #'EventRecorder-Tests-Support'
}

{ #category : #running }
EREventBundleTest >> setUp [
	super setUp.
	bundle := EREventSingleBundle new.
	data := #[1 2 3 4].

	self flag: #fix. "These properties are not tested"
	category := #category1.
	url := 'http://localhost/gt/events' asZnUrl.

]

{ #category : #tests }
EREventBundleTest >> testAsZnEntity [
	bundle data: data.
	entity := bundle asZnEntity.
	self assert: (entity isKindOf: ZnByteArrayEntity).
	self assert: entity bytes equals: data.
]

{ #category : #tests }
EREventBundleTest >> testData [
	"It is really important that it is the same object."

	bundle data: data.
	self assert: bundle data identicalTo: bundle data
]
