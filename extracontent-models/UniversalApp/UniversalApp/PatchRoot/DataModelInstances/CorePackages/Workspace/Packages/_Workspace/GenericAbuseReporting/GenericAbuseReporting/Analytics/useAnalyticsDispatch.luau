local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local React = require(Parent.React)
local AnalyticsDispatchContext = require(script.Parent.AnalyticsDispatchContext)

local function useAnalyticsDispatch() -- line: 6
	-- upvalues: React (copy), AnalyticsDispatchContext (copy)
	return (React.useContext(AnalyticsDispatchContext))
end

return useAnalyticsDispatch
