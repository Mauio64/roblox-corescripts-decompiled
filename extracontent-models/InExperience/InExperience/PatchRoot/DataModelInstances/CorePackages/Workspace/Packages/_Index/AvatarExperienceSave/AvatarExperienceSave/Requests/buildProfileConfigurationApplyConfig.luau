local function buildProfileConfigurationApplyConfig(p)
	if p.BackgroundAssetId == nil and p.FrameAssetId == nil then
		error("ProfileConfiguration apply config must include BackgroundAssetId or FrameAssetId")
	end

	local profileConfigurationApplyConfig = {}

	if p.BackgroundAssetId ~= nil then
		profileConfigurationApplyConfig.BackgroundAssetId = p.BackgroundAssetId
	end

	if p.FrameAssetId ~= nil then
		profileConfigurationApplyConfig.FrameAssetId = p.FrameAssetId
	end

	return profileConfigurationApplyConfig
end

return buildProfileConfigurationApplyConfig
