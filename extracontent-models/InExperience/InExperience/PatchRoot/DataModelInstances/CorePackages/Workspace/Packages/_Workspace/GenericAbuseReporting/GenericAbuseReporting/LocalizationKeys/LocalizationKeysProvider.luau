local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local React = require(parent.React)

local LocalizationKeysContext = require(GenericAbuseReporting.LocalizationKeys.LocalizationKeysContext)
local DefaultLocalizationKeys = require(GenericAbuseReporting.LocalizationKeys.DefaultLocalizationKeys)

local function LocalizationKeysProvider(p)
	local v = React.useMemo(function()
		local localizationKeys = p.localizationKeys
		return {
			formTitle = localizationKeys and localizationKeys.formTitle or DefaultLocalizationKeys.formTitle,
			formSubmit = localizationKeys and localizationKeys.formSubmit or DefaultLocalizationKeys.formSubmit,
			completeTitle = localizationKeys and localizationKeys.completeTitle or DefaultLocalizationKeys.completeTitle,
			completeDescription = localizationKeys and localizationKeys.completeDescription or DefaultLocalizationKeys.completeDescription,
			completeClose = localizationKeys and localizationKeys.completeClose or DefaultLocalizationKeys.completeClose,
			failedTitle = localizationKeys and localizationKeys.failedTitle or DefaultLocalizationKeys.failedTitle,
			failedDescription = localizationKeys and localizationKeys.failedDescription or DefaultLocalizationKeys.failedDescription,
			failedClose = localizationKeys and localizationKeys.failedClose or DefaultLocalizationKeys.failedClose
		}
	end, { p.localizationKeys })

	return React.createElement(LocalizationKeysContext.Provider, { value = v }, p.children)
end

return LocalizationKeysProvider
