local CorePackages = game:GetService("CorePackages")
local isTenFootInterface = require("@game/CorePackages/Workspace/Packages/AppCommonLib").isTenFootInterface
local UserInputService = game:GetService("UserInputService")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module = require("@luauforge/bundled/ehB")
local UrlBuilder = require(CorePackages.Packages.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local module2 = require("@luauforge/bundled/dFu")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local avatarRoute = AvatarExperienceNavigation.AvatarRoute.AvatarRoute
local overlay = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Components.Overlay

local module4 = require("@luauforge/deferred/gJH")
local module5 = require("@luauforge/bundled/dXh")
local module6 = require("@luauforge/bundled/fDf")
local module7 = require("@luauforge/deferred/gLe")
local assetTypeIdStringToName = require("@luauforge/bundled/dPN").AssetTypeIdStringToName
local closeCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/CentralOverlay").Thunks.CloseCentralOverlay

local module8 = require("@luauforge/bundled/dPN")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local fFlagEnableSplitPane = SharedFlags.FFlagEnableSplitPane

local v5 = if fFlagEnableSplitPane then require("@luauforge/bundled/fCo") else nil

local module10 = require("@luauforge/bundled/dPU")
local module11 = require("@luauforge/bundled/dVl")
local module12 = require("@luauforge/deferred/gLf")
local module13 = require("@luauforge/deferred/gLg")
local module14 = require("@luauforge/deferred/gLh")
local module15 = require("@luauforge/deferred/gLi")
local module16 = require("@luauforge/deferred/gLj")
local module17 = require("@luauforge/deferred/fBZ")
local impressionEnums = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").Enums.ImpressionEnums
local itemData = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").State.Selectors.ItemData
local module18 = require("@luauforge/deferred/gJI")
local module19 = require("@luauforge/bundled/fAe")
local module20 = require("@luauforge/deferred/gLl")
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dFz").NavigationCommands
else
	navigationCommands = nil
end

local module21 = require("@luauforge/deferred/gLn")
local module22 = require("@luauforge/bundled/egx")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module23 = require("@luauforge/bundled/dAB")
local module24 = require("@luauforge/bundled/dVn")

local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)
local module25 = require("@luauforge/deferred/gLo")
local module26 = require("@luauforge/deferred/gLp")

local contextualMenu = UIBlox.App.Menu.ContextualMenu
local menuDirection = UIBlox.App.Menu.MenuDirection
local images = UIBlox.App.ImageSet.Images
local withStyle = UIBlox.Style.withStyle

local module27 = require("@luauforge/deferred/gLq")
local getFFlagLuafiedReportEntryPoints = SharedFlags.GetFFlagLuafiedReportEntryPoints
local getFFlagEnableAbuseReport10ft = SharedFlags.GetFFlagEnableAbuseReport10ft
local fFlagEnableAbuseReportRevampFlow = SharedFlags.FFlagEnableAbuseReportRevampFlow
local defineFastFlag = game:DefineFastFlag("EnableAbuseReportRevampItem2", false)
local defineFastFlag2 = game:DefineFastFlag("EnableAbuseReportRevampUgcBundle", false)
local defineFastFlag3 = game:DefineFastFlag("MigrateConsoleToReportingRevampFlow", false)
local fFlagAXFixPurchaseSurfaceLogging = SharedFlags.FFlagAXFixPurchaseSurfaceLogging
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXItemDetailsSdui = AvatarExperienceFlags.FFlagAXItemDetailsSdui
local fFlagAXItemDetailsSduiFavorite = AvatarExperienceFlags.FFlagAXItemDetailsSduiFavorite

local module29 = require("@luauforge/deferred/gLr")
local module30 = require("@luauforge/deferred/gLs")

local tenFootInterface = isTenFootInterface()
local module31 = require("@luauforge/bundled/gJS")

local module32 = require("@luauforge/bundled/dFm")
local module33 = require("@luauforge/bundled/dzE")
local GetExperienceSourceLanguage = require("@game/CoreGui/RobloxGui/Modules/Feedback/Network/GetExperienceSourceLanguage")

