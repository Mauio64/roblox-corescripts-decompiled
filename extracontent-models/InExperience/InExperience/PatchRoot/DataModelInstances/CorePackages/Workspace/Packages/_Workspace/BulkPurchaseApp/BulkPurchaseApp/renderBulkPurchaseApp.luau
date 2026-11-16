local CoreGui = game:GetService("CoreGui")
local LocalizationService = game:GetService("LocalizationService")

local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local parent = BulkPurchaseApp.Parent
local Rodux = require(parent.Rodux)
local ReactRoblox = require(parent.ReactRoblox)
local RoactRodux = require(parent.RoactRodux)
local React = require(parent.React)
local HttpRequest = require(parent.HttpRequest)
local Style = require(parent.Style)
local DesignTokenProvider = Style.DesignTokenProvider
local Style2 = require(parent.Style)
local AppStyleProvider = Style2.AppStyleProvider
local Localization = require(parent.Localization)
local LocalizationProvider = Localization.LocalizationProvider
local InExperienceLocales = require(parent.InExperienceLocales)
local localization = InExperienceLocales.Localization
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local Provider = FocusNavigationUtils.FocusNavigableSurfaceRegistry.Provider
local UIBlox = require(parent.UIBlox)
local SelectionCursorProvider = UIBlox.App.SelectionImage.SelectionCursorProvider
local CursorProvider = UIBlox.App.SelectionCursor.CursorProvider
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local universalAppPolicy = UniversalAppPolicy.UniversalAppPolicy
local AppFeaturePolicies = UniversalAppPolicy.AppFeaturePolicies

local BulkPurchaseApp2 = require(BulkPurchaseApp.BulkPurchaseApp)
local BulkPurchaseReducer = require(BulkPurchaseApp.Store.Reducers.BulkPurchaseReducer)
local EconomyCommonCoreScriptHooks = require(parent.EconomyCommonCoreScriptHooks)
local NetworkContext = EconomyCommonCoreScriptHooks.NetworkContext

local FFlagAXAddPlusUpsellToBulkPurchase = require(BulkPurchaseApp.Flags.FFlagAXAddPlusUpsellToBulkPurchase)

local style = { themeName = "dark", fontName = "gotham" }

local function createFocusNavigationService() -- 1 equivalent call inferred from this helper
	return ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
end

local function createNetworkImpl()
	return HttpRequest.config({
		requestFunction = function(p, p2, p3)
			return (HttpRequest.requestFunctions.HttpRbxApi(p, p2, p3))
		end,
		maxRetryCount = game:DefineFastInt("BulkPurchaseMaxHttpRequestRetries", 2),
		maxWaitTime = game:DefineFastInt("BulkPurchaseMaxHttpRequestWaitTime", 1)
	})
end

local function createStore() -- 1 equivalent call inferred from this helper
	return Rodux.Store.new(BulkPurchaseReducer, nil, { Rodux.makeThunkMiddleware() })
end

local function renderBulkPurchaseApp()
	local bulkPurchaseApp = Instance.new("Folder")
	bulkPurchaseApp.Name = "BulkPurchaseApp"
	bulkPurchaseApp.Parent = CoreGui
	local store = createStore() -- inferred equivalent call
	local networkImpl = createNetworkImpl()
	local focusNavigationService = createFocusNavigationService() -- inferred equivalent call
	local createElement = React.createElement
	local v = {
		localization = localization.new(LocalizationService.RobloxLocaleId)
	}

	local createElement2 = React.createElement
	local createElement3 = React.createElement
	local provider = NetworkContext.Provider
	local createElement4 = React.createElement
	local storeProvider = RoactRodux.StoreProvider
	local createElement5 = React.createElement
	local createElement6 = React.createElement
	local createElement7 = React.createElement
	local createElement8 = React.createElement
	local provider2 = ReactFocusNavigation.FocusNavigationContext.Provider

	local createElement9 = React.createElement
	local v2

	if FFlagAXAddPlusUpsellToBulkPurchase then
		v2 = {
			PolicyProvider = React.createElement(universalAppPolicy.Provider, {
				policy = { AppFeaturePolicies }
			}, {
				BulkPurchaseApp = React.createElement(BulkPurchaseApp2)
			})
		}
	else
		v2 = {
			BulkPurchaseApp = React.createElement(BulkPurchaseApp2)
		}
	end

	local element = createElement(LocalizationProvider, v, {
		StyleProvider = createElement2(AppStyleProvider, { style = style }, {
			NetworkProvider = createElement3(provider, { value = networkImpl }, {
				StoreProvider = createElement4(storeProvider, { store = store }, {
					DesignTokenProvider = createElement5(DesignTokenProvider, { tokenMappers = {} }, {
						CursorProvider = createElement6(SelectionCursorProvider, {}, {
							NewCursorProvider = createElement7(CursorProvider, {}, {
								FocusNavigationProvider = createElement8(
									provider2,
									{ value = focusNavigationService },
									{
										FocusNavigationRegistryProvider = createElement9(Provider, nil, v2)
									}
								)
							})
						})
					})
				})
			})
		})
	})

	local root = ReactRoblox.createRoot(bulkPurchaseApp)
	root:render(element)
	return root
end

return renderBulkPurchaseApp
