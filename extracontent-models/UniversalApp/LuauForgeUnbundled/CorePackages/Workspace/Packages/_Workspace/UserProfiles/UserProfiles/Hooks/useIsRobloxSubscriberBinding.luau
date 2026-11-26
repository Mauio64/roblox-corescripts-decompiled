local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserProfiles/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/UserProfiles/SignalsReact")

local createIsRobloxSubscriberGetter = require("@game/CorePackages/Workspace/Packages/_Workspace/UserProfiles/UserProfiles/Hooks/createIsRobloxSubscriberGetter")

local function useIsRobloxSubscriberBinding(p2)
	local v5 = React.useMemo(function()
		return createIsRobloxSubscriberGetter(p2)
	end, { p2 })

	return SignalsReact.useSignalBinding(v5)
end

return useIsRobloxSubscriberBinding
