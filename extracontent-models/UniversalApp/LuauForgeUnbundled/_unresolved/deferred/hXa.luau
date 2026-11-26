local CorePackages = game:GetService("CorePackages")
local IXPService = game:GetService("IXPService")
local Roact = require(CorePackages.Packages.Roact)
local none = Roact.None
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local contextualMenu = UIBlox.App.Menu.ContextualMenu
local menuDirection = UIBlox.App.Menu.MenuDirection
local images = UIBlox.App.ImageSet.Images
local Otter = require(CorePackages.Packages.Otter)
local Cryo = require(CorePackages.Packages.Cryo)
local ApolloClient = require(CorePackages.Packages.ApolloClient)
local useQuery = ApolloClient.useQuery
local gql = ApolloClient.gql

local externalContentSharingProtocol = require("@luauforge/bundled/bZp").ExternalContentSharingProtocol
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local useUserExperiment = RoactAppExperiment.useUserExperiment
local isTenFootInterface = require("@game/CorePackages/Workspace/Packages/AppCommonLib").isTenFootInterface
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local roactNetworking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").RoactNetworking
local appEventIngestService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppEventIngestService
local appPinShortcutService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppPinShortcutService
local toastType = require("@luauforge/bundled/dzF").Enums.ToastType
local appUserLayers = require("@luauforge/bundled/dPQ").AppUserLayers
local closeCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/CentralOverlay").Thunks.CloseCentralOverlay
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux")
local navigateDown = NavigationRodux.Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dFz").NavigationCommands
else
	navigationCommands = nil
end

