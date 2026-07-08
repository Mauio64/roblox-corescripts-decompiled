local ParentParent = script.Parent.Parent.Parent

return require(ParentParent.React).createContext({
	isPresent = true,
	id = "",
	onExitComplete = nil,
	passThroughData = nil
})
