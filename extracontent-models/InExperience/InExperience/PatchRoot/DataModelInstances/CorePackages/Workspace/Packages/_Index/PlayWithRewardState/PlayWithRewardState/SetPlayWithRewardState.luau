local PlayWithRewardState = script:FindFirstAncestor("PlayWithRewardState")
local PlayWithRewardStateParent = PlayWithRewardState.Parent
local makeActionCreator = require(PlayWithRewardStateParent.Rodux).makeActionCreator

require(PlayWithRewardState.PlayWithRewardAdData)

return makeActionCreator(script.Name, function(s1: string, s2: string, b1: boolean, p1) -- line: 11
	return {
		flowId = s1,
		universeId = s2,
		isAdDataExpected = b1,
		adData = p1
	}
end)