local selectors = NavigationRodux.Selectors
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local deviceOrientationMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").DeviceOrientationMode
local setCurrentToastMessage = require("@luauforge/bundled/dzF").Actions.SetCurrentToastMessage
local GameHydrationReact = require("@game/CorePackages/Workspace/Packages/GameHydrationReact")
local UrlBuilder = require(CorePackages.Packages.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local module3 = require("@luauforge/bundled/hUa")
local gameInviteModalManager = module3.GameInviteModalManager
local gameInviteAnalyticsManager = module3.GameInviteAnalyticsManager
local gameInviteConstants = module3.GameInviteConstants
local module4 = require("@luauforge/deferred/gLo")
local module5 = require("@luauforge/deferred/gLp")
local module6 = require("@luauforge/deferred/gCa")

local module7 = require("@luauforge/deferred/gBX")

local fetchGamePlayabilityAndProductInfo = require("@luauforge/bundled/dBl").FetchGamePlayabilityAndProductInfo

local gameDetailsEvents = require("@luauforge/bundled/dtb").Modules.LuaApp.Analytics.Events.Games.GameDetailsEvents
local copyExperienceLink = gameDetailsEvents.CopyExperienceLink
local favorite = gameDetailsEvents.Favorite
local follow = gameDetailsEvents.Follow
local openMore = gameDetailsEvents.OpenMore
local requestRefundClick = gameDetailsEvents.RequestRefundClick
local shareExperienceLink = gameDetailsEvents.ShareExperienceLink

local module8 = require("@luauforge/bundled/egY")
local module9 = require("@luauforge/bundled/dCC")
local module10 = require("@luauforge/deferred/hXb")
local module11 = require("@luauforge/bundled/dBq")
local module12 = require("@luauforge/deferred/gDa")

local module13 = require("@luauforge/bundled/dBs")
local module14 = require("@luauforge/deferred/hGI")
local module15 = require("@luauforge/deferred/hXd")
local module16 = require("@luauforge/deferred/hXe")
local module17 = require("@luauforge/bundled/dzD")
local module18 = require("@luauforge/bundled/fIj")
local module19 = require("@luauforge/deferred/gBI")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagSignalsNavP3fGameDetails = SharedFlags.FFlagSignalsNavP3fGameDetails
local getLegacyNavigationStore

if fFlagSignalsNavP3fGameDetails then
	getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore
else
	getLegacyNavigationStore = nil
end

local fFlagUseSignalsForDeviceOrientation = SharedFlags.FFlagUseSignalsForDeviceOrientation
local getDeviceOrientationStore

if fFlagUseSignalsForDeviceOrientation then
	getDeviceOrientationStore = require("@luauforge/bundled/hWZ").GetDeviceOrientationStore
else
	getDeviceOrientationStore = nil
end

local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local React = require(CorePackages.Packages.React)

local module21 = require("@luauforge/deferred/hXf")

local module22 = require("@luauforge/deferred/hXg")
local getFFlagLuafiedReportEntryPoints = SharedFlags.GetFFlagLuafiedReportEntryPoints
local getFFlagEnableAbuseReport10ft = SharedFlags.GetFFlagEnableAbuseReport10ft

local getNotificationsExperienceDetailsVariant = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetNotificationsExperienceDetailsVariant

local getFFlagNotificationsForceEnableEDPDiscoverability = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagNotificationsForceEnableEDPDiscoverability

local fFlagEnableAbuseReportRevampFlow = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableAbuseReportRevampFlow
local fFlagAddThumbnailSelectorReport = SharedFlags.FFlagAddThumbnailSelectorReport
local fFlagPinShortcutEnableOnCompleteCallback = SharedFlags.FFlagPinShortcutEnableOnCompleteCallback
local fFlagAddPinExperienceTargetDestinationGUACPolicy = SharedFlags.FFlagAddPinExperienceTargetDestinationGUACPolicy
local fFlagEdpPinnedShortcutsLogExposure = SharedFlags.FFlagEdpPinnedShortcutsLogExposure
local fStringEdpPinnedShortcutsIxpLayer = SharedFlags.FStringEdpPinnedShortcutsIxpLayer

local fFlagLuaAppEdpBackendV2HydrateLegacyIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2HydrateLegacyIxp

local fFlagLuaAppEdpBackendV2SduiInterleaveDefault = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2SduiInterleaveDefault

local fFlagLuaAppEdpBackendV2SduiInterleaveIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2SduiInterleaveIxp
local fFlagLuaAppAddUniverseIdToEngagementEvents = SharedFlags.FFlagLuaAppAddUniverseIdToEngagementEvents
local defineFastFlag = game:DefineFastFlag("EdpConsoleUseAbuseReportRevampFlow", false)

local getAppFeaturePolicies = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").getAppFeaturePolicies

local pinExperienceAndNotify = require("@luauforge/bundled/hXh").pinExperienceAndNotify

local defineFastString = game:DefineFastString(
	"ExperienceDetailsCopyLinkExperimentVariant",
	"enableCopyLinkButton"
)

local defineFastString2 = game:DefineFastString(
	"SocialExperienceDetailsContextualMenuLayer",
	"Social.ExperienceDetailsContextualMenu"
)

local extended = Roact.PureComponent:extend("GameDetailMoreContextualMenu")

local strictInterface = t.strictInterface
local v5 = {}
v5.universeId = t.string
v5.menuPosition = t.optional(t.UDim2)
v5.onClose = t.optional(t.callback)
v5.menuAnchorPoint = t.optional(t.Vector2)
v5.externalContentSharingProtocol = t.table
v5.hideCloseButton = t.optional(t.boolean)
local v6 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then t.optional(t.boolean) else nil
v5.shouldHydrateLegacyIxp = v6
v5.edpServerIxpVariables = t.optional(t.table)

v5.closeCentralOverlayThunk = t.optional(t.callback)
v5.focusController = t.optional(t.table)
v5.defaultChildRef = t.optional(t.table)

v5.rootPlaceId = t.optional(t.string)
local v7 = if SharedFlags.FFlagEnablePinnedShortcutsOnHomeScreenLua then t.optional(t.string) else nil
v5.experienceName = v7
v5.isFavorite = t.optional(t.boolean)
v5.gameFollowings = t.optional(t.table)
v5.currentPage = t.string
v5.shareButtonEnabled = t.boolean
v5.screenSize = t.optional(t.Vector2)
v5.deviceOrientation = t.optional(t.string)
v5.notificationsEnabled = t.table
v5.refundLink = t.optional(t.string)

v5.closeCallback = t.callback
v5.gamePostFavorite = t.callback
v5.setGameFavorite = t.callback
v5.sendGameFollow = t.callback
v5.setGameFollow = t.callback
v5.setCurrentToastMessage = t.callback
v5.navigateDown = t.callback
v5.setToastMessage = t.callback
local v8 = if getFFlagLuafiedReportEntryPoints() then t.callback else nil
v5.reportExperienceDialog = v8
local v9 = if getFFlagEnableAbuseReport10ft() then t.callback else nil
v5.reportExperienceScreen = v9
v5.setExperienceNotificationsEnabledCount = t.callback
v5.openRequestRefundPage = t.callback
v5.fetchGameDetail = t.callback
v5.fetchPlayabilityAndProductInfo = t.callback
local v10 = if fFlagEnableAbuseReportRevampFlow then t.callback else nil
v5.openDynamicAbuseReport = v10
local v11 = if fFlagPinShortcutEnableOnCompleteCallback then t.callback else nil
v5.pinExperienceDispatch = v11

v5.shouldShowShareButton = t.boolean
v5.shouldShareToProvider = t.boolean
v5.reportingDisabled = t.boolean
v5.supportsWebViews = t.boolean
local v12 = if getFFlagLuafiedReportEntryPoints() or getFFlagEnableAbuseReport10ft() then t.optional(t.boolean) else nil
v5.useLuafiedReportFlow = v12

v5.inviteFriendsDisabled = t.boolean
v5.webViewSupport = t.boolean
v5.notificationsCanEnableExperience = t.boolean

local v13 = if not getFFlagNotificationsForceEnableEDPDiscoverability() then t.boolean else nil
v5.enableNotificationsDiscoverability = v13

local v14 = if not getFFlagNotificationsForceEnableEDPDiscoverability() then t.boolean else nil
v5.enableNotificationsRebrand = v14

v5.enableCopyLink = t.optional(t.any)
v5.shareLinkId = t.optional(t.string)

v5.networking = t.callback
v5.localization = t.table
v5.eventIngest = t.table
local v15 = if SharedFlags.FFlagEnablePinnedShortcutsOnHomeScreenLua then t.union(t.Instance, t.table) else nil
v5.pinShortcutService = v15
extended.validateProps = strictInterface(v5)

local function generateExperienceDetailsShareLinkUrl(shareLinkId, universeId, rootPlaceId)
	local v16 = nil

	if not shareLinkId then
		return urlBuilder.game.info.appsflyer({
			universeId = universeId,
			placeId = rootPlaceId
		}), v16
	end

	local unixTimestampMillis = tostring(DateTime.now().UnixTimestampMillis)
	return
		urlBuilder.sharelinks.shortUrl({
			linkId = shareLinkId,
			type = module18.ExperienceDetails,
			stamp = unixTimestampMillis
		}),
		unixTimestampMillis
end

extended.defaultProps = {
	externalContentSharingProtocol = externalContentSharingProtocol.default,
	onClose = function() end
}

function extended:init()
	self.isMounted = false
	self.menuItemNames = {}
	self.gameInfoSubscription = GameHydrationReact.subscribeGameInfo({
		universeId = self.props.universeId,
		onChange = function(p2)
			self:setState({
				gameInfo = p2.gameInfo or none
			})
		end
	})

	function self.getMenuPos()
		if self.props.menuPosition == nil then
			return UDim2.fromOffset(0, 0)
		end

		return self.props.menuPosition
	end

	function self.getMenuSize()
		return UDim2.new(0, 300, 1, 0)
	end

	function self.getMenuAnchor()
		if self.props.menuPosition == nil or self.props.screenSize == nil then
			return nil
		end

		if self.props.menuAnchorPoint then
			return self.props.menuAnchorPoint
		end

		return Vector2.new(0, 0)
	end

	function self.getLinkPage()
		return (urlBuilder.game.report({
			placeId = self.props.rootPlaceId or self.state.gameInfo and self.state.gameInfo.rootPlaceId
		}))
	end

	function self.closeCallback()
		if self.props.onClose then
			self.props.onClose()
		end

		self.props.closeCallback()
	end

	function self.onRequestRefundPageClose()
		local fetchGameDetail = self.props.fetchGameDetail
		local networking = self.props.networking
		local universeId = self.props.universeId
		local v16 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then self.props.shouldHydrateLegacyIxp else nil
		fetchGameDetail(networking, universeId, v16)

		self.props.fetchPlayabilityAndProductInfo(self.props.networking, self.props.universeId)
	end
end

function extended:renderContextualMenuContent(data)
	local contextualMenuContent = {}
	self.menuItemNames = {}

	local rootPlaceId = self.props.rootPlaceId or self.state.gameInfo and self.state.gameInfo.rootPlaceId
	local eventIngest = self.props.eventIngest

	local networking = self.props.networking
	local universeId = self.props.universeId

	local notificationsCanEnableExperience = self.props.notificationsCanEnableExperience

	local iconsactionsfavoriteOn = images["icons/actions/favoriteOn"]
	local v16 = images["icons/actions/favoriteOff"]
	local v17 = not (self.props.isFavorite == nil) and (self.props.isFavorite or false)
	local v18 = self.props.isFavorite == nil
	v16 = v17 and iconsactionsfavoriteOn or v16
	local v19 = data.favoriteLabel

	if module21 then
		v19 = v17 and data.favoritedLabel or data.favoriteLabel
	end

	local v20 = getFFlagNotificationsForceEnableEDPDiscoverability() and true
		or self.props.enableNotificationsDiscoverability

	if
		not (fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and module7.getShouldInterleaveSdui())
		or not self.props.edpServerIxpVariables
		or self.props.edpServerIxpVariables.hideFavoritesInContextMenu ~= true
	then
		table.insert(contextualMenuContent, {
			icon = v16,
			text = v19,
			stayOnActivated = true,
			onActivated = function()
				if not self.isMounted or v18 or not rootPlaceId then
					return
				end

				self.props.setGameFavorite(universeId, not v17)
				self.props.gamePostFavorite(networking, universeId, not v17)
				favorite(
					eventIngest,
					"GameDetailMoreContextualMenu",
					rootPlaceId,
					not v17,
					fFlagLuaAppAddUniverseIdToEngagementEvents and {
						targetId = universeId
					} or nil
				)
			end
		})

		table.insert(self.menuItemNames, "Favorite")
	end

	if
		notificationsCanEnableExperience
		and not v20
		and (not (fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and module7.getShouldInterleaveSdui()) or not self.props.edpServerIxpVariables or self.props.edpServerIxpVariables.hideNotifyInContextMenu ~= true)
	then
		local v21 = self.props.gameFollowings == nil
		local v22 = not (self.props.gameFollowings == nil)
			and (self.props.gameFollowings.isFollowed or false)
		local iconscommonnotificationOn = images["icons/common/notificationOn"]
		local v23 = images["icons/common/notificationOff"]

		local v24 = data.followLabel

		if module21 then
			v24 = v22 and data.followingLabel or data.followLabel
		end

		v23 = v22 and iconscommonnotificationOn or v23
		table.insert(contextualMenuContent, {
			text = v24,
			icon = v23,
			disabled = v21,
			stayOnActivated = true,
			onActivated = function()
				if not self.isMounted or v21 or not rootPlaceId then
					return
				end

				local isFollowed = self.props.gameFollowings.isFollowed

				local setCurrentToastMessage2 = self.props.setCurrentToastMessage
				local count = self.props.notificationsEnabled.count or 0
				local limit = self.props.notificationsEnabled.limit or 0

				if isFollowed then
					self.props.setExperienceNotificationsEnabledCount(count - 1)
				elseif limit <= count then
					setCurrentToastMessage2({
						toastType = toastType.GameFollowError,
						toastMessage = self.props.enableNotificationsRebrand and "Feature.GameFollows.TooltipNotificationsLimitReached" or "Feature.GameFollows.TooltipFollowLimitReached"
					})

					return
				else
					self.props.setExperienceNotificationsEnabledCount(count + 1)
				end

				self.props.setGameFollow(universeId, not isFollowed)
				self.props.sendGameFollow(networking, universeId, not isFollowed, false, count, limit)

				follow(
					eventIngest,
					"GameDetailMoreContextualMenu",
					rootPlaceId,
					not isFollowed,
					fFlagLuaAppAddUniverseIdToEngagementEvents and {
						universeId = universeId
					} or nil
				)
			end
		})

		table.insert(self.menuItemNames, "Follow")
	end

	if not self.props.inviteFriendsDisabled then
		table.insert(contextualMenuContent, {
			text = data.inviteFriends,
			icon = images["icons/actions/friends/friendInvite"],
			onActivated = function()
				if not (self.isMounted and rootPlaceId) then
					return
				end

				gameInviteAnalyticsManager:withButtonName(gameInviteAnalyticsManager.ButtonName.GameDetailsMoreMenu)
				gameInviteAnalyticsManager:inputShareGameEntryPoint(rootPlaceId, universeId)
				gameInviteModalManager:openModal({
					trigger = gameInviteConstants.Triggers.GameDetailsMoreMenu,
					rootPlaceId = rootPlaceId,
					universeId = universeId,
					hideCloseButton = self.props.hideCloseButton
				})

				self.closeCallback()
			end
		})

		table.insert(self.menuItemNames, "InviteFriends")
	end

	if self.props.enableCopyLink then
		table.insert(contextualMenuContent, {
			icon = images["icons/menu/link"],
			onActivated = function()
				if not (self.isMounted and rootPlaceId) then
					return
				end

				local v21, v22 = generateExperienceDetailsShareLinkUrl(
					self.props.shareLinkId,
					universeId,
					rootPlaceId
				)

				self.props.externalContentSharingProtocol:shareUrl({
					context = "GameDetailsMoreWebURL",
					url = v21
				})

				copyExperienceLink(eventIngest, "GameDetailMoreContextualMenu", rootPlaceId, {
					stamp = v22,
					targetId = if fFlagLuaAppAddUniverseIdToEngagementEvents then universeId else nil
				})

				self.props.setCurrentToastMessage({
					toastMessage = "Feature.GameDetails.Toast.LinkCopied",
					toastType = toastType.SuccessConfirmation
				})

				self.closeCallback()
			end,
			text = data.copyLink
		})

		table.insert(self.menuItemNames, "CopyLink")
	end

	if self.props.shareButtonEnabled and self.props.shouldShowShareButton then
		table.insert(contextualMenuContent, {
			text = data.share,
			icon = images["icons/actions/share"],
			onActivated = function()
				if not (self.isMounted and rootPlaceId) then
					return
				end

				if self.props.shouldShareToProvider then
					self.props.navigateDown({
						name = appPage.SdkShare,
						extraProps = {
							universeId = universeId,
							context = "GameDetailsMoreWebURL"
						}
					})
				else
					local v21, v22 = generateExperienceDetailsShareLinkUrl(
						self.props.shareLinkId,
						universeId,
						rootPlaceId
					)

					shareExperienceLink(eventIngest, "GameDetailMoreContextualMenu", rootPlaceId, {
						shortShareLinkFailed = not self.props.shareLinkId,
						shareToAppsflyer = true,
						stamp = v22,
						linkId = self.props.shareLinkId,
						targetId = if fFlagLuaAppAddUniverseIdToEngagementEvents then universeId else nil
					})

					self.props.externalContentSharingProtocol:shareUrl({
						url = v21,
						context = "GameDetailsMoreWebURL"
					})
				end

				self.closeCallback()
			end
		})

		table.insert(self.menuItemNames, "ShareExperienceLink")
	end

	if not self.props.reportingDisabled then
		table.insert(contextualMenuContent, {
			text = data.report,
			icon = images["icons/actions/feedback"],
			onActivated = function()
				if not (self.isMounted and rootPlaceId) then
					return
				end

				if
					self.props.useLuafiedReportFlow
					and not (defineFastFlag and fFlagEnableAbuseReportRevampFlow)
				then
					if getFFlagEnableAbuseReport10ft() and isTenFootInterface() then
						self.props.reportExperienceScreen({
							context = module17.ReportScreen.Contexts.Experience,
							assetId = tostring(rootPlaceId),
							reportAbuseVector = module17.ReportScreen.AbuseVectors.Place,
							platform = module17.ReportScreen.Platforms.Console
						})
					else
						self.props.reportExperienceDialog({
							reportEntryPoint = module17.ReportDialogEntryPoints.ExperienceDetails,
							universeId = universeId,
							rootPlaceId = rootPlaceId
						})
					end
				else
					if fFlagEnableAbuseReportRevampFlow then
						self.props.openDynamicAbuseReport({
							abuseVector = module4.Place,
							targetId = rootPlaceId,
							custom = fFlagAddThumbnailSelectorReport and {
								universeId = universeId
							} or nil,
							onClose = function()
								self.closeCallback()
							end
						})
						return
					end

					if not self.props.supportsWebViews then
						self.props.setToastMessage(module17.WEBVIEWS_UNAVAILABLE_TOAST)
						return
					end

					self.props.navigateDown({
						name = appPage.GenericWebPage,
						detail = self:getLinkPage(),
						extraProps = { title = data.localizedTextReport }
					})
				end

				self.closeCallback()
			end
		})

		table.insert(self.menuItemNames, "Report")
	end

	if self.props.refundLink and self.props.webViewSupport then
		table.insert(contextualMenuContent, {
			text = data.requestRefund,
			icon = images["icons/menu/wallet"],
			onActivated = function()
				if not (self.isMounted and rootPlaceId) then
					return
				end

				requestRefundClick(self.props.eventIngest, "GameDetailMoreContextualMenu", rootPlaceId)

				self.props.openRequestRefundPage(self.props.refundLink, self.onRequestRefundPageClose)

				self.closeCallback()
			end
		})

		table.insert(self.menuItemNames, "RequestRefund")
	end

	if not SharedFlags.FFlagEnablePinnedShortcutsOnHomeScreenLua then
		return contextualMenuContent
	end

	local experienceName = self.props.experienceName or self.state.gameInfo and self.state.gameInfo.name
	local pinShortcutService = self.props.pinShortcutService

	if pinShortcutService and pinShortcutService:IsAvailable() then
		table.insert(contextualMenuContent, {
			text = data.addToHomeScreen,
			icon = images["icons/actions/edit/add"],
			onActivated = function()
				if not self.isMounted then
					return
				end

				if
					fFlagEdpPinnedShortcutsLogExposure
					and game:GetEngineFeature("EnableLogFlagLinkedUserLayerExposure")
				then
					pcall(function()
						IXPService:LogFlagLinkedUserLayerExposure(fStringEdpPinnedShortcutsIxpLayer)
					end)
				end

				if fFlagPinShortcutEnableOnCompleteCallback then
					pinExperienceAndNotify(
						rootPlaceId,
						universeId,
						experienceName or "",
						self.props.pinExperienceDispatch,
						pinShortcutService
					)
				else
					pinShortcutService:PinExperience(rootPlaceId, universeId, experienceName)
				end

				self.closeCallback()
			end
		})

		table.insert(self.menuItemNames, "AddToHomescreen")
	end

	return contextualMenuContent
end

function extended:renderLandscapeContextualMenu(p2)
	local screenSize = self.props.screenSize
	local contextualMenuContent = self:renderContextualMenuContent(p2)
	local menuPos = self.getMenuPos()
	local menuAnchor = self:getMenuAnchor()
	local menuSize = self.getMenuSize()

	return Roact.createElement(
		"Frame",
		{ BackgroundTransparency = 1, Position = menuPos, Size = menuSize },
		{
			ContextMenu = Roact.createElement(contextualMenu, {
				buttonProps = contextualMenuContent,
				open = true,
				horizontalAlignment = Enum.HorizontalAlignment.Left,
				openPositionX = UDim.new(0, 0),
				openPositionY = UDim.new(0, 0),
				closeBackgroundVisible = false,
				screenSize = screenSize,
				onDismiss = self.closeCallback,
				contextMenuWidthOverride = UDim.new(1, 0),
				anchorPointOverride = menuAnchor,
				motorOverrideOptions = {
					motorCallback = Otter.instant,
					open = { targetValue = 1 },
					close = { targetValue = 0 }
				}
			})
		}
	)
end

function extended:renderPortraitContextualMenu(p2)
	local screenSize = self.props.screenSize
	local contextualMenuContent = self:renderContextualMenuContent(p2)

	local v16 = self.props.deviceOrientation == deviceOrientationMode.Portrait

	local v17 = (screenSize == nil or not (screenSize.X > 0)) and 0
		or self.props.menuPosition.X.Offset / screenSize.X / 2
		or 0

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.new(v16 and 0 or v17, 0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		ContextMenu = Roact.createElement(contextualMenu, {
			buttonProps = contextualMenuContent,
			open = true,
			menuDirection = menuDirection.Up,
			openPositionY = UDim.new(1, -76),
			closeBackgroundVisible = false,
			screenSize = screenSize,
			onDismiss = self.closeCallback
		})
	})
