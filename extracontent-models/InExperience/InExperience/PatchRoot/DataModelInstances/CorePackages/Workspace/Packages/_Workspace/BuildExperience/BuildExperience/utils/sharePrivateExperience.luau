local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local ExternalContentSharingProtocol = require(parent.ExternalContentSharingProtocol)
local default = ExternalContentSharingProtocol.ExternalContentSharingProtocol.default
local ShareSheet = require(parent.ShareSheet)
local UniversalShareSheet = ShareSheet.UniversalShareSheet
local SharedFlags = require(parent.SharedFlags)

local createExperienceShareLink = require(BuildExperience.utils.createExperienceShareLink)

local FFlagEnableShareSheet = SharedFlags.FFlagEnableShareSheet
local isSubjectToDesktopPolicies = SharedFlags.isSubjectToDesktopPolicies

local function sharePrivateExperience(p: number)
	return createExperienceShareLink(p):andThen(function(p2: string?)
		if p2 == nil then
			error("sharePrivateExperience: no share link returned")
		end

		if FFlagEnableShareSheet then
			UniversalShareSheet.show({
				url = p2,
				context = "BuildExperiencePrivateInvitesShareLink",
				recipientSource = UniversalShareSheet.RecipientSource.OneToOneFriends
			})

			return nil
		end

		if isSubjectToDesktopPolicies() then
			default:setClipboardText({
				text = p2,
				context = "BuildExperiencePrivateInvitesShareLink"
			})

			return { url = p2, copiedToClipboard = true }
		end

		default:shareUrl({ url = p2, context = "BuildExperiencePrivateInvitesShareLink" })

		return { url = p2, copiedToClipboard = false }
	end)
end

return sharePrivateExperience
