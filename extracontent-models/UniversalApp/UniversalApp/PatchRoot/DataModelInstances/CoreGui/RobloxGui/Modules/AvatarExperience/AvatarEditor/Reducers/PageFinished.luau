local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local SetPageFinished = require(Modules.AvatarExperience.AvatarEditor.Actions.SetPageFinished)

return Rodux.createReducer({}, {
	[SetPageFinished.name] = function(p1, p2) -- line: 13
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p1, {
			[p2.assetTypeId] = p2.isFinished
		})
	end
})
