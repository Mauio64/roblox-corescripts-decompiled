local itemType = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceGifting/Gifting").Enums.ItemType

local function buildGiftItem(p2)
	if p2 == nil or p2 == "" then
		return nil
	end

	return { itemType = itemType.CollectibleItem, itemId = p2 }
end

return buildGiftItem
