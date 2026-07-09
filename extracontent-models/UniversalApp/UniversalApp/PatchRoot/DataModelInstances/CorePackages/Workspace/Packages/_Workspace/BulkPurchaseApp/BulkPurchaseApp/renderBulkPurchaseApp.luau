local CoreGui = game:GetService("CoreGui")
local LocalizationService = game:GetService("LocalizationService")
local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local BulkPurchaseAppParent = BulkPurchaseApp.Parent
local Rodux = require(BulkPurchaseAppParent.Rodux)
local ReactRoblox = require(BulkPurchaseAppParent.ReactRoblox)
local RoactRodux = require(BulkPurchaseAppParent.RoactRodux)
local React = require(BulkPurchaseAppParent.React)
local HttpRequest = require(BulkPurchaseAppParent.HttpRequest)
local DesignTokenProvider = require(BulkPurchaseAppParent.Style).DesignTokenProvider
local AppStyleProvider = require(BulkPurchaseAppParent.Style).AppStyleProvider
local LocalizationProvider = require(BulkPurchaseAppParent.Localization).LocalizationProvider
local Localization = require(BulkPurchaseAppParent.InExperienceLocales).Localization
local ReactFocusNavigation = require(BulkPurchaseAppParent.ReactFocusNavigation)
local Provider = require(BulkPurchaseAppParent.FocusNavigationUtils).FocusNavigableSurfaceRegistry.Provider
local UIBlox = require(BulkPurchaseAppParent.UIBlox)
local SelectionCursorProvider = UIBlox.App.SelectionImage.SelectionCursorProvider
local CursorProvider = UIBlox.App.SelectionCursor.CursorProvider
local BulkPurchaseApp2 = require(BulkPurchaseApp.BulkPurchaseApp)
local BulkPurchaseReducer = require(BulkPurchaseApp.Store.Reducers.BulkPurchaseReducer)
local NetworkContext = require(BulkPurchaseAppParent.EconomyCommonCoreScriptHooks).NetworkContext
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
		maxRetryCount = game:DefineFastInt("BulkPurchaseMaxHttpRequestRetries", 2),
		maxWaitTime = game:DefineFastInt("BulkPurchaseMaxHttpRequestWaitTime", 1)
	})
end
local function createStore() -- line: 47
	-- upvalues: Rodux (copy), BulkPurchaseReducer (copy)
	return Rodux.Store.new(BulkPurchaseReducer, nil, { Rodux.makeThunkMiddleware() })
end
local function renderBulkPurchaseApp() -- line: 53
	-- upvalues: CoreGui (copy), Rodux (copy), BulkPurchaseReducer (copy), createNetworkImpl (copy), ReactFocusNavigation (copy), React (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy), AppStyleProvider (copy), t1 (copy), NetworkContext (copy), RoactRodux (copy), DesignTokenProvider (copy), SelectionCursorProvider (copy), CursorProvider (copy), Provider (copy), BulkPurchaseApp2 (copy), ReactRoblox (copy)
	local Folder = Instance.new("Folder")

	Folder.Name = "BulkPurchaseApp"
	Folder.Parent = CoreGui

	local v28 = Rodux.Store.new(BulkPurchaseReducer, nil, { Rodux.makeThunkMiddleware() })
	local v29 = createNetworkImpl()
	local v30 = ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
	local v31 = React.createElement(LocalizationProvider, {
		localization = Localization.new(LocalizationService.RobloxLocaleId)
	}, {
		StyleProvider = React.createElement(AppStyleProvider, {
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
										BulkPurchaseApp = React.createElement(BulkPurchaseApp2)
									})
								})
							})
						})
					})
				})
			})
		})
	})
	local v32 = ReactRoblox.createRoot(Folder)

	v32:render(v31)

	return v32
end

return renderBulkPurchaseApp
