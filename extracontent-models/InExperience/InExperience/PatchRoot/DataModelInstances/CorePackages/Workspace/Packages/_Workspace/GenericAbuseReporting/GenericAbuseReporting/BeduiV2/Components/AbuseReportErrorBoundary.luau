local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local React = require(GenericAbuseReportingParent.React)
local forwardErrorToScriptContext = require(GenericAbuseReporting.BeduiV2.Analytics.forwardErrorToScriptContext)
local v5 = React.Component:extend("AbuseReportErrorBoundary")

function v5.getDerivedStateFromError(_) -- line: 36
	return {
		hasError = true
	}
end
function v5.init(p2) -- line: 40
	p2.state = {
		hasError = false
	}
end
function v5.componentDidCatch(t1: {[any]: any}, p3, t2: {[any]: any}) -- line: 44
	-- upvalues: forwardErrorToScriptContext (copy)
	local onError = t1.props.onError

	if onError then
		onError(p3, t2)
	end

	forwardErrorToScriptContext(p3, t2 and t2.componentStack or nil)
end
function v5.render(p4) -- line: 53
	local props = p4.props

	if p4.state.hasError then
		return props.fallback
	end

	return props.children
end

return v5
