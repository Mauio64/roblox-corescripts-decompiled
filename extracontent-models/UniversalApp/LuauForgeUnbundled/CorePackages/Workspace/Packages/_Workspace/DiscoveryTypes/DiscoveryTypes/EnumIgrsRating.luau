local fFlagLuaAppAddIgrsImages = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryTypes/SharedFlags").FFlagLuaAppAddIgrsImages

return {
	IgrsThreePlus = fFlagLuaAppAddIgrsImages and "IGRS_RATING_THREE_PLUS" or nil,
	IgrsSevenPlus = fFlagLuaAppAddIgrsImages and "IGRS_RATING_SEVEN_PLUS" or nil,
	IgrsThirteenPlus = "IGRS_RATING_THIRTEEN_PLUS",
	IgrsFifteenPlus = "IGRS_RATING_FIFTEEN_PLUS",
	IgrsEighteenPlus = "IGRS_RATING_EIGHTEEN_PLUS",
	IgrsUnrated = "IGRS_RATING_UNRATED"
}
