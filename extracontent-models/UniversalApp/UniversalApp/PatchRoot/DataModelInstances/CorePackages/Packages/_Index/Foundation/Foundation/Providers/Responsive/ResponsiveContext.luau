local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local BreakpointConfig = require(Foundation.Utility.Responsive.BreakpointConfig)
local GridConfig = require(Foundation.Utility.Responsive.GridConfig)
local React = require(parent.React)

return React.createContext({
	config = { breakpoint = BreakpointConfig, grid = GridConfig }
})
