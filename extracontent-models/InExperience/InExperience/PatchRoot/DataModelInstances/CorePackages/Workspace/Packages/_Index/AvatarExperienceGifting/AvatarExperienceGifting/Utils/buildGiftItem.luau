local parent = script:FindFirstAncestor("AvatarExperienceGifting").Parent

local Gifting = require(parent.Gifting)

local ItemType = Gifting.Enums.ItemType

local function buildGiftItem(itemId: string?)
	if itemId == nil or itemId == "" then
		return nil
	end

	return { itemType = ItemType.CollectibleItem, itemId = itemId }
end

return buildGiftItem
