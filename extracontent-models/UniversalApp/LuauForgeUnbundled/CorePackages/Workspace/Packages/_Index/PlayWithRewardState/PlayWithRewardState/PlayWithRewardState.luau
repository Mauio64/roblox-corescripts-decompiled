local SetPlayWithRewardState = require("@game/CorePackages/Workspace/Packages/_Index/PlayWithRewardState/PlayWithRewardState/SetPlayWithRewardState")
require("@game/CorePackages/Workspace/Packages/_Index/PlayWithRewardState/PlayWithRewardState/PlayWithRewardAdData")

local v5 = { flowId = "", universeId = "", isAdDataExpected = false, adData = nil }

return function(p2, data)
	local v6 = p2 or table.clone(v5)

	if data.type == SetPlayWithRewardState.name then
		return {
			flowId = data.flowId,
			universeId = data.universeId,
			isAdDataExpected = data.isAdDataExpected,
			adData = data.adData
		}
	end

	return v6
end
