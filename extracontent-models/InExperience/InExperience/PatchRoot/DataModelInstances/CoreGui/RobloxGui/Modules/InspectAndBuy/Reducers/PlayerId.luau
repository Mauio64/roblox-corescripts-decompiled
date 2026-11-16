local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local parent = script.Parent.Parent
local SetPlayerId = require(parent.Actions.SetPlayerId)

return Rodux.createReducer("", {
	[SetPlayerId.name] = function(_, p)
		return p.playerId
	end
})
