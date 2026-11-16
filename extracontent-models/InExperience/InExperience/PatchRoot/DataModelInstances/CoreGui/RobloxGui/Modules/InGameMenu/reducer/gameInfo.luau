local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Cryo = InGameMenuDependencies.Cryo
local Rodux = InGameMenuDependencies.Rodux

local parent = script.Parent.Parent

local SetGameNameAndDescription = require(parent.Actions.SetGameNameAndDescription)

return Rodux.createReducer({ name = "Game", description = "" }, {
	[SetGameNameAndDescription.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { name = p2.gameName, description = p2.gameDescription })
	end
})
