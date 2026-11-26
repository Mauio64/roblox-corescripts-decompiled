local LocalizationService = game:GetService("LocalizationService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/React")
local ReactRoblox = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/ReactRoblox")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/SignalsReact")
local Style = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/Style")
local RoactRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/RoactRodux")
local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/Rodux")
local useSelectedTheme = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/RoactUtils").Hooks.useSelectedTheme
local styleProviderWithDefaultTheme = Style.StyleProviderWithDefaultTheme
local foundationProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/Foundation").FoundationProvider
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/UIBlox")
local selectionCursorProvider = UIBlox.App.SelectionImage.SelectionCursorProvider
local cursorProvider = UIBlox.App.SelectionCursor.CursorProvider

local localization = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/AppLocales").Localization
local localizationProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/Localization").LocalizationProvider

local providerContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/RoactUtils").Components.ProviderContainer

local RobloxSubscriptionContainer = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Components/RobloxSubscriptionContainer")
local RobloxSubscriptionStore = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Store/RobloxSubscriptionStore")
local fFlagSubscriptionPurchaseFollowsAppTheme = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/SharedFlags").FFlagSubscriptionPurchaseFollowsAppTheme
local fFlagAppClassicThemeGreenButtonColors = Style.FFlagAppClassicThemeGreenButtonColors

local v5 = nil

local v6 = { Rodux.thunkMiddleware }

local function close()
	if v5 then
		v5()
		v5 = nil
	end
end

local function ThemedOverlay(p2)
	local v7 = useSelectedTheme()
	local v8

	if fFlagSubscriptionPurchaseFollowsAppTheme then
		v8 = SignalsReact.useSignalState(Style.AppFoundationThemeName.getAppFoundationThemeName)
	end

	local v9 = React.useMemo(function()
		return Rodux.Store.new(Rodux.combineReducers({}), nil, v6)
	end, {})

	local v10 = React.useMemo(function()
		local v11 = {}
		table.insert(v11, {
			class = RoactRodux.StoreProvider,
			props = { store = v9 }
		})

		table.insert(v11, {
			class = styleProviderWithDefaultTheme,
			props = {
				withDarkTheme = v7 ~= "light",
				withUiModeSupport = false
			}
		})

		table.insert(v11, {
			class = localizationProvider,
			props = {
				localization = localization.new(LocalizationService.RobloxLocaleId)
			}
		})

		table.insert(v11, { class = selectionCursorProvider, props = {} })

		table.insert(v11, { class = cursorProvider, props = {} })

		return v11
	end, { v7, v9 })

	local v11 = v7 == "light" and "Light" or "Dark"
	local v12

	if fFlagSubscriptionPurchaseFollowsAppTheme and fFlagAppClassicThemeGreenButtonColors then
		v12 = Style.getClassicThemeTokenOverrides(v8, v11)
	end

	local createElement = React.createElement

	local createElement2 = React.createElement
	local createElement3 = React.createElement
	local v21 = if p2.params then p2.params.title or nil else nil
	local v22 = if p2.params then p2.params.message or nil else nil
	return createElement(foundationProvider, {
		colorMode = v11,
		themeName = v8,
		tokenOverrides = v12
	}, {
		Providers = createElement2(providerContainer, { providers = v10 }, {
			Sheet = createElement3(RobloxSubscriptionContainer, {
				title = v21,
				message = v22,
				onClose = p2.onClose
			})
		})
	})
end

return {
	render = function(p2)
		local v7 = RobloxSubscriptionStore.get()
		v7.triggerUnmountUI()

		local robloxSubscriptionPurchaseOverlay = Instance.new("Folder")
		robloxSubscriptionPurchaseOverlay.Name = "RobloxSubscriptionPurchaseOverlay"
		robloxSubscriptionPurchaseOverlay.Parent = game:GetService("CoreGui")

		local root = ReactRoblox.createRoot(robloxSubscriptionPurchaseOverlay)
		root:render(React.createElement(ThemedOverlay, { params = p2, onClose = close }))

		local function cleanup()
			root:unmount()
			robloxSubscriptionPurchaseOverlay:Destroy()
		end

		v5 = cleanup
		v7.setOnUnmountUI(cleanup)

		return cleanup
	end,
	close = close
}
