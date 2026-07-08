local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local SocialCarouselParent = SocialCarousel.Parent
local React = require(SocialCarouselParent.React)
local useLocalization = require(SocialCarouselParent.Localization).Hooks.useLocalization
local useAppPolicy = require(SocialCarouselParent.UniversalAppPolicy).useAppPolicy
local Constants = require(SocialCarousel.Common.Constants)
local Tile = require(SocialCarousel.BaseComponents.Tile)
local FFlagConnectionsToFriendsRename = require(SocialCarouselParent.SharedFlags).FFlagConnectionsToFriendsRename
local v9 = not game:DefineFastFlag("UpdateSocialCarouselAddFriendsIcon", false) and "icons/common/plus_heavy" or "icons/actions/friend_sort/add_friends"

local function AddFriendsTile(p1) -- line: 18
	-- upvalues: useAppPolicy (copy), useLocalization (copy), FFlagConnectionsToFriendsRename (copy), Constants (copy), React (copy), Tile (copy), v9 (copy)
	local v12 = useAppPolicy(function(p2) -- line: 19
		return p2.getRenameFriendsToConnections()
	end)
	local v13 = useLocalization({
		addFriendsHeading = if not FFlagConnectionsToFriendsRename then if not v12 then Constants.LOCALIZATION.ADD_FRIENDS_HEADING else Constants.LOCALIZATION.ADD_CONNECTIONS_HEADING else Constants.LOCALIZATION.ADD_FRIENDS_HEADING
	})

	return React.createElement(Tile, {
		index = p1.index,
		itemSize = p1.itemSize,
		onActivated = p1.onActivated,
		title = v13.addFriendsHeading,
		icon = v9,
		selectionOrder = p1.selectionOrder,
		badge = p1.badge
	})
end

return AddFriendsTile
