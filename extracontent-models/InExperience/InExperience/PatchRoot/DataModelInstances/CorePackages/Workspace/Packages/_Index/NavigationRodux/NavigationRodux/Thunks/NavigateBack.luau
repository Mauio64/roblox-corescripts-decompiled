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

local RoactNavigation = require(parent.RoactNavigation)
local RNAdapterThunk = require(NavigationRodux.Thunks.RNAdapterThunk)

return function(flag: boolean?)
	ArgCheck.isTypeOrNil(flag, "boolean", "bypassNavigationLock")

	if FFlagSignalsNavP2NavigationPrimitives then
		return function(_)
			navigationCommands.back(flag)
		end
	end

	return RNAdapterThunk.new("NavigateBack", function(object, callback)
		if object:getState().Navigation.lockNavigationActions and not flag then
			return
		end

		object:dispatch(SetNavigationLocked(true))
		callback(RoactNavigation.Actions.back())
	end)
end
