local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)
local UserLib = require(parent.UserLib)
local Constants = UserLib.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local VerifiedBadges = require(parent.VerifiedBadges)

local Enums = require(ProfilePlatform.Common.Enums)
local getDeepValue = require(ProfilePlatform.Utils.getDeepValue)
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)

local FFlagEnablePressingCommunityOwnerInPeekView = require(ProfilePlatform.Flags.FFlagEnablePressingCommunityOwnerInPeekView)

local CommunityProfileHeader = require(ProfilePlatform.Components.CommunityProfileHeader.CommunityProfileHeader)

local function CommunityProfileHeaderContainer(p)
	local profileId = useProfileWrapperContext().profileId

	local v = useProfileJsonComponent(Enums.Components.CommunityProfileHeader)
	local name

	if v.isVerified then
		name = `{v.name}{VerifiedBadges.emoji.verified}`
	else
		name = v.name
	end

	local ownerName

	if v.ownerIsVerified then
		ownerName = `{v.ownerName}{VerifiedBadges.emoji.verified}`
	else
		ownerName = v.ownerName
	end

	local membersCount = getDeepValue(v, "counts.membersCount") or 0

	local rbxthumbWithTypeSizeAndOptions = getRbxthumbWithTypeSizeAndOptions(
		profileId,
		Constants.RbxthumbTypes.GroupIcon,
		150
	)
	local ownerUserId

	if FFlagEnablePressingCommunityOwnerInPeekView then
		ownerUserId = v.ownerUserId
	end

	local createElement = React.createElement
	local v2 = {
		layoutOrder = p.layoutOrder,
		name = name,
		ownerName = ownerName,
		membersCount = membersCount,
		hasSocialModules = v.hasSocialModules,
		thumbnail = rbxthumbWithTypeSizeAndOptions,
		ownerUserId = 0
	}

	if not FFlagEnablePressingCommunityOwnerInPeekView then
		ownerUserId = nil
	end

	v2.ownerUserId = ownerUserId
	return createElement(CommunityProfileHeader, v2)
end

return CommunityProfileHeaderContainer
