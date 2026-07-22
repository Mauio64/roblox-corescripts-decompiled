local Parent = script:FindFirstAncestor("Moments").Parent
local React = require(Parent.React)
local v3 = React.createContext(nil)

return {
	Context = v3,
	useMomentPushedFeedSafeArea = function() -- line: 16
		-- upvalues: React (copy), v3 (copy)
		return React.useContext(v3)
	end
}
