local default = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/ExternalContentSharingProtocol").ExternalContentSharingProtocol.default
local universalShareSheet = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/ShareSheet").UniversalShareSheet
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags")

local createExperienceShareLink = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/createExperienceShareLink")

local fFlagEnableShareSheet = SharedFlags.FFlagEnableShareSheet
local isSubjectToDesktopPolicies = SharedFlags.isSubjectToDesktopPolicies

local function sharePrivateExperience(p2)
	return createExperienceShareLink(p2):andThen(function(p3)
		if p3 == nil then
			error("sharePrivateExperience: no share link returned")
		end

		if fFlagEnableShareSheet then
			universalShareSheet.show({
				url = p3,
				context = "BuildExperiencePrivateInvitesShareLink",
				recipientSource = universalShareSheet.RecipientSource.OneToOneFriends
			})

			return nil
		end

		if isSubjectToDesktopPolicies() then
			default:setClipboardText({
				text = p3,
				context = "BuildExperiencePrivateInvitesShareLink"
			})

			return { url = p3, copiedToClipboard = true }
		end

		default:shareUrl({
			url = p3,
			context = "BuildExperiencePrivateInvitesShareLink"
		})

		return { url = p3, copiedToClipboard = false }
	end)
end

return sharePrivateExperience
