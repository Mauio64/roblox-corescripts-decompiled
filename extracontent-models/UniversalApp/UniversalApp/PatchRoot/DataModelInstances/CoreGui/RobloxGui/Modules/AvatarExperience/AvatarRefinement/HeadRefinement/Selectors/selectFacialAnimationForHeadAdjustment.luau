local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local CharacterManagerUtils = require(Modules.AvatarExperience.Common.Util.CharacterManagerUtils)
local FFlagHeadRefinementFacialAnimationToggle = AvatarExperienceFlags.FFlagHeadRefinementFacialAnimationToggle

local function selectFacialAnimationForHeadAdjustment(p1) -- line: 10
	-- upvalues: FFlagHeadRefinementFacialAnimationToggle (copy), CharacterManagerUtils (copy)
	if not FFlagHeadRefinementFacialAnimationToggle then
		return nil
	end

	local v8 = p1.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems or {}

	if next(v8) ~= nil then
		return CharacterManagerUtils.getStaticFacialAnimationFromTryOn(p1)
	end

	return CharacterManagerUtils.getStaticFacialAnimationFromEquippedAssets(p1)
end

return selectFacialAnimationForHeadAdjustment