local externalContentSharingProtocol = require("@luauforge/bundled/bZp").ExternalContentSharingProtocol

local platform = UserInputService:GetPlatform()
local v6 = platform == Enum.Platform.Windows
	or platform == Enum.Platform.OSX
	or platform == Enum.Platform.Linux
	or platform == Enum.Platform.UWP

local iconsactionsfavoriteOff = images["icons/actions/favoriteOff"]
local iconsactionsfavoriteOn = images["icons/actions/favoriteOn"]
local iconsmenucustomize = images["icons/menu/customize"]
local iconsmenushop = images["icons/menu/shop"]
local iconsactionsshare = images["icons/actions/share"]
local iconsactionsfeedback = images["icons/actions/feedback"]
local iconsmenulink = images["icons/menu/link"]
local iconsactionsinfo = images["icons/actions/info"]

local extended = Roact.PureComponent:extend("CatalogContextFrame")

local strictInterface = t.strictInterface
local v7 = {}
v7.itemId = t.string
v7.itemType = t.string
v7.onOverlayClosed = t.optional(t.callback)
v7.centered = t.optional(t.boolean)
v7.itemDetailsPeekViewRefs = t.optional(t.table)
v7.hideItemDetailsButtonVisible = t.optional(t.boolean)

v7.navigation = t.table

v7.avatarRoute = avatarRoute.Interface

v7.analytics = t.any
v7.networking = t.any

v7.namedRefs = t.table

v7.shouldShowShareButton = t.boolean
v7.shouldShareToProvider = t.boolean
v7.reportingDisabled = t.boolean
v7.webViewSupport = t.boolean
local v8 = if getFFlagLuafiedReportEntryPoints() or getFFlagEnableAbuseReport10ft() then t.boolean else nil
v7.useLuafiedReportFlow = v8

v7.favoritesFetchingState = t.any
v7.localUserId = t.string
v7.isFavorited = t.optional(t.boolean)
v7.itemData = t.optional(module7)
v7.screenSize = t.Vector2
v7.userHasMembership = t.boolean
local v9 = if module27() then t.optional(t.boolean) else nil
v7.isCollectiblesEnabled = v9
v7.collectiblesResaleRestriction = t.number
v7.itemSubType = t.optional(t.string)
v7.priceInRobux = t.optional(t.number)

v7.navigateDown = t.callback
v7.getAssetFavorite = t.callback
v7.getBundleFavorite = t.callback
v7.setAssetFavorite = t.callback
v7.setBundleFavorite = t.callback
v7.isPortrait = t.optional(t.boolean)
v7.getOrGenerateShortShareLink = t.callback
v7.externalContentSharingProtocol = t.any
v7.setCurrentToastMessage = t.callback
v7.openItemDetails = t.callback
v7.openAppItemDetails = t.callback
v7.reportBundle = t.callback
local v10 = if fFlagEnableAbuseReportRevampFlow then t.callback else nil
v7.openDynamicAbuseReport = v10
v7.closeCentralOverlay = t.callback

local v11 = if fFlagAXItemDetailsSdui and fFlagAXItemDetailsSduiFavorite then t.callback else nil
v7.toggleFavorite = v11
extended.validateProps = strictInterface(v7)

local function getIsFavorited(p2, p3)
	local v12 = nil
	local itemId = p3.itemId
	local itemType = p3.itemType

	if itemType == module8.ItemType.Asset then
		return p2.AvatarExperience.Catalog.AssetFavorites[itemId]
	end

	if itemType == module8.ItemType.Bundle then
		v12 = p2.AvatarExperience.Catalog.BundleFavorites[itemId]
	end

	return v12
end

local function getFavoritesFetchingState(p2, p3)
	local v12 = nil
	local itemId = p3.itemId
	local itemType = p3.itemType

	if itemType == module8.ItemType.Asset then
		v12 = module10.SetFavoriteAssetKey
	elseif itemType == module8.ItemType.Bundle then
		v12 = module10.SetFavoriteBundleKey
	end

	return performFetch.GetStatus(p2, v12 .. tostring(itemId))
