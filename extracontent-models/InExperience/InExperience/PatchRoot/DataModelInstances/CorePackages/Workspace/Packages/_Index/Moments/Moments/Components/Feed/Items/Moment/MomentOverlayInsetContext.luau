local parent = script:FindFirstAncestor("Moments").Parent

local React = require(parent.React)

local context = React.createContext(0)

return {
	Context = context,
	useMomentOverlayInset = function()
		return React.useContext(context)
	end
}
