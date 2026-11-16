local CoreGui = game:GetService("CoreGui")
local LocalizationService = game:GetService("LocalizationService")

local CommercePurchaseApp = script:FindFirstAncestor("CommercePurchaseApp")
local parent = CommercePurchaseApp.Parent
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

local CommercePurchaseApp2 = require(CommercePurchaseApp.CommercePurchaseApp)
local CommercePurchaseReducer = require(CommercePurchaseApp.Store.Reducers.CommercePurchaseReducer)
local EconomyCommonCoreScriptHooks = require(parent.EconomyCommonCoreScriptHooks)
local NetworkContext = EconomyCommonCoreScriptHooks.NetworkContext

local style = { themeName = "dark", fontName = "gotham" }

local function createFocusNavigationService() -- 1 equivalent call inferred from this helper
	return ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
end

local function createNetworkImpl()
	return HttpRequest.config({
		requestFunction = function(p, p2, p3)
			return (HttpRequest.requestFunctions.HttpRbxApi(p, p2, p3))
		end,
		maxRetryCount = game:DefineFastInt("CommercePurchaseMaxHttpRequestRetries", 2),
		maxWaitTime = game:DefineFastInt("CommercePurchaseMaxHttpRequestWaitTime", 1)
	})
end

local function createStore() -- 1 equivalent call inferred from this helper
	return Rodux.Store.new(CommercePurchaseReducer, nil, { Rodux.makeThunkMiddleware() })
end

local function renderCommercePurchaseApp()
	local commercePurchaseApp = Instance.new("Folder")
	commercePurchaseApp.Name = "CommercePurchaseApp"
	commercePurchaseApp.Parent = CoreGui
	local store = createStore() -- inferred equivalent call
	local networkImpl = createNetworkImpl()
	local focusNavigationService = createFocusNavigationService() -- inferred equivalent call
	local element = React.createElement(
		LocalizationProvider,
		{
			localization = localization.new(LocalizationService.RobloxLocaleId)
		},
		{ React.createElement(AppStyleProvider, { style = style }, {
				NetworkProvider = React.createElement(NetworkContext.Provider, {
					value = networkImpl
				}, {
					StoreProvider = React.createElement(RoactRodux.StoreProvider, { store = store }, {
						DesignTokenProvider = React.createElement(DesignTokenProvider, {
							tokenMappers = {}
						}, {
							CursorProvider = React.createElement(SelectionCursorProvider, {}, {
								NewCursorProvider = React.createElement(CursorProvider, {}, {
									FocusNavigationProvider = React.createElement(
										ReactFocusNavigation.FocusNavigationContext.Provider,
										{ value = focusNavigationService },
										{
											FocusNavigationRegistryProvider = React.createElement(Provider, nil, {
												CommercePurchaseApp = React.createElement(CommercePurchaseApp2)
											})
										}
									)
								})
							})
						})
					})
				})
			}) }
	)

	local root = ReactRoblox.createRoot(commercePurchaseApp)
	root:render(element)
	return root
end

return renderCommercePurchaseApp
