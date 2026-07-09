local CorePackages = game:GetService("CorePackages")
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local Selectors = require(CorePackages.Workspace.Packages.NavigationRodux).Selectors
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local SquadExternalContractProvider = require(CorePackages.Workspace.Packages.SquadsCore.SquadExternalContractProvider)
local SquadRootViewType = require(CorePackages.Workspace.Packages.SquadsCore.Enums).SquadRootViewType
local makeSquadContract = SquadExternalContractProvider.makeSquadContract
local CentralOverlayType = require(CorePackages.Workspace.Packages.RobloxAppEnums).CentralOverlayType
local SetCentralOverlay = require(CorePackages.Workspace.Packages.CentralOverlay).Actions.SetCentralOverlay
local CloseCentralOverlay = require(CorePackages.Workspace.Packages.CentralOverlay).Thunks.CloseCentralOverlay
local SquadContract = require(CorePackages.Workspace.Packages.AppChat.SquadContract)
local useChatIsVisible = require(CorePackages.Workspace.Packages.AppChat.useChatIsVisible)
local FFlagEnableSquadTopBannerWideMode = SharedFlags.FFlagEnableSquadTopBannerWideMode
local FFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local FFlagSignalsNavP3hMisc = SharedFlags.FFlagSignalsNavP3hMisc
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local v20 = if not FFlagSignalsNavP3hMisc then nil else require(CorePackages.Workspace.Packages.NavigationRodux).GetLegacyNavigationStore

return (makeSquadContract(Cryo.Dictionary.union(SquadContract, {
	setSquadPrompt = function(p1, p2) -- line: 34
		-- upvalues: SetCentralOverlay (copy), CentralOverlayType (copy)
		p1:dispatch(SetCentralOverlay(CentralOverlayType.SquadPrompt, p2))
	end,
	showSearchOverlay = function(p3: ((...any) -> ...any), t1: {[any]: any}?) -- line: 38
		-- upvalues: SetCentralOverlay (copy), CentralOverlayType (copy), Cryo (copy)
		p3(SetCentralOverlay(CentralOverlayType.SearchPageOverlay, Cryo.Dictionary.join({
			isFocused = true,
			initialSearchText = "",
			searchType = "Games"
		}, t1 or {})))
	end,
	closeSquadPrompt = CloseCentralOverlay,
	useSquadRootView = function() -- line: 49
		-- upvalues: FFlagSignalsNavP3hMisc (copy), FFlagEnableSquadTopBannerWideMode (copy), useSelector (copy), v20 (copy), useSignalState (copy), AppPage (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), useChatIsVisible (copy), SquadRootViewType (copy)
		local v28

		if FFlagSignalsNavP3hMisc and FFlagEnableSquadTopBannerWideMode then
			local v25 = useSelector(function(p4) -- line: 52
				return p4.Navigation ~= nil
			end)
			local v26 = v20(false)
			local v27 = useSignalState(v26.getCurrentLegacyRoute)

			if not v25 then
				v28 = true
			else
				v28 = false

				if v27 then
					for _, v30 in v27 do
						if v30.name == AppPage.Chat then
							v28 = true

							break
						end
					end
				end
			end
		else
			v28 = if not FFlagEnableSquadTopBannerWideMode then useChatIsVisible() else useSelector(function(p5) -- line: 71
				-- upvalues: FFlagUseNavigationSelectors (copy), Selectors (copy), AppPage (copy)
				if not p5.Navigation then
					return true
				end

				local v37 = if not FFlagUseNavigationSelectors then p5.Navigation.history else Selectors.selectLegacyHistory(p5)

				if not v37 then
					return false
				end

				local v38 = v37[#v37]

				if not v38 then
					return false
				end

				for _, v40 in v38 do
					if v40.name == AppPage.Chat then
						return true
					end
				end

				return false
			end)
		end

		if v28 then
			return SquadRootViewType.UAAppChatPage
		end

		return SquadRootViewType.None
	end,
	useSquadTopBannerManager = function() -- line: 104
		-- upvalues: React (copy), Cryo (copy)
		local v31, v32 = React.useState({})
		local v33 = React.useCallback(function(s1: string, b1: boolean) -- line: 107
			-- upvalues: v32 (copy), Cryo (copy)
			v32(function(p6) -- line: 108
				-- upvalues: s1 (copy), b1 (copy), Cryo (copy)
				if p6[s1] == true == b1 then
					return p6
				end

				return Cryo.Dictionary.join(p6, {
					[s1] = not not b1 or Cryo.None
				})
			end)
		end, { v32 })
		local v34 = React.useCallback(function() -- line: 118
			-- upvalues: v31 (copy)
			for _, v in pairs(v31) do
				if v == true then
					return true
				end
			end

			return false
		end, { v31 })

		return {
			disableSquadTopBanner = v33,
			useSquadTopBannerDisabled = v34
		}
	end
})))
