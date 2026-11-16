local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

local submitAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Analytics/submitAnalytics")
local AnalyticsSubmitContext = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Analytics/AnalyticsSubmitContext")
local AnalyticsStateContext = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Analytics/AnalyticsStateContext")
local AnalyticsDispatchContext = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Analytics/AnalyticsDispatchContext")
local AnalyticsReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Analytics/AnalyticsReducer")

local function AnalyticsProvider(props)
	local v5, v6 = React.useReducer(AnalyticsReducer.reducer, AnalyticsReducer.initialState)

	local v7 = React.useCallback(function(p2)
		local v8 = if props.onBeforeSubmitAnalytics then props.onBeforeSubmitAnalytics(v5) else v5

		if v8 then
			if props.onSubmitAnalytics then
				props.onSubmitAnalytics(v8, p2)
			else
				submitAnalytics(v8, p2)
			end
		end
	end, { v5, props.onBeforeSubmitAnalytics, props.onSubmitAnalytics })

	return React.createElement(AnalyticsSubmitContext.Provider, { value = v7 }, {
		stateProvider = React.createElement(AnalyticsStateContext.Provider, { value = v5 }, {
			dispatchProvider = React.createElement(AnalyticsDispatchContext.Provider, { value = v6 }, props.children)
		})
	})
end

return AnalyticsProvider
