local GameDetails = require(script.GameDetails)
local GamesByPlaceId = require(script.GamesByPlaceId)
local GetGameNameAndDescription = require(script.GetGameNameAndDescription)
local FetchGamePlayabilityAndProductInfo = require(script.FetchGamePlayabilityAndProductInfo)
local FetchUserSettingsAndOptions = require(script.FetchUserSettingsAndOptions)
local AgeRecommendations = require(script.AgeRecommendations)
local ExperienceDetails = require(script.ExperienceDetails)

return {
	AgeRecommendations = AgeRecommendations,
	ExperienceDetails = ExperienceDetails,
	FetchGamePlayabilityAndProductInfo = FetchGamePlayabilityAndProductInfo,
	FetchUserSettingsAndOptions = FetchUserSettingsAndOptions,
	GameDetails = GameDetails,
	GamesByPlaceId = GamesByPlaceId,
	GetGameNameAndDescription = GetGameNameAndDescription,
	["jest.config"] = script["jest.config"]
}
