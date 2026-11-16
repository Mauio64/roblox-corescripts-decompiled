local module = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/GameDetailRodux/GameDetails")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/GameDetailRodux/GamesByPlaceId")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/GameDetailRodux/GetGameNameAndDescription")
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/GameDetailRodux/FetchGamePlayabilityAndProductInfo")
local module5 = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/GameDetailRodux/FetchUserSettingsAndOptions")
return {
	AgeRecommendations = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/GameDetailRodux/AgeRecommendations"),
	ExperienceDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/GameDetailRodux/ExperienceDetails"),
	FetchGamePlayabilityAndProductInfo = module4,
	FetchUserSettingsAndOptions = module5,
	GameDetails = module,
	GamesByPlaceId = module2,
	GetGameNameAndDescription = module3
}
