local FriendsMenu = script:FindFirstAncestor("FriendsMenu")
local parent = FriendsMenu.Parent
local Context = FriendsMenu.Context

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Checkbox = Foundation.Checkbox

require(FriendsMenu.friendsMenuModalType)

local SelectedUsersContext = require(Context.SelectedUsersContext)

return function(props)
	local v = React.useContext(SelectedUsersContext)

	local onActivated = React.useCallback(function()
		if v.isFriendSelected(props.friend.id) then
			v.removeFriend(props.friend.id)
		else
			v.addFriend(props.friend.id, props.friend.displayName)
		end
	end, {
		v.isFriendSelected(props.friend.id),
		v.removeFriend,
		v.addFriend,
		props.friend.id
	})

	return React.createElement("Frame", {
		AutomaticSize = Enum.AutomaticSize.XY,
		AnchorPoint = props.anchorPoint,
		Position = props.position,
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder
	}, {
		CheckboxAlignment = React.createElement("UIListLayout", {
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		Button = React.createElement(Checkbox, {
			onActivated = onActivated,
			isChecked = v.isFriendSelected(props.friend.id),
			label = "",
			isDisabled = props.isDisabled,
			Selectable = props.selectable
		})
	})
end
