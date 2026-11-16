local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

local binding = React.createBinding(false)
local context = React.createContext(binding)

return {
	Provider = context.Provider,
	useIsSlideAnimating = function()
		return React.useContext(context)
	end
}
