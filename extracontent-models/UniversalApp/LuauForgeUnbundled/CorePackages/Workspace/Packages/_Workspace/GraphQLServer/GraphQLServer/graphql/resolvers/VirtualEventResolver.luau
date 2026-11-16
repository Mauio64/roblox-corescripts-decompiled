local VirtualEventConnector = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql/connectors/VirtualEventConnector")
local findVirtualEventById = VirtualEventConnector.findVirtualEventById
local findVirtualEventsByUniverseId = VirtualEventConnector.findVirtualEventsByUniverseId
local findRsvpCountersByVirtualEventId = VirtualEventConnector.findRsvpCountersByVirtualEventId
local findRsvpsByVirtualEventId = VirtualEventConnector.findRsvpsByVirtualEventId
local updateRsvpStatus = VirtualEventConnector.updateRsvpStatus
local neverShowNotificationModalAgain = VirtualEventConnector.neverShowNotificationModalAgain
local enablePushNotifications = VirtualEventConnector.enablePushNotifications
local ExperienceConnector = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql/connectors/ExperienceConnector")
local findExperienceDetailsByUniverseId = ExperienceConnector.findExperienceDetailsByUniverseId
local findExperienceMediaByUniverseId = ExperienceConnector.findExperienceMediaByUniverseId
require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql/generatedTypes")

return {
	VirtualEventMutations = {
		neverShowNotificationModalAgain = function(p2, p3, p4)
			return neverShowNotificationModalAgain(p4.fetchImpl)
		end,
		enablePushNotifications = function(p2, p3, p4)
			return enablePushNotifications(p4.fetchImpl)
		end
	},
	VirtualEvent = {
		experienceDetails = function(p2, p3, p4)
			return findExperienceDetailsByUniverseId(tostring(p2.universeId), p4.fetchImpl)
		end,
		media = function(p2, p3, p4)
			return findExperienceMediaByUniverseId(tostring(p2.universeId), p4.fetchImpl)
		end,
		rsvpCounters = function(p2, p3, p4)
			return findRsvpCountersByVirtualEventId(p2.id, p4.fetchImpl)
		end,
		rsvps = function(p2, p3, p4)
			return findRsvpsByVirtualEventId(p2.id, p4.fetchImpl)
		end
	},
	Mutation = {
		virtualEvents = function()
			return {}
		end,
		virtualEventRsvp = function(p2, p3, p4)
			return updateRsvpStatus(p3.id, p3.rsvpStatus, p4.fetchImpl)
		end
	},
	Query = {
		virtualEvent = function(p2, p3, p4)
			return findVirtualEventById(p3.id, p4.fetchImpl)
		end,
		virtualEventsByUniverseId = function(p2, p3, p4)
			return findVirtualEventsByUniverseId(p3.universeId, p3.options, p4.fetchImpl)
		end
	}
}
