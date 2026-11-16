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
local usePlayButtonState = require("@luauforge/bundled/fWH").usePlayButtonState
local playButtonStates = require("@luauforge/bundled/fWH").PlayButtonStates
local apiFetchGameDetails = require("@luauforge/bundled/dyi").GameDetails.ApiFetchGameDetails

local fetchGamePlayabilityAndProductInfo = require("@luauforge/bundled/dyi").FetchGamePlayabilityAndProductInfo
local playabilityStatusEnum = require("@luauforge/bundled/cyO").PlayabilityStatusEnum
local enumGameDetailErrorTypes = require("@luauforge/bundled/cyO").EnumGameDetailErrorTypes
local getSafeAreaSize = require("@luauforge/bundled/fuE").getSafeAreaSize
local retrievalStatus = require("@game/CorePackages/Workspace/Packages/Http").Enum.RetrievalStatus
local module = require("@luauforge/bundled/dzN")
local nextDataExpirationTimeReducer = module.NextDataExpirationTimeReducer
local expirationTimeNamespace = module.ExpirationTimeNamespace
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local module2 = require("@luauforge/bundled/dwM")
local appEventIngestService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppEventIngestService
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local appUserLayers = require("@luauforge/bundled/dMA").AppUserLayers

local module3 = require("@luauforge/deferred/fXb")
local gameInfosReducer = require("@luauforge/bundled/dzK").GameInfosReducer
local GameHydrationReact = require("@game/CorePackages/Workspace/Packages/GameHydrationReact")
local experienceDetailsNoticeType = require("@luauforge/bundled/cyO").ExperienceDetailsNoticeType
local UIBlox = require(CorePackages.Packages.UIBlox)

local images = UIBlox.App.ImageSet.Images

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local withStyle = UIBlox.Style.withStyle
local loadingStateContainer = UIBlox.App.Container.LoadingStateContainer
local retrievalStatus2 = UIBlox.App.Loading.Enum.RetrievalStatus
local emptyState = UIBlox.App.Indicator.EmptyState
local playWithRewardComponent = require("@luauforge/deferred/fXc").PlayWithRewardComponent

local fetchPlayWithRewardState = require("@luauforge/deferred/fXc").FetchPlayWithRewardState
local setPlayWithRewardState = require("@luauforge/bundled/fXd").SetPlayWithRewardState
local module5 = require("@luauforge/deferred/fXe")

local module6 = require("@luauforge/deferred/fXf")

local modules = require("@luauforge/bundled/dpZ").Modules
local mediaGallerySwiped = modules.LuaApp.Analytics.Events.Games.GameDetailsEvents.MediaGallerySwiped

local mediaGalleryMediaChanged = modules.LuaApp.Analytics.Events.Games.GameDetailsEvents.MediaGalleryMediaChanged

local checkAndFormatPossibleLink = require("@luauforge/bundled/edJ").checkAndFormatPossibleLink

local module7 = require("@luauforge/bundled/dwA")
local module8 = require("@luauforge/deferred/fWL")
local module9 = require("@luauforge/deferred/fWP")
local module10 = require("@luauforge/deferred/fXg")
local module11 = require("@luauforge/deferred/fXi")
local module12 = require("@luauforge/deferred/fYd")
local module13 = require("@luauforge/deferred/fYt")
local module14 = require("@luauforge/deferred/fYy")
local module15 = require("@luauforge/deferred/fYH")
local module16 = require("@luauforge/deferred/fYP")
local module17 = require("@luauforge/deferred/fYT")
local module18 = require("@luauforge/deferred/fYV")
local module19 = require("@luauforge/deferred/fYX")
local module20 = require("@luauforge/deferred/fZc")
local module21 = require("@luauforge/deferred/fZq")
local module22 = require("@luauforge/deferred/fZr")
local module23 = require("@luauforge/deferred/fYp")
local module24 = require("@luauforge/bundled/fsr")
local module25 = require("@luauforge/deferred/fZs")
local module26 = require("@luauforge/deferred/gan")
local module27 = require("@luauforge/deferred/fWQ")
local module28 = require("@luauforge/bundled/dAU")

