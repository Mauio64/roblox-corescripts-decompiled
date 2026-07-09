local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local getGameInfoStore = require(DataHydration.Game.GameInfo.getGameInfoStore)
local getAgeRecommendationStore = require(DataHydration.Game.AgeRecommendations.getAgeRecommendationStore)
local FFlagLuaAppDataHydrationUpdateItem = require(DataHydrationParent.SharedFlags).FFlagLuaAppDataHydrationUpdateItem
local FFlagSduiExperienceDetailsSupport = require(DataHydrationParent.SharedFlags).FFlagSduiExperienceDetailsSupport

require(script.Parent.ExperienceGuidelinesStoreTypes)

return {
	syncGuidelinesAgeToGameStores = function(n1: number, p1) -- line: 13
		-- upvalues: FFlagLuaAppDataHydrationUpdateItem (copy), getGameInfoStore (copy), FFlagSduiExperienceDetailsSupport (copy), getAgeRecommendationStore (copy)
		local ageRecommendationDetails = p1.ageRecommendationDetails
		local v10 = ageRecommendationDetails and ageRecommendationDetails.ageRecommendationSummary
		local v11 = v10 and v10.ageRecommendation

		if not v11 then
			return
		end

		local str = tostring(n1)

		if FFlagLuaAppDataHydrationUpdateItem then
			getGameInfoStore(false).updateGameInfo(str, {
				gameMinimumAge = v11.minimumAge,
				gameAgeDisplayName = v11.displayName,
				contentMaturity = v11.contentMaturity
			})
		end

		if FFlagSduiExperienceDetailsSupport then
			getAgeRecommendationStore(false).updateAgeRecommendations({
				[str] = {
					displayName = v11.displayName,
					displayNameWithHeaderShort = v11.displayNameWithHeaderShort,
					igrsRating = v11.igrsRating,
					igrsRatingDisplayMessage = v11.igrsRatingDisplayMessage
				}
			})
		end
	end
}
