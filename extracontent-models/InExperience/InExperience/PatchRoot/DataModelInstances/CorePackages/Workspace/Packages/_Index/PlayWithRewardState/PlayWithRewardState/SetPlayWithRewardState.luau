local PlayWithRewardState = script:FindFirstAncestor("PlayWithRewardState")
local parent = PlayWithRewardState.Parent
local Rodux = require(parent.Rodux)
local makeActionCreator = Rodux.makeActionCreator

require(PlayWithRewardState.PlayWithRewardAdData)

return makeActionCreator(script.Name, function(flowId: string, universeId: string, isAdDataExpected: boolean, adData)
	return {
		flowId = flowId,
		universeId = universeId,
		isAdDataExpected = isAdDataExpected,
		adData = adData
	}
end)
