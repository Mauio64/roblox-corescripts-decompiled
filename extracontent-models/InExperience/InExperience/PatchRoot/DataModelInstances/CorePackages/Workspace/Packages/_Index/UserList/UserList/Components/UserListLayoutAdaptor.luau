local UserList = script:FindFirstAncestor("UserList")
local parent = UserList.Parent

local React = require(parent.React)

local VerticalUserList = require(UserList.Components.VerticalUserList)
local VerticalUserListSection = VerticalUserList.VerticalUserListSection
local HorizontalUserList = require(UserList.Components.HorizontalUserList)
local horizontalUserList = HorizontalUserList.HorizontalUserList
local Enums = require(UserList.Common.Enums)
require(UserList.Common.Types)

local function UserListLayoutAdaptor(p)
	local v

	if p.layoutMode == Enums.LayoutMode.Vertical then
		v = VerticalUserListSection
	else
		v = horizontalUserList
	end

	local clone = table.clone(p)
	clone.layoutMode = nil

	return React.createElement(v, clone)
end

return React.memo(UserListLayoutAdaptor)
