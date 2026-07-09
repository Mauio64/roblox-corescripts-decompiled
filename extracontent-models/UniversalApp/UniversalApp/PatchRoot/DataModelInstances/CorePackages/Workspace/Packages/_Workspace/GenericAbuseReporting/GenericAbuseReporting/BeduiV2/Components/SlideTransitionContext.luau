local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local React = require(Parent.React)
local v3 = React.createBinding(false)
local v4 = React.createContext(v3)

return {
	Provider = v4.Provider,
	useIsSlideAnimating = function() -- line: 13
		-- upvalues: React (copy), v4 (copy)
		return React.useContext(v4)
	end
}
