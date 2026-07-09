local Parent = script:FindFirstAncestor("DiscoveryTypes").Parent
local FFlagLuaAppAddIgrsImages = require(Parent.SharedFlags).FFlagLuaAppAddIgrsImages

return {
	IgrsThirteenPlus = "IGRS_RATING_THIRTEEN_PLUS",
	IgrsFifteenPlus = "IGRS_RATING_FIFTEEN_PLUS",
	IgrsEighteenPlus = "IGRS_RATING_EIGHTEEN_PLUS",
	IgrsUnrated = "IGRS_RATING_UNRATED",
	IgrsThreePlus = if not FFlagLuaAppAddIgrsImages then nil else "IGRS_RATING_THREE_PLUS",
	IgrsSevenPlus = if not FFlagLuaAppAddIgrsImages then nil else "IGRS_RATING_SEVEN_PLUS"
}
