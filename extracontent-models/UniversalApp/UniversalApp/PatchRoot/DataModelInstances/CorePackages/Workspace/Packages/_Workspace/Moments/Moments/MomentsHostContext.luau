local Parent = script:FindFirstAncestor("Moments").Parent
local React = require(Parent.React)
local v3 = React.createContext(nil)

return {
	MomentsHostContext = v3,
	useMomentsHost = function() -- line: 15
		-- upvalues: React (copy), v3 (copy)
		local v4 = React.useContext(v3)

		if v4 == nil then
			return {}
		end

		return v4
	end
}
