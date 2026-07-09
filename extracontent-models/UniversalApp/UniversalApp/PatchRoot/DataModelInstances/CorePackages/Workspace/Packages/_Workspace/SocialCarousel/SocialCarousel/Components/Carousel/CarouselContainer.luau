local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local SocialCarouselParent = SocialCarousel.Parent
local React = require(SocialCarouselParent.React)
local RobloxAppEnums = require(SocialCarouselParent.RobloxAppEnums)
local RoactUtils = require(SocialCarouselParent.RoactUtils)
local Carousel = require(script.Parent.Carousel)
local NavigateDown = require(SocialCarouselParent.NavigationRodux).Thunks.NavigateDown
local Navigation = require(SocialCarouselParent.Navigation)
local useSocialCarouselAnalytics = require(SocialCarousel.Analytics.useSocialCarouselAnalytics)
local useTilesSeenCollection = require(SocialCarousel.Analytics.useTilesSeenCollection)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local AppPage = RobloxAppEnums.AppPage
local useNavigation = Navigation.useNavigation
local FFlagCreateConnectionsHub = require(SocialCarouselParent.SharedFlags).FFlagCreateConnectionsHub
local FFlagSignalsNavP3Dispatch = require(SocialCarouselParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v16 = if not FFlagSignalsNavP3Dispatch then nil else require(SocialCarouselParent.RobloxAppNavigation).NavigationCommands

local function CarouselContainer(t1: {[any]: any}) -- line: 26
	-- upvalues: useSocialCarouselAnalytics (copy), useTilesSeenCollection (copy), useDispatch (copy), useNavigation (copy), React (copy), FFlagCreateConnectionsHub (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v16 (copy), NavigateDown (copy), Carousel (copy)
	local v19 = useSocialCarouselAnalytics()
	local v20 = useTilesSeenCollection()
	local v21 = useDispatch()
	local v22 = useNavigation()
	local v23 = React.useRef({
		startIndex = 1,
		endIndex = 1
	})
	local v24 = React.useCallback(function() -- line: 33
		-- upvalues: v19 (copy), FFlagCreateConnectionsHub (copy), v22 (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v16 (copy), v21 (copy), NavigateDown (copy)
		v19.friendsHeaderPressed()

		if FFlagCreateConnectionsHub then
			v22.navigate(AppPage.CoHubMyConnections)

			return
		end

		if FFlagSignalsNavP3Dispatch then
			v16.down(v16.fromLegacyPage({
				name = AppPage.ViewFriends
			}))

			return
		end

		v21(NavigateDown({
			name = AppPage.ViewFriends
		}))
	end, {
		v21,
		v22
	})
	local v25 = React.useCallback(function(s1: string, n1: number, p1) -- line: 44
		-- upvalues: v23 (copy), v20 (copy)
		local current = v23.current

		if n1 >= current.startIndex and n1 <= current.endIndex then
			v20.addTileToCollection(s1, n1, p1)
		end
	end, { v20 })

	return React.createElement(Carousel, {
		onActivateHeader = v24,
		onTileContentChanged = v25,
		appCompositionEnabled = t1.appCompositionEnabled
	})
end

return CarouselContainer
