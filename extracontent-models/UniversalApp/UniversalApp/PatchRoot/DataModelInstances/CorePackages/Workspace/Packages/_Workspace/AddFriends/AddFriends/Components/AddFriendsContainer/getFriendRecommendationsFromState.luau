local Parent = script:FindFirstAncestor("AddFriends").Parent
local llama = require(Parent.llama)
local RecommendationSourceEnum = require(Parent.SocialCommon).Enums.RecommendationSourceEnum
local AddFriendsState = require(Parent.AddFriendsState)
local AddFriendsSelector = AddFriendsState.AddFriendsSelector
local RoduxFriends = AddFriendsState.RoduxFriends
local RecommendationContextType = RoduxFriends.Enums.RecommendationContextType
local EntityType = require(Parent.UserList).Enums.EntityType
local FFlagAddFriendsRenderTileRefactor = require(Parent.SharedFlags).FFlagAddFriendsRenderTileRefactor

return function(p1) -- line: 20
	-- upvalues: RoduxFriends (copy), RecommendationSourceEnum (copy), llama (copy), AddFriendsSelector (copy), FFlagAddFriendsRenderTileRefactor (copy), RecommendationContextType (copy), EntityType (copy)
	local LocalUserId = p1.LocalUserId
	local v12 = RoduxFriends.Selectors.getRecommendationIdsBySource(p1)(RecommendationSourceEnum.AddFriendsPage)
	local v13 = RoduxFriends.Selectors.getSortedByRankRecommendationIds(p1)(LocalUserId, v12)

	return (llama.List.map(v13, function(p2) -- line: 28
		-- upvalues: llama (copy), AddFriendsSelector (copy), p1 (copy), LocalUserId (copy), FFlagAddFriendsRenderTileRefactor (copy), RecommendationContextType (copy), EntityType (copy)
		local v15 = llama.Dictionary.join(AddFriendsSelector(p1, "Users.byUserId.%s", p2), AddFriendsSelector(p1, "Friends.recommendations.byUserId.%s.%s", LocalUserId, p2), {
			isRecommendation = true
		})

		if FFlagAddFriendsRenderTileRefactor then
			local v16 = AddFriendsSelector(p1, "Friends.recommendations.byUserId.%s.%s", LocalUserId, p2)
			local v17 = v16.contextType == RecommendationContextType.Contacts

			return llama.Dictionary.join({
				id = p2
			}, if not v17 then {} else {
				type = EntityType.Contact,
				entityId = p2,
				entityDisplayName = v16.entityDisplayName,
				thumbnailEntities = v16.thumbnailEntities
			})
		end

		return v15
	end))
end