end

function extended:init()
	if self.props.analytics then
		self.props.analytics.sendAXCounter(module8.Counter.ContextFrame.Open)
	end

	local binding, v12 = Roact.createBinding(UDim2.fromScale(1, 1))
	self.contextMenuSize = binding
	self.updateContextMenuSize = v12

	function self.goToAvatarPage()
		self.props.analytics.clickCustomizeItemButton(self.props.itemId, self.props.itemType)
		module5.navigateFromOverlay(self.props.navigation, avatarScreen.AvatarEditor)
	end

	function self.openSellPage()
		local itemId = self.props.itemId
		local itemType = self.props.itemType
		local userHasMembership = self.props.userHasMembership
		local navigation = self.props.navigation

		if not userHasMembership then
			module5.navigateToNextOverlay(navigation, avatarScreen.PremiumSellOnlyPrompt)
		elseif not module27() or self.props.isCollectiblesEnabled then
			local collectibleItemId = self.props.itemData.collectibleItemId
			module5.navigateFromOverlay(self.props.navigation, avatarScreen.ItemOwnershipPage, {
				itemId = itemId,
				collectibleItemId = collectibleItemId,
				itemType = itemType
			})
		else
			module5.navigateFromOverlay(self.props.navigation, avatarScreen.SellItemPage, {
				itemId = itemId,
				itemType = itemType
			})
		end
	end

	function self.favoriteItem()
		if fFlagAXItemDetailsSdui and fFlagAXItemDetailsSduiFavorite then
			self.props.toggleFavorite()
			return
		end

		local isFavorited = self.props.isFavorited

		if isFavorited == nil or self.props.favoritesFetchingState == module23.Fetching then
			return
		end

		local itemId = self.props.itemId
		local itemType = self.props.itemType
		local analytics = self.props.analytics

		if itemType == module8.ItemType.Asset then
			self.props.setAssetFavorite(itemId, not isFavorited)
		elseif itemType == module8.ItemType.Bundle then
			self.props.setBundleFavorite(itemId, not isFavorited)
		end

		analytics.clickFavoriteItemButton(itemId, itemType, not isFavorited)
	end

	function self.shareItemViaShortLink(callback, callback2, callback3)
		self.props.getOrGenerateShortShareLink(self.props.itemId, self.props.itemType):andThen(function(p2)
			if p2 and p2.responseBody and p2.responseBody.shortUrl then
				self.props.analytics.sendCounter(module8.Counter.GetOrGenerateShortShareLink.Success)

				if callback then
					callback()
				end

				self.openShareSheetOrCopyLink(p2.responseBody.shortUrl)
			else
				self.props.analytics.sendCounter(module8.Counter.GetOrGenerateShortShareLink.Invalid)

				if callback2 then
					callback2(p2)
				end

				self.shareItem()
			end
		end):catch(function(p2)
			self.props.analytics.sendCounter(module8.Counter.GetOrGenerateShortShareLink.Failure)

			if callback3 then
				callback3(p2)
			end

			self.shareItem()
		end)
	end

	function self.popupLinkCopiedToast()
		self.props.setCurrentToastMessage({
			toastMessage = "Feature.Catalog.Toast.LinkCopied",
			toastType = module33.SuccessConfirmation
		})

		self.props.analytics.sendCounter(module8.Counter.GetOrGenerateShortShareLink.LinkCopied)
	end

	function self.openShareSheetOrCopyLink(p2)
		self.props.analytics.clickShareItemButton(self.props.itemId, self.props.itemType)

		self.closePrompt()
		self.props.externalContentSharingProtocol:shareUrl({
			context = "CatalogMoreMenu",
			url = p2
		})
	end

	function self.shareItem()
		local appsflyer = urlBuilder.catalog.info.appsflyer({
			assetId = self.props.itemId,
			assetType = self.props.itemType
		})

		self.openShareSheetOrCopyLink(appsflyer)
	end

	function self.reportItem(p2)
		local navigation = self.props.navigation
		local itemId = self.props.itemId
		local itemType = self.props.itemType
		local itemData2 = self.props.itemData
		local localUserId = self.props.localUserId
		local v13 = module24.BASE_URL .. "abusereport/asset?id=" .. itemId

		local id = nil
		local name = nil
		local name2, description, assetType

		if itemData2 then
			if itemData2.creator then
				id = itemData2.creator.id
				name = itemData2.creator.name
			end

			name2 = itemData2.name
			description = itemData2.description
			assetType = itemData2.assetType
		end

		if itemType == module8.ItemType.Bundle then
			if fFlagEnableAbuseReportRevampFlow and defineFastFlag2 then
				self.props.openDynamicAbuseReport({
					abuseVector = module25.UgcBundle,
					targetId = itemId,
					onClose = function()
						self.props.closeCentralOverlay()
					end
				})
			else
				self.props.reportBundle(
					self.props.networking,
					itemId,
					platform,
					DateTime.now().UnixTimestampMillis
				)
			end

			self.closePrompt()
		elseif defineFastFlag3 or not self.props.useLuafiedReportFlow then
			if not defineFastFlag3 and tenFootInterface then
				module5.navigateToNextOverlay(navigation, avatarScreen.CatalogReport, {
					userId = localUserId,
					itemId = itemId,
					itemCreatorId = id,
					itemName = name2,
					itemDescription = description
				})
				return
			end

			if fFlagEnableAbuseReportRevampFlow and defineFastFlag then
				self.props.openDynamicAbuseReport({
					abuseVector = module25.Accessory,
					targetId = itemId,
					onClose = function()
						self.props.closeCentralOverlay()
					end,
					custom = { assetTypeName = assetTypeIdStringToName[assetType] }
				})
				return
			end

			self.closePrompt()
			self.props.navigateDown({
				name = module2.GenericWebPage,
				detail = v13,
				extraProps = { title = p2 }
			})
		elseif getFFlagEnableAbuseReport10ft() and tenFootInterface then
			self.props.navigateDown({
				name = module2.ReportScreen,
				reportData = {
					assetId = itemId,
					platform = module10.ReportScreen.Platforms.Console,
					context = module10.ReportScreen.Contexts.Item,
					reportAbuseVector = assetTypeIdStringToName[assetType]
				}
			})
		else
			module5.navigateToNextOverlay(navigation, avatarScreen.ReportDialog, {
				userId = localUserId,
				itemId = itemId,
				itemCreatorId = id,
				itemCreatorName = name,
				itemName = name2,
				itemDescription = description,
				assetTypeName = assetTypeIdStringToName[assetType]
			})
		end
	end

	function self.closePrompt()
		module5.closeOverlay(self.props.navigation)
	end

	function self.onViewDetailsPageActivate()
		self.props.analytics.sendAXCounter(module8.Counter.ContextFrame.ViewDetailsPageClick)
		self.closePrompt()

		if self.props.avatarRoute.current.name ~= avatarScreen.TryOnItem then
			self.props.openItemDetails({
				itemId = self.props.itemId,
				itemType = self.props.itemType,
				itemSubType = self.props.itemSubType,
				priceInRobux = self.props.priceInRobux,
				showFullWithNoPeekView = true,
				closePreviousItemDetails = true,
				avatarRoute = self.props.avatarRoute,
				navigation = self.props.navigation,
				resultsListRef = self.props.namedRefs[self.props.avatarRoute.opaque.name .. module21.ItemsList],
				itemDetailsPeekViewRefs = self.props.itemDetailsPeekViewRefs,
				catalogAnalytics = self.props.analytics
			})
		elseif fFlagAXFixPurchaseSurfaceLogging then
			self.props.openAppItemDetails(
				self.props.itemId,
				self.props.itemType,
				true,
				true,
				impressionEnums.MarketplaceSurfaceType.USER_PROFILE
			)
		else
			self.props.openAppItemDetails(self.props.itemId, self.props.itemType, true)
		end
	end
