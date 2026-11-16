local CorePackages = game:GetService("CorePackages")

local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local module = require("@luauforge/deferred/fou")
local RobloxAppToastsRodux = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppToastsRodux/RobloxAppToastsRodux")
local module3 = require("@luauforge/bundled/dTM")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dCu").NavigationCommands
else
	navigationCommands = nil
end

return function(p2)
	return function(object)
		if not module(module3.getRootNavigation(p2).state) then
			p2.dispatch(RoactNavigation.Actions.back(nil))
		elseif fFlagSignalsNavP3Dispatch then
			navigationCommands.back(false)
		else
			object:dispatch(RobloxAppToastsRodux(false))
		end
	end
end
