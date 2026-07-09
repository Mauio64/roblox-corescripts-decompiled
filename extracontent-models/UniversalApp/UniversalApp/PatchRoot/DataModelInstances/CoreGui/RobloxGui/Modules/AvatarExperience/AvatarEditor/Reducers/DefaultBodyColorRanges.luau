local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)
local ReducerUtils = require(CorePackages.Workspace.Packages.AvatarExperienceRodux).Utils.ReducerUtils
local SetDefaultBodyColorRanges = require(Modules.AvatarExperience.AvatarEditor.Actions.SetDefaultBodyColorRanges)

return (Rodux.createReducer({}, {
	[SetDefaultBodyColorRanges.name] = function(_, p2) -- line: 19
		-- upvalues: ReducerUtils (copy)
		return (ReducerUtils.convertDefaultBodyColorRanges(p2.defaultBodyColorRanges))
	end
}))
