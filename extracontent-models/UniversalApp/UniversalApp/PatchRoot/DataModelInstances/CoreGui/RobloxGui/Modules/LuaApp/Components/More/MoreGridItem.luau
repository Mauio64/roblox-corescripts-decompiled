local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local MenuTile = UIBlox.App.Tile.MenuTile
local Cryo = require(CorePackages.Packages.Cryo)
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local validateColorInfo = UIBlox.Style.Validator.validateColorInfo
local validateFontInfo = UIBlox.Style.Validator.validateFontInfo
local validateTypographyInfo = UIBlox.Style.Validator.validateTypographyInfo
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local AppPage = require(Modules.LuaApp.AppPage)
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local MorePageSettings = require(Modules.LuaApp.Components.More.Config.MorePageSettings)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v20 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local AppEventIngestService = require(Modules.LuaApp.Services.AppEventIngestService)
local AppLinking = require(CorePackages.Workspace.Packages.RoactServiceTags).AppLinking
local withLocalization = require(Modules.LuaApp.withLocalization)
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local openExternalBrowser = require(Modules.LuaApp.openExternalBrowser)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local Constants = require(Modules.LuaApp.Constants)
local OpenCentralOverlayForLeaveRobloxAlert = require(Modules.LuaApp.Thunks.OpenCentralOverlayForLeaveRobloxAlert)
local OpenCentralOverlayForReportLogs = require(Modules.LuaApp.Thunks.OpenCentralOverlayForReportLogs)
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local useIsSpatial = require(CorePackages.Workspace.Packages.Responsive).useIsSpatial
local navigateToFriendsLandingEvent = require(Modules.LuaApp.Components.FriendsLanding.navigateToFriendsLandingEvent)
local Sources = require(CorePackages.Workspace.Packages.SocialLuaAnalytics).Analytics.Enums.Sources
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local LinkingProtocol = require(CorePackages.Workspace.Packages.LinkingProtocol).LinkingProtocol
local FFlagCreateConnectionsHub = require(CorePackages.Workspace.Packages.SharedFlags).FFlagCreateConnectionsHub
local FFlagEnableArgusFlyoutEntry = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableArgusFlyoutEntry
local FFlagEnableMorePageDirectionalLayoutRolloutFix = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableMorePageDirectionalLayoutRolloutFix
local FFlagBlackbirdRequiresIAP = require(CorePackages.Workspace.Packages.SharedFlags).FFlagBlackbirdRequiresIAP
local FFlagEnableBlackbird = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableBlackbird
local FFlagEnableBlackbirdOnMorePage = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableBlackbirdOnMorePage
local v45 = if not FFlagEnableBlackbird or not FFlagEnableBlackbirdOnMorePage then nil else require(CorePackages.Packages.Foundation)
local GetFFlagEnableCommunityListExperimentation = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableCommunityListExperimentation
local CommunityListExperimentation = require(CorePackages.Workspace.Packages.Groups).Experiments.CommunityListExperimentation
local v48 = Roact.PureComponent:extend("MoreGridItem")

v48.validateProps = t.strictInterface({
	item = t.table,
	layoutOrder = t.integer,
	formFactor = t.string,
	localUserId = t.string,
	navigateDown = t.callback,
	openLeaveRobloxAlertUIBlox = t.callback,
	openReportLogConfirmation = t.callback,
	closeAlert = t.callback,
	catalogAnalytics = t.table,
	shouldUseExternalBrowserForMorePageItem = t.callback,
	linking = t.table,
	linkingProtocol = t.optional(t.table),
	navigation = t.table,
	eventIngest = t.any,
	disableWebViewSupport = t.boolean,
	disableIAPEntryPoint = t.optional(t.boolean),
	shouldSkipWebViewCheck = t.boolean,
	showWebViewNotAvailableToastMessage = t.callback,
	isDirectional = if not FFlagEnableMorePageDirectionalLayoutRolloutFix then nil else t.boolean,
	itemStyleProps = t.optional(t.strictInterface({
		iconStyle = t.optional(validateColorInfo),
		iconSize = t.optional(IconSize.isEnumValue),
		titleStyle = t.optional(validateColorInfo),
		titleFont = t.optional(t.union(validateFontInfo, validateTypographyInfo))
	}))
})
v48.defaultProps = {
	linkingProtocol = LinkingProtocol.default
}

