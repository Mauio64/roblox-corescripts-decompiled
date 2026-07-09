local ParentParent = script.Parent.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local getDeepValue = dependencies.SocialLibraries.Dictionary.getDeepValue
local llama = dependencies.llama
local Constants = require(ParentParent.Common.Constants)

require(ParentParent.Common.ModelTypes)

local RecommendationSourceEnum = dependencies.SocialCommon.Enums.RecommendationSourceEnum

return function(t1: {[any]: any}) -- line: 18
	-- upvalues: getDeepValue (copy), Constants (copy), RecommendationSourceEnum (copy), llama (copy)
	return function(p1) -- line: 19
		-- upvalues: getDeepValue (copy), Constants (copy), RecommendationSourceEnum (copy), llama (copy), t1 (copy)
		local v9 = getDeepValue(p1, string.format("%s.Friends.recommendations.bySource.%s", Constants.RODUX_KEY, RecommendationSourceEnum.HomepagePYMKCarousel)) or {}

		return llama.List.filter(t1, function(p2) -- line: 29
			-- upvalues: v9 (copy)
			return v9[p2.id]
		end)
	end
end
