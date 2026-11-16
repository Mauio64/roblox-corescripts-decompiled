local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local parent = script.Parent.Parent
local SetPlayerName = require(parent.Actions.SetPlayerName)

return Rodux.createReducer("", {
	[SetPlayerName.name] = function(_, p)
		return p.playerName
	end
})
