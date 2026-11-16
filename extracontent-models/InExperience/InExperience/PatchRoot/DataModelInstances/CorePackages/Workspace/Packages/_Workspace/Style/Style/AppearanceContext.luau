local parent = script:FindFirstAncestor("Style").Parent
local React = require(parent.React)

return React.createContext({
	theme = "dark",
	setTheme = function(_: string) end
})
