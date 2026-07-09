local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent

return require(Parent.React).createContext({
	value = nil,
	onValueChanged = function(_: string?) -- line: 8
		warn("No ListProvider found for List")
	end
})
