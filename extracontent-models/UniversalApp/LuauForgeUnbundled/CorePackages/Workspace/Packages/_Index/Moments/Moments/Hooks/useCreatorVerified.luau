local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")
local UserProfile = require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/UserProfile")

local useSignalState = SignalsReact.useSignalState

return function(p2)
	local v6 = useSignalState((React.useMemo(function()
		return UserProfile.getAndFetchUserInfo(p2).info
	end, { p2 })))

	if v6 == nil then
		return false
	end

	return v6.hasVerifiedBadge
end
