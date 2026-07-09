local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local UrlBuilder = require(CorePackages.Packages.UrlBuilder).UrlBuilder
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local AppPage = require(Modules.LuaApp.AppPage)
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local AvatarRoute = AvatarExperienceNavigation.AvatarRoute.AvatarRoute
local Overlay = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Components.Overlay
local withMappedNavigationParams = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withMappedNavigationParams)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local ItemDataValidator = require(Modules.AvatarExperience.Common.Validators.ItemDataValidator)
local AssetTypeIdStringToName = require(Modules.AvatarExperience.Common.Constants).AssetTypeIdStringToName
local CloseCentralOverlay = require(CorePackages.Workspace.Packages.CentralOverlay).Thunks.CloseCentralOverlay
local Constants = require(Modules.AvatarExperience.Common.Constants)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local GetAssetFavorite = require(Modules.AvatarExperience.Catalog.Thunks.GetAssetFavorite)
local SetAssetFavorite = require(Modules.AvatarExperience.Catalog.Thunks.SetAssetFavorite)
local GetBundleFavorite = require(Modules.AvatarExperience.Catalog.Thunks.GetBundleFavorite)
local SetBundleFavorite = require(Modules.AvatarExperience.Catalog.Thunks.SetBundleFavorite)
local OpenItemDetails = require(Modules.AvatarExperience.Common.Thunks.OpenItemDetails)
local OpenAppItemDetails = require(Modules.AvatarExperience.Common.Thunks.OpenAppItemDetails)
local ImpressionEnums = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).Enums.ImpressionEnums
local ItemData = require(Modules.AvatarExperience.Common.Selectors.ItemData)
local withOverlayFocusHandling = require(Modules.AvatarExperience.Common.Components.withOverlayFocusHandling)
local withAvatarRoute = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withAvatarRoute)
local withNamedRefs = require(Modules.AvatarExperience.Common.Context.withNamedRefs)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local v39 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local FFlagRenameDeprecatedUIBloxTokens = SharedFlags.FFlagRenameDeprecatedUIBloxTokens
local NamedRefConstants = require(Modules.AvatarExperience.Common.NamedRefConstants)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local RetrievalStatus = require(Modules.LuaApp.Enum.RetrievalStatus)
local Url = require(Modules.LuaApp.Http.Url)
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)
local AbuseVector = require(CorePackages.Workspace.Packages.GenericAbuseReporting.AbuseVector)
local OpenDynamicAbuseReport = require(CorePackages.Workspace.Packages.GenericAbuseReporting.OpenDynamicAbuseReport)
local ContextualMenu = UIBlox.App.Menu.ContextualMenu
local MenuDirection = UIBlox.App.Menu.MenuDirection
local Images = UIBlox.App.ImageSet.Images
local withStyle = UIBlox.Style.withStyle
local GetFFlagRestrictLimited2ToSoothsayers = require(Modules.AvatarExperience.Flags.GetFFlagRestrictLimited2ToSoothsayers)
local GetFFlagLuafiedReportEntryPoints = SharedFlags.GetFFlagLuafiedReportEntryPoints
local GetFFlagEnableAbuseReport10ft = SharedFlags.GetFFlagEnableAbuseReport10ft
local GetFFlagFixCatalogContextItemReportURLConstruction = SharedFlags.GetFFlagFixCatalogContextItemReportURLConstruction
local FFlagEnableAbuseReportRevampFlow = SharedFlags.FFlagEnableAbuseReportRevampFlow
local v59 = game:DefineFastFlag("EnableAbuseReportRevampItem2", false)
local v60 = game:DefineFastFlag("EnableAbuseReportRevampUgcBundle", false)
local v61 = game:DefineFastFlag("AXOpenAppItemDetailsOnTryOnPage", false)
local v62 = game:DefineFastFlag("MigrateConsoleToReportingRevampFlow", false)
local FFlagAXFixPurchaseSurfaceLogging = SharedFlags.FFlagAXFixPurchaseSurfaceLogging
local ReportBundle = require(Modules.AvatarExperience.Catalog.Thunks.ReportBundle)
local v65 = GuiService:IsTenFootInterface()
local selectIsPortrait = require(Modules.AvatarExperience.Common.Selectors.selectIsPortrait)
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local ToastType = require(Modules.LuaApp.Enum.ToastType)
local WebApi = require(Modules.AvatarExperience.Catalog.Http.WebApi)
local ExternalContentSharingProtocol = require(CorePackages.Workspace.Packages.ExternalContentSharingProtocol).ExternalContentSharingProtocol
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local Platform = UserInputService:GetPlatform()
local v73 = Platform == Enum.Platform.Windows or (Platform == Enum.Platform.OSX or (Platform == Enum.Platform.Linux or Platform == Enum.Platform.UWP))
local v74 = Images["icons/actions/favoriteOff"]
local v75 = Images["icons/actions/favoriteOn"]
local v76 = Images["icons/menu/customize"]
local v77 = Images["icons/menu/shop"]
local v78 = Images["icons/actions/share"]
local v79 = Images["icons/actions/feedback"]
local v80 = Images["icons/menu/link"]
local v81 = Images["icons/actions/info"]
local v82 = Roact.PureComponent:extend("CatalogContextFrame")

