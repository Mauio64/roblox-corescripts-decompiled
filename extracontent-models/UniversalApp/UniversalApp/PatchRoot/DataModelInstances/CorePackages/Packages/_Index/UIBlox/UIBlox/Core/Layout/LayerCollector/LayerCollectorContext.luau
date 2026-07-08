local ParentParent = script.Parent.Parent.Parent.Parent.Parent

return (require(ParentParent.Roact).createContext({
	absoluteSize = Vector2.new(0, 0),
	insets = {
		top = 0,
		left = 0,
		bottom = 0,
		right = 0
	}
}))
