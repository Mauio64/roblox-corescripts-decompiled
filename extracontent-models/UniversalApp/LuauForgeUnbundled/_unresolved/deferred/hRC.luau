local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local menuTile = UIBlox.App.Tile.MenuTile
local Cryo = require(CorePackages.Packages.Cryo)
local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging
local iconSize = UIBlox.App.ImageSet.Enum.IconSize
local validateColorInfo = UIBlox.Style.Validator.validateColorInfo
local validateFontInfo = UIBlox.Style.Validator.validateFontInfo
local validateTypographyInfo = UIBlox.Style.Validator.validateTypographyInfo

local module = require("@luauforge/bundled/dFu")
local module2 = require("@luauforge/bundled/fDf")
local module3 = require("@luauforge/deferred/fFQ")
local module4 = require("@luauforge/deferred/hRD")
local module5 = require("@luauforge/bundled/ehB")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dFz").NavigationCommands
else
	navigationCommands = nil
end

local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module6 = require("@luauforge/bundled/ecr")
local appLinking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppLinking
local module7 = require("@luauforge/bundled/egZ")
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local module8 = require("@luauforge/deferred/fGi")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local module9 = require("@luauforge/bundled/dFm")
local module10 = require("@luauforge/bundled/dzD")
local module11 = require("@luauforge/bundled/fAJ")
local OpenCentralOverlayForUnifiedPurchasePrompt = require("@game/CorePackages/Workspace/Packages/_Index/PurchasePromptLite/PurchasePromptLite/State/Thunks/OpenCentralOverlayForUnifiedPurchasePrompt")
local module13 = require("@luauforge/bundled/fCM")
local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")
local useIsSpatial = require("@game/CorePackages/Workspace/Packages/Responsive").useIsSpatial
local module15 = require("@luauforge/deferred/hRF")
local sources = require("@luauforge/bundled/ecs").Analytics.Enums.Sources
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens

local linkingProtocol = require("@luauforge/bundled/bZe").LinkingProtocol
local fFlagCreateConnectionsHub = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagCreateConnectionsHub
local fFlagEnableArgus = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableArgus
local fFlagEnableArgusImmersiveNav = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableArgusImmersiveNav
local module16 = require("@luauforge/deferred/hRG")

local fFlagEnableMorePageDirectionalLayoutRolloutFix = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableMorePageDirectionalLayoutRolloutFix
local fFlagBlackbirdRequiresIAP = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagBlackbirdRequiresIAP
local fFlagEnableBlackbird = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableBlackbird

local fFlagEnableBlackbirdOnMorePage = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableBlackbirdOnMorePage
local fFlagUnifyConsoleSettingsPage = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUnifyConsoleSettingsPage
local Foundation2

if fFlagEnableBlackbird and fFlagEnableBlackbirdOnMorePage then
	Foundation2 = require(CorePackages.Packages.Foundation)
else
	Foundation2 = nil
end

local extended = Roact.PureComponent:extend("MoreGridItem")

local strictInterface = t.strictInterface
local v5 = {
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
	isDirectional = 0,
	itemStyleProps = 0
}
local v6 = if fFlagEnableMorePageDirectionalLayoutRolloutFix then t.boolean else nil
v5.isDirectional = v6
v5.itemStyleProps = t.optional(t.strictInterface({
	iconStyle = t.optional(validateColorInfo),
	iconSize = t.optional(iconSize.isEnumValue),
	titleStyle = t.optional(validateColorInfo),
	titleFont = t.optional(t.union(validateFontInfo, validateTypographyInfo))
}))
extended.validateProps = strictInterface(v5)

extended.defaultProps = { linkingProtocol = linkingProtocol.default }

