Class {
	#name : #ERPrivacyAgreementPresenterTest,
	#superclass : #TestCase,
	#category : #'EventRecorder-PharoUsageData-Tests'
}

{ #category : #tests }
ERPrivacyAgreementPresenterTest >> testMessage [

	| previousSetting |
	[ | presenter |
	previousSetting := ERPharoUsageDataPrivacy sendDiagnosticsAndUsageData.
	presenter := ERPharoUsageDataPrivacyAgreementPresenter new.
	ERPharoUsageDataPrivacy sendDiagnosticsAndUsageData: true.
	self assert: presenter privacyMessage equals: presenter sendingMessage.
	ERPharoUsageDataPrivacy sendDiagnosticsAndUsageData: false.
	self assert: presenter privacyMessage equals: presenter notSendingMessage ]
		ensure: [ ERPharoUsageDataPrivacy sendDiagnosticsAndUsageData: previousSetting ]
]

{ #category : #tests }
ERPrivacyAgreementPresenterTest >> testOpenWindowAddsItToWindowCollection [

	| presenter |
	self shouldnt: [ presenter := ERPharoUsageDataPrivacyAgreementPresenter new openWithSpec ] raise: MessageNotUnderstood.
	presenter close
]
