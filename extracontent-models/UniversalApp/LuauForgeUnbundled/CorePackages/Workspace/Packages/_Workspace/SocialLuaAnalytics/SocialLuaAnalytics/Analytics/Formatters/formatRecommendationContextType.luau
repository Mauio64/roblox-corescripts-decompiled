local recommendationContextTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/Enums").RecommendationContextTypes

local fFlagSocialCarouselMigrateRecommendations = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SharedFlags").FFlagSocialCarouselMigrateRecommendations

return function(value)
	if value == nil then
		return nil
	end

	if not fFlagSocialCarouselMigrateRecommendations then
		return recommendationContextTypes[value.rawValue()].rawValue()
	end

	if type(value) ~= "string" then
		value = value.rawValue()
	end

	local recommendationContextType = recommendationContextTypes[value]

	if recommendationContextType then
		return (recommendationContextType.rawValue())
	end

	return nil
end
