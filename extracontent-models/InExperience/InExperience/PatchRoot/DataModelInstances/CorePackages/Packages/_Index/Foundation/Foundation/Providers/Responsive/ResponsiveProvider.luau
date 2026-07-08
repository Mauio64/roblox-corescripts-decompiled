local scriptParent = script.Parent
local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local BreakpointConfig = require(Foundation.Utility.Responsive.BreakpointConfig)
local GridConfig = require(Foundation.Utility.Responsive.GridConfig)
local ResponsiveContext = require(scriptParent.ResponsiveContext)
local withDefaults = require(Foundation.Utility.withDefaults)
local t1 = {
	config = {
		breakpoint = BreakpointConfig,
		grid = GridConfig
	}
}

local function ResponsiveProvider(t2: {[any]: any}) -- line: 26
	-- upvalues: withDefaults (copy), t1 (copy), React (copy), ResponsiveContext (copy)
	local v12 = withDefaults(t2, t1)

	return React.createElement(ResponsiveContext.Provider, {
		value = v12
	}, v12.children)
end

return ResponsiveProvider
