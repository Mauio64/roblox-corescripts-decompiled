local CoreGui = game:GetService("CoreGui")
local LocalizationService = game:GetService("LocalizationService")

local CancelSubscriptionApp = script:FindFirstAncestor("CancelSubscriptionApp")
local parent = CancelSubscriptionApp.Parent
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

local Foundation = require(parent.Foundation)
local UIBlox = require(parent.UIBlox)
local SelectionCursorProvider = UIBlox.App.SelectionImage.SelectionCursorProvider
local CursorProvider = UIBlox.App.SelectionCursor.CursorProvider

local CancelSubscriptionReducer = require(CancelSubscriptionApp.Store.Reducers.CancelSubscriptionReducer)
local CancelSubscriptionApp2 = require(CancelSubscriptionApp.CancelSubscriptionApp)
local EconomyCommonCoreScriptHooks = require(parent.EconomyCommonCoreScriptHooks)
local NetworkContext = EconomyCommonCoreScriptHooks.NetworkContext
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppDefaultHttpRetry = SharedFlags.FFlagLuaAppDefaultHttpRetry

local style = { themeName = "dark", fontName = "gotham" }

local function createFocusNavigationService() -- 1 equivalent call inferred from this helper
	return ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
end

local function createNetworkImpl()
	local config = HttpRequest.config
	local v = {
		requestFunction = function(p, p2, p3)
			return (HttpRequest.requestFunctions.HttpRbxApi(p, p2, p3))
		end,
		maxRetryCount = 0
	}
	local maxRetryCount

	if FFlagLuaAppDefaultHttpRetry then
		maxRetryCount = game:DefineFastInt("RenderCancelSubscriptionAppHttpRetryCount", 4)
	end

	v.maxRetryCount = maxRetryCount
	return config(v)
end

local function createStore() -- 1 equivalent call inferred from this helper
	return Rodux.Store.new(CancelSubscriptionReducer, nil, { Rodux.makeThunkMiddleware() })
end

local function renderCancelSubscriptionApp()
	local cancelSubscriptionApp = Instance.new("Folder")
	cancelSubscriptionApp.Name = "CancelSubscriptionApp"
	cancelSubscriptionApp.Parent = CoreGui
	local store = createStore() -- inferred equivalent call
	local networkImpl = createNetworkImpl()
	local focusNavigationService = createFocusNavigationService() -- inferred equivalent call
	local element = React.createElement(
		LocalizationProvider,
		{
			localization = localization.new(LocalizationService.RobloxLocaleId)
		},
		{
			StyleProvider = React.createElement(AppStyleProvider, { style = style }, {
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
												CancelSubscriptionApp = React.createElement(CancelSubscriptionApp2)
											})
										}
									)
								})
							})
						})
					})
				})
			})
		}
	)

	local element2 = React.createElement(
		Foundation.FoundationProvider,
		{ colorMode = Foundation.Enums.ColorMode.Dark },
		{ LocalizationProvider = element }
	)

	local root = ReactRoblox.createRoot(cancelSubscriptionApp)
	root:render(element2)
	return root
end

return renderCancelSubscriptionApp
