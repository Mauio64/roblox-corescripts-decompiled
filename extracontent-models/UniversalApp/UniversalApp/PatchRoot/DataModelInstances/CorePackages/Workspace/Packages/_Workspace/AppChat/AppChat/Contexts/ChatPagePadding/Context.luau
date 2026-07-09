local Parent = script:FindFirstAncestor("AppChat").Parent

return require(Parent.React).createContext({
	top = 0,
	right = 12,
	bottom = 0,
	left = 12
})
