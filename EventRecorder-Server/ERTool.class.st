"
I simplify the process of downloading and extracting of recorded data.

You likely want to use #ensureLocalDirectory that downloads and extracts server data or #unpackAll if you want to load all data into memory.


Here is the code of the UI to open the settings

openSettingsBrowser
	| settingsBrowser window node nodePath |
	settingsBrowser := SettingBrowser new 
		changePackageSet: (RPackage organizer packageNamed: 'EventRecorder') asOrderedCollection;
		yourself.
	window := settingsBrowser open.
	window position: Display extent - window extent // 2.
	settingsBrowser expandAll.
	node := settingsBrowser treeHolder nodeNamed: #sendDiagnosticsAndUsageData.
	nodePath := Array 
		with: (settingsBrowser treeHolder nodeNamed: node parentName)
		with: node.
	settingsBrowser selection: (MorphTreeMorphSingleSelection new selectedNodePath: nodePath)
	


"
Class {
	#name : #ERTool,
	#superclass : #Object,
	#category : #'EventRecorder-Server'
}

{ #category : #accessing }
ERTool class >> default [
	^ self new
]

{ #category : #configuration }
ERTool >> defaultDownloadDirectory [
	^ FileSystem disk workingDirectory
]

{ #category : #configuration }
ERTool >> defaultDownloadFilename [
	^ self defaultDownloadDirectory / 'gt-events.zip'
]

{ #category : #configuration }
ERTool >> defaultEventsDirectory [
	^ self defaultDownloadDirectory / 'gt' / 'events'
]

{ #category : #private }
ERTool >> defaultEventsZipUrl [
	^ ERRecorderServer defaultBaseUrl / 'gt-events.zip'
]

{ #category : #api }
ERTool >> download [
	"self default download"
 	UIManager default informUserDuring: [ :bar |
		bar label: 'Downloading Event Data...'.
		[ ZnClient new
			url: self defaultEventsZipUrl;
			signalProgress: true;
			downloadTo: self defaultDownloadFilename ]
		on: HTTPProgress 
		do: [ :progress |
			progress isEmpty ifFalse: [ 
				bar current: progress percentage.
				progress total ifNotNil: [ :aTotalNumber |
					| humanReadable |
					humanReadable := self printHumanReadableSize: aTotalNumber.
					bar label: 'Downloading ', humanReadable, ' of Event Data... ' ] ].
			progress resume ] 
	]
]

{ #category : #api }
ERTool >> ensureDownloadedData [
	self defaultDownloadFilename exists ifFalse: [ self download ]
]

{ #category : #api }
ERTool >> ensureExtractedData [
	self defaultEventsDirectory exists ifFalse: [ self extract ]
]

{ #category : #api }
ERTool >> ensureLocalDirectory [
	"self default ensureLocalDirectory"
	self 
		ensureDownloadedData;
		ensureExtractedData
]

{ #category : #api }
ERTool >> extract [
	(ZipArchive new readFrom: self defaultDownloadFilename) extractAllTo: FileLocator workingDirectory.
]

{ #category : #printing }
ERTool >> printHumanReadableSize: aTotalNumber [
	| humanReadable length unit |
	length := ((aTotalNumber decimalDigitLength / 3) truncated) - 1 max: 0.
	humanReadable := (aTotalNumber / (1024 raisedTo: (length min: 3))) rounded.
	length = 0 ifTrue: [ unit := 'bytes' ].
	length = 1 ifTrue: [ unit := 'KB' ].
	length = 2 ifTrue: [ unit := 'MB' ].
	length = 3 ifTrue: [ unit := 'GB' ].
	^ humanReadable printString, ' ', unit
]

{ #category : #api }
ERTool >> unpackAll [
	"self default unpackAll inspect"
	self ensureLocalDirectory.
	^ ERUnpacking default safeUnpackDirectory: self defaultEventsDirectory.
]

{ #category : #api }
ERTool >> unpackAll: aFileReference [
	"self default unpackAll: './gt/events' asFileReference.
	self default unpackAll: './gt/events/roassal2Examples' asFileReference.
	" 
	self ensureLocalDirectory.
	^ ERUnpacking default safeUnpackDirectory: aFileReference.
]
