local module = require("@luauforge/bundled/idU")

local module2 = require("@luauforge/bundled/iei")
local module3 = require("@luauforge/bundled/iej")
require("@luauforge/bundled/iek")
require("@luauforge/bundled/iel")
local module4 = require("@luauforge/bundled/idW")
local module5 = require("@luauforge/bundled/iem")
local module6 = require("@luauforge/bundled/ieb")

local getOverflowMenuSignalStore = module2.getOverflowMenuSignalStore
local oneByTwoTile = module6.OneByTwoTile
local sduiTileOverflowMenu = module5.SduiTileOverflowMenu
local useSduiVideoAnalytics = module5.useSduiVideoAnalytics
local useSduiReportExperienceLaunched = module5.useSduiReportExperienceLaunched
local useUidRefString = module4.useUidRefString
local findAnalyticsFieldInAncestors = module4.findAnalyticsFieldInAncestors
local sduiComponentType = module4.SduiComponentType
local sduiErrorType = module4.SduiErrors.SduiErrorType

local fFlagLuaAppEnableOneByTwoTileFunnelTelemetrySdui = require("@luauforge/bundled/idX").FFlagLuaAppEnableOneByTwoTileFunnelTelemetrySdui

local function SduiSponsoredOneByTwoTileContent(props)
	local universeId = props.universeId or ""
	local rootPlaceId = props.rootPlaceId or ""
	local current = useUidRefString().current

	local v5 = useSduiReportExperienceLaunched(
		props.sduiContext,
		props.analyticsContext,
		universeId,
		props.placeIdOverride or rootPlaceId,
		rootPlaceId,
		nil,
		props.launchDataOverride
	)

	local v6 = module.useCallback(function(p2, p3, p4, p5, p6, p7)
		v5(p7)
	end, { v5 })

	local v7 = props.contentType == "AdLink"
	local analyticsContext = props.analyticsContext
	local appPage = props.sduiContext.appPage

	local v10 = if v7 then props.clickoutUrl else props.universeId
	local v11 = useSduiVideoAnalytics(analyticsContext, appPage, {
		source = v7 and "adLink" or "universe",
		sourceId = v10,
		universeId = props.universeId,
		placeId = props.rootPlaceId
	})

	local v12 = module.useCallback(function(p2)
		module3.Events.gameTileOverflowMenuAction({
			universeId = universeId,
			sortId = props.collectionId,
			contentType = props.contentType,
			actionType = p2 and "GameTileOverflowMenuClosed" or "GameTileOverflowMenuOpened"
		}, props.sduiContext.appPage or "Unknown")
	end, {
		universeId,
		props.collectionId,
		props.contentType,
		props.sduiContext.appPage
	})

	local triggerFeedback = props.sduiContext.dependencies.triggerFeedback
	local v13 = module.useCallback(function()
		local overflowMenuSignalStore = getOverflowMenuSignalStore()

		if triggerFeedback and not overflowMenuSignalStore.getIsMenuOpen(current) then
			triggerFeedback("TileLongPress", "Press", props.sduiContext.appPage or "Unknown", {
				universeId = universeId,
				sortId = props.collectionId
			})
		end

		overflowMenuSignalStore.openMenu(current)
		v12(false)
	end, {
		current,
		v12,
		props.collectionId,
		props.sduiContext.appPage,
		triggerFeedback,
		universeId
	})

	local fn = props.overflowMenuComponent and function(props2)
		return module.createElement(sduiTileOverflowMenu, {
			componentConfig = props.overflowMenuComponent,
			debugName = "SduiSponsoredOneByTwoTile.OverflowMenu",
			isHovered = props2.isHovered,
			isSelected = props2.isSelected,
			menuKey = props2.menuKey,
			onMenuOpenChanged = v12,
			parentRef = props2.parentRef,
			sduiContext = props.sduiContext,
			zIndex = 4
		})
	end or nil

	local v14 = props.badgeText and props.badgeAnalyticsId and {
		ImageTopLeft = {
			{
				analyticsId = props.badgeAnalyticsId,
				tileBadgeType = "Text",
				text = props.badgeText,
				tileBadgeComponentType = "Pill"
			}
		}
	} or nil
	local v15

	if fFlagLuaAppEnableOneByTwoTileFunnelTelemetrySdui then
		v15 = findAnalyticsFieldInAncestors("oneByTwoTileFlowId", props.analyticsContext)

		if typeof(v15) ~= "string" then
			v15 = nil
		end
	end

	local createElement = module.createElement
	local v17 = {}
	v17.rootSize = UDim2.fromScale(1, 1)
	v17.size = UDim2.fromScale(1, 1)
	v17.alignmentType = props.alignmentType
	v17.cellVerticalPadding = props.cellVerticalPadding
	v17.hoverKey = current
	v17.contentType = props.contentType
	v17.universeId = props.universeId
	v17.placeId = props.rootPlaceId
	v17.placeIdOverride = props.placeIdOverride
	v17.launchDataOverride = props.launchDataOverride
	v17.referralSource = props.sduiContext.appPage
	v17.reportExperienceLaunched = v6
	v17.onOpenGameDetails = props.onOpenGameDetails
	v17.launchExperienceEventContext = "OneByTwoTile"
	v17.badgeOverride = v14
	v17.primaryImageAssetId = props.imageAssetId
	v17.primaryVideoAssetId = props.videoAssetId
	v17.attributionThumbnailAssetId = props.attributionThumbnailAssetId
	v17.logoImageAssetId = props.logoAssetId
	local v18 = if props.logoAspectRatio ~= nil then tostring(props.logoAspectRatio) else nil
	v17.logoAspectRatio = v18
	v17.headline = props.titleText
	v17.subtitle = props.subtitle
	v17.ctaText = props.ctaText or ""
	v17.payerName = props.payerName
	v17.sponsoredUserCohort = props.sponsoredUserCohort
	v17.clickoutUrl = props.clickoutUrl
	v17.videoPlaybackContext = props.sduiContext.videoPlaybackContext
	v17.videoAnalytics = v11
	v17.adId = props.nativeAdData
	v17.index = props.index
	v17.pageContext = props.sduiContext.appPage
	v17.appPage = props.sduiContext.appPage
	v17.topicId = props.collectionId
	v17.renderOverflowMenu = fn

	if not props.overflowMenuComponent then
		v13 = nil
	end

	v17.onTouchLongPress = v13
	v17.disableGameLaunchSponsoredClickRecording = true

	v17.enableSponsoredFeedback = false
	v17.enableReportAd = true
	v17.enableExplicitFeedback = false
	v17.SelectionOrder = props.selectionOrder

	if not fFlagLuaAppEnableOneByTwoTileFunnelTelemetrySdui then
		v15 = nil
	end

	v17.oneByTwoTileFlowId = v15
	v17.isSdui = fFlagLuaAppEnableOneByTwoTileFunnelTelemetrySdui and true or nil
	return createElement(oneByTwoTile, v17)
end

local function SduiSponsoredOneByTwoTile(props)
	local v5

	if props.contentType == "AdLink" then
		v5 = not (props.clickoutUrl == nil) and props.clickoutUrl ~= ""
	else
		v5 = props.contentType == "Game" and props.universeId ~= nil and props.universeId ~= ""
	end

	module.useEffect(function()
		if not v5 then
			props.sduiContext.dependencies.logger.reportError(
				sduiErrorType.InvalidProps,
				{
					componentType = sduiComponentType.SponsoredOneByTwoTile,
					propName = "contentType",
					message = `Missing destination for 1x2, contentType: {props.contentType}, clickoutUrl: {props.clickoutUrl}, universeId: {props.universeId}`
				},
				props.sduiContext.appPage
			)
		end
	end, {
		v5,
		props.sduiContext,
		props.clickoutUrl,
		props.contentType,
		props.universeId
	})

	if v5 then
		return module.createElement(SduiSponsoredOneByTwoTileContent, props)
	end

	return nil
end

return module.memo(SduiSponsoredOneByTwoTile)