function extended:init()
	function self.navigateDown(options)
		local item = self.props.item
		local v7 = item.context.url
		local titleKey = item.context.titleKey

		if item.urlGenerator then
			local localUserId = self.props.localUserId
			v7 = item.urlGenerator(localUserId)
		end

		local v8 = if item.getSearchParams then item.getSearchParams(self.props.formFactor) else nil

		local v9 = (titleKey or v8) and { titleKey = titleKey, searchParams = v8 } or nil

		local v10 = item.shouldOpenInExternalBrowser
			and self.props.shouldUseExternalBrowserForMorePageItem()
		local v11

		if self.props.disableWebViewSupport == true then
			v11 = item.context.fallbackToExternalBrowser == true
		else
			v11 = false
		end

		local appURI = item.context.appURI

		if appURI then
			self.props.linkingProtocol:isURLRegistered(appURI):andThen(function(p2)
				if p2 then
					if self.props.linkingProtocol:isInternalDlicEnabled() then
						local internalDlic = self.props.linkingProtocol:createInternalDlic(
							appURI,
							self.props.linkingProtocol.DeepLinkSource.LuaInternal
						)

						self.props.linkingProtocol:detectDeeplinkIntent(internalDlic)
					else
						self.props.linkingProtocol:detectURL(appURI)
					end
				end
			end)
			return
		end

		if v10 or v11 then
			module8(self.props.linking, v7)
			return
		end

		local v12 = module4({
			isMomentsDestination = item.context.page == module.Moments,
			isRmTile = item.itemType == module3.ItemType.RM
		})

		if fFlagCreateConnectionsHub and item.itemType == module3.ItemType.Friends then
			self.props.navigation.navigate(item.context.page)
		elseif
			fFlagEnableArgus
			and fFlagEnableArgusImmersiveNav
			and item.context.page == module.Moments
		then
			self.props.navigateDown({
				name = module.MomentsImmersive,
				source = "flyout_menu"
			})
		elseif v12 == "tab" then
			self.props.navigation.navigate(item.context.page, { source = "flyout_menu" })
		elseif item.itemType == module3.ItemType.Catalog then
			self.props.navigation.navigate(avatarScreen.Catalog)
		elseif item.itemType == module3.ItemType.OfficialStore then
			self.props.openLeaveRobloxAlertUIBlox(self.openUrl)
		elseif item.itemType == module3.ItemType.ReportLogs then
			self.props.openReportLogConfirmation()
		else
			self.props.navigateDown({
				name = item.context.page,
				detail = v7,
				extraProps = Cryo.Dictionary.join(v9 or {}, options or {})
			})
		end
	end

	function self.openUrl()
		local url = self.props.item.context.url
		self.props.linking:openURL(url):andThen(function(p2)
			if p2 == false then
				logging.warn("LinkingProtocol:openURL failed for offical amazon store.")
			end
		end)
		self.props.closeAlert()
	end

	function self.onActivated()
		local catalogAnalytics = self.props.catalogAnalytics
		local item = self.props.item

		local v7 = nil

		if not self.props.shouldSkipWebViewCheck then
			local v8 = not fFlagUnifyConsoleSettingsPage

			if v8 then
				v8 = item.itemType == module3.ItemType.Settings and self.props.disableWebViewSupport
			end

			local v9 = item.itemType == module3.ItemType.BuildersClub and self.props.disableIAPEntryPoint
			local v10 = fFlagBlackbirdRequiresIAP

			if v10 then
				v10 = item.itemType == module3.ItemType.Blackbird and self.props.disableIAPEntryPoint
			end

			if v8 or v9 or v10 then
				self.props.showWebViewNotAvailableToastMessage()
				return
			end
		end

		if item.itemType == module3.ItemType.Catalog then
			catalogAnalytics.moreMenuToCatalogButton()
		end

		if item.itemType == module3.ItemType.Friends then
			module15({ context = "morePage", localUserId = self.props.localUserId })

			v7 = {
				navigateToFriendsLandingEventStart = {
					startPage = module.More,
					startTime = os.clock()
				}
			}
		end

		local v8 = item.itemType == module3.ItemType.Profile and {
			source = sources.MorePageTile
		} or v7

		local v9 = item.itemType == module3.ItemType.RM and { source = "flyout_menu" } or v8

		self.navigateDown(v9)

		self.props.eventIngest:sendEventDeferred("moreGridItem", "moreGridItemClick", {
			itemType = item.itemType,
			url = item.context.url,
			localUserId = self.props.localUserId
		})
	end
