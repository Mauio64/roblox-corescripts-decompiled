local OutfitTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Enums/OutfitTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Types/CategoryTypes/CategoryTypes")
local inventoryOutfitType = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceModel").Enums.InventoryOutfitType

local function getInventoryOutfitType(p2, p3)
	if p2 == OutfitTypes.Avatar then
		if p3 == false then
			return inventoryOutfitType.Body
		end

		return inventoryOutfitType.Avatar
	end

	if p2 == OutfitTypes.DynamicHead then
		return inventoryOutfitType.DynamicHead
	end

	if p2 == OutfitTypes.Shoes then
		return inventoryOutfitType.Shoes
	end

	if p2 == OutfitTypes.Animations then
		return inventoryOutfitType.Animations
	end

	if p2 ~= OutfitTypes.Makeup then
		return nil
	end

	if p3 == false then
		return inventoryOutfitType.PurchasedMakeup
	end

	return inventoryOutfitType.CreatedMakeup
end

return getInventoryOutfitType
