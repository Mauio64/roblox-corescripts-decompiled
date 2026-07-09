local UserList = script:FindFirstAncestor("UserList")
local UserListParent = UserList.Parent
local React = require(UserListParent.React)

require(UserList.Common.Types)

local t1 = {
	contacts = {}
}

return (React.createContext(t1))
