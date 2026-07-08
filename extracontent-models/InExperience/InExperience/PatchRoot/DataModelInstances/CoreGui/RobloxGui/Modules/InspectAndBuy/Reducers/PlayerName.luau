local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local ParentParent = script.Parent.Parent
local SetPlayerName = require(ParentParent.Actions.SetPlayerName)

return Rodux.createReducer("", {
	[SetPlayerName.name] = function(_, p2) -- line: 7
		return p2.playerName
	end
})
