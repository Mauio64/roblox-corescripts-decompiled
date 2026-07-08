local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)

require(Foundation.Components.Types)

local InputSize = require(Foundation.Enums.InputSize)

return (React.createContext({
	onActivated = nil,
	onNestedLeafActivated = nil,
	hasLeading = nil,
	setHasLeading = nil,
	hoverOpenAtDepth = nil,
	hoverCloseAtDepth = nil,
	hoverReset = nil,
	depth = 1,
	size = InputSize.Medium,
	hoverOpenPath = {}
}))
