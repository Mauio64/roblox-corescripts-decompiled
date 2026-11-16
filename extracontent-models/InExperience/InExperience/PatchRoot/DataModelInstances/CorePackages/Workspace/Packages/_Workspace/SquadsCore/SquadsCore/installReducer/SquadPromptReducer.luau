local SquadsCore = script:FindFirstAncestor("SquadsCore")
local parent = SquadsCore.Parent

local SetSquadPrompt = require(SquadsCore.Actions.SetSquadPrompt)
local CloseSquadPrompt = require(SquadsCore.Actions.CloseSquadPrompt)

local Cryo = require(parent.Cryo)
local Rodux = require(parent.Rodux)

return Rodux.createReducer({ arguments = {} }, {
	[SetSquadPrompt.name] = function(p, p2)
		return Cryo.Dictionary.join(p, {
			arguments = p2.arguments or {}
		})
	end,
	[CloseSquadPrompt.name] = function(_, _)
		return { arguments = {} }
	end
})
