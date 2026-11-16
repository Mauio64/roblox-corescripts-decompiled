local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local getGameInfoStore = require(DataHydration.Game.GameInfo.getGameInfoStore)
local getAgeRecommendationStore = require(DataHydration.Game.AgeRecommendations.getAgeRecommendationStore)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppDataHydrationUpdateItem = SharedFlags.FFlagLuaAppDataHydrationUpdateItem

require(script.Parent.ExperienceGuidelinesStoreTypes)

return {
	syncGuidelinesAgeToGameStores = function(p: number, p2)
		local ageRecommendationDetails = p2.ageRecommendationDetails
		local ageRecommendationSummary = ageRecommendationDetails and ageRecommendationDetails.ageRecommendationSummary
		local ageRecommendation = ageRecommendationSummary and ageRecommendationSummary.ageRecommendation

		if not ageRecommendation then
			return
		end

		local v = tostring(p)

		if FFlagLuaAppDataHydrationUpdateItem then
			getGameInfoStore(false).updateGameInfo(v, {
				gameMinimumAge = ageRecommendation.minimumAge,
				gameAgeDisplayName = ageRecommendation.displayName,
				contentMaturity = ageRecommendation.contentMaturity
			})
		end

		getAgeRecommendationStore(false).updateAgeRecommendations({
			[v] = {
				displayName = ageRecommendation.displayName,
				displayNameWithHeaderShort = ageRecommendation.displayNameWithHeaderShort,
				igrsRating = ageRecommendation.igrsRating,
				igrsRatingDisplayMessage = ageRecommendation.igrsRatingDisplayMessage
			}
		})
	end
}
