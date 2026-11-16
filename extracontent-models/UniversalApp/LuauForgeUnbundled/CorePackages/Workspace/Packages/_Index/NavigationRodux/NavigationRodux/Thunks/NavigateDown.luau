local fFlagSignalsNavP2NavigationPrimitives = require("@game/CorePackages/Workspace/Packages/_Workspace/NavigationRodux/SharedFlags").FFlagSignalsNavP2NavigationPrimitives
local navigationCommands

if fFlagSignalsNavP2NavigationPrimitives then
	navigationCommands = require("@game/CorePackages/Workspace/Packages/_Workspace/NavigationRodux/RobloxAppNavigation").NavigationCommands
else
	navigationCommands = nil
end

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/NavigationRodux/Cryo")
local SetNavigationLocked = require("@game/CorePackages/Workspace/Packages/_Index/NavigationRodux/NavigationRodux/Thunks/SetNavigationLocked")
local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/NavigationRodux/ArgCheck")

local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/NavigationRodux/RoactNavigation")
local RNAdapterThunk = require("@game/CorePackages/Workspace/Packages/_Index/NavigationRodux/NavigationRodux/Thunks/RNAdapterThunk")

return function(p2, p3)
	ArgCheck.isType(p2, "table", "page")
	ArgCheck.isTypeOrNil(p3, "boolean", "bypassNavigationLock")

	if fFlagSignalsNavP2NavigationPrimitives then
		return function()
			navigationCommands.down(navigationCommands.fromLegacyPage(p2), p3)
		end
	end

	return RNAdapterThunk.new("NavigateDown", function(object, callback)
		if object:getState().Navigation.lockNavigationActions and not p3 then
			return
		end

		object:dispatch(SetNavigationLocked(true))

		callback(RoactNavigation.StackActions.push({
			routeName = p2.name,
			params = Cryo.Dictionary.join(p2, {
				name = Cryo.None,
				rnKey = Cryo.None
			})
		}))
	end)
end
