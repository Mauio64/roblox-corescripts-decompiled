local PlayWithRewardState = script:FindFirstAncestor("PlayWithRewardState")
local SetPlayWithRewardState = require(PlayWithRewardState.SetPlayWithRewardState)

require(PlayWithRewardState.PlayWithRewardAdData)

local t1 = {
	flowId = "",
	universeId = "",
	isAdDataExpected = false,
	adData = nil
}

return function(p1, p2) -- line: 24
	-- upvalues: t1 (copy), SetPlayWithRewardState (copy)
	local v6 = p1 or table.clone(t1)

	if p2.type == SetPlayWithRewardState.name then
		return {
			flowId = p2.flowId,
			universeId = p2.universeId,
			isAdDataExpected = p2.isAdDataExpected,
			adData = p2.adData
		}
	end

	return v6
end
