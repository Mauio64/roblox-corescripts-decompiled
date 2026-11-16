local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent

local React = require(parent.React)

require(script.Parent.submitAnalytics)

return React.createContext(function() end)
