local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local ContextualMenu = UIBlox.App.Menu.ContextualMenu
local MenuDirection = UIBlox.App.Menu.MenuDirection
local Images = UIBlox.App.ImageSet.Images
local Otter = require(CorePackages.Packages.Otter)
local Cryo = require(CorePackages.Packages.Cryo)
local ApolloClient = require(CorePackages.Packages.ApolloClient)
local useQuery = ApolloClient.useQuery
local gql = ApolloClient.gql
local ExternalContentSharingProtocol = require(CorePackages.Workspace.Packages.ExternalContentSharingProtocol).ExternalContentSharingProtocol
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local useUserExperiment = RoactAppExperiment.useUserExperiment
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(CorePackages.Workspace.Packages.RoactServiceTags).RoactNetworking
local AppEventIngestService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppEventIngestService
local AppGuiService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppGuiService
local ToastType = require(CorePackages.Workspace.Packages.ToastRodux).Enums.ToastType
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local CloseCentralOverlay = require(CorePackages.Workspace.Packages.CentralOverlay).Thunks.CloseCentralOverlay
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local NavigationRodux = require(CorePackages.Workspace.Packages.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v29 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local Selectors = NavigationRodux.Selectors
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local DeviceOrientationMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).DeviceOrientationMode
local SetCurrentToastMessage = require(CorePackages.Workspace.Packages.ToastRodux).Actions.SetCurrentToastMessage
local GameInfosReducer = require(CorePackages.Workspace.Packages.GameInfosRodux).GameInfosReducer
local UrlBuilder = require(CorePackages.Packages.UrlBuilder).UrlBuilder
local GameInvite = require(CorePackages.Workspace.Packages.GameInvite)
local GameInviteModalManager = GameInvite.GameInviteModalManager
local GameInviteAnalyticsManager = GameInvite.GameInviteAnalyticsManager
local GameInviteConstants = GameInvite.GameInviteConstants
local AbuseVector = require(CorePackages.Workspace.Packages.GenericAbuseReporting.AbuseVector)
local OpenDynamicAbuseReport = require(CorePackages.Workspace.Packages.GenericAbuseReporting.OpenDynamicAbuseReport)
local useEdpServerIxpVariables = require(script.Parent.Parent.ExperienceDetails.Hooks.useEdpServerIxpVariables)
local ExperienceDetailsExperimentation = require(script.Parent.Parent.ExperienceDetails.ExperienceDetailsExperimentation)
local GameDetailRodux = require(CorePackages.Workspace.Packages.GameDetailRodux)
local ApiFetchGameDetails = GameDetailRodux.GameDetails.ApiFetchGameDetails
local FetchGamePlayabilityAndProductInfo = GameDetailRodux.FetchGamePlayabilityAndProductInfo
local GameDetailsEvents = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules.LuaApp.Analytics.Events.Games.GameDetailsEvents
local CopyExperienceLink = GameDetailsEvents.CopyExperienceLink
local Favorite = GameDetailsEvents.Favorite
local Follow = GameDetailsEvents.Follow
local OpenMore = GameDetailsEvents.OpenMore
local RequestRefundClick = GameDetailsEvents.RequestRefundClick
local ShareExperienceLink = GameDetailsEvents.ShareExperienceLink
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local RoactLocalization = require(Modules.LuaApp.Services.RoactLocalization)
local SetGameFavorite = require(Modules.LuaApp.Actions.Games.SetGameFavorite)
local GamePostFavorite = require(Modules.LuaApp.Thunks.Games.GamePostFavorite)
local SetGameFollow = require(Modules.LuaApp.Actions.SetGameFollow)
local SendGameFollow = require(Modules.LuaApp.Thunks.SendGameFollow)
local SetExperienceNotificationsEnabledCount = require(Modules.LuaApp.Actions.Games.SetExperienceNotificationsEnabledCount)
local OpenReportDialog = require(Modules.LuaApp.Thunks.OpenReportDialog)
local OpenReportScreen = require(Modules.LuaApp.Thunks.OpenReportScreen)
local OpenRequestRefundPage = require(Modules.LuaApp.Thunks.OpenRequestRefundPage)
local Constants = require(Modules.LuaApp.Constants)
local ShareLinkTypes = require(Modules.LuaApp.DeepLinks.ShareLinks.ShareLinkTypes)
local ApiFetchExperienceDetailsPage = require(Modules.LuaApp.Thunks.Games.ApiFetchExperienceDetailsPage)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagSignalsNavP3fGameDetails = SharedFlags.FFlagSignalsNavP3fGameDetails
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local v70 = if not FFlagSignalsNavP3fGameDetails then nil else require(CorePackages.Workspace.Packages.NavigationRodux).GetLegacyNavigationStore
local FFlagLuaAppFixFavoriteAndFollowOptionsText = require(Modules.LuaApp.Flags.FFlagLuaAppFixFavoriteAndFollowOptionsText)
local GetLuaAppGameDetailsMoreShareButtonEnabledV2 = require(Modules.LuaApp.Flags.GetLuaAppGameDetailsMoreShareButtonEnabledV2)
local GetFFlagLuafiedReportEntryPoints = SharedFlags.GetFFlagLuafiedReportEntryPoints
local GetFFlagEnableAbuseReport10ft = SharedFlags.GetFFlagEnableAbuseReport10ft
local GetNotificationsExperienceDetailsVariant = require(CorePackages.Workspace.Packages.SharedFlags).GetNotificationsExperienceDetailsVariant
local GetFFlagNotificationsForceEnableEDPDiscoverability = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagNotificationsForceEnableEDPDiscoverability
local FFlagLuaAppRenameFriendsToConnectionsEdp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppRenameFriendsToConnectionsEdp
local FFlagEnableAbuseReportRevampFlow = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableAbuseReportRevampFlow
local v79 = game:DefineFastFlag("EnableAbuseReportRevampExperience", false)
local FFlagAddThumbnailSelectorReport = SharedFlags.FFlagAddThumbnailSelectorReport
local FFlagLuaAppEdpBackendV2HydrateLegacyDefault = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyDefault
local FFlagLuaAppEdpBackendV2HydrateLegacyIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyIxp
local FFlagLuaAppEdpBackendV2SduiInterleaveDefault = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2SduiInterleaveDefault
local FFlagLuaAppEdpBackendV2SduiInterleaveIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2SduiInterleaveIxp
local v85 = game:DefineFastString("ExperienceDetailsCopyLinkExperimentVariant", "enableCopyLinkButton")
local v86 = game:DefineFastString("SocialExperienceDetailsContextualMenuLayer", "Social.ExperienceDetailsContextualMenu")
local v87 = Roact.PureComponent:extend("GameDetailMoreContextualMenu")

