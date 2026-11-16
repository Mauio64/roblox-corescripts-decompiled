local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local React = require(parent.React)

local forwardErrorToScriptContext = require(GenericAbuseReporting.BeduiV2.Analytics.forwardErrorToScriptContext)

local extended = React.Component:extend("AbuseReportErrorBoundary")

function extended.getDerivedStateFromError(_)
	return { hasError = true }
end

function extended:init()
	self.state = { hasError = false }
end

function extended.componentDidCatch(p, p2, p3)
	local onError = p.props.onError

	if onError then
		onError(p2, p3)
	end

	forwardErrorToScriptContext(p2, p3 and p3.componentStack or nil)
end

function extended.render(p)
	local props = p.props
	return if p.state.hasError then props.fallback else props.children
end

return extended
