local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)

local Actions = script.Parent.Parent.Actions
local AddTeam = require(Actions.AddTeam)
local RemoveTeam = require(Actions.RemoveTeam)
local SetTeamName = require(Actions.SetTeamName)

return (Rodux.createReducer({}, {
	[AddTeam.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { [p2.team] = p2.team.Name })
	end,
	[RemoveTeam.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { [p2.team] = Cryo.None })
	end,
	[SetTeamName.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { [p2.team] = p2.teamName })
	end
}))
