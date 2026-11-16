local parent = script:FindFirstAncestor("DiscoveryTypes").Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppAddIgrsImages = SharedFlags.FFlagLuaAppAddIgrsImages

return {
	IgrsThreePlus = FFlagLuaAppAddIgrsImages and "IGRS_RATING_THREE_PLUS" or nil,
	IgrsSevenPlus = FFlagLuaAppAddIgrsImages and "IGRS_RATING_SEVEN_PLUS" or nil,
	IgrsThirteenPlus = "IGRS_RATING_THIRTEEN_PLUS",
	IgrsFifteenPlus = "IGRS_RATING_FIFTEEN_PLUS",
	IgrsEighteenPlus = "IGRS_RATING_EIGHTEEN_PLUS",
	IgrsUnrated = "IGRS_RATING_UNRATED"
}
