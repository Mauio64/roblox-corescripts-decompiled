local Parent = script:FindFirstAncestor("DataHydration").Parent
local DiscoveryEventErrorLogger = require(Parent.DiscoveryUtils).DiscoveryEventErrorLogger
local EnumIgrsRating = require(Parent.DiscoveryTypes).EnumIgrsRating
local FFlagLuaAppAddIgrsImages = require(Parent.SharedFlags).FFlagLuaAppAddIgrsImages
local t1 = {
	[EnumIgrsRating.IgrsThirteenPlus] = "rbxasset://textures/ui/LuaApp/icons/GameDetails/contentRating/igrs-13.png",
	[EnumIgrsRating.IgrsFifteenPlus] = "rbxasset://textures/ui/LuaApp/icons/GameDetails/contentRating/igrs-15.png",
	[EnumIgrsRating.IgrsEighteenPlus] = "rbxasset://textures/ui/LuaApp/icons/GameDetails/contentRating/igrs-18.png",
	[EnumIgrsRating.IgrsUnrated] = "rbxasset://textures/ui/LuaApp/icons/GameDetails/contentRating/igrs-pending.png"
}

if FFlagLuaAppAddIgrsImages then
	if EnumIgrsRating.IgrsThreePlus then
		t1[EnumIgrsRating.IgrsThreePlus] = "rbxasset://textures/ui/LuaApp/icons/GameDetails/contentRating/igrs-3.png"
	end

	if EnumIgrsRating.IgrsSevenPlus then
		t1[EnumIgrsRating.IgrsSevenPlus] = "rbxasset://textures/ui/LuaApp/icons/GameDetails/contentRating/igrs-7.png"
	end
end

return {
	getIgrsImage = function(p1) -- line: 31
		-- upvalues: t1 (copy), DiscoveryEventErrorLogger (copy)
		if not t1[p1] then
			DiscoveryEventErrorLogger.reportError("getIgrsImage", `Invalid IGRS rating: { p1 }`)

			return nil
		end

		return t1[p1]
	end
}
