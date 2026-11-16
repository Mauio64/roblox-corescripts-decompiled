local NavigationRodux = script:FindFirstAncestor("NavigationRodux")
local parent = NavigationRodux.Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP2NavigationPrimitives = SharedFlags.FFlagSignalsNavP2NavigationPrimitives
local navigationCommands

if FFlagSignalsNavP2NavigationPrimitives then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local SetNavigationLocked = require(NavigationRodux.Thunks.SetNavigationLocked)
local Cryo = require(parent.Cryo)
local ArgCheck = require(parent.ArgCheck)

local RoactNavigation = require(parent.RoactNavigation)
local RNAdapterThunk = require(NavigationRodux.Thunks.RNAdapterThunk)

return function(p, p2)
	ArgCheck.isType(p, "table", "page")
	ArgCheck.isTypeOrNil(p2, "boolean", "bypassNavigationLock")

	if FFlagSignalsNavP2NavigationPrimitives then
		return function()
			navigationCommands.sideways(navigationCommands.fromLegacyPage(p), p2)
		end
	end

	return RNAdapterThunk.new("NavigateSideways", function(object, callback)
		if object:getState().Navigation.lockNavigationActions and not p2 then
			return
		end

		object:dispatch(SetNavigationLocked(true))
		callback(RoactNavigation.Actions.navigate({
			routeName = p.name,
			key = p.key,
			params = Cryo.Dictionary.join(p, { name = Cryo.None, rnKey = Cryo.None })
		}))
	end)
end
