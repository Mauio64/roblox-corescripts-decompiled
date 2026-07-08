local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local Actions = script.Parent.Parent.Actions
local AddTeam = require(Actions.AddTeam)
local RemoveTeam = require(Actions.RemoveTeam)
local SetTeamName = require(Actions.SetTeamName)

return (Rodux.createReducer({}, {
	[AddTeam.name] = function(p1, p2) -- line: 13
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p1, {
			[p2.team] = p2.team.Name
		})
	end,
	[RemoveTeam.name] = function(p3, p4) -- line: 19
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p3, {
			[p4.team] = Cryo.None
		})
	end,
	[SetTeamName.name] = function(p5, p6) -- line: 25
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p5, {
			[p6.team] = p6.teamName
		})
	end
}))
