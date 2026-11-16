local parent = script:FindFirstAncestor("RobloxAppNavigation").Parent
local React = require(parent.React)

return React.createContext({
	render = function(p)
		return p
	end
})