v87.validateProps = t.strictInterface({
	universeId = t.string,
	menuPosition = t.optional(t.UDim2),
	onClose = t.optional(t.callback),
	menuAnchorPoint = t.optional(t.Vector2),
	externalContentSharingProtocol = t.table,
	hideCloseButton = t.optional(t.boolean),
	shouldHydrateLegacyIxp = if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else t.optional(t.boolean),
	edpServerIxpVariables = t.optional(t.table),
	closeCentralOverlayThunk = t.optional(t.callback),
	focusController = t.optional(t.table),
	defaultChildRef = t.optional(t.table),
	rootPlaceId = t.optional(t.string),
	isFavorite = t.optional(t.boolean),
	gameFollowings = t.optional(t.table),
	currentPage = t.string,
	shareButtonEnabled = t.boolean,
	screenSize = t.optional(t.Vector2),
	deviceOrientation = t.string,
	notificationsEnabled = t.table,
	refundLink = t.optional(t.string),
	closeCallback = t.callback,
	gamePostFavorite = t.callback,
	setGameFavorite = t.callback,
	sendGameFollow = t.callback,
	setGameFollow = t.callback,
	setCurrentToastMessage = t.callback,
	navigateDown = t.callback,
	setToastMessage = t.callback,
	reportExperienceDialog = if not GetFFlagLuafiedReportEntryPoints() then nil else t.callback,
	reportExperienceScreen = if not GetFFlagEnableAbuseReport10ft() then nil else t.callback,
	setExperienceNotificationsEnabledCount = t.callback,
	openRequestRefundPage = t.callback,
	fetchGameDetail = t.callback,
	fetchPlayabilityAndProductInfo = t.callback,
	openDynamicAbuseReport = if not FFlagEnableAbuseReportRevampFlow or not v79 then nil else t.callback,
	shouldShowShareButton = t.boolean,
	shouldShareToProvider = t.boolean,
	reportingDisabled = t.boolean,
	supportsWebViews = t.boolean,
	useLuafiedReportFlow = if not GetFFlagLuafiedReportEntryPoints() and not GetFFlagEnableAbuseReport10ft() then nil else t.optional(t.boolean),
	inviteFriendsDisabled = t.boolean,
	webViewSupport = t.boolean,
	notificationsCanEnableExperience = t.boolean,
	renameFriendsToConnections = if not FFlagLuaAppRenameFriendsToConnectionsEdp then nil else t.optional(t.boolean),
	enableNotificationsDiscoverability = if GetFFlagNotificationsForceEnableEDPDiscoverability() then nil else t.boolean,
	enableNotificationsRebrand = if GetFFlagNotificationsForceEnableEDPDiscoverability() then nil else t.boolean,
	enableCopyLink = t.optional(t.any),
	shareLinkId = t.optional(t.string),
	networking = t.callback,
	localization = t.table,
	eventIngest = t.table,
	guiService = if not GetFFlagEnableAbuseReport10ft() then nil else t.union(t.Instance, t.table)
})

