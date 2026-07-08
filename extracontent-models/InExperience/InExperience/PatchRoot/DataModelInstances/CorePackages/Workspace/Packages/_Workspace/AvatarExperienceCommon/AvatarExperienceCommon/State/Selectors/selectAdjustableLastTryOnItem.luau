local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local Cryo = require(Parent.Cryo)

return function(p1) -- line: 6
	-- upvalues: Cryo (copy)
	local OutfitTryOn = p1.AvatarExperience.AvatarScene.OutfitTryOn

	if OutfitTryOn.LastToggledItem and OutfitTryOn.AdjustableTryOnIds then
		local itemId = OutfitTryOn.LastToggledItem.itemId

		if Cryo.List.find(OutfitTryOn.AdjustableTryOnIds, itemId) then
			return itemId
		end
	end

	return nil
end
