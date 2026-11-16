local parent = script.Parent.Parent
local Overlay = require(parent.Enums.Overlay)
local AttributionTraversal = require(parent.Components.AttributionTraversal)

return { [Overlay.AttributionTraversal] = AttributionTraversal }
