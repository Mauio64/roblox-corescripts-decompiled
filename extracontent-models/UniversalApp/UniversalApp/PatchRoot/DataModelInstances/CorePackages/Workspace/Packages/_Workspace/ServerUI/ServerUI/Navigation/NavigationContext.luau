local Parent = script:FindFirstAncestor("ServerUI").Parent

return (require(Parent.React).createContext({
	stack = {}
}))
