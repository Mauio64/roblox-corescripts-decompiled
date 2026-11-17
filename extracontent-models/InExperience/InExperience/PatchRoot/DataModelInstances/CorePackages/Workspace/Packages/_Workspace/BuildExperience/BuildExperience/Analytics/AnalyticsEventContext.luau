local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)

require(BuildExperience.Analytics.AnalyticsPageEvents)

return React.createContext(nil)
