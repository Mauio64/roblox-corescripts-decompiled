local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local ColorNamespace = require(Foundation.Enums.ColorNamespace)
local React = require(FoundationParent.React)
local v5 = React.createContext({
	isIconSize = false,
	colorNamespace = ColorNamespace.Color
})

return {
	Provider = v5.Provider,
	usePresentationContext = function() -- line: 19
		-- upvalues: React (copy), v5 (copy)
		return React.useContext(v5)
	end
}
