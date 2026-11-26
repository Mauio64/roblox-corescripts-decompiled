local t = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/t")

local ItemType = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Enums/ItemType")
require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Types")

local v5 = {}

function v5.invalidField(p2, p3)
	return `invalid {p2}: {tostring(p3)}`
end

v5.nonEmptyString = t.intersection(t.string, function(p2): (boolean, string)
	return p2 ~= "", "non-empty string expected, got empty string"
end)

local interface = t.interface({ itemId = v5.nonEmptyString })

local interface2 = t.interface({
	year = t.number,
	month = t.number,
	day = t.number
})

local interface3 = t.interface({ userId = t.number })

local interface4 = t.interface({
	areFriends = t.boolean,
	mutualFriendsCount = t.number,
	userAccountSinceYear = t.number
})

function v5.formatList(p2, items, callback)
	local tbl, v6 = t.table(items)

	if not tbl then
		return nil, `{p2}: {v6}`
	end

	local result = {}

	for k, item in items do
		local v7, v8 = callback(item)

		if v7 == nil then
			return nil, `{p2}[{k}]: {v8}`
		end

		table.insert(result, v7)
	end

	return result
end

function v5.formatItem(p2)
	local v6, v7 = interface(p2)

	if not v6 then
		return nil, `item: {v7}`
	end

	local v8 = ItemType.fromValue(p2.itemType)

	if v8 == nil or v8 == ItemType.Invalid then
		return nil, v5.invalidField("itemType", p2.itemType)
	end

	return { itemType = v8, itemId = p2.itemId }
end

function v5.formatDateInfo(data)
	local v6, v7 = interface2(data)

	if v6 then
		return { year = data.year, month = data.month, day = data.day }
	end

	return nil, `date: {v7}`
end

function v5.formatGiftSenderInfo(data)
	local v6, v7 = interface3(data)

	if v6 then
		return {
			userId = data.userId,
			username = data.username or "",
			displayName = data.displayName or ""
		}
	end

	return nil, `sender: {v7}`
end

function v5.formatUserRelationshipDetail(data)
	local v6, v7 = interface4(data)

	if not v6 then
		return nil, `userRelationshipDetail: {v7}`
	end

	local v8

	if data.friendSinceDate ~= nil then
		local v9
		v8, v9 = v5.formatDateInfo(data.friendSinceDate)

		if v8 == nil then
			return nil, `userRelationshipDetail.friendSinceDate: {v9}`
		end
	end

	local v9 = {
		areFriends = data.areFriends,
		mutualFriendsCount = data.mutualFriendsCount,
		friendSinceYear = 0,
		friendSinceDate = 0,
		userAccountSinceYear = 0
	}
	local v10 = if t.number(data.friendSinceYear) then data.friendSinceYear else nil
	v9.friendSinceYear = v10
	v9.friendSinceDate = v8
	v9.userAccountSinceYear = data.userAccountSinceYear
	return v9
end

return v5
