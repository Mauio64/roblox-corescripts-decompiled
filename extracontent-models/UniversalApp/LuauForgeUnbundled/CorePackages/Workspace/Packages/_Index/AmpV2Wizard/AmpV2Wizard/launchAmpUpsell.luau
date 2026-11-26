require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/Types")
local startAmpUpsell = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/startAmpUpsell")

return function(p2, p3, p4)
	return function(object)
		return startAmpUpsell(p2, p3, function(p5): boolean
			local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/SharedFlags")

			if not SharedFlags.FFlagEnableAmpV2Wizard then
				return false
			end

			local v5 = {
				name = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/RobloxAppEnums").AppPage.AmpV2Wizard,
				extraProps = p5
			}

			if SharedFlags.FFlagSignalsNavP3Dispatch or SharedFlags.FFlagSignalsNavP2NavigationPrimitives then
				local RobloxAppNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/RobloxAppNavigation")
				local appNavigationRegistry = RobloxAppNavigation.AppNavigationRegistry

				if
					appNavigationRegistry.isRegistered()
					and (p4 or not appNavigationRegistry.get().getIsNavigating(false))
				then
					local navigationCommands = RobloxAppNavigation.NavigationCommands
					navigationCommands.down(navigationCommands.fromLegacyPage(v5), p4)
				else
					return false
				end
			else
				local navigation = object:getState().Navigation

				if navigation and (not navigation.lockNavigationActions or p4) then
					object:dispatch(require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/NavigationRodux").Thunks.NavigateDown(v5, p4))
				else
					return false
				end
			end

			return true
		end, false)
	end
end
