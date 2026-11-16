local parseCloseupCameraConfig = require(script.Parent.parseCloseupCameraConfig)
local parseProfileFrameAssetId = require(script.Parent.parseProfileFrameAssetId)

local function parseProfileFrameAssetIdFromV4(p)
	if p == nil then
		return nil
	end

	local frameAsset = p.frameAsset or p.profileFrameAsset or p

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
	parseUserAvatarConfigurationsV4 = function(p)
		local avatarConfigurations

		if typeof(p) == "table" then
			avatarConfigurations = p.avatarConfigurations
		end

		local avatarThumbnailCustomizations

		if avatarConfigurations then
			avatarThumbnailCustomizations = avatarConfigurations.thumbnailCustomizations
		end

		local userAvatarConfigurationsV4 = {
			closeupCameraConfig = parseCloseupCameraConfig({
				avatarThumbnailCustomizations = avatarThumbnailCustomizations
			}),
			profileFrameAssetId = 0
		}
		local v

		if avatarConfigurations then
			v = avatarConfigurations.profileFrame
		end

		userAvatarConfigurationsV4.profileFrameAssetId = parseProfileFrameAssetIdFromV4(v)
		return userAvatarConfigurationsV4
	end
}
