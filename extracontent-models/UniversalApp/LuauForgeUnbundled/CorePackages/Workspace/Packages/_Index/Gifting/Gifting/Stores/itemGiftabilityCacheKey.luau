local ItemType = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Enums/ItemType")
require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Types")

return {
	buildItemGiftabilityKey = function(p2)
		return `{p2.itemType}:{p2.itemId}`
	end,
	parseItemGiftabilityKey = function(value)
		local v5 = string.find(value, ":", 1, true)

		if v5 == nil then
			return nil
		end

		local v6 = ItemType.fromValue((string.sub(value, 1, v5 - 1)))

		if v6 == nil or v6 == ItemType.Invalid then
			return nil
		end

		local v7 = string.sub(value, v5 + 1)

		if v7 == "" then
			return nil
		end

		return { itemType = v6, itemId = v7 }
	end
}
