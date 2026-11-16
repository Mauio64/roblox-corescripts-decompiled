local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local ColorNamespace = require(Foundation.Enums.ColorNamespace)
local React = require(parent.React)

local context = React.createContext({ isIconSize = false, colorNamespace = ColorNamespace.Color })

return {
	Provider = context.Provider,
	usePresentationContext = function()
		return React.useContext(context)
	end
}