function v48.init(p1) -- line: 101
	-- upvalues: openExternalBrowser (copy), FFlagCreateConnectionsHub (copy), MorePageSettings (copy), FFlagEnableArgusFlyoutEntry (copy), AvatarScreen (copy), Cryo (copy), Logging (copy), FFlagBlackbirdRequiresIAP (copy), navigateToFriendsLandingEvent (copy), AppPage (copy), Sources (copy), GetFFlagEnableCommunityListExperimentation (copy), CommunityListExperimentation (copy)
	function p1.navigateDown(p2) -- line: 102
		-- upvalues: p1 (copy), openExternalBrowser (copy), FFlagCreateConnectionsHub (copy), MorePageSettings (copy), FFlagEnableArgusFlyoutEntry (copy), AvatarScreen (copy), Cryo (copy)
		local item = p1.props.item
		local url = item.context.url
		local titleKey = item.context.titleKey

		if item.urlGenerator then
			local localUserId = p1.props.localUserId

			url = item.urlGenerator(localUserId)
		end

		local v85 = nil

		if item.getSearchParams then
			v85 = item.getSearchParams(p1.props.formFactor)
		end

		local t1 = nil

		if titleKey or v85 then
			t1 = {
				titleKey = titleKey,
				searchParams = v85
			}
		end

		local v87 = item.shouldOpenInExternalBrowser and p1.props.shouldUseExternalBrowserForMorePageItem()
		local v88 = p1.props.disableWebViewSupport == true and item.context.fallbackToExternalBrowser == true
		local appURI = item.context.appURI

		if appURI then
			p1.props.linkingProtocol:isURLRegistered(appURI):andThen(function(p3) -- line: 131
				-- upvalues: p1 (copy), appURI (copy)
				if p3 then
					p1.props.linkingProtocol:detectURL(appURI)
				end
			end)

			return
		end

		if v87 or v88 then
			openExternalBrowser(p1.props.linking, url)

			return
		end

		if FFlagCreateConnectionsHub and item.itemType == MorePageSettings.ItemType.Friends then
			p1.props.navigation.navigate(item.context.page)

			return
		end

		if FFlagEnableArgusFlyoutEntry and item.itemType == MorePageSettings.ItemType.RM then
			p1.props.navigation.navigate(item.context.page, {
				source = "flyout_menu"
			})

			return
		end

		if item.itemType == MorePageSettings.ItemType.Catalog then
			p1.props.navigation.navigate(AvatarScreen.Catalog)

			return
		end

		if item.itemType == MorePageSettings.ItemType.OfficialStore then
			p1.props.openLeaveRobloxAlertUIBlox(p1.openUrl)

			return
		end

		if item.itemType == MorePageSettings.ItemType.ReportLogs then
			p1.props.openReportLogConfirmation()

			return
		end

		p1.props.navigateDown({
			name = item.context.page,
			detail = url,
			extraProps = Cryo.Dictionary.join(t1 or {}, p2 or {})
		})
	end
	function p1.openUrl() -- line: 162
		-- upvalues: p1 (copy), Logging (copy)
		local url = p1.props.item.context.url

		p1.props.linking:openURL(url):andThen(function(p4) -- line: 164
			-- upvalues: Logging (copy)
			if p4 == false then
				Logging.warn("LinkingProtocol:openURL failed for offical amazon store.")
			end
		end)
		p1.props.closeAlert()
	end
	function p1.onActivated() -- line: 173
		-- upvalues: p1 (copy), MorePageSettings (copy), FFlagBlackbirdRequiresIAP (copy), navigateToFriendsLandingEvent (copy), AppPage (copy), Sources (copy), GetFFlagEnableCommunityListExperimentation (copy), CommunityListExperimentation (copy)
		local catalogAnalytics = p1.props.catalogAnalytics
		local item = p1.props.item
		local t2 = nil

		if not p1.props.shouldSkipWebViewCheck then
			local v94 = item.itemType == MorePageSettings.ItemType.Settings and p1.props.disableWebViewSupport
			local v95 = item.itemType == MorePageSettings.ItemType.BuildersClub and p1.props.disableIAPEntryPoint
			local v96 = FFlagBlackbirdRequiresIAP and (item.itemType == MorePageSettings.ItemType.Blackbird and p1.props.disableIAPEntryPoint)

			if v94 or v95 or v96 then
				p1.props.showWebViewNotAvailableToastMessage()

				return
			end
		end

		if item.itemType == MorePageSettings.ItemType.Catalog then
			catalogAnalytics.moreMenuToCatalogButton()
		end

		if item.itemType == MorePageSettings.ItemType.Friends then
			navigateToFriendsLandingEvent({
				context = "morePage",
				localUserId = p1.props.localUserId
			})
			t2 = {
				navigateToFriendsLandingEventStart = {
					startPage = AppPage.More,
					startTime = os.clock()
				}
			}
		end

		if item.itemType == MorePageSettings.ItemType.Profile then
			t2 = {
				source = Sources.MorePageTile
			}
		end

		if item.itemType == MorePageSettings.ItemType.Groups and GetFFlagEnableCommunityListExperimentation() then
			CommunityListExperimentation.logExposure()
		end

		p1.navigateDown(t2)
		p1.props.eventIngest:sendEventDeferred("moreGridItem", "moreGridItemClick", {
			itemType = item.itemType,
			url = item.context.url,
			localUserId = p1.props.localUserId
		})
	end
