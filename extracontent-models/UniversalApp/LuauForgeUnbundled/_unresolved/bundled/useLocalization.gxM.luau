local CorePackages = game:GetService("CorePackages")

if require("@luauforge/bundled/gxN")() then
	return require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
end

local LocalizationService = game:GetService("LocalizationService")

local React = require(CorePackages.Packages.React)
local module = require("@luauforge/bundled/dzP")
local robloxLocaleIdKey = require("@game/CorePackages/Workspace/Packages/Localization").RobloxLocaleIdKey
local localizationRoactContext = require("@game/CorePackages/Workspace/Packages/Localization").LocalizationRoactContext
local localizeStrings = require("@game/CorePackages/Workspace/Packages/Localization").localizeStrings
local useSignal = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useSignal

local function useLocalization(p2)
	local v5 = React.useContext(localizationRoactContext)

	local state, setState = React.useState(LocalizationService.RobloxLocaleId)

	local v6 = React.useCallback(function(p3)
		local locale = v5:GetLocale()

		if locale ~= state then
			setState(locale)
		end
	end, { v5 })

	useSignal(v5.changed, v6)

	module.isType(p2, "table", "LocalizationConsumer.props.stringsToBeLocalized")

	local statesByRobloxLocaleIdKey = localizeStrings(v5, p2)
	statesByRobloxLocaleIdKey[robloxLocaleIdKey] = state

	return statesByRobloxLocaleIdKey
end

return useLocalization
