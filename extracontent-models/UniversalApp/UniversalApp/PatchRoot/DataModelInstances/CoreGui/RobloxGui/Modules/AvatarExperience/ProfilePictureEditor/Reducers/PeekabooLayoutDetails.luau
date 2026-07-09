local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local SetPeekabooLayoutDetails = require(Modules.AvatarExperience.ProfilePictureEditor.Actions.SetPeekabooLayoutDetails)

return Rodux.createReducer({}, {
	[SetPeekabooLayoutDetails.name] = function(p1, p2) -- line: 27
		-- upvalues: Cryo (copy)
		local v8 = p1[p2.screenName] or {}

		return Cryo.Dictionary.join(p1, {
			[p2.screenName] = Cryo.Dictionary.join(v8, {
				screenHeightPix = p2.screenHeightPix,
				topYPix = p2.topYPix,
				viewportSizePix = p2.viewportSizePix
			})
		})
	end
})