end

function extended:didMount()
	self.isMounted = true
	local v16

	if fFlagSignalsNavP3fGameDetails then
		v16 = getLegacyNavigationStore(false).getCurrentPage(false).name
	else
		v16 = self.props.currentPage
	end

	if v16 ~= appPage.GameDetail and v16 ~= appPage.ExperienceDetail then
		self.closeCallback()
		return
	end

	local eventIngest = self.props.eventIngest

	local rootPlaceId = self.props.rootPlaceId or self.state.gameInfo and self.state.gameInfo.rootPlaceId
	openMore(eventIngest, "GameDetailMoreContextualMenu", rootPlaceId, {
		moreMenuItems = table.concat(self.menuItemNames, ",")
	})
end

function extended.didUpdate(p2)
	p2.gameInfoSubscription.update(p2.props.universeId)
end

function extended:willUnmount()
	self.isMounted = false
	self.gameInfoSubscription.dispose()
end

function extended:render()
	return withLocalization({
		favoriteLabel = "Feature.Favorites.Label.Favorite",
		favoritedLabel = "Feature.Favorites.Label.Favorited",
		followLabel = self.props.enableNotificationsRebrand and "Feature.GameFollows.LabelNotifications" or "Feature.GameDetails.Label.Follow",
		followingLabel = "Feature.Friends.Label.Following",
		inviteFriends = "Feature.GameDetails.Action.InviteFriends",
		copyLink = "Feature.GameDetails.Action.CopyLink",
		share = "Feature.SocialShare.Action.Share",
		report = "Feature.GameDetails.Action.Report",
		requestRefund = "Feature.GameDetails.Action.Refund",
		addToHomeScreen = fFlagAddPinExperienceTargetDestinationGUACPolicy and getAppFeaturePolicies().getPinExperienceTargetDestination() == "Desktop" and "InstantApps.Shortcuts.Label.AddToDesktopMenuItem" or "InstantApps.Shortcuts.Label.AddToHomeMenuItem"
	})(function(p2)
		if self.props.deviceOrientation == deviceOrientationMode.Portrait then
			return self:renderPortraitContextualMenu(p2)
		end

		return self:renderLandscapeContextualMenu(p2)
	end)
