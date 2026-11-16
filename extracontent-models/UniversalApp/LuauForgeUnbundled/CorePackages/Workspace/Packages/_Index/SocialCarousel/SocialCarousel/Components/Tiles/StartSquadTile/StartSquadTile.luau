local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/RobloxAppEnums").AppPage
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Localization")
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Navigation").useNavigation

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/React")

local useSocialCarouselAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Analytics/useSocialCarouselAnalytics")
local useSocialCarouselContext = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Contexts/useSocialCarouselContext")
local Tile = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/BaseComponents/Tile")

local useLocalization = Localization.Hooks.useLocalization

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Common/Constants")

local function StartSquadTile(props)
	local v5 = useNavigation()
	local v6 = useSocialCarouselAnalytics()
	local v7 = useSocialCarouselContext()

	local v8 = useLocalization({
		startPartyText = Constants.LOCALIZATION.START_SQUAD_TEXT
	})

	local v9 = React.useCallback(function()
		if props.item and props.item.onActivated then
			props.item.onActivated()
		else
			v5.navigate(appPage.Chat)
		end

		v6.startSquadPressed(props.index)
	end, { v5, props.item, props.index, v6.startSquadPressed })

	React.useEffect(function()
		v7.onSuccessfulRender(Constants.ANALYTICS.UI_LOADING_EVENTS.START_SQUAD)
	end, {})

	return React.createElement(Tile, {
		index = props.index,
		itemSize = props.itemSize,
		onActivated = v9,
		title = v8.startPartyText,
		icon = "icons/actions/friends/friendsplaying",
		selectionOrder = props.selectionOrder
	})
end

return StartSquadTile
