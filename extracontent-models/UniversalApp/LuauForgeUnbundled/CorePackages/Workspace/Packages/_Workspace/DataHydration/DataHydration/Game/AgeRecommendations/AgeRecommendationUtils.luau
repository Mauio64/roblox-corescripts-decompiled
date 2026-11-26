local discoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DiscoveryUtils").DiscoveryEventErrorLogger
local enumIgrsRating = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DiscoveryTypes").EnumIgrsRating
local fFlagLuaAppAddIgrsImages = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagLuaAppAddIgrsImages

local v5 = {
	[enumIgrsRating.IgrsThirteenPlus] = "rbxasset://textures/ui/LuaApp/icons/GameDetails/contentRating/igrs-13.png",
	[enumIgrsRating.IgrsFifteenPlus] = "rbxasset://textures/ui/LuaApp/icons/GameDetails/contentRating/igrs-15.png",
	[enumIgrsRating.IgrsEighteenPlus] = "rbxasset://textures/ui/LuaApp/icons/GameDetails/contentRating/igrs-18.png",
	[enumIgrsRating.IgrsUnrated] = "rbxasset://textures/ui/LuaApp/icons/GameDetails/contentRating/igrs-pending.png"
}

if fFlagLuaAppAddIgrsImages then
	if enumIgrsRating.IgrsThreePlus then
		v5[enumIgrsRating.IgrsThreePlus] = "rbxasset://textures/ui/LuaApp/icons/GameDetails/contentRating/igrs-3.png"
	end

	if enumIgrsRating.IgrsSevenPlus then
		v5[enumIgrsRating.IgrsSevenPlus] = "rbxasset://textures/ui/LuaApp/icons/GameDetails/contentRating/igrs-7.png"
	end
end

return {
	getIgrsImage = function(p2)
		if v5[p2] then
			return v5[p2]
		end

		discoveryEventErrorLogger.reportError("getIgrsImage", `Invalid IGRS rating: {p2}`)
		return nil
	end
}
