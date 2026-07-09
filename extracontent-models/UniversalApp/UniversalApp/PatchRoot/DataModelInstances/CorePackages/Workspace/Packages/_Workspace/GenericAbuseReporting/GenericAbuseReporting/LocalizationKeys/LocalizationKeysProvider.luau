local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local React = require(GenericAbuseReportingParent.React)
local LocalizationKeysContext = require(GenericAbuseReporting.LocalizationKeys.LocalizationKeysContext)
local DefaultLocalizationKeys = require(GenericAbuseReporting.LocalizationKeys.DefaultLocalizationKeys)

local function LocalizationKeysProvider(t1: {[any]: any}) -- line: 25
	-- upvalues: React (copy), DefaultLocalizationKeys (copy), LocalizationKeysContext (copy)
	local v8 = React.useMemo(function() -- line: 26
		-- upvalues: t1 (copy), DefaultLocalizationKeys (copy)
		local localizationKeys = t1.localizationKeys

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
	end, { t1.localizationKeys })

	return React.createElement(LocalizationKeysContext.Provider, {
		value = v8
	}, t1.children)
end

return LocalizationKeysProvider
