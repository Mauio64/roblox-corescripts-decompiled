local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent

require(DataHydration.DataHydrationTypes)

local t = require(DataHydrationParent.t)
local FFlagSduiExperienceDetailsSupport = require(DataHydrationParent.SharedFlags).FFlagSduiExperienceDetailsSupport

return {
	ageRecommendationResponseValidator = t.interface({
		ageRecommendationDetails = t.interface({
			summary = t.interface({
				ageRecommendation = t.interface({
					displayName = t.optional(t.string),
					displayNameWithHeaderShort = t.optional(t.string),
					igrsRating = if not FFlagSduiExperienceDetailsSupport then nil else t.optional(t.string),
					igrsRatingDisplayMessage = if not FFlagSduiExperienceDetailsSupport then nil else t.optional(t.string)
				})
			})
		})
	})
}
