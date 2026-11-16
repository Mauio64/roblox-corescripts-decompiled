local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local React = require(parent.React)
local AnalyticsSubmitContext = require(script.Parent.AnalyticsSubmitContext)

local function useAnalyticsDispatch()
	return (React.useContext(AnalyticsSubmitContext))
end

return useAnalyticsDispatch
