local CoreGui = game:GetService("CoreGui")
local LocalizationService = game:GetService("LocalizationService")
local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local CurrencyTransfersParent = CurrencyTransfers.Parent
local ReactRoblox = require(CurrencyTransfersParent.ReactRoblox)
local Rodux = require(CurrencyTransfersParent.Rodux)
local RoactRodux = require(CurrencyTransfersParent.RoactRodux)
local React = require(CurrencyTransfersParent.React)
local HttpRequest = require(CurrencyTransfersParent.HttpRequest)
local DesignTokenProvider = require(CurrencyTransfersParent.Style).DesignTokenProvider
local AppStyleProvider = require(CurrencyTransfersParent.Style).AppStyleProvider
local LocalizationProvider = require(CurrencyTransfersParent.Localization).LocalizationProvider
local Localization = require(CurrencyTransfersParent.InExperienceLocales).Localization
local ReactFocusNavigation = require(CurrencyTransfersParent.ReactFocusNavigation)
local Provider = require(CurrencyTransfersParent.FocusNavigationUtils).FocusNavigableSurfaceRegistry.Provider
local UIBlox = require(CurrencyTransfersParent.UIBlox)
local SelectionCursorProvider = UIBlox.App.SelectionImage.SelectionCursorProvider
local CursorProvider = UIBlox.App.SelectionCursor.CursorProvider
local InExperienceTransferApp = require(CurrencyTransfers.Components.InExperienceTransferApp)
local NetworkContext = require(CurrencyTransfersParent.EconomyCommonCoreScriptHooks).NetworkContext
local t1 = {
	themeName = "dark",
	fontName = "gotham"
}

local function createFocusNavigationService() -- line: 31
	-- upvalues: ReactFocusNavigation (copy)
	return ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
end
local function createNetworkImpl() -- line: 35
	-- upvalues: HttpRequest (copy)
	return HttpRequest.config({
		requestFunction = function(p1, p2, p3) -- line: 37
			-- upvalues: HttpRequest (copy)
			return (HttpRequest.requestFunctions.HttpRbxApi(p1, p2, p3))
		end,
		maxRetryCount = game:DefineFastInt("InExperienceTransferMaxHttpRequestRetries", 2),
		maxWaitTime = game:DefineFastInt("InExperienceTransferMaxHttpRequestWaitTime", 1)
	})
end
local function renderInExperienceTransferApp() -- line: 46
	-- upvalues: CoreGui (copy), createNetworkImpl (copy), ReactFocusNavigation (copy), Rodux (copy), React (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy), AppStyleProvider (copy), t1 (copy), NetworkContext (copy), RoactRodux (copy), DesignTokenProvider (copy), SelectionCursorProvider (copy), CursorProvider (copy), Provider (copy), InExperienceTransferApp (copy), ReactRoblox (copy)
	local Folder = Instance.new("Folder")

	Folder.Name = "InExperienceTransferApp"
	Folder.Parent = CoreGui

	local v26 = createNetworkImpl()
	local v27 = ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
	local v28 = Rodux.Store.new(function(p4) -- line: 55
		return p4 or {}
	end)
	local v29 = React.createElement(LocalizationProvider, {
		localization = Localization.new(LocalizationService.RobloxLocaleId)
	}, {
		StyleProvider = React.createElement(AppStyleProvider, {
			style = t1
		}, {
			NetworkProvider = React.createElement(NetworkContext.Provider, {
				value = v26
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
									value = v27
								}, {
									FocusNavigationRegistryProvider = React.createElement(Provider, nil, {
										InExperienceTransferApp = React.createElement(InExperienceTransferApp)
									})
								})
							})
						})
					})
				})
			})
		})
	})
	local v30 = ReactRoblox.createRoot(Folder)

	v30:render(v29)

	return v30
end

return renderInExperienceTransferApp
