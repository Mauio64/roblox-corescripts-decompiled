local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Flags = require(Foundation.Utility.Flags)

local context = React.createContext(Flags.FoundationPopoverPluginOverlayMeasurement and {
	id = nil,
	ready = true
} or nil)
context.displayName = "PluginPopoverParentContext"

return context
