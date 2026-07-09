local NavigationRodux = script:FindFirstAncestor("NavigationRodux")
local NavigationRoduxParent = NavigationRodux.Parent
local FFlagSignalsNavP2NavigationPrimitives = require(NavigationRoduxParent.SharedFlags).FFlagSignalsNavP2NavigationPrimitives
local v4 = if not FFlagSignalsNavP2NavigationPrimitives then nil else require(NavigationRoduxParent.RobloxAppNavigation).NavigationCommands
local SetNavigationLocked = require(NavigationRodux.Thunks.SetNavigationLocked)
local ArgCheck = require(NavigationRoduxParent.ArgCheck)
local RoactNavigation = require(NavigationRoduxParent.RoactNavigation)
local RNAdapterThunk = require(NavigationRodux.Thunks.RNAdapterThunk)

return function(b1: boolean?) -- line: 17
	-- upvalues: ArgCheck (copy), FFlagSignalsNavP2NavigationPrimitives (copy), v4 (copy), RNAdapterThunk (copy), SetNavigationLocked (copy), RoactNavigation (copy)
	ArgCheck.isTypeOrNil(b1, "boolean", "bypassNavigationLock")

	if FFlagSignalsNavP2NavigationPrimitives then
		return function(_) -- line: 21
			-- upvalues: v4 (copy), b1 (copy)
			v4.back(b1)
		end
	end

	return RNAdapterThunk.new("NavigateBack", function(p2, p3) -- line: 26
		-- upvalues: b1 (copy), SetNavigationLocked (copy), RoactNavigation (copy)
		if p2:getState().Navigation.lockNavigationActions and not b1 then
			return
		end

		p2:dispatch(SetNavigationLocked(true))
		p3(RoactNavigation.Actions.back())
	end)
end
