local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local OverlayType = require(Modules.LuaApp.Enum.OverlayType)
local SetCentralOverlay = require(Modules.LuaApp.Actions.SetCentralOverlay)
local CloseCentralOverlay = require(CorePackages.Workspace.Packages.CentralOverlay).Thunks.CloseCentralOverlay
local NavigateDown = require(CorePackages.Workspace.Packages.NavigationRodux).Thunks.NavigateDown
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local TransitionAnimation = require(Modules.LuaApp.Enum.TransitionAnimation)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v10 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands

return function(p1, b1: boolean?) -- line: 15
	-- upvalues: CloseCentralOverlay (copy), AppPage (copy), TransitionAnimation (copy), FFlagSignalsNavP3Dispatch (copy), v10 (copy), NavigateDown (copy), SetCentralOverlay (copy), OverlayType (copy)
	return function(p2) -- line: 16
		-- upvalues: p1 (copy), CloseCentralOverlay (copy), AppPage (copy), TransitionAnimation (copy), FFlagSignalsNavP3Dispatch (copy), v10 (copy), NavigateDown (copy), b1 (copy), SetCentralOverlay (copy), OverlayType (copy)
		function p1.closeUpsell() -- line: 17
			-- upvalues: p2 (copy), CloseCentralOverlay (copy)
			return p2:dispatch(CloseCentralOverlay())
		end
		function p1.showWebpage(s1: string) -- line: 20
			-- upvalues: AppPage (copy), TransitionAnimation (copy), FFlagSignalsNavP3Dispatch (copy), v10 (copy), p2 (copy), NavigateDown (copy)
			local t1 = {
				name = AppPage.GenericWebPage,
				detail = s1,
				extraProps = {
					title = "",
					transitionAnimation = TransitionAnimation.SlideInFromBottom
				}
			}

			if FFlagSignalsNavP3Dispatch then
				return v10.down(v10.fromLegacyPage(t1))
			end

			return p2:dispatch(NavigateDown(t1))
		end

		if b1 then
			p2:dispatch(SetCentralOverlay(OverlayType.VoicePhoneVerificationUpsellOverlayWrapper, p1))

			return
		end

		p2:dispatch(SetCentralOverlay(OverlayType.PhoneVerificationUpsellOverlayWrapper, p1))
	end
end
