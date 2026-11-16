local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local React = require(parent.React)

local LocalizationKeysContext = require(script.Parent.LocalizationKeysContext)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local function useLocalizedStrings()
	return (useLocalization((React.useContext(LocalizationKeysContext))))
end

return useLocalizedStrings
