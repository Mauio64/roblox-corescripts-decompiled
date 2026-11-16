local parent = script:FindFirstAncestor("Moments").Parent

local React = require(parent.React)

require(script.Parent.createMomentsStore)
local parentModule = require(script.Parent)

local context = React.createContext(nil)

return {
	MomentsSessionContext = context,
	useMomentsSession = function()
		local v = React.useContext(context)

		if v == nil then
			return parentModule()
		end

		return v
	end
}
