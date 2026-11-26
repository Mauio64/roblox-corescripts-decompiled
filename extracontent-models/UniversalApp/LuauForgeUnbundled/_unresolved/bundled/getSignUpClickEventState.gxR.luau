local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")

local Promise = require(CorePackages.Packages.Promise)
local experienceService = require("@luauforge/bundled/bZg").ExperienceService
local module = require("@luauforge/bundled/guP")

local function getSignUpClickEventState(p2, value)
	if not (value and string.find(value, "share")) then
		local pendingJoinAttempt = experienceService:GetPendingJoinAttempt()
		return Promise.resolve(not pendingJoinAttempt and "" or HttpService:JSONEncode(pendingJoinAttempt))
	end

	local v5, v6, v7 = string.match(value, "code=(.-)&type=(.-)&stamp=(.*)")

	if not v7 then
		v5, v6 = string.match(value, "code=(.-)&type=(.*)")
	end

	if v5 and v6 then
		return module(p2, v5, v6):andThen(function(p3)
			if p3 then
				return (HttpService:JSONEncode(p3))
			end

			return ""
		end, function(p3): string
			warn("Error fetching share link metadata: ", p3)
			return ""
		end)
	end

	return Promise.resolve("")
end

return getSignUpClickEventState
