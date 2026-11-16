local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local parent = SocialCarousel.Parent
local React = require(parent.React)
local Localization = require(parent.Localization)

local useLocalization = Localization.Hooks.useLocalization
local Constants = require(SocialCarousel.Common.Constants)
local Tile = require(SocialCarousel.BaseComponents.Tile)

local icon = game:DefineFastFlag("UpdateSocialCarouselAddFriendsIcon", false)
	and "icons/actions/friend_sort/add_friends"
	or "icons/common/plus_heavy"

local function AddFriendsTile(props)
	local v = useLocalization({ addFriendsHeading = Constants.LOCALIZATION.ADD_FRIENDS_HEADING })

	return React.createElement(Tile, {
		index = props.index,
		itemSize = props.itemSize,
		onActivated = props.onActivated,
		title = v.addFriendsHeading,
		icon = icon,
		selectionOrder = props.selectionOrder,
		badge = props.badge
	})
end

return AddFriendsTile
