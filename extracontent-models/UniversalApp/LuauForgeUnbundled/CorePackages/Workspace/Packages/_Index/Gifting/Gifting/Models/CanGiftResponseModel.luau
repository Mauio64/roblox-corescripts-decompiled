local t = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/t")

local GiftEligibility = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Enums/GiftEligibility")
local RequiredAction = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Enums/RequiredAction")
local GiftModelUtils = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Models/GiftModelUtils")
require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Types")

local interface = t.interface({ isGiftable = t.boolean })

local function formatItemGiftability(p2)
	local v5, v6 = interface(p2)

	if not v5 then
		return nil, `item giftability: {v6}`
	end

	local formatItem, v7 = GiftModelUtils.formatItem(p2.item)

	if formatItem == nil then
		return nil, v7
	end

	return { item = formatItem, isGiftable = p2.isGiftable }
end

return {
	format = function(data)
		local v5 = GiftEligibility.fromValue(data.eligibility)

		if v5 == nil then
			return nil, GiftModelUtils.invalidField("eligibility", data.eligibility)
		end

		local v6 = RequiredAction.fromValues(data.requiredActions or {})

		if v6 == nil then
			return nil, GiftModelUtils.invalidField("requiredActions", data.requiredActions)
		end

		local formatList, v7 = GiftModelUtils.formatList("items", data.items or {}, formatItemGiftability)

		if formatList == nil then
			return nil, v7
		end

		return { eligibility = v5, requiredActions = v6, items = formatList }
	end
}
