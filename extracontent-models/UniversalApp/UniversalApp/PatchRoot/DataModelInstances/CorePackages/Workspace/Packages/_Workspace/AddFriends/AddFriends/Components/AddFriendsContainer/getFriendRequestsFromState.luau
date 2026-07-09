local Parent = script:FindFirstAncestor("AddFriends").Parent
local AddFriendsState = require(Parent.AddFriendsState)
local AddFriendsSelector = AddFriendsState.AddFriendsSelector
local llama = require(Parent.llama)
local RoduxPresence = AddFriendsState.RoduxPresence
local FFlagFriendRequestNicknames = require(Parent.SharedFlags).FFlagFriendRequestNicknames
local sortFriendRequestsByOrder = require(script.Parent.sortFriendRequestsByOrder)
local FFlagAddFriendsRenderTileRefactor = require(Parent.SharedFlags).FFlagAddFriendsRenderTileRefactor

return function(p1) -- line: 15
	-- upvalues: AddFriendsSelector (copy), llama (copy), FFlagAddFriendsRenderTileRefactor (copy), RoduxPresence (copy), FFlagFriendRequestNicknames (copy), sortFriendRequestsByOrder (copy)
	local v10 = AddFriendsSelector(p1, "Friends.requests.byUserId")

	if not v10 then
		return {}
	end

	local v11 = llama.Dictionary.keys(v10)
	local v12 = llama.List.map(v11, function(p2) -- line: 22
		-- upvalues: AddFriendsSelector (copy), p1 (copy), FFlagAddFriendsRenderTileRefactor (copy), llama (copy), RoduxPresence (copy), FFlagFriendRequestNicknames (copy)
		local v14 = AddFriendsSelector(p1, "Friends.requests.order.requestsById.%s", p2)

		if FFlagAddFriendsRenderTileRefactor then
			return {
				id = p2,
				order = v14
			}
		end

		return llama.Dictionary.join(AddFriendsSelector(p1, "Users.byUserId.%s", p2), RoduxPresence.Selectors.getUserPresenceByUserId(p1, p2), {
			sentAt = AddFriendsSelector(p1, "Friends.requests.sentAt.%s", p2)
		}, {
			mutualFriends = AddFriendsSelector(p1, "Friends.requests.mutualFriends.%s", p2)
		}, {
			contactName = AddFriendsSelector(p1, "Friends.contactNamesByUserId.%s", p2)
		}, {
			order = v14
		}, {
			senderNickname = if not FFlagFriendRequestNicknames then nil else AddFriendsSelector(p1, `Friends.requests.senderNickname.{ p2 }`)
		})
	end)

	return sortFriendRequestsByOrder(v12)
end
