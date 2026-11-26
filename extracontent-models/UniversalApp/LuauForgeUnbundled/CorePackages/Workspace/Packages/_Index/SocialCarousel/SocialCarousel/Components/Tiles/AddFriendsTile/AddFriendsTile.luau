local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/React")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Localization")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Foundation")
local FFlagSocialCarouselXXSmallTiles = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Flags/FFlagSocialCarouselXXSmallTiles")

local useLocalization = Localization.Hooks.useLocalization
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Common/Constants")
local Tile = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/BaseComponents/Tile")

local defineFastFlag = game:DefineFastFlag("UpdateSocialCarouselAddFriendsIcon", false)
local v5 = defineFastFlag and "icons/actions/friend_sort/add_friends" or "icons/common/plus_heavy"

local function AddFriendsTile(props)
	local v6 = FFlagSocialCarouselXXSmallTiles and props.isCompact == true

	local v9 = if v6 then Constants.LOCALIZATION.ADD_FRIENDS_HEADING_SENTENCE_CASE else Constants.LOCALIZATION.ADD_FRIENDS_HEADING
	local v10 = useLocalization({ addFriendsHeading = v9 })

	local createElement = React.createElement
	local v12 = {
		testId = props.testId or `--social-social-carousel-view-add-friends-{props.index}`,
		index = props.index,
		itemSize = props.itemSize,
		onActivated = props.onActivated,
		title = v10.addFriendsHeading,
		icon = 0,
		iconScale = 0,
		titleOverhang = 0,
		iconVariant = 0,
		selectionOrder = 0,
		badge = 0
	}
	local v13 = if v6 then defineFastFlag and "person-plus" or "plus-large" else v5
	v12.icon = v13

	local v14 = if v6 then Constants.TILE_ICON_SCALE else nil
	v12.iconScale = v14
	local v15 = if v6 then Constants.ADD_FRIENDS_TITLE_OVERHANG else nil
	v12.titleOverhang = v15

	local v16 = if v6 and not defineFastFlag then Foundation.Enums.IconVariant.Filled else nil
	v12.iconVariant = v16

	v12.selectionOrder = props.selectionOrder
	v12.badge = props.badge
	return createElement(Tile, v12)
end

return AddFriendsTile
