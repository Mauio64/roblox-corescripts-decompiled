local parent = script.Parent.Parent.Parent
local dependencies = require(parent.dependencies)
local getDeepValue = dependencies.SocialLibraries.Dictionary.getDeepValue
local llama = dependencies.llama

local Constants = require(parent.Common.Constants)
require(parent.Common.ModelTypes)

local recommendationSourceEnum = dependencies.SocialCommon.Enums.RecommendationSourceEnum

return function(p)
	return function(p2)
		local v = getDeepValue(
				p2,
				string.format(
					"%s.Friends.recommendations.bySource.%s",
					Constants.RODUX_KEY,
					recommendationSourceEnum.HomepagePYMKCarousel
				)
			)
			or {}

		return llama.List.filter(p, function(p3)
			return v[p3.id]
		end)
	end
end
