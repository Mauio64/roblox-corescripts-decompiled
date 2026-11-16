local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)

local Actions = script.Parent.Parent.Actions
local AddTeam = require(Actions.AddTeam)
local RemoveTeam = require(Actions.RemoveTeam)

return (Rodux.createReducer({}, {
	[AddTeam.name] = function(p, p2)
		return Cryo.List.join(p, { p2.team })
	end,
	[RemoveTeam.name] = function(p, p2)
		return Cryo.List.filter(p, function(p3): boolean
			return p3 ~= p2.team
		end)
	end
}))
