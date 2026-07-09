local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local ReceivedAvatarData = require(Modules.AvatarExperience.AvatarEditor.Actions.ReceivedAvatarData)

return Rodux.createReducer(false, {
	[ReceivedAvatarData.name] = function(_: boolean, _) -- line: 9
		return true
	end
})
