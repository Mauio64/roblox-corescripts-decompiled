local Parent = script:FindFirstAncestor("Localization").Parent
local React = require(Parent.React)
local LocalizationRoactContext = require(script.Parent.LocalizationRoactContext)

local function LocalizationProvider(p1) -- line: 7
	-- upvalues: React (copy), LocalizationRoactContext (copy)
	return React.createElement(LocalizationRoactContext.Provider, {
		value = p1.localization
	}, p1.children)
end

return LocalizationProvider