local function generateExperienceDetailsShareLinkUrl(p1, p2, p3) -- line: 197
	-- upvalues: UrlBuilder (copy), ShareLinkTypes (copy)
	if p1 then
		local str = tostring(DateTime.now().UnixTimestampMillis)

		return UrlBuilder.sharelinks.shortUrl({
			linkId = p1,
			type = ShareLinkTypes.ExperienceDetails,
			stamp = str
		}), str
	end

	return UrlBuilder.game.info.appsflyer({
		universeId = p2,
		placeId = p3
	}), nil
end

v87.defaultProps = {
	externalContentSharingProtocol = ExternalContentSharingProtocol.default,
	onClose = function() -- line: 218
	end
}

function v87.init(p4) -- line: 221
	-- upvalues: UrlBuilder (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy)
	p4.isMounted = false
	p4.menuItemNames = {}

	function p4.getMenuPos() -- line: 225
		-- upvalues: p4 (copy)
		if p4.props.menuPosition == nil then
			return UDim2.fromOffset(0, 0)
		end

		return p4.props.menuPosition
	end
	function p4.getMenuSize() -- line: 233
		return UDim2.new(0, 300, 1, 0)
	end
	function p4.getMenuAnchor() -- line: 237
		-- upvalues: p4 (copy)
		if p4.props.menuPosition == nil or p4.props.screenSize == nil then
			return nil
		end

		if p4.props.menuAnchorPoint then
			return p4.props.menuAnchorPoint
		end

		return Vector2.new(0, 0)
	end
	function p4.getLinkPage() -- line: 246
		-- upvalues: UrlBuilder (copy), p4 (copy)
		return (UrlBuilder.game.report({
			placeId = p4.props.rootPlaceId
		}))
	end
	function p4.closeCallback() -- line: 253
		-- upvalues: p4 (copy)
		if p4.props.onClose then
			p4.props.onClose()
		end

		p4.props.closeCallback()
	end
	function p4.onRequestRefundPageClose() -- line: 261
		-- upvalues: p4 (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy)
		p4.props.fetchGameDetail(p4.props.networking, p4.props.universeId, if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else p4.props.shouldHydrateLegacyIxp)
		p4.props.fetchPlayabilityAndProductInfo(p4.props.networking, p4.props.universeId)
	end
