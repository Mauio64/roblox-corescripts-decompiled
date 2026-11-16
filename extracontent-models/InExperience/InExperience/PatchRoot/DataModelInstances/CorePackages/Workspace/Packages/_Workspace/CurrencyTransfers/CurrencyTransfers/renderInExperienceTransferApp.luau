local CoreGui = game:GetService("CoreGui")
local LocalizationService = game:GetService("LocalizationService")

local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local parent = CurrencyTransfers.Parent
local ReactRoblox = require(parent.ReactRoblox)
local Rodux = require(parent.Rodux)
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

local InExperienceTransferApp = require(CurrencyTransfers.Components.InExperienceTransferApp)
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
		maxRetryCount = game:DefineFastInt("InExperienceTransferMaxHttpRequestRetries", 2),
		maxWaitTime = game:DefineFastInt("InExperienceTransferMaxHttpRequestWaitTime", 1)
	})
end

local function renderInExperienceTransferApp()
	local inExperienceTransferApp = Instance.new("Folder")
	inExperienceTransferApp.Name = "InExperienceTransferApp"
	inExperienceTransferApp.Parent = CoreGui

	local networkImpl = createNetworkImpl()
	local focusNavigationService = createFocusNavigationService() -- inferred equivalent call
	local store = Rodux.Store.new(function(options)
		return options or {}
	end)

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
												InExperienceTransferApp = React.createElement(InExperienceTransferApp)
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

	local root = ReactRoblox.createRoot(inExperienceTransferApp)
	root:render(element)
	return root
end

return renderInExperienceTransferApp
