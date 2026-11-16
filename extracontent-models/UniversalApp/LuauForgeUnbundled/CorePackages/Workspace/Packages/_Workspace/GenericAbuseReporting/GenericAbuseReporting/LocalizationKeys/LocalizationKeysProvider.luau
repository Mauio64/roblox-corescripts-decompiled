local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

local LocalizationKeysContext = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/LocalizationKeys/LocalizationKeysContext")
local DefaultLocalizationKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/LocalizationKeys/DefaultLocalizationKeys")

local function LocalizationKeysProvider(p2)
	local v5 = React.useMemo(function()
		local localizationKeys = p2.localizationKeys
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
	end, { p2.localizationKeys })

	return React.createElement(LocalizationKeysContext.Provider, { value = v5 }, p2.children)
end

return LocalizationKeysProvider
