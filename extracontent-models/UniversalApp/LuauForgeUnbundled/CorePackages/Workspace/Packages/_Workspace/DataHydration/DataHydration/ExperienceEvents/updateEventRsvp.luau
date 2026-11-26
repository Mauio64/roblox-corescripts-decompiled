local HttpService = game:GetService("HttpService")
local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpRequest")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")
local getLocalPlayerUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationUtils").getLocalPlayerUserId

local ExperienceEventsUrlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/ExperienceEvents/ExperienceEventsUrlBuilder")

local function updateEventRsvp(p2, p3)
	local localPlayerUserId = getLocalPlayerUserId()

	if not localPlayerUserId or localPlayerUserId <= 0 then
		return Promise.reject({
			ClientError = "Missing or invalid local player ID",
			message = "Cannot RSVP to event: missing or invalid local player ID"
		})
	end

	local rsvpUpdateUrl = ExperienceEventsUrlBuilder.buildRsvpUpdateUrl((tostring(p2)))

	return HttpRequest.config({
		requestFunction = function(p4, p5, p6)
			return HttpRequest.requestFunctions.RequestInternal(p4, p5, p6)
		end
	})(rsvpUpdateUrl, "POST", {
		postBody = HttpService:JSONEncode({ rsvpStatus = p3 })
	})
end

return updateEventRsvp
