Class {
	#name : #ERPharoUsageDataRecorder,
	#superclass : #ERRecorder,
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'EventRecorder-PharoUsageData'
}

{ #category : #cleanup }
ERPharoUsageDataRecorder class >> cleanUp [
	self reset.
]

{ #category : #initialization }
ERPharoUsageDataRecorder class >> initializeUniqueInstance [
	uniqueInstance ifNotNil: [ ^ uniqueInstance ].
	uniqueInstance := self new.
	self registerInterestToSystemAnnouncement.
	^ uniqueInstance
]

{ #category : #'instance creation' }
ERPharoUsageDataRecorder class >> new [
	"Answer a new instance with the default settings."

	^ self newWith: ERPharoUsageDataPrivacy
]

{ #category : #'instance creation' }
ERPharoUsageDataRecorder class >> newWith: aRecorderSettings [
	"Answer a new instance with the specified settings."

	^ self basicNew
		initializeWith: aRecorderSettings;
		yourself
]

{ #category : #initialization }
ERPharoUsageDataRecorder class >> registerInterestToSystemAnnouncement [
	<systemEventRegistration>
	
	uniqueInstance ifNil: [ ^ self ].
	SystemAnnouncer uniqueInstance
		unsubscribe: uniqueInstance.
	SystemAnnouncer uniqueInstance weak 
			when: ERPharoUsageDataPrivacyChangedAnnouncement
			send: #privacyChanged 
			to: uniqueInstance
]

{ #category : #initialization }
ERPharoUsageDataRecorder class >> reset [
	"Stop and remove the process for sending usage data. Delete all recorder that from the queue."
	uniqueInstance ifNil: [ ^ self ].
	SystemAnnouncer uniqueInstance unsubscribe: uniqueInstance.
	uniqueInstance deactivateDelivery ifNotNil: [ :aProcess | 
			[ aProcess terminate ] on: Error do: [ "ignore error" ] ].
	uniqueInstance := nil.
]

{ #category : #accessing }
ERPharoUsageDataRecorder class >> uniqueInstance [
	uniqueInstance ifNil: [ self initializeUniqueInstance ].
	^ uniqueInstance
]
