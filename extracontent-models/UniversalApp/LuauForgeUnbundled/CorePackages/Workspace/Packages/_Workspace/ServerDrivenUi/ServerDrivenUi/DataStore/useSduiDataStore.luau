local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")

require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")

local useSduiSocialData = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/DataStore/useSduiSocialData")

local function useSduiDataStore()
	local v5 = useSduiSocialData()

	return React.useMemo(function()
		return { social = v5 }
	end, { v5 })
end

return useSduiDataStore
