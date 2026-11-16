local PlayWithRewardExperimentData = require("@game/CorePackages/Workspace/Packages/_Index/PlayWithRewardState/PlayWithRewardState/PlayWithRewardExperimentData")

return {
	new = function(p2, p3, p4, p5, p6)
		return {
			["adAvailabilityResult"] = p2,
			productId = p3,
			productName = p4,
			productImageAssetId = p5,
			experimentVariantData = PlayWithRewardExperimentData.fromJsonData(p6)
		}
	end
}
