local Players = game:GetService("Players")

local function sendMediaGalleryMediaChanged(object, p2, p3, p4, p5, p6, p7)
	local localPlayer = Players.LocalPlayer
	object:setRBXEventStream(p2, "mediaGalleryMediaChanged", {
		uid = not localPlayer and "" or tostring(localPlayer.UserId),
		placeId = p7,
		universeId = p4,
		imageAssetId = p3.imageId,
		videoAssetId = p3.videoId,
		isYouTubeVideo = p6,
		autoAdvance = p5
	})
end

return sendMediaGalleryMediaChanged
