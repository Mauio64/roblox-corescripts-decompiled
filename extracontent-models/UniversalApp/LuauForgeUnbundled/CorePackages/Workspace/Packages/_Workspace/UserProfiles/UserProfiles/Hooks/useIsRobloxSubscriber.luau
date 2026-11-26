local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserProfiles/React")
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/UserProfiles/SignalsReact").useSignalState

local createIsRobloxSubscriberGetter = require("@game/CorePackages/Workspace/Packages/_Workspace/UserProfiles/UserProfiles/Hooks/createIsRobloxSubscriberGetter")

local function useIsRobloxSubscriber(p2)
	return (useSignalState((React.useMemo(function()
		return createIsRobloxSubscriberGetter(p2)
	end, { p2 }))))
end

return useIsRobloxSubscriber
