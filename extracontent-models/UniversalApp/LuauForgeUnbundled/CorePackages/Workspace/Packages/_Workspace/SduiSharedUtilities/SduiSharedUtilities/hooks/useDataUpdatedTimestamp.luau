local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SignalsReact")
local getSduiApiStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/getSduiApiStore")

local function useDataUpdatedTimestamp(p2, p3)
	local v5 = React.useCallback(function(p4)
		local v6 = if p3 then `{p2}_{p3}` else nil
		return getSduiApiStore().getDataUpdatedTimestamp(p2, p4, v6)
	end, { p2, p3 })

	return SignalsReact.useSignalState(v5)
end

return useDataUpdatedTimestamp
