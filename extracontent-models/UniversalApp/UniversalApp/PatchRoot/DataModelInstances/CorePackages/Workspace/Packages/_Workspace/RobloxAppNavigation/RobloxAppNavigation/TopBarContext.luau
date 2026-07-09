local Parent = script:FindFirstAncestor("RobloxAppNavigation").Parent

return require(Parent.React).createContext({
	render = function(p1) -- line: 9
		return p1
	end
})
