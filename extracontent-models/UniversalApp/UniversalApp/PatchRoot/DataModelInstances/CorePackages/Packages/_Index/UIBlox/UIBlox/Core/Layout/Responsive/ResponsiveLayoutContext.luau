local ParentParent = script.Parent.Parent.Parent.Parent.Parent

return require(ParentParent.Roact).createContext({
	breakpoint = nil,
	kind = nil,
	scrollable = false,
	multiLine = false,
	relativeHeight = nil,
	subPixelOffset = 0,
	config = {}
})
