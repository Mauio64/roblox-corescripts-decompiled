local NavigationRodux = script:FindFirstAncestor("NavigationRodux")
local NavigationRoduxParent = NavigationRodux.Parent
local FFlagSignalsNavP2NavigationPrimitives = require(NavigationRoduxParent.SharedFlags).FFlagSignalsNavP2NavigationPrimitives
local v4 = if not FFlagSignalsNavP2NavigationPrimitives then nil else require(NavigationRoduxParent.RobloxAppNavigation).NavigationCommands
local SetNavigationLocked = require(NavigationRodux.Thunks.SetNavigationLocked)
local Cryo = require(NavigationRoduxParent.Cryo)
local ArgCheck = require(NavigationRoduxParent.ArgCheck)
local RoactNavigation = require(NavigationRoduxParent.RoactNavigation)
local RNAdapterThunk = require(NavigationRodux.Thunks.RNAdapterThunk)

return function(p1, p2) -- line: 18
	-- upvalues: ArgCheck (copy), FFlagSignalsNavP2NavigationPrimitives (copy), v4 (copy), RNAdapterThunk (copy), SetNavigationLocked (copy), RoactNavigation (copy), Cryo (copy)
	ArgCheck.isType(p1, "table", "page")
	ArgCheck.isTypeOrNil(p2, "boolean", "bypassNavigationLock")

	if FFlagSignalsNavP2NavigationPrimitives then
		return function() -- line: 23
			-- upvalues: v4 (copy), p1 (copy), p2 (copy)
			v4.sideways(v4.fromLegacyPage(p1), p2)
		end
	end

	return RNAdapterThunk.new("NavigateSideways", function(p3, p4) -- line: 28
		-- upvalues: p2 (copy), SetNavigationLocked (copy), RoactNavigation (copy), p1 (copy), Cryo (copy)
		if p3:getState().Navigation.lockNavigationActions and not p2 then
			return
		end

		p3:dispatch(SetNavigationLocked(true))
		p4(RoactNavigation.Actions.navigate({
			routeName = p1.name,
			key = p1.key,
			params = Cryo.Dictionary.join(p1, {
				name = Cryo.None,
				rnKey = Cryo.None
			})
		}))
	end)
end
