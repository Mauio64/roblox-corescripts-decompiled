local UserList = script:FindFirstAncestor("UserList")
local parent = UserList.Parent

local React = require(parent.React)
require(UserList.Common.Types)

return (React.createContext({ contacts = {} }))
