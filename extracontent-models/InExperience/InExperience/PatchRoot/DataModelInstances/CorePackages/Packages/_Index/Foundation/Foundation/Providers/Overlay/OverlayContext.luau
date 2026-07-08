local Parent = script:FindFirstAncestor("Foundation").Parent

return require(Parent.React).createContext({
	instance = nil,
	screen = nil,
	requestOverlay = function() -- line: 7
	end
})
