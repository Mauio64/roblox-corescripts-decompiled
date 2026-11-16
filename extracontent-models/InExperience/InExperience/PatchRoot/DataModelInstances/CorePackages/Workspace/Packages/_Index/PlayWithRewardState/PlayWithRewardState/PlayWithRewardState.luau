local playWithRewardState = script:FindFirstAncestor("PlayWithRewardState")

local SetPlayWithRewardState = require(playWithRewardState.SetPlayWithRewardState)
require(playWithRewardState.PlayWithRewardAdData)

local v = { flowId = "", universeId = "", isAdDataExpected = false, adData = nil }

return function(p, data)
	local v2 = p or table.clone(v)

	if data.type == SetPlayWithRewardState.name then
		return {
			flowId = data.flowId,
			universeId = data.universeId,
			isAdDataExpected = data.isAdDataExpected,
			adData = data.adData
		}
	end

	return v2
end
