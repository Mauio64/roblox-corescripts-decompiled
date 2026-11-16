local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SignalsReact")

local getSduiApiStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/getSduiApiStore")

local function useEntrySurfacing(p2, p3, p4)
	local v5 = React.useCallback(function(p5)
		local v6 = if p3 then `{p2}_{p3}` else nil
		local entrySurfacing = getSduiApiStore().getEntrySurfacing(p2, v6, p5)
		return entrySurfacing and entrySurfacing[p4]
	end, { p2, p3, p4 })

	return SignalsReact.useSignalState(v5)
end

return useEntrySurfacing
