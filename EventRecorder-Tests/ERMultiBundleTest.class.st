"
A GTEventMultiBundleTest is a test class for testing the behavior of GTEventMultiBundle
"
Class {
	#name : #ERMultiBundleTest,
	#superclass : #TestCase,
	#instVars : [
		'bundle1',
		'bundle2',
		'bundle3',
		'multiBundle',
		'entity'
	],
	#category : #'EventRecorder-Tests-Support'
}

{ #category : #running }
ERMultiBundleTest >> setUp [
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
	multiBundle := ERMultiBundle new
]

{ #category : #tests }
ERMultiBundleTest >> testAsZnEntity [
	self assert: multiBundle asZnEntity isEmpty
]

{ #category : #tests }
ERMultiBundleTest >> testAsZnEntity2 [
	multiBundle add: bundle1.
	entity := multiBundle asZnEntity.
	self deny: entity isEmpty.
	self assert: entity parts size equals: 2.

	self assert: entity parts first fieldName equals: 'category'.
	self assert: entity parts second fieldName equals: 'data'.

	self assert: entity parts first fieldValue equals: #c1.
	self assert: entity parts second fieldValue equals: #[1 2 3].
	
]

{ #category : #tests }
ERMultiBundleTest >> testAsZnEntity3 [
	multiBundle add: bundle1; add: bundle2.
	entity := multiBundle asZnEntity.
	self deny: entity isEmpty.
	self assert: entity parts size equals: 4.

	self assert: entity parts first fieldName equals: 'category'.
	self assert: entity parts second fieldName equals: 'data'.
	self assert: entity parts third fieldName equals: 'category'.
	self assert: entity parts fourth fieldName equals: 'data'.

	self assert: entity parts first fieldValue equals: #c1.
	self assert: entity parts second fieldValue equals: #[1 2 3].
	self assert: entity parts third fieldValue equals: #c1.
	self assert: entity parts fourth fieldValue equals: #[4 5 6].

]

{ #category : #tests }
ERMultiBundleTest >> testAsZnEntity4 [
	multiBundle add: bundle1; add: bundle2; add: bundle3.
	entity := multiBundle asZnEntity.
	self deny: entity isEmpty.
	self assert: entity parts size equals: 6.

	self assert: entity parts first fieldName equals: 'category'.
	self assert: entity parts second fieldName equals: 'data'.
	self assert: entity parts third fieldName equals: 'category'.
	self assert: entity parts fourth fieldName equals: 'data'.
	self assert: entity parts fifth fieldName equals: 'category'.
	self assert: entity parts sixth fieldName equals: 'data'.

	self assert: entity parts first fieldValue equals: #c1.
	self assert: entity parts second fieldValue equals: #[1 2 3].
	self assert: entity parts third fieldValue equals: #c1.
	self assert: entity parts fourth fieldValue equals: #[4 5 6].
	self assert: entity parts fifth fieldValue equals: #c2.
	self assert: entity parts sixth fieldValue equals: #[7 8 9].

]
