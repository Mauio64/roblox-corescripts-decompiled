local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local DataHydration = require(parent.DataHydration)
local Game = DataHydration.Game
local refreshPublishEligibility = require(script.Parent.refreshPublishEligibility)
local refreshAdCampaignEligibility = require(script.Parent.refreshAdCampaignEligibility)
local FFlagEnableBuildAdPromotion = require(BuildExperience.Flags.FFlagEnableBuildAdPromotion)

local function rehydrateGameMetadata(p: number)
	local v = tostring(p)

	Game.getGameInfoStore().fetchGameInfo(v)
	Game.getGameMediaStore().fetchGameMedia(v)
	refreshPublishEligibility(p)

	if FFlagEnableBuildAdPromotion then
		refreshAdCampaignEligibility(p)
	end
end

return rehydrateGameMetadata
