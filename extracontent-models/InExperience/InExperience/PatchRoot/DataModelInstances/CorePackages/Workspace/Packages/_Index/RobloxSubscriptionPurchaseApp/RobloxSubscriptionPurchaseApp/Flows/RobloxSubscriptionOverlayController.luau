local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local parent = RobloxSubscriptionPurchaseApp.Parent

local LocalizationService = game:GetService("LocalizationService")

local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local SignalsReact = require(parent.SignalsReact)
local Style = require(parent.Style)
local RoactRodux = require(parent.RoactRodux)
local Rodux = require(parent.Rodux)
local RoactUtils = require(parent.RoactUtils)
local useSelectedTheme = RoactUtils.Hooks.useSelectedTheme
local StyleProviderWithDefaultTheme = Style.StyleProviderWithDefaultTheme
local Foundation = require(parent.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local UIBlox = require(parent.UIBlox)
local SelectionCursorProvider = UIBlox.App.SelectionImage.SelectionCursorProvider
local CursorProvider = UIBlox.App.SelectionCursor.CursorProvider

local AppLocales = require(parent.AppLocales)
local Localization = AppLocales.Localization
local Localization2 = require(parent.Localization)
local LocalizationProvider = Localization2.LocalizationProvider

local RoactUtils2 = require(parent.RoactUtils)
local ProviderContainer = RoactUtils2.Components.ProviderContainer

local RobloxSubscriptionContainer = require(RobloxSubscriptionPurchaseApp.Components.RobloxSubscriptionContainer)
local RobloxSubscriptionStore = require(RobloxSubscriptionPurchaseApp.Store.RobloxSubscriptionStore)
local SharedFlags = require(parent.SharedFlags)
local FFlagSubscriptionPurchaseFollowsAppTheme = SharedFlags.FFlagSubscriptionPurchaseFollowsAppTheme
local FFlagAppClassicThemeGreenButtonColors = Style.FFlagAppClassicThemeGreenButtonColors

local v = nil

local v2 = { Rodux.thunkMiddleware }

local function close()
	if v then
		v()
		v = nil
	end
end

local function ThemedOverlay(p)
	local v3 = useSelectedTheme()
	local themeName

	if FFlagSubscriptionPurchaseFollowsAppTheme then
		themeName = SignalsReact.useSignalState(Style.AppFoundationThemeName.getAppFoundationThemeName)
	end

	local store = React.useMemo(function()
		return Rodux.Store.new(Rodux.combineReducers({}), nil, v2)
	end, {})

	local providers = React.useMemo(function()
		local v4 = {}
		table.insert(v4, {
			class = RoactRodux.StoreProvider,
			props = { store = store }
		})

		table.insert(v4, {
			class = StyleProviderWithDefaultTheme,
			props = {
				withDarkTheme = v3 ~= "light",
				withUiModeSupport = false
			}
		})

		table.insert(v4, {
			class = LocalizationProvider,
			props = {
				localization = Localization.new(LocalizationService.RobloxLocaleId)
			}
		})

		table.insert(v4, { class = SelectionCursorProvider, props = {} })

		table.insert(v4, { class = CursorProvider, props = {} })

		return v4
	end, { v3, store })

	local colorMode = v3 == "light" and "Light" or "Dark"
	local tokenOverrides

	if FFlagSubscriptionPurchaseFollowsAppTheme and FFlagAppClassicThemeGreenButtonColors then
		tokenOverrides = Style.getClassicThemeTokenOverrides(themeName, colorMode)
	end

	local createElement = React.createElement

	local createElement2 = React.createElement
	local createElement3 = React.createElement
	local title

	if p.params then
		title = p.params.title or nil
	end

	local message

	if p.params then
		message = p.params.message or nil
	end

	return createElement(
		FoundationProvider,
		{ colorMode = colorMode, themeName = themeName, tokenOverrides = tokenOverrides },
		{
			Providers = createElement2(ProviderContainer, { providers = providers }, {
				Sheet = createElement3(RobloxSubscriptionContainer, {
					title = title,
					message = message,
					onClose = p.onClose
				})
			})
		}
	)
end

return {
	render = function(self)
		local v3 = RobloxSubscriptionStore.get()
		v3.triggerUnmountUI()

		local robloxSubscriptionPurchaseOverlay = Instance.new("Folder")
		robloxSubscriptionPurchaseOverlay.Name = "RobloxSubscriptionPurchaseOverlay"
		robloxSubscriptionPurchaseOverlay.Parent = game:GetService("CoreGui")

		local root = ReactRoblox.createRoot(robloxSubscriptionPurchaseOverlay)
		root:render(React.createElement(ThemedOverlay, { params = self, onClose = close }))

		local function cleanup()
			root:unmount()
			robloxSubscriptionPurchaseOverlay:Destroy()
		end

		v = cleanup
		v3.setOnUnmountUI(cleanup)

		return cleanup
	end,
	close = close
}
