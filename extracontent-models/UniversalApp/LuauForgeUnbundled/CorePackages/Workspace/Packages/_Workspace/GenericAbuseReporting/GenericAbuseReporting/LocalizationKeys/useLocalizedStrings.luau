local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

local LocalizationKeysContext = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/LocalizationKeys/LocalizationKeysContext")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Localization").Hooks.useLocalization

local function useLocalizedStrings()
	return useLocalization((React.useContext(LocalizationKeysContext)))
end

return useLocalizedStrings
