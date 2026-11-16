local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent

local React = require(parent.React)

local submitAnalytics = require(script.Parent.submitAnalytics)
local AnalyticsSubmitContext = require(script.Parent.AnalyticsSubmitContext)
local AnalyticsStateContext = require(script.Parent.AnalyticsStateContext)
local AnalyticsDispatchContext = require(script.Parent.AnalyticsDispatchContext)
local AnalyticsReducer = require(script.Parent.AnalyticsReducer)

local function AnalyticsProvider(props)
	local v, v2 = React.useReducer(AnalyticsReducer.reducer, AnalyticsReducer.initialState)

	local v3 = React.useCallback(function(p)
		local v3

		if props.onBeforeSubmitAnalytics then
			v3 = props.onBeforeSubmitAnalytics(v)
		else
			v3 = v
		end

		if v3 then
			if props.onSubmitAnalytics then
				props.onSubmitAnalytics(v3, p)
			else
				submitAnalytics(v3, p)
			end
		end
	end, { v, props.onBeforeSubmitAnalytics, props.onSubmitAnalytics })

	return React.createElement(AnalyticsSubmitContext.Provider, { value = v3 }, {
		stateProvider = React.createElement(AnalyticsStateContext.Provider, { value = v }, {
			dispatchProvider = React.createElement(AnalyticsDispatchContext.Provider, { value = v2 }, props.children)
		})
	})
end

return AnalyticsProvider