end
function v48.render(p5) -- line: 231
	-- upvalues: FFlagEnableBlackbird (copy), FFlagEnableBlackbirdOnMorePage (copy), withLocalization (copy), Roact (copy), MenuTile (copy), v45 (copy)
	local item = p5.props.item
	local badgeCount = item.badgeCount
	local icon = item.icon
	local layoutOrder = p5.props.layoutOrder
	local textKey = item.textKey
	local itemStyleProps = p5.props.itemStyleProps
	local v62 = FFlagEnableBlackbird and (FFlagEnableBlackbirdOnMorePage and (typeof(icon) == "table" and icon.isFoundationIcon == true))
	local v63 = if not v62 then icon else ""

	return withLocalization({
		title = textKey
	})(function(p6) -- line: 247
		-- upvalues: Roact (copy), MenuTile (copy), badgeCount (copy), v63 (copy), layoutOrder (copy), p5 (copy), itemStyleProps (copy), v62 (copy), v45 (copy), icon (copy)
		local v98 = Roact.createElement(MenuTile, {
			badgeValue = badgeCount > 0 and badgeCount or nil,
			icon = v63,
			layoutOrder = layoutOrder,
			onActivated = function() -- line: 252
				-- upvalues: p5 (copy)
				p5.onActivated()
			end,
			title = p6.title,
			styleProps = itemStyleProps
		})

		if not v62 then
			return v98
		end

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			LayoutOrder = layoutOrder
		}, {
			MenuTileBase = v98,
			FoundationIcon = Roact.createElement(v45.Icon, {
				size = 48,
				ZIndex = 10,
				name = icon.name,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.38)
			})
		})
	end)
end

local v49 = RoactRodux.connect(function(p7, _) -- line: 282
	return {
		formFactor = p7.FormFactor,
		localUserId = p7.LocalUserId
	}
end, function(p9) -- line: 287
	-- upvalues: FFlagSignalsNavP3Dispatch (copy), v20 (copy), NavigateDown (copy), SetCurrentToastMessage (copy), Constants (copy), OpenCentralOverlayForLeaveRobloxAlert (copy), OpenCentralOverlayForReportLogs (copy), CloseCentralOverlay (copy)
	return {
		navigateDown = function(p10) -- line: 289
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v20 (copy), p9 (copy), NavigateDown (copy)
			if FFlagSignalsNavP3Dispatch then
				v20.down(v20.fromLegacyPage(p10))

				return
			end

			p9(NavigateDown(p10))
		end,
		showWebViewNotAvailableToastMessage = function() -- line: 296
			-- upvalues: p9 (copy), SetCurrentToastMessage (copy), Constants (copy)
			p9(SetCurrentToastMessage(Constants.WEBVIEWS_UNAVAILABLE_TOAST))
		end,
		openLeaveRobloxAlertUIBlox = function(p11) -- line: 299
			-- upvalues: p9 (copy), OpenCentralOverlayForLeaveRobloxAlert (copy)
			p9(OpenCentralOverlayForLeaveRobloxAlert(p11))
		end,
		openReportLogConfirmation = function() -- line: 302
			-- upvalues: p9 (copy), OpenCentralOverlayForReportLogs (copy)
			p9(OpenCentralOverlayForReportLogs())
		end,
		closeAlert = function() -- line: 305
			-- upvalues: p9 (copy), CloseCentralOverlay (copy)
			p9(CloseCentralOverlay())
		end
	}
end)(v48)
local v50 = RoactAppPolicy.connect(function(p12) -- line: 311
	return {
		shouldUseExternalBrowserForMorePageItem = p12.shouldUseExternalBrowserForMorePageItem
	}
end)(v49)
local v51 = RoactNavigation.withNavigation(v50)
local v52 = RoactAppPolicy.connect(function(p13) -- line: 319
	local v69 = p13.getWebViewSupport()
	local v70 = p13.getDisableIAPEntryPoint()

	return {
		disableWebViewSupport = not v69,
		disableIAPEntryPoint = v70
	}
end)(v51)
local u53 = RoactServices.connect({
	catalogAnalytics = Analytics,
	linking = AppLinking,
	eventIngest = AppEventIngestService
})(v52)

return function(p14) -- line: 334
	-- upvalues: useIsSpatial (copy), FFlagEnableMorePageDirectionalLayoutRolloutFix (copy), Responsive (copy), useDesignTokens (copy), IconSize (copy), Roact (copy), u53 (ref), Cryo (copy)
	local v72 = useIsSpatial()
	local v73 = if not FFlagEnableMorePageDirectionalLayoutRolloutFix then Responsive.usePreferredInput() == Responsive.Input.Directional else p14.isDirectional
	local t3 = nil

	if v73 then
		local v75 = useDesignTokens()
		local NavigationItemIconStyle = v75.LuaApps.More.NavigationItemIconStyle
		local NavigationItemTitleStyle = v75.LuaApps.More.NavigationItemTitleStyle
		local NavigationItemTitleFont = v75.LuaApps.More.NavigationItemTitleFont

		t3 = {
			iconStyle = NavigationItemIconStyle,
			iconSize = IconSize.Large,
			titleStyle = NavigationItemTitleStyle,
			titleFont = NavigationItemTitleFont
		}
	end

	local v79 = v72 or v73

	return Roact.createElement(u53, Cryo.Dictionary.join(p14, {
		shouldSkipWebViewCheck = v79,
		itemStyleProps = if not v73 then nil else t3
	}))
end
