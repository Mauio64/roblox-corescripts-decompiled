local Players = game:GetService("Players")

local function sendMediaGalleryFullscreenEvent(t1: {[any]: any}, s1: string, s2: string, s3: string?, s4: string?, n1: number?, b1: boolean?) -- line: 7
	-- upvalues: Players (copy)
	local LocalPlayer = Players.LocalPlayer

	t1:setRBXEventStream(s1, s2, {
		uid = not LocalPlayer and "" or tostring(LocalPlayer.UserId),
		placeId = s3,
		universeId = s4,
		selectedIndex = n1,
		isVideo = b1
	})
end

return sendMediaGalleryFullscreenEvent
