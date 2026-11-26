local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/React")
local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/SduiSharedUtilities")

local buildHomeSortDropDownOptions = require("@game/CorePackages/Workspace/Packages/_Index/Home/Home/HomeSortDetailPage/buildHomeSortDropDownOptions")
local HomeConstants = require("@game/CorePackages/Workspace/Packages/_Index/Home/Home/HomeConstants")

local function useHomeSortDropDownOptions()
	local v5 = SduiSharedUtilities.useInputData(HomeConstants.ConfigKey, HomeConstants.ContentIdentifier)
	return React.useMemo(function()
		return buildHomeSortDropDownOptions(v5)
	end, { v5 })
end

return useHomeSortDropDownOptions
