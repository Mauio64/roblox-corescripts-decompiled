local parent = script.Parent
local Foundation = script:FindFirstAncestor("Foundation")
local parent2 = Foundation.Parent
local React = require(parent2.React)

local BreakpointConfig = require(Foundation.Utility.Responsive.BreakpointConfig)
local GridConfig = require(Foundation.Utility.Responsive.GridConfig)
local ResponsiveContext = require(parent.ResponsiveContext)

local withDefaults = require(Foundation.Utility.withDefaults)

local v = {
	config = { breakpoint = BreakpointConfig, grid = GridConfig }
}

local function ResponsiveProvider(p)
	local v2 = React.useMemo(function()
		return {
			config = withDefaults(p.config or {}, v.config)
		}
	end, { p.config })

	return React.createElement(ResponsiveContext.Provider, { value = v2 }, p.children)
end

return ResponsiveProvider
