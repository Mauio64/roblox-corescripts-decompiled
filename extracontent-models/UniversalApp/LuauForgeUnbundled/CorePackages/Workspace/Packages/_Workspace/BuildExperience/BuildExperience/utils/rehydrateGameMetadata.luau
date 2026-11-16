local Game = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration").Game
local refreshPublishEligibility = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/refreshPublishEligibility")
local refreshAdCampaignEligibility = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/refreshAdCampaignEligibility")
local FFlagEnableBuildAdPromotion = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagEnableBuildAdPromotion")

local function rehydrateGameMetadata(p2)
	local v5 = tostring(p2)

	Game.getGameInfoStore().fetchGameInfo(v5)
	Game.getGameMediaStore().fetchGameMedia(v5)
	refreshPublishEligibility(p2)

	if FFlagEnableBuildAdPromotion then
		refreshAdCampaignEligibility(p2)
	end
end

return rehydrateGameMetadata
