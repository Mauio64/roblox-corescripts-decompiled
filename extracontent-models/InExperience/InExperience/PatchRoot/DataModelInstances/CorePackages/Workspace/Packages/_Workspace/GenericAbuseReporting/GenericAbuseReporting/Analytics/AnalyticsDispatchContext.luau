local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent

local React = require(parent.React)

return React.createContext(function() end)
