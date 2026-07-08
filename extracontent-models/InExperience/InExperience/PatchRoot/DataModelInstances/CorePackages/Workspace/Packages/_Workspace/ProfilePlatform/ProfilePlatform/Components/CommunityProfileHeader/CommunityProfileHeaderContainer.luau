local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local UserLib = require(ProfilePlatformParent.UserLib)
local Constants = UserLib.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local VerifiedBadges = require(ProfilePlatformParent.VerifiedBadges)
local Enums = require(ProfilePlatform.Common.Enums)
local getDeepValue = require(ProfilePlatform.Utils.getDeepValue)
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local FFlagProfilePlatformUpdateUXForNonSocialCommunities = require(ProfilePlatform.Flags.FFlagProfilePlatformUpdateUXForNonSocialCommunities)
local FFlagEnablePressingCommunityOwnerInPeekView = require(ProfilePlatform.Flags.FFlagEnablePressingCommunityOwnerInPeekView)
local CommunityProfileHeader = require(ProfilePlatform.Components.CommunityProfileHeader.CommunityProfileHeader)

local function CommunityProfileHeaderContainer(t1: {[any]: any}) -- line: 38
	-- upvalues: useProfileWrapperContext (copy), useProfileJsonComponent (copy), Enums (copy), VerifiedBadges (copy), getDeepValue (copy), getRbxthumbWithTypeSizeAndOptions (copy), Constants (copy), FFlagEnablePressingCommunityOwnerInPeekView (copy), React (copy), CommunityProfileHeader (copy), FFlagProfilePlatformUpdateUXForNonSocialCommunities (copy)
	local profileId = useProfileWrapperContext().profileId
	local v18 = useProfileJsonComponent(Enums.Components.CommunityProfileHeader)
	local v19 = if not v18.isVerified then v18.name else `{ v18.name }{ VerifiedBadges.emoji.verified }`
	local v20 = if not v18.ownerIsVerified then v18.ownerName else `{ v18.ownerName }{ VerifiedBadges.emoji.verified }`
	local v21 = getDeepValue(v18, "counts.membersCount") or 0
	local v22 = getRbxthumbWithTypeSizeAndOptions(profileId, Constants.RbxthumbTypes.GroupIcon, 150)
	local v23 = if not FFlagEnablePressingCommunityOwnerInPeekView then nil else v18.ownerUserId

	return React.createElement(CommunityProfileHeader, {
		layoutOrder = t1.layoutOrder,
		name = v19,
		ownerName = v20,
		membersCount = v21,
		hasSocialModules = if not FFlagProfilePlatformUpdateUXForNonSocialCommunities then nil else v18.hasSocialModules,
		thumbnail = v22,
		ownerUserId = if not FFlagEnablePressingCommunityOwnerInPeekView then nil else v23
	})
end

return CommunityProfileHeaderContainer
