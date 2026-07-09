local CoreGui = game:GetService("CoreGui")
local LocalizationService = game:GetService("LocalizationService")
local CommercePurchaseApp = script:FindFirstAncestor("CommercePurchaseApp")
local CommercePurchaseAppParent = CommercePurchaseApp.Parent
local Rodux = require(CommercePurchaseAppParent.Rodux)
local ReactRoblox = require(CommercePurchaseAppParent.ReactRoblox)
local RoactRodux = require(CommercePurchaseAppParent.RoactRodux)
local React = require(CommercePurchaseAppParent.React)
local HttpRequest = require(CommercePurchaseAppParent.HttpRequest)
local DesignTokenProvider = require(CommercePurchaseAppParent.Style).DesignTokenProvider
local AppStyleProvider = require(CommercePurchaseAppParent.Style).AppStyleProvider
local LocalizationProvider = require(CommercePurchaseAppParent.Localization).LocalizationProvider
local Localization = require(CommercePurchaseAppParent.InExperienceLocales).Localization
local ReactFocusNavigation = require(CommercePurchaseAppParent.ReactFocusNavigation)
local Provider = require(CommercePurchaseAppParent.FocusNavigationUtils).FocusNavigableSurfaceRegistry.Provider
local UIBlox = require(CommercePurchaseAppParent.UIBlox)
local SelectionCursorProvider = UIBlox.App.SelectionImage.SelectionCursorProvider
local CursorProvider = UIBlox.App.SelectionCursor.CursorProvider
local CommercePurchaseApp2 = require(CommercePurchaseApp.CommercePurchaseApp)
local CommercePurchaseReducer = require(CommercePurchaseApp.Store.Reducers.CommercePurchaseReducer)
local NetworkContext = require(CommercePurchaseAppParent.EconomyCommonCoreScriptHooks).NetworkContext
local t1 = {
	themeName = "dark",
	fontName = "gotham"
}

local function createFocusNavigationService() -- line: 32
	-- upvalues: ReactFocusNavigation (copy)
	return ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
end
local function createNetworkImpl() -- line: 36
	-- upvalues: HttpRequest (copy)
	return HttpRequest.config({
		requestFunction = function(p1, p2, p3) -- line: 38
			-- upvalues: HttpRequest (copy)
			return (HttpRequest.requestFunctions.HttpRbxApi(p1, p2, p3))
		end,
		maxRetryCount = game:DefineFastInt("CommercePurchaseMaxHttpRequestRetries", 2),
		maxWaitTime = game:DefineFastInt("CommercePurchaseMaxHttpRequestWaitTime", 1)
	})
end
local function createStore() -- line: 47
	-- upvalues: Rodux (copy), CommercePurchaseReducer (copy)
	return Rodux.Store.new(CommercePurchaseReducer, nil, { Rodux.makeThunkMiddleware() })
end
local function renderCommercePurchaseApp() -- line: 53
	-- upvalues: CoreGui (copy), Rodux (copy), CommercePurchaseReducer (copy), createNetworkImpl (copy), ReactFocusNavigation (copy), React (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy), AppStyleProvider (copy), t1 (copy), NetworkContext (copy), RoactRodux (copy), DesignTokenProvider (copy), SelectionCursorProvider (copy), CursorProvider (copy), Provider (copy), CommercePurchaseApp2 (copy), ReactRoblox (copy)
	local Folder = Instance.new("Folder")

	Folder.Name = "CommercePurchaseApp"
	Folder.Parent = CoreGui

	local v28 = Rodux.Store.new(CommercePurchaseReducer, nil, { Rodux.makeThunkMiddleware() })
	local v29 = createNetworkImpl()
	local v30 = ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
	local v31 = React.createElement(LocalizationProvider, {
		localization = Localization.new(LocalizationService.RobloxLocaleId)
	}, { React.createElement(AppStyleProvider, {
		style = t1
	}, {
		NetworkProvider = React.createElement(NetworkContext.Provider, {
			value = v29
		}, {
			StoreProvider = React.createElement(RoactRodux.StoreProvider, {
				store = v28
			}, {
				DesignTokenProvider = React.createElement(DesignTokenProvider, {
					tokenMappers = {}
				}, {
					CursorProvider = React.createElement(SelectionCursorProvider, {}, {
						NewCursorProvider = React.createElement(CursorProvider, {}, {
							FocusNavigationProvider = React.createElement(ReactFocusNavigation.FocusNavigationContext.Provider, {
								value = v30
							}, {
								FocusNavigationRegistryProvider = React.createElement(Provider, nil, {
									CommercePurchaseApp = React.createElement(CommercePurchaseApp2)
								})
							})
						})
					})
				})
			})
		})
	}) })
	local v32 = ReactRoblox.createRoot(Folder)

	v32:render(v31)

	return v32
end

return renderCommercePurchaseApp
