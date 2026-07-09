local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local SetRemoteUprankedItems = require(Modules.AvatarExperience.AvatarEditor.Actions.SetRemoteUprankedItems)

require(Modules.AvatarExperience.Common.Types)

return Rodux.createReducer({}, {
	[SetRemoteUprankedItems.name] = function(_, p2) -- line: 12
		-- upvalues: ArgCheck (copy)
		ArgCheck.isType(p2.uprankedItems, "table", "items data must be a table.")

		return p2.uprankedItems
	end
})
