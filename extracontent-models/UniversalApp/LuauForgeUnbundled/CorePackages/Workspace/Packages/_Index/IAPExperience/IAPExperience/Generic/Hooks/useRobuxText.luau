local React = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/React")
local formatNumber = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/formatNumber")
local LocalizationService = game:GetService("LocalizationService")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Foundation")
local enums = Foundation.Enums
local getIconRichText = Foundation.Utility.getIconRichText

function LUAUFORGE_MODULE_GLOBALS_aWG_useRobuxText(value)
	return (React.useMemo(function()
		local v5 = formatNumber(LocalizationService.RobloxLocaleId, value or 0)
		return `{getIconRichText(enums.IconName.Robux)} {v5}`
	end, { value, LocalizationService.RobloxLocaleId }))
end

return LUAUFORGE_MODULE_GLOBALS_aWG_useRobuxText
