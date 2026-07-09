local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthCommonParent = AuthCommon.Parent
local dependencies = require(AuthCommon.dependencies)
local CentralOverlayType = require(AuthCommonParent.RobloxAppEnums).CentralOverlayType
local SetCentralOverlay = require(AuthCommonParent.CentralOverlay).Actions.SetCentralOverlay
local NavigateDown = require(AuthCommonParent.NavigationRodux).Thunks.NavigateDown
local AppPage = require(AuthCommonParent.RobloxAppEnums).AppPage
local FFlagSignalsNavP3Dispatch = require(AuthCommonParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v9 = if not FFlagSignalsNavP3Dispatch then nil else require(AuthCommonParent.RobloxAppNavigation).NavigationCommands
local GetFFlagEnableAccountSwitcherFoundationDesign = dependencies.SharedFlags.GetFFlagEnableAccountSwitcherFoundationDesign

return function(p1, p2, p3) -- line: 16
	-- upvalues: GetFFlagEnableAccountSwitcherFoundationDesign (copy), SetCentralOverlay (copy), CentralOverlayType (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v9 (copy), NavigateDown (copy)
	return function(p4) -- line: 17
		-- upvalues: p2 (copy), GetFFlagEnableAccountSwitcherFoundationDesign (copy), p3 (copy), SetCentralOverlay (copy), CentralOverlayType (copy), p1 (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v9 (copy), NavigateDown (copy)
		if p2 then
			if GetFFlagEnableAccountSwitcherFoundationDesign() and p3 then
				p4:dispatch(SetCentralOverlay(CentralOverlayType.AccountSwitcher, p1))

				return
			end

			local t1 = {
				name = AppPage.AccountSelectorPeekView,
				extraProps = p1
			}

			if FFlagSignalsNavP3Dispatch then
				v9.down(v9.fromLegacyPage(t1))

				return
			end

			p4:dispatch(NavigateDown(t1))

			return
		end

		p4:dispatch(SetCentralOverlay(CentralOverlayType.AccountSelector, p1))
	end
end
