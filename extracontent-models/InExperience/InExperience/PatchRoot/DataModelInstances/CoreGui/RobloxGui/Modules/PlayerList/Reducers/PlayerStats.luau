local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local Actions = script.Parent.Parent.Actions
local AddPlayer = require(Actions.AddPlayer)
local RemovePlayer = require(Actions.RemovePlayer)
local SetPlayerLeaderstat = require(Actions.SetPlayerLeaderstat)

return (Rodux.createReducer({}, {
	[AddPlayer.name] = function(p1, p2) -- line: 13
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p1, {
			[p2.userId] = {}
		})
	end,
	[RemovePlayer.name] = function(p3, p4) -- line: 19
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p3, {
			[p4.userId] = Cryo.None
		})
	end,
	[SetPlayerLeaderstat.name] = function(p5, p6) -- line: 25
		-- upvalues: Cryo (copy)
		if p5[p6.userId] == nil then
			return p5
		end

		return Cryo.Dictionary.join(p5, {
			[p6.userId] = Cryo.Dictionary.join(p5[p6.userId], {
				[p6.leaderstat] = p6.value
			})
		})
	end
}))
