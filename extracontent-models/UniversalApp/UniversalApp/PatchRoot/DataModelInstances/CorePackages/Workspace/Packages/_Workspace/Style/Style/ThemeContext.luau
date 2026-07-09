local Parent = script:FindFirstAncestor("Style").Parent

return require(Parent.React).createContext({
	theme = "dark",
	setTheme = function(_: string) -- line: 5
	end
})
