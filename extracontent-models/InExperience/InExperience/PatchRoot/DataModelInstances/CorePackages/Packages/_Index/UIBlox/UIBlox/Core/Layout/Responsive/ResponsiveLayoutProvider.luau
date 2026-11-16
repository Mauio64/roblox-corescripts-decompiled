local parent = script.Parent
local parent2 = parent.Parent.Parent.Parent.Parent

local React = require(parent2.React)

local ResponsiveLayoutContext = require(parent.ResponsiveLayoutContext)
local ResponsiveLayoutConfigReader = require(parent.ResponsiveLayoutConfigReader)

local function ResponsiveLayoutProvider(props)
	local width = props.width or 1
	local config = props.config or {}

	local state, setState = React.useState(function()
		return ResponsiveLayoutConfigReader.findBreakpoint(config, width)
	end)

	React.useLayoutEffect(function()
		setState(ResponsiveLayoutConfigReader.findBreakpoint(config, width))
	end, { config })

	React.useLayoutEffect(function()
		if width < state.min or width > state.max then
			setState(ResponsiveLayoutConfigReader.findBreakpoint(config, width))
		end
	end, { width, state.min, state.max })

	return React.createElement(ResponsiveLayoutContext.Provider, {
		value = { config = config, breakpoint = state.name }
	}, props.children)
end

return ResponsiveLayoutProvider