end
function v87.renderContextualMenuContent(p5, p6) -- line: 279
	-- upvalues: FFlagLuaAppRenameFriendsToConnectionsEdp (copy), Images (copy), FFlagLuaAppFixFavoriteAndFollowOptionsText (copy), GetFFlagNotificationsForceEnableEDPDiscoverability (copy), FFlagLuaAppEdpBackendV2SduiInterleaveDefault (copy), FFlagLuaAppEdpBackendV2SduiInterleaveIxp (copy), ExperienceDetailsExperimentation (copy), Favorite (copy), ToastType (copy), Follow (copy), GameInviteAnalyticsManager (copy), GameInviteModalManager (copy), GameInviteConstants (copy), generateExperienceDetailsShareLinkUrl (copy), CopyExperienceLink (copy), AppPage (copy), ShareExperienceLink (copy), GetFFlagEnableAbuseReport10ft (copy), Constants (copy), FFlagEnableAbuseReportRevampFlow (copy), v79 (copy), AbuseVector (copy), FFlagAddThumbnailSelectorReport (copy), RequestRefundClick (copy)
	local t1 = {}

	p5.menuItemNames = {}

	local rootPlaceId = p5.props.rootPlaceId
	local eventIngest = p5.props.eventIngest
	local networking = p5.props.networking
	local universeId = p5.props.universeId
	local guiService = p5.props.guiService
	local notificationsCanEnableExperience = p5.props.notificationsCanEnableExperience
	local v107 = if not FFlagLuaAppRenameFriendsToConnectionsEdp then nil else p5.props.renameFriendsToConnections
	local v108 = Images["icons/actions/favoriteOn"]
	local v109 = Images["icons/actions/favoriteOff"]
	local v110 = p5.props.isFavorite ~= nil and (p5.props.isFavorite or false)
	local v111 = p5.props.isFavorite == nil
	local v112 = v110 and v108 or v109
	local favoriteLabel = p6.favoriteLabel

	if FFlagLuaAppFixFavoriteAndFollowOptionsText then
		favoriteLabel = v110 and p6.favoritedLabel or p6.favoriteLabel
	end

	local v114 = not not GetFFlagNotificationsForceEnableEDPDiscoverability() or p5.props.enableNotificationsDiscoverability

	if not FFlagLuaAppEdpBackendV2SduiInterleaveDefault and (not FFlagLuaAppEdpBackendV2SduiInterleaveIxp or not ExperienceDetailsExperimentation.getShouldInterleaveSdui()) or (not p5.props.edpServerIxpVariables or p5.props.edpServerIxpVariables.hideFavoritesInContextMenu ~= true) then
		table.insert(t1, {
			stayOnActivated = true,
			icon = v112,
			text = favoriteLabel,
			onActivated = function() -- line: 328
				-- upvalues: p5 (copy), v111 (copy), rootPlaceId (copy), networking (copy), universeId (copy), v110 (copy), Favorite (copy), eventIngest (copy)
				if not p5.isMounted or (v111 or not rootPlaceId) then
					return
				end

				local v158 = networking

				p5.props.setGameFavorite(universeId, not v110)
				p5.props.gamePostFavorite(v158, universeId, not v110)
				Favorite(eventIngest, "GameDetailMoreContextualMenu", rootPlaceId, not v110)
			end
		})
		table.insert(p5.menuItemNames, "Favorite")
	end

	if notificationsCanEnableExperience and not v114 and (not FFlagLuaAppEdpBackendV2SduiInterleaveDefault and (not FFlagLuaAppEdpBackendV2SduiInterleaveIxp or not ExperienceDetailsExperimentation.getShouldInterleaveSdui()) or (not p5.props.edpServerIxpVariables or p5.props.edpServerIxpVariables.hideNotifyInContextMenu ~= true)) then
		local v115 = p5.props.gameFollowings == nil
		local v116 = p5.props.gameFollowings ~= nil and (p5.props.gameFollowings.isFollowed or false)
		local v117 = Images["icons/common/notificationOn"]
		local v118 = Images["icons/common/notificationOff"]
		local followLabel = p6.followLabel

		if FFlagLuaAppFixFavoriteAndFollowOptionsText then
			followLabel = v116 and p6.followingLabel or p6.followLabel
		end

		table.insert(t1, {
			stayOnActivated = true,
			text = followLabel,
			icon = v116 and v117 or v118,
			disabled = v115,
			onActivated = function() -- line: 372
				-- upvalues: p5 (copy), v115 (copy), rootPlaceId (copy), ToastType (copy), universeId (copy), networking (copy), Follow (copy), eventIngest (copy)
				if not p5.isMounted or (v115 or not rootPlaceId) then
					return
				end

				local isFollowed = p5.props.gameFollowings.isFollowed
				local setCurrentToastMessage = p5.props.setCurrentToastMessage
				local v161 = p5.props.notificationsEnabled.count or 0
				local v162 = p5.props.notificationsEnabled.limit or 0

				if not isFollowed then
					if v162 <= v161 then
						setCurrentToastMessage({
							toastType = ToastType.GameFollowError,
							toastMessage = not p5.props.enableNotificationsRebrand and "Feature.GameFollows.TooltipFollowLimitReached" or "Feature.GameFollows.TooltipNotificationsLimitReached"
						})

						return
					end

					p5.props.setExperienceNotificationsEnabledCount(v161 + 1)
				else
					p5.props.setExperienceNotificationsEnabledCount(v161 - 1)
				end

				p5.props.setGameFollow(universeId, not isFollowed)
				p5.props.sendGameFollow(networking, universeId, not isFollowed, false, v161, v162)
				Follow(eventIngest, "GameDetailMoreContextualMenu", rootPlaceId, not isFollowed)
			end
		})
		table.insert(p5.menuItemNames, "Follow")
	end

	if not p5.props.inviteFriendsDisabled then
		table.insert(t1, {
			text = if not FFlagLuaAppRenameFriendsToConnectionsEdp or not v107 then p6.inviteFriends else p6.inviteConnections,
			icon = Images["icons/actions/friends/friendInvite"],
			onActivated = function() -- line: 422
				-- upvalues: p5 (copy), rootPlaceId (copy), GameInviteAnalyticsManager (copy), universeId (copy), GameInviteModalManager (copy), GameInviteConstants (copy)
				if not p5.isMounted or not rootPlaceId then
					return
				end

				GameInviteAnalyticsManager:withButtonName(GameInviteAnalyticsManager.ButtonName.GameDetailsMoreMenu)
				GameInviteAnalyticsManager:inputShareGameEntryPoint(rootPlaceId, universeId)
				GameInviteModalManager:openModal({
					trigger = GameInviteConstants.Triggers.GameDetailsMoreMenu,
					rootPlaceId = rootPlaceId,
					universeId = universeId,
					hideCloseButton = p5.props.hideCloseButton
				})
				p5.closeCallback()
			end
		})
		table.insert(p5.menuItemNames, "InviteFriends")
	end

	if p5.props.enableCopyLink then
		table.insert(t1, {
			icon = Images["icons/menu/link"],
			onActivated = function() -- line: 446
				-- upvalues: p5 (copy), rootPlaceId (copy), generateExperienceDetailsShareLinkUrl (copy), universeId (copy), CopyExperienceLink (copy), eventIngest (copy), ToastType (copy)
				if not p5.isMounted or not rootPlaceId then
					return
				end

				local v163, v164 = generateExperienceDetailsShareLinkUrl(p5.props.shareLinkId, universeId, rootPlaceId)

				p5.props.externalContentSharingProtocol:shareUrl({
					context = "GameDetailsMoreWebURL",
					url = v163
				})
				CopyExperienceLink(eventIngest, "GameDetailMoreContextualMenu", rootPlaceId, {
					stamp = v164
				})
				p5.props.setCurrentToastMessage({
					toastMessage = "Feature.GameDetails.Toast.LinkCopied",
					toastType = ToastType.SuccessConfirmation
				})
				p5.closeCallback()
			end,
			text = p6.copyLink
		})
		table.insert(p5.menuItemNames, "CopyLink")
	end

	if p5.props.shareButtonEnabled and p5.props.shouldShowShareButton then
		table.insert(t1, {
			text = p6.share,
			icon = Images["icons/actions/share"],
			onActivated = function() -- line: 479
				-- upvalues: p5 (copy), rootPlaceId (copy), AppPage (copy), universeId (copy), generateExperienceDetailsShareLinkUrl (copy), ShareExperienceLink (copy), eventIngest (copy)
				if not p5.isMounted or not rootPlaceId then
					return
				end

				if p5.props.shouldShareToProvider then
					p5.props.navigateDown({
						name = AppPage.SdkShare,
						extraProps = {
							context = "GameDetailsMoreWebURL",
							universeId = universeId
						}
					})
				else
					local v165, v166 = generateExperienceDetailsShareLinkUrl(p5.props.shareLinkId, universeId, rootPlaceId)

					ShareExperienceLink(eventIngest, "GameDetailMoreContextualMenu", rootPlaceId, {
						shareToAppsflyer = true,
						shortShareLinkFailed = not p5.props.shareLinkId,
						stamp = v166,
						linkId = p5.props.shareLinkId
					})
					p5.props.externalContentSharingProtocol:shareUrl({
						context = "GameDetailsMoreWebURL",
						url = v165
					})
				end

				p5.closeCallback()
			end
		})
		table.insert(p5.menuItemNames, "ShareExperienceLink")
	end

	if not p5.props.reportingDisabled then
		table.insert(t1, {
			text = p6.report,
			icon = Images["icons/actions/feedback"],
			onActivated = function() -- line: 518
				-- upvalues: p5 (copy), rootPlaceId (copy), GetFFlagEnableAbuseReport10ft (copy), guiService (copy), Constants (copy), universeId (copy), FFlagEnableAbuseReportRevampFlow (copy), v79 (copy), AbuseVector (copy), FFlagAddThumbnailSelectorReport (copy), AppPage (copy), p6 (copy)
				if not p5.isMounted or not rootPlaceId then
					return
				end

				if p5.props.useLuafiedReportFlow then
					if GetFFlagEnableAbuseReport10ft() and guiService and guiService:IsTenFootInterface() then
						p5.props.reportExperienceScreen({
							context = Constants.ReportScreen.Contexts.Experience,
							assetId = tostring(rootPlaceId),
							reportAbuseVector = Constants.ReportScreen.AbuseVectors.Place,
							platform = Constants.ReportScreen.Platforms.Console
						})
					else
						p5.props.reportExperienceDialog({
							reportEntryPoint = Constants.ReportDialogEntryPoints.ExperienceDetails,
							universeId = universeId,
							rootPlaceId = rootPlaceId
						})
					end

					p5.closeCallback()

					return
				end

				if FFlagEnableAbuseReportRevampFlow and v79 then
					p5.props.openDynamicAbuseReport({
						abuseVector = AbuseVector.Place,
						targetId = rootPlaceId,
						custom = if not FFlagAddThumbnailSelectorReport then nil else {
							universeId = universeId
						},
						onClose = function() -- line: 550
							-- upvalues: p5 (copy)
							p5.closeCallback()
						end
					})

					return
				end

				if not p5.props.supportsWebViews then
					p5.props.setToastMessage(Constants.WEBVIEWS_UNAVAILABLE_TOAST)

					return
				end

				p5.props.navigateDown({
					name = AppPage.GenericWebPage,
					detail = p5:getLinkPage(),
					extraProps = {
						title = p6.localizedTextReport
					}
				})
				p5.closeCallback()
			end
		})
		table.insert(p5.menuItemNames, "Report")
	end

	if p5.props.refundLink and p5.props.webViewSupport then
		table.insert(t1, {
			text = p6.requestRefund,
			icon = Images["icons/menu/wallet"],
			onActivated = function() -- line: 577
				-- upvalues: p5 (copy), rootPlaceId (copy), RequestRefundClick (copy)
				if not p5.isMounted or not rootPlaceId then
					return
				end

				local eventIngest2 = p5.props.eventIngest

				RequestRefundClick(eventIngest2, "GameDetailMoreContextualMenu", rootPlaceId)
				p5.props.openRequestRefundPage(p5.props.refundLink, p5.onRequestRefundPageClose)
				p5.closeCallback()
			end
		})
		table.insert(p5.menuItemNames, "RequestRefund")
	end

	return t1
