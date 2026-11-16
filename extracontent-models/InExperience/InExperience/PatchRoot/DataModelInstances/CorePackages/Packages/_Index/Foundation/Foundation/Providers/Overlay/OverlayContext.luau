local parent = script:FindFirstAncestor("Foundation").Parent

local React = require(parent.React)

return React.createContext({
	requestOverlay = function() end,
	instance = nil,
	screen = nil
})
