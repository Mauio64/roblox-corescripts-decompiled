local function buildProfileConfigurationApplyConfig(p2)
	if p2.BackgroundAssetId == nil and p2.FrameAssetId == nil then
		error("ProfileConfiguration apply config must include BackgroundAssetId or FrameAssetId")
	end

	local profileConfigurationApplyConfig = {}

	if p2.BackgroundAssetId ~= nil then
		profileConfigurationApplyConfig.BackgroundAssetId = p2.BackgroundAssetId
	end

	if p2.FrameAssetId ~= nil then
		profileConfigurationApplyConfig.FrameAssetId = p2.FrameAssetId
	end

	return profileConfigurationApplyConfig
end

return buildProfileConfigurationApplyConfig
