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
		neverShowNotificationModalAgain = function(_, _, p)
			return neverShowNotificationModalAgain(p.fetchImpl)
		end,
		enablePushNotifications = function(_, _, p)
			return enablePushNotifications(p.fetchImpl)
		end
	},
	VirtualEvent = {
		experienceDetails = function(p, _, p2)
			return findExperienceDetailsByUniverseId(tostring(p.universeId), p2.fetchImpl)
		end,
		media = function(p, _, p2)
			return findExperienceMediaByUniverseId(tostring(p.universeId), p2.fetchImpl)
		end,
		rsvpCounters = function(p, _, p2)
			return findRsvpCountersByVirtualEventId(p.id, p2.fetchImpl)
		end,
		rsvps = function(p, _, p2)
			return findRsvpsByVirtualEventId(p.id, p2.fetchImpl)
		end
	},
	Mutation = {
		virtualEvents = function()
			return {}
		end,
		virtualEventRsvp = function(_, p, p2)
			return updateRsvpStatus(p.id, p.rsvpStatus, p2.fetchImpl)
		end
	},
	Query = {
		virtualEvent = function(_, p, p2)
			return findVirtualEventById(p.id, p2.fetchImpl)
		end,
		virtualEventsByUniverseId = function(_, p, p2)
			return findVirtualEventsByUniverseId(p.universeId, p.options, p2.fetchImpl)
		end
	}
}
