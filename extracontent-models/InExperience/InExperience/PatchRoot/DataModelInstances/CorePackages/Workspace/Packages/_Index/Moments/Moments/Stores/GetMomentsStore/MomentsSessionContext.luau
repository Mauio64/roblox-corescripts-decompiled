local Parent = script:FindFirstAncestor("Moments").Parent
local React = require(Parent.React)

require(script.Parent.createMomentsStore)

local Parent2 = require(script.Parent)
local v4 = React.createContext(nil)

return {
	MomentsSessionContext = v4,
	useMomentsSession = function() -- line: 27
		-- upvalues: React (copy), v4 (copy), Parent2 (copy)
		local v5 = React.useContext(v4)

		if v5 == nil then
			return Parent2()
		end

		return v5
	end
}
