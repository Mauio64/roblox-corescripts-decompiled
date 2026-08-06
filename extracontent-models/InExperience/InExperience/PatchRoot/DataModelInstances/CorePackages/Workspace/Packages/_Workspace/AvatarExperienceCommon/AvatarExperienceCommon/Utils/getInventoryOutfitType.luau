local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local OutfitTypes = require(AvatarExperienceCommon.Enums.OutfitTypes)

require(AvatarExperienceCommon.Types.CategoryTypes.CategoryTypes)

local InventoryOutfitType = require(AvatarExperienceCommon.Enums.InventoryOutfitType)

local function getInventoryOutfitType(p1, b1: boolean?) -- line: 15
	-- upvalues: OutfitTypes (copy), InventoryOutfitType (copy)
	if p1 == OutfitTypes.Avatar then
		if b1 ~= false then
			return InventoryOutfitType.Avatar
		end

		return InventoryOutfitType.Body
	end

	if p1 == OutfitTypes.DynamicHead then
		return InventoryOutfitType.DynamicHead
	end

	if p1 == OutfitTypes.Shoes then
		return InventoryOutfitType.Shoes
	end

	if p1 == OutfitTypes.Animations then
		return InventoryOutfitType.Animations
	end

	if p1 == OutfitTypes.Makeup then
		if b1 ~= false then
			return InventoryOutfitType.CreatedMakeup
		end

		return InventoryOutfitType.PurchasedMakeup
	end

	return nil
end

return getInventoryOutfitType
