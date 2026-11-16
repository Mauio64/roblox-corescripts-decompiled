local parent = script.Parent.Parent.Parent

local React = require(parent.React)
local Localization = require(parent.Localization)
local LocalizationRoactContext = Localization.LocalizationRoactContext
local Localization2 = require(parent.Localization)
local useLocalization = Localization2.Hooks.useLocalization
local NotificationsCommon = script:FindFirstAncestor("NotificationsCommon")
require(NotificationsCommon.type)

local RobloxTranslator = require(parent.RobloxTranslator)

return {
	getLocalizedStrings = function(items)
		if React.useContext(LocalizationRoactContext) ~= nil then
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
