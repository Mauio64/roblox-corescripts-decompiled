local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local Actions = script.Parent.Parent.Actions
local AddPlayerToTeam = require(Actions.AddPlayerToTeam)
local RemovePlayerFromTeam = require(Actions.RemovePlayerFromTeam)
local RemovePlayer = require(Actions.RemovePlayer)

return (Rodux.createReducer({}, {
	[AddPlayerToTeam.name] = function(p1, p2) -- line: 12
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p1, {
			[p2.player.UserId] = p2.team
		})
	end,
	[RemovePlayerFromTeam.name] = function(p3, p4) -- line: 18
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p3, {
			[p4.player.UserId] = Cryo.None
		})
	end,
	[RemovePlayer.name] = function(p5, p6) -- line: 24
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p5, {
			[p6.player.UserId] = Cryo.None
		})
	end
}))
