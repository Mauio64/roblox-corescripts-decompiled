local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local parent = AvatarExperienceCommon.Parent

local OutfitTypes = require(AvatarExperienceCommon.Enums.OutfitTypes)
require(AvatarExperienceCommon.Types.CategoryTypes.CategoryTypes)
local AvatarExperienceModel = require(parent.AvatarExperienceModel)
local InventoryOutfitType = AvatarExperienceModel.Enums.InventoryOutfitType

local function getInventoryOutfitType(p, flag: boolean?)
	if p == OutfitTypes.Avatar then
		if flag == false then
			return InventoryOutfitType.Body
		end

		return InventoryOutfitType.Avatar
	end

	if p == OutfitTypes.DynamicHead then
		return InventoryOutfitType.DynamicHead
	end

	if p == OutfitTypes.Shoes then
		return InventoryOutfitType.Shoes
	end

	if p == OutfitTypes.Animations then
		return InventoryOutfitType.Animations
	end

	if p ~= OutfitTypes.Makeup then
		return nil
	end

	if flag == false then
		return InventoryOutfitType.PurchasedMakeup
	end

	return InventoryOutfitType.CreatedMakeup
end

return getInventoryOutfitType
