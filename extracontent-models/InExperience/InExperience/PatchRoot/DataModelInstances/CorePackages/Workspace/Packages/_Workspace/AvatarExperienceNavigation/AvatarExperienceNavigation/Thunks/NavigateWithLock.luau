local Parent = script:FindFirstAncestor("AvatarExperienceNavigation").Parent
local ArgCheck = require(Parent.ArgCheck)
local NavigationRodux = require(Parent.NavigationRodux)
local ApplySetNavigationLocked = NavigationRodux.Actions.ApplySetNavigationLocked
local Selectors = NavigationRodux.Selectors
local SharedFlags = require(Parent.SharedFlags)
local FFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local FFlagSignalsNavP2NavigationPrimitives = SharedFlags.FFlagSignalsNavP2NavigationPrimitives
local v9 = if not FFlagSignalsNavP2NavigationPrimitives then nil else require(Parent.RobloxAppNavigation).AppNavigationRegistry

return function(p1) -- line: 25
	-- upvalues: ArgCheck (copy), FFlagSignalsNavP2NavigationPrimitives (copy), v9 (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), ApplySetNavigationLocked (copy)
	ArgCheck.isType(p1, "function", "navigationCallback")

	return function(p2) -- line: 27
		-- upvalues: FFlagSignalsNavP2NavigationPrimitives (copy), v9 (copy), p1 (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), ApplySetNavigationLocked (copy)
		if FFlagSignalsNavP2NavigationPrimitives then
			if v9.get().getIsNavigating(false) then
				return
			end

			p1()

			return
		end

		local v12 = p2:getState()

		if if not FFlagUseNavigationSelectors then v12.Navigation.lockNavigationActions else Selectors.selectNavigationLocked(v12) then
			return
		end

		p2:dispatch(ApplySetNavigationLocked(true))
		p1()
	end
end
