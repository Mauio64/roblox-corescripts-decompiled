local mockId = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Models/mockId")
require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/roduxFriendsTypes")
local llama = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/llama")
local RecommendationContextType = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Enums/RecommendationContextType")

local class = {}

function class.new(data)
	assert(class.isValid(data))

	class.__index = class

	local v5 = {
		id = data.id,
		entityId = data.entityId,
		rank = data.rank,
		contextType = data.contextType,
		mutualFriendsList = data.mutualFriendsList,
		mutualFriendsCount = data.mutualFriendsCount,
		thumbnailEntities = data.thumbnailEntities,
		entityDisplayName = data.entityDisplayName
	}

	setmetatable(v5, class)

	return v5
end

function class.mock(p2)
	local v5 = { id = mockId(), contextType = RecommendationContextType.MutualFriends }
	local joined = llama.Dictionary.join(v5, p2)

	local new = class.new
	local v6 = {
		id = joined.id,
		mutualFriendsList = joined.mutualFriendsList,
		rank = joined.rank or tonumber(joined.id),
		contextType = joined.contextType,
		mutualFriendsCount = 0
	}
	local v7 = if joined.mutualFriendsCount then joined.mutualFriendsCount else joined.mutualFriendsList and #joined.mutualFriendsList or 0
	v6.mutualFriendsCount = v7
	return (new(v6))
end

function class.isValid(data): (boolean, string)
	if not data then
		return false, "Expected recommendation information to be given"
	end

	if not data.id then
		return false, "Expected user's id to be given"
	end

	if not data.rank then
		return false, "Expected user's rank to be given"
	end

	if not (data.contextType and RecommendationContextType.isEnumValue(data.contextType)) then
		return false, "Expected contextType to be given"
	end

	if data.mutualFriendsList and type(data.mutualFriendsList) ~= "table" then
		return false, "mutualFriendList must be a table of strings"
	end

	if data.mutualFriendsCount and type(data.mutualFriendsCount) ~= "number" then
		return false, "mutualFriendsCount must be a number"
	end

	if data.contextType == RecommendationContextType.Contacts and not data.entityId then
		return false, "entity Id must be given for Contacts recommendation type"
	end

	return true, "Valid Recommendation"
end

function class.isEqual(data, data2)
	local v5

	if data.id == data2.id then
		v5 = llama.List.equals(data.mutualFriendsList, data2.mutualFriendsList)

		if v5 then
			if data.rank == data2.rank and data.contextType == data2.contextType then
				v5 = data.mutualFriendsCount == data2.mutualFriendsCount
			else
				v5 = false
			end
		end
	else
		v5 = false
	end

	return v5
end

function class.format(data)
	local v5

	if data.contextType then
		v5 = RecommendationContextType.fromRawValue(data.contextType) or RecommendationContextType.None
	else
		v5 = RecommendationContextType.None
	end

	local v6

	if data.mutualFriendsCount then
		v6 = data.mutualFriendsCount
	else
		v6 = data.mutualFriendsList and #data.mutualFriendsList or 0
	end

	local contactId = if data.contactId ~= "" then data.contactId else nil

	local v7 = if v5 == RecommendationContextType.Contacts then data.displayName else nil

	return class.new(llama.Dictionary.join(data, {
		id = data.id,
		entityId = contactId,
		contextType = v5,
		mutualFriendsCount = v6,
		thumbnailEntities = data.thumbnailEntities,
		entityDisplayName = v7
	}))
end

return class