end

function extended.render(p2)
	local item = p2.props.item
	local badgeCount = item.badgeCount
	local icon = item.icon
	local layoutOrder = p2.props.layoutOrder
	local textKey = item.textKey
	local itemStyleProps = p2.props.itemStyleProps

	local v7 = fFlagEnableBlackbird and fFlagEnableBlackbirdOnMorePage

	if v7 then
		v7 = typeof(icon) == "table" and icon.isFoundationIcon == true
	end

	local v8 = v7 and "" or icon
	return module7({ title = textKey })(function(p3)
		local element = Roact.createElement(menuTile, {
			badgeValue = badgeCount > 0 and badgeCount or nil,
			icon = v8,
			layoutOrder = layoutOrder,
			onActivated = function()
				p2.onActivated()
			end,
			title = p3.title,
			styleProps = itemStyleProps
		})

		if v7 then
			return Roact.createElement(
				"Frame",
				{
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					LayoutOrder = layoutOrder
				},
				{
					MenuTileBase = element,
					FoundationIcon = Roact.createElement(Foundation2.Icon, {
						name = icon.name,
						size = 48,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.38),
						ZIndex = 10
					})
				}
			)
		end

		return element
	end)
end

local v7 = RoactRodux.connect(function(p2, p3)
	return { formFactor = p2.FormFactor, localUserId = p2.LocalUserId }
end, function(callback)
	return {
		navigateDown = function(p2)
			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(p2))
			else
				callback(module5(p2))
			end
		end,
		showWebViewNotAvailableToastMessage = function()
			callback(module9(module10.WEBVIEWS_UNAVAILABLE_TOAST))
		end,
		openLeaveRobloxAlertUIBlox = function(p2)
			callback(module11(p2))
		end,
		openReportLogConfirmation = function()
			callback(OpenCentralOverlayForUnifiedPurchasePrompt())
		end,
		closeAlert = function()
			callback(module13())
		end
	}
end)(extended)

local v8 = roactAppPolicy.connect(function(p2)
	return {
		shouldUseExternalBrowserForMorePageItem = p2.shouldUseExternalBrowserForMorePageItem
	}
end)(v7)

local v9 = RoactNavigation.withNavigation(v8)

local v10 = roactAppPolicy.connect(function(p2)
	return {
		disableWebViewSupport = not p2.getWebViewSupport(),
		disableIAPEntryPoint = p2.getDisableIAPEntryPoint()
	}
end)(v9)

local v11 = roactServices.connect({
	catalogAnalytics = module2,
	linking = appLinking,
	eventIngest = module6
})(v10)

return function(p2)
	local v12 = useIsSpatial()
	local v13 = useTokens()
	local v14

	if fFlagEnableMorePageDirectionalLayoutRolloutFix then
		v14 = p2.isDirectional
	else
		v14 = Responsive.usePreferredInput() == Responsive.Input.Directional
	end

	local v15

	if v14 and not module16 then
		local v16 = useDesignTokens()
		local navigationItemIconStyle = v16.LuaApps.More.NavigationItemIconStyle
		local navigationItemTitleStyle = v16.LuaApps.More.NavigationItemTitleStyle
		local navigationItemTitleFont = v16.LuaApps.More.NavigationItemTitleFont
		v15 = {
			iconStyle = navigationItemIconStyle,
			iconSize = iconSize.Large,
			titleStyle = navigationItemTitleStyle,
			titleFont = navigationItemTitleFont
		}
	else
		v15 = { titleFont = v13.Typography.TitleLarge }
	end

	return Roact.createElement(v11, Cryo.Dictionary.join(p2, {
		shouldSkipWebViewCheck = v12 or v14,
		itemStyleProps = v15
	}))
end
