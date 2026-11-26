local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
require("@luauforge/bundled/dKT")
local module2 = require("@luauforge/bundled/gKV")

local fFlagHeadRefinementFacialAnimationToggle = AvatarExperienceFlags.FFlagHeadRefinementFacialAnimationToggle

local function selectFacialAnimationForHeadAdjustment(p2)
	if not fFlagHeadRefinementFacialAnimationToggle then
		return nil
	end

	local tryOnItems = p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems or {}

	if next(tryOnItems) ~= nil then
		return module2.getStaticFacialAnimationFromTryOn(p2)
	end

	return module2.getStaticFacialAnimationFromEquippedAssets(p2)
end

return selectFacialAnimationForHeadAdjustment
