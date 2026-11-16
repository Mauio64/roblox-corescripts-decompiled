local default = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/ExternalContentSharingProtocol").ExternalContentSharingProtocol.default
local universalShareSheet = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/ShareSheet").UniversalShareSheet
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags")

local createExperienceShareLink = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/createExperienceShareLink")
local FFlagBuildShareSheetFriendsSortAll = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildShareSheetFriendsSortAll")

local fFlagEnableShareSheet = SharedFlags.FFlagEnableShareSheet
local isSubjectToDesktopPolicies = SharedFlags.isSubjectToDesktopPolicies

local function sharePrivateExperience(p2)
	return createExperienceShareLink(p2):andThen(function(p3)
		if p3 == nil then
			error("sharePrivateExperience: no share link returned")
		end

		if fFlagEnableShareSheet then
			local show = universalShareSheet.show

			local v6 = if FFlagBuildShareSheetFriendsSortAll then universalShareSheet.RecipientSource.OneToOneFriends else nil
			show({
				url = p3,
				context = "BuildExperiencePrivateInvitesShareLink",
				recipientSource = v6
			})

			return nil
		elseif isSubjectToDesktopPolicies() then
			default:setClipboardText({
				text = p3,
				context = "BuildExperiencePrivateInvitesShareLink"
			})

			return { url = p3, copiedToClipboard = true }
		else
			default:shareUrl({
				url = p3,
				context = "BuildExperiencePrivateInvitesShareLink"
			})

			return { url = p3, copiedToClipboard = false }
		end
	end)
end

return sharePrivateExperience
