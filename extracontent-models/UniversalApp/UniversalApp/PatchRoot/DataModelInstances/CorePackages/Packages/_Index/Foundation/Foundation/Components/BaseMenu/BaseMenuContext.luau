local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

require(Foundation.Components.Types)

local InputSize = require(Foundation.Enums.InputSize)

return (React.createContext({
	onActivated = nil,
	onNestedLeafActivated = nil,
	size = InputSize.Medium,
	hasLeading = nil,
	setHasLeading = nil,
	hoverOpenPath = {},
	hoverOpenAtDepth = nil,
	hoverCloseAtDepth = nil,
	hoverReset = nil,
	depth = 1,
	maxHeight = nil
}))
