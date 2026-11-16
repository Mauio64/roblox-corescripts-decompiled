local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Localization").Hooks.useLocalization
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Common/Constants")
local Tile = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/BaseComponents/Tile")

local v5 = game:DefineFastFlag("UpdateSocialCarouselAddFriendsIcon", false)
	and "icons/actions/friend_sort/add_friends"
	or "icons/common/plus_heavy"

local function AddFriendsTile(props)
	local v6 = useLocalization({
		addFriendsHeading = Constants.LOCALIZATION.ADD_FRIENDS_HEADING
	})

	return React.createElement(Tile, {
		index = props.index,
		itemSize = props.itemSize,
		onActivated = props.onActivated,
		title = v6.addFriendsHeading,
		icon = v5,
		selectionOrder = props.selectionOrder,
		badge = props.badge
	})
end

return AddFriendsTile
