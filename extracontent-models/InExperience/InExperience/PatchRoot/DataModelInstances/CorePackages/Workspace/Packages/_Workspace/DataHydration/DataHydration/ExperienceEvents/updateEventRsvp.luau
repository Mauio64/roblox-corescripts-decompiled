local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local HttpService = game:GetService("HttpService")
local HttpRequest = require(DataHydrationParent.HttpRequest)
local Promise = require(DataHydrationParent.Promise)
local getLocalPlayerUserId = require(DataHydration.DataHydrationUtils).getLocalPlayerUserId
local ExperienceEventsUrlBuilder = require(script.Parent.ExperienceEventsUrlBuilder)

local function updateEventRsvp(s1: string, s2: string) -- line: 13
	-- upvalues: getLocalPlayerUserId (copy), Promise (copy), ExperienceEventsUrlBuilder (copy), HttpRequest (copy), HttpService (copy)
	local v11 = getLocalPlayerUserId()

	if not v11 or v11 <= 0 then
		return Promise.reject({
			ClientError = "Missing or invalid local player ID",
			message = "Cannot RSVP to event: missing or invalid local player ID"
		})
	end

	local v12 = ExperienceEventsUrlBuilder.buildRsvpUpdateUrl((tostring(s1)))

	return HttpRequest.config({
		requestFunction = function(s3: string, s4: string, p1) -- line: 25
			-- upvalues: HttpRequest (copy)
			return HttpRequest.requestFunctions.RequestInternal(s3, s4, p1)
		end
	})(v12, "POST", {
		postBody = HttpService:JSONEncode({
			rsvpStatus = s2
		})
	})
end

return updateEventRsvp