end

local v16 = RoactRodux.connect(function(data, p2)
	local v17 = if data.GameDetailsV2 then data.GameDetailsV2[p2.universeId] or nil else nil

	local v19 = {
		rootPlaceId = if v17 then v17.rootPlaceId or nil else nil,
		experienceName = 0,
		isFavorite = 0,
		gameFollowings = 0,
		currentPage = 0,
		shareButtonEnabled = 0,
		screenSize = 0,
		deviceOrientation = 0,
		notificationsEnabled = 0,
		refundLink = 0
	}

	local v20 = if SharedFlags.FFlagEnablePinnedShortcutsOnHomeScreenLua and v17 then v17.name or nil else nil
	v19.experienceName = v20

	v19.isFavorite = data.GameFavorites[p2.universeId]
	v19.gameFollowings = data.GameFollowings[p2.universeId]
	local routeName

	if not fFlagSignalsNavP3fGameDetails then
		if SharedFlags.FFlagUseNavigationSelectors then
			routeName = selectors.selectCurrentRoactNavigationRoute(data).routeName
		else
			routeName = data.Navigation.currentRoute.routeName
		end
	end

	v19.currentPage = routeName

	v19.shareButtonEnabled = module22(data.LocalUserId)
	v19.screenSize = data.ScreenSize
	local v21 = if not fFlagUseSignalsForDeviceOrientation then data.DeviceOrientation else nil
	v19.deviceOrientation = v21
	v19.notificationsEnabled = data.ExperienceNotificationsEnabled or {}
	local v22 = if v17 then v17.refundLink else nil
	v19.refundLink = v22
	return v19
end, function(callback)
	return {
		closeCallback = function()
			callback(closeCentralOverlay())
		end,
		gamePostFavorite = function(p2, p3, p4)
			return callback(module10(p2, p3, p4))
		end,
		setGameFavorite = function(p2, p3)
			return callback(module9(p2, p3))
		end,
		sendGameFollow = function(p2, p3, p4, p5, p6, p7)
			return callback(module12(p2, p3, p4, p5, p6, p7))
		end,
		setGameFollow = function(p2, p3)
			return callback(module11(p2, p3))
		end,
		setCurrentToastMessage = function(p2)
			return callback(setCurrentToastMessage(p2))
		end,
		navigateDown = function(p2)
			if fFlagSignalsNavP3Dispatch then
				return navigationCommands.down(navigationCommands.fromLegacyPage(p2))
			end

			return callback(navigateDown(p2))
		end,
		setToastMessage = function(p2)
			return callback(setCurrentToastMessage(p2))
		end,
		reportExperienceDialog = getFFlagLuafiedReportEntryPoints() and function(p2)
			return callback(module14(p2))
		end or nil,
		reportExperienceScreen = getFFlagEnableAbuseReport10ft() and function(p2)
			return callback(module15(p2))
		end or nil,
		setExperienceNotificationsEnabledCount = function(p2)
			return callback(module13(p2))
		end,
		openRequestRefundPage = function(p2, p3)
			return callback(module16(p2, p3))
		end,
		fetchGameDetail = function(p2, p3, p4)
			return callback(module19.Fetch(p2, p3, p4, nil))
		end,
		fetchPlayabilityAndProductInfo = function(p2, p3)
			return callback(fetchGamePlayabilityAndProductInfo.Fetch(p2, p3))
		end,
		openDynamicAbuseReport = fFlagEnableAbuseReportRevampFlow and function(p2)
			return callback(module5(p2))
		end or nil,
		pinExperienceDispatch = if fFlagPinShortcutEnableOnCompleteCallback then callback else nil
	}
end)(extended)
local v17

