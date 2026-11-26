local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/dependencies")
local getDeepValue = dependencies.SocialLibraries.Dictionary.getDeepValue
local llama = dependencies.llama

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Common/Constants")
require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Common/ModelTypes")

local recommendationSourceEnum = dependencies.SocialCommon.Enums.RecommendationSourceEnum

return function(p2)
	return function(p3)
		local v5 = getDeepValue(
				p3,
				string.format(
					"%s.Friends.recommendations.bySource.%s",
					Constants.RODUX_KEY,
					recommendationSourceEnum.HomepagePYMKCarousel
				)
			)
			or {}

		return llama.List.filter(p2, function(p4)
			return v5[p4.id]
		end)
	end
end
