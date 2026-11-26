local CorePackages = game:GetService("CorePackages")
local AdService = game:GetService("AdService")
local ExperienceService = game:GetService("ExperienceService")
local IXPService = game:GetService("IXPService")
local Roact = require(CorePackages.Packages.Roact)
local none = Roact.None
local Cryo = require(CorePackages.Packages.Cryo)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local memoize = require("@game/CorePackages/Workspace/Packages/AppCommonLib").memoize
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local roactNetworking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").RoactNetworking
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local usePlayButtonState = require("@luauforge/bundled/fIC").usePlayButtonState
local playButtonStates = require("@luauforge/bundled/fIC").PlayButtonStates

local fetchGamePlayabilityAndProductInfo = require("@luauforge/bundled/dBl").FetchGamePlayabilityAndProductInfo
local playabilityStatusEnum = require("@luauforge/bundled/cBc").PlayabilityStatusEnum
local enumGameDetailErrorTypes = require("@luauforge/bundled/cBc").EnumGameDetailErrorTypes
local getSafeAreaSize = require("@luauforge/bundled/fCf").getSafeAreaSize
local retrievalStatus = require("@game/CorePackages/Workspace/Packages/Http").Enum.RetrievalStatus
local module = require("@luauforge/bundled/dCS")
local nextDataExpirationTimeReducer = module.NextDataExpirationTimeReducer
local expirationTimeNamespace = module.ExpirationTimeNamespace
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local module2 = require("@luauforge/bundled/dzP")
local appEventIngestService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppEventIngestService
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local appUserLayers = require("@luauforge/bundled/dPQ").AppUserLayers

local module3 = require("@luauforge/deferred/gBX")
local GameHydrationReact = require("@game/CorePackages/Workspace/Packages/GameHydrationReact")
local experienceDetailsNoticeType = require("@luauforge/bundled/cBc").ExperienceDetailsNoticeType
local UIBlox = require(CorePackages.Packages.UIBlox)

local images = UIBlox.App.ImageSet.Images

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local withStyle = UIBlox.Style.withStyle
local loadingStateContainer = UIBlox.App.Container.LoadingStateContainer
local retrievalStatus2 = UIBlox.App.Loading.Enum.RetrievalStatus
local emptyState = UIBlox.App.Indicator.EmptyState
local playWithRewardComponent = require("@luauforge/deferred/gBY").PlayWithRewardComponent

local fetchPlayWithRewardState = require("@luauforge/deferred/gBY").FetchPlayWithRewardState
local setPlayWithRewardState = require("@luauforge/bundled/gBZ").SetPlayWithRewardState
local module5 = require("@luauforge/deferred/gCa")

local module6 = require("@luauforge/deferred/gCb")

local modules = require("@luauforge/bundled/dtb").Modules
local mediaGallerySwiped = modules.LuaApp.Analytics.Events.Games.GameDetailsEvents.MediaGallerySwiped

local mediaGalleryMediaChanged = modules.LuaApp.Analytics.Events.Games.GameDetailsEvents.MediaGalleryMediaChanged

local checkAndFormatPossibleLink = require("@luauforge/bundled/ehg").checkAndFormatPossibleLink

local module7 = require("@luauforge/bundled/dzD")
local module8 = require("@luauforge/deferred/gBI")
local module9 = require("@luauforge/deferred/gBM")
local module10 = require("@luauforge/deferred/gCc")
local module11 = require("@luauforge/deferred/gCe")
local module12 = require("@luauforge/deferred/gCZ")
local module13 = require("@luauforge/deferred/gDp")
local module14 = require("@luauforge/deferred/gDu")
local module15 = require("@luauforge/deferred/gDx")
local module16 = require("@luauforge/deferred/gDB")
local module17 = require("@luauforge/deferred/gDD")
local module18 = require("@luauforge/deferred/gDF")
local module19 = require("@luauforge/deferred/gDK")
local module20 = require("@luauforge/deferred/gDY")
local module21 = require("@luauforge/deferred/gDZ")
local module22 = require("@luauforge/deferred/gDl")
local module23 = require("@luauforge/bundled/fzL")
local module24 = require("@luauforge/deferred/gEa")
local module25 = require("@luauforge/deferred/gEV")
local module26 = require("@luauforge/deferred/gBN")
local module27 = require("@luauforge/bundled/dDZ")

local module28 = require("@luauforge/bundled/dKu")
local edpttiConstants = module28.EDPTTIConstants
local fFlagEDPTTITrackingEnabled = module28.FFlagEDPTTITrackingEnabled
local module29 = require("@luauforge/deferred/gEY")

local useFirstMediaCarouselImageUri = require("@luauforge/deferred/gEZ").useFirstMediaCarouselImageUri
local fFlagSongEdpCarouselIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSongEdpCarouselIxp
local defineFastFlag = game:DefineFastFlag("LuaAppFixNoticeLocalization", false)

local fFlagLuaAppEdpMediaGalleryRedesignIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryRedesignIxp

local fFlagLuaAppEdpMediaGalleryVideoPreviewIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryVideoPreviewIxp

local fFlagLuaAppEdpMediaGalleryRedesignTelemetry = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryRedesignTelemetry

local fFlagLuaAppEdpBackendV2HydrateLegacyIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2HydrateLegacyIxp

local fFlagEnablePlayWithRewardComponent = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnablePlayWithRewardComponent

local fFlagPlayWithRewardClearOnExperienceLeave = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagPlayWithRewardClearOnExperienceLeave

