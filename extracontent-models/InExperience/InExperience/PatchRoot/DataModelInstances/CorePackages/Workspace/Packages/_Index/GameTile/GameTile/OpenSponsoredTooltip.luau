local Parent = script:FindFirstAncestor("GameTile").Parent
local RobloxAppEnums = require(Parent.RobloxAppEnums)
local CentralOverlayType = RobloxAppEnums.CentralOverlayType
local AppPage = RobloxAppEnums.AppPage
local SetCentralOverlay = require(Parent.CentralOverlay).Actions.SetCentralOverlay
local NavigateDown = require(Parent.NavigationRodux).Thunks.NavigateDown
local Responsive = require(Parent.Responsive)
local FFlagSignalsNavP3Dispatch = require(Parent.SharedFlags).FFlagSignalsNavP3Dispatch
local v9 = if not FFlagSignalsNavP3Dispatch then nil else require(Parent.RobloxAppNavigation).NavigationCommands

return function(p1) -- line: 16
	-- upvalues: Responsive (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v9 (copy), NavigateDown (copy), SetCentralOverlay (copy), CentralOverlayType (copy)
	return function(p2) -- line: 17
		-- upvalues: p1 (copy), Responsive (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v9 (copy), NavigateDown (copy), SetCentralOverlay (copy), CentralOverlayType (copy)
		if p1 == Responsive.Input.Touch then
			local t1 = {
				name = AppPage.SponsoredTooltipPeekView
			}

			if FFlagSignalsNavP3Dispatch then
				v9.down(v9.fromLegacyPage(t1))

				return
			end

			p2:dispatch(NavigateDown(t1))

			return
		end

		p2:dispatch(SetCentralOverlay(CentralOverlayType.SponsoredTooltip))
	end
end
