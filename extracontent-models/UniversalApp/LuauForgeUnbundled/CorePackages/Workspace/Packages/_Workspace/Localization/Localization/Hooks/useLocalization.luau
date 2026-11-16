local LocalizationService = game:GetService("LocalizationService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Localization/React")
local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/Localization/ArgCheck")
local RobloxLocaleIdKey = require("@game/CorePackages/Workspace/Packages/_Workspace/Localization/Localization/RobloxLocaleIdKey")
local LocalizationRoactContext = require("@game/CorePackages/Workspace/Packages/_Workspace/Localization/Localization/LocalizationRoactContext")
local localizeStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/Localization/Localization/localizeStrings")
local useSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/Localization/RoactUtils").Hooks.useSignal

local function useLocalization(p2)
	local v5 = React.useContext(LocalizationRoactContext)

	local state, setState = React.useState(LocalizationService.RobloxLocaleId)

	local v6 = React.useCallback(function(p3)
		local locale = v5:GetLocale()

		if locale ~= state then
			setState(locale)
		end
	end, { v5 })

	useSignal(v5.changed, v6)

	ArgCheck.isType(p2, "table", "LocalizationConsumer.props.stringsToBeLocalized")

	local statesByModule = localizeStrings(v5, p2)
	statesByModule[RobloxLocaleIdKey] = state

	return statesByModule
end

return useLocalization
