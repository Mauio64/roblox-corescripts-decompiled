local Gifting = script:FindFirstAncestor("Gifting")
local parent = Gifting.Parent

local t = require(parent.t)

local ItemType = require(Gifting.Enums.ItemType)
require(Gifting.Types)

local GiftModelUtils = {}

function GiftModelUtils.invalidField(p: string, p2)
	return `invalid {p}: {tostring(p2)}`
end

GiftModelUtils.nonEmptyString = t.intersection(t.string, function(p: string): (boolean, string)
	return p ~= "", "non-empty string expected, got empty string"
end)

local interface = t.interface({ itemId = GiftModelUtils.nonEmptyString })

local interface2 = t.interface({ year = t.number, month = t.number, day = t.number })

local interface3 = t.interface({ userId = t.number })

local interface4 = t.interface({
	areFriends = t.boolean,
	mutualFriendsCount = t.number,
	userAccountSinceYear = t.number
})

function GiftModelUtils.formatList(p: string, items, callback)
	local tbl, v = t.table(items)

	if not tbl then
		return nil, `{p}: {v}`
	end

	local result = {}

	for k, item in items do
		local v2, v3 = callback(item)

		if v2 == nil then
			return nil, `{p}[{k}]: {v3}`
		end

		table.insert(result, v2)
	end

	return result
end

function GiftModelUtils.formatItem(p)
	local v, v2 = interface(p)

	if not v then
		return nil, `item: {v2}`
	end

	local itemType = ItemType.fromValue(p.itemType)

	if itemType == nil or itemType == ItemType.Invalid then
		return nil, GiftModelUtils.invalidField("itemType", p.itemType)
	end

	return { itemType = itemType, itemId = p.itemId }
end

function GiftModelUtils.formatDateInfo(data)
	local v, v2 = interface2(data)

	if v then
		return { year = data.year, month = data.month, day = data.day }
	end

	return nil, `date: {v2}`
end

function GiftModelUtils.formatGiftSenderInfo(data)
	local v, v2 = interface3(data)

	if v then
		return {
			userId = data.userId,
			username = data.username or "",
			displayName = data.displayName or ""
		}
	end

	return nil, `sender: {v2}`
end

function GiftModelUtils.formatUserRelationshipDetail(data)
	local v, v2 = interface4(data)

	if not v then
		return nil, `userRelationshipDetail: {v2}`
	end

	local friendSinceDate

	if data.friendSinceDate ~= nil then
		local v3
		friendSinceDate, v3 = GiftModelUtils.formatDateInfo(data.friendSinceDate)

		if friendSinceDate == nil then
			return nil, `userRelationshipDetail.friendSinceDate: {v3}`
		end
	end

	local v3 = {
		areFriends = data.areFriends,
		mutualFriendsCount = data.mutualFriendsCount,
		friendSinceYear = 0,
		friendSinceDate = 0,
		userAccountSinceYear = 0
	}
	local friendSinceYear

	if t.number(data.friendSinceYear) then
		friendSinceYear = data.friendSinceYear
	end

	v3.friendSinceYear = friendSinceYear
	v3.friendSinceDate = friendSinceDate
	v3.userAccountSinceYear = data.userAccountSinceYear
	return v3
end

return GiftModelUtils
