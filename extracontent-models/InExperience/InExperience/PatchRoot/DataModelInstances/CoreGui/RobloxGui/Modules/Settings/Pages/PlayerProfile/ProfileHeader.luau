local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local View = require(CorePackages.Packages.Foundation).View
local Enums = require(CorePackages.Workspace.Packages.ProfilePlatform.Enums)
local useProfileJsonComponent = require(CorePackages.Workspace.Packages.ProfilePlatform.useProfileJsonComponent)
local ProfileWrapperContext = require(CorePackages.Workspace.Packages.ProfilePlatform.ProfileWrapperContext)
local AvatarHeadshotComponent = require(CorePackages.Workspace.Packages.ProfilePlatform.AvatarHeadshotComponent)
local SocialChipCountsRow = require(CorePackages.Workspace.Packages.ProfilePlatform.SocialChipCountsRow)
local useAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).useAppPolicy
local FFlagFriendRequestNicknames = require(CorePackages.Workspace.Packages.SharedFlags).FFlagFriendRequestNicknames

local function ProfileHeader(t1: {[any]: any}) -- line: 42
	-- upvalues: React (copy), ProfileWrapperContext (copy), useProfileJsonComponent (copy), Enums (copy), FFlagFriendRequestNicknames (copy), useAppPolicy (copy), View (copy), AvatarHeadshotComponent (copy), SocialChipCountsRow (copy)
	local v17 = React.useContext(ProfileWrapperContext)
	local v18 = useProfileJsonComponent(Enums.Components.UserProfileHeader)
	local v19 = v18.counts ~= nil
	local v20 = not not FFlagFriendRequestNicknames and useAppPolicy(function(p1) -- line: 49
		return p1.getFriendRequestNicknamesEnabled()
	end)
	local createElement = React.createElement
	local v22 = View
	local t2 = {
		tag = "size-full-0 auto-y col gap-large",
		LayoutOrder = t1.layoutOrder
	}
	local t3 = {}
	local createElement2 = React.createElement
	local v26 = AvatarHeadshotComponent
	local t4 = {
		layoutOrder = 1,
		userId = t1.profileId
	}
	local v28 = v18.names.primaryName or ""

	t4.primaryName = if not v17.profileUserNickname or (not v20 or v17.profileUserNickname == "") then v28 else v17.profileUserNickname .. " (" .. v28 .. ")"
	t4.username = v18.names.username
	t4.isPremium = v18.isPremium
	t4.isVerified = v18.isVerified
	t4.isRobloxAdmin = v18.isRobloxAdmin
	t3.AvatarHeadshotComponent = createElement2(v26, t4)
	t3.SocialCountsRow = if not v19 then nil else React.createElement(SocialChipCountsRow, {
		layoutOrder = 2,
		size = UDim2.fromScale(1, 0)
	})

	return createElement(v22, t2, t3)
end

return React.memo(ProfileHeader)
