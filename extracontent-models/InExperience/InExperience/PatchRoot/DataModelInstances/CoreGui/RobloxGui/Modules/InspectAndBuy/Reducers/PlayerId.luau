local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local ParentParent = script.Parent.Parent
local SetPlayerId = require(ParentParent.Actions.SetPlayerId)

return Rodux.createReducer("", {
	[SetPlayerId.name] = function(_, p2) -- line: 7
		return p2.playerId
	end
})
