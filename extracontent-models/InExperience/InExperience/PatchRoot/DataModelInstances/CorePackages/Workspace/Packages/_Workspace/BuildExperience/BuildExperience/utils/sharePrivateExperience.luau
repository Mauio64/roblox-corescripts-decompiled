local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local default = require(BuildExperienceParent.ExternalContentSharingProtocol).ExternalContentSharingProtocol.default
local UniversalShareSheet = require(BuildExperienceParent.ShareSheet).UniversalShareSheet
local SharedFlags = require(BuildExperienceParent.SharedFlags)
local createPrivateShareLink = require(BuildExperience.utils.createPrivateShareLink)
local FFlagEnableShareSheet = SharedFlags.FFlagEnableShareSheet
local isSubjectToDesktopPolicies = SharedFlags.isSubjectToDesktopPolicies

local function sharePrivateExperience(n1: number) -- line: 34
	-- upvalues: createPrivateShareLink (copy), FFlagEnableShareSheet (copy), UniversalShareSheet (copy), isSubjectToDesktopPolicies (copy), default (copy)
	return createPrivateShareLink(n1):andThen(function(s1: string?) -- line: 35
		-- upvalues: FFlagEnableShareSheet (copy), UniversalShareSheet (copy), isSubjectToDesktopPolicies (copy), default (copy)
		if s1 == nil then
			error("sharePrivateExperience: no share link returned")
		end

		if FFlagEnableShareSheet then
			UniversalShareSheet.show({
				context = "BuildExperiencePrivateInvitesShareLink",
				url = s1
			})

			return nil
		end

		if isSubjectToDesktopPolicies() then
			default:setClipboardText({
				context = "BuildExperiencePrivateInvitesShareLink",
				text = s1
			})

			return {
				copiedToClipboard = true,
				url = s1
			}
		end

		default:shareUrl({
			context = "BuildExperiencePrivateInvitesShareLink",
			url = s1
		})

		return {
			copiedToClipboard = false,
			url = s1
		}
	end)
end

return sharePrivateExperience
