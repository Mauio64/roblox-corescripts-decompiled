local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local parent = SocialCarousel.Parent
local React = require(parent.React)
local Localization = require(parent.Localization)
local Foundation = require(parent.Foundation)
local FFlagSocialCarouselXXSmallTiles = require(SocialCarousel.Flags.FFlagSocialCarouselXXSmallTiles)

local useLocalization = Localization.Hooks.useLocalization
local Constants = require(SocialCarousel.Common.Constants)
local Tile = require(SocialCarousel.BaseComponents.Tile)

local defineFastFlag = game:DefineFastFlag("UpdateSocialCarouselAddFriendsIcon", false)
local v = defineFastFlag and "icons/actions/friend_sort/add_friends" or "icons/common/plus_heavy"

local function AddFriendsTile(props)
	local v2 = FFlagSocialCarouselXXSmallTiles and props.isCompact == true
	local addFriendsHeading

	if v2 then
		addFriendsHeading = Constants.LOCALIZATION.ADD_FRIENDS_HEADING_SENTENCE_CASE
	else
		addFriendsHeading = Constants.LOCALIZATION.ADD_FRIENDS_HEADING
	end

	local v3 = useLocalization({ addFriendsHeading = addFriendsHeading })

	local createElement = React.createElement
	local v4 = {
		testId = props.testId or `--social-social-carousel-view-add-friends-{props.index}`,
		index = props.index,
		itemSize = props.itemSize,
		onActivated = props.onActivated,
		title = v3.addFriendsHeading,
		icon = 0,
		iconScale = 0,
		titleOverhang = 0,
		iconVariant = 0,
		selectionOrder = 0,
		badge = 0
	}
	local icon

	if v2 then
		icon = defineFastFlag and "person-plus" or "plus-large"
	else
		icon = v
	end

	v4.icon = icon
	local iconScale

	if v2 then
		iconScale = Constants.TILE_ICON_SCALE
	end

	v4.iconScale = iconScale
	local titleOverhang

	if v2 then
		titleOverhang = Constants.ADD_FRIENDS_TITLE_OVERHANG
	end

	v4.titleOverhang = titleOverhang
	local iconVariant

	if v2 and not defineFastFlag then
		iconVariant = Foundation.Enums.IconVariant.Filled
	end

	v4.iconVariant = iconVariant

	v4.selectionOrder = props.selectionOrder
	v4.badge = props.badge
	return createElement(Tile, v4)
end

return AddFriendsTile