local module29 = require("@luauforge/bundled/dHp")
local edpttiConstants = module29.EDPTTIConstants
local fFlagEDPTTITrackingEnabled = module29.FFlagEDPTTITrackingEnabled
local module30 = require("@luauforge/deferred/gaq")

local useFirstMediaCarouselImageUri = require("@luauforge/deferred/gar").useFirstMediaCarouselImageUri

local fFlagLuaAppExperienceDetailsLayoutOrderConfig = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppExperienceDetailsLayoutOrderConfig
local fFlagSongEdpCarouselIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSongEdpCarouselIxp
local defineFastFlag = game:DefineFastFlag("LuaAppFixNoticeLocalization", false)

local fFlagLuaAppEnableConsolidatedGameRefundPolicy = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEnableConsolidatedGameRefundPolicy

local fFlagLuaAppEdpMediaGalleryRedesignIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryRedesignIxp

local fFlagLuaAppEdpMediaGalleryVideoPreviewIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryVideoPreviewIxp

local fFlagLuaAppEdpMediaGalleryRedesignTelemetry = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryRedesignTelemetry

local fFlagLuaAppEdpBackendV2HydrateLegacyDefault = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2HydrateLegacyDefault

local fFlagLuaAppEdpBackendV2HydrateLegacyIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2HydrateLegacyIxp

local fFlagEnablePlayWithRewardComponent = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnablePlayWithRewardComponent
local fFlagMigrateGameInfoToStore = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagMigrateGameInfoToStore

local fFlagPlayWithRewardClearOnExperienceLeave = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagPlayWithRewardClearOnExperienceLeave

local fFlagLuaAppEdpBackendV2SduiInterleaveDefault = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2SduiInterleaveDefault

local fFlagLuaAppEdpBackendV2SduiInterleaveIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2SduiInterleaveIxp

local fFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable

local fFlagLuaAppAddUniverseIdToGameDetailsEvents = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppAddUniverseIdToGameDetailsEvents

local fFlagLuaAppExpandableTextImpressionsEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppExpandableTextImpressionsEnabled

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

local function createLayoutOrderGenerator()
	local count = 0
	return function()
		count += 1
		return count
	end
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

	if fFlagMigrateGameInfoToStore then
		self.gameInfoSubscription = GameHydrationReact.subscribeGameInfo({
			universeId = self.props.universeId,
			onChange = function(p2)
				self:setState({
					gameInfo = p2.gameInfo or none
				})
			end
		})
	end

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
		local v13 = {}
		v13.BackgroundTransparency = 1
		v13.Text = v8
		v13.AutomaticSize = Enum.AutomaticSize.XY
		local v14 = if not foundationFontFaceMigration then bodyLarge.Font else nil
		v13.Font = v14
		local v15 = if foundationFontFaceMigration then normalizeFontFace(bodyLarge.Font) else nil
		v13.FontFace = v15
		v13.TextSize = bodyLarge.FontSize
		v13.TextColor3 = muted.Color3
		v13.TextTransparency = muted.Transparency
		v13.TextWrapped = true
		v13.TextXAlignment = Enum.TextXAlignment.Left
		v13.RichText = v7
		local tag = React.Tag
		local v16 = if fFlagLuaAppAddTestIdsForArrow then getTestId("discovery-edp-game-refund-policy") else nil
		v13[tag] = v16

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

