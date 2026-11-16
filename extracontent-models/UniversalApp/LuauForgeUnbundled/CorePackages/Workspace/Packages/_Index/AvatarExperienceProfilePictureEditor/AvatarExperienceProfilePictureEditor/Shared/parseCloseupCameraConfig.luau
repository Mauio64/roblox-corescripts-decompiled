local Constants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Constants")

local function parseCloseupCameraConfig(p2)
	local v5 = Constants.DefaultDistanceScale
	local v6 = Constants.DefaultYRotDeg
	local v7 = Constants.DefaultFieldOfViewDeg
	local emoteAssetId = nil

	local avatarThumbnailCustomizations = p2 and p2.avatarThumbnailCustomizations

	if avatarThumbnailCustomizations then
		for k, avatarThumbnailCustomization in avatarThumbnailCustomizations do
			if avatarThumbnailCustomization.thumbnailType == Constants.CloseupThumbnailTypeApi then
				if
					avatarThumbnailCustomization.emoteAssetId
					and avatarThumbnailCustomization.emoteAssetId ~= 0
				then
					emoteAssetId = tostring(avatarThumbnailCustomization.emoteAssetId)
				end

				local camera = avatarThumbnailCustomization.camera

				if not camera then
					break
				end

				local distanceScale = camera.distanceScale

				if typeof(distanceScale) == "number" and distanceScale ~= -1 then
					v5 = distanceScale
				end

				if typeof(camera.yRotDeg) == "number" then
					v6 = camera.yRotDeg
				end

				if typeof(camera.fieldOfViewDeg) == "number" and camera.fieldOfViewDeg > 0 then
					v7 = camera.fieldOfViewDeg
				end

				break
			end
		end
	end

	return {
		distanceScale = v5,
		yRotDeg = v6,
		fieldOfViewDeg = v7,
		emoteAssetId = emoteAssetId
	}
end

return parseCloseupCameraConfig
