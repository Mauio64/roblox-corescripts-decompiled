local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local ExternalContentSharingProtocol = require(parent.ExternalContentSharingProtocol)
local default = ExternalContentSharingProtocol.ExternalContentSharingProtocol.default
local ShareSheet = require(parent.ShareSheet)
local UniversalShareSheet = ShareSheet.UniversalShareSheet
local SharedFlags = require(parent.SharedFlags)

local createExperienceShareLink = require(BuildExperience.utils.createExperienceShareLink)
local FFlagBuildShareSheetFriendsSortAll = require(BuildExperience.Flags.FFlagBuildShareSheetFriendsSortAll)

local FFlagEnableShareSheet = SharedFlags.FFlagEnableShareSheet
local isSubjectToDesktopPolicies = SharedFlags.isSubjectToDesktopPolicies

local function sharePrivateExperience(p: number)
	return createExperienceShareLink(p):andThen(function(p2: string?)
		if p2 == nil then
			error("sharePrivateExperience: no share link returned")
		end

		if FFlagEnableShareSheet then
			local show = UniversalShareSheet.show
			local recipientSource

			if FFlagBuildShareSheetFriendsSortAll then
				recipientSource = UniversalShareSheet.RecipientSource.OneToOneFriends
			end

			show({
				url = p2,
				context = "BuildExperiencePrivateInvitesShareLink",
				recipientSource = recipientSource
			})

			return nil
		elseif isSubjectToDesktopPolicies() then
			default:setClipboardText({
				text = p2,
				context = "BuildExperiencePrivateInvitesShareLink"
			})

			return { url = p2, copiedToClipboard = true }
		else
			default:shareUrl({ url = p2, context = "BuildExperiencePrivateInvitesShareLink" })

			return { url = p2, copiedToClipboard = false }
		end
	end)
end

return sharePrivateExperience
