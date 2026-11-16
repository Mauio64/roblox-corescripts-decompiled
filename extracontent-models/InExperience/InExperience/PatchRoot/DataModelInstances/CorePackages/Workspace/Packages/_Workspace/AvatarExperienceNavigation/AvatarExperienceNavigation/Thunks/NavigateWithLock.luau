local parent = script:FindFirstAncestor("AvatarExperienceNavigation").Parent

local ArgCheck = require(parent.ArgCheck)
local NavigationRodux = require(parent.NavigationRodux)
local ApplySetNavigationLocked = NavigationRodux.Actions.ApplySetNavigationLocked
local Selectors = NavigationRodux.Selectors
local SharedFlags = require(parent.SharedFlags)
local FFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local FFlagSignalsNavP2NavigationPrimitives = SharedFlags.FFlagSignalsNavP2NavigationPrimitives
local appNavigationRegistry

if FFlagSignalsNavP2NavigationPrimitives then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	appNavigationRegistry = RobloxAppNavigation.AppNavigationRegistry
else
	appNavigationRegistry = nil
end

return function(callback)
	ArgCheck.isType(callback, "function", "navigationCallback")
	return function(object)
		if FFlagSignalsNavP2NavigationPrimitives then
			if appNavigationRegistry.get().getIsNavigating(false) then
				return
			end

			callback()
		else
			local state = object:getState()
			local v

			if FFlagUseNavigationSelectors then
				v = Selectors.selectNavigationLocked(state)
			else
				v = state.Navigation.lockNavigationActions
			end

			if v then
				return
			end

			object:dispatch(ApplySetNavigationLocked(true))
			callback()
		end
	end
end
