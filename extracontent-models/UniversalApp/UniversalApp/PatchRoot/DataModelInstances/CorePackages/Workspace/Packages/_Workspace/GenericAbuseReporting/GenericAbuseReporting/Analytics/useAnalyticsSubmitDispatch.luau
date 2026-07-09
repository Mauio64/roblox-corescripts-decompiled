local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local React = require(Parent.React)
local AnalyticsSubmitContext = require(script.Parent.AnalyticsSubmitContext)

local function useAnalyticsDispatch() -- line: 6
	-- upvalues: React (copy), AnalyticsSubmitContext (copy)
	return (React.useContext(AnalyticsSubmitContext))
end

return useAnalyticsDispatch
