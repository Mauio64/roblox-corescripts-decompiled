local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

local forwardErrorToScriptContext = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Analytics/forwardErrorToScriptContext")

local extended = React.Component:extend("AbuseReportErrorBoundary")

function extended.getDerivedStateFromError(p2)
	return { hasError = true }
end

function extended:init()
	self.state = { hasError = false }
end

function extended.componentDidCatch(p2, p3, p4)
	local onError = p2.props.onError

	if onError then
		onError(p3, p4)
	end

	forwardErrorToScriptContext(p3, p4 and p4.componentStack or nil)
end

function extended.render(p2)
	local props = p2.props

	if p2.state.hasError then
		return props.fallback
	end

	return props.children
end

return extended