local fFlagLuaAppEdpBackendV2SduiInterleaveDefault = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2SduiInterleaveDefault

local fFlagLuaAppEdpBackendV2SduiInterleaveIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2SduiInterleaveIxp

local fFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable

local fFlagLuaAppAddUniverseIdToGameDetailsEvents = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppAddUniverseIdToGameDetailsEvents

local fFlagLuaAppEdpKeepCachedDetailsOnRefetch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpKeepCachedDetailsOnRefetch

local fFlagLuaAppEdpMediaGalleryHeightJitterFix = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryHeightJitterFix

local fFlagLuaAppUpdateFailedStateEdpIcon = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppUpdateFailedStateEdpIcon
local fFlagLuaAppAddTestIdsForArrow = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppAddTestIdsForArrow
local getTestId = require("@game/CorePackages/Workspace/Packages/RoactUtils").getTestId

local v5 = {
	{ Size = UDim2.new(0.5, 0, 0, 35) },
	{ Size = UDim2.new(0.25, 0, 0, 24) },
	{ Size = UDim2.new(1, 0, 0, 200) },
	{ Size = UDim2.new(1, 0, 0, 24) },
	{ Size = UDim2.new(0.6, 0, 0, 24) }
}

local fn = fFlagLuaAppEdpKeepCachedDetailsOnRefetch and function(p2, p3, p4, p5)
	local v6 = p4 == retrievalStatus.Fetching or p4 == retrievalStatus.NotStarted

	if p5 == nil or not v6 then
		return p4
	end

	local v7 = p2.Personalization[nextDataExpirationTimeReducer.key][expirationTimeNamespace.GameDetailPage]
	local v8 = v7 and v7[p3]

	local v9 = not (v8 == nil) and tick() <= v8

	if v9 then
		return retrievalStatus.Done
	end

	return p4
end or nil

local function getInnerPaddingSize(p2): number
	if p2 < 600 then
		return 20
	end

	return 40
end

local v6 = {
	Header = 100,
	MediaGallery = 125,
	StatsCarousel = 200,
	TagSection = 300,
	MovedEventsList = 400,
	Description = 500,
	IgrsRatingLabel = 550,
	PlaysAndRatings = 600,
	InfoList = 700,
	RefundPolicy = 900,
	Notice = 1000,
	RecommendedGames = 1100,
	ExperienceSongsCarousel = 1200,
	SduiFeedItemsDefault = 1500
}

local extended = Roact.PureComponent:extend("GameDetailsCard")

function extended:init()
	if fFlagEnablePlayWithRewardComponent then
		self.state = { didFocus = false }
		function self.onDidFocus()
			self:setState({ didFocus = true })
		end

		if fFlagPlayWithRewardClearOnExperienceLeave then
			self.didExperienceLeave = false
		end
	end

	self.gameInfoSubscription = GameHydrationReact.subscribeGameInfo({
		universeId = self.props.universeId,
		onChange = function(p2)
			self:setState({
				gameInfo = p2.gameInfo or none
			})
		end
	})

	local universeId = self.props.universeId
	module2.isType(universeId, "string", "GameDetailsCard.init.universeId")

	function self.fetchGameDetailsPageData()
		local networking = self.props.networking
		local universeId2 = self.props.universeId
		local fetchGameDetailsPageData = self.props.fetchGameDetailsPageData

		local shouldHydrateLegacyIxp = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then self.props.shouldHydrateLegacyIxp else nil
		local shouldInterleaveSduiIxp

		if fFlagLuaAppEdpBackendV2SduiInterleaveIxp then
			shouldInterleaveSduiIxp = self.props.shouldInterleaveSduiIxp
		end

		local v7 = if fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and self.props.shouldInterleaveSduiIxp then self.props.sduiDataUpdatedTimestamp else nil
		return fetchGameDetailsPageData(
			networking,
			universeId2,
			shouldHydrateLegacyIxp,
			shouldInterleaveSduiIxp,
			v7
		)
	end

	self.onMediaGallerySwiped = not fFlagLuaAppEdpMediaGalleryRedesignTelemetry and function()
		local rootPlaceId = self.props.gameDetail and self.props.gameDetail.rootPlaceId or nil

		if rootPlaceId then
			mediaGallerySwiped(
				self.props.eventIngest,
				"GameDetailsCard",
				rootPlaceId,
				fFlagLuaAppAddUniverseIdToGameDetailsEvents and {
					universeId = self.props.universeId
				} or nil
			)
		end
	end or nil

	self.onMediaGalleryMediaChanged = fFlagLuaAppEdpMediaGalleryRedesignTelemetry
		and function(p2, p3, p4, p5)
			local rootPlaceId = self.props.gameDetail and self.props.gameDetail.rootPlaceId or nil

			if rootPlaceId then
				local eventIngest = self.props.eventIngest

				local v10 = if fFlagLuaAppAddUniverseIdToGameDetailsEvents then self.props.universeId else nil
				mediaGalleryMediaChanged(eventIngest, "GameDetailsCard", rootPlaceId, {
					imageAssetId = p2,
					videoAssetId = p3,
					isYouTubeVideo = p4,
					autoAdvance = p5,
					universeId = v10
				})
			end
		end
		or nil

	self.linkStartStyle = memoize(function(p2)
		local color3 = p2.Tokens.Color.Content.Link.Color3
		return `<font color="{string.format(
			"rgb(%d, %d, %d)",
			math.round(color3.R * 255),
			math.round(color3.G * 255),
			(math.round(color3.B * 255))
		)}"><b>`
	end)

	self.checkAndFormatPossibleLink = memoize(function(p2, p3)
		return checkAndFormatPossibleLink(p3, nil, nil, self.linkStartStyle(p2), "</b></font>")
	end)

	function self.renderRefundPolicy(p2, p3, p4)
		local bodyLarge = p2.Tokens.Typography.BodyLarge
		local muted = p2.Tokens.Color.Content.Muted

		local v7, v8 = self.checkAndFormatPossibleLink(p2, p3.policyText)

		local createElement = Roact.createElement
		local v10 = {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = p4
		}

		local createElement2 = Roact.createElement
		local v13 = {
			BackgroundTransparency = 1,
			["Text"] = v8,
			AutomaticSize = Enum.AutomaticSize.XY,
			FontFace = normalizeFontFace(bodyLarge.Font),
			TextSize = bodyLarge.FontSize,
			TextColor3 = muted.Color3,
			TextTransparency = muted.Transparency,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			RichText = v7
		}

		local tag = React.Tag
		local v14 = if fFlagLuaAppAddTestIdsForArrow then getTestId("discovery-edp-game-refund-policy") else nil
		v13[tag] = v14

		v13[Roact.Event.Activated] = function(p5)
			self.props.openRefundPolicyLearnMorePage(p3.learnMoreUrl)
		end

		return createElement("Frame", v10, {
			RefundPolicy = createElement2("TextButton", v13)
		})
	end

	self.maybeFetchPlayWithReward = fFlagEnablePlayWithRewardComponent and function()
		if fFlagPlayWithRewardClearOnExperienceLeave then
			if not ((self.state.didFocus or self.didExperienceLeave) and self.props.gameDetailsPageDataStatus == retrievalStatus.Done) then
				return
			end

			if self.didExperienceLeave then
				self.didExperienceLeave = false
			end
		elseif
			self.state.didFocus ~= true
			or self.props.gameDetailsPageDataStatus ~= retrievalStatus.Done
		then
			return
		end

		if
			fFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable
			and (fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and self.props.shouldInterleaveSduiIxp)
			and (not self.props.edpPerUniverseVisibilityVariables or self.props.edpPerUniverseVisibilityVariables.hidePlayWithReward == true)
		then
			return
		end

		local localUserId = tonumber(self.props.localUserId)

		if
			not localUserId
			or self.props.playWithRewardData
			and self.props.playWithRewardData.universeId == self.props.universeId
		then
			return
		end

		self:setState({ didFocus = false })
		self.props.fetchPlayWithReward(self.props.universeId, localUserId):catch(function() end)
	end or nil
