local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Cryo = InGameMenuDependencies.Cryo
local Rodux = InGameMenuDependencies.Rodux
local ParentParent = script.Parent.Parent
local SetGameNameAndDescription = require(ParentParent.Actions.SetGameNameAndDescription)

return Rodux.createReducer({
	name = "Game",
	description = ""
}, {
	[SetGameNameAndDescription.name] = function(p1, p2) -- line: 15
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p1, {
			name = p2.gameName,
			description = p2.gameDescription
		})
	end
})
