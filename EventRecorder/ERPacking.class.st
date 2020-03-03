"
I represent an abstract packing system that is able to receive objects and pack them into a binary data (ByteArray).

Others can ask me for serializing an object by sending me #pack: or for materializing a ByteArray by sending me #unpack:. On the class side, you can find out #fuel and #ston methods, two available packing strategies. The method #version keeps current packing version and changelog. 

The main users are GTEventRecorder (for packing) and GTEventAnnouncement (for unpacking).

Public API and Key Messages

- pack:
- unpack:
- version

"
Class {
	#name : #ERPacking,
	#superclass : #Object,
	#category : #'EventRecorder-Support'
}

{ #category : #'instance creation' }
ERPacking class >> default [
	^ self ston
]

{ #category : #'instance creation' }
ERPacking class >> fuel [
	^ ERFuelPacking new
]

{ #category : #'instance creation' }
ERPacking class >> ston [
	^ ERStonPacking new
]

{ #category : #private }
ERPacking >> materialize: aByteArray [
	^ self subclassResponsibility
]

{ #category : #accessing }
ERPacking >> migrations: anObject [ 
	"Ignore by default. Subclasses can overwrite it."
]

{ #category : #private }
ERPacking >> serialize: anObject [
	^ self subclassResponsibility
]

{ #category : #accessing }
ERPacking >> technologyName [
	"It returns a string that identify packing technology."
	^ self subclassResponsibility
]

{ #category : #packing }
ERPacking >> unpack: aByteArray [
	^ self materialize: aByteArray
]

{ #category : #accessing }
ERPacking >> version [
	^ 5
	
"
Changes to (in?) version 5:
	- Renamed classes (GT* to ER*) and more
Changes to version 4:
	- It introduces GTEventMultiBundle object that is used for sending several GTEventBundle objects to the same server in one HTTP request
	- GTStonPacking returns ByteArray instead of ByteString
Changes to version 3:
	- GTSpotterEventRecorder rewritten to GTEventRecorder.
	- It uses STON instead of FUEL serializing engine.
		- FUEL engine is still available using GTFuelPacking object
Changes to version 2 (FUEL):
	- GTSpotterEventRecorder>>timestamp keeps DateAndTime object. 
	  Before, it was an integer as unix time.
"
]