end

function extended:renderOnLoading(p3)
	return Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1
	}, {
		Padding = Roact.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 0),
			PaddingLeft = UDim.new(0, p3),
			PaddingRight = UDim.new(0, p3)
		}),
		Skeleton = Roact.createElement(module10, {
			Size = UDim2.new(1, 0, 1, 0),
			createLayout = function()
				return Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 15)
				})
			end,
			panels = v5
		})
	})
end

function extended.renderOnLoaded(data, p2, p3, p4, data2)
	local universeId = data.props.universeId
	local gameDetail = data.props.gameDetail
	local gameInfo = data.state.gameInfo
	local rootPlaceId = gameDetail and gameDetail.rootPlaceId or gameInfo and gameInfo.rootPlaceId
	local enableRecommendedGames = data.props.showRecommendedGames and data.props.enableRecommendedGames
	local enableSocial = gameDetail and data.props.enableSocial
	local enableGameInfoList = gameDetail and data.props.enableGameInfoList
	local v7 = data.props.enableGamePlaysAndRatings
	local enableGamePassPreview = data.props.enableGamePassPreview

	if
		(fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and module3.getShouldInterleaveSdui())
		and data.props.edpServerIxpVariables
		and data.props.edpServerIxpVariables.hideGameRatings == true
	then
		v7 = false
	end

	local v8

	if gameDetail then
		v8 = not (gameDetail.description == nil) and gameDetail.description ~= ""
	else
		v8 = gameDetail
	end

	local showGlobalCounters = data.props.showGlobalCounters
	local showLikesFavoritesCount = data.props.showLikesFavoritesCount

	local ageRecommendations = data.props.ageRecommendations
	local igrsRating

	if
		ageRecommendations
		and ageRecommendations.summary
		and ageRecommendations.summary.ageRecommendation
		and ageRecommendations.summary.ageRecommendation.igrsRating
		and ageRecommendations.summary.ageRecommendation.igrsRating ~= ""
	then
		igrsRating = ageRecommendations.summary.ageRecommendation.igrsRating
	else
		igrsRating = nil
	end

	local igrsRatingDisplayMessage

	if
		ageRecommendations
		and ageRecommendations.summary
		and ageRecommendations.summary.ageRecommendation
		and ageRecommendations.summary.ageRecommendation.igrsRatingDisplayMessage
	then
		igrsRatingDisplayMessage = ageRecommendations.summary.ageRecommendation.igrsRatingDisplayMessage
	else
		igrsRatingDisplayMessage = nil
	end

	local v9 = data.props.notificationsCanAccessExperience

	if
		(fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and module3.getShouldInterleaveSdui())
		and data.props.edpServerIxpVariables
		and data.props.edpServerIxpVariables.hideNotifyButton == true
	then
		v9 = false
	end

	local v10 = data.props.webViewSupport

	if v10 then
		v10 = not (gameDetail == nil) and gameDetail.refundPolicy ~= nil
	end

	local isPlayabilitySettledAndPlayable

	if fFlagEnablePlayWithRewardComponent then
		isPlayabilitySettledAndPlayable = data.props.isPlayabilitySettledAndPlayable
	else
		isPlayabilitySettledAndPlayable = nil
	end

	local v11 = fFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable
		and (fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and data.props.shouldInterleaveSduiIxp)
		and (not data.props.edpPerUniverseVisibilityVariables or data.props.edpPerUniverseVisibilityVariables.hidePlayWithReward == true)
	local v12

	if fFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable then
		v12 = fFlagEnablePlayWithRewardComponent and isPlayabilitySettledAndPlayable and not v11
	else
		v12 = nil
	end

	return withStyle(function(p5)
		local children = {
			ListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 20)
			}),
			PagePadding = Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, p3),
				PaddingRight = UDim.new(0, p3),
				PaddingTop = UDim.new(0, 0),
				PaddingBottom = UDim.new(0, 20)
			}),
			Header = 0,
			MediaGalleryFrame = 0,
			StatsCarousel = 0,
			TagSection = 0,
			MovedEventsList = 0,
			Description = 0,
			IgrsRatingLabel = 0,
			PlaysAndRatings = 0,
			InfoList = 0,
			RefundPolicy = 0,
			Notice = 0,
			RecommendedGames = 0,
			ExperienceSongsCarousel = 0,
			PlayWithRewardComponent = 0
		}

		local createElement = Roact.createElement
		local v14 = {
			LayoutOrder = v6.Header,
			universeId = universeId,
			showNotificationButton = v9,
			shouldHydrateLegacyIxp = 0
		}

		local v15 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then data.props.shouldHydrateLegacyIxp else nil
		v14.shouldHydrateLegacyIxp = v15
		children.Header = createElement(module12, v14)

		local createElement2 = Roact.createElement
		local v17 = {
			LayoutOrder = v6.MediaGallery,
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y
		}

		local createElement3 = Roact.createElement
		local v19 = {
			universeId = universeId,
			deviceType = "Phone",
			initialWidth = 0,
			showYouTubeVideoFirst = false,
			onSwipe = 0,
			onMediaGalleryMediaChanged = 0,
			mediaGalleryRedesignEnabledIxp = 0,
			mediaGalleryVideoPreviewEnabledIxp = 0,
			shouldHydrateLegacyIxp = 0
		}

		local v20 = if fFlagLuaAppEdpMediaGalleryHeightJitterFix then p2 - p3 * 2 else nil
		v19.initialWidth = v20

		local v21 = if not fFlagLuaAppEdpMediaGalleryRedesignTelemetry then data.onMediaGallerySwiped else nil
		v19.onSwipe = v21

		local v22 = if fFlagLuaAppEdpMediaGalleryRedesignTelemetry then data.onMediaGalleryMediaChanged else nil
		v19.onMediaGalleryMediaChanged = v22

		local v23 = if fFlagLuaAppEdpMediaGalleryRedesignIxp then data.props.mediaGalleryRedesignEnabledIxp else nil
		v19.mediaGalleryRedesignEnabledIxp = v23

		local v24 = if fFlagLuaAppEdpMediaGalleryVideoPreviewIxp then data.props.mediaGalleryVideoPreviewEnabledIxp else nil
		v19.mediaGalleryVideoPreviewEnabledIxp = v24

		local v25 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then data.props.shouldHydrateLegacyIxp else nil
		v19.shouldHydrateLegacyIxp = v25
		children.MediaGalleryFrame = createElement2("Frame", v17, {
			MediaGallery = createElement3(module19, v19),
			SizeConstraint = Roact.createElement("UISizeConstraint", {
				MinSize = Vector2.new(0, (p2 - p3 * 2) / (16 / 9))
			})
		})
		local v26

		if not ((fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and module3.getShouldInterleaveSdui()) and data.props.edpServerIxpVariables and data.props.edpServerIxpVariables.hideStatsCarousel == true) then
			local createElement4 = Roact.createElement
			local v28 = {
				LayoutOrder = v6.StatsCarousel,
				universeId = universeId,
				shouldHydrateLegacyIxp = 0
			}

			local v29 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then data.props.shouldHydrateLegacyIxp else nil
			v28.shouldHydrateLegacyIxp = v29
			v26 = createElement4(module16, v28)
		end

		children.StatsCarousel = v26

		local createElement4 = Roact.createElement
		local v28 = {
			LayoutOrder = v6.TagSection,
			universeId = universeId,
			shouldHydrateLegacyIxp = 0,
			hideContentDescriptors = 0
		}

		local v29 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then data.props.shouldHydrateLegacyIxp else nil
		v28.shouldHydrateLegacyIxp = v29

		v28.hideContentDescriptors = (fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and module3.getShouldInterleaveSdui())
			and data.props.edpServerIxpVariables
			and data.props.edpServerIxpVariables.showContentDescriptorsInInfoList == true
			and true
			or nil
		children.TagSection = createElement4(module17, v28)

		local createElement5 = Roact.createElement
		local v31 = {
			layoutOrder = v6.MovedEventsList,
			universeId = universeId,
			referralSource = "expDetailsPage",
			defaultThumbnail = 0,
			peekViewFormat = true
		}

		local v32 = if rootPlaceId then ("rbxthumb://type=GameThumbnail&id=%d&w=768&h=432"):format(rootPlaceId) else nil
		v31.defaultThumbnail = v32
		children.MovedEventsList = createElement5(module15, v31)

		local v33 = if v8 then Roact.createElement(module18, {
			dataStatus = retrievalStatus2.fromRawValue(p4),
			descriptionText = gameDetail and gameDetail.description,
			expandable = true,
			listPadding = p5.Tokens.Size.Size_250,
			LayoutOrder = v6.Description,
			universeId = universeId,
			pageContext = appPage.GameDetail,
			componentType = "gameDescription",
			viewportBoundsOffset = data.props.viewportBoundsOffset
		}) else nil
		children.Description = v33
		local v34

		if igrsRating then
			v34 = Roact.createElement(module20, {
				igrsRating = igrsRating,
				igrsRatingDisplayMessage = igrsRatingDisplayMessage,
				onActivated = function()
					data.props.openWebview(
						module7.INDONESIAN_CONTENT_MATURITY_URL,
						data2.contentMaturityHeader
					)
				end,
				LayoutOrder = v6.IgrsRatingLabel
			})
		end

		children.IgrsRatingLabel = v34

		local v35 = v7

		if v35 then
			local createElement6 = Roact.createElement
			local v37 = {
				LayoutOrder = v6.PlaysAndRatings,
				universeId = universeId,
				containerWidth = p2 - 2 * p3,
				rowPadding = 20,
				showGlobalCounters = showGlobalCounters,
				showLikesFavoritesCount = showLikesFavoritesCount,
				hideVisits = true,
				shouldHydrateLegacyIxp = 0
			}

			local v38 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then data.props.shouldHydrateLegacyIxp else nil
			v37.shouldHydrateLegacyIxp = v38
			v35 = createElement6(module13, v37)
		end

		children.PlaysAndRatings = v35

		local v36 = enableGameInfoList

		if v36 then
			local createElement6 = Roact.createElement
			local v38 = {
				LayoutOrder = v6.InfoList,
				universeId = universeId,
				leftPadding = p3,
				rightPadding = p3,
				showSocial = enableSocial,
				ageRecommendations = ageRecommendations,
				width = p2,
				enableGamePassPreview = enableGamePassPreview,
				shouldHydrateLegacyIxp = 0
			}

			local v39 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then data.props.shouldHydrateLegacyIxp else nil
			v38.shouldHydrateLegacyIxp = v39
			v36 = createElement6(module11, v38)
		end

		children.InfoList = v36

		local v37 = if v10 then Roact.createElement(module21, {
			refundPolicy = gameDetail.refundPolicy,
			layoutOrder = v6.RefundPolicy
		}) else nil
		children.RefundPolicy = v37
		local v38

		if data.props.experienceDetailsNoticeType == experienceDetailsNoticeType.InExperiencePurchase then
			local createElement6 = Roact.createElement

			local v41 = if defineFastFlag then retrievalStatus2.fromRawValue(retrievalStatus.Done) else retrievalStatus2.fromRawValue(p4)
			v38 = createElement6(module18, {
				dataStatus = v41,
				headerText = data2.noticeHeader,
				descriptionText = data2.noticeText,
				expandable = false,
				listPadding = p5.Tokens.Size.Size_250,
				LayoutOrder = v6.Notice,
				universeId = universeId,
				pageContext = appPage.GameDetail,
				componentType = "gameNotice",
				viewportBoundsOffset = data.props.viewportBoundsOffset
			})
		end

		children.Notice = v38

		local v39 = enableRecommendedGames

		if v39 then
			local createElement6 = Roact.createElement
			local v41 = {
				LayoutOrder = v6.RecommendedGames,
				Size = UDim2.new(1, 0, 0, 0),
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1
			}

			local createElement7 = Roact.createElement
			local v44 = {
				universeId = universeId,
				pageContext = appPage.GameDetail,
				onPeekViewClosed = data.props.onPeekViewClosed,
				scrollingEnabled = true,
				shouldHydrateLegacyIxp = 0
			}

			local v45 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then data.props.shouldHydrateLegacyIxp else nil
			v44.shouldHydrateLegacyIxp = v45
			v39 = createElement6("Frame", v41, {
				Carousel = createElement7(module25, v44)
			})
		end

		children.RecommendedGames = v39

		local v40 = if fFlagSongEdpCarouselIxp and data.props.showSongCarousel then Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, 0),
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder = v6.ExperienceSongsCarousel
		}, { Roact.createElement(module24, {
				universeId = universeId,
				universeTitle = gameDetail and gameDetail.name or gameInfo and gameInfo.name or "",
				collectionOrder = 2,
				clipsDescendants = false
			}) }) else nil
		children.ExperienceSongsCarousel = v40
		local v41

		if fFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable then
			v41 = v12
		else
			v41 = fFlagEnablePlayWithRewardComponent and isPlayabilitySettledAndPlayable
		end

		local v42

		if v41 then
			local createElement6 = Roact.createElement
			local v44 = {
				universeId = universeId,
				placeId = rootPlaceId,
				placeIdOverride = data.props.placeIdOverride,
				experienceJoinData = data.props.experienceJoinData,
				flowId = not data.props.playWithRewardData and "" or data.props.playWithRewardData.flowId,
				fetchedUniverseId = 0,
				isAdDataExpected = 0,
				playWithRewardAdData = 0
			}
			local v45 = if data.props.playWithRewardData then data.props.playWithRewardData.universeId else nil
			v44.fetchedUniverseId = v45

			local v46 = if data.props.playWithRewardData then data.props.playWithRewardData.isAdDataExpected else false
			v44.isAdDataExpected = v46

			local v47 = if data.props.playWithRewardData then data.props.playWithRewardData.adData else nil
			v44.playWithRewardAdData = v47
			v42 = createElement6(playWithRewardComponent, v44)
		end

		children.PlayWithRewardComponent = v42

		if
			(fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and data.props.shouldInterleaveSduiIxp)
			and data.props.sduiFeedItemConfigs
		then
			for k, sduiFeedItemConfig in data.props.sduiFeedItemConfigs do
				children[`SduiFeedItem_{k}`] = Roact.createElement("Frame", {
					Size = UDim2.new(1, 0, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					LayoutOrder = sduiFeedItemConfig.portraitLayoutOrder
				}, {
					SduiComponent = sduiFeedItemConfig.renderComponent()
				})
			end
		end

		return Roact.createElement("Frame", {
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y
		}, children)
	end)
