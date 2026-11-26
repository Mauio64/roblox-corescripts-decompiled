local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SignalsReact")
local TextSize = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/TextSize")
local getPreferredTextSizeLineBudget = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/getPreferredTextSizeLineBudget")

local function usePreferredTextSizeLineBudget(p2)
	local v5 = React.useCallback(function(p3)
		return getPreferredTextSizeLineBudget(TextSize.getTextSizeStore(p3).getTextSizeOffset(p3), p2)
	end, { p2 })

	return SignalsReact.useSignalState(v5)
end

return usePreferredTextSizeLineBudget