end
function v87.renderLandscapeContextualMenu(p7, p8) -- line: 596
	-- upvalues: Roact (copy), ContextualMenu (copy), Otter (copy)
	local screenSize = p7.props.screenSize
	local v123 = p7:renderContextualMenuContent(p8)
	local v124 = p7.getMenuPos()
	local v125 = p7:getMenuAnchor()
	local v126 = p7.getMenuSize()

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Position = v124,
		Size = v126
	}, {
		ContextMenu = Roact.createElement(ContextualMenu, {
			open = true,
			closeBackgroundVisible = false,
			buttonProps = v123,
			horizontalAlignment = Enum.HorizontalAlignment.Left,
			openPositionX = UDim.new(0, 0),
			openPositionY = UDim.new(0, 0),
			screenSize = screenSize,
			onDismiss = p7.closeCallback,
			contextMenuWidthOverride = UDim.new(1, 0),
			anchorPointOverride = v125,
			motorOverrideOptions = {
				motorCallback = Otter.instant,
				open = {
					targetValue = 1
				},
				close = {
					targetValue = 0
				}
			}
		})
	})
end
function v87.renderPortraitContextualMenu(p9, p10) -- line: 632
	-- upvalues: DeviceOrientationMode (copy), Roact (copy), ContextualMenu (copy), MenuDirection (copy)
	local screenSize = p9.props.screenSize
	local v130 = p9:renderContextualMenuContent(p10)
	local v131 = p9.props.deviceOrientation == DeviceOrientationMode.Portrait
	local v132 = screenSize ~= nil and (screenSize.X > 0 and p9.props.menuPosition.X.Offset / screenSize.X / 2) or 0

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.new(if not v131 then v132 else 0, 0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		ContextMenu = Roact.createElement(ContextualMenu, {
			open = true,
			closeBackgroundVisible = false,
			buttonProps = v130,
			menuDirection = MenuDirection.Up,
			openPositionY = UDim.new(1, -76),
			screenSize = screenSize,
			onDismiss = p9.closeCallback
		})
	})