if fFlagUseSignalsForDeviceOrientation then
	local function GameDetailMoreContextualMenuWithSignals(p2)
		local v18 = useSignalState(getDeviceOrientationStore(false).getDeviceOrientation)

		return React.createElement(v16, Cryo.Dictionary.union(p2, {
			deviceOrientation = v18
		}))
	end

	v17 = React.memo(GameDetailMoreContextualMenuWithSignals)
else
	v17 = v16
end

local v18 = roactAppPolicy.connect(function(data, p2)
	local v19 = {
		shouldShowShareButton = data.shouldShowGameDetailsShareButton(),
		shouldShareToProvider = data.shouldShareToAccountProvider(),
		reportingDisabled = data.getGameReportingDisabled(),
		supportsWebViews = data.getWebViewSupport(),
		useLuafiedReportFlow = 0,
		inviteFriendsDisabled = 0,
		webViewSupport = 0,
		notificationsCanEnableExperience = 0
	}
	local v20 = if getFFlagLuafiedReportEntryPoints() or getFFlagEnableAbuseReport10ft() then data.getUseLuafiedReportFlow() else nil
	v19.useLuafiedReportFlow = v20

	v19.inviteFriendsDisabled = data.getInviteFriendsDisabled()
	v19.webViewSupport = data.getWebViewSupport()
	v19.notificationsCanEnableExperience = data.getNotificationsCanReceiveExperience()
	return v19
end)(v17)

