local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local context = React.createContext(0)

return {
	Context = context,
	useMomentOverlayInset = function()
		return React.useContext(context)
	end
}