v82.validateProps = t.strictInterface({
	itemId = t.string,
	itemType = t.string,
	onOverlayClosed = t.optional(t.callback),
	centered = t.optional(t.boolean),
	itemDetailsPeekViewRefs = t.optional(t.table),
	hideItemDetailsButtonVisible = t.optional(t.boolean),
	navigation = t.table,
	avatarRoute = AvatarRoute.Interface,
	analytics = t.any,
	networking = t.any,
	namedRefs = t.table,
	shouldShowShareButton = t.boolean,
	shouldShareToProvider = t.boolean,
	reportingDisabled = t.boolean,
	webViewSupport = t.boolean,
	useLuafiedReportFlow = if not GetFFlagLuafiedReportEntryPoints() and not GetFFlagEnableAbuseReport10ft() then nil else t.boolean,
	favoritesFetchingState = t.any,
	localUserId = t.string,
	isFavorited = t.optional(t.boolean),
	itemData = t.optional(ItemDataValidator),
	screenSize = t.Vector2,
	userHasMembership = t.boolean,
	isCollectiblesEnabled = if not GetFFlagRestrictLimited2ToSoothsayers() then nil else t.optional(t.boolean),
	collectiblesResaleRestriction = t.number,
	itemSubType = t.optional(t.string),
	priceInRobux = t.optional(t.number),
	navigateDown = t.callback,
	getAssetFavorite = t.callback,
	getBundleFavorite = t.callback,
	setAssetFavorite = t.callback,
	setBundleFavorite = t.callback,
	isPortrait = t.optional(t.boolean),
	getOrGenerateShortShareLink = t.callback,
	externalContentSharingProtocol = t.any,
	setCurrentToastMessage = t.callback,
	openItemDetails = t.callback,
	openAppItemDetails = if not v61 then nil else t.callback,
	reportBundle = t.callback,
	openDynamicAbuseReport = if not FFlagEnableAbuseReportRevampFlow then nil else t.callback,
	closeCentralOverlay = t.callback
})

local function getIsFavorited(p1, p2) -- line: 179
	-- upvalues: Constants (copy)
	local v90 = nil
	local itemId = p2.itemId
	local itemType = p2.itemType

	if itemType == Constants.ItemType.Asset then
		return p1.AvatarExperience.Catalog.AssetFavorites[itemId]
	end

	if itemType == Constants.ItemType.Bundle then
		v90 = p1.AvatarExperience.Catalog.BundleFavorites[itemId]
	end

	return v90
end
local function getFavoritesFetchingState(p3, p4) -- line: 191
	-- upvalues: Constants (copy), CatalogConstants (copy), PerformFetch (copy)
	local SetFavoriteAssetKey = nil
	local itemId = p4.itemId
	local itemType = p4.itemType

	if itemType == Constants.ItemType.Asset then
		SetFavoriteAssetKey = CatalogConstants.SetFavoriteAssetKey
	elseif itemType == Constants.ItemType.Bundle then
		SetFavoriteAssetKey = CatalogConstants.SetFavoriteBundleKey
	end

	return PerformFetch.GetStatus(p3, SetFavoriteAssetKey .. tostring(itemId))
end

