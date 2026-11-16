local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local context = React.createContext(nil)

return {
	Context = context,
	useMomentPushedFeedSafeArea = function()
		return React.useContext(context)
	end
}
