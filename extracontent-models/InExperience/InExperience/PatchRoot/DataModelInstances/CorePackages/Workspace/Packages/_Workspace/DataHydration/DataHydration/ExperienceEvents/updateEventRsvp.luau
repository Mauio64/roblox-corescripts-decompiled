local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local HttpService = game:GetService("HttpService")
local HttpRequest = require(parent.HttpRequest)
local Promise = require(parent.Promise)
local DataHydrationUtils = require(DataHydration.DataHydrationUtils)
local getLocalPlayerUserId = DataHydrationUtils.getLocalPlayerUserId

local ExperienceEventsUrlBuilder = require(script.Parent.ExperienceEventsUrlBuilder)

local function updateEventRsvp(p: string, rsvpStatus: string)
	local localPlayerUserId = getLocalPlayerUserId()

	if not localPlayerUserId or localPlayerUserId <= 0 then
		return Promise.reject({
			ClientError = "Missing or invalid local player ID",
			message = "Cannot RSVP to event: missing or invalid local player ID"
		})
	end

	local rsvpUpdateUrl = ExperienceEventsUrlBuilder.buildRsvpUpdateUrl((tostring(p)))

	return HttpRequest.config({
		requestFunction = function(p2: string, p3: string, p4)
			return HttpRequest.requestFunctions.RequestInternal(p2, p3, p4)
		end
	})(rsvpUpdateUrl, "POST", {
		postBody = HttpService:JSONEncode({ rsvpStatus = rsvpStatus })
	})
end

return updateEventRsvp