end

function extended.didMount(p2)
	if fFlagAXItemDetailsSdui and fFlagAXItemDetailsSduiFavorite then
		return
	end

	if p2.props.isFavorited == nil then
		local itemId = p2.props.itemId
		local itemType = p2.props.itemType

		if itemType == module8.ItemType.Asset then
			p2.props.getAssetFavorite(itemId)
		elseif itemType == module8.ItemType.Bundle then
			p2.props.getBundleFavorite(itemId)
		end
	end
end

function extended:renderWithProviders(props2, p2)
	local centered = self.props.centered
	local itemType = self.props.itemType
	local itemData2 = self.props.itemData
	local isFavorited = self.props.isFavorited
	local screenSize = self.props.screenSize
	local name = self.props.avatarRoute.opaque.name
	local v12 = self.props.userHasMembership
	local reportingDisabled = self.props.reportingDisabled
	local collectiblesResaleRestriction = self.props.collectiblesResaleRestriction
	local name2 = self.props.avatarRoute.current.name

	local v14 = not ((itemData2.creator and itemData2.creator.id) == "1") and not reportingDisabled
	local isResellable = module11.IsResellable(itemData2)

	local unfavoriteLabel = isFavorited and props2.unfavoriteLabel or props2.favoriteLabel
	local reportLabel = props2.reportLabel

	local v15 = {}

	local isOwned = itemData2.isOwned

	if isOwned and name ~= avatarScreen.AvatarEditor then
		table.insert(v15, {
			icon = iconsmenucustomize,
			text = props2.customizeLabel,
			onActivated = self.goToAvatarPage
		})
	end

	if name2 ~= avatarScreen.ItemDetails and not self.props.hideItemDetailsButtonVisible then
		table.insert(v15, {
			icon = iconsactionsinfo,
			text = props2.viewDetailsPageLabel,
			onActivated = self.onViewDetailsPageActivate
		})
	end

	table.insert(v15, {
		icon = isFavorited and iconsactionsfavoriteOn or iconsactionsfavoriteOff,
		text = unfavoriteLabel,
		onActivated = self.favoriteItem
	})

	if not tenFootInterface or v12 then
		v12 = collectiblesResaleRestriction ~= module10.ResaleRestriction.Disabled
	end

	if isOwned and isResellable and v12 then
		table.insert(v15, {
			icon = iconsmenushop,
			text = props2.sellLabel,
			onActivated = self.openSellPage
		})
	end

	local webViewSupport = self.props.shouldShowShareButton
		and not tenFootInterface
		and self.props.webViewSupport
	local v16 = v6

	if webViewSupport then
		if not self.props.shouldShareToProvider then
			table.insert(v15, {
				icon = iconsactionsshare,
				text = props2.shareLabel,
				onActivated = function()
					self.shareItemViaShortLink()
				end
			})
		end
	elseif v16 then
		table.insert(v15, {
			icon = iconsmenulink,
			onActivated = function()
				self.shareItemViaShortLink(
					self.popupLinkCopiedToast,
					self.popupLinkCopiedToast,
					self.popupLinkCopiedToast
				)
			end,
			text = props2.copyLink
		})
	end

	local v17 = itemType == module8.ItemType.Asset
	local v18 = itemType == module8.ItemType.Bundle
	local useLuafiedReportFlow = self.props.useLuafiedReportFlow or self.props.webViewSupport or v18

	if v14 and (v17 or v18) and useLuafiedReportFlow then
		table.insert(v15, {
			icon = iconsactionsfeedback,
			text = reportLabel,
			onActivated = function()
				self.reportItem(reportLabel)
			end
		})
	end

	local isPortrait = self.props.isPortrait
	local v19

	if isPortrait then
		v19 = 0
	else
		v19 = if fFlagEnableSplitPane then v5.getLandscapeNavWidth() else module8.LandscapeNavWidth
	end

	local v20

	if isPortrait then
		v20 = 1
	else
		v20 = if fFlagEnableSplitPane then v5.getLandscapeSceneWidth() else module8.LandscapeSceneWidth
	end

	local udim, udim2

	if centered and not isPortrait then
		local v21 = math.min(screenSize.X, 640)
		udim = UDim2.fromOffset((screenSize.X - v21) / 2, 0)
		udim2 = UDim2.new(0, v21, 1, 0)
	else
		udim = UDim2.fromScale(v19, 0)
		udim2 = UDim2.fromScale(v20, 1)
	end

	if centered then
		udim = UDim2.fromScale(0.5, 0)
	end

	local createElement = Roact.createElement

	local v23 = if centered then Vector2.new(0.5, 0) else nil
	return createElement(
		overlay,
		{ BackgroundTransparency = 1, Position = udim, Size = udim2, AnchorPoint = v23 },
		{
			SizeFrame = self:renderInnerFrame(v15, -76, p2)
		}
	)
