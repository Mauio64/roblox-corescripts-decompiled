local NavigationRodux = script:FindFirstAncestor("NavigationRodux")
local NavigationRoduxParent = NavigationRodux.Parent
local FFlagSignalsNavP2NavigationPrimitives = require(NavigationRoduxParent.SharedFlags).FFlagSignalsNavP2NavigationPrimitives
local v4 = if not FFlagSignalsNavP2NavigationPrimitives then nil else require(NavigationRoduxParent.RobloxAppNavigation).NavigationCommands
local Cryo = require(NavigationRoduxParent.Cryo)
local ArgCheck = require(NavigationRoduxParent.ArgCheck)
local RoactNavigation = require(NavigationRoduxParent.RoactNavigation)
local SetNavigationLocked = require(NavigationRodux.Thunks.SetNavigationLocked)
local RNAdapterThunk = require(NavigationRodux.Thunks.RNAdapterThunk)

return function(p1, b1: boolean?) -- line: 27
	-- upvalues: ArgCheck (copy), FFlagSignalsNavP2NavigationPrimitives (copy), v4 (copy), RNAdapterThunk (copy), SetNavigationLocked (copy), RoactNavigation (copy), Cryo (copy)
	ArgCheck.isType(p1, "table", "page")
	ArgCheck.isTypeOrNil(b1, "boolean", "bypassNavigationLock")

	if FFlagSignalsNavP2NavigationPrimitives then
		return function() -- line: 32
			-- upvalues: v4 (copy), p1 (copy), b1 (copy)
			v4.fromWebView(v4.fromLegacyPage(p1), b1)
		end
	end

	return RNAdapterThunk.new("NavigateFromWebView", function(p2, p3) -- line: 37
		-- upvalues: b1 (copy), SetNavigationLocked (copy), RoactNavigation (copy), p1 (copy), Cryo (copy)
		if p2:getState().Navigation.lockNavigationActions and not b1 then
			return
		end

		p2:dispatch(SetNavigationLocked(true))
		p3(RoactNavigation.StackActions.replace({
			routeName = p1.name,
			key = p1.key,
			params = Cryo.Dictionary.join(p1, {
				name = Cryo.None,
				rnKey = Cryo.None
			})
		}))
	end)
end
