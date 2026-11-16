local PlayWithRewardState = script:FindFirstAncestor("PlayWithRewardState")
local PlayWithRewardExperimentData = require(PlayWithRewardState.PlayWithRewardExperimentData)

return {
	new = function(adAvailabilityResult, productId, productName, productImageAssetId, p)
		return {
			["adAvailabilityResult"] = adAvailabilityResult,
			productId = productId,
			productName = productName,
			productImageAssetId = productImageAssetId,
			experimentVariantData = PlayWithRewardExperimentData.fromJsonData(p)
		}
	end
}
