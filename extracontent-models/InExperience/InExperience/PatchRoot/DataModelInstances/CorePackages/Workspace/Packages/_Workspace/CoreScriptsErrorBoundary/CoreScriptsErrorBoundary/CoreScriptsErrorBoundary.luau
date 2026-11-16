local parent = script.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local LoggingProtocol = require(parent2.LoggingProtocol)

local ReactTreeCrashedConfig = require(parent.ReactTreeCrashedConfig)
local reportCaughtError = require(parent.reportCaughtError)

local extended = React.Component:extend("CoreScriptsErrorBoundary")

function extended.getDerivedStateFromError(_)
	return { hasError = true }
end

function extended:init()
	self.state = { hasError = false }
end

function extended.componentDidCatch(p, p2, p3)
	local props = p.props
	LoggingProtocol.default:logRobloxTelemetryCounter(ReactTreeCrashedConfig, 1, {
		surface = props.surface
	})

	reportCaughtError(p2, {
		surface = props.surface,
		componentStack = p3 and p3.componentStack or nil
	})
end

function extended.render(p)
	return if not p.state.hasError then p.props.children else nil
end

return extended
