local UserList = script:FindFirstAncestor("UserList")
local UserListParent = UserList.Parent
local React = require(UserListParent.React)
local VerticalUserListSection = require(UserList.Components.VerticalUserList).VerticalUserListSection
local HorizontalUserList = require(UserList.Components.HorizontalUserList).HorizontalUserList
local Enums = require(UserList.Common.Enums)

require(UserList.Common.Types)

local function UserListLayoutAdaptor(t1: {[any]: any}) -- line: 36
	-- upvalues: Enums (copy), VerticalUserListSection (copy), HorizontalUserList (copy), React (copy)
	local v9 = if t1.layoutMode ~= Enums.LayoutMode.Vertical then HorizontalUserList else VerticalUserListSection
	local v10 = table.clone(t1)

	v10.layoutMode = nil

	return React.createElement(v9, v10)
end

return React.memo(UserListLayoutAdaptor)