end

function extended:renderOnFailed(p2, p3, p4)
	local gameInfo = self.state.gameInfo
	local v7 = not (gameInfo == nil) and gameInfo.rootPlaceId ~= nil

	if v7 then
		return self:renderOnLoaded(p3, p4, nil, p2)
	end

	local v8 = self.props.gameDetailError
		and self.props.gameDetailError.errorType == enumGameDetailErrorTypes.ExperienceUnavailable
	local createElement = Roact.createElement
	local v10 = {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1
	}

	local v11 = {
		Padding = Roact.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 100),
			PaddingLeft = UDim.new(0, p4),
			PaddingRight = UDim.new(0, p4),
			PaddingBottom = UDim.new(0, 20)
		}),
		EmptyState = 0
	}

	local createElement2 = Roact.createElement
	local v14 = if fFlagLuaAppUpdateFailedStateEdpIcon then images["icons/status/error_large"] else nil
	local v15 = if not v8 then self.fetchGameDetailsPageData else nil

	local v16 = if v8 then p2.experienceUnavailableMessage else p2.failedMessage
	v11.EmptyState = createElement2(emptyState, {
		icon = v14,
		onActivated = v15,
		text = v16,
		maxSizeTextLabel = Vector2.new(p3 - 2 * p4, 1e999)
	})
	return createElement("Frame", v10, v11)
