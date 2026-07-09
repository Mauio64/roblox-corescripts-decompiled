local Modules = game:GetService("CoreGui").RobloxGui.Modules
local PPEThumbnailType = require(Modules.AvatarExperience.ProfilePictureEditor.PPEThumbnailType)

return {
	CameraFieldOfViewDeg = 70,
	ViewportHalfWidthUnits = 1.25,
	PeekabooBorderWidthPix = 6,
	AnalyticsTag = "LuaProfilePictureEditor",
	SliderMax = 20,
	YRotMaxDeg = 60,
	ZoomMinScale = 0.5,
	PPEConfigFetchStatusKey = "avatar.ppe.fetchStatus",
	FullscreenTweenTimeSeconds = 0.25,
	CircleCutoutAsset = "rbxasset://textures/ui/AvatarExperience/CircleCutoutLargeNoBorder.png",
	PPEConfigWriteStatusKeys = {
		[PPEThumbnailType.Closeup] = "avatar.ppe.closeup.writeStatus",
		[PPEThumbnailType.FullBody] = "avatar.ppe.fullBody.writeStatus"
	}
}
