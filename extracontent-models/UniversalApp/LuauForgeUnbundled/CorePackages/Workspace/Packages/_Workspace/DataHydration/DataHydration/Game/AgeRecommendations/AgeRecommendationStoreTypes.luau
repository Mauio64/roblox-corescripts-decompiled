require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/t")

local fFlagShowGameAgeRating = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagShowGameAgeRating

local interface = t.interface
local v5 = {
	displayName = t.optional(t.string),
	displayNameWithHeaderShort = t.optional(t.string),
	igrsRating = t.optional(t.string),
	igrsRatingDisplayMessage = t.optional(t.string),
	minimumAgeDisplay = 0
}
local v6 = if fFlagShowGameAgeRating then t.optional(t.string) else nil
v5.minimumAgeDisplay = v6
local v7 = interface(v5)

local interface2 = t.interface
local interface3 = t.interface
local interface4 = t.interface

if fFlagShowGameAgeRating then
	v7 = t.optional(v7)
end

return {
	ageRecommendationResponseValidator = interface2({
		ageRecommendationDetails = interface3({
			summary = interface4({ ageRecommendation = v7 })
		})
	})
}
