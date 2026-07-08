local FriendsMenu = script:FindFirstAncestor("FriendsMenu")
local FriendsMenuParent = FriendsMenu.Parent
local Context = FriendsMenu.Context
local React = require(FriendsMenuParent.React)
local Checkbox = require(FriendsMenuParent.Foundation).Checkbox

require(FriendsMenu.friendsMenuModalType)

local SelectedUsersContext = require(Context.SelectedUsersContext)

return function(t1: {[any]: any}) -- line: 23
	-- upvalues: React (copy), SelectedUsersContext (copy), Checkbox (copy)
	local v8 = React.useContext(SelectedUsersContext)
	local v9 = React.useCallback(function() -- line: 27
		-- upvalues: v8 (copy), t1 (copy)
		if v8.isFriendSelected(t1.friend.id) then
			v8.removeFriend(t1.friend.id)

			return
		end

		v8.addFriend(t1.friend.id, t1.friend.displayName)
	end, {
		v8.isFriendSelected(t1.friend.id),
		v8.removeFriend,
		v8.addFriend,
		t1.friend.id
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		AnchorPoint = t1.anchorPoint,
		Position = t1.position,
		LayoutOrder = t1.layoutOrder
	}, {
		CheckboxAlignment = React.createElement("UIListLayout", {
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		Button = React.createElement(Checkbox, {
			label = "",
			onActivated = v9,
			isChecked = v8.isFriendSelected(t1.friend.id),
			isDisabled = t1.isDisabled,
			Selectable = t1.selectable
		})
	})
end
