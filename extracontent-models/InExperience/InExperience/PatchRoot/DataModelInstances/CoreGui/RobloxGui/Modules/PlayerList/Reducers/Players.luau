local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)

local Actions = script.Parent.Parent.Actions
local AddPlayer = require(Actions.AddPlayer)
local RemovePlayer = require(Actions.RemovePlayer)

return (Rodux.createReducer({}, {
	[AddPlayer.name] = function(p, p2)
		return Cryo.List.join(p, { p2.player })
	end,
	[RemovePlayer.name] = function(p, p2)
		return Cryo.List.filter(p, function(p3): boolean
			return p3 ~= p2.player
		end)
	end
}))
