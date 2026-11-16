local Gifting = script:FindFirstAncestor("Gifting")
local parent = Gifting.Parent

local t = require(parent.t)

local GiftEligibility = require(Gifting.Enums.GiftEligibility)
local RequiredAction = require(Gifting.Enums.RequiredAction)
local GiftModelUtils = require(Gifting.Models.GiftModelUtils)
require(Gifting.Types)

local interface = t.interface({ isGiftable = t.boolean })

local function formatItemGiftability(p)
	local v, v2 = interface(p)

	if not v then
		return nil, `item giftability: {v2}`
	end

	local formatItem, v3 = GiftModelUtils.formatItem(p.item)

	if formatItem == nil then
		return nil, v3
	end

	return { item = formatItem, isGiftable = p.isGiftable }
end

return {
	format = function(self)
		local eligibility = GiftEligibility.fromValue(self.eligibility)

		if eligibility == nil then
			return nil, GiftModelUtils.invalidField("eligibility", self.eligibility)
		end

		local requiredActions = RequiredAction.fromValues(self.requiredActions or {})

		if requiredActions == nil then
			return nil, GiftModelUtils.invalidField("requiredActions", self.requiredActions)
		end

		local formatList, v = GiftModelUtils.formatList("items", self.items or {}, formatItemGiftability)

		if formatList == nil then
			return nil, v
		end

		return { eligibility = eligibility, requiredActions = requiredActions, items = formatList }
	end
}
