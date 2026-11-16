local CoreGui = game:GetService("CoreGui")
local LocalizationService = game:GetService("LocalizationService")

local ReactRoblox = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/ReactRoblox")
local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/Rodux")
local RoactRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/RoactRodux")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/React")
local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/HttpRequest")
local designTokenProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/Style").DesignTokenProvider
local appStyleProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/Style").AppStyleProvider
local localizationProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/Localization").LocalizationProvider
local localization = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/InExperienceLocales").Localization
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/ReactFocusNavigation")
local provider = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/FocusNavigationUtils").FocusNavigableSurfaceRegistry.Provider
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/UIBlox")
local selectionCursorProvider = UIBlox.App.SelectionImage.SelectionCursorProvider
local cursorProvider = UIBlox.App.SelectionCursor.CursorProvider

local module8 = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Components/InExperienceTransferApp")
local networkContext = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/EconomyCommonCoreScriptHooks").NetworkContext

local v5 = { themeName = "dark", fontName = "gotham" }

local function createFocusNavigationService()
	return ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
end

local function createNetworkImpl()
	return HttpRequest.config({
		requestFunction = function(p2, p3, p4)
			return (HttpRequest.requestFunctions.HttpRbxApi(p2, p3, p4))
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
	local focusNavigationService = ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)

	local store = Rodux.Store.new(function(options)
		return options or {}
	end)

	local element = React.createElement(
		localizationProvider,
		{
			localization = localization.new(LocalizationService.RobloxLocaleId)
		},
		{
			StyleProvider = React.createElement(appStyleProvider, { style = v5 }, {
				NetworkProvider = React.createElement(networkContext.Provider, {
					value = networkImpl
				}, {
					StoreProvider = React.createElement(RoactRodux.StoreProvider, {
						store = store
					}, {
						DesignTokenProvider = React.createElement(
							designTokenProvider,
							{ tokenMappers = {} },
							{
								CursorProvider = React.createElement(selectionCursorProvider, {}, {
									NewCursorProvider = React.createElement(cursorProvider, {}, {
										FocusNavigationProvider = React.createElement(
											ReactFocusNavigation.FocusNavigationContext.Provider,
											{ value = focusNavigationService },
											{
												FocusNavigationRegistryProvider = React.createElement(provider, nil, {
													InExperienceTransferApp = React.createElement(module8)
												})
											}
										)
									})
								})
							}
						)
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