function v82.init(p5) -- line: 203
	-- upvalues: Constants (copy), Roact (copy), NavigationUtils (copy), AvatarScreen (copy), GetFFlagRestrictLimited2ToSoothsayers (copy), RetrievalStatus (copy), ToastType (copy), UrlBuilder (copy), GetFFlagFixCatalogContextItemReportURLConstruction (copy), Url (copy), FFlagEnableAbuseReportRevampFlow (copy), v60 (copy), AbuseVector (copy), Platform (copy), v62 (copy), GetFFlagEnableAbuseReport10ft (copy), v65 (copy), AppPage (copy), CatalogConstants (copy), AssetTypeIdStringToName (copy), v59 (copy), v61 (copy), FFlagAXFixPurchaseSurfaceLogging (copy), ImpressionEnums (copy), NamedRefConstants (copy)
	if p5.props.analytics then
		p5.props.analytics.sendAXCounter(Constants.Counter.ContextFrame.Open)
	end

	local v99, v100 = Roact.createBinding(UDim2.fromScale(1, 1))

	p5.contextMenuSize = v99
	p5.updateContextMenuSize = v100

	function p5.goToAvatarPage() -- line: 211
		-- upvalues: p5 (copy), NavigationUtils (copy), AvatarScreen (copy)
		p5.props.analytics.clickCustomizeItemButton(p5.props.itemId, p5.props.itemType)
		NavigationUtils.navigateFromOverlay(p5.props.navigation, AvatarScreen.AvatarEditor)
	end
	function p5.openSellPage() -- line: 216
		-- upvalues: p5 (copy), GetFFlagRestrictLimited2ToSoothsayers (copy), NavigationUtils (copy), AvatarScreen (copy)
		local itemId = p5.props.itemId
		local itemType = p5.props.itemType
		local userHasMembership = p5.props.userHasMembership
		local navigation = p5.props.navigation

		if userHasMembership then
			if not GetFFlagRestrictLimited2ToSoothsayers() or p5.props.isCollectiblesEnabled then
				local collectibleItemId = p5.props.itemData.collectibleItemId

				NavigationUtils.navigateFromOverlay(p5.props.navigation, AvatarScreen.ItemOwnershipPage, {
					itemId = itemId,
					collectibleItemId = collectibleItemId,
					itemType = itemType
				})

				return
			end

			NavigationUtils.navigateFromOverlay(p5.props.navigation, AvatarScreen.SellItemPage, {
				itemId = itemId,
				itemType = itemType
			})

			return
		end

		NavigationUtils.navigateToNextOverlay(navigation, AvatarScreen.PremiumSellOnlyPrompt)
	end
	function p5.favoriteItem() -- line: 244
		-- upvalues: p5 (copy), RetrievalStatus (copy), Constants (copy)
		local isFavorited = p5.props.isFavorited

		if isFavorited == nil or p5.props.favoritesFetchingState == RetrievalStatus.Fetching then
			return
		end

		local itemId = p5.props.itemId
		local itemType = p5.props.itemType
		local analytics = p5.props.analytics

		if itemType == Constants.ItemType.Asset then
			p5.props.setAssetFavorite(itemId, not isFavorited)
		elseif itemType == Constants.ItemType.Bundle then
			p5.props.setBundleFavorite(itemId, not isFavorited)
		end

		analytics.clickFavoriteItemButton(itemId, itemType, not isFavorited)
	end
	function p5.shareItemViaShortLink(p6, p7, p8) -- line: 263
		-- upvalues: p5 (copy), Constants (copy)
		p5.props.getOrGenerateShortShareLink(p5.props.itemId, p5.props.itemType):andThen(function(p9) -- line: 266
			-- upvalues: p5 (copy), Constants (copy), p6 (copy), p7 (copy)
			if p9 and (p9.responseBody and p9.responseBody.shortUrl) then
				p5.props.analytics.sendCounter(Constants.Counter.GetOrGenerateShortShareLink.Success)

				if p6 then
					p6()
				end

				p5.openShareSheetOrCopyLink(p9.responseBody.shortUrl)

				return
			end

			p5.props.analytics.sendCounter(Constants.Counter.GetOrGenerateShortShareLink.Invalid)

			if p7 then
				p7(p9)
			end

			p5.shareItem()
		end):catch(function(p10) -- line: 282
			-- upvalues: p5 (copy), Constants (copy), p8 (copy)
			p5.props.analytics.sendCounter(Constants.Counter.GetOrGenerateShortShareLink.Failure)

			if p8 then
				p8(p10)
			end

			p5.shareItem()
		end)
	end
	function p5.popupLinkCopiedToast() -- line: 291
		-- upvalues: p5 (copy), ToastType (copy), Constants (copy)
		p5.props.setCurrentToastMessage({
			toastMessage = "Feature.Catalog.Toast.LinkCopied",
			toastType = ToastType.SuccessConfirmation
		})
		p5.props.analytics.sendCounter(Constants.Counter.GetOrGenerateShortShareLink.LinkCopied)
	end
	function p5.openShareSheetOrCopyLink(s1: string) -- line: 299
		-- upvalues: p5 (copy)
		p5.props.analytics.clickShareItemButton(p5.props.itemId, p5.props.itemType)
		p5.closePrompt()
		p5.props.externalContentSharingProtocol:shareUrl({
			context = "CatalogMoreMenu",
			url = s1
		})
	end
	function p5.shareItem() -- line: 309
		-- upvalues: UrlBuilder (copy), p5 (copy)
		local v178 = UrlBuilder.catalog.info.appsflyer({
			assetId = p5.props.itemId,
			assetType = p5.props.itemType
		})

		p5.openShareSheetOrCopyLink(v178)
	end
	function p5.reportItem(p11) -- line: 318
		-- upvalues: p5 (copy), GetFFlagFixCatalogContextItemReportURLConstruction (copy), Url (copy), Constants (copy), FFlagEnableAbuseReportRevampFlow (copy), v60 (copy), AbuseVector (copy), Platform (copy), v62 (copy), GetFFlagEnableAbuseReport10ft (copy), v65 (copy), AppPage (copy), CatalogConstants (copy), AssetTypeIdStringToName (copy), NavigationUtils (copy), AvatarScreen (copy), v59 (copy)
		local navigation = p5.props.navigation
		local itemId = p5.props.itemId
		local itemType = p5.props.itemType
		local itemData = p5.props.itemData
		local localUserId = p5.props.localUserId
		local v185 = if not GetFFlagFixCatalogContextItemReportURLConstruction() then Url.BASE_URL .. "/abusereport/asset?id=" .. itemId else Url.BASE_URL .. "abusereport/asset?id=" .. itemId
		local id = nil
		local name = nil
		local name2 = nil
		local description = nil
		local assetType = nil

		if itemData then
			if itemData.creator then
				id = itemData.creator.id
				name = itemData.creator.name
			end

			name2 = itemData.name
			description = itemData.description
			assetType = itemData.assetType
		end

		if itemType == Constants.ItemType.Bundle then
			if FFlagEnableAbuseReportRevampFlow and v60 then
				p5.props.openDynamicAbuseReport({
					abuseVector = AbuseVector.UgcBundle,
					targetId = itemId,
					onClose = function() -- line: 350
						-- upvalues: p5 (copy)
						p5.props.closeCentralOverlay()
					end
				})
			else
				p5.props.reportBundle(p5.props.networking, itemId, Platform, DateTime.now().UnixTimestampMillis)
			end

			p5.closePrompt()

			return
		end

		if not v62 and p5.props.useLuafiedReportFlow then
			if GetFFlagEnableAbuseReport10ft() and v65 then
				p5.props.navigateDown({
					name = AppPage.ReportScreen,
					reportData = {
						assetId = itemId,
						platform = CatalogConstants.ReportScreen.Platforms.Console,
						context = CatalogConstants.ReportScreen.Contexts.Item,
						reportAbuseVector = AssetTypeIdStringToName[assetType]
					}
				})

				return
			end

			NavigationUtils.navigateToNextOverlay(navigation, AvatarScreen.ReportDialog, {
				userId = localUserId,
				itemId = itemId,
				itemCreatorId = id,
				itemCreatorName = name,
				itemName = name2,
				itemDescription = description,
				assetTypeName = AssetTypeIdStringToName[assetType]
			})

			return
		end

		if not v62 and v65 then
			NavigationUtils.navigateToNextOverlay(navigation, AvatarScreen.CatalogReport, {
				userId = localUserId,
				itemId = itemId,
				itemCreatorId = id,
				itemName = name2,
				itemDescription = description
			})

			return
		end

		if FFlagEnableAbuseReportRevampFlow and v59 then
			p5.props.openDynamicAbuseReport({
				abuseVector = AbuseVector.Accessory,
				targetId = itemId,
				onClose = function() -- line: 397
					-- upvalues: p5 (copy)
					p5.props.closeCentralOverlay()
				end,
				custom = {
					assetTypeName = AssetTypeIdStringToName[assetType]
				}
			})

			return
		end

		p5.closePrompt()
		p5.props.navigateDown({
			name = AppPage.GenericWebPage,
			detail = v185,
			extraProps = {
				title = p11
			}
		})
	end
	function p5.closePrompt() -- line: 416
		-- upvalues: NavigationUtils (copy), p5 (copy)
		NavigationUtils.closeOverlay(p5.props.navigation)
	end
	function p5.onViewDetailsPageActivate() -- line: 420
		-- upvalues: p5 (copy), Constants (copy), v61 (copy), AvatarScreen (copy), FFlagAXFixPurchaseSurfaceLogging (copy), ImpressionEnums (copy), NamedRefConstants (copy)
		p5.props.analytics.sendAXCounter(Constants.Counter.ContextFrame.ViewDetailsPageClick)
		p5.closePrompt()

		if v61 and p5.props.avatarRoute.current.name == AvatarScreen.TryOnItem then
			if FFlagAXFixPurchaseSurfaceLogging then
				p5.props.openAppItemDetails(p5.props.itemId, p5.props.itemType, true, true, ImpressionEnums.MarketplaceSurfaceType.USER_PROFILE)

				return
			end

			p5.props.openAppItemDetails(p5.props.itemId, p5.props.itemType, true)

			return
		end

		p5.props.openItemDetails({
			showFullWithNoPeekView = true,
			closePreviousItemDetails = true,
			itemId = p5.props.itemId,
			itemType = p5.props.itemType,
			itemSubType = p5.props.itemSubType,
			priceInRobux = p5.props.priceInRobux,
			avatarRoute = p5.props.avatarRoute,
			navigation = p5.props.navigation,
			resultsListRef = p5.props.namedRefs[p5.props.avatarRoute.opaque.name .. NamedRefConstants.ItemsList],
			itemDetailsPeekViewRefs = p5.props.itemDetailsPeekViewRefs,
			catalogAnalytics = p5.props.analytics
		})
	end
