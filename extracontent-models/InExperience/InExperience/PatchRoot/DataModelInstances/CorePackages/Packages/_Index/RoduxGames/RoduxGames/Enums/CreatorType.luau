local parent = script:FindFirstAncestor("RoduxGames").Parent
local enumerate = require(parent.enumerate)

return enumerate(script.Name, { User = "User", Group = "Group" })
