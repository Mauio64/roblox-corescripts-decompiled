local Constants = require(script.Parent.Parent.Constants)

local function buildApplyConfig(data)
	local emoteAssetId = data.emoteAssetId and tonumber(data.emoteAssetId) or 0

	local applyConfig = {
		ThumbnailCustomizations = {
			{
				ThumbnailType = Enum.AvatarThumbnailCustomizationType.Closeup.Value,
				EmoteAssetId = emoteAssetId,
				Camera = {
					FieldOfViewDeg = data.fieldOfViewDeg,
					YRotDeg = data.cameraYRotDeg,
					DistanceScale = data.cameraDistanceScale
				}
			},
			{
				ThumbnailType = Enum.AvatarThumbnailCustomizationType.FullBody.Value,
				EmoteAssetId = emoteAssetId,
				Camera = {
					FieldOfViewDeg = data.fieldOfViewDeg,
					YRotDeg = data.cameraYRotDeg,
					DistanceScale = Constants.FullBodyDistanceScale
				}
			}
		}
	}

	if data.profileFrameAssetId ~= nil then
		applyConfig.FrameAssetId = data.profileFrameAssetId
	end

	return applyConfig
end

local function applyProfileConfiguration(avatarEditorService, p): boolean
	local v = avatarEditorService:NoPromptApplyProfileConfiguration(p)

	while not v do
		avatarEditorService.PromptApplyProfileConfigurationCompleted:Wait()
		v = avatarEditorService:NoPromptApplyProfileConfiguration(p)
	end

	return avatarEditorService.PromptApplyProfileConfigurationCompleted:Wait() == Enum.AvatarPromptResult.Success
end

return {
	saveCloseupAndFullBody = function(p)
		if applyProfileConfiguration(
			p.avatarEditorService or game:GetService("AvatarEditorService"),
			buildApplyConfig(p)
		) then
			return { ok = true }
		end

		return { ok = false }
	end
}
