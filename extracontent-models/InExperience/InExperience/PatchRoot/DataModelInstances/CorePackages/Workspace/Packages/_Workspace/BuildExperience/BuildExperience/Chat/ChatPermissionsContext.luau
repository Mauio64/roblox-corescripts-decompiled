local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)

require(BuildExperience.useGamePermissions)

return React.createContext(nil)
