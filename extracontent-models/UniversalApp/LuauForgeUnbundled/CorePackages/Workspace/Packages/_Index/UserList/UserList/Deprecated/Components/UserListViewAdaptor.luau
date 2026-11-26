local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/React")
local module2 = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Deprecated/Components/UserListPeekView")
local appFormFactor = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Enums").AppFormFactor
local view = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/Foundation").View
local useListFormFactor = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Hooks/useListFormFactor")
require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Types")

local v5 = {
	position = UDim2.fromScale(0, 0),
	size = UDim2.fromScale(1, 1),
	anchorPoint = Vector2.new(0, 0)
}

local function UserListViewAdaptor(props)
	local v6 = useListFormFactor()
	local v7 = v6.formFactor == appFormFactor.Compact
	local v8 = not v7 and props.wideModePeekViewLayout ~= nil
	local v9 = React.useMemo(function()
		if v8 then
			return props.wideModePeekViewLayout
		end

		return v5
	end, { v6.formFactor, props.wideModePeekViewLayout })

	if v7 or v8 then
		return React.createElement(
			view,
			{ Size = v9.size, Position = v9.position, AnchorPoint = v9.anchorPoint },
			{
				UserListPeekView = React.createElement(module2, {
					users = props.users,
					title = props.title,
					onLoadMore = props.onLoadMore,
					onUserSelected = props.onUserSelected,
					hasMore = props.hasMore
				})
			}
		)
	end

	return nil
end

return UserListViewAdaptor