end

function extended:renderInnerFrame(p3, p4, p5)
	local tokens = p5.Tokens

	return Roact.createElement(
		"Frame",
		{
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0),
			Size = UDim2.fromScale(1, 1)
		},
		{
			ContextMenuPadding = Roact.createElement("UIPadding", {
				PaddingRight = UDim.new(0, tokens.Size.Size_600),
				PaddingLeft = UDim.new(0, tokens.Size.Size_600)
			}),
			ContextMenu = Roact.createElement(contextualMenu, {
				buttonProps = p3,
				open = true,
				menuDirection = menuDirection.Up,
				openPositionY = UDim.new(1, p4),
				closeBackgroundVisible = true,
				screenSize = self.props.screenSize,
				contextMenuWidthOverride = UDim.new(1, 0),
				onDismiss = self.closePrompt
			})
		}
	)
end

function extended:render()
	if self.props.itemData then
		return withStyle(function(p2)
			return withLocalization({
				copyLink = "Feature.Catalog.Action.CopyLink",
				customizeLabel = "Feature.Catalog.Action.Customize",
				favoriteLabel = "Feature.Catalog.Action.Favorite",
				unfavoriteLabel = "Feature.Catalog.Action.RemoveFavorite",
				sellLabel = "Feature.Catalog.Action.Sell",
				shareLabel = "Feature.SocialShare.Action.Share",
				reportLabel = "Feature.Catalog.Action.Report",
				viewDetailsPageLabel = "Feature.Catalog.Action.ViewDetailsPage"
			})(function(p3)
				return self:renderWithProviders(p3, p2)
			end)
		end)
	end
