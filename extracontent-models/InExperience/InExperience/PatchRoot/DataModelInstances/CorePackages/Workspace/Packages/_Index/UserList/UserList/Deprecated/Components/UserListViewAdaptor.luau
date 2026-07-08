local UserList = script:FindFirstAncestor("UserList")
local UserListParent = UserList.Parent
local React = require(UserListParent.React)
local UserListPeekView = require(script.Parent.UserListPeekView)
local AppFormFactor = require(UserList.Common.Enums).AppFormFactor
local View = require(UserListParent.Foundation).View
local useListFormFactor = require(UserList.Hooks.useListFormFactor)

require(UserList.Common.Types)

local t1 = {
	position = UDim2.fromScale(0, 0),
	size = UDim2.fromScale(1, 1),
	anchorPoint = Vector2.new(0, 0)
}

local function UserListViewAdaptor(t2: {[any]: any}) -- line: 28
	-- upvalues: useListFormFactor (copy), AppFormFactor (copy), React (copy), t1 (copy), View (copy), UserListPeekView (copy)
	local v11 = useListFormFactor()
	local v12 = v11.formFactor == AppFormFactor.Compact
	local v13 = not v12 and t2.wideModePeekViewLayout ~= nil
	local v14 = React.useMemo(function() -- line: 32
		-- upvalues: v13 (copy), t2 (copy), t1 (copy)
		if v13 then
			return t2.wideModePeekViewLayout
		end

		return t1
	end, {
		v11.formFactor,
		t2.wideModePeekViewLayout
	})

	if not v12 and not v13 then
		return nil
	end

	return React.createElement(View, {
		Size = v14.size,
		Position = v14.position,
		AnchorPoint = v14.anchorPoint
	}, {
		UserListPeekView = React.createElement(UserListPeekView, {
			users = t2.users,
			title = t2.title,
			onLoadMore = t2.onLoadMore,
			onUserSelected = t2.onUserSelected,
			hasMore = t2.hasMore
		})
	})
end

return UserListViewAdaptor
