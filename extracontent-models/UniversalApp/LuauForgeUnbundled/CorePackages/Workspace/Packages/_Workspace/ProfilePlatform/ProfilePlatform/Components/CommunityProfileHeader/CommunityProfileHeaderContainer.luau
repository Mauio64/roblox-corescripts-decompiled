local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local UserLib = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UserLib")
local constants = UserLib.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local VerifiedBadges = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/VerifiedBadges")

local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local module5 = require("@luauforge/bundled/eXH")
local useProfileJsonComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileJsonComponent")
local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")

local FFlagEnablePressingCommunityOwnerInPeekView = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagEnablePressingCommunityOwnerInPeekView")

local CommunityProfileHeader = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CommunityProfileHeader/CommunityProfileHeader")

local function CommunityProfileHeaderContainer(p2)
	local profileId = useProfileWrapperContext().profileId

	local v5 = useProfileJsonComponent(Enums.Components.CommunityProfileHeader)
	local v6 = if v5.isVerified then `{v5.name}{module3.emoji.verified}` else v5.name
	local v7 = if v5.ownerIsVerified then `{v5.ownerName}{module3.emoji.verified}` else v5.ownerName
	local v8 = module5(v5, "counts.membersCount") or 0

	local rbxthumbWithTypeSizeAndOptions = getRbxthumbWithTypeSizeAndOptions(
		profileId,
		constants.RbxthumbTypes.GroupIcon,
		150
	)
	local ownerUserId = if FFlagEnablePressingCommunityOwnerInPeekView then v5.ownerUserId else nil

	local createElement = React.createElement
	local v10 = {
		layoutOrder = p2.layoutOrder,
		name = v6,
		ownerName = v7,
		membersCount = v8,
		hasSocialModules = v5.hasSocialModules,
		thumbnail = rbxthumbWithTypeSizeAndOptions,
		ownerUserId = 0
	}

	if not FFlagEnablePressingCommunityOwnerInPeekView then
		ownerUserId = nil
	end

	v10.ownerUserId = ownerUserId
	return createElement(CommunityProfileHeader, v10)
end

return CommunityProfileHeaderContainer
