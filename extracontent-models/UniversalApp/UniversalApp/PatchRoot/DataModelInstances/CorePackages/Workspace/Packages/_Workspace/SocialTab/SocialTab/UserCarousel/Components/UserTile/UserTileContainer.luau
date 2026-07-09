local SocialTab = script:FindFirstAncestor("SocialTab")
local SocialTabParent = SocialTab.Parent
local React = require(SocialTabParent.React)
local UserProfiles = require(SocialTabParent.UserProfiles)
local Cryo = require(SocialTabParent.Cryo)
local UserTile = require(script.Parent.UserTile)
local getSocialTabUserProfileApiEnabled = require(SocialTab.Flags.getSocialTabUserProfileApiEnabled)

local function UserTileContainer(t1: {[any]: any}) -- line: 29
	-- upvalues: getSocialTabUserProfileApiEnabled (copy), UserProfiles (copy), React (copy), UserTile (copy), Cryo (copy)
	local v10 = nil
	local v11 = nil

	if getSocialTabUserProfileApiEnabled() then
		local v12 = UserProfiles.Hooks.useUserProfilesFetch({
			userIds = { t1.user.id },
			query = UserProfiles.Queries.userProfilesCombinedNameAndUsernameByUserIds
		})

		v10 = v12.loading and true or not not v12.error
		v11 = if not v12.data then nil else UserProfiles.Selectors.getCombinedNameFromId(v12.data, t1.user.id)
	end

	return React.createElement(UserTile, Cryo.Dictionary.join(t1, {
		combinedName = v11,
		shouldShimmerName = v10
	}))
end

return UserTileContainer