end
function v87.didMount(p11) -- line: 665
	-- upvalues: AppPage (copy), OpenMore (copy)
	p11.isMounted = true

	local currentPage = p11.props.currentPage

	if currentPage ~= AppPage.GameDetail and currentPage ~= AppPage.ExperienceDetail then
		p11.closeCallback()

		return
	end

	local eventIngest = p11.props.eventIngest
	local rootPlaceId = p11.props.rootPlaceId
	local v137 = table.concat(p11.menuItemNames, ",")

	OpenMore(eventIngest, "GameDetailMoreContextualMenu", rootPlaceId, {
		moreMenuItems = v137
	})
end
function v87.willUnmount(p12) -- line: 683
	p12.isMounted = false
end
function v87.render(p13) -- line: 687
	-- upvalues: withLocalization (copy), FFlagLuaAppRenameFriendsToConnectionsEdp (copy), DeviceOrientationMode (copy)
	return withLocalization({
		favoriteLabel = "Feature.Favorites.Label.Favorite",
		favoritedLabel = "Feature.Favorites.Label.Favorited",
		followingLabel = "Feature.Friends.Label.Following",
		inviteFriends = "Feature.GameDetails.Action.InviteFriends",
		copyLink = "Feature.GameDetails.Action.CopyLink",
		share = "Feature.SocialShare.Action.Share",
		report = "Feature.GameDetails.Action.Report",
		requestRefund = "Feature.GameDetails.Action.Refund",
		followLabel = not p13.props.enableNotificationsRebrand and "Feature.GameDetails.Label.Follow" or "Feature.GameFollows.LabelNotifications",
		inviteConnections = if not FFlagLuaAppRenameFriendsToConnectionsEdp then nil else "CommonUI.Features.Label.InviteConnections"
	})(function(p14) -- line: 703
		-- upvalues: p13 (copy), DeviceOrientationMode (copy)
		if p13.props.deviceOrientation == DeviceOrientationMode.Portrait then
			return p13:renderPortraitContextualMenu(p14)
		end

		return p13:renderLandscapeContextualMenu(p14)
	end)
end

