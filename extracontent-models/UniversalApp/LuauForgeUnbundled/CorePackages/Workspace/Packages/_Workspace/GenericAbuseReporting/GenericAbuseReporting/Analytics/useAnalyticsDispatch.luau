local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")
local AnalyticsDispatchContext = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Analytics/AnalyticsDispatchContext")

local function useAnalyticsDispatch()
	return (React.useContext(AnalyticsDispatchContext))
end

return useAnalyticsDispatch
