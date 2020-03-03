Extension { #name : #ERTool }

{ #category : #'*EventRecorder-Inspector' }
ERTool >> gtInspectorActionHelp [
	<gtInspectorAction>
	^ GLMGenericAction new
		action: [:b | 
		HelpBrowser open selectTopicSatisfying: [:each |
			each owner notNil and:  [
			(each owner key = ERRecorderHelp key) and: [
				each title = 'Data Analysis' ] ] ] ];
		icon: GLMUIThemeExtraIcons glamorousHelp;
		title: 'Help'
]
