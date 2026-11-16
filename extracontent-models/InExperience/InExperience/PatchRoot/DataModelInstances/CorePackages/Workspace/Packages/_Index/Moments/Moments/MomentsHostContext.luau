local parent = script:FindFirstAncestor("Moments").Parent

local React = require(parent.React)

local context = React.createContext(nil)

return {
	MomentsHostContext = context,
	useMomentsHost = function()
		local v = React.useContext(context)

		if v == nil then
			return {}
		end

		return v
	end
}
