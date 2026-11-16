local Constants = require(script.Parent.Parent.Constants)

local function parseCloseupCameraConfig(p)
	local distanceScale2 = Constants.DefaultDistanceScale
	local yRotDeg = Constants.DefaultYRotDeg
	local fieldOfViewDeg = Constants.DefaultFieldOfViewDeg
	local emoteAssetId = nil

	local avatarThumbnailCustomizations = p and p.avatarThumbnailCustomizations

	if avatarThumbnailCustomizations then
		for _, avatarThumbnailCustomization in avatarThumbnailCustomizations do
			if avatarThumbnailCustomization.thumbnailType == Constants.CloseupThumbnailTypeApi then
				if avatarThumbnailCustomization.emoteAssetId and avatarThumbnailCustomization.emoteAssetId ~= 0 then
					emoteAssetId = tostring(avatarThumbnailCustomization.emoteAssetId)
				end

				local camera = avatarThumbnailCustomization.camera

				if not camera then
					break
				end

				local distanceScale = camera.distanceScale

				if typeof(distanceScale) == "number" and distanceScale ~= -1 then
					distanceScale2 = distanceScale
				end

				if typeof(camera.yRotDeg) == "number" then
					yRotDeg = camera.yRotDeg
				end

				if typeof(camera.fieldOfViewDeg) == "number" and camera.fieldOfViewDeg > 0 then
					fieldOfViewDeg = camera.fieldOfViewDeg
				end

				break
			end
		end
	end

	return {
		distanceScale = distanceScale2,
		yRotDeg = yRotDeg,
		fieldOfViewDeg = fieldOfViewDeg,
		emoteAssetId = emoteAssetId
	}
end

return parseCloseupCameraConfig
