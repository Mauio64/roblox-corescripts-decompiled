local Parent = script:FindFirstAncestor("AddFriends").Parent
local t = require(Parent.t)
local Images = require(Parent.UIBlox).App.ImageSet.Images

require(script.Parent.getFriendRequestHandlersExtraProps)

local IconName = require(Parent.Foundation).Enums.IconName
local FocusNavigationEventNameEnum = require(Parent.FocusNavigationUtils).FocusNavigationEventNameEnum
local ButtonTypes = require(Parent.UserList).Enums.ButtonTypes
local FFlagAddFriendsUserListEnabled = require(Parent.SharedFlags).FFlagAddFriendsUserListEnabled
local v8 = t.strictInterface({
	isFriendRequest = t.boolean,
	hasIncomingFriendRequest = t.optional(t.boolean),
	friendStatus = t.optional(t.enum(Enum.FriendStatus)),
	handleRequestFriendship = t.optional(t.callback),
	handleAcceptFriendRequest = t.optional(t.callback),
	handleDeclineFriendRequest = t.optional(t.callback),
	shouldAddFocusEventName = t.optional(t.boolean)
})

return function(p1) -- line: 34
	-- upvalues: v8 (copy), FFlagAddFriendsUserListEnabled (copy), IconName (copy), Images (copy), FocusNavigationEventNameEnum (copy), ButtonTypes (copy)
	assert(v8(p1))

	local t1 = {}

	if p1.isFriendRequest then
		if (p1.friendStatus or Enum.FriendStatus.FriendRequestReceived) == Enum.FriendStatus.FriendRequestReceived then
			table.insert(t1, {
				icon = if not FFlagAddFriendsUserListEnabled then Images["icons/actions/reject"] else IconName.X,
				isSecondary = not FFlagAddFriendsUserListEnabled or nil,
				onActivated = function() -- line: 50
					-- upvalues: p1 (copy)
					p1.handleDeclineFriendRequest()
				end,
				focusEventName = if not p1.shouldAddFocusEventName then nil else FocusNavigationEventNameEnum.IgnoreFriendRequest,
				type = if not FFlagAddFriendsUserListEnabled then nil else ButtonTypes.Dismiss
			})
			table.insert(t1, {
				icon = Images["icons/actions/friends/friendAdd"],
				isSecondary = not not FFlagAddFriendsUserListEnabled and nil,
				onActivated = function() -- line: 61
					-- upvalues: p1 (copy)
					p1.handleAcceptFriendRequest()
				end,
				focusEventName = if not p1.shouldAddFocusEventName then nil else FocusNavigationEventNameEnum.HoldToAcceptFriendRequest,
				type = if not FFlagAddFriendsUserListEnabled then nil else ButtonTypes.Accept
			})

			return t1
		end
	else
		local v11 = p1.friendStatus or Enum.FriendStatus.NotFriend

		if p1.hasIncomingFriendRequest then
			table.insert(t1, {
				icon = Images["icons/actions/friends/friendAdd"],
				isSecondary = not not FFlagAddFriendsUserListEnabled and nil,
				onActivated = function() -- line: 80
					-- upvalues: p1 (copy)
					p1.handleAcceptFriendRequest()
				end,
				focusEventName = if not p1.shouldAddFocusEventName then nil else FocusNavigationEventNameEnum.HoldToAcceptFriendRequest,
				type = if not FFlagAddFriendsUserListEnabled then nil else ButtonTypes.Accept
			})

			return t1
		end

		if v11 == Enum.FriendStatus.NotFriend then
			table.insert(t1, {
				icon = Images["icons/actions/friends/friendAdd"],
				isSecondary = not not FFlagAddFriendsUserListEnabled and nil,
				onActivated = function() -- line: 92
					-- upvalues: p1 (copy)
					p1.handleRequestFriendship()
				end,
				focusEventName = if not p1.shouldAddFocusEventName then nil else FocusNavigationEventNameEnum.HoldToAddFriend,
				type = if not FFlagAddFriendsUserListEnabled then nil else ButtonTypes.Add
			})

			return t1
		end

		if v11 == Enum.FriendStatus.FriendRequestSent then
			table.insert(t1, {
				isDisabled = true,
				icon = Images["icons/actions/friends/friendpending"],
				isSecondary = not not FFlagAddFriendsUserListEnabled and nil,
				onActivated = function() -- line: 105
				end,
				type = if not FFlagAddFriendsUserListEnabled then nil else ButtonTypes.Pending
			})
		end
	end

	return t1
end
