local SetSquadPrompt = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Actions/SetSquadPrompt")
local CloseSquadPrompt = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Actions/CloseSquadPrompt")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/Cryo")
return require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/Rodux").createReducer({ arguments = {} }, {
	[SetSquadPrompt.name] = function(p2, p3)
		return Cryo.Dictionary.join(p2, {
			arguments = p3.arguments or {}
		})
	end,
	[CloseSquadPrompt.name] = function(p2, p3)
		return { arguments = {} }
	end
})
