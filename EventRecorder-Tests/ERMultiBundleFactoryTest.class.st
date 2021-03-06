"
This is a test class for testing the behavior of EREventMultiBundleFactory.
"
Class {
	#name : #ERMultiBundleFactoryTest,
	#superclass : #TestCase,
	#instVars : [
		'bundle1',
		'bundle2',
		'bundle3',
		'bundle4',
		'factory',
		'multiBundles',
		'multiBundle1',
		'multiBundle2'
	],
	#category : #'EventRecorder-Tests-Support'
}

{ #category : #accessing }
ERMultiBundleFactoryTest >> allBundles [
	^ { bundle1. bundle2. bundle3. bundle4 }
]

{ #category : #private }
ERMultiBundleFactoryTest >> detectEvents [
	multiBundle1 := multiBundles first.
	multiBundle2 := multiBundles second.
	
]

{ #category : #running }
ERMultiBundleFactoryTest >> setUp [
	super setUp.
	bundle1 := ERSingleBundle new
		url: 'http://localhost/gt/events1' asZnUrl;
		category: #c1;
		data: #[1 2 3];
		yourself.
	bundle2 := ERSingleBundle new
		url: 'http://localhost/gt/events1' asZnUrl;
		category: #c1;
		data: #[4 5 6];
		yourself.
	bundle3 := ERSingleBundle new
		url: 'http://localhost/gt/events1' asZnUrl;
		category: #c2;
		data: #[7 8 9];
		yourself.
	bundle4 := ERSingleBundle new
		url: 'http://localhost/gt/events2' asZnUrl;
		category: #c1;
		data: #[10 11 12];
		yourself.
	factory := ERMultiBundleFactory new
]

{ #category : #tests }
ERMultiBundleFactoryTest >> testFromBundles [
	multiBundles := factory fromBundles: self allBundles.
	self assert: multiBundles size equals: 2.
	self detectEvents.

	self assert: multiBundle1 url equals: bundle1 url.
	self assert: multiBundle1 bundles size equals: 3.
	self assert: multiBundle1 bundles first equals: bundle1.
	self assert: multiBundle1 bundles second equals: bundle2.
	self assert: multiBundle1 bundles third equals: bundle3.

	self assert: multiBundle2 url equals: bundle4 url.
	self assert: multiBundle2 bundles size equals: 1.
	self assert: multiBundle2 bundles first equals: bundle4.

]

{ #category : #tests }
ERMultiBundleFactoryTest >> testFromBundles2 [
	"#fromBundles: can also receive ERMultiBundle object. It should be consolidate too."
	
	multiBundles := factory fromBundles: self allBundles.
	multiBundles := factory fromBundles: (self allBundles copy asOrderedCollection
		addAll: multiBundles;
		yourself) asArray.
	self assert: multiBundles size equals: 2.
	self detectEvents.

	self assert: multiBundle1 url equals: bundle1 url.
	self assert: multiBundle1 bundles size equals: 6.
	self assert: multiBundle1 bundles first equals: bundle1.
	self assert: multiBundle1 bundles second equals: bundle2.
	self assert: multiBundle1 bundles third equals: bundle3.
	self assert: multiBundle1 bundles fourth equals: bundle1.
	self assert: multiBundle1 bundles fifth equals: bundle2.
	self assert: multiBundle1 bundles sixth equals: bundle3.

	self assert: multiBundle2 url equals: bundle4 url.
	self assert: multiBundle2 bundles size equals: 2.
	self assert: multiBundle2 bundles first equals: bundle4.
	self assert: multiBundle2 bundles second equals: bundle4.

]

{ #category : #tests }
ERMultiBundleFactoryTest >> testFromBundles3 [
	"#fromBundles: can also receive ERMultiBundle object. It should be consolidate too."

	multiBundles := factory fromBundles: self allBundles.
	multiBundles := factory fromBundles: (multiBundles copy asOrderedCollection
		addAll: self allBundles;
		yourself) asArray.
	self assert: multiBundles size equals: 2.
	self detectEvents.

	self assert: multiBundle1 url equals: bundle1 url.
	self assert: multiBundle1 bundles size equals: 6.
	self assert: multiBundle1 bundles first equals: bundle1.
	self assert: multiBundle1 bundles second equals: bundle2.
	self assert: multiBundle1 bundles third equals: bundle3.
	self assert: multiBundle1 bundles fourth equals: bundle1.
	self assert: multiBundle1 bundles fifth equals: bundle2.
	self assert: multiBundle1 bundles sixth equals: bundle3.

	self assert: multiBundle2 url equals: bundle4 url.
	self assert: multiBundle2 bundles size equals: 2.
	self assert: multiBundle2 bundles first equals: bundle4.
	self assert: multiBundle2 bundles second equals: bundle4.

]

{ #category : #tests }
ERMultiBundleFactoryTest >> testFromBundles4 [
	"#fromBundles: can also receive ERMultiBundle object. It should be consolidate too."

	multiBundles := factory fromBundles: self allBundles.
	multiBundles := factory fromBundles: multiBundles.
	self assert: multiBundles size equals: 2.
	self detectEvents.

	self assert: multiBundle1 url equals: bundle1 url.
	self assert: multiBundle1 bundles size equals: 3.
	self assert: multiBundle1 bundles first equals: bundle1.
	self assert: multiBundle1 bundles second equals: bundle2.
	self assert: multiBundle1 bundles third equals: bundle3.

	self assert: multiBundle2 url equals: bundle4 url.
	self assert: multiBundle2 bundles size equals: 1.
	self assert: multiBundle2 bundles first equals: bundle4.

]