function extended.renderOnLoaded(data, width, p2, p3, data2)
	local universeId = data.props.universeId
	local gameDetail = data.props.gameDetail
	local gameInfo, rootPlaceId

	if fFlagMigrateGameInfoToStore then
		gameInfo = data.state.gameInfo
		rootPlaceId = gameDetail and gameDetail.rootPlaceId or gameInfo and gameInfo.rootPlaceId
	else
		gameInfo = data.props.gameInfo
		rootPlaceId = gameDetail and gameDetail.rootPlaceId or gameInfo and gameInfo.placeId
	end

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

	local count = 0
	local function fn2()
		count += 1
		return count
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

	return withStyle(function(p4)
		local children = {
			ListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 20)
			}),
			PagePadding = Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, p2),
				PaddingRight = UDim.new(0, p2),
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
		local v13

		if fFlagLuaAppExperienceDetailsLayoutOrderConfig then
			local createElement = Roact.createElement
			local v15 = {
				LayoutOrder = v6.Header,
				universeId = universeId,
				showNotificationButton = v9,
				shouldHydrateLegacyIxp = 0
			}

			local v16 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then data.props.shouldHydrateLegacyIxp else nil
			v15.shouldHydrateLegacyIxp = v16
			v13 = createElement(module12, v15)
		else
			local createElement = Roact.createElement
			local v15 = {
				LayoutOrder = fn2(),
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(1, 0, 0, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.Y
			}
			local children2 = {
				ListLayout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 20)
				}),
				MediaGalleryFrame = 0,
				Header = 0
			}

			local createElement2 = Roact.createElement
			local v17 = {
				LayoutOrder = 2,
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

			local v20 = if fFlagLuaAppEdpMediaGalleryHeightJitterFix then width - p2 * 2 else nil
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
			children2.MediaGalleryFrame = createElement2("Frame", v17, {
				MediaGallery = createElement3(module20, v19),
				SizeConstraint = Roact.createElement("UISizeConstraint", {
					MinSize = Vector2.new(0, (width - p2 * 2) / (16 / 9))
				})
			})

			local createElement4 = Roact.createElement
			local v27 = {
				LayoutOrder = 1,
				universeId = universeId,
				showNotificationButton = v9,
				shouldHydrateLegacyIxp = 0
			}

			local v28 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then data.props.shouldHydrateLegacyIxp else nil
			v27.shouldHydrateLegacyIxp = v28
			children2.Header = createElement4(module12, v27)
			v13 = createElement("Frame", v15, children2)
		end

		children.Header = v13
		local v14

		if fFlagLuaAppExperienceDetailsLayoutOrderConfig then
			local createElement = Roact.createElement
			local v16 = {
				LayoutOrder = v6.MediaGallery,
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(1, 0, 0, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.Y
			}

			local createElement2 = Roact.createElement
			local v18 = {
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

			local v19 = if fFlagLuaAppEdpMediaGalleryHeightJitterFix then width - p2 * 2 else nil
			v18.initialWidth = v19

			local v20 = if not fFlagLuaAppEdpMediaGalleryRedesignTelemetry then data.onMediaGallerySwiped else nil
			v18.onSwipe = v20

			local v21 = if fFlagLuaAppEdpMediaGalleryRedesignTelemetry then data.onMediaGalleryMediaChanged else nil
			v18.onMediaGalleryMediaChanged = v21

			local v22 = if fFlagLuaAppEdpMediaGalleryRedesignIxp then data.props.mediaGalleryRedesignEnabledIxp else nil
			v18.mediaGalleryRedesignEnabledIxp = v22

			local v23 = if fFlagLuaAppEdpMediaGalleryVideoPreviewIxp then data.props.mediaGalleryVideoPreviewEnabledIxp else nil
			v18.mediaGalleryVideoPreviewEnabledIxp = v23

			local v24 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then data.props.shouldHydrateLegacyIxp else nil
			v18.shouldHydrateLegacyIxp = v24
			v14 = createElement("Frame", v16, {
				MediaGallery = createElement2(module20, v18),
				SizeConstraint = Roact.createElement("UISizeConstraint", {
					MinSize = Vector2.new(0, (width - p2 * 2) / (16 / 9))
				})
			})
		end

		children.MediaGalleryFrame = v14
		local v15

		if not ((fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and module3.getShouldInterleaveSdui()) and data.props.edpServerIxpVariables and data.props.edpServerIxpVariables.hideStatsCarousel == true) then
			local createElement = Roact.createElement

			local v18 = if fFlagLuaAppExperienceDetailsLayoutOrderConfig then v6.StatsCarousel else fn2()
			local v17 = {
				LayoutOrder = v18,
				universeId = universeId,
				shouldHydrateLegacyIxp = 0
			}

			local v19 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then data.props.shouldHydrateLegacyIxp else nil
			v17.shouldHydrateLegacyIxp = v19
			v15 = createElement(module17, v17)
		end

		children.StatsCarousel = v15

		local createElement = Roact.createElement

		local v18 = if fFlagLuaAppExperienceDetailsLayoutOrderConfig then v6.TagSection else fn2()
		local v17 = {
			LayoutOrder = v18,
			universeId = universeId,
			shouldHydrateLegacyIxp = 0,
			hideContentDescriptors = 0
		}

		local v19 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then data.props.shouldHydrateLegacyIxp else nil
		v17.shouldHydrateLegacyIxp = v19

		v17.hideContentDescriptors = (fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and module3.getShouldInterleaveSdui())
			and data.props.edpServerIxpVariables
			and data.props.edpServerIxpVariables.showContentDescriptorsInInfoList == true
			and true
			or nil
		children.TagSection = createElement(module18, v17)

		local createElement2 = Roact.createElement

		local v22 = if fFlagLuaAppExperienceDetailsLayoutOrderConfig then v6.MovedEventsList else fn2()
		local v21 = {
			layoutOrder = v22,
			universeId = universeId,
			referralSource = "expDetailsPage",
			defaultThumbnail = 0,
			peekViewFormat = true
		}

		local v23 = if rootPlaceId then ("rbxthumb://type=GameThumbnail&id=%d&w=768&h=432"):format(rootPlaceId) else nil
		v21.defaultThumbnail = v23
		children.MovedEventsList = createElement2(module16, v21)
		local v24

		if v8 then
			local createElement3 = Roact.createElement
			local v26 = {
				dataStatus = retrievalStatus2.fromRawValue(p3),
				descriptionText = gameDetail and gameDetail.description,
				expandable = true,
				listPadding = p4.Tokens.Size.Size_250,
				LayoutOrder = 0,
				universeId = 0,
				pageContext = 0,
				componentType = 0,
				viewportBoundsOffset = 0
			}

			local v27 = if fFlagLuaAppExperienceDetailsLayoutOrderConfig then v6.Description else fn2()
			v26.LayoutOrder = v27

			v26.universeId = if fFlagLuaAppExpandableTextImpressionsEnabled then universeId else nil
			local v29 = if fFlagLuaAppExpandableTextImpressionsEnabled then appPage.GameDetail else nil
			v26.pageContext = v29
			v26.componentType = fFlagLuaAppExpandableTextImpressionsEnabled and "gameDescription" or nil

			local v30 = if fFlagLuaAppExpandableTextImpressionsEnabled then data.props.viewportBoundsOffset else nil
			v26.viewportBoundsOffset = v30
			v24 = createElement3(module19, v26)
		end

		children.Description = v24
		local v25

		if igrsRating then
			local createElement3 = Roact.createElement
			local v27 = {
				igrsRating = igrsRating,
				igrsRatingDisplayMessage = igrsRatingDisplayMessage,
				onActivated = function()
					data.props.openWebview(
						module7.INDONESIAN_CONTENT_MATURITY_URL,
						data2.contentMaturityHeader
					)
				end,
				LayoutOrder = 0
			}

			local v28 = if fFlagLuaAppExperienceDetailsLayoutOrderConfig then v6.IgrsRatingLabel else fn2()
			v27.LayoutOrder = v28
			v25 = createElement3(module21, v27)
		end

		children.IgrsRatingLabel = v25

		local v26 = v7

		if v26 then
			local createElement3 = Roact.createElement

			local v29 = if fFlagLuaAppExperienceDetailsLayoutOrderConfig then v6.PlaysAndRatings else fn2()
			local v28 = {
				LayoutOrder = v29,
				universeId = universeId,
				containerWidth = width - 2 * p2,
				rowPadding = 20,
				showGlobalCounters = showGlobalCounters,
				showLikesFavoritesCount = showLikesFavoritesCount,
				hideVisits = true,
				shouldHydrateLegacyIxp = 0
			}

			local v30 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then data.props.shouldHydrateLegacyIxp else nil
			v28.shouldHydrateLegacyIxp = v30
			v26 = createElement3(module13, v28)
		end

		children.PlaysAndRatings = v26

		local v27 = enableGameInfoList

		if v27 then
			local createElement3 = Roact.createElement

			local v30 = if fFlagLuaAppExperienceDetailsLayoutOrderConfig then v6.InfoList else fn2()
			local v29 = {
				LayoutOrder = v30,
				universeId = universeId,
				leftPadding = p2,
				rightPadding = p2,
				showSocial = enableSocial,
				ageRecommendations = ageRecommendations,
				width = width,
				enableGamePassPreview = enableGamePassPreview,
				shouldHydrateLegacyIxp = 0
			}

			local v31 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then data.props.shouldHydrateLegacyIxp else nil
			v29.shouldHydrateLegacyIxp = v31
			v27 = createElement3(module11, v29)
		end

		children.InfoList = v27
		local v28

		if v10 then
			if fFlagLuaAppEnableConsolidatedGameRefundPolicy then
				local createElement3 = Roact.createElement
				local v30 = { refundPolicy = gameDetail.refundPolicy, layoutOrder = 0 }

				local v31 = if fFlagLuaAppExperienceDetailsLayoutOrderConfig then v6.RefundPolicy else fn2()
				v30.layoutOrder = v31
				v28 = createElement3(module22, v30)
			else
				local renderRefundPolicy = data.renderRefundPolicy

				local refundPolicy = gameDetail.refundPolicy

				local v29 = if fFlagLuaAppExperienceDetailsLayoutOrderConfig then v6.RefundPolicy else fn2()
				v28 = renderRefundPolicy(p4, refundPolicy, v29)
			end
		end

		children.RefundPolicy = v28
		local v29

		if data.props.experienceDetailsNoticeType == experienceDetailsNoticeType.InExperiencePurchase then
			local createElement3 = Roact.createElement

			local v32 = if defineFastFlag then retrievalStatus2.fromRawValue(retrievalStatus.Done) else retrievalStatus2.fromRawValue(p3)
			local v31 = {
				dataStatus = v32,
				headerText = data2.noticeHeader,
				descriptionText = data2.noticeText,
				expandable = false,
				listPadding = p4.Tokens.Size.Size_250,
				LayoutOrder = 0,
				universeId = 0,
				pageContext = 0,
				componentType = 0,
				viewportBoundsOffset = 0
			}

			local v33 = if fFlagLuaAppExperienceDetailsLayoutOrderConfig then v6.Notice else fn2()
			v31.LayoutOrder = v33

			v31.universeId = if fFlagLuaAppExpandableTextImpressionsEnabled then universeId else nil
			local v35 = if fFlagLuaAppExpandableTextImpressionsEnabled then appPage.GameDetail else nil
			v31.pageContext = v35
			v31.componentType = fFlagLuaAppExpandableTextImpressionsEnabled and "gameNotice" or nil

			local v36 = if fFlagLuaAppExpandableTextImpressionsEnabled then data.props.viewportBoundsOffset else nil
			v31.viewportBoundsOffset = v36
			v29 = createElement3(module19, v31)
		end

		children.Notice = v29

		local v30 = enableRecommendedGames

		if v30 then
			local createElement3 = Roact.createElement

			local v33 = if fFlagLuaAppExperienceDetailsLayoutOrderConfig then v6.RecommendedGames else fn2()
			local v32 = {
				LayoutOrder = v33,
				Size = UDim2.new(1, 0, 0, 0),
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1
			}

			local createElement4 = Roact.createElement
			local v36 = {
				universeId = universeId,
				pageContext = appPage.GameDetail,
				onPeekViewClosed = data.props.onPeekViewClosed,
				scrollingEnabled = true,
				shouldHydrateLegacyIxp = 0
			}

			local v37 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then data.props.shouldHydrateLegacyIxp else nil
			v36.shouldHydrateLegacyIxp = v37
			v30 = createElement3("Frame", v32, {
				Carousel = createElement4(module26, v36)
			})
		end

		children.RecommendedGames = v30
		local v31

		if fFlagSongEdpCarouselIxp and data.props.showSongCarousel then
			local createElement3 = Roact.createElement
			local v33 = {
				Size = UDim2.new(1, 0, 0, 0),
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				LayoutOrder = 0
			}

			local v34 = if fFlagLuaAppExperienceDetailsLayoutOrderConfig then v6.ExperienceSongsCarousel else fn2()
			v33.LayoutOrder = v34
			v31 = createElement3("Frame", v33, { Roact.createElement(module25, {
					universeId = universeId,
					universeTitle = gameDetail and gameDetail.name or gameInfo and gameInfo.name or "",
					collectionOrder = 2,
					clipsDescendants = false
				}) })
		end

		children.ExperienceSongsCarousel = v31
		local v32

		if fFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable then
			v32 = v12
		else
			v32 = fFlagEnablePlayWithRewardComponent and isPlayabilitySettledAndPlayable
		end

		local v33

		if v32 then
			local createElement3 = Roact.createElement
			local v35 = {
				universeId = universeId,
				placeId = rootPlaceId,
				placeIdOverride = data.props.placeIdOverride,
				experienceJoinData = data.props.experienceJoinData,
				flowId = not data.props.playWithRewardData and "" or data.props.playWithRewardData.flowId,
				fetchedUniverseId = 0,
				isAdDataExpected = 0,
				playWithRewardAdData = 0
			}
			local v36 = if data.props.playWithRewardData then data.props.playWithRewardData.universeId else nil
			v35.fetchedUniverseId = v36

			local v37 = if data.props.playWithRewardData then data.props.playWithRewardData.isAdDataExpected else false
			v35.isAdDataExpected = v37

			local v38 = if data.props.playWithRewardData then data.props.playWithRewardData.adData else nil
			v35.playWithRewardAdData = v38
			v33 = createElement3(playWithRewardComponent, v35)
		end

		children.PlayWithRewardComponent = v33

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
	local v7

	if fFlagMigrateGameInfoToStore then
		local gameInfo = self.state.gameInfo
		v7 = not (gameInfo == nil) and gameInfo.rootPlaceId ~= nil
	else
		v7 = self.props.gameInfo ~= nil
	end

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

	if fFlagMigrateGameInfoToStore then
		data.gameInfoSubscription.update(data.props.universeId)
	end
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

	if fFlagMigrateGameInfoToStore then
		self.gameInfoSubscription.dispose()
	end

	if fFlagPlayWithRewardClearOnExperienceLeave and self.experienceLeaveConnection then
		self.experienceLeaveConnection:Disconnect()
		self.experienceLeaveConnection = nil
	end
end

local v7 = memoize(function(p2, list): boolean
	return p2 ~= retrievalStatus.Done or list ~= nil and #list ~= 0
end)

local v8 = RoactRodux.connect(function(data, data2)
	local v9

	if fFlagEnablePlayWithRewardComponent then
		v9 = fetchGamePlayabilityAndProductInfo.GetFetchingStatus(data, data2.universeId)
	end

	local v10

	if fFlagEnablePlayWithRewardComponent and data.PlayabilityStatus then
		v10 = data.PlayabilityStatus[data2.universeId] or nil
	end

	local v11

	if fFlagEnablePlayWithRewardComponent then
		if
			v9 == retrievalStatus.Done
			and v10 ~= nil
			and v10.playabilityStatus == playabilityStatusEnum.Playable
		then
			v11 = data2.playButtonState == playButtonStates.Playable
		else
			v11 = false
		end
	end

	local v12, v13

	if
		fFlagLuaAppEdpBackendV2HydrateLegacyDefault
		or fFlagLuaAppEdpBackendV2HydrateLegacyIxp and data2.shouldHydrateLegacyIxp
	then
		v12 = module8.GetFetchingStatus(data, data2.universeId)
		v13 = module8.GetFetchingStatus(data, data2.universeId)
	else
		v12 = apiFetchGameDetails.GetFetchingStatus(data, data2.universeId)
		v13 = module15.GetFetchingStatus(data, data2.universeId)
	end

	local v14, v15

	if fFlagLuaAppEdpKeepCachedDetailsOnRefetch then
		if
			fFlagLuaAppEdpBackendV2HydrateLegacyDefault
			or fFlagLuaAppEdpBackendV2HydrateLegacyIxp and data2.shouldHydrateLegacyIxp
		then
			v14 = data.GameDetailsV2[data2.universeId]
		else
			v14 = data.GameDetails[data2.universeId]
		end

		v15 = fn(data, data2.universeId, v12, v14)
	end

	local v16

	if not fFlagMigrateGameInfoToStore then
		v16 = data.Personalization[gameInfosReducer.key][data2.universeId]
	end

	local playWithRewardState

	if fFlagEnablePlayWithRewardComponent and data.PlayWithRewardState.universeId == data2.universeId then
		playWithRewardState = data.PlayWithRewardState
	end

	if not fFlagLuaAppEdpKeepCachedDetailsOnRefetch then
		if
			fFlagLuaAppEdpBackendV2HydrateLegacyDefault
			or fFlagLuaAppEdpBackendV2HydrateLegacyIxp and data2.shouldHydrateLegacyIxp
		then
			v14 = data.GameDetailsV2[data2.universeId]
		else
			v14 = data.GameDetails[data2.universeId]
		end
	end

	local v17 = {
		topBarHeight = 0,
		gameDetail = v14,
		gameDetailError = data.GameDetailErrors[data2.universeId],
		gameDetailsPageDataStatus = if fFlagLuaAppEdpKeepCachedDetailsOnRefetch then v15 else v12,
		gameInfo = v16,
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
		v12 = v15
	end

	v17.showLoadingBackground = v12 ~= retrievalStatus.Done
	v17.showRecommendedGames = v7(v13, data.RecommendedGameEntries[data2.universeId])

	v17.ageRecommendations = data.AgeRecommendations[data2.universeId]

	if not fFlagEnablePlayWithRewardComponent then
		playWithRewardState = nil
	end

	v17.playWithRewardData = playWithRewardState

	if not fFlagEnablePlayWithRewardComponent then
		v11 = nil
	end

	v17.isPlayabilitySettledAndPlayable = v11

	local v19 = if fFlagEnablePlayWithRewardComponent then data.LocalUserId else nil
	v17.localUserId = v19
	return v17
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
			return callback(module23(p2))
		end,
		openWebview = function(p2, p3)
			return callback(module24(p2, p3))
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
			local v15 = module28.useSduiContextFromSignalAndProcessConfigs(
				module27.getUnprocessedEdpStoreKey((tostring(p2.universeId))),
				module27.getEdpStoreKey((tostring(p2.universeId))),
				fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and p2.shouldInterleaveSduiIxp
			)

			v11 = module28.useSduiEdpFeedItemConfigs({
				sduiContext = v15,
				storeKey = module27.getEdpStoreKey((tostring(p2.universeId))),
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
						return module28.getSduiFeedStore(module27.getEdpStoreKey((tostring(p2.universeId)))).getDataUpdatedTimestamp(p3)
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
			module30(edpttiConstants.EDP_IMPLEMENTATION.LEGACY_PEEK_VIEW, p2.universeId, v11)
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
