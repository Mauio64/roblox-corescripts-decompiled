local InterventionShared = script:FindFirstAncestor("InterventionShared")
local InterventionSharedParent = InterventionShared.Parent
local Constants = require(InterventionShared.Utils.Constants)

return (require(InterventionSharedParent.React).createContext(Constants.InterventionPlacementType.Unknown))
