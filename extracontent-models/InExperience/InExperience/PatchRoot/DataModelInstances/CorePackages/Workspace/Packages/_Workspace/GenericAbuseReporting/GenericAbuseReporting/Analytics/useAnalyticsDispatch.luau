local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local React = require(parent.React)
local AnalyticsDispatchContext = require(script.Parent.AnalyticsDispatchContext)

local function useAnalyticsDispatch()
	return (React.useContext(AnalyticsDispatchContext))
end

return useAnalyticsDispatch