end

function extended.getImageSize(p2, p3, p4, p5, p6)
	local v7 = p4 * 1.8
	local v8 = p6 / p5

	local v9 = math.max(v7, p3 * v8)
	local v10 = v9 / v8

	return Vector2.new(v10, v9)
end

function extended:render()
	local screenSize = self.props.screenSize
	local globalGuiInset = self.props.globalGuiInset
	local gameDetailsPageDataStatus = self.props.gameDetailsPageDataStatus

	local safeAreaSize = getSafeAreaSize(screenSize, globalGuiInset)
	local v7 = math.min(safeAreaSize.X.Offset, 640)
	local offset = safeAreaSize.Y.Offset
	local v8 = v7 < 600 and 20 or 40

	local element = Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 1,
		ClipsDescendants = true
	}, {
		GameDetails = Roact.createElement(
			"Frame",
			{
				Position = UDim2.new(0, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0),
				BackgroundTransparency = 1
			},
			{
				Background = Roact.createElement("Frame", {
					Size = UDim2.new(1, 0, 0, offset),
					Position = UDim2.new(0, 0, 0, 0),
					BackgroundTransparency = 1,
					ZIndex = 1
				}),
				LoadingState = withLocalization({
					failedMessage = "Feature.EmptyStatePage.Message.NoInternet",
					experienceUnavailableMessage = "Feature.GamePage.QuickLaunch.LaunchError.TemporarilyUnavailable",
					noticeHeader = "Feature.ExperienceDetails.Body.NotesTitle",
					noticeText = "Feature.ExperienceDetails.Notes.InExperiencePurchase",
					contentMaturityHeader = "Feature.GameDetails.Label.ContentMaturity"
				})(function(p2)
					return Roact.createElement("Frame", {
						Size = UDim2.fromScale(1, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						Position = UDim2.new(0, 0, 0, 0),
						ZIndex = 2,
						BackgroundTransparency = 1
					}, {
						LoadingStateContainer = Roact.createElement(loadingStateContainer, {
							dataStatus = retrievalStatus2.fromRawValue(gameDetailsPageDataStatus),
							renderOnFailed = function()
								return self:renderOnFailed(p2, v7, v8)
							end,
							renderOnLoading = function()
								return self:renderOnLoading(v8)
							end,
							renderOnLoaded = function()
								return self:renderOnLoaded(v7, v8, gameDetailsPageDataStatus, p2)
							end
						})
					})
				end)
			}
		)
	})

	if fFlagEnablePlayWithRewardComponent then
		return Roact.createFragment({
			Content = element,
			NavigationEvents = Roact.createElement(RoactNavigation.NavigationEvents, {
				onDidFocus = self.onDidFocus
			})
		})
	end

	return element
