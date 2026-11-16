local Localization = script:FindFirstAncestor("Localization")
local parent = Localization.Parent
local LocalizationService = game:GetService("LocalizationService")

local React = require(parent.React)
local ArgCheck = require(parent.ArgCheck)
local RobloxLocaleIdKey = require(Localization.RobloxLocaleIdKey)
local LocalizationRoactContext = require(Localization.LocalizationRoactContext)
local localizeStrings = require(Localization.localizeStrings)
local RoactUtils = require(parent.RoactUtils)
local useSignal = RoactUtils.Hooks.useSignal

local function useLocalization(p)
	local v = React.useContext(LocalizationRoactContext)

	local state, setState = React.useState(LocalizationService.RobloxLocaleId)

	local v2 = React.useCallback(function(_)
		local locale = v:GetLocale()

		if locale ~= state then
			setState(locale)
		end
	end, { v })

	useSignal(v.changed, v2)

	ArgCheck.isType(p, "table", "LocalizationConsumer.props.stringsToBeLocalized")

	local statesByRobloxLocaleIdKey = localizeStrings(v, p)
	statesByRobloxLocaleIdKey[RobloxLocaleIdKey] = state

	return statesByRobloxLocaleIdKey
end

return useLocalization
