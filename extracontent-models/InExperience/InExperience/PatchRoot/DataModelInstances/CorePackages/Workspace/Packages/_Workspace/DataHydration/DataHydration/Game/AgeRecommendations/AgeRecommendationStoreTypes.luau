local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

require(DataHydration.DataHydrationTypes)
local t = require(parent.t)

local SharedFlags = require(parent.SharedFlags)
local FFlagShowGameAgeRating = SharedFlags.FFlagShowGameAgeRating

local interface = t.interface
local v = {
	displayName = t.optional(t.string),
	displayNameWithHeaderShort = t.optional(t.string),
	igrsRating = t.optional(t.string),
	igrsRatingDisplayMessage = t.optional(t.string),
	minimumAgeDisplay = 0
}
local minimumAgeDisplay

if FFlagShowGameAgeRating then
	minimumAgeDisplay = t.optional(t.string)
end

v.minimumAgeDisplay = minimumAgeDisplay
local ageRecommendation = interface(v)

local interface2 = t.interface
local interface3 = t.interface
local interface4 = t.interface

if FFlagShowGameAgeRating then
	ageRecommendation = t.optional(ageRecommendation)
end

return {
	ageRecommendationResponseValidator = interface2({
		ageRecommendationDetails = interface3({
			summary = interface4({ ageRecommendation = ageRecommendation })
		})
	})
}