end

function extended:didMount()
	self.fetchGameDetailsPageData()

	if fFlagEnablePlayWithRewardComponent then
		self.maybeFetchPlayWithReward()
	end

	if fFlagPlayWithRewardClearOnExperienceLeave then
		self.experienceLeaveConnection = ExperienceService:RegisterForExperienceLeave(function()
			self.didExperienceLeave = true
			self.props.clearPlayWithReward()
		end)
	end
end

function extended.didUpdate(data)
	if fFlagEnablePlayWithRewardComponent then
		data.maybeFetchPlayWithReward()
	end

	data.gameInfoSubscription.update(data.props.universeId)
end

function extended:willUnmount()
	local eventIngest = self.props.eventIngest
	local universeId = self.props.universeId
	local rootPlaceId = if self.props.gameDetail then self.props.gameDetail.rootPlaceId or nil else nil
	local source = self.props.source or "None"
	local index = self.props.index or -1

	if eventIngest ~= nil and universeId ~= nil and rootPlaceId ~= nil then
		eventIngest:setRBXEventStream("GameDetailsCard", "viewClose", {
			universeId = universeId,
			rootPlaceId = rootPlaceId,
			source = source,
			index = index
		})
	end

	if fFlagEnablePlayWithRewardComponent then
		self.props.clearPlayWithReward()
	end

	self.gameInfoSubscription.dispose()

	if fFlagPlayWithRewardClearOnExperienceLeave and self.experienceLeaveConnection then
		self.experienceLeaveConnection:Disconnect()
		self.experienceLeaveConnection = nil
	end
