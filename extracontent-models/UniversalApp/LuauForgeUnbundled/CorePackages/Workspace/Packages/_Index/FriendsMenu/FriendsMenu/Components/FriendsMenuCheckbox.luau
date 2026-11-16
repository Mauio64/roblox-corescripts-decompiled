local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/React")
local checkbox = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/Foundation").Checkbox

require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/friendsMenuModalType")

local SelectedUsersContext = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Context/SelectedUsersContext")

return function(props)
	local v5 = React.useContext(SelectedUsersContext)

	local v6 = React.useCallback(function()
		if v5.isFriendSelected(props.friend.id) then
			v5.removeFriend(props.friend.id)
		else
			v5.addFriend(props.friend.id, props.friend.displayName)
		end
	end, {
		v5.isFriendSelected(props.friend.id),
		v5.removeFriend,
		v5.addFriend,
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
		Button = React.createElement(checkbox, {
			onActivated = v6,
			isChecked = v5.isFriendSelected(props.friend.id),
			label = "",
			isDisabled = props.isDisabled,
			Selectable = props.selectable
		})
	})
end
