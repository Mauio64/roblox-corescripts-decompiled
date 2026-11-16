local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)

local Actions = script.Parent.Parent.Actions
local AddPlayer = require(Actions.AddPlayer)
local RemovePlayer = require(Actions.RemovePlayer)
local SetPlayerLeaderstat = require(Actions.SetPlayerLeaderstat)

return (Rodux.createReducer({}, {
	[AddPlayer.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { [p2.userId] = {} })
	end,
	[RemovePlayer.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { [p2.userId] = Cryo.None })
	end,
	[SetPlayerLeaderstat.name] = function(p, data)
		if p[data.userId] == nil then
			return p
		end

		return Cryo.Dictionary.join(p, {
			[data.userId] = Cryo.Dictionary.join(p[data.userId], { [data.leaderstat] = data.value })
		})
	end
}))
