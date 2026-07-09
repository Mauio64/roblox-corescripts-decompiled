local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local scriptParent = script.Parent
local ProfilePictureParams = require(scriptParent.ProfilePictureParams)
local PeekabooLayoutDetails = require(scriptParent.PeekabooLayoutDetails)
local CameraSliders = require(scriptParent.CameraSliders)
local FinalPageViewMode = require(scriptParent.FinalPageViewMode)

return Rodux.combineReducers({
	ProfilePictureParams = ProfilePictureParams,
	PeekabooLayoutDetails = PeekabooLayoutDetails,
	CameraSliders = CameraSliders,
	FinalPageViewMode = FinalPageViewMode
})
