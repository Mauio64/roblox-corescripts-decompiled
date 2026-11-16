local parent = script:FindFirstAncestor("Localization").Parent

local React = require(parent.React)
local LocalizationRoactContext = require(script.Parent.LocalizationRoactContext)

local function LocalizationProvider(p)
	return React.createElement(LocalizationRoactContext.Provider, { value = p.localization }, p.children)
end

return LocalizationProvider
