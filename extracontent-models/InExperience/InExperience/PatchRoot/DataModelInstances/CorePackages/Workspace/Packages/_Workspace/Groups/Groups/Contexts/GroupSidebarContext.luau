local Groups = script:FindFirstAncestor("Groups")
local parent = Groups.Parent
local React = require(parent.React)
require(Groups.Stores.createGroupSidebarState)

return React.createContext(nil)