if not getFFlagNotificationsForceEnableEDPDiscoverability() then
	v18 = RoactAppExperiment.connectUserLayer({ appUserLayers.ExperienceDetailsPageLayer }, function(p2, p3)
		local v19 = (p2[appUserLayers.ExperienceDetailsPageLayer] or {})[getNotificationsExperienceDetailsVariant.getNotificationsVariantFieldName]
			or -1
		return {
			enableNotificationsDiscoverability = v19 == 2,
			enableNotificationsRebrand = v19 > 0
		}
	end)(v18)
end

local v19 = gql([[
query ExperienceDetailsLink($universeId: String!) {
	experienceDetailsLinkByUniverseId(universeId: $universeId) {
		linkId
	}
}
		]])

local function fn(p2)
	local v20 = useQuery(v19, {
		variables = { universeId = p2.universeId }
	})
	local linkId

	if v20.data and v20.data.experienceDetailsLinkByUniverseId then
		linkId = v20.data.experienceDetailsLinkByUniverseId.linkId
	end

	local v21 = useUserExperiment({ defineFastString2 }, function(p3)
		return (p3[defineFastString2] or {})[defineFastString]
	end, true)
	local v22

	if fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp then
		v22 = module6()
	end

	local v23

	if fFlagSignalsNavP3fGameDetails then
		v23 = getLegacyNavigationStore(false).getCurrentPage(false)
	end

	local join = Cryo.Dictionary.join

	if not (fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and module7.getShouldInterleaveSdui()) then
		v22 = nil
	end

	local v25 = if fFlagSignalsNavP3fGameDetails then v23.name else nil
	local v26 = join(p2, {
		enableCopyLink = v21,
		shareLinkId = linkId,
		edpServerIxpVariables = v22,
		currentPage = v25
	})

	return Roact.createElement(v18, v26)
end

local connect = roactServices.connect

if not SharedFlags.FFlagEnablePinnedShortcutsOnHomeScreenLua then
	appPinShortcutService = nil
end

return connect({
	networking = roactNetworking,
	localization = module8,
	eventIngest = appEventIngestService,
	pinShortcutService = appPinShortcutService
})(fn)
