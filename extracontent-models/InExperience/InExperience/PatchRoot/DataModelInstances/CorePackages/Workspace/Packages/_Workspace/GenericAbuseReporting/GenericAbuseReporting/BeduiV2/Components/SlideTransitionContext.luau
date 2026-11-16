local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent

local React = require(parent.React)

local binding = React.createBinding(false)
local context = React.createContext(binding)

return {
	Provider = context.Provider,
	useIsSlideAnimating = function()
		return React.useContext(context)
	end
}