end
function v82.didMount(p12) -- line: 453
	-- upvalues: Constants (copy)
	if p12.props.isFavorited == nil then
		local itemId = p12.props.itemId
		local itemType = p12.props.itemType

		if itemType == Constants.ItemType.Asset then
			p12.props.getAssetFavorite(itemId)

			return
		end

		if itemType == Constants.ItemType.Bundle then
			p12.props.getBundleFavorite(itemId)
		end
	end
end
function v82.renderWithProviders(p13, p14, p15) -- line: 467
	-- upvalues: v75 (copy), v74 (copy), CatalogUtils (copy), AvatarScreen (copy), v76 (copy), v81 (copy), v65 (copy), CatalogConstants (copy), v77 (copy), v73 (copy), v78 (copy), v80 (copy), Constants (copy), v79 (copy), Roact (copy), Overlay (copy)
	local centered = p13.props.centered
	local itemType = p13.props.itemType
	local itemData = p13.props.itemData
	local isFavorited = p13.props.isFavorited
	local screenSize = p13.props.screenSize
	local name = p13.props.avatarRoute.opaque.name
	local userHasMembership = p13.props.userHasMembership
	local reportingDisabled = p13.props.reportingDisabled
	local collectiblesResaleRestriction = p13.props.collectiblesResaleRestriction
	local name3 = p13.props.avatarRoute.current.name
	local v117 = isFavorited and v75 or v74
	local v118 = (itemData.creator and itemData.creator.id) ~= "1" and not reportingDisabled
	local v119 = CatalogUtils.IsResellable(itemData)
	local v120 = isFavorited and p14.unfavoriteLabel or p14.favoriteLabel
	local reportLabel = p14.reportLabel
	local t1 = {}
	local isOwned = itemData.isOwned

	if isOwned and name ~= AvatarScreen.AvatarEditor then
		table.insert(t1, {
			icon = v76,
			text = p14.customizeLabel,
			onActivated = p13.goToAvatarPage
		})
	end

	if name3 ~= AvatarScreen.ItemDetails and not p13.props.hideItemDetailsButtonVisible then
		table.insert(t1, {
			icon = v81,
			text = p14.viewDetailsPageLabel,
			onActivated = p13.onViewDetailsPageActivate
		})
	end

	table.insert(t1, {
		icon = v117,
		text = v120,
		onActivated = p13.favoriteItem
	})

	local v124 = (not v65 or userHasMembership) and collectiblesResaleRestriction ~= CatalogConstants.ResaleRestriction.Disabled

	if isOwned and v119 and v124 then
		table.insert(t1, {
			icon = v77,
			text = p14.sellLabel,
			onActivated = p13.openSellPage
		})
	end

	local v125 = p13.props.shouldShowShareButton and (not v65 and p13.props.webViewSupport)
	local v126 = v73

	if v125 then
		if not p13.props.shouldShareToProvider then
			table.insert(t1, {
				icon = v78,
				text = p14.shareLabel,
				onActivated = function() -- line: 537
					-- upvalues: p13 (copy)
					p13.shareItemViaShortLink()
				end
			})
		end
	elseif v126 then
		table.insert(t1, {
			icon = v80,
			onActivated = function() -- line: 564
				-- upvalues: p13 (copy)
				p13.shareItemViaShortLink(p13.popupLinkCopiedToast, p13.popupLinkCopiedToast, p13.popupLinkCopiedToast)
			end,
			text = p14.copyLink
		})
	end

	local v127 = itemType == Constants.ItemType.Asset
	local v128 = itemType == Constants.ItemType.Bundle
	local v129 = p13.props.useLuafiedReportFlow or (p13.props.webViewSupport or v128)
	local v130 = v127 or v128

	if v118 and (v130 and v129) then
		table.insert(t1, {
			icon = v79,
			text = reportLabel,
			onActivated = function() -- line: 589
				-- upvalues: p13 (copy), reportLabel (copy)
				p13.reportItem(reportLabel)
			end
		})
	end

	local isPortrait = p13.props.isPortrait
	local v132 = if not isPortrait then Constants.LandscapeNavWidth else 0
	local v133 = if not isPortrait then Constants.LandscapeSceneWidth else 1
	local uDim2, uDim2_2

	if centered and not isPortrait then
		local v134 = math.min(screenSize.X, 640)

		uDim2 = UDim2.fromOffset((screenSize.X - v134) / 2, 0)
		uDim2_2 = UDim2.new(0, v134, 1, 0)
	else
		uDim2 = UDim2.fromScale(v132, 0)
		uDim2_2 = UDim2.fromScale(v133, 1)
	end

	if centered then
		uDim2 = UDim2.fromScale(0.5, 0)
	end

	return Roact.createElement(Overlay, {
		BackgroundTransparency = 1,
		Position = uDim2,
		Size = uDim2_2,
		AnchorPoint = if not centered then nil else Vector2.new(0.5, 0)
	}, {
		SizeFrame = p13:renderInnerFrame(t1, -76, p15)
	})
