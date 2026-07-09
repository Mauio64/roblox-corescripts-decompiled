local Players = game:GetService("Players")

local function sendMediaGalleryMediaChanged(t1: {[any]: any}, s1: string, t2: {[any]: any}, s2: string?, b1: boolean?, b2: boolean?, s3: string?) -- line: 12
	-- upvalues: Players (copy)
	local LocalPlayer = Players.LocalPlayer

	t1:setRBXEventStream(s1, "mediaGalleryMediaChanged", {
		uid = not LocalPlayer and "" or tostring(LocalPlayer.UserId),
		placeId = s3,
		universeId = s2,
		imageAssetId = t2.imageId,
		videoAssetId = t2.videoId,
		isYouTubeVideo = b2,
		autoAdvance = b1
	})
end

return sendMediaGalleryMediaChanged
