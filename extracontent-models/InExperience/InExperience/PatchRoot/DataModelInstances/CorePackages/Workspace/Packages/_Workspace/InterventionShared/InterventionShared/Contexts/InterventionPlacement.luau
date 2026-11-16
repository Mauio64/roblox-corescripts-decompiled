local InterventionShared = script:FindFirstAncestor("InterventionShared")
local parent = InterventionShared.Parent

local Constants = require(InterventionShared.Utils.Constants)
local React = require(parent.React)

return (React.createContext(Constants.InterventionPlacementType.Unknown))
