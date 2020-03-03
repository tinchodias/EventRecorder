"
I represents Privacy settings. You can open Settings Browser and see Privacy group.

Execute: SettingBrowser open
"
Class {
	#name : #ERRecorderSettings,
	#superclass : #Object,
	#classInstVars : [
		'url'
	],
	#category : #'EventRecorder-Settings'
}

{ #category : #cleanup }
ERRecorderSettings class >> cleanUp [
	"Clean settings."
	url := nil
]

{ #category : #accessing }
ERRecorderSettings class >> stringUrl [
	^ self url asString
]

{ #category : #accessing }
ERRecorderSettings class >> stringUrl: aUrlString [
	^ self url: aUrlString
]

{ #category : #accessing }
ERRecorderSettings class >> url [
	^ url ifNil: [ url := 'http://gc.dcc.uchile.cl:8080/gt/events' asZnUrl ]
]

{ #category : #accessing }
ERRecorderSettings class >> url: aZnUrl [
	url := aZnUrl ifNotNil: [ aZnUrl asZnUrl ]
]

{ #category : #settings }
ERRecorderSettings class >> urlSettingsOn: aBuilder [ 
	<systemsettings>	
	(aBuilder setting: #stringUrl)
		parent: #gt;
		target: self;
		description: 'The default URL for the Event Recorder server.';
		label: 'Event Recorder URL address'

]