end

local v7 = memoize(function(p2, list): boolean
	return p2 ~= retrievalStatus.Done or list ~= nil and #list ~= 0
end)

local v8 = RoactRodux.connect(function(data, p2)
	local v9

	if fFlagEnablePlayWithRewardComponent then
		v9 = fetchGamePlayabilityAndProductInfo.GetFetchingStatus(data, p2.universeId)
	end

	local v10

	if fFlagEnablePlayWithRewardComponent and data.PlayabilityStatus then
		v10 = data.PlayabilityStatus[p2.universeId] or nil
	end

	local v11

	if fFlagEnablePlayWithRewardComponent then
		if
			v9 == retrievalStatus.Done
			and v10 ~= nil
			and v10.playabilityStatus == playabilityStatusEnum.Playable
		then
			v11 = p2.playButtonState == playButtonStates.Playable
		else
			v11 = false
		end
	end

	local v12 = module8.GetFetchingStatus(data, p2.universeId)
	local fetchingStatus = module8.GetFetchingStatus(data, p2.universeId)
	local v13, v14

	if fFlagLuaAppEdpKeepCachedDetailsOnRefetch then
		v13 = data.GameDetailsV2[p2.universeId]

		v14 = fn(data, p2.universeId, v12, v13)
	end

	local playWithRewardState

	if fFlagEnablePlayWithRewardComponent and data.PlayWithRewardState.universeId == p2.universeId then
		playWithRewardState = data.PlayWithRewardState
	end

	if not fFlagLuaAppEdpKeepCachedDetailsOnRefetch then
		v13 = data.GameDetailsV2[p2.universeId]
	end

	local v15 = {
		topBarHeight = 0,
		gameDetail = v13,
		gameDetailError = data.GameDetailErrors[p2.universeId],
		gameDetailsPageDataStatus = if fFlagLuaAppEdpKeepCachedDetailsOnRefetch then v14 else v12,
		gameInfo = nil,
		screenSize = data.ScreenSize,
		globalGuiInset = data.GlobalGuiInset,
		showLoadingBackground = 0,
		showRecommendedGames = 0,
		ageRecommendations = 0,
		playWithRewardData = 0,
		isPlayabilitySettledAndPlayable = 0,
		localUserId = 0
	}

	if fFlagLuaAppEdpKeepCachedDetailsOnRefetch then
		v12 = v14
	end

	v15.showLoadingBackground = v12 ~= retrievalStatus.Done
	v15.showRecommendedGames = v7(fetchingStatus, data.RecommendedGameEntries[p2.universeId])

	v15.ageRecommendations = data.AgeRecommendations[p2.universeId]

	if not fFlagEnablePlayWithRewardComponent then
		playWithRewardState = nil
	end

	v15.playWithRewardData = playWithRewardState

	if not fFlagEnablePlayWithRewardComponent then
		v11 = nil
	end

	v15.isPlayabilitySettledAndPlayable = v11

	local v17 = if fFlagEnablePlayWithRewardComponent then data.LocalUserId else nil
	v15.localUserId = v17
	return v15
end, function(callback)
	return {
		fetchGameDetailsPageData = function(p2, p3, p4, p5, p6)
			if not fFlagLuaAppEdpBackendV2HydrateLegacyIxp then
				p4 = nil
			end

			local v12 = if fFlagLuaAppEdpBackendV2SduiInterleaveIxp then p5 else nil

			if not (fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and p5) then
				p6 = nil
			end

			return callback(module14(p2, p3, nil, p4, v12, p6))
		end,
		clearPlayWithReward = fFlagEnablePlayWithRewardComponent and function()
			return callback(setPlayWithRewardState("", "", false, nil))
		end or nil,
		fetchPlayWithReward = fFlagEnablePlayWithRewardComponent and function(p2, p3)
			return callback(fetchPlayWithRewardState(AdService, p2, p3))
		end or nil,
		openRefundPolicyLearnMorePage = function(p2)
			return callback(module22(p2))
		end,
		openWebview = function(p2, p3)
			return callback(module23(p2, p3))
		end
	}
end)(extended)

local v9 = roactServices.connect({
	networking = roactNetworking,
	eventIngest = appEventIngestService
})(v8)

