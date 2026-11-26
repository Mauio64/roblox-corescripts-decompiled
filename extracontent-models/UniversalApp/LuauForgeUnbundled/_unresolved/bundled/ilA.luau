local CorePackages = game:GetService("CorePackages")

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Selectors
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector

local module2 = require("@luauforge/bundled/iig")
local squadRootViewType = require("@luauforge/bundled/cAW").SquadRootViewType
local makeSquadContract = module2.makeSquadContract

local centralOverlayType = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").CentralOverlayType
local setCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/CentralOverlay").Actions.SetCentralOverlay
local closeCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/CentralOverlay").Thunks.CloseCentralOverlay

local module3 = require("@luauforge/bundled/ilB")

local module4 = require("@luauforge/bundled/ilF")

local fFlagEnableSquadTopBannerWideMode = SharedFlags.FFlagEnableSquadTopBannerWideMode
local fFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local fFlagSignalsNavP3dRouteGated = SharedFlags.FFlagSignalsNavP3dRouteGated
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local Signals = require(CorePackages.Packages.Signals)
local getLegacyNavigationStore

if fFlagSignalsNavP3dRouteGated then
	getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore
else
	getLegacyNavigationStore = nil
end

local isNavigationAvailable = if fFlagSignalsNavP3dRouteGated then require("@luauforge/bundled/dFz").isNavigationAvailable else nil

return (makeSquadContract(Cryo.Dictionary.union(module3, {
	setSquadPrompt = function(object, p2)
		object:dispatch(setCentralOverlay(centralOverlayType.SquadPrompt, p2))
	end,
	showSearchOverlay = function(callback, options)
		callback(setCentralOverlay(
			centralOverlayType.SearchPageOverlay,
			Cryo.Dictionary.join(
				{ isFocused = true, initialSearchText = "", searchType = "Games" },
				options or {}
			)
		))
	end,
	closeSquadPrompt = closeCentralOverlay,
	useSquadRootView = function()
		local v5

		if fFlagSignalsNavP3dRouteGated and fFlagEnableSquadTopBannerWideMode then
			local legacyNavigationStore = getLegacyNavigationStore(false)
			v5 = useSignalState((React.useMemo(function()
				local routeContainsPageSignal = legacyNavigationStore.getRouteContainsPageSignal(appPage.Chat)
				return Signals.createComputed(function(p2)
					if isNavigationAvailable() then
						return routeContainsPageSignal(p2)
					end

					return true
				end)
			end, {})))
		elseif fFlagEnableSquadTopBannerWideMode then
			v5 = useSelector(function(p2): boolean
				if not p2.Navigation then
					return true
				end

				local v6

				if fFlagUseNavigationSelectors then
					v6 = selectors.selectLegacyHistory(p2)
				else
					v6 = p2.Navigation.history
				end

				if not v6 then
					return false
				end

				local v7 = v6[#v6]

				if not v7 then
					return false
				end

				for k, v8 in v7 do
					if v8.name == appPage.Chat then
						return true
					end
				end

				return false
			end)
		else
			v5 = module4()
		end

		if v5 then
			return squadRootViewType.UAAppChatPage
		end

		return squadRootViewType.None
	end,
	useSquadTopBannerManager = function()
		local state, setState = React.useState({})

		return {
			disableSquadTopBanner = React.useCallback(function(p2, p3)
				setState(function(p4)
					if p3 == (p4[p2] == true) then
						return p4
					end

					return Cryo.Dictionary.join(p4, {
						[p2] = p3 and true or Cryo.None
					})
				end)
			end, { setState }),
			useSquadTopBannerDisabled = React.useCallback(function(): boolean
				for k, v5 in pairs(state) do
					if v5 == true then
						return true
					end
				end

				return false
			end, { state })
		}
	end
})))
