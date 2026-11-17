local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local parent = SocialCarousel.Parent

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local Localization = require(parent.Localization)
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation

local React = require(parent.React)

local useSocialCarouselAnalytics = require(SocialCarousel.Analytics.useSocialCarouselAnalytics)
local useSocialCarouselContext = require(SocialCarousel.Contexts.useSocialCarouselContext)
local Tile = require(SocialCarousel.BaseComponents.Tile)
local FFlagSocialCarouselXXSmallTiles = require(SocialCarousel.Flags.FFlagSocialCarouselXXSmallTiles)

local useLocalization = Localization.Hooks.useLocalization

local Constants = require(SocialCarousel.Common.Constants)

local function StartSquadTile(props)
	local v = FFlagSocialCarouselXXSmallTiles and props.isCompact == true
	local v2 = useNavigation()
	local v3 = useSocialCarouselAnalytics()
	local v4 = useSocialCarouselContext()

	local v5 = useLocalization({ startPartyText = Constants.LOCALIZATION.START_SQUAD_TEXT })

	local onActivated = React.useCallback(function()
		if props.item and props.item.onActivated then
			props.item.onActivated()
		else
			v2.navigate(AppPage.Chat)
		end

		v3.startSquadPressed(props.index)
	end, { v2, props.item, props.index, v3.startSquadPressed })

	React.useEffect(function()
		v4.onSuccessfulRender(Constants.ANALYTICS.UI_LOADING_EVENTS.START_SQUAD)
	end, {})

	local createElement = React.createElement
	local v6 = {
		testId = props.testId or `--social-social-carousel-view-start-squad-{props.index}`,
		index = props.index,
		itemSize = props.itemSize,
		onActivated = onActivated,
		title = v5.startPartyText,
		icon = v and "person-play" or "icons/actions/friends/friendsplaying",
		iconScale = 0,
		selectionOrder = 0
	}
	local iconScale

	if v then
		iconScale = Constants.TILE_ICON_SCALE
	end

	v6.iconScale = iconScale
	v6.selectionOrder = props.selectionOrder
	return createElement(Tile, v6)
end

return StartSquadTile
