local Gifting = script:FindFirstAncestor("Gifting")

local ItemType = require(Gifting.Enums.ItemType)
require(Gifting.Types)
local ItemGiftabilityCacheKey = {}

function ItemGiftabilityCacheKey.buildItemGiftabilityKey(p)
	return `{p.itemType}:{p.itemId}`
end

function ItemGiftabilityCacheKey.parseItemGiftabilityKey(value: string)
	local v = string.find(value, ":", 1, true)

	if v == nil then
		return nil
	end

	local itemType = ItemType.fromValue((string.sub(value, 1, v - 1)))

	if itemType == nil or itemType == ItemType.Invalid then
		return nil
	end

	local itemId = string.sub(value, v + 1)

	if itemId == "" then
		return nil
	end

	return { itemType = itemType, itemId = itemId }
end

return ItemGiftabilityCacheKey
