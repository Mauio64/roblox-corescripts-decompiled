local parent = script.Parent.Parent.Parent.Parent.Parent
local Roact = require(parent.Roact)

return Roact.createContext({
	config = {},
	breakpoint = nil,
	kind = nil,
	scrollable = false,
	multiLine = false,
	relativeHeight = nil,
	subPixelOffset = 0
})
