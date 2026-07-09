local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local RobloxSubscriptionPurchaseAppParent = RobloxSubscriptionPurchaseApp.Parent
local LocalizationService = game:GetService("LocalizationService")
local React = require(RobloxSubscriptionPurchaseAppParent.React)
local ReactRoblox = require(RobloxSubscriptionPurchaseAppParent.ReactRoblox)
local Style = require(RobloxSubscriptionPurchaseAppParent.Style)
local RoactRodux = require(RobloxSubscriptionPurchaseAppParent.RoactRodux)
local Rodux = require(RobloxSubscriptionPurchaseAppParent.Rodux)
local useSelectedTheme = require(RobloxSubscriptionPurchaseAppParent.RoactUtils).Hooks.useSelectedTheme
local StyleProviderWithDefaultTheme = Style.StyleProviderWithDefaultTheme
local FoundationProvider = require(RobloxSubscriptionPurchaseAppParent.Foundation).FoundationProvider
local UIBlox = require(RobloxSubscriptionPurchaseAppParent.UIBlox)
local SelectionCursorProvider = UIBlox.App.SelectionImage.SelectionCursorProvider
local CursorProvider = UIBlox.App.SelectionCursor.CursorProvider
local Localization = require(RobloxSubscriptionPurchaseAppParent.AppLocales).Localization
local LocalizationProvider = require(RobloxSubscriptionPurchaseAppParent.Localization).LocalizationProvider
local ProviderContainer = require(RobloxSubscriptionPurchaseAppParent.RoactUtils).Components.ProviderContainer
local RobloxSubscriptionContainer = require(RobloxSubscriptionPurchaseApp.Components.RobloxSubscriptionContainer)
local RobloxSubscriptionStore = require(RobloxSubscriptionPurchaseApp.Store.RobloxSubscriptionStore)
local u20 = nil
local t1 = { Rodux.thunkMiddleware }

local function close() -- line: 42
	-- upvalues: u20 (ref)
	if u20 then
		u20()
		u20 = nil
	end
end
local function ThemedOverlay(t2: {[any]: any}) -- line: 49
	-- upvalues: useSelectedTheme (copy), React (copy), Rodux (copy), t1 (copy), RoactRodux (copy), StyleProviderWithDefaultTheme (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy), SelectionCursorProvider (copy), CursorProvider (copy), FoundationProvider (copy), ProviderContainer (copy), RobloxSubscriptionContainer (copy)
	local v25 = useSelectedTheme()
	local v26 = React.useMemo(function() -- line: 52
		-- upvalues: Rodux (copy), t1 (copy)
		return Rodux.Store.new(Rodux.combineReducers({}), nil, t1)
	end, {})
	local v27 = React.useMemo(function() -- line: 56
		-- upvalues: RoactRodux (copy), v26 (copy), StyleProviderWithDefaultTheme (copy), v25 (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy), SelectionCursorProvider (copy), CursorProvider (copy)
		local t3 = {}

		table.insert(t3, {
			class = RoactRodux.StoreProvider,
			props = {
				store = v26
			}
		})
		table.insert(t3, {
			class = StyleProviderWithDefaultTheme,
			props = {
				withUiModeSupport = false,
				withDarkTheme = v25 ~= "light"
			}
		})
		table.insert(t3, {
			class = LocalizationProvider,
			props = {
				localization = Localization.new(LocalizationService.RobloxLocaleId)
			}
		})
		table.insert(t3, {
			class = SelectionCursorProvider,
			props = {}
		})
		table.insert(t3, {
			class = CursorProvider,
			props = {}
		})

		return t3
	end, {
		v25,
		v26
	})
	local v28 = v25 ~= "light" and "Dark" or "Light"

	return React.createElement(FoundationProvider, {
		theme = v28
	}, {
		Providers = React.createElement(ProviderContainer, {
			providers = v27
		}, {
			Sheet = React.createElement(RobloxSubscriptionContainer, {
				title = t2.params and t2.params.title or nil,
				message = t2.params and t2.params.message or nil,
				onClose = t2.onClose
			})
		})
	})
end

return {
	render = function(t4: {[any]: any}?) -- line: 94
		-- upvalues: RobloxSubscriptionStore (copy), ReactRoblox (copy), React (copy), ThemedOverlay (copy), close (copy), u20 (ref)
		local v30 = RobloxSubscriptionStore.get()

		v30.triggerUnmountUI()

		local Folder = Instance.new("Folder")

		Folder.Name = "RobloxSubscriptionPurchaseOverlay"
		Folder.Parent = game:GetService("CoreGui")

		local v32 = ReactRoblox.createRoot(Folder)

		v32:render(React.createElement(ThemedOverlay, {
			params = t4,
			onClose = close
		}))

		local function cleanup() -- line: 108
			-- upvalues: v32 (copy), Folder (copy)
			v32:unmount()
			Folder:Destroy()
		end

		u20 = cleanup
		v30.setOnUnmountUI(cleanup)

		return cleanup
	end,
	close = close
}
