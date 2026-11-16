local parent = script:FindFirstAncestor("DataHydration").Parent
local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger
local DiscoveryTypes = require(parent.DiscoveryTypes)
local EnumIgrsRating = DiscoveryTypes.EnumIgrsRating
local SharedFlags = require(parent.SharedFlags)

local FFlagLuaAppAddIgrsImages = SharedFlags.FFlagLuaAppAddIgrsImages

local v = {
	[EnumIgrsRating.IgrsThirteenPlus] = "rbxasset://textures/ui/LuaApp/icons/GameDetails/contentRating/igrs-13.png",
	[EnumIgrsRating.IgrsFifteenPlus] = "rbxasset://textures/ui/LuaApp/icons/GameDetails/contentRating/igrs-15.png",
	[EnumIgrsRating.IgrsEighteenPlus] = "rbxasset://textures/ui/LuaApp/icons/GameDetails/contentRating/igrs-18.png",
	[EnumIgrsRating.IgrsUnrated] = "rbxasset://textures/ui/LuaApp/icons/GameDetails/contentRating/igrs-pending.png"
}

if FFlagLuaAppAddIgrsImages then
	if EnumIgrsRating.IgrsThreePlus then
		v[EnumIgrsRating.IgrsThreePlus] = "rbxasset://textures/ui/LuaApp/icons/GameDetails/contentRating/igrs-3.png"
	end

	if EnumIgrsRating.IgrsSevenPlus then
		v[EnumIgrsRating.IgrsSevenPlus] = "rbxasset://textures/ui/LuaApp/icons/GameDetails/contentRating/igrs-7.png"
	end
end

return {
	getIgrsImage = function(p)
		if v[p] then
			return v[p]
		end

		DiscoveryEventErrorLogger.reportError("getIgrsImage", `Invalid IGRS rating: {p}`)
		return nil
	end
}
