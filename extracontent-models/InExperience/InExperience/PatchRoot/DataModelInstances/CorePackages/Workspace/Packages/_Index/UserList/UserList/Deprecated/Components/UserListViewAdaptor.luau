local UserList = script:FindFirstAncestor("UserList")
local parent = UserList.Parent

local React = require(parent.React)
local UserListPeekView = require(script.Parent.UserListPeekView)
local Enums = require(UserList.Common.Enums)
local AppFormFactor = Enums.AppFormFactor
local Foundation = require(parent.Foundation)
local View = Foundation.View
local useListFormFactor = require(UserList.Hooks.useListFormFactor)
require(UserList.Common.Types)

local v = {
	position = UDim2.fromScale(0, 0),
	size = UDim2.fromScale(1, 1),
	anchorPoint = Vector2.new(0, 0)
}

local function UserListViewAdaptor(props)
	local v2 = useListFormFactor()
	local v3 = v2.formFactor == AppFormFactor.Compact
	local v4 = not v3 and props.wideModePeekViewLayout ~= nil
	local v5 = React.useMemo(function()
		return if v4 then props.wideModePeekViewLayout else v
	end, { v2.formFactor, props.wideModePeekViewLayout })

	if v3 or v4 then
		return React.createElement(View, {
			Size = v5.size,
			Position = v5.position,
			AnchorPoint = v5.anchorPoint
		}, {
			UserListPeekView = React.createElement(UserListPeekView, {
				users = props.users,
				title = props.title,
				onLoadMore = props.onLoadMore,
				onUserSelected = props.onUserSelected,
				hasMore = props.hasMore
			})
		})
	end

	return nil
end

return UserListViewAdaptor
