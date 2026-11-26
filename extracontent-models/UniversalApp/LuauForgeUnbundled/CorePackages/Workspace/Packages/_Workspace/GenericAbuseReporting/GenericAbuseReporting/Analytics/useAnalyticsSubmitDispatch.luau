local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")
local AnalyticsSubmitContext = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Analytics/AnalyticsSubmitContext")

local function useAnalyticsDispatch()
	return (React.useContext(AnalyticsSubmitContext))
end

return useAnalyticsDispatch
