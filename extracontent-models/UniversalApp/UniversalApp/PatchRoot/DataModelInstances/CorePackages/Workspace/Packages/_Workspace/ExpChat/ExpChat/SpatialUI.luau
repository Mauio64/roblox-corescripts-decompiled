local Parent = script:FindFirstAncestor("ExpChat").Parent

return require(Parent.Roact).createContext({
	isSpatialUIEnabled = false
})
