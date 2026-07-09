local SquadsCore = script:FindFirstAncestor("SquadsCore")
local SquadsCoreParent = SquadsCore.Parent
local SetSquadPrompt = require(SquadsCore.Actions.SetSquadPrompt)
local CloseSquadPrompt = require(SquadsCore.Actions.CloseSquadPrompt)
local Cryo = require(SquadsCoreParent.Cryo)

return require(SquadsCoreParent.Rodux).createReducer({
	arguments = {}
}, {
	[SetSquadPrompt.name] = function(p1, p2) -- line: 13
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p1, {
			arguments = p2.arguments or {}
		})
	end,
	[CloseSquadPrompt.name] = function(_, _) -- line: 18
		return {
			arguments = {}
		}
	end
})
