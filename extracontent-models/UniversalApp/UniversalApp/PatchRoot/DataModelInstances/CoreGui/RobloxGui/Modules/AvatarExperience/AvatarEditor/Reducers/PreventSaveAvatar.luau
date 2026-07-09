local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local PreventSaveAvatar = require(Modules.AvatarExperience.AvatarEditor.Actions.PreventSaveAvatar)

return Rodux.createReducer(false, {
	[PreventSaveAvatar.name] = function(_: boolean, p1) -- line: 10
		return p1.preventSaveAvatar
	end
})
