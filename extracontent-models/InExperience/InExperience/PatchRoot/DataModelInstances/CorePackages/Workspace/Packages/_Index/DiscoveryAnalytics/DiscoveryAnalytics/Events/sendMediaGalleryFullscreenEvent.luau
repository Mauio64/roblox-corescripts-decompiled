local Players = game:GetService("Players")

local function sendMediaGalleryFullscreenEvent(object, p: string, p2: string, placeId: string?, universeId: string?, selectedIndex: number?, isVideo: boolean?)
	local localPlayer = Players.LocalPlayer
	object:setRBXEventStream(p, p2, {
		uid = not localPlayer and "" or tostring(localPlayer.UserId),
		placeId = placeId,
		universeId = universeId,
		selectedIndex = selectedIndex,
		isVideo = isVideo
	})
end

return sendMediaGalleryFullscreenEvent
