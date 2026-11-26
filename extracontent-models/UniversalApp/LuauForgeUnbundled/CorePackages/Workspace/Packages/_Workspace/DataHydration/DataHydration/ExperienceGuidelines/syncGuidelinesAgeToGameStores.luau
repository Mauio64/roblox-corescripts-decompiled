local getGameInfoStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/GameInfo/getGameInfoStore")
local getAgeRecommendationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/AgeRecommendations/getAgeRecommendationStore")

local fFlagLuaAppDataHydrationUpdateItem = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagLuaAppDataHydrationUpdateItem

require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/ExperienceGuidelines/ExperienceGuidelinesStoreTypes")

return {
	syncGuidelinesAgeToGameStores = function(p2, p3)
		local ageRecommendationDetails = p3.ageRecommendationDetails
		local ageRecommendationSummary = ageRecommendationDetails
			and ageRecommendationDetails.ageRecommendationSummary
		local ageRecommendation = ageRecommendationSummary and ageRecommendationSummary.ageRecommendation

		if not ageRecommendation then
			return
		end

		local v5 = tostring(p2)

		if fFlagLuaAppDataHydrationUpdateItem then
			getGameInfoStore(false).updateGameInfo(v5, {
				gameMinimumAge = ageRecommendation.minimumAge,
				gameAgeDisplayName = ageRecommendation.displayName,
				contentMaturity = ageRecommendation.contentMaturity
			})
		end

		getAgeRecommendationStore(false).updateAgeRecommendations({
			[v5] = {
				displayName = ageRecommendation.displayName,
				displayNameWithHeaderShort = ageRecommendation.displayNameWithHeaderShort,
				igrsRating = ageRecommendation.igrsRating,
				igrsRatingDisplayMessage = ageRecommendation.igrsRatingDisplayMessage
			}
		})
	end
}
