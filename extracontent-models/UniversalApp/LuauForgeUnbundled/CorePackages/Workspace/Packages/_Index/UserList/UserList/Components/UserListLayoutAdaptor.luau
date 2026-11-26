local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/React")

local verticalUserListSection = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Components/VerticalUserList").VerticalUserListSection
local horizontalUserList = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Components/HorizontalUserList").HorizontalUserList
local Enums = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Enums")
require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Types")

local function UserListLayoutAdaptor(p2)
	local v5

	if p2.layoutMode == Enums.LayoutMode.Vertical then
		v5 = verticalUserListSection
	else
		v5 = horizontalUserList
	end

	local clone = table.clone(p2)
	clone.layoutMode = nil

	return React.createElement(v5, clone)
end

return React.memo(UserListLayoutAdaptor)
