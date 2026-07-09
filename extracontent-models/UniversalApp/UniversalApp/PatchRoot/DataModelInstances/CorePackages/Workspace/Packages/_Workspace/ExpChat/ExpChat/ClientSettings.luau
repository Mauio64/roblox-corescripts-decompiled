local Parent = script:FindFirstAncestor("ExpChat").Parent

return require(Parent.Roact).createContext({
	preferredTransparency = 1
})