end

local function CatalogContextFrameWrapper(props)
	local clone = table.clone(props)

	local v12 = module30(props.itemId, props.itemType, props.analytics)
	clone.isFavorited = v12.isFavorited
	clone.toggleFavorite = v12.toggleFavorite

	return Roact.createElement(extended, clone)
end

if fFlagAXItemDetailsSdui then
	if not fFlagAXItemDetailsSduiFavorite then
		CatalogContextFrameWrapper = extended
	end
else
	CatalogContextFrameWrapper = extended
end

local v12 = RoactRodux.connect(function(data, p2)
	local itemId = p2.itemId
	local itemType = p2.itemType
	local v13 = itemData(data.AvatarExperience.Common, itemId, itemType)
	local itemSubType = module11.GetItemSubType(itemType, v13)
	local priceInRobux = v13 and v13.priceInRobux
	local user = data.Users[data.LocalUserId]
	local membership = user and user.membership
	local collectibleItemId = if v13 then v13.collectibleItemId else nil
	local v14

	if collectibleItemId then
		v14 = data.AvatarExperience.Common.Collectibles.CollectiblesItemInfo[collectibleItemId]
	end

	local v15 = if v14 then v14.resaleRestriction else module10.ResaleRestriction.None
	local v17 = nil
	local itemId2 = p2.itemId
	local itemType2 = p2.itemType

	if itemType2 == module8.ItemType.Asset then
		v17 = module10.SetFavoriteAssetKey
	elseif itemType2 == module8.ItemType.Bundle then
		v17 = module10.SetFavoriteBundleKey
	end

	local v16 = {
		favoritesFetchingState = performFetch.GetStatus(data, v17 .. tostring(itemId2)),
		localUserId = data.LocalUserId,
		isFavorited = 0,
		itemData = 0,
		screenSize = 0,
		userHasMembership = 0,
		isCollectiblesEnabled = 0,
		isPortrait = 0,
		collectiblesResaleRestriction = 0,
		externalContentSharingProtocol = 0,
		itemSubType = 0,
		priceInRobux = 0
	}
	local v18 = nil
	local itemId3 = p2.itemId
	local itemType3 = p2.itemType

	if itemType3 == module8.ItemType.Asset then
		v18 = data.AvatarExperience.Catalog.AssetFavorites[itemId3]
	elseif itemType3 == module8.ItemType.Bundle then
		v18 = data.AvatarExperience.Catalog.BundleFavorites[itemId3]
	end

	v16.isFavorited = v18
	v16.itemData = v13
	v16.screenSize = data.ScreenSize
	v16.userHasMembership = membership ~= Enum.MembershipType.None
	local v19 = if module27() then data.AvatarExperience.Catalog.Metadata.isCollectiblesEnabled else nil
	v16.isCollectiblesEnabled = v19

	v16.isPortrait = module31(data)
	v16.collectiblesResaleRestriction = v15
	v16.externalContentSharingProtocol = externalContentSharingProtocol.default
	v16.itemSubType = itemSubType
	v16.priceInRobux = priceInRobux
	return v16
end, function(callback)
	local v13 = {
		navigateDown = function(p2)
			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(p2))
			else
				callback(module(p2))
			end
		end,
		getBundleFavorite = function(p2)
			callback(module14(p2))
		end,
		getAssetFavorite = function(p2)
			callback(module12(p2))
		end,
		setAssetFavorite = function(p2, p3)
			callback(module13(p2, p3))
		end,
		setBundleFavorite = function(p2, p3)
			callback(module15(p2, p3))
		end,
		getOrGenerateShortShareLink = function(p2, p3)
			return callback(GetExperienceSourceLanguage.GetOrGenerateShortShareLink(p2, p3))
		end,
		setCurrentToastMessage = function(p2)
			return callback(module32(p2))
		end,
		openItemDetails = function(p2)
			callback(module16(p2))
		end,
		openAppItemDetails = 0,
		reportBundle = 0,
		openDynamicAbuseReport = 0,
		closeCentralOverlay = 0
	}
	local v14

	if fFlagAXFixPurchaseSurfaceLogging then
		v14 = function(p2, p3, p4, p5, p6)
			callback(module17(p2, p3, p4, p5, p6))
		end
	else
		v14 = function(p2, p3, p4)
			callback(module17(p2, p3, p4))
		end
	end

	v13.openAppItemDetails = v14

	function v13.reportBundle(p2, p3, p4, p5)
		callback(module29(p2, p3, p4, p5))
	end
	v13.openDynamicAbuseReport = fFlagEnableAbuseReportRevampFlow and function(p2)
		callback(module26(p2))
	end or nil

	function v13.closeCentralOverlay()
		callback(closeCentralOverlay())
	end

	return v13
end)(CatalogContextFrameWrapper)

local v13 = roactServices.connect({ analytics = module6, networking = module22 })(v12)

return (module20((module4((module19((module18((roactAppPolicy.connect(function(data, p2)
	local v14 = {
		shouldShowShareButton = data.shouldShowCatalogShareButton(),
		shouldShareToProvider = data.shouldShareToAccountProvider(),
		reportingDisabled = data.getCatalogReportingDisabled(),
		webViewSupport = data.getWebViewSupport(),
		useLuafiedReportFlow = 0
	}
	local v15 = if getFFlagLuafiedReportEntryPoints() or getFFlagEnableAbuseReport10ft() then data.getUseLuafiedReportFlow() else nil
	v14.useLuafiedReportFlow = v15
	return v14
end)(v13))))))))))
