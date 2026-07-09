local Parent = script:FindFirstAncestor("Moments").Parent
local React = require(Parent.React)
local v3 = React.createContext(0)

return {
	Context = v3,
	useMomentOverlayInset = function() -- line: 19
		-- upvalues: React (copy), v3 (copy)
		return React.useContext(v3)
	end
}
