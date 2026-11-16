local module = require("@luauforge/bundled/dTh")

return {
	CameraFieldOfViewDeg = 70,
	ViewportHalfWidthUnits = 1.25,
	PeekabooBorderWidthPix = 6,
	AnalyticsTag = "LuaProfilePictureEditor",
	SliderMax = 20,
	YRotMaxDeg = 60,
	ZoomMinScale = 0.5,
	PPEConfigFetchStatusKey = "avatar.ppe.fetchStatus",
	PPEConfigWriteStatusKeys = {
		[module.Closeup] = "avatar.ppe.closeup.writeStatus",
		[module.FullBody] = "avatar.ppe.fullBody.writeStatus"
	},
	FullscreenTweenTimeSeconds = 0.25,
	CircleCutoutAsset = "rbxasset://textures/ui/AvatarExperience/CircleCutoutLargeNoBorder.png"
}
