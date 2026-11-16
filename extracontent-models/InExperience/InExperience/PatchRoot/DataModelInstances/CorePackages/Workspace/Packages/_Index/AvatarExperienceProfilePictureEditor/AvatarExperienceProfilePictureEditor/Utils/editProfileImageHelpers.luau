local AvatarExperienceProfilePictureEditor = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor")
local parent = AvatarExperienceProfilePictureEditor.Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagEditProfileFramesEnabled = SharedFlags.FFlagEditProfileFramesEnabled
local Constants = require(AvatarExperienceProfilePictureEditor.Constants)
local Enums = require(AvatarExperienceProfilePictureEditor.Common.Enums)

local function toProfileFrameAssetId(selectedFrameId: string?) -- 2 equivalent calls inferred from this helper
	if selectedFrameId == nil then
		return nil
	end

	if selectedFrameId == Constants.ProfileFrameNoneId then
		return 0
	end

	return (tonumber(selectedFrameId))
end

local EditProfileImageHelpers = {}

function EditProfileImageHelpers.buildSavePayloadForActiveView(p: string, data)
	if p == "frames" then
		return {
			emoteAssetId = data.savedEmoteAssetId,
			profileFrameAssetId = toProfileFrameAssetId(data.selectedFrameId) -- inferred equivalent call
		}
	else
		if p == "emotes" then
			return { emoteAssetId = data.selectedEmoteId, profileFrameAssetId = nil }
		end

		local v = { emoteAssetId = data.selectedEmoteId, profileFrameAssetId = 0 }
		local profileFrameAssetId

		if data.showFrames then
			profileFrameAssetId = toProfileFrameAssetId(data.selectedFrameId) -- inferred equivalent call
		end

		v.profileFrameAssetId = profileFrameAssetId
		return v
	end
end

function EditProfileImageHelpers.getInitialActiveView(p): string
	if FFlagEditProfileFramesEnabled and p == Enums.EditProfileImageMode.FramesOnly then
		return "frames"
	end

	if FFlagEditProfileFramesEnabled then
		return "combined"
	end

	return "emotes"
end

function EditProfileImageHelpers.hasOnTitleBack(p: string, p2): boolean
	if p == "combined" or p == "frames" and p2 == Enums.EditProfileImageMode.FramesOnly then
		return false
	end

	return if FFlagEditProfileFramesEnabled then true else false
end

function EditProfileImageHelpers.resolvePostSaveAction(data): string
	if data.framesFeatureEnabled and data.hasOnTitleBack then
		return "returnToCombined"
	end

	if data.hasOnSaveSuccess then
		return "exitWithSuccessCallback"
	end

	return "exit"
end

function EditProfileImageHelpers.resolveFooterCta(data): string
	if data.isFramesOnlyEntry or not data.isRecommendedEmoteSelected then
		if data.isEquipRestrictedFrameSelected then
			return "subscribePlus"
		end

		return "save"
	end

	return "purchaseEmote"
end

return EditProfileImageHelpers
