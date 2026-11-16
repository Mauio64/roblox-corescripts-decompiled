local React = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/React")
local localizationRoactContext = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/Localization").LocalizationRoactContext
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/Localization").Hooks.useLocalization

require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/type")

local RobloxTranslator = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/RobloxTranslator")

return {
	getLocalizedStrings = function(items)
		if React.useContext(localizationRoactContext) ~= nil then
			return useLocalization(items)
		end

		local result = {}

		for k, item in pairs(items) do
			local success, result2 = pcall(function()
				return RobloxTranslator:FormatByKey(item)
			end)

			if success then
				result[k] = result2
			else
				result[k] = item
			end
		end

		return result
	end
}
