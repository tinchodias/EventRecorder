Class {
	#name : #TestPrivacySettings,
	#superclass : #Object,
	#instVars : [
		'hasPermissionToSend'
	],
	#category : #'EventRecorder-Server-Tests'
}

{ #category : #accessing }
TestPrivacySettings >> disablePermissionToSend [
	hasPermissionToSend := false
]

{ #category : #accessing }
TestPrivacySettings >> enablePermissionToSend [
	hasPermissionToSend := true
]

{ #category : #testing }
TestPrivacySettings >> hasPermissionToSend [
	^ hasPermissionToSend
]

{ #category : #initialization }
TestPrivacySettings >> initialize [
	super initialize.
	
	hasPermissionToSend := true.
]
