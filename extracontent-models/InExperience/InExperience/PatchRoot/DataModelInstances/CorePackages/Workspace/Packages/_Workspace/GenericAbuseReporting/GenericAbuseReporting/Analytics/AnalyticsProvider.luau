local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local React = require(Parent.React)
local submitAnalytics = require(script.Parent.submitAnalytics)
local AnalyticsSubmitContext = require(script.Parent.AnalyticsSubmitContext)
local AnalyticsStateContext = require(script.Parent.AnalyticsStateContext)
local AnalyticsDispatchContext = require(script.Parent.AnalyticsDispatchContext)
local AnalyticsReducer = require(script.Parent.AnalyticsReducer)

local function AnalyticsProvider(t1: {[any]: any}) -- line: 22
	-- upvalues: React (copy), AnalyticsReducer (copy), submitAnalytics (copy), AnalyticsSubmitContext (copy), AnalyticsStateContext (copy), AnalyticsDispatchContext (copy)
	local v10, v11 = React.useReducer(AnalyticsReducer.reducer, AnalyticsReducer.initialState)
	local v12 = React.useCallback(function(p1) -- line: 25
		-- upvalues: t1 (copy), v10 (copy), submitAnalytics (copy)
		local v14 = if not t1.onBeforeSubmitAnalytics then v10 else t1.onBeforeSubmitAnalytics(v10)

		if v14 then
			if t1.onSubmitAnalytics then
				t1.onSubmitAnalytics(v14, p1)

				return
			end

			submitAnalytics(v14, p1)
		end
	end, {
		v10,
		t1.onBeforeSubmitAnalytics,
		t1.onSubmitAnalytics
	})

	return React.createElement(AnalyticsSubmitContext.Provider, {
		value = v12
	}, {
		stateProvider = React.createElement(AnalyticsStateContext.Provider, {
			value = v10
		}, {
			dispatchProvider = React.createElement(AnalyticsDispatchContext.Provider, {
				value = v11
			}, t1.children)
		})
	})
end

return AnalyticsProvider
