local module = require("@luauforge/bundled/hTW")
local module2 = require("@luauforge/bundled/hUq")
local module3 = require("@luauforge/bundled/hUr")

local module4 = require("@luauforge/bundled/hUk")
local module5 = require("@luauforge/bundled/hUl")
local module6 = require("@luauforge/bundled/hUn")
local module7 = require("@luauforge/bundled/hTY")
local module8 = require("@luauforge/bundled/hUo")
local module9 = require("@luauforge/bundled/hUd")

local getGameTileHiddenStore = module6.getGameTileHiddenStore
local getOverflowMenuSignalStore = module4.getOverflowMenuSignalStore
local getSduiComponentWrapper = module7.getSduiComponentWrapper
local sduiTileOverflowMenu = module8.SduiTileOverflowMenu
local twoByOneGameTile = module9.TwoByOneGameTile
local useSduiReportExperienceLaunched = module8.useSduiReportExperienceLaunched
local useUidRefString = module7.useUidRefString

local signal = module2.createSignal(false)

local function SduiSponsoredTwoByOneTile(props)
	local universeId = props.universeId
	local current = useUidRefString().current

	local v5 = useSduiReportExperienceLaunched(
		props.sduiContext,
		props.analyticsContext,
		universeId,
		props.placeIdOverride or props.rootPlaceId,
		props.rootPlaceId,
		nil,
		props.launchDataOverride
	)

	local v6 = module.useCallback(function(p2, p3, p4, p5, p6, p7)
		v5(p7)
	end, { v5 })

	local v7 = module.useCallback(function(p2)
		module5.Events.gameTileOverflowMenuAction({
			universeId = universeId,
			sortId = props.collectionId,
			actionType = p2 and "GameTileOverflowMenuClosed" or "GameTileOverflowMenuOpened"
		}, props.sduiContext.appPage or "Unknown")
	end, { universeId, props.collectionId, props.sduiContext.appPage })

	local triggerFeedback = props.sduiContext.dependencies.triggerFeedback
	local v8 = module.useCallback(function()
		local overflowMenuSignalStore = getOverflowMenuSignalStore()

		if triggerFeedback and not overflowMenuSignalStore.getIsMenuOpen(current) then
			triggerFeedback("TileLongPress", "Press", props.sduiContext.appPage or "Unknown", {
				universeId = universeId,
				sortId = props.collectionId
			})
		end

		overflowMenuSignalStore.openMenu(current)
		v7(false)
	end, {
		current,
		v7,
		props.collectionId,
		props.sduiContext.appPage,
		triggerFeedback,
		universeId
	})
	local v9

	if props.collectionId == nil or props.collectionId == "" or props.overflowMenuComponent == nil then
		v9 = false
	else
		v9 = props.hiddenStateComponent ~= nil
	end

	local v10 = module.useMemo(function()
		if not v9 then
			return signal
		end

		local getHiddenGames = getGameTileHiddenStore(props.collectionId).getHiddenGames
		return module2.createComputed(function(p2): boolean
			return getHiddenGames(p2)[universeId] == true
		end)
	end, { v9, props.collectionId, universeId })

	local v11 = module3.useSignalState(v10)

	local setGameHidden = if v9 then getGameTileHiddenStore(props.collectionId).setGameHidden else nil

	local fn = props.overflowMenuComponent and function(props2)
		return module.createElement(sduiTileOverflowMenu, {
			componentConfig = props.overflowMenuComponent,
			debugName = "SduiSponsoredTwoByOneTile.OverflowMenu",
			isHovered = props2.isHovered,
			isSelected = props2.isSelected,
			menuKey = props2.menuKey,
			onMenuOpenChanged = v7,
			parentRef = props2.parentRef,
			sduiContext = props.sduiContext,
			zIndex = 5
		})
	end or nil

	local fn2 = props.hiddenStateComponent and function(p2)
		return module.createElement(getSduiComponentWrapper(props.hiddenStateComponent), {
			componentConfig = props.hiddenStateComponent,
			debugName = "SduiSponsoredTwoByOneTile.HiddenState",
			extraLocalProps = { parentRef = p2 },
			sduiContext = props.sduiContext
		})
	end or nil

	local v12 = props.badgeText and props.badgeAnalyticsId and {
		ImageTopLeft = {
			{
				analyticsId = props.badgeAnalyticsId,
				tileBadgeType = "Text",
				text = props.badgeText,
				tileBadgeComponentType = "Pill"
			}
		}
	} or nil

	local createElement = module.createElement
	local v14 = {
		rootSize = UDim2.fromScale(1, 1),
		universeId = universeId,
		placeId = props.rootPlaceId,
		logoImageAssetId = props.logoAssetId,
		logoAspectRatio = 0,
		headline = 0,
		subtitle = 0,
		ctaText = 0,
		tileVariant = 0,
		onOpenGameDetails = 0,
		badgeOverride = 0,
		adId = 0,
		isSponsored = true,
		disableSponsoredClickRecording = true,
		appPage = 0,
		topicId = 0,
		setGameHidden = 0,
		isHidden = 0,
		renderOverflowMenu = 0,
		renderHiddenState = 0,
		onTouchLongPress = 0,
		hoverKey = 0,
		index = 0,
		placeIdOverride = 0,
		launchDataOverride = 0,
		wideAssetId = 0,
		ageRatingLabel = 0,
		videoPlaybackContext = 0,
		SelectionOrder = 0,
		reportExperienceLaunched = 0
	}
	local v15 = if props.logoAspectRatio ~= nil then tostring(props.logoAspectRatio) else nil
	v14.logoAspectRatio = v15
	v14.headline = props.titleText
	v14.subtitle = props.subtitle
	v14.ctaText = props.ctaText
	v14.tileVariant = props.tileVariant
	v14.onOpenGameDetails = props.onOpenGameDetails
	v14.badgeOverride = v12
	v14.adId = props.nativeAdData

	v14.appPage = props.sduiContext.appPage
	v14.topicId = props.collectionId
	v14.setGameHidden = setGameHidden
	v14.isHidden = v11
	v14.renderOverflowMenu = fn
	v14.renderHiddenState = fn2

	if not props.overflowMenuComponent then
		v8 = nil
	end

	v14.onTouchLongPress = v8
	v14.hoverKey = current
	v14.index = props.index
	v14.placeIdOverride = props.placeIdOverride
	v14.launchDataOverride = props.launchDataOverride
	v14.wideAssetId = props.imageAssetId
	v14.ageRatingLabel = props.ageRatingText
	v14.videoPlaybackContext = props.sduiContext.videoPlaybackContext
	v14.SelectionOrder = props.selectionOrder
	v14.reportExperienceLaunched = v6
	return createElement(twoByOneGameTile, v14)
end

return module.memo(SduiSponsoredTwoByOneTile)
