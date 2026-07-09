local NavigationRodux = script:FindFirstAncestor("NavigationRodux")
local NavigationRoduxParent = NavigationRodux.Parent
local FFlagSignalsNavP2NavigationPrimitives = require(NavigationRoduxParent.SharedFlags).FFlagSignalsNavP2NavigationPrimitives
local v4 = if not FFlagSignalsNavP2NavigationPrimitives then nil else require(NavigationRoduxParent.RobloxAppNavigation).NavigationCommands
local SetNavigationLocked = require(NavigationRodux.Thunks.SetNavigationLocked)
local ArgCheck = require(NavigationRoduxParent.ArgCheck)
local Cryo = require(NavigationRoduxParent.Cryo)
local RoactNavigation = require(NavigationRoduxParent.RoactNavigation)
local RNAdapterThunk = require(NavigationRodux.Thunks.RNAdapterThunk)

return function(p1, p2) -- line: 18
	-- upvalues: ArgCheck (copy), FFlagSignalsNavP2NavigationPrimitives (copy), v4 (copy), RNAdapterThunk (copy), SetNavigationLocked (copy), RoactNavigation (copy), Cryo (copy)
	ArgCheck.isType(p1, "table", "route")
	ArgCheck.isTypeOrNil(p2, "boolean", "bypassNavigationLock")

	if FFlagSignalsNavP2NavigationPrimitives then
		return function() -- line: 23
			-- upvalues: v4 (copy), p1 (copy), p2 (copy)
			v4.to(v4.fromLegacyPage(p1[#p1]), p2)
		end
	end

	return RNAdapterThunk.new("NavigateToRoute", function(p3, p4) -- line: 28
		-- upvalues: p2 (copy), SetNavigationLocked (copy), p1 (copy), RoactNavigation (copy), Cryo (copy)
		if p3:getState().Navigation.lockNavigationActions and not p2 then
			return
		end

		p3:dispatch(SetNavigationLocked(true))

		local v14 = p1[#p1]

		p4(RoactNavigation.Actions.navigate({
			routeName = v14.name,
			params = Cryo.Dictionary.join(v14, {
				name = Cryo.None,
				rnKey = Cryo.None
			})
		}))
	end)
end
