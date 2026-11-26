local parseCloseupCameraConfig = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Shared/parseCloseupCameraConfig")
local parseProfileFrameAssetId = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Shared/parseProfileFrameAssetId")

local function parseProfileFrameAssetIdFromV4(p2)
	if p2 == nil then
		return nil
	end

	local frameAsset = p2.frameAsset or p2.profileFrameAsset or p2

	if typeof(frameAsset) ~= "table" then
		return nil
	end

	local id = frameAsset.id or frameAsset.assetId or frameAsset.FrameAssetId

	if typeof(id) == "number" and id ~= 0 then
		return (tostring(id))
	end

	return parseProfileFrameAssetId({ FrameAssetId = id })
end

return {
	parseProfileFrameAssetIdFromV4 = parseProfileFrameAssetIdFromV4,
	parseUserAvatarConfigurationsV4 = function(p2)
		local avatarConfigurations = if typeof(p2) == "table" then p2.avatarConfigurations else nil
		local v5 = if avatarConfigurations then avatarConfigurations.thumbnailCustomizations else nil

		local userAvatarConfigurationsV4 = {
			closeupCameraConfig = parseCloseupCameraConfig({ avatarThumbnailCustomizations = v5 }),
			profileFrameAssetId = 0
		}

		local v7 = if avatarConfigurations then avatarConfigurations.profileFrame else nil
		userAvatarConfigurationsV4.profileFrameAssetId = parseProfileFrameAssetIdFromV4(v7)
		return userAvatarConfigurationsV4
	end
}
