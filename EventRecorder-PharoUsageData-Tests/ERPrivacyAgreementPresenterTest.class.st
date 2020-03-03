Class {
	#name : #ERPrivacyAgreementPresenterTest,
	#superclass : #TestCase,
	#category : #'EventRecorder-PharoUsageData-Tests'
}

{ #category : #tests }
ERPrivacyAgreementPresenterTest >> testMessage [

	| presenter privacy |
	privacy := TestPrivacySettings new.
	presenter := ERPharoUsageDataPrivacyAgreementPresenter on: privacy.
	privacy enablePermissionToSend.
	self assert: presenter privacyMessage equals: presenter sendingMessage.
	privacy disablePermissionToSend.
	self assert: presenter privacyMessage equals: presenter notSendingMessage

]

{ #category : #tests }
ERPrivacyAgreementPresenterTest >> testOpenWindowAddsItToWindowCollection [
	| presenter |
	presenter := (ERPharoUsageDataPrivacyAgreementPresenter
		on: TestPrivacySettings new) openWithSpec.
	presenter close
]
