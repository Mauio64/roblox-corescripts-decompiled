local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/ArgCheck")
local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/NavigationRodux")
local applySetNavigationLocked = NavigationRodux.Actions.ApplySetNavigationLocked
local selectors = NavigationRodux.Selectors
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/SharedFlags")
local fFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local fFlagSignalsNavP2NavigationPrimitives = SharedFlags.FFlagSignalsNavP2NavigationPrimitives
local appNavigationRegistry

if fFlagSignalsNavP2NavigationPrimitives then
	appNavigationRegistry = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/RobloxAppNavigation").AppNavigationRegistry
else
	appNavigationRegistry = nil
end

return function(callback)
	ArgCheck.isType(callback, "function", "navigationCallback")
	return function(object)
		if fFlagSignalsNavP2NavigationPrimitives then
			if appNavigationRegistry.get().getIsNavigating(false) then
				return
			end

			callback()
		else
			local state = object:getState()
			local v5

			if fFlagUseNavigationSelectors then
				v5 = selectors.selectNavigationLocked(state)
			else
				v5 = state.Navigation.lockNavigationActions
			end

			if v5 then
				return
			end

			object:dispatch(applySetNavigationLocked(true))
			callback()
		end
	end
end
