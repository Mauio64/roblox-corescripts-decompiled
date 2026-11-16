local UserInputService = game:GetService("UserInputService")

local module = require("@luauforge/bundled/dCp")
local module2 = require("@luauforge/bundled/fvl")
local module3 = require("@luauforge/deferred/gij")
local module4 = require("@luauforge/deferred/gin")
local module5 = require("@luauforge/bundled/eee")
local module6 = require("@luauforge/bundled/edP")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dCu").NavigationCommands
else
	navigationCommands = nil
end

return function(callback)
	return {
		dispatchCentralOverlay = function(p2, p3)
			return callback(module6(p2, p3))
		end,
		dispatchFetchIAPProducts = function(p2)
			callback(module3.Fetch(p2))
		end,
		closeCentralOverlay = function()
			callback(module2())
		end,
		promptPremium = function(p2, p3)
			local platform = UserInputService:GetPlatform()

			if platform ~= Enum.Platform.Windows and platform ~= Enum.Platform.OSX then
				callback(module4(p2, p3))

				return
			end

			local v5 = { name = module.BuildersClub }

			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(v5))
			else
				callback(module5(v5))
			end
		end
	}
end
