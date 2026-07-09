local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local Modules = CoreGui.RobloxGui.Modules
local SetFullView = require(Modules.AvatarExperience.Common.Actions.SetFullView)
local _ = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Enums.FullView
local FullViewPageDefaults = require(Modules.AvatarExperience.Common.Constants).FullViewPageDefaults

return Rodux.createReducer(FullViewPageDefaults, {
	[SetFullView.name] = function(p1, p2) -- line: 29
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p1, {
			[p2.avatarScreen] = p2.fullViewStatus
		})
	end
})
