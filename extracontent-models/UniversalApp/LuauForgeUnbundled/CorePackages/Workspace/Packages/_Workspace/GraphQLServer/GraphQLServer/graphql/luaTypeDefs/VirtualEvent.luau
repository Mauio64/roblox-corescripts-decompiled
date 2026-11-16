return [[
	    enum EventStatus {
	        unpublished
	        active
	        cancelled
moderated
	    }
	
	    enum RsvpStatus {
	        none
	        going
	        maybeGoing
	        notGoing
	    }
	
	    enum HostType {
	        user
	        group
	    }
	
	    type EventTime {
	        startUtc: String
	        endUtc: String
	    }
	
	    type Host {
	        hostId: ID
	        hostType: HostType
	        hostName: String
	        hasVerifiedBadge: Boolean
	    }
	
	    type Rsvp {
	        userId: ID
	        rsvpStatus: RsvpStatus
	    }
	
	    type RsvpCounters {
	        none: Float
	        going: Float
	        maybeGoing: Float
	        notGoing: Float
	    }
	    
	    type EventCategory {
	        category: String
	        rank: Int
	    }
	
	    type VirtualEvent {
	        id: ID!
	        title: String
	        displayTitle: String
	        subtitle: String
	        displaySubtitle: String
	        description: String
	        displayDescription: String
	        host: Host
	        universeId: ID
	        placeId: String
	        eventStatus: EventStatus
	        eventTime: EventTime
	        createdUtc: String
	        updatedUtc: String
	        userRsvpStatus: RsvpStatus
	        eventCategories: [ EventCategory ]
	
	        experienceDetails: ExperienceDetails
	        media: [ ExperienceMedia! ]
	        rsvpCounters: RsvpCounters
	        rsvps: [ Rsvp! ]
	    }
	
	    input VirtualEventsByUniverseIdOptions {
	        cursor: String,
	        limit: Int
	        fromUtc: String
	    }
	
	    type VirtualEventsPage {
	        cursor: String
	        virtualEvents: [ VirtualEvent! ]
	    }
	
	    type RsvpResponse {
	        shouldSeeNotificationsUpsellModal: Boolean
	        virtualEvent: VirtualEvent
	    }
	
	    type VirtualEventMutations {
	        neverShowNotificationModalAgain: Boolean
enablePushNotifications: Boolean
	    }
	
	    type Mutation {
	        virtualEvents: VirtualEventMutations!
	        virtualEventRsvp(id: ID!, rsvpStatus: RsvpStatus!): RsvpResponse
	    }
	
	    type Query {
	        virtualEvent(id: ID!): VirtualEvent
	        virtualEventsByUniverseId(universeId: ID!, options: VirtualEventsByUniverseIdOptions): VirtualEventsPage
	    }
	]]
