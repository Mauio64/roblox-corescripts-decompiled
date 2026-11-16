local Players = game:GetService("Players")

local function sendMediaGalleryMediaChanged(object, p: string, p2, universeId: string?, autoAdvance: boolean?, isYouTubeVideo: boolean?, placeId: string?)
	local localPlayer = Players.LocalPlayer
	object:setRBXEventStream(p, "mediaGalleryMediaChanged", {
		uid = not localPlayer and "" or tostring(localPlayer.UserId),
		placeId = placeId,
		universeId = universeId,
		imageAssetId = p2.imageId,
		videoAssetId = p2.videoId,
		isYouTubeVideo = isYouTubeVideo,
		autoAdvance = autoAdvance
	})
end

return sendMediaGalleryMediaChanged
