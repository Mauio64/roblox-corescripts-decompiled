local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local SetPlayEmoteInBackground = require(Modules.AvatarExperience.Common.Actions.SetPlayEmoteInBackground)
local t1 = {
	shouldPlayEmoteInBackground = false
}

return (Rodux.createReducer(t1, {
	[SetPlayEmoteInBackground.name] = function(p1, p2) -- line: 20
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p1, {
			shouldPlayEmoteInBackground = p2.shouldPlayEmoteInBackground
		})
	end
}))
