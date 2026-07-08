local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local Flags = require(Foundation.Utility.Flags)
local t1 = {
	id = nil,
	ready = true
}
local v6 = React.createContext(if not Flags.FoundationPopoverPluginOverlayMeasurement then nil else t1)

v6.displayName = "PluginPopoverParentContext"

return v6
