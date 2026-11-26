local selectTryOnBodyIds = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/State/Selectors/selectTryOnBodyIds")

local function selectHasBodyTryOn(p2)
	local hasBodyTryOn

	if #selectTryOnBodyIds(p2) > 0 then
		hasBodyTryOn = true
	elseif p2.AvatarExperience.AvatarScene.OutfitTryOn == nil then
		hasBodyTryOn = false
	else
		hasBodyTryOn = p2.AvatarExperience.AvatarScene.OutfitTryOn.LookId ~= nil
	end

	return hasBodyTryOn
end

return selectHasBodyTryOn
