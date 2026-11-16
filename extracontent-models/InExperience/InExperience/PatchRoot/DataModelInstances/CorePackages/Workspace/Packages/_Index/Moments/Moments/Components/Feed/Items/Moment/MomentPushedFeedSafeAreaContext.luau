local parent = script:FindFirstAncestor("Moments").Parent

local React = require(parent.React)

local context = React.createContext(nil)

return {
	Context = context,
	useMomentPushedFeedSafeArea = function()
		return React.useContext(context)
	end
}
