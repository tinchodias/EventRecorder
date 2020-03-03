"
I'm a little framework to collect data from Pharo and publish it on server.

This framework has been developed by the GT team (probably T. Girba, A. Chis and others). Since this is a cool framework,I decided to invest in it and repackage it to avoid to have everything in a single package.

The vision is to have several packages.

EventRecorder
EventRecorderInspector
EventRecorderFuel
EventRecorderSTON
EventRecorderServer (should be migrated from SmalltalkHub -- See below)
EventRecorderHelp
and eventually adding tests

http://smalltalkhub.com/#!/~Moose/GToolkit repository, package GT-EventRecorder-Server, or load it using the following configuration:

Gofer it
	smalltalkhubUser: #Moose project: #GToolkit;
	configurationOf: #GTEventRecorderServer;
	loadStable.
"
Class {
	#name : #EREventRecorderHelp,
	#superclass : #CustomHelp,
	#category : #'EventRecorder-Help'
}

{ #category : #pages }
EREventRecorderHelp class >> analysis [
	^ HelpTopic 
		title: 'Data Analysis'
		contents:	
	('!! Downloading Data

	The collected data on the server are stored in the file system. The data are compressed every hour (that is the expected behavior) and can be downloaded from {url}.

	You can use {EREventTool} class to download all collected data by executing:
	
	{EREventTool} default ensureDownloadedData.
	
	It is downloaded to your working directory (next to your Pharo image). You can extract it using `{EREventTool} default ensureExtractedData`. Some versions of Pharo do not support ZIP signature that is used for large files. In such case, you can unzip manually using standard tools of your system. It is extracted into `./gt/events` directory.

!! Data Structure
	
	The data are structured per category and per month. The category is defined by the client side, see the previous section about the client. Let us say that your category is called `myCoolTool` and you have been collecting data since November 2016 to January 2017. Then you will find out the following directory structure:
	
	./gt/events/myCoolTool
		/201611/  - data collected during November 2016
		/201612/  - data collected during Dicember 2016
		/201701/  - data collected during January 2017

	Each file is a serialized {EREventPacket} object. The object is a data container of meta data and of collected events.

!! Analysis
	
	We recomend you to remove all data that you are not interested in and start your analysis. To load all data available in the directory executing:
	
	{EREventTool} default unpackAll inspect.

	It returns an association `unpackedData -> exceptions`. The key `unpackedData` includes all your data, the value `exceptions` all catched exception that happened while loading the data. You can thus load all correct data and check all errors.
	
	Remember that semantics of the data depends on you. Event Recorder only provides a convenient infrustructure to collect data.' 
		format: {
			'EREventTool' -> EREventTool.
			'EREventPacket' -> EREventPacket.
			'url' -> EREventTool defaultBaseUrl 
		} asDictionary)
]

{ #category : #accessing }
EREventRecorderHelp class >> bookDescription [
	^ 'Here, we describe Event Recorder, a moldable infrastructure, that allows to capture and store events that are specific to different tools. It is composed of a client and a server that we describe in the following sections. The last section describes basic analysis support.'
]

{ #category : #accessing }
EREventRecorderHelp class >> bookName [
	^ 'Event Recorder'
]

{ #category : #pages }
EREventRecorderHelp class >> client [
	^ HelpTopic 
		title: 'Client'
		contents:	 ('	The client includes four main objects: {EREventRecorder}, {EREventCollector}, {EREventPacket}, and {EREventTool}. The last one is described in the Data Analysis section.

!! {EREventRecorder}

	An {EREventRecorder} is responsible for collecting and sending data to a server. You, as a Event Recorder user, do not need to take care much of this object. Once you register your {EREventCollector} object, it does the job.
	
	By default, it sends data to the server every twenty minutes. If you want to send data immediately, you can use `#deliverNow` method.

	For more information, read the class comment of {EREventRecorder}.
	
!! {EREventCollector}

	An {EREventCollector} is a data collector which you want to use. You can create a new instance, register it to the {EREventRecorder} and starts to collect data. Here is a basic example:
	
	{EREventCollector} new
		category: #testingForFun; 	"the data are stored under the defined category."
		occupant: nil; 					"object that represents your application; if nil, the collector will be removed from {EREventRecorder} object once collected data are sent"
		add: 42; 							"collected data"
		add: ''Hello Pharo user''; 	"collected data"
		register; 						"please, be aware that we collect the data"
		yourself.

	You can collect any data that is possible to serialize by the recorder''s packing. By default, it uses STON for data serialization, but a Fuel alternative is available, too. (Check at `{EREventPacking} default`).
	
	Before the data are sent to the server, it is serialized and kept by an {EREventPacket} object who also keeps additional information, e.g., computer-id, data and time. The additional information helps you to group collected data per computer and order them according to time. For that reason, we recommend you to collect objects that responds to #infoAt:put:. If so, the additional information is passed to your extracted data. 

	For more information, read the class comment of {EREventCollector}.'
	format: {
		'EREventRecorder' -> EREventRecorder.
		'EREventCollector' -> EREventCollector.
		'EREventTool' -> EREventTool.
		'EREventPacking' -> EREventPacking.
		'EREventPacket' -> EREventPacket.
		} asDictionary)
]

{ #category : #pages }
EREventRecorderHelp class >> introduction [
	^ HelpTopic 
		title: 'Introduction'
		contents:	
	'	Event Recorder is a moldable infrastructure that allows to capture custom made events that are specific to different tools. The semantics of collected events belongs to tools and developers who use Event Recorder. 
	
	Essentially, Event Recorder provides an infrastructure that allows researchers and tool builders to collect data easily. That is what makes it interesting.
	
	Event Recorder is composed of a client and a server that we describe in the following sections.'
]

{ #category : #accessing }
EREventRecorderHelp class >> pages [
	^ #(introduction client server analysis)
]

{ #category : #pages }
EREventRecorderHelp class >> server [
	^ HelpTopic
		title: 'Server'
		contents:	
	('	The server is not included in the default Metacello group. It can be loaded using the following script:
	
	Metacello new 
	  baseline: ''EventRecorder'';
	  repository: ''github://pharo-contributions/EventRecorder/'';
	  load: #(server).
	
	The server uses standard Zinc Server (ZnServer class) and you can start it by executing:
	
	{EREventRecorderServer} start.
	
	By default, it runs on port 8080. If you need to run it with other services, check {EREventRecorderDelegate} class.
	
	You can stop the server using: 
	
	{EREventRecorderServer} stop.
	
	The original "GTEventRecorder" server is executed on {url}.
	
	The following section describes the data storage and data analysis.
	'
	format: {
		'EREventRecorderServer' -> EREventRecorderServer.
		'EREventRecorderDelegate' -> EREventRecorderDelegate.
		'url' -> EREventTool defaultBaseUrl } asDictionary)
]
