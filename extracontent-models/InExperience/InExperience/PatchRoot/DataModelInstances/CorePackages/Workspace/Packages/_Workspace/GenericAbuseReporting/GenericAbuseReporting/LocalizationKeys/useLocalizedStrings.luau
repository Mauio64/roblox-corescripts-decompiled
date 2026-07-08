local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local React = require(Parent.React)
local LocalizationKeysContext = require(script.Parent.LocalizationKeysContext)
local useLocalization = require(Parent.Localization).Hooks.useLocalization

local function useLocalizedStrings() -- line: 8
	-- upvalues: React (copy), LocalizationKeysContext (copy), useLocalization (copy)
	local v6 = React.useContext(LocalizationKeysContext)

	return (useLocalization(v6))
end

return useLocalizedStrings
