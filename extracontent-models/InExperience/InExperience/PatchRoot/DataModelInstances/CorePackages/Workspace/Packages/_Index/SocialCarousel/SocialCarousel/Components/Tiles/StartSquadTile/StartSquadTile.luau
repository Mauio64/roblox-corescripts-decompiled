local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local SocialCarouselParent = SocialCarousel.Parent
local AppPage = require(SocialCarouselParent.RobloxAppEnums).AppPage
local Localization = require(SocialCarouselParent.Localization)
local useNavigation = require(SocialCarouselParent.Navigation).useNavigation
local React = require(SocialCarouselParent.React)
local useSocialCarouselAnalytics = require(SocialCarousel.Analytics.useSocialCarouselAnalytics)
local useSocialCarouselContext = require(SocialCarousel.Contexts.useSocialCarouselContext)
local Tile = require(SocialCarousel.BaseComponents.Tile)
local useLocalization = Localization.Hooks.useLocalization
local Constants = require(SocialCarousel.Common.Constants)

local function StartSquadTile(t1: {[any]: any}) -- line: 29
	-- upvalues: useNavigation (copy), useSocialCarouselAnalytics (copy), useSocialCarouselContext (copy), useLocalization (copy), Constants (copy), React (copy), AppPage (copy), Tile (copy)
	local v14 = useNavigation()
	local v15 = useSocialCarouselAnalytics()
	local v16 = useSocialCarouselContext()
	local v17 = useLocalization({
		startPartyText = Constants.LOCALIZATION.START_SQUAD_TEXT
	})
	local v18 = React.useCallback(function() -- line: 38
		-- upvalues: t1 (copy), v14 (copy), AppPage (copy), v15 (copy)
		if t1.item and t1.item.onActivated then
			t1.item.onActivated()
		else
			v14.navigate(AppPage.Chat)
		end

		v15.startSquadPressed(t1.index)
	end, {
		v14,
		t1.item,
		t1.index,
		v15.startSquadPressed
	})

	React.useEffect(function() -- line: 55
		-- upvalues: v16 (copy), Constants (copy)
		v16.onSuccessfulRender(Constants.ANALYTICS.UI_LOADING_EVENTS.START_SQUAD)
	end, {})

	return React.createElement(Tile, {
		icon = "icons/actions/friends/friendsplaying",
		index = t1.index,
		itemSize = t1.itemSize,
		onActivated = v18,
		title = v17.startPartyText,
		selectionOrder = t1.selectionOrder
	})
end

return StartSquadTile
