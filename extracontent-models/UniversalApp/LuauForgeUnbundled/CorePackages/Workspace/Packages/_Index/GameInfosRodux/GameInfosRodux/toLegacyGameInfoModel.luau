require("@game/CorePackages/Workspace/Packages/_Workspace/GameInfosRodux/DataHydration")
require("@game/CorePackages/Workspace/Packages/_Workspace/GameInfosRodux/DiscoveryTypes")

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
	local v5 = if creator then creator.id else nil
	legacyGameInfoModel.creatorId = v5
	local v6 = if creator then creator.name else nil
	legacyGameInfoModel.creatorName = v6
	return legacyGameInfoModel
end

return toLegacyGameInfoModel
