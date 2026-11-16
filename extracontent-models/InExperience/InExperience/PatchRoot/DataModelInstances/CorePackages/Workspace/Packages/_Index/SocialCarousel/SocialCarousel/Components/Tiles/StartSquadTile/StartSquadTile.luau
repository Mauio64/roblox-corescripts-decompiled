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

local useLocalization = Localization.Hooks.useLocalization

local Constants = require(SocialCarousel.Common.Constants)

local function StartSquadTile(props)
	local v = useNavigation()
	local v2 = useSocialCarouselAnalytics()
	local v3 = useSocialCarouselContext()

	local v4 = useLocalization({ startPartyText = Constants.LOCALIZATION.START_SQUAD_TEXT })

	local onActivated = React.useCallback(function()
		if props.item and props.item.onActivated then
			props.item.onActivated()
		else
			v.navigate(AppPage.Chat)
		end

		v2.startSquadPressed(props.index)
	end, { v, props.item, props.index, v2.startSquadPressed })

	React.useEffect(function()
		v3.onSuccessfulRender(Constants.ANALYTICS.UI_LOADING_EVENTS.START_SQUAD)
	end, {})

	return React.createElement(Tile, {
		index = props.index,
		itemSize = props.itemSize,
		onActivated = onActivated,
		title = v4.startPartyText,
		icon = "icons/actions/friends/friendsplaying",
		selectionOrder = props.selectionOrder
	})
end

return StartSquadTile
