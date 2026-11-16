local parent = script:FindFirstAncestor("GameInfosRodux").Parent

require(parent.DataHydration)
require(parent.DiscoveryTypes)

local function toLegacyGameInfoModel(data)
	local creator = data.creator

	local legacyGameInfoModel = {
		universeId = data.universeId,
		placeId = data.rootPlaceId,
		name = data.name,
		playerCount = data.playerCount,
		contentMaturity = data.contentMaturity,
		minimumAge = data.gameMinimumAge,
		ageRecommendationDisplayName = data.gameAgeDisplayName,
		creatorId = 0,
		creatorName = 0
	}
	local creatorId

	if creator then
		creatorId = creator.id
	end

	legacyGameInfoModel.creatorId = creatorId
	local creatorName

	if creator then
		creatorName = creator.name
	end

	legacyGameInfoModel.creatorName = creatorName
	return legacyGameInfoModel
end

return toLegacyGameInfoModel
