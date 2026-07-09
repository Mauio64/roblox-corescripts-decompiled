local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local SetFinalPageViewMode = require(Modules.AvatarExperience.ProfilePictureEditor.Actions.SetFinalPageViewMode)
local t1 = {
	finalPageViewMode = require(Modules.AvatarExperience.ProfilePictureEditor.PPEThumbnailType).Closeup
}

return Rodux.createReducer(t1, {
	[SetFinalPageViewMode.name] = function(p1, p2) -- line: 24
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p1, {
			finalPageViewMode = p2.finalPageViewMode
		})
	end
})
