local CoreGui = game:GetService("CoreGui")
local LocalizationService = game:GetService("LocalizationService")
local CancelSubscriptionApp = script:FindFirstAncestor("CancelSubscriptionApp")
local CancelSubscriptionAppParent = CancelSubscriptionApp.Parent
local Rodux = require(CancelSubscriptionAppParent.Rodux)
local ReactRoblox = require(CancelSubscriptionAppParent.ReactRoblox)
local RoactRodux = require(CancelSubscriptionAppParent.RoactRodux)
local React = require(CancelSubscriptionAppParent.React)
local HttpRequest = require(CancelSubscriptionAppParent.HttpRequest)
local DesignTokenProvider = require(CancelSubscriptionAppParent.Style).DesignTokenProvider
local AppStyleProvider = require(CancelSubscriptionAppParent.Style).AppStyleProvider
local LocalizationProvider = require(CancelSubscriptionAppParent.Localization).LocalizationProvider
local Localization = require(CancelSubscriptionAppParent.InExperienceLocales).Localization
local ReactFocusNavigation = require(CancelSubscriptionAppParent.ReactFocusNavigation)
local Provider = require(CancelSubscriptionAppParent.FocusNavigationUtils).FocusNavigableSurfaceRegistry.Provider
local Foundation = require(CancelSubscriptionAppParent.Foundation)
local UIBlox = require(CancelSubscriptionAppParent.UIBlox)
local SelectionCursorProvider = UIBlox.App.SelectionImage.SelectionCursorProvider
local CursorProvider = UIBlox.App.SelectionCursor.CursorProvider
local CancelSubscriptionReducer = require(CancelSubscriptionApp.Store.Reducers.CancelSubscriptionReducer)
local CancelSubscriptionApp2 = require(CancelSubscriptionApp.CancelSubscriptionApp)
local NetworkContext = require(CancelSubscriptionAppParent.EconomyCommonCoreScriptHooks).NetworkContext
local FFlagLuaAppDefaultHttpRetry = require(CancelSubscriptionAppParent.SharedFlags).FFlagLuaAppDefaultHttpRetry
local t1 = {
	themeName = "dark",
	fontName = "gotham"
}

local function createFocusNavigationService() -- line: 35
	-- upvalues: ReactFocusNavigation (copy)
	return ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
end
local function createNetworkImpl() -- line: 39
	-- upvalues: HttpRequest (copy), FFlagLuaAppDefaultHttpRetry (copy)
	return HttpRequest.config({
		requestFunction = function(p1, p2, p3) -- line: 41
			-- upvalues: HttpRequest (copy)
			return (HttpRequest.requestFunctions.HttpRbxApi(p1, p2, p3))
		end,
		maxRetryCount = if not FFlagLuaAppDefaultHttpRetry then nil else game:DefineFastInt("RenderCancelSubscriptionAppHttpRetryCount", 4)
	})
end
local function createStore() -- line: 51
	-- upvalues: Rodux (copy), CancelSubscriptionReducer (copy)
	return Rodux.Store.new(CancelSubscriptionReducer, nil, { Rodux.makeThunkMiddleware() })
end
local function renderCancelSubscriptionApp() -- line: 57
	-- upvalues: CoreGui (copy), Rodux (copy), CancelSubscriptionReducer (copy), createNetworkImpl (copy), ReactFocusNavigation (copy), React (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy), AppStyleProvider (copy), t1 (copy), NetworkContext (copy), RoactRodux (copy), DesignTokenProvider (copy), SelectionCursorProvider (copy), CursorProvider (copy), Provider (copy), CancelSubscriptionApp2 (copy), Foundation (copy), ReactRoblox (copy)
	local Folder = Instance.new("Folder")

	Folder.Name = "CancelSubscriptionApp"
	Folder.Parent = CoreGui

	local v30 = Rodux.Store.new(CancelSubscriptionReducer, nil, { Rodux.makeThunkMiddleware() })
	local v31 = createNetworkImpl()
	local v32 = ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
	local v33 = React.createElement(LocalizationProvider, {
		localization = Localization.new(LocalizationService.RobloxLocaleId)
	}, {
		StyleProvider = React.createElement(AppStyleProvider, {
			style = t1
		}, {
			NetworkProvider = React.createElement(NetworkContext.Provider, {
				value = v31
			}, {
				StoreProvider = React.createElement(RoactRodux.StoreProvider, {
					store = v30
				}, {
					DesignTokenProvider = React.createElement(DesignTokenProvider, {
						tokenMappers = {}
					}, {
						CursorProvider = React.createElement(SelectionCursorProvider, {}, {
							NewCursorProvider = React.createElement(CursorProvider, {}, {
								FocusNavigationProvider = React.createElement(ReactFocusNavigation.FocusNavigationContext.Provider, {
									value = v32
								}, {
									FocusNavigationRegistryProvider = React.createElement(Provider, nil, {
										CancelSubscriptionApp = React.createElement(CancelSubscriptionApp2)
									})
								})
							})
						})
					})
				})
			})
		})
	})
	local v34 = React.createElement(Foundation.FoundationProvider, {
		theme = Foundation.Enums.Theme.Dark
	}, {
		LocalizationProvider = v33
	})
	local v35 = ReactRoblox.createRoot(Folder)

	v35:render(v34)

	return v35
end

return renderCancelSubscriptionApp
