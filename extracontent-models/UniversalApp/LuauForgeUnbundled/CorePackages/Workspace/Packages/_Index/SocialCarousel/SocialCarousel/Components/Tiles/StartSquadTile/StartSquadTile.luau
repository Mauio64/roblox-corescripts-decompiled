local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/RobloxAppEnums").AppPage
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Localization")
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Navigation").useNavigation

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/React")

local useSocialCarouselAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Analytics/useSocialCarouselAnalytics")
local useSocialCarouselContext = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Contexts/useSocialCarouselContext")
local Tile = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/BaseComponents/Tile")
local FFlagSocialCarouselXXSmallTiles = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Flags/FFlagSocialCarouselXXSmallTiles")

local useLocalization = Localization.Hooks.useLocalization

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Common/Constants")

local function StartSquadTile(props)
	local v5 = FFlagSocialCarouselXXSmallTiles and props.isCompact == true
	local v6 = useNavigation()
	local v7 = useSocialCarouselAnalytics()
	local v8 = useSocialCarouselContext()

	local v9 = useLocalization({
		startPartyText = Constants.LOCALIZATION.START_SQUAD_TEXT
	})

	local v10 = React.useCallback(function()
		if props.item and props.item.onActivated then
			props.item.onActivated()
		else
			v6.navigate(appPage.Chat)
		end

		v7.startSquadPressed(props.index)
	end, { v6, props.item, props.index, v7.startSquadPressed })

	React.useEffect(function()
		v8.onSuccessfulRender(Constants.ANALYTICS.UI_LOADING_EVENTS.START_SQUAD)
	end, {})

	local createElement = React.createElement
	local v12 = {
		testId = props.testId or `--social-social-carousel-view-start-squad-{props.index}`,
		index = props.index,
		itemSize = props.itemSize,
		onActivated = v10,
		title = v9.startPartyText,
		icon = v5 and "person-play" or "icons/actions/friends/friendsplaying",
		iconScale = 0,
		selectionOrder = 0
	}

	local v13 = if v5 then Constants.TILE_ICON_SCALE else nil
	v12.iconScale = v13
	v12.selectionOrder = props.selectionOrder
	return createElement(Tile, v12)
end

return StartSquadTile