local v89 = RoactRodux.connect(function(p15, p16) -- line: 716
	-- upvalues: FFlagLuaAppEdpBackendV2HydrateLegacyDefault (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), GameInfosReducer (copy), FFlagSignalsNavP3fGameDetails (copy), SharedFlags (copy), Selectors (copy), GetLuaAppGameDetailsMoreShareButtonEnabledV2 (copy)
	local v142 = if not FFlagLuaAppEdpBackendV2HydrateLegacyDefault and (not FFlagLuaAppEdpBackendV2HydrateLegacyIxp or not p16.shouldHydrateLegacyIxp) then p15.GameDetails[p16.universeId] else p15.GameDetailsV2 and p15.GameDetailsV2[p16.universeId] or nil
	local v143 = p15.Personalization[GameInfosReducer.key][p16.universeId]

	return {
		rootPlaceId = v142 and v142.rootPlaceId or v143 and v143.placeId,
		isFavorite = p15.GameFavorites[p16.universeId],
		gameFollowings = p15.GameFollowings[p16.universeId],
		currentPage = if not FFlagSignalsNavP3fGameDetails then if not SharedFlags.FFlagUseNavigationSelectors then p15.Navigation.currentRoute.routeName else Selectors.selectCurrentRoactNavigationRoute(p15).routeName else nil,
		shareButtonEnabled = GetLuaAppGameDetailsMoreShareButtonEnabledV2(p15.LocalUserId),
		screenSize = p15.ScreenSize,
		deviceOrientation = p15.DeviceOrientation,
		notificationsEnabled = p15.ExperienceNotificationsEnabled or {},
		refundLink = if not v142 then nil else v142.refundLink
	}
end, function(p17) -- line: 745
	-- upvalues: CloseCentralOverlay (copy), GamePostFavorite (copy), SetGameFavorite (copy), SendGameFollow (copy), SetGameFollow (copy), SetCurrentToastMessage (copy), FFlagSignalsNavP3Dispatch (copy), v29 (copy), NavigateDown (copy), GetFFlagLuafiedReportEntryPoints (copy), OpenReportDialog (copy), GetFFlagEnableAbuseReport10ft (copy), OpenReportScreen (copy), SetExperienceNotificationsEnabledCount (copy), OpenRequestRefundPage (copy), FFlagLuaAppEdpBackendV2HydrateLegacyDefault (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), ApiFetchExperienceDetailsPage (copy), ApiFetchGameDetails (copy), FetchGamePlayabilityAndProductInfo (copy), FFlagEnableAbuseReportRevampFlow (copy), v79 (copy), OpenDynamicAbuseReport (copy)
	return {
		closeCallback = function() -- line: 747
			-- upvalues: p17 (copy), CloseCentralOverlay (copy)
			p17(CloseCentralOverlay())
		end,
		gamePostFavorite = function(p18, p19, p20) -- line: 750
			-- upvalues: p17 (copy), GamePostFavorite (copy)
			return p17(GamePostFavorite(p18, p19, p20))
		end,
		setGameFavorite = function(p21, p22) -- line: 753
			-- upvalues: p17 (copy), SetGameFavorite (copy)
			return p17(SetGameFavorite(p21, p22))
		end,
		sendGameFollow = function(p23, p24, p25, p26, p27, p28) -- line: 756
			-- upvalues: p17 (copy), SendGameFollow (copy)
			return p17(SendGameFollow(p23, p24, p25, p26, p27, p28))
		end,
		setGameFollow = function(p29, p30) -- line: 775
			-- upvalues: p17 (copy), SetGameFollow (copy)
			return p17(SetGameFollow(p29, p30))
		end,
		setCurrentToastMessage = function(p31) -- line: 778
			-- upvalues: p17 (copy), SetCurrentToastMessage (copy)
			return p17(SetCurrentToastMessage(p31))
		end,
		navigateDown = function(p32) -- line: 781
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v29 (copy), p17 (copy), NavigateDown (copy)
			if FFlagSignalsNavP3Dispatch then
				return v29.down(v29.fromLegacyPage(p32))
			end

			return p17(NavigateDown(p32))
		end,
		setToastMessage = function(p33) -- line: 788
			-- upvalues: p17 (copy), SetCurrentToastMessage (copy)
			return p17(SetCurrentToastMessage(p33))
		end,
		reportExperienceDialog = if not GetFFlagLuafiedReportEntryPoints() then nil else function(p34) -- line: 792
			-- upvalues: p17 (copy), OpenReportDialog (copy)
			return p17(OpenReportDialog(p34))
		end,
		reportExperienceScreen = if not GetFFlagEnableAbuseReport10ft() then nil else function(p35) -- line: 797
			-- upvalues: p17 (copy), OpenReportScreen (copy)
			return p17(OpenReportScreen(p35))
		end,
		setExperienceNotificationsEnabledCount = function(p36) -- line: 801
			-- upvalues: p17 (copy), SetExperienceNotificationsEnabledCount (copy)
			return p17(SetExperienceNotificationsEnabledCount(p36))
		end,
		openRequestRefundPage = function(p37, p38) -- line: 804
			-- upvalues: p17 (copy), OpenRequestRefundPage (copy)
			return p17(OpenRequestRefundPage(p37, p38))
		end,
		fetchGameDetail = function(p39, p40, p41) -- line: 807
			-- upvalues: FFlagLuaAppEdpBackendV2HydrateLegacyDefault (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), p17 (copy), ApiFetchExperienceDetailsPage (copy), ApiFetchGameDetails (copy)
			if FFlagLuaAppEdpBackendV2HydrateLegacyDefault or FFlagLuaAppEdpBackendV2HydrateLegacyIxp and p41 then
				return p17(ApiFetchExperienceDetailsPage.Fetch(p39, p40, p41, nil))
			end

			return p17(ApiFetchGameDetails.Fetch(p39, { p40 }))
		end,
		fetchPlayabilityAndProductInfo = function(p42, p43) -- line: 819
			-- upvalues: p17 (copy), FetchGamePlayabilityAndProductInfo (copy)
			return p17(FetchGamePlayabilityAndProductInfo.Fetch(p42, p43))
		end,
		openDynamicAbuseReport = if not FFlagEnableAbuseReportRevampFlow or not v79 then nil else function(p44) -- line: 823
			-- upvalues: p17 (copy), OpenDynamicAbuseReport (copy)
			return p17(OpenDynamicAbuseReport(p44))
		end
	}
end)(v87)
local v90 = RoactAppPolicy.connect(function(p45, _) -- line: 830
	-- upvalues: GetFFlagLuafiedReportEntryPoints (copy), GetFFlagEnableAbuseReport10ft (copy), FFlagLuaAppRenameFriendsToConnectionsEdp (copy)
	return {
		shouldShowShareButton = p45.shouldShowGameDetailsShareButton(),
		shouldShareToProvider = p45.shouldShareToAccountProvider(),
		reportingDisabled = p45.getGameReportingDisabled(),
		supportsWebViews = p45.getWebViewSupport(),
		useLuafiedReportFlow = if not GetFFlagLuafiedReportEntryPoints() and not GetFFlagEnableAbuseReport10ft() then nil else p45.getUseLuafiedReportFlow(),
		inviteFriendsDisabled = p45.getInviteFriendsDisabled(),
		webViewSupport = p45.getWebViewSupport(),
		notificationsCanEnableExperience = p45.getNotificationsCanReceiveExperience(),
		renameFriendsToConnections = if not FFlagLuaAppRenameFriendsToConnectionsEdp then nil else p45.getRenameFriendsToConnections()
	}
end)(v89)

