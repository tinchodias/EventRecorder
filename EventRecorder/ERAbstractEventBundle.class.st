"
I define the common API for Event Recorder bundles. See my subclasses.
"
Class {
	#name : #ERAbstractEventBundle,
	#superclass : #Object,
	#instVars : [
		'url'
	],
	#category : #'EventRecorder-Support'
}

{ #category : #visitor }
ERAbstractEventBundle >> accept: aVisitor [ 
	^ self subclassResponsibility
]

{ #category : #converting }
ERAbstractEventBundle >> asZnEntity [
	^ self subclassResponsibility
]

{ #category : #accessing }
ERAbstractEventBundle >> url [
	^ url
]

{ #category : #accessing }
ERAbstractEventBundle >> url: aZnUrl [
	url := aZnUrl
]
