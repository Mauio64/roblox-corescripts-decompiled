local makeActionCreator = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayWithRewardState/Rodux").makeActionCreator

require("@game/CorePackages/Workspace/Packages/_Index/PlayWithRewardState/PlayWithRewardState/PlayWithRewardAdData")

return makeActionCreator("SetPlayWithRewardState", function(p2, p3, p4, p5)
	return { flowId = p2, universeId = p3, isAdDataExpected = p4, adData = p5 }
end)
