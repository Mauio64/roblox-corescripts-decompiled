local GraphQLServer = script:FindFirstAncestor("GraphQLServer")
local VirtualEventConnector = require(GraphQLServer.graphql.connectors.VirtualEventConnector)
local findVirtualEventById = VirtualEventConnector.findVirtualEventById
local findVirtualEventsByUniverseId = VirtualEventConnector.findVirtualEventsByUniverseId
local findRsvpCountersByVirtualEventId = VirtualEventConnector.findRsvpCountersByVirtualEventId
local findRsvpsByVirtualEventId = VirtualEventConnector.findRsvpsByVirtualEventId
local updateRsvpStatus = VirtualEventConnector.updateRsvpStatus
local neverShowNotificationModalAgain = VirtualEventConnector.neverShowNotificationModalAgain
local enablePushNotifications = VirtualEventConnector.enablePushNotifications
local ExperienceConnector = require(GraphQLServer.graphql.connectors.ExperienceConnector)
local findExperienceDetailsByUniverseId = ExperienceConnector.findExperienceDetailsByUniverseId
local findExperienceMediaByUniverseId = ExperienceConnector.findExperienceMediaByUniverseId

require(GraphQLServer.graphql.generatedTypes)

return {
	VirtualEventMutations = {
		neverShowNotificationModalAgain = function(_, _, p3) -- line: 19
			-- upvalues: neverShowNotificationModalAgain (copy)
			return neverShowNotificationModalAgain(p3.fetchImpl)
		end,
		enablePushNotifications = function(_, _, p6) -- line: 22
			-- upvalues: enablePushNotifications (copy)
			return enablePushNotifications(p6.fetchImpl)
		end
	},
	VirtualEvent = {
		experienceDetails = function(p7, _, p9) -- line: 27
			-- upvalues: findExperienceDetailsByUniverseId (copy)
			return findExperienceDetailsByUniverseId(tostring(p7.universeId), p9.fetchImpl)
		end,
		media = function(p10, _, p12) -- line: 30
			-- upvalues: findExperienceMediaByUniverseId (copy)
			return findExperienceMediaByUniverseId(tostring(p10.universeId), p12.fetchImpl)
		end,
		rsvpCounters = function(p13, _, p15) -- line: 33
			-- upvalues: findRsvpCountersByVirtualEventId (copy)
			return findRsvpCountersByVirtualEventId(p13.id, p15.fetchImpl)
		end,
		rsvps = function(p16, _, p18) -- line: 36
			-- upvalues: findRsvpsByVirtualEventId (copy)
			return findRsvpsByVirtualEventId(p16.id, p18.fetchImpl)
		end
	},
	Mutation = {
		virtualEvents = function() -- line: 41
			return {}
		end,
		virtualEventRsvp = function(_, p20, p21) -- line: 44
			-- upvalues: updateRsvpStatus (copy)
			return updateRsvpStatus(p20.id, p20.rsvpStatus, p21.fetchImpl)
		end
	},
	Query = {
		virtualEvent = function(_, p23, p24) -- line: 49
			-- upvalues: findVirtualEventById (copy)
			return findVirtualEventById(p23.id, p24.fetchImpl)
		end,
		virtualEventsByUniverseId = function(_, p26, p27) -- line: 52
			-- upvalues: findVirtualEventsByUniverseId (copy)
			return findVirtualEventsByUniverseId(p26.universeId, p26.options, p27.fetchImpl)
		end
	}
}
