local fFlagSignalsNavP2NavigationPrimitives = require("@game/CorePackages/Workspace/Packages/_Workspace/NavigationRodux/SharedFlags").FFlagSignalsNavP2NavigationPrimitives
local navigationCommands

if fFlagSignalsNavP2NavigationPrimitives then
	navigationCommands = require("@game/CorePackages/Workspace/Packages/_Workspace/NavigationRodux/RobloxAppNavigation").NavigationCommands
else
	navigationCommands = nil
end

local SetNavigationLocked = require("@game/CorePackages/Workspace/Packages/_Index/NavigationRodux/NavigationRodux/Thunks/SetNavigationLocked")
local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/NavigationRodux/ArgCheck")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/NavigationRodux/Cryo")
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/NavigationRodux/RoactNavigation")
local RNAdapterThunk = require("@game/CorePackages/Workspace/Packages/_Index/NavigationRodux/NavigationRodux/Thunks/RNAdapterThunk")

return function(list, p2)
	ArgCheck.isType(list, "table", "route")
	ArgCheck.isTypeOrNil(p2, "boolean", "bypassNavigationLock")

	if fFlagSignalsNavP2NavigationPrimitives then
		return function()
			navigationCommands.to(navigationCommands.fromLegacyPage(list[#list]), p2)
		end
	end

	return RNAdapterThunk.new("NavigateToRoute", function(object, callback)
		if object:getState().Navigation.lockNavigationActions and not p2 then
			return
		end

		object:dispatch(SetNavigationLocked(true))

		local item = list[#list]
		callback(RoactNavigation.Actions.navigate({
			routeName = item.name,
			params = Cryo.Dictionary.join(item, {
				name = Cryo.None,
				rnKey = Cryo.None
			})
		}))
	end)
end
