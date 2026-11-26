local HttpService = game:GetService("HttpService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/Cryo")

local Analytics = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Analytics/Analytics")

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
