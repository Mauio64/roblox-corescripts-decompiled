local RoduxFriends = script:FindFirstAncestor("RoduxFriends")
local RoduxFriendsParent = RoduxFriends.Parent
local mockId = require(script.Parent.mockId)

require(script.Parent.Parent.roduxFriendsTypes)

local llama = require(RoduxFriendsParent.llama)
local RecommendationContextType = require(RoduxFriends.Enums.RecommendationContextType)
local t1 = {}

function t1.new(p1) -- line: 10
	-- upvalues: t1 (copy)
	assert(t1.isValid(p1))
	t1.__index = t1

	local t2 = {
		id = p1.id,
		entityId = p1.entityId,
		rank = p1.rank,
		contextType = p1.contextType,
		mutualFriendsList = p1.mutualFriendsList,
		mutualFriendsCount = p1.mutualFriendsCount,
		thumbnailEntities = p1.thumbnailEntities,
		entityDisplayName = p1.entityDisplayName
	}

	setmetatable(t2, t1)

	return t2
end
function t1.mock(t3: {[any]: any}?) -- line: 31
	-- upvalues: mockId (copy), RecommendationContextType (copy), llama (copy), t1 (copy)
	local t4 = {
		id = mockId(),
		contextType = RecommendationContextType.MutualFriends
	}
	local v11 = llama.Dictionary.join(t4, t3)

	return (t1.new({
		id = v11.id,
		mutualFriendsList = v11.mutualFriendsList,
		rank = v11.rank or tonumber(v11.id),
		contextType = v11.contextType,
		mutualFriendsCount = if not v11.mutualFriendsCount then v11.mutualFriendsList and #v11.mutualFriendsList or 0 else v11.mutualFriendsCount
	}))
end
function t1.isValid(p2) -- line: 48
	-- upvalues: RecommendationContextType (copy)
	if not p2 then
		return false, "Expected recommendation information to be given"
	end

	if not p2.id then
		return false, "Expected user's id to be given"
	end

	if not p2.rank then
		return false, "Expected user's rank to be given"
	end

	if not p2.contextType or not RecommendationContextType.isEnumValue(p2.contextType) then
		return false, "Expected contextType to be given"
	end

	if p2.mutualFriendsList and type(p2.mutualFriendsList) ~= "table" then
		return false, "mutualFriendList must be a table of strings"
	end

	if p2.mutualFriendsCount and type(p2.mutualFriendsCount) ~= "number" then
		return false, "mutualFriendsCount must be a number"
	end

	if p2.contextType == RecommendationContextType.Contacts and not p2.entityId then
		return false, "entity Id must be given for Contacts recommendation type"
	end

	return true, "Valid Recommendation"
end
function t1.isEqual(p3, p4) -- line: 74
	-- upvalues: llama (copy)
	return p3.id == p4.id and (llama.List.equals(p3.mutualFriendsList, p4.mutualFriendsList) and (p3.rank == p4.rank and (p3.contextType == p4.contextType and p3.mutualFriendsCount == p4.mutualFriendsCount)))
end
function t1.format(p5) -- line: 85
	-- upvalues: RecommendationContextType (copy), t1 (copy), llama (copy)
	local v16 = if not p5.contextType then RecommendationContextType.None else RecommendationContextType.fromRawValue(p5.contextType) or RecommendationContextType.None
	local v17 = if not p5.mutualFriendsCount then not p5.mutualFriendsList and 0 or #p5.mutualFriendsList else p5.mutualFriendsCount
	local v18 = if p5.contactId == "" then nil else p5.contactId
	local v19 = if v16 ~= RecommendationContextType.Contacts then nil else p5.displayName

	return t1.new(llama.Dictionary.join(p5, {
		id = p5.id,
		entityId = v18,
		contextType = v16,
		mutualFriendsCount = v17,
		contactId = contactId,
		thumbnailEntities = p5.thumbnailEntities,
		entityDisplayName = v19
	}))
end

return t1