local v10 = roactAppPolicy.connect(function(data, p2)
	return {
		enableRecommendedGames = data.getRecommendedGames(),
		enableSocial = data.getSocialLinks(),
		enableGameInfoList = data.getGameInfoList(),
		enableGamePlaysAndRatings = data.getGamePlaysAndRatings(),
		showGlobalCounters = data.getShowGlobalCounters(),
		showLikesFavoritesCount = data.getEnableAggregateLikesFavoritesCount(),
		enableGamePassPreview = data.getShowPassesOnExperienceDetails(),
		webViewSupport = data.getWebViewSupport(),
		notificationsCanAccessExperience = data.getNotificationsCanReceiveExperience(),
		experienceDetailsNoticeType = data.getExperienceDetailsNoticeType()
	}
end)(v9)

local fn2 = (fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp)
	and function(p2)
		local v11, v12, v13, v14

		if fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp then
			local v15 = module27.useSduiContextFromSignalAndProcessConfigs(
				module26.getUnprocessedEdpStoreKey((tostring(p2.universeId))),
				module26.getEdpStoreKey((tostring(p2.universeId))),
				fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and p2.shouldInterleaveSduiIxp
			)

			v11 = module27.useSduiEdpFeedItemConfigs({
				sduiContext = v15,
				storeKey = module26.getEdpStoreKey((tostring(p2.universeId))),
				portraitLayoutConfig = v6,
				landscapeLayoutConfig = v6,
				defaultLayoutOrder = v6.SduiFeedItemsDefault,
				logLayoutConflictFn = module9.logSduiLayoutOrderConflict,
				shouldInterleaveSdui = fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and p2.shouldInterleaveSduiIxp
			})

			local v16 = React.useMemo(function()
				return function(p3)
					if
						(fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and p2.shouldInterleaveSduiIxp)
						and p2.universeId
					then
						return module27.getSduiFeedStore(module26.getEdpStoreKey((tostring(p2.universeId)))).getDataUpdatedTimestamp(p3)
					end

					return nil
				end
			end, { p2.universeId, p2.shouldInterleaveSduiIxp })
			v12 = SignalsReact.useSignalState(v16)
			v13 = module5()

			if fFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable then
				v14 = module6(p2.universeId)
			end
		end

		return Roact.createElement(
			v10,
			Cryo.Dictionary.join(p2, {
				currentSduiDataTimestamp = v12,
				sduiFeedItemConfigs = v11,
				edpServerIxpVariables = v13,
				edpPerUniverseVisibilityVariables = v14
			})
		)
	end
	or v10

if
	fFlagSongEdpCarouselIxp
	or fFlagLuaAppEdpMediaGalleryRedesignIxp
	or fFlagLuaAppEdpMediaGalleryVideoPreviewIxp
then
	fn2 = RoactAppExperiment.connectUserLayer(
		{ appUserLayers.ExperienceDetailsPageExposureLayer },
		function(p2, p3)
			local v11 = p2[appUserLayers.ExperienceDetailsPageExposureLayer] or {}

			local v13 = if fFlagSongEdpCarouselIxp then v11.showSongCarousel else nil

			local v14 = if fFlagLuaAppEdpMediaGalleryRedesignIxp then v11.MediaGalleryRedesignEnabled else nil

			local v15 = if fFlagLuaAppEdpMediaGalleryVideoPreviewIxp then v11.MediaGalleryVideoPreviewEnabled else nil
			return {
				showSongCarousel = v13,
				mediaGalleryRedesignEnabledIxp = v14,
				mediaGalleryVideoPreviewEnabledIxp = v15
			}
		end,
		true
	)(fn2)
end

return (fFlagLuaAppEdpBackendV2HydrateLegacyIxp or fFlagLuaAppEdpBackendV2SduiInterleaveIxp or fFlagEDPTTITrackingEnabled or fFlagEnablePlayWithRewardComponent)
	and function(p2)
		if fFlagEDPTTITrackingEnabled then
			local v11 = useFirstMediaCarouselImageUri(p2.universeId)
			module29(edpttiConstants.EDP_IMPLEMENTATION.LEGACY_PEEK_VIEW, p2.universeId, v11)
		end

		local v11 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then module3.getShouldHydrateLegacy() else nil
		local v12

		if fFlagLuaAppEdpBackendV2SduiInterleaveIxp then
			v12 = module3.getShouldInterleaveSdui()
		end

		local playButtonState

		if fFlagEnablePlayWithRewardComponent then
			playButtonState = usePlayButtonState(useRoactService(roactNetworking), p2.universeId, nil).playButtonState
		end

		if
			fFlagLuaAppEdpBackendV2HydrateLegacyIxp
			or fFlagLuaAppEdpBackendV2SduiInterleaveIxp
			or fFlagEDPTTITrackingEnabled
		then
			React.useEffect(function()
				IXPService:LogUserLayerExposure(appUserLayers.ExperienceDetailsPageExposureLayer)
			end, {})
		end

		local createElement = Roact.createElement

		local join = Cryo.Dictionary.join

		if not fFlagLuaAppEdpBackendV2HydrateLegacyIxp then
			v11 = nil
		end

		if not fFlagLuaAppEdpBackendV2SduiInterleaveIxp then
			v12 = nil
		end

		if not fFlagEnablePlayWithRewardComponent then
			playButtonState = nil
		end

		return createElement(
			fn2,
			join(p2, {
				shouldHydrateLegacyIxp = v11,
				shouldInterleaveSduiIxp = v12,
				playButtonState = playButtonState
			})
		)
	end
	or fn2
