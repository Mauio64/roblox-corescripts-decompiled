local FriendsRodux = script:FindFirstAncestor("FriendsRodux")
local parent = FriendsRodux.Parent
local mockId = require(script.Parent.mockId)
require(script.Parent.Parent.roduxFriendsTypes)
local llama = require(parent.llama)
local RecommendationContextType = require(FriendsRodux.Enums.RecommendationContextType)

local Recommendation = {}

function Recommendation.new(data)
	assert(Recommendation.isValid(data))

	Recommendation.__index = Recommendation

	local v = {
		id = data.id,
		entityId = data.entityId,
		rank = data.rank,
		contextType = data.contextType,
		mutualFriendsList = data.mutualFriendsList,
		mutualFriendsCount = data.mutualFriendsCount,
		thumbnailEntities = data.thumbnailEntities,
		entityDisplayName = data.entityDisplayName
	}

	setmetatable(v, Recommendation)

	return v
end

function Recommendation.mock(p)
	local v = { id = mockId(), contextType = RecommendationContextType.MutualFriends }
	local joined = llama.Dictionary.join(v, p)

	local new = Recommendation.new
	local v2 = {
		id = joined.id,
		mutualFriendsList = joined.mutualFriendsList,
		rank = joined.rank or tonumber(joined.id),
		contextType = joined.contextType,
		mutualFriendsCount = 0
	}
	local mutualFriendsCount

	if joined.mutualFriendsCount then
		mutualFriendsCount = joined.mutualFriendsCount
	else
		mutualFriendsCount = joined.mutualFriendsList and #joined.mutualFriendsList or 0
	end

	v2.mutualFriendsCount = mutualFriendsCount
	return (new(v2))
end

function Recommendation.isValid(data): (boolean, string)
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

function Recommendation.isEqual(data, data2)
	local v

	if data.id == data2.id then
		v = llama.List.equals(data.mutualFriendsList, data2.mutualFriendsList)

		if v then
			if data.rank == data2.rank and data.contextType == data2.contextType then
				return data.mutualFriendsCount == data2.mutualFriendsCount
			end

			return false
		end
	else
		return false
	end

	return v
end

function Recommendation.format(data)
	local contextType

	if data.contextType then
		contextType = RecommendationContextType.fromRawValue(data.contextType) or RecommendationContextType.None
	else
		contextType = RecommendationContextType.None
	end

	local mutualFriendsCount

	if data.mutualFriendsCount then
		mutualFriendsCount = data.mutualFriendsCount
	else
		mutualFriendsCount = data.mutualFriendsList and #data.mutualFriendsList or 0
	end

	local contactId

	if data.contactId ~= "" then
		contactId = data.contactId
	end

	local entityDisplayName

	if contextType == RecommendationContextType.Contacts then
		entityDisplayName = data.displayName
	end

	return Recommendation.new(llama.Dictionary.join(data, {
		id = data.id,
		entityId = contactId,
		contextType = contextType,
		mutualFriendsCount = mutualFriendsCount,
		thumbnailEntities = data.thumbnailEntities,
		entityDisplayName = entityDisplayName
	}))
end

return Recommendation
