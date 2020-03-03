"
I know how to handle GET request on /gt/zip?category=categoryName path.
I compress the given category directory and return corresponding ZIP file URL as a HTTP redirect response.

See value:value: method. This is an entry point to a corresponding HTTP request.

I am used by GTEventRecorderDelegate.
"
Class {
	#name : #ERRecorderZipHandler,
	#superclass : #Object,
	#instVars : [
		'fileDirectory',
		'zipRootUrl',
		'archiver'
	],
	#category : #'EventRecorder-Server'
}

{ #category : #accessing }
ERRecorderZipHandler >> archiver [
	"Return an object that is responsible for compressing files."
	^ archiver ifNil: [ archiver := ERRecorderExternalZipScript new ]
]

{ #category : #accessing }
ERRecorderZipHandler >> archiver: anObject [
	"Set an object that is responsible for compressing files.
	It should understand #compress: directory method that returns compressed filename."
	^ archiver := anObject
]

{ #category : #accessing }
ERRecorderZipHandler >> categoryUrlFor: aString [ 
	"Return a public URL for a given category ZIP file."
	^ self zipRootUrl / aString
]

{ #category : #private }
ERRecorderZipHandler >> compress: aFileReference [ 
	"Compress aFileReference directory and return ZIP file name."
	^ self archiver compress: aFileReference
]

{ #category : #private }
ERRecorderZipHandler >> compressCategory: aString request: aZnRequest response: aZnResponse [ 
	| directory fileName url |
	directory := self fileDirectory / aString.
	directory exists ifFalse: [ 
			^ aZnResponse 
				statusLine: ZnStatusLine notFound; 
				entity: (ZnEntity textCRLF: 'Category Not Found ', aString asString );
				yourself ].
	fileName := self compress: directory.
	url := self categoryUrlFor: fileName.
	^ aZnResponse 
		statusLine: ZnStatusLine redirect;
		setLocation: url asString;
		entity: (ZnEntity textCRLF: 'Redirect ', url asString);
		yourself
]

{ #category : #accessing }
ERRecorderZipHandler >> fileDirectory [
	"Return a FileReference object where unpacked data are stored."
	^ fileDirectory
]

{ #category : #accessing }
ERRecorderZipHandler >> fileDirectory: anObject [
	"Set a FileReference object where unpacked data are stored."
	fileDirectory := anObject asFileReference
]

{ #category : #private }
ERRecorderZipHandler >> handleGetRequest: aZnRequest response: aZnResponse [ 
	"Handle GET request. aZnRequest should have category value and 
	we should compress a corresponding files and return a ZIP URL."
	| category |
	category := aZnRequest url queryAt: 'category' ifAbsent: [ nil ].
	category ifNil: [	^ aZnResponse
		statusLine: ZnStatusLine badRequest;
		entity: (ZnEntity textCRLF: '?category=<category-name> is missing in ', aZnRequest uri asString);
		yourself ].
	^ self compressCategory: category request: aZnRequest response: aZnResponse.
]

{ #category : #evaluating }
ERRecorderZipHandler >> value: aZnRequest value: aZnResponse [
	"Process GET request. The other requests are invalid."
	aZnRequest method = #GET ifTrue: [ ^ self handleGetRequest: aZnRequest response: aZnResponse ].
	^ aZnResponse
		statusLine: ZnStatusLine badRequest;
		entity: (ZnEntity textCRLF: 'Only GET is supported in ', aZnRequest uri);
		yourself
]

{ #category : #accessing }
ERRecorderZipHandler >> zipRootUrl [
	"Return a ZnUrl object from which compressed ZIP files are available on the Internet."
	^ zipRootUrl
]

{ #category : #accessing }
ERRecorderZipHandler >> zipRootUrl: anObject [
	"Set a ZnUrl object from which compressed ZIP files are available on the Internet."
	zipRootUrl := anObject asZnUrl
]
