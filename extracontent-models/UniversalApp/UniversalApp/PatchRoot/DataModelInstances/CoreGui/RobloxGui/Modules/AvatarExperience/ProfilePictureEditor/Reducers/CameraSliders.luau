local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local SetCameraSliderZoom = require(Modules.AvatarExperience.ProfilePictureEditor.Actions.SetCameraSliderZoom)
local SetCameraSliderRotate = require(Modules.AvatarExperience.ProfilePictureEditor.Actions.SetCameraSliderRotate)
local t1 = {
	zoomSliderValue = 0,
	rotateSliderValue = 0
}

return Rodux.createReducer(t1, {
	[SetCameraSliderZoom.name] = function(t2: {[any]: any}, p1) -- line: 29
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(t2, {
			zoomSliderValue = p1.zoomSliderValue
		})
	end,
	[SetCameraSliderRotate.name] = function(t3: {[any]: any}, p2) -- line: 34
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(t3, {
			rotateSliderValue = p2.rotateSliderValue
		})
	end
})
