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
local ArgCheck = require(parent.ArgCheck)

local Cryo = require(parent.Cryo)
local RoactNavigation = require(parent.RoactNavigation)
local RNAdapterThunk = require(NavigationRodux.Thunks.RNAdapterThunk)

return function(list, p)
	ArgCheck.isType(list, "table", "route")
	ArgCheck.isTypeOrNil(p, "boolean", "bypassNavigationLock")

	if FFlagSignalsNavP2NavigationPrimitives then
		return function()
			navigationCommands.to(navigationCommands.fromLegacyPage(list[#list]), p)
		end
	end

	return RNAdapterThunk.new("NavigateToRoute", function(object, callback)
		if object:getState().Navigation.lockNavigationActions and not p then
			return
		end

		object:dispatch(SetNavigationLocked(true))

		local item = list[#list]
		callback(RoactNavigation.Actions.navigate({
			routeName = item.name,
			params = Cryo.Dictionary.join(item, { name = Cryo.None, rnKey = Cryo.None })
		}))
	end)
end