if not GetFFlagNotificationsForceEnableEDPDiscoverability() then
	v90 = RoactAppExperiment.connectUserLayer({ AppUserLayers.ExperienceDetailsPageLayer }, function(p47, _) -- line: 851
		-- upvalues: AppUserLayers (copy), GetNotificationsExperienceDetailsVariant (copy)
		local v149 = (p47[AppUserLayers.ExperienceDetailsPageLayer] or {})[GetNotificationsExperienceDetailsVariant.getNotificationsVariantFieldName] or -1

		return {
			enableNotificationsDiscoverability = v149 == 2,
			enableNotificationsRebrand = v149 > 0
		}
	end)(v90)
end

local v91 = gql("\t\tquery ExperienceDetailsLink($universeId: String!) {\n\t\t\texperienceDetailsLinkByUniverseId(universeId: $universeId) {\n\t\t\t\tlinkId\n\t\t\t}\n\t\t}\n\t")
local v92 = v90

return RoactServices.connect({
	networking = RoactNetworking,
	localization = RoactLocalization,
	eventIngest = AppEventIngestService,
	guiService = if not GetFFlagEnableAbuseReport10ft() then nil else AppGuiService
})(function(p49) -- line: 871
	-- upvalues: useQuery (copy), v91 (copy), useUserExperiment (copy), v86 (copy), v85 (copy), FFlagLuaAppEdpBackendV2SduiInterleaveDefault (copy), FFlagLuaAppEdpBackendV2SduiInterleaveIxp (copy), useEdpServerIxpVariables (copy), FFlagSignalsNavP3fGameDetails (copy), v70 (copy), useSignalState (copy), Cryo (copy), ExperienceDetailsExperimentation (copy), Roact (copy), v92 (copy)
	local linkId = nil
	local v152 = useQuery(v91, {
		variables = {
			universeId = p49.universeId
		}
	})

	if v152.data and v152.data.experienceDetailsLinkByUniverseId then
		linkId = v152.data.experienceDetailsLinkByUniverseId.linkId
	end

	local v153 = useUserExperiment({ v86 }, function(p50) -- line: 886
		-- upvalues: v86 (copy), v85 (copy)
		return (p50[v86] or {})[v85]
	end, true)
	local v154 = nil

	if FFlagLuaAppEdpBackendV2SduiInterleaveDefault or FFlagLuaAppEdpBackendV2SduiInterleaveIxp then
		v154 = useEdpServerIxpVariables()
	end

	local v155 = nil

	if FFlagSignalsNavP3fGameDetails then
		local v156 = v70(false)

		v155 = useSignalState(v156.getCurrentPage)
	end

	local v157 = Cryo.Dictionary.join(p49, {
		enableCopyLink = v153,
		shareLinkId = linkId,
		edpServerIxpVariables = if not FFlagLuaAppEdpBackendV2SduiInterleaveDefault and (not FFlagLuaAppEdpBackendV2SduiInterleaveIxp or not ExperienceDetailsExperimentation.getShouldInterleaveSdui()) then nil else v154,
		currentPage = if not FFlagSignalsNavP3fGameDetails then nil else v155.name
	})

	return Roact.createElement(v92, v157)
end)
