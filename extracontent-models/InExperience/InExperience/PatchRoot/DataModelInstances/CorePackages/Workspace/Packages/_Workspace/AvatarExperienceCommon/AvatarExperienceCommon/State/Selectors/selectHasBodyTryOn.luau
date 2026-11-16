local selectTryOnBodyIds = require(script.Parent.selectTryOnBodyIds)

local function selectHasBodyTryOn(p)
	local hasBodyTryOn

	if #selectTryOnBodyIds(p) > 0 then
		hasBodyTryOn = true
	elseif p.AvatarExperience.AvatarScene.OutfitTryOn == nil then
		hasBodyTryOn = false
	else
		hasBodyTryOn = p.AvatarExperience.AvatarScene.OutfitTryOn.LookId ~= nil
	end

	return hasBodyTryOn
end

return selectHasBodyTryOn
