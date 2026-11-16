local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local Foundation = require(CorePackages.Packages.Foundation)
local View = Foundation.View
local Enums = require(CorePackages.Workspace.Packages.ProfilePlatform.Enums)
local useProfileJsonComponent = require(CorePackages.Workspace.Packages.ProfilePlatform.useProfileJsonComponent)
local ProfileWrapperContext = require(CorePackages.Workspace.Packages.ProfilePlatform.ProfileWrapperContext)
local AvatarHeadshotComponent = require(CorePackages.Workspace.Packages.ProfilePlatform.AvatarHeadshotComponent)
local SocialChipCountsRow = require(CorePackages.Workspace.Packages.ProfilePlatform.SocialChipCountsRow)

local function ProfileHeader(p)
	local v = React.useContext(ProfileWrapperContext)

	local v2 = useProfileJsonComponent(Enums.Components.UserProfileHeader)
	local v3 = v2.counts ~= nil

	local createElement = React.createElement
	local v4 = { tag = "size-full-0 auto-y col gap-large", LayoutOrder = p.layoutOrder }

	local createElement2 = React.createElement
	local v5 = {
		userId = p.profileId,
		primaryName = 0,
		username = 0,
		isPremium = 0,
		isVerified = 0,
		isRobloxAdmin = 0,
		layoutOrder = 1
	}
	local primaryName = v2.names.primaryName or ""

	local _profileUserNickname = v.profileUserNickname

	v5.primaryName = primaryName
	v5.username = v2.names.username
	v5.isPremium = v2.isPremium
	v5.isVerified = v2.isVerified
	v5.isRobloxAdmin = v2.isRobloxAdmin
	local v6 = {
		AvatarHeadshotComponent = createElement2(AvatarHeadshotComponent, v5),
		SocialCountsRow = 0
	}
	local socialCountsRow

	if v3 then
		socialCountsRow = React.createElement(SocialChipCountsRow, {
			size = UDim2.fromScale(1, 0),
			layoutOrder = 2
		})
	end

	v6.SocialCountsRow = socialCountsRow
	return createElement(View, v4, v6)
end

return React.memo(ProfileHeader)
