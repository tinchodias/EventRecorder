Class {
	#name : #ERTestPrivacySettings,
	#superclass : #Object,
	#instVars : [
		'hasPermissionToSend'
	],
	#category : #'EventRecorder-Tests-Support'
}

{ #category : #accessing }
ERTestPrivacySettings >> disablePermissionToSend [
	hasPermissionToSend := false
]

{ #category : #accessing }
ERTestPrivacySettings >> enablePermissionToSend [
	hasPermissionToSend := true
]

{ #category : #testing }
ERTestPrivacySettings >> hasPermissionToSend [
	^ hasPermissionToSend
]

{ #category : #initialization }
ERTestPrivacySettings >> initialize [
	super initialize.
	
	hasPermissionToSend := true.
]
