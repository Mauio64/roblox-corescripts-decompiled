local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local Actions = script.Parent.Parent.Actions
local AddTeam = require(Actions.AddTeam)
local RemoveTeam = require(Actions.RemoveTeam)

return (Rodux.createReducer({}, {
	[AddTeam.name] = function(p1, p2) -- line: 11
		-- upvalues: Cryo (copy)
		return Cryo.List.join(p1, { p2.team })
	end,
	[RemoveTeam.name] = function(p3, p4) -- line: 15
		-- upvalues: Cryo (copy)
		return Cryo.List.filter(p3, function(p5) -- line: 16
			-- upvalues: p4 (copy)
			return p5 ~= p4.team
		end)
	end
}))
