local parent = script.Parent
local parent2 = parent.Parent
require(parent.Types)
local startAmpUpsell = require(parent.startAmpUpsell)

return function(p, p2, flag: boolean?)
	return function(object)
		return startAmpUpsell(p, p2, function(extraProps): boolean
			local SharedFlags = require(parent2.SharedFlags)

			if not SharedFlags.FFlagEnableAmpV2Wizard then
				return false
			end

			local RobloxAppEnums = require(parent2.RobloxAppEnums)
			local v = { name = RobloxAppEnums.AppPage.AmpV2Wizard, extraProps = extraProps }

			if SharedFlags.FFlagSignalsNavP3Dispatch or SharedFlags.FFlagSignalsNavP2NavigationPrimitives then
				local RobloxAppNavigation = require(parent2.RobloxAppNavigation)
				local appNavigationRegistry = RobloxAppNavigation.AppNavigationRegistry

				if
					appNavigationRegistry.isRegistered()
					and (flag or not appNavigationRegistry.get().getIsNavigating(false))
				then
					local navigationCommands = RobloxAppNavigation.NavigationCommands
					navigationCommands.down(navigationCommands.fromLegacyPage(v), flag)
				else
					return false
				end
			else
				local navigation = object:getState().Navigation

				if navigation and (not navigation.lockNavigationActions or flag) then
					local NavigationRodux = require(parent2.NavigationRodux)
					object:dispatch(NavigationRodux.Thunks.NavigateDown(v, flag))
				else
					return false
				end
			end

			return true
		end, false)
	end
end
