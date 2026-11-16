local fFlagEditProfileFramesEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/SharedFlags").FFlagEditProfileFramesEnabled
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Constants")
local Enums = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Common/Enums")

local function toProfileFrameAssetId(p2)
	if p2 == nil then
		return nil
	end

	if p2 == Constants.ProfileFrameNoneId then
		return 0
	end

	return (tonumber(p2))
end

return {
	buildSavePayloadForActiveView = function(p2, data)
		if p2 == "frames" then
			local v5 = {
				emoteAssetId = data.savedEmoteAssetId,
				profileFrameAssetId = 0
			}
			local selectedFrameId = data.selectedFrameId
			local v6 = if selectedFrameId ~= nil then selectedFrameId == Constants.ProfileFrameNoneId and 0 or tonumber(selectedFrameId) else nil

			v5.profileFrameAssetId = v6
			return v5
		else
			if p2 == "emotes" then
				return {
					emoteAssetId = data.selectedEmoteId,
					profileFrameAssetId = nil
				}
			end

			local v5 = { emoteAssetId = data.selectedEmoteId, profileFrameAssetId = 0 }
			local v6

			if data.showFrames then
				local selectedFrameId = data.selectedFrameId

				if selectedFrameId ~= nil then
					v6 = selectedFrameId == Constants.ProfileFrameNoneId and 0 or tonumber(selectedFrameId)
				end
			end

			v5.profileFrameAssetId = v6
			return v5
		end
	end,
	getInitialActiveView = function(p2): string
		if fFlagEditProfileFramesEnabled and p2 == Enums.EditProfileImageMode.FramesOnly then
			return "frames"
		end

		if fFlagEditProfileFramesEnabled then
			return "combined"
		end

		return "emotes"
	end,
	hasOnTitleBack = function(p2, p3): boolean
		if p2 == "combined" or p2 == "frames" and p3 == Enums.EditProfileImageMode.FramesOnly then
			return false
		end

		if fFlagEditProfileFramesEnabled then
			return true
		end

		return false
	end,
	resolvePostSaveAction = function(data): string
		if data.framesFeatureEnabled and data.hasOnTitleBack then
			return "returnToCombined"
		end

		if data.hasOnSaveSuccess then
			return "exitWithSuccessCallback"
		end

		return "exit"
	end,
	resolveFooterCta = function(data): string
		if data.isFramesOnlyEntry or not data.isRecommendedEmoteSelected then
			if data.isEquipRestrictedFrameSelected then
				return "subscribePlus"
			end

			return "save"
		end

		return "purchaseEmote"
	end
}
