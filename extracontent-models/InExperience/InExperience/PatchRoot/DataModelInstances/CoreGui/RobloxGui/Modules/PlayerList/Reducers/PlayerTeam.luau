local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)

local Actions = script.Parent.Parent.Actions
local AddPlayerToTeam = require(Actions.AddPlayerToTeam)
local RemovePlayerFromTeam = require(Actions.RemovePlayerFromTeam)
local RemovePlayer = require(Actions.RemovePlayer)

return (Rodux.createReducer({}, {
	[AddPlayerToTeam.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { [p2.player.UserId] = p2.team })
	end,
	[RemovePlayerFromTeam.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { [p2.player.UserId] = Cryo.None })
	end,
	[RemovePlayer.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { [p2.player.UserId] = Cryo.None })
	end
}))
