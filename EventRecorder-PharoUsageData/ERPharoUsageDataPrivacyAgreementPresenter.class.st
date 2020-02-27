"
I'm a simple window to display privacy information based on previously set settings.
"
Class {
	#name : #ERPharoUsageDataPrivacyAgreementPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'text',
		'settingButton'
	],
	#category : #'EventRecorder-PharoUsageData'
}

{ #category : #specs }
ERPharoUsageDataPrivacyAgreementPresenter class >> defaultSpec [

	^  SpBoxLayout newVertical
			add: #text;
			add:
			(SpBoxLayout newHorizontal
				add: #settingButton;
				yourself)
			withConstraints: [ :constraints | constraints height: self toolbarHeight ];
		yourself
]

{ #category : #actions }
ERPharoUsageDataPrivacyAgreementPresenter class >> openSettingsBrowser [
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
	settingsBrowser selection: (MorphTreeMorphSingleSelection new selectedNodePath: nodePath).
]

{ #category : #testing }
ERPharoUsageDataPrivacyAgreementPresenter >> hasPermissionToSend [
	^ ERPharoUsageDataPrivacy hasPermissionToSend
]

{ #category : #initialize }
ERPharoUsageDataPrivacyAgreementPresenter >> initializePresenters [

	text := self newText.
	text text: self privacyMessage.
	settingButton := self newButton.
	settingButton
		label: 'Go to setting ';
		action: [ self openSettingsBrowser ].
]

{ #category : #initialize }
ERPharoUsageDataPrivacyAgreementPresenter >> initializeWindow: aWindowPresenter [
	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: 'Privacy agreement';
		initialExtent: 400 @ 200
]

{ #category : #accessing }
ERPharoUsageDataPrivacyAgreementPresenter >> notSendingMessage [
	^ 'No diagnostic and usage data is being sent. Would you like to send diagnostic and usage data to help us improve Pharo?'
]

{ #category : #private }
ERPharoUsageDataPrivacyAgreementPresenter >> openSettingsBrowser [
	self class openSettingsBrowser
]

{ #category : #accessing }
ERPharoUsageDataPrivacyAgreementPresenter >> privacyMessage [
	^ self hasPermissionToSend
		ifTrue: [ self sendingMessage ]
		ifFalse: [ self notSendingMessage ]
]

{ #category : #accessing }
ERPharoUsageDataPrivacyAgreementPresenter >> sendingMessage [

	^ 'You are sending diagnostic and usage data to help us improve Pharo. Thanks!' 
]
