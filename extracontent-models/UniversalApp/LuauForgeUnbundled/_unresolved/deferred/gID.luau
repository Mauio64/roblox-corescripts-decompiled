local CorePackages = game:GetService("CorePackages")

local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RobloxAppToastsRodux = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppToastsRodux/RobloxAppToastsRodux")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dFz").NavigationCommands
else
	navigationCommands = nil
end

local module2 = require("@luauforge/bundled/dFm")
local module3 = require("@luauforge/bundled/dzE")

local RoactNavigation = require(CorePackages.Packages.RoactNavigation)

local module4 = require("@luauforge/deferred/gIE")

local v5 = RoactNavigation.withNavigation(module4)

return (RoactRodux.connect(function(p2, p3)
	return {}
end, function(callback)
	return {
		navigateBack = function()
			if fFlagSignalsNavP3Dispatch then
				return navigationCommands.back(true)
			end

			return callback(RobloxAppToastsRodux(true))
		end,
		onError = function(p2, p3)
			return callback(module2({
				toastMessage = p2,
				toastSubMessage = p3,
				isLocalized = true,
				toastType = module3.NetworkingError
			}))
		end
	}
end)(v5))
