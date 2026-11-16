local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)

require("@luauforge/bundled/dMc")

return Rodux.makeActionCreator(
	"AddLookDetails",
	function(p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16)
		return {
			lookAssetInfos = p5,
			lookBundleInfos = p6,
			lookId = p2,
			lookType = p7,
			totalValue = p8,
			totalPrice = p3,
			totalPremiumPrice = p4,
			curator = p9,
			description = p10,
			moderationStatus = p11,
			name = p12,
			displayProperties = p13,
			favoriteCount = p14,
			isFavorited = p15,
			lookDiscounts = p16
		}
	end
)
