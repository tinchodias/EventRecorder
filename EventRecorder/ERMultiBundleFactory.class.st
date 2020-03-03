"
I know how to create GTEventMultiBundle object from a collection of GTEventBundle objects.
"
Class {
	#name : #ERMultiBundleFactory,
	#superclass : #Object,
	#instVars : [
		'multiBundleByUrl'
	],
	#category : #'EventRecorder-Support'
}

{ #category : #accessing }
ERMultiBundleFactory class >> default [
	^ self new
]

{ #category : #public }
ERMultiBundleFactory class >> fromBundles: aCollection [ 
	^ self default fromBundles: aCollection
]

{ #category : #public }
ERMultiBundleFactory >> fromBundles: aCollection [
	multiBundleByUrl := OrderedDictionary new.
	aCollection
		do: [ :anEventBundle | anEventBundle accept: self ].
	^ self multiBundles
]

{ #category : #accessing }
ERMultiBundleFactory >> multiBundles [
	^ multiBundleByUrl asOrderedCollection
]

{ #category : #visitor }
ERMultiBundleFactory >> visitMultiBundle: aMultiBundle [
	aMultiBundle bundles do: [ :eachSingleBundle |
		self visitSingleBundle: eachSingleBundle ]
]

{ #category : #visitor }
ERMultiBundleFactory >> visitSingleBundle: aSingleBundle [
	| multiBundle |
	multiBundle := multiBundleByUrl
		at: aSingleBundle url
		ifAbsentPut: [
			ERMultiBundle new
				url: aSingleBundle url;
				yourself ].
	multiBundle add: aSingleBundle
]