end
function v82.renderInnerFrame(p16, p17, p18, p19) -- line: 628
	-- upvalues: Roact (copy), FFlagRenameDeprecatedUIBloxTokens (copy), ContextualMenu (copy), MenuDirection (copy)
	local Tokens = p19.Tokens

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.fromScale(0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0),
		Size = UDim2.fromScale(1, 1)
	}, {
		ContextMenuPadding = Roact.createElement("UIPadding", {
			PaddingRight = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then Tokens.Global.Size_300 else Tokens.Size.Size_600),
			PaddingLeft = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then Tokens.Global.Size_300 else Tokens.Size.Size_600)
		}),
		ContextMenu = Roact.createElement(ContextualMenu, {
			open = true,
			closeBackgroundVisible = true,
			buttonProps = p17,
			menuDirection = MenuDirection.Up,
			openPositionY = UDim.new(1, p18),
			screenSize = p16.props.screenSize,
			contextMenuWidthOverride = UDim.new(1, 0),
			onDismiss = p16.closePrompt
		})
	})
end
function v82.render(p20) -- line: 664
	-- upvalues: withStyle (copy), withLocalization (copy)
	if not p20.props.itemData then
		return
	end

	return withStyle(function(p21) -- line: 668
		-- upvalues: withLocalization (copy), p20 (copy)
		return withLocalization({
			copyLink = "Feature.Catalog.Action.CopyLink",
			customizeLabel = "Feature.Catalog.Action.Customize",
			favoriteLabel = "Feature.Catalog.Action.Favorite",
			unfavoriteLabel = "Feature.Catalog.Action.RemoveFavorite",
			sellLabel = "Feature.Catalog.Action.Sell",
			shareLabel = "Feature.SocialShare.Action.Share",
			reportLabel = "Feature.Catalog.Action.Report",
			viewDetailsPageLabel = "Feature.Catalog.Action.ViewDetailsPage"
		})(function(p22) -- line: 678
			-- upvalues: p20 (copy), p21 (copy)
			return p20:renderWithProviders(p22, p21)
		end)
	end)
