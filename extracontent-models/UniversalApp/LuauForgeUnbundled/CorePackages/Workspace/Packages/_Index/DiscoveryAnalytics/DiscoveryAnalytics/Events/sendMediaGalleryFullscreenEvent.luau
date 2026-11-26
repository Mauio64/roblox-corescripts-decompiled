local Players = game:GetService("Players")

local function sendMediaGalleryFullscreenEvent(object, p2, p3, p4, p5, p6, p7)
	local localPlayer = Players.LocalPlayer
	object:setRBXEventStream(p2, p3, {
		uid = not localPlayer and "" or tostring(localPlayer.UserId),
		placeId = p4,
		universeId = p5,
		selectedIndex = p6,
		isVideo = p7
	})
end

return sendMediaGalleryFullscreenEvent
