local module = require("@luauforge/deferred/gQM")

local context = module.createContext(false)

return {
	Provider = context.Provider,
	useResponsiveEdgeSurface = function()
		return module.useContext(context)
	end
}
