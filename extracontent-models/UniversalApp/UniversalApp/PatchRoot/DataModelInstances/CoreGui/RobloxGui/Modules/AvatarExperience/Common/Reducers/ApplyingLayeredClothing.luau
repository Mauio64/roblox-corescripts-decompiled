local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local StartedApplyingLayeredClothing = require(Modules.AvatarExperience.Common.Actions.StartedApplyingLayeredClothing)
local FinishedApplyingLayeredClothing = require(Modules.AvatarExperience.Common.Actions.FinishedApplyingLayeredClothing)

return Rodux.createReducer(false, {
	[StartedApplyingLayeredClothing.name] = function(_, _) -- line: 11
		return true
	end,
	[FinishedApplyingLayeredClothing.name] = function(_, _) -- line: 15
		return false
	end
})
