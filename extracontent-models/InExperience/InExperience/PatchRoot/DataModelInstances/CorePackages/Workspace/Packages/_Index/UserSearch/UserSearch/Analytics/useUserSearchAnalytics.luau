local HttpService = game:GetService("HttpService")

local parent = script:FindFirstAncestor("UserSearch").Parent

local React = require(parent.React)
local Cryo = require(parent.Cryo)

local Analytics = require(script.Parent.Analytics)

local function useUserSearchAnalytics(options)
	local userSearchSessionId = options and options.userSearchSessionId or HttpService:GenerateGUID(false)

	return (React.useMemo(function()
		return Analytics({
			infoForAllEvents = Cryo.Dictionary.join(options or {}, {
				userSearchSessionId = userSearchSessionId
			})
		})
	end, { options, userSearchSessionId }))
end

return useUserSearchAnalytics
