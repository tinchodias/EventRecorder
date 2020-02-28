"
I know how to create GTEventMultiBundle object from a collection of GTEventBundle objects.
"
Class {
	#name : #EREventMultiBundleFactory,
	#superclass : #Object,
	#instVars : [
		'multiBundleByUrl'
	],
	#category : #'EventRecorder-Support'
}

{ #category : #accessing }
EREventMultiBundleFactory class >> default [
	^ self new
]

{ #category : #public }
EREventMultiBundleFactory class >> fromBundles: aCollection [ 
	^ self default fromBundles: aCollection
]

{ #category : #public }
EREventMultiBundleFactory >> fromBundles: aCollection [
	multiBundleByUrl := OrderedDictionary new.
	aCollection
		do: [ :anEventBundle | anEventBundle accept: self ].
	^ self multiBundles
]

{ #category : #accessing }
EREventMultiBundleFactory >> multiBundles [
	^ multiBundleByUrl asOrderedCollection
]

{ #category : #visitor }
EREventMultiBundleFactory >> visitMultiBundle: aMultiBundle [
	aMultiBundle bundles do: [ :eachSingleBundle |
		self visitSingleBundle: eachSingleBundle ]
]

{ #category : #visitor }
EREventMultiBundleFactory >> visitSingleBundle: aSingleBundle [
	| multiBundle |
	multiBundle := multiBundleByUrl
		at: aSingleBundle url
		ifAbsentPut: [
			EREventMultiBundle new
				url: aSingleBundle url;
				yourself ].
	multiBundle add: aSingleBundle
]
