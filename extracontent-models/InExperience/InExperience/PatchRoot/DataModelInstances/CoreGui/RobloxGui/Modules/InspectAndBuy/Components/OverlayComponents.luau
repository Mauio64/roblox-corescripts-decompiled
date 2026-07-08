local ParentParent = script.Parent.Parent
local Overlay = require(ParentParent.Enums.Overlay)
local AttributionTraversal = require(ParentParent.Components.AttributionTraversal)

return {
	[Overlay.AttributionTraversal] = AttributionTraversal
}
