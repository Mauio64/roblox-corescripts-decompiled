local fFlagSignalsNavP2NavigationPrimitives = require("@game/CorePackages/Workspace/Packages/_Workspace/NavigationRodux/SharedFlags").FFlagSignalsNavP2NavigationPrimitives
local navigationCommands

if fFlagSignalsNavP2NavigationPrimitives then
	navigationCommands = require("@game/CorePackages/Workspace/Packages/_Workspace/NavigationRodux/RobloxAppNavigation").NavigationCommands
else
	navigationCommands = nil
end

local SetNavigationLocked = require("@game/CorePackages/Workspace/Packages/_Index/NavigationRodux/NavigationRodux/Thunks/SetNavigationLocked")
local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/NavigationRodux/ArgCheck")

local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/NavigationRodux/RoactNavigation")
local RNAdapterThunk = require("@game/CorePackages/Workspace/Packages/_Index/NavigationRodux/NavigationRodux/Thunks/RNAdapterThunk")

return function(p2)
	ArgCheck.isTypeOrNil(p2, "boolean", "bypassNavigationLock")

	if fFlagSignalsNavP2NavigationPrimitives then
		return function(p3)
			navigationCommands.back(p2)
		end
	end

	return RNAdapterThunk.new("NavigateBack", function(object, callback)
		if object:getState().Navigation.lockNavigationActions and not p2 then
			return
		end

		object:dispatch(SetNavigationLocked(true))
		callback(RoactNavigation.Actions.back())
	end)
end
