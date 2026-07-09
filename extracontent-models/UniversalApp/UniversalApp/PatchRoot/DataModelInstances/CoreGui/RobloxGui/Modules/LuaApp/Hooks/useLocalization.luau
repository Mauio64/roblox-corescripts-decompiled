local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules

if require(Modules.LuaApp.Flags.GetFFlagUseLocalizationFromAppTempCommon)() then
	return require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
end

local LocalizationService = game:GetService("LocalizationService")
local React = require(CorePackages.Packages.React)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local RobloxLocaleIdKey = require(CorePackages.Workspace.Packages.Localization).RobloxLocaleIdKey
local LocalizationRoactContext = require(CorePackages.Workspace.Packages.Localization).LocalizationRoactContext
local localizeStrings = require(CorePackages.Workspace.Packages.Localization).localizeStrings
local useSignal = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.useSignal

local function useLocalization(t1: {[any]: any}) -- line: 24
	-- upvalues: React (copy), LocalizationRoactContext (copy), LocalizationService (copy), useSignal (copy), ArgCheck (copy), localizeStrings (copy), RobloxLocaleIdKey (copy)
	local v12 = React.useContext(LocalizationRoactContext)
	local v13, v14 = React.useState(LocalizationService.RobloxLocaleId)
	local v15 = React.useCallback(function(_) -- line: 29
		-- upvalues: v12 (copy), v13 (copy), v14 (copy)
		local Locale = v12:GetLocale()

		if Locale ~= v13 then
			v14(Locale)
		end
	end, { v12 })

	useSignal(v12.changed, v15)
	ArgCheck.isType(t1, "table", "LocalizationConsumer.props.stringsToBeLocalized")

	local v16 = localizeStrings(v12, t1)

	v16[RobloxLocaleIdKey] = v13

	return v16
end

return useLocalization
