local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local Enums = require(parent.Analytics.Enums)
local RecommendationContextTypes = Enums.RecommendationContextTypes

local SharedFlags = require(parent2.SharedFlags)
local FFlagSocialCarouselMigrateRecommendations = SharedFlags.FFlagSocialCarouselMigrateRecommendations

return function(value)
	if value == nil then
		return nil
	end

	if not FFlagSocialCarouselMigrateRecommendations then
		return RecommendationContextTypes[value.rawValue()].rawValue()
	end

	if type(value) ~= "string" then
		value = value.rawValue()
	end

	local recommendationContextType = RecommendationContextTypes[value]

	if recommendationContextType then
		return (recommendationContextType.rawValue())
	end

	return nil
end