end

local v85 = RoactRodux.connect(function(p23, p24) -- line: 684
	-- upvalues: ItemData (copy), CatalogUtils (copy), CatalogConstants (copy), Constants (copy), PerformFetch (copy), GetFFlagRestrictLimited2ToSoothsayers (copy), selectIsPortrait (copy), ExternalContentSharingProtocol (copy)
	local itemId = p24.itemId
	local itemType = p24.itemType
	local v147 = ItemData(p23.AvatarExperience.Common, itemId, itemType)
	local v148 = CatalogUtils.GetItemSubType(itemType, v147)
	local v149 = v147 and v147.priceInRobux
	local v150 = p23.Users[p23.LocalUserId]
	local v151 = v150 and v150.membership
	local v152 = if not v147 then nil else v147.collectibleItemId
	local v153 = if not v152 then nil else p23.AvatarExperience.Common.Collectibles.CollectiblesItemInfo[v152]
	local v154 = if not v153 then CatalogConstants.ResaleRestriction.None else v153.resaleRestriction
	local t2 = {}
	local SetFavoriteAssetKey = nil
	local itemId2 = p24.itemId
	local itemType2 = p24.itemType

	if itemType2 == Constants.ItemType.Asset then
		SetFavoriteAssetKey = CatalogConstants.SetFavoriteAssetKey
	elseif itemType2 == Constants.ItemType.Bundle then
		SetFavoriteAssetKey = CatalogConstants.SetFavoriteBundleKey
	end

	t2.favoritesFetchingState = PerformFetch.GetStatus(p23, SetFavoriteAssetKey .. tostring(itemId2))
	t2.localUserId = p23.LocalUserId

	local v159 = nil
	local itemId3 = p24.itemId
	local itemType3 = p24.itemType

	if itemType3 == Constants.ItemType.Asset then
		v159 = p23.AvatarExperience.Catalog.AssetFavorites[itemId3]
	elseif itemType3 == Constants.ItemType.Bundle then
		v159 = p23.AvatarExperience.Catalog.BundleFavorites[itemId3]
	end

	t2.isFavorited = v159
	t2.itemData = v147
	t2.screenSize = p23.ScreenSize
	t2.userHasMembership = v151 ~= Enum.MembershipType.None
	t2.isCollectiblesEnabled = if not GetFFlagRestrictLimited2ToSoothsayers() then nil else p23.AvatarExperience.Catalog.Metadata.isCollectiblesEnabled
	t2.isPortrait = selectIsPortrait(p23)
	t2.collectiblesResaleRestriction = v154
	t2.externalContentSharingProtocol = ExternalContentSharingProtocol.default
	t2.itemSubType = v148
	t2.priceInRobux = v149

	return t2
end, function(p25) -- line: 716
	-- upvalues: FFlagSignalsNavP3Dispatch (copy), v39 (copy), NavigateDown (copy), GetBundleFavorite (copy), GetAssetFavorite (copy), SetAssetFavorite (copy), SetBundleFavorite (copy), WebApi (copy), SetCurrentToastMessage (copy), OpenItemDetails (copy), v61 (copy), FFlagAXFixPurchaseSurfaceLogging (copy), OpenAppItemDetails (copy), ReportBundle (copy), FFlagEnableAbuseReportRevampFlow (copy), OpenDynamicAbuseReport (copy), CloseCentralOverlay (copy)
	return {
		navigateDown = function(p26) -- line: 718
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v39 (copy), p25 (copy), NavigateDown (copy)
			if FFlagSignalsNavP3Dispatch then
				v39.down(v39.fromLegacyPage(p26))

				return
			end

			p25(NavigateDown(p26))
		end,
		getBundleFavorite = function(p27) -- line: 725
			-- upvalues: p25 (copy), GetBundleFavorite (copy)
			p25(GetBundleFavorite(p27))
		end,
		getAssetFavorite = function(p28) -- line: 728
			-- upvalues: p25 (copy), GetAssetFavorite (copy)
			p25(GetAssetFavorite(p28))
		end,
		setAssetFavorite = function(p29, p30) -- line: 731
			-- upvalues: p25 (copy), SetAssetFavorite (copy)
			p25(SetAssetFavorite(p29, p30))
		end,
		setBundleFavorite = function(p31, p32) -- line: 734
			-- upvalues: p25 (copy), SetBundleFavorite (copy)
			p25(SetBundleFavorite(p31, p32))
		end,
		getOrGenerateShortShareLink = function(p33, p34) -- line: 737
			-- upvalues: p25 (copy), WebApi (copy)
			return p25(WebApi.GetOrGenerateShortShareLink(p33, p34))
		end,
		setCurrentToastMessage = function(p35) -- line: 740
			-- upvalues: p25 (copy), SetCurrentToastMessage (copy)
			return p25(SetCurrentToastMessage(p35))
		end,
		openItemDetails = function(p36) -- line: 743
			-- upvalues: p25 (copy), OpenItemDetails (copy)
			p25(OpenItemDetails(p36))
		end,
		openAppItemDetails = if not v61 then nil else not FFlagAXFixPurchaseSurfaceLogging and function(p37, p38, p39) -- line: 751
			-- upvalues: p25 (copy), OpenAppItemDetails (copy)
			p25(OpenAppItemDetails(p37, p38, p39))
		end or function(p40, p41, p42, p43, p44) -- line: 748
			-- upvalues: p25 (copy), OpenAppItemDetails (copy)
			p25(OpenAppItemDetails(p40, p41, p42, p43, p44))
		end,
		reportBundle = function(p45, p46, p47, p48) -- line: 755
			-- upvalues: p25 (copy), ReportBundle (copy)
			p25(ReportBundle(p45, p46, p47, p48))
		end,
		openDynamicAbuseReport = if not FFlagEnableAbuseReportRevampFlow then nil else function(p49) -- line: 759
			-- upvalues: p25 (copy), OpenDynamicAbuseReport (copy)
			p25(OpenDynamicAbuseReport(p49))
		end,
		closeCentralOverlay = function() -- line: 763
			-- upvalues: p25 (copy), CloseCentralOverlay (copy)
			p25(CloseCentralOverlay())
		end
	}
end)(v82)
local v86 = RoactServices.connect({
	analytics = Analytics,
	networking = RoactNetworking
})(v85)
local v87 = RoactAppPolicy.connect(function(p50, _) -- line: 774
	-- upvalues: GetFFlagLuafiedReportEntryPoints (copy), GetFFlagEnableAbuseReport10ft (copy)
	return {
		shouldShowShareButton = p50.shouldShowCatalogShareButton(),
		shouldShareToProvider = p50.shouldShareToAccountProvider(),
		reportingDisabled = p50.getCatalogReportingDisabled(),
		webViewSupport = p50.getWebViewSupport(),
		useLuafiedReportFlow = if not GetFFlagLuafiedReportEntryPoints() and not GetFFlagEnableAbuseReport10ft() then nil else p50.getUseLuafiedReportFlow()
	}
end)(v86)

if FFlagAXMigrateAXToGlobalAutofocus then
	v87 = withOverlayFocusHandling(v87)
end

return (withNamedRefs((withMappedNavigationParams((withAvatarRoute(v87))))))
