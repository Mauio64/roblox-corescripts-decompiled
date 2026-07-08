local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local BreakpointConfig = require(Foundation.Utility.Responsive.BreakpointConfig)
local GridConfig = require(Foundation.Utility.Responsive.GridConfig)

return require(FoundationParent.React).createContext({
	config = {
		breakpoint = BreakpointConfig,
		grid = GridConfig
	}
})
