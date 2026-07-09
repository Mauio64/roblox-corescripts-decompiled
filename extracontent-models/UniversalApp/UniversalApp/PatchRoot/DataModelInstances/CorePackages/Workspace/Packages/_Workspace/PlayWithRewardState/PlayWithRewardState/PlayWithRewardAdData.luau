local PlayWithRewardState = script:FindFirstAncestor("PlayWithRewardState")
local PlayWithRewardExperimentData = require(PlayWithRewardState.PlayWithRewardExperimentData)

return {
	new = function(p1, p2, p3, p4, p5) -- line: 16
		-- upvalues: PlayWithRewardExperimentData (copy)
		return {
			adAvailabilityResult = p1,
			productId = p2,
			productName = p3,
			productImageAssetId = p4,
			experimentVariantData = PlayWithRewardExperimentData.fromJsonData(p5)
		}
	end
}
