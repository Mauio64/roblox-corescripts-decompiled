local CorePackages = game:GetService("CorePackages")
local AdService = game:GetService("AdService")
local IXPService = game:GetService("IXPService")
local Roact = require(CorePackages.Packages.Roact)
local Cryo = require(CorePackages.Packages.Cryo)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local memoize = require(CorePackages.Workspace.Packages.AppCommonLib).memoize
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(CorePackages.Workspace.Packages.RoactServiceTags).RoactNetworking
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local usePlayButtonState = require(CorePackages.Workspace.Packages.GamePlayButton).usePlayButtonState
local PlayButtonStates = require(CorePackages.Workspace.Packages.GamePlayButton).PlayButtonStates
local ApiFetchGameDetails = require(CorePackages.Workspace.Packages.GameDetailRodux).GameDetails.ApiFetchGameDetails
local FetchGamePlayabilityAndProductInfo = require(CorePackages.Workspace.Packages.GameDetailRodux).FetchGamePlayabilityAndProductInfo
local PlayabilityStatusEnum = require(CorePackages.Workspace.Packages.DiscoveryTypes).PlayabilityStatusEnum
local EnumGameDetailErrorTypes = require(CorePackages.Workspace.Packages.DiscoveryTypes).EnumGameDetailErrorTypes
local getSafeAreaSize = require(CorePackages.Workspace.Packages.InputUi).getSafeAreaSize
local RetrievalStatus = require(CorePackages.Workspace.Packages.Http).Enum.RetrievalStatus
local NextDataExpirationTimeRodux = require(CorePackages.Workspace.Packages.NextDataExpirationTimeRodux)
local NextDataExpirationTimeReducer = NextDataExpirationTimeRodux.NextDataExpirationTimeReducer
local ExpirationTimeNamespace = NextDataExpirationTimeRodux.ExpirationTimeNamespace
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local React = require(CorePackages.Packages.React)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local AppEventIngestService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppEventIngestService
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local ExperienceDetailsExperimentation = require(script.Parent.Parent.ExperienceDetails.ExperienceDetailsExperimentation)
local GameInfosReducer = require(CorePackages.Workspace.Packages.GameInfosRodux).GameInfosReducer
local ExperienceDetailsNoticeType = require(CorePackages.Workspace.Packages.DiscoveryTypes).ExperienceDetailsNoticeType
local UIBlox = require(CorePackages.Packages.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local withStyle = UIBlox.Style.withStyle
local LoadingStateContainer = UIBlox.App.Container.LoadingStateContainer
local RetrievalStatus2 = UIBlox.App.Loading.Enum.RetrievalStatus
local EmptyState = UIBlox.App.Indicator.EmptyState
local PlayWithRewardComponent = require(CorePackages.Workspace.Packages.PlayWithRewardComponent).PlayWithRewardComponent
local FetchPlayWithRewardState = require(CorePackages.Workspace.Packages.PlayWithRewardComponent).FetchPlayWithRewardState
local SetPlayWithRewardState = require(CorePackages.Workspace.Packages.PlayWithRewardState).SetPlayWithRewardState
local useEdpServerIxpVariables = require(script.Parent.Parent.ExperienceDetails.Hooks.useEdpServerIxpVariables)
local useEdpPerUniverseVisibilityVariablesForUniverse = require(script.Parent.Parent.ExperienceDetails.Hooks.useEdpPerUniverseVisibilityVariablesForUniverse)
local Modules = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules
local MediaGallerySwiped = Modules.LuaApp.Analytics.Events.Games.GameDetailsEvents.MediaGallerySwiped
local MediaGalleryMediaChanged = Modules.LuaApp.Analytics.Events.Games.GameDetailsEvents.MediaGalleryMediaChanged
local checkAndFormatPossibleLink = require(CorePackages.Workspace.Packages.CollectionViews).checkAndFormatPossibleLink
local Modules2 = game:GetService("CoreGui").RobloxGui.Modules
local Constants = require(Modules2.LuaApp.Constants)
local ApiFetchExperienceDetailsPage = require(Modules2.LuaApp.Thunks.Games.ApiFetchExperienceDetailsPage)
local ApiFetchExperienceDetailsPageCounters = require(Modules2.LuaApp.Thunks.ApiFetchExperienceDetailsPageCounters)
local LoadingSkeleton = require(Modules2.LuaApp.Components.LoadingSkeleton)
local GameInfoList = require(Modules2.LuaApp.Components.GameDetails.GameInfoList)
local GameHeader = require(Modules2.LuaApp.Components.GameDetails.GameHeader)
local GamePlaysAndRatings = require(Modules2.LuaApp.Components.GameDetails.GamePlaysAndRatings)
local FetchGameDetailsPageData = require(Modules2.LuaApp.Thunks.Games.FetchGameDetailsPageData)
local RecommendedGames = require(Modules2.LuaApp.Thunks.Games.RecommendedGames)
local EventsListWrapper = require(Modules2.LuaApp.Components.VirtualEvents.EventsListWrapper)
local GameStatsCarousel = require(Modules2.LuaApp.Components.ExperienceDetails.GameStatsCarousel)
local ExperienceTagsContainer = require(Modules2.LuaApp.Components.ExperienceDetails.ExperienceTagsContainer)
local ExperienceDescription = require(Modules2.LuaApp.Components.ExperienceDetails.ExperienceDescription)
local ExperienceMediaGallery = require(Modules2.LuaApp.Components.ExperienceDetails.ExperienceMediaGallery)
local IgrsRatingLabel = require(Modules2.LuaApp.Components.ExperienceDetails.IgrsRatingLabel)
local GameRefundPolicy = require(Modules2.LuaApp.Components.GameDetails.GameRefundPolicy)
local OpenRefundPolicyLearnMorePage = require(Modules2.LuaApp.Thunks.OpenRefundPolicyLearnMorePage)
local OpenWebview = require(Modules2.LuaApp.Thunks.OpenWebview)
local ExperienceSongsCarousel = require(Modules2.LuaApp.Components.ExperienceDetails.ExperienceSongsCarousel)
local RecommendedExperienceCarousel = require(Modules2.LuaApp.Components.ExperienceDetails.RecommendedExperienceCarousel)
local EdpSduiUtils = require(script.Parent.Parent.ExperienceDetails.EdpSduiUtils)
local ServerDrivenUi = require(CorePackages.Workspace.Packages.ServerDrivenUi)
local GameDetailTelemetry = require(CorePackages.Workspace.Packages.GameDetailTelemetry)
local EDPTTIConstants = GameDetailTelemetry.EDPTTIConstants
local FFlagEDPTTITrackingEnabled = GameDetailTelemetry.FFlagEDPTTITrackingEnabled
local useEDPTTITracking = require(Modules2.LuaApp.Components.ExperienceDetails.useEDPTTITracking)
local useFirstMediaCarouselImageUri = require(Modules2.LuaApp.Components.ExperienceDetails.useFirstMediaCarouselImageUri).useFirstMediaCarouselImageUri
local FFlagLuaAppExperienceDetailsLayoutOrderConfig = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppExperienceDetailsLayoutOrderConfig
local FFlagSongEdpCarouselIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSongEdpCarouselIxp
local v80 = game:DefineFastFlag("LuaAppFixNoticeLocalization", false)
local FFlagLuaAppEnableConsolidatedGameRefundPolicy = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEnableConsolidatedGameRefundPolicy
local FFlagLuaAppEdpMediaGalleryRedesignIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpMediaGalleryRedesignIxp
local FFlagLuaAppEdpMediaGalleryVideoPreviewIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpMediaGalleryVideoPreviewIxp
local FFlagLuaAppEdpMediaGalleryRedesignTelemetry = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpMediaGalleryRedesignTelemetry
local FFlagLuaAppEdpBackendV2HydrateLegacyDefault = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyDefault
local FFlagLuaAppEdpBackendV2HydrateLegacyIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyIxp
local FFlagEnablePlayWithRewardComponent = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnablePlayWithRewardComponent
local FFlagLuaAppEdpBackendV2SduiInterleaveDefault = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2SduiInterleaveDefault
local FFlagLuaAppEdpBackendV2SduiInterleaveIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2SduiInterleaveIxp
local FFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable
local FFlagLuaAppAddUniverseIdToGameDetailsEvents = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppAddUniverseIdToGameDetailsEvents
local FFlagLuaAppExpandableTextImpressionsEnabled = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppExpandableTextImpressionsEnabled
local FFlagLuaAppEdpKeepCachedDetailsOnRefetch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpKeepCachedDetailsOnRefetch
local FFlagLuaAppEdpMediaGalleryHeightJitterFix = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpMediaGalleryHeightJitterFix
local t1 = {
	[1] = {
		Size = UDim2.new(0.5, 0, 0, 35)
	},
	[2] = {
		Size = UDim2.new(0.25, 0, 0, 24)
	},
	[3] = {
		Size = UDim2.new(1, 0, 0, 200)
	},
	[4] = {
		Size = UDim2.new(1, 0, 0, 24)
	},
	[5] = {
		Size = UDim2.new(0.6, 0, 0, 24)
	}
}
local u96 = nil

if FFlagLuaAppEdpKeepCachedDetailsOnRefetch then
	function u96(p1, p2, p3, p4) -- line: 154
		-- upvalues: RetrievalStatus (copy), NextDataExpirationTimeReducer (copy), ExpirationTimeNamespace (copy)
		local v115 = p3 == RetrievalStatus.Fetching or p3 == RetrievalStatus.NotStarted

		if p4 ~= nil and v115 then
			local v116 = p1.Personalization[NextDataExpirationTimeReducer.key][ExpirationTimeNamespace.GameDetailPage]
			local v117 = v116 and v116[p2]

			if v117 ~= nil and v117 >= tick() then
				return RetrievalStatus.Done
			end
		end

		return p3
	end
end

local function getInnerPaddingSize(p5) -- line: 168
	if p5 < 600 then
		return 20
	end

	return 40
end
local function createLayoutOrderGenerator() -- line: 172
	local n1 = 0

	return function() -- line: 174
		-- upvalues: n1 (ref)
		n1 += 1

		return n1
	end
end

local t2 = {
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
local v100 = Roact.PureComponent:extend("GameDetailsCard")

function v100.init(p6) -- line: 199
	-- upvalues: FFlagEnablePlayWithRewardComponent (copy), ArgCheck (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), FFlagLuaAppEdpBackendV2SduiInterleaveIxp (copy), FFlagLuaAppEdpBackendV2SduiInterleaveDefault (copy), FFlagLuaAppEdpMediaGalleryRedesignTelemetry (copy), MediaGallerySwiped (copy), FFlagLuaAppAddUniverseIdToGameDetailsEvents (copy), MediaGalleryMediaChanged (copy), memoize (copy), FFlagRenameDeprecatedUIBloxTokens (copy), checkAndFormatPossibleLink (copy), Roact (copy), RetrievalStatus (copy), FFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable (copy)
	if FFlagEnablePlayWithRewardComponent then
		p6.state = {
			didFocus = false
		}

		function p6.onDidFocus() -- line: 202
			-- upvalues: p6 (copy)
			p6:setState({
				didFocus = true
			})
		end
	end

	local universeId = p6.props.universeId

	ArgCheck.isType(universeId, "string", "GameDetailsCard.init.universeId")

	function p6.fetchGameDetailsPageData() -- line: 210
		-- upvalues: p6 (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), FFlagLuaAppEdpBackendV2SduiInterleaveIxp (copy), FFlagLuaAppEdpBackendV2SduiInterleaveDefault (copy)
		local networking = p6.props.networking
		local universeId2 = p6.props.universeId

		return p6.props.fetchGameDetailsPageData(networking, universeId2, if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else p6.props.shouldHydrateLegacyIxp, if not FFlagLuaAppEdpBackendV2SduiInterleaveIxp then nil else p6.props.shouldInterleaveSduiIxp, if not FFlagLuaAppEdpBackendV2SduiInterleaveDefault and (not FFlagLuaAppEdpBackendV2SduiInterleaveIxp or not p6.props.shouldInterleaveSduiIxp) then nil else p6.props.sduiDataUpdatedTimestamp)
	end

	p6.onMediaGallerySwiped = not FFlagLuaAppEdpMediaGalleryRedesignTelemetry and function() -- line: 229
		-- upvalues: p6 (copy), MediaGallerySwiped (copy), FFlagLuaAppAddUniverseIdToGameDetailsEvents (copy)
		local v216 = p6.props.gameDetail and p6.props.gameDetail.rootPlaceId or nil

		if v216 then
			MediaGallerySwiped(p6.props.eventIngest, "GameDetailsCard", v216, if not FFlagLuaAppAddUniverseIdToGameDetailsEvents then nil else {
				universeId = p6.props.universeId
			})
		end
	end or nil
	p6.onMediaGalleryMediaChanged = if not FFlagLuaAppEdpMediaGalleryRedesignTelemetry then nil else function(p7, p8, p9, p10) -- line: 246
		-- upvalues: p6 (copy), MediaGalleryMediaChanged (copy), FFlagLuaAppAddUniverseIdToGameDetailsEvents (copy)
		local v221 = p6.props.gameDetail and p6.props.gameDetail.rootPlaceId or nil

		if v221 then
			MediaGalleryMediaChanged(p6.props.eventIngest, "GameDetailsCard", v221, {
				imageAssetId = p7,
				videoAssetId = p8,
				isYouTubeVideo = p9,
				autoAdvance = p10,
				universeId = if not FFlagLuaAppAddUniverseIdToGameDetailsEvents then nil else p6.props.universeId
			})
		end
	end
	p6.linkStartStyle = memoize(function(p11) -- line: 260
		-- upvalues: FFlagRenameDeprecatedUIBloxTokens (copy)
		local Color3 = ((if not FFlagRenameDeprecatedUIBloxTokens then p11.Tokens.Semantic.Color.Text.Link else p11.Tokens.Color.Content.Link)).Color3

		return `<font color="{ string.format("rgb(%d, %d, %d)", math.round(Color3.R * 255), math.round(Color3.G * 255), (math.round(Color3.B * 255))) }"><b>`
	end)
	p6.checkAndFormatPossibleLink = memoize(function(p12, p13) -- line: 274
		-- upvalues: checkAndFormatPossibleLink (copy), p6 (copy)
		return checkAndFormatPossibleLink(p13, nil, nil, p6.linkStartStyle(p12), "</b></font>")
	end)

	function p6.renderRefundPolicy(p14, p15, p16) -- line: 280
		-- upvalues: FFlagRenameDeprecatedUIBloxTokens (copy), p6 (copy), Roact (copy)
		local v229 = if not FFlagRenameDeprecatedUIBloxTokens then p14.Tokens.Semantic.Typography.Body else p14.Tokens.Typography.BodyLarge
		local v230 = if not FFlagRenameDeprecatedUIBloxTokens then p14.Tokens.Semantic.Color.Text.Muted else p14.Tokens.Color.Content.Muted
		local v231, v232 = p6.checkAndFormatPossibleLink(p14, p15.policyText)

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = p16
		}, {
			RefundPolicy = Roact.createElement("TextButton", {
				BackgroundTransparency = 1,
				Text = v232,
				AutomaticSize = Enum.AutomaticSize.XY,
				Font = v229.Font,
				TextSize = v229.FontSize,
				TextColor3 = v230.Color3,
				TextTransparency = v230.Transparency,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				RichText = v231,
				[Roact.Event.Activated] = function(_) -- line: 312
					-- upvalues: p6 (copy), p15 (copy)
					p6.props.openRefundPolicyLearnMorePage(p15.learnMoreUrl)
				end
			})
		})
	end

	p6.maybeFetchPlayWithReward = if not FFlagEnablePlayWithRewardComponent then nil else function() -- line: 320
		-- upvalues: p6 (copy), RetrievalStatus (copy), FFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable (copy), FFlagLuaAppEdpBackendV2SduiInterleaveDefault (copy), FFlagLuaAppEdpBackendV2SduiInterleaveIxp (copy)
		if p6.state.didFocus ~= true or p6.props.gameDetailsPageDataStatus ~= RetrievalStatus.Done then
			return
		end

		if FFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable and ((FFlagLuaAppEdpBackendV2SduiInterleaveDefault or FFlagLuaAppEdpBackendV2SduiInterleaveIxp and p6.props.shouldInterleaveSduiIxp) and (p6.props.edpPerUniverseVisibilityVariables and p6.props.edpPerUniverseVisibilityVariables.hidePlayWithReward == true)) then
			return
		end

		local num = tonumber(p6.props.localUserId)

		if not num then
			return
		end

		if p6.props.playWithRewardData and p6.props.playWithRewardData.universeId == p6.props.universeId then
			return
		end

		p6:setState({
			didFocus = false
		})
		p6.props.fetchPlayWithReward(p6.props.universeId, num):catch(function() -- line: 348
		end)
	end
end
function v100.renderOnLoading(_, p19) -- line: 353
	-- upvalues: Roact (copy), LoadingSkeleton (copy), t1 (copy)
	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		Padding = Roact.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 0),
			PaddingLeft = UDim.new(0, p19),
			PaddingRight = UDim.new(0, p19)
		}),
		Skeleton = Roact.createElement(LoadingSkeleton, {
			Size = UDim2.new(1, 0, 1, 0),
			createLayout = function() -- line: 365
				-- upvalues: Roact (copy)
				return Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 15)
				})
			end,
			panels = t1
		})
	})
end
function v100.renderOnLoaded(p20, p21, p22, p23, p24) -- line: 378
	-- upvalues: FFlagLuaAppEdpBackendV2SduiInterleaveDefault (copy), FFlagLuaAppEdpBackendV2SduiInterleaveIxp (copy), ExperienceDetailsExperimentation (copy), FFlagEnablePlayWithRewardComponent (copy), FFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable (copy), withStyle (copy), Roact (copy), FFlagLuaAppExperienceDetailsLayoutOrderConfig (copy), GameHeader (copy), t2 (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), ExperienceMediaGallery (copy), FFlagLuaAppEdpMediaGalleryHeightJitterFix (copy), FFlagLuaAppEdpMediaGalleryRedesignTelemetry (copy), FFlagLuaAppEdpMediaGalleryRedesignIxp (copy), FFlagLuaAppEdpMediaGalleryVideoPreviewIxp (copy), GameStatsCarousel (copy), ExperienceTagsContainer (copy), EventsListWrapper (copy), ExperienceDescription (copy), RetrievalStatus2 (copy), FFlagRenameDeprecatedUIBloxTokens (copy), FFlagLuaAppExpandableTextImpressionsEnabled (copy), AppPage (copy), IgrsRatingLabel (copy), Constants (copy), GamePlaysAndRatings (copy), GameInfoList (copy), FFlagLuaAppEnableConsolidatedGameRefundPolicy (copy), GameRefundPolicy (copy), ExperienceDetailsNoticeType (copy), v80 (copy), RetrievalStatus (copy), RecommendedExperienceCarousel (copy), FFlagSongEdpCarouselIxp (copy), ExperienceSongsCarousel (copy), PlayWithRewardComponent (copy)
	local universeId = p20.props.universeId
	local gameDetail = p20.props.gameDetail
	local gameInfo = p20.props.gameInfo
	local v132 = gameDetail and gameDetail.rootPlaceId or gameInfo and gameInfo.placeId
	local v133 = p20.props.showRecommendedGames and p20.props.enableRecommendedGames
	local v134 = gameDetail and p20.props.enableSocial
	local v135 = gameDetail and p20.props.enableGameInfoList
	local enableGamePlaysAndRatings = p20.props.enableGamePlaysAndRatings
	local enableGamePassPreview = p20.props.enableGamePassPreview

	if (FFlagLuaAppEdpBackendV2SduiInterleaveDefault or FFlagLuaAppEdpBackendV2SduiInterleaveIxp and ExperienceDetailsExperimentation.getShouldInterleaveSdui()) and (p20.props.edpServerIxpVariables and p20.props.edpServerIxpVariables.hideGameRatings == true) then
		enableGamePlaysAndRatings = false
	end

	local v138 = gameDetail and (gameDetail.description ~= nil and gameDetail.description ~= "")
	local showGlobalCounters = p20.props.showGlobalCounters
	local showLikesFavoritesCount = p20.props.showLikesFavoritesCount
	local ageRecommendations = p20.props.ageRecommendations
	local v142 = if not ageRecommendations or (not ageRecommendations.summary or (not ageRecommendations.summary.ageRecommendation or (not ageRecommendations.summary.ageRecommendation.igrsRating or ageRecommendations.summary.ageRecommendation.igrsRating == ""))) then nil else ageRecommendations.summary.ageRecommendation.igrsRating
	local v143 = if not ageRecommendations or (not ageRecommendations.summary or (not ageRecommendations.summary.ageRecommendation or not ageRecommendations.summary.ageRecommendation.igrsRatingDisplayMessage)) then nil else ageRecommendations.summary.ageRecommendation.igrsRatingDisplayMessage
	local notificationsCanAccessExperience = p20.props.notificationsCanAccessExperience

	if (FFlagLuaAppEdpBackendV2SduiInterleaveDefault or FFlagLuaAppEdpBackendV2SduiInterleaveIxp and ExperienceDetailsExperimentation.getShouldInterleaveSdui()) and (p20.props.edpServerIxpVariables and p20.props.edpServerIxpVariables.hideNotifyButton == true) then
		notificationsCanAccessExperience = false
	end

	local n2 = 0

	local function v146() -- line: 174
		-- upvalues: n2 (ref)
		n2 += 1

		return n2
	end

	local v147 = p20.props.webViewSupport and (gameDetail ~= nil and gameDetail.refundPolicy ~= nil)
	local v148 = if not FFlagEnablePlayWithRewardComponent then nil else p20.props.isPlayabilitySettledAndPlayable
	local v149 = FFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable and ((FFlagLuaAppEdpBackendV2SduiInterleaveDefault or FFlagLuaAppEdpBackendV2SduiInterleaveIxp and p20.props.shouldInterleaveSduiIxp) and (p20.props.edpPerUniverseVisibilityVariables and p20.props.edpPerUniverseVisibilityVariables.hidePlayWithReward == true))
	local v150 = if not FFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable then nil else FFlagEnablePlayWithRewardComponent and (v148 and not v149)

	return withStyle(function(p25) -- line: 450
		-- upvalues: Roact (copy), p22 (copy), FFlagLuaAppExperienceDetailsLayoutOrderConfig (copy), GameHeader (copy), t2 (copy), universeId (copy), notificationsCanAccessExperience (ref), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), p20 (copy), v146 (copy), ExperienceMediaGallery (copy), FFlagLuaAppEdpMediaGalleryHeightJitterFix (copy), p21 (copy), FFlagLuaAppEdpMediaGalleryRedesignTelemetry (copy), FFlagLuaAppEdpMediaGalleryRedesignIxp (copy), FFlagLuaAppEdpMediaGalleryVideoPreviewIxp (copy), FFlagLuaAppEdpBackendV2SduiInterleaveDefault (copy), FFlagLuaAppEdpBackendV2SduiInterleaveIxp (copy), ExperienceDetailsExperimentation (copy), GameStatsCarousel (copy), ExperienceTagsContainer (copy), EventsListWrapper (copy), v132 (copy), v138 (copy), ExperienceDescription (copy), RetrievalStatus2 (copy), p23 (copy), gameDetail (copy), FFlagRenameDeprecatedUIBloxTokens (copy), FFlagLuaAppExpandableTextImpressionsEnabled (copy), AppPage (copy), v142 (copy), IgrsRatingLabel (copy), v143 (copy), Constants (copy), p24 (copy), enableGamePlaysAndRatings (ref), GamePlaysAndRatings (copy), showGlobalCounters (copy), showLikesFavoritesCount (copy), v135 (copy), GameInfoList (copy), v134 (copy), ageRecommendations (copy), enableGamePassPreview (copy), v147 (copy), FFlagLuaAppEnableConsolidatedGameRefundPolicy (copy), GameRefundPolicy (copy), ExperienceDetailsNoticeType (copy), v80 (copy), RetrievalStatus (copy), v133 (copy), RecommendedExperienceCarousel (copy), FFlagSongEdpCarouselIxp (copy), ExperienceSongsCarousel (copy), gameInfo (copy), FFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable (copy), v150 (copy), FFlagEnablePlayWithRewardComponent (copy), v148 (copy), PlayWithRewardComponent (copy)
		local t3 = {
			ListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 20)
			}),
			PagePadding = Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, p22),
				PaddingRight = UDim.new(0, p22),
				PaddingTop = UDim.new(0, 0),
				PaddingBottom = UDim.new(0, 20)
			}),
			Header = if not FFlagLuaAppExperienceDetailsLayoutOrderConfig then Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = v146(),
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				ListLayout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 20)
				}),
				MediaGalleryFrame = Roact.createElement("Frame", {
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Position = UDim2.new(0, 0, 0, 0),
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}, {
					MediaGallery = Roact.createElement(ExperienceMediaGallery, {
						deviceType = "Phone",
						showYouTubeVideoFirst = false,
						universeId = universeId,
						initialWidth = if not FFlagLuaAppEdpMediaGalleryHeightJitterFix then nil else p21 - p22 * 2,
						onSwipe = if not FFlagLuaAppEdpMediaGalleryRedesignTelemetry then p20.onMediaGallerySwiped else nil,
						onMediaGalleryMediaChanged = if not FFlagLuaAppEdpMediaGalleryRedesignTelemetry then nil else p20.onMediaGalleryMediaChanged,
						mediaGalleryRedesignEnabledIxp = if not FFlagLuaAppEdpMediaGalleryRedesignIxp then nil else p20.props.mediaGalleryRedesignEnabledIxp,
						mediaGalleryVideoPreviewEnabledIxp = if not FFlagLuaAppEdpMediaGalleryVideoPreviewIxp then nil else p20.props.mediaGalleryVideoPreviewEnabledIxp,
						shouldHydrateLegacyIxp = if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else p20.props.shouldHydrateLegacyIxp
					}),
					SizeConstraint = Roact.createElement("UISizeConstraint", {
						MinSize = Vector2.new(0, (p21 - p22 * 2) / 1.7777777777777777)
					})
				}),
				Header = Roact.createElement(GameHeader, {
					LayoutOrder = 1,
					universeId = universeId,
					showNotificationButton = notificationsCanAccessExperience,
					shouldHydrateLegacyIxp = if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else p20.props.shouldHydrateLegacyIxp
				})
			}) else Roact.createElement(GameHeader, {
				LayoutOrder = t2.Header,
				universeId = universeId,
				showNotificationButton = notificationsCanAccessExperience,
				shouldHydrateLegacyIxp = if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else p20.props.shouldHydrateLegacyIxp
			}),
			MediaGalleryFrame = if not FFlagLuaAppExperienceDetailsLayoutOrderConfig then nil else Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = t2.MediaGallery,
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				MediaGallery = Roact.createElement(ExperienceMediaGallery, {
					deviceType = "Phone",
					showYouTubeVideoFirst = false,
					universeId = universeId,
					initialWidth = if not FFlagLuaAppEdpMediaGalleryHeightJitterFix then nil else p21 - p22 * 2,
					onSwipe = if not FFlagLuaAppEdpMediaGalleryRedesignTelemetry then p20.onMediaGallerySwiped else nil,
					onMediaGalleryMediaChanged = if not FFlagLuaAppEdpMediaGalleryRedesignTelemetry then nil else p20.onMediaGalleryMediaChanged,
					mediaGalleryRedesignEnabledIxp = if not FFlagLuaAppEdpMediaGalleryRedesignIxp then nil else p20.props.mediaGalleryRedesignEnabledIxp,
					mediaGalleryVideoPreviewEnabledIxp = if not FFlagLuaAppEdpMediaGalleryVideoPreviewIxp then nil else p20.props.mediaGalleryVideoPreviewEnabledIxp,
					shouldHydrateLegacyIxp = if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else p20.props.shouldHydrateLegacyIxp
				}),
				SizeConstraint = Roact.createElement("UISizeConstraint", {
					MinSize = Vector2.new(0, (p21 - p22 * 2) / 1.7777777777777777)
				})
			}),
			StatsCarousel = if not FFlagLuaAppEdpBackendV2SduiInterleaveDefault and (not FFlagLuaAppEdpBackendV2SduiInterleaveIxp or not ExperienceDetailsExperimentation.getShouldInterleaveSdui()) or (not p20.props.edpServerIxpVariables or p20.props.edpServerIxpVariables.hideStatsCarousel ~= true) then Roact.createElement(GameStatsCarousel, {
				LayoutOrder = if not FFlagLuaAppExperienceDetailsLayoutOrderConfig then v146() else t2.StatsCarousel,
				universeId = universeId,
				shouldHydrateLegacyIxp = if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else p20.props.shouldHydrateLegacyIxp
			}) else nil,
			TagSection = Roact.createElement(ExperienceTagsContainer, {
				LayoutOrder = if not FFlagLuaAppExperienceDetailsLayoutOrderConfig then v146() else t2.TagSection,
				universeId = universeId,
				shouldHydrateLegacyIxp = if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else p20.props.shouldHydrateLegacyIxp,
				hideContentDescriptors = not (not FFlagLuaAppEdpBackendV2SduiInterleaveDefault and (not FFlagLuaAppEdpBackendV2SduiInterleaveIxp or not ExperienceDetailsExperimentation.getShouldInterleaveSdui())) and (not not p20.props.edpServerIxpVariables and p20.props.edpServerIxpVariables.showContentDescriptorsInInfoList == true) or nil
			}),
			MovedEventsList = Roact.createElement(EventsListWrapper, {
				referralSource = "expDetailsPage",
				peekViewFormat = true,
				layoutOrder = if not FFlagLuaAppExperienceDetailsLayoutOrderConfig then v146() else t2.MovedEventsList,
				universeId = universeId,
				defaultThumbnail = if not v132 then nil else ("rbxthumb://type=GameThumbnail&id=%d&w=768&h=432"):format(v132)
			}),
			Description = if not v138 then nil else Roact.createElement(ExperienceDescription, {
				expandable = true,
				dataStatus = RetrievalStatus2.fromRawValue(p23),
				descriptionText = gameDetail and gameDetail.description,
				listPadding = if not FFlagRenameDeprecatedUIBloxTokens then p25.Tokens.Global.Space_125 else p25.Tokens.Size.Size_250,
				LayoutOrder = if not FFlagLuaAppExperienceDetailsLayoutOrderConfig then v146() else t2.Description,
				universeId = if not FFlagLuaAppExpandableTextImpressionsEnabled then nil else universeId,
				pageContext = if not FFlagLuaAppExpandableTextImpressionsEnabled then nil else AppPage.GameDetail,
				componentType = if not FFlagLuaAppExpandableTextImpressionsEnabled then nil else "gameDescription",
				viewportBoundsOffset = if not FFlagLuaAppExpandableTextImpressionsEnabled then nil else p20.props.viewportBoundsOffset
			}),
			IgrsRatingLabel = if not v142 then nil else Roact.createElement(IgrsRatingLabel, {
				igrsRating = v142,
				igrsRatingDisplayMessage = v143,
				onActivated = function() -- line: 642
					-- upvalues: p20 (copy), Constants (copy), p24 (copy)
					p20.props.openWebview(Constants.INDONESIAN_CONTENT_MATURITY_URL, p24.contentMaturityHeader)
				end,
				LayoutOrder = if not FFlagLuaAppExperienceDetailsLayoutOrderConfig then v146() else t2.IgrsRatingLabel
			}),
			PlaysAndRatings = enableGamePlaysAndRatings and Roact.createElement(GamePlaysAndRatings, {
				rowPadding = 20,
				hideVisits = true,
				LayoutOrder = if not FFlagLuaAppExperienceDetailsLayoutOrderConfig then v146() else t2.PlaysAndRatings,
				universeId = universeId,
				containerWidth = p21 - 2 * p22,
				showGlobalCounters = showGlobalCounters,
				showLikesFavoritesCount = showLikesFavoritesCount,
				shouldHydrateLegacyIxp = if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else p20.props.shouldHydrateLegacyIxp
			}),
			InfoList = v135 and Roact.createElement(GameInfoList, {
				LayoutOrder = if not FFlagLuaAppExperienceDetailsLayoutOrderConfig then v146() else t2.InfoList,
				universeId = universeId,
				leftPadding = p22,
				rightPadding = p22,
				showSocial = v134,
				ageRecommendations = ageRecommendations,
				width = p21,
				enableGamePassPreview = enableGamePassPreview,
				shouldHydrateLegacyIxp = if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else p20.props.shouldHydrateLegacyIxp
			}),
			RefundPolicy = if not v147 then nil else if not FFlagLuaAppEnableConsolidatedGameRefundPolicy then p20.renderRefundPolicy(p25, gameDetail.refundPolicy, if not FFlagLuaAppExperienceDetailsLayoutOrderConfig then v146() else t2.RefundPolicy) else Roact.createElement(GameRefundPolicy, {
				refundPolicy = gameDetail.refundPolicy,
				layoutOrder = if not FFlagLuaAppExperienceDetailsLayoutOrderConfig then v146() else t2.RefundPolicy
			}),
			Notice = if p20.props.experienceDetailsNoticeType ~= ExperienceDetailsNoticeType.InExperiencePurchase then nil else Roact.createElement(ExperienceDescription, {
				expandable = false,
				dataStatus = if not v80 then RetrievalStatus2.fromRawValue(p23) else RetrievalStatus2.fromRawValue(RetrievalStatus.Done),
				headerText = p24.noticeHeader,
				descriptionText = p24.noticeText,
				listPadding = if not FFlagRenameDeprecatedUIBloxTokens then p25.Tokens.Global.Space_125 else p25.Tokens.Size.Size_250,
				LayoutOrder = if not FFlagLuaAppExperienceDetailsLayoutOrderConfig then v146() else t2.Notice,
				universeId = if not FFlagLuaAppExpandableTextImpressionsEnabled then nil else universeId,
				pageContext = if not FFlagLuaAppExpandableTextImpressionsEnabled then nil else AppPage.GameDetail,
				componentType = if not FFlagLuaAppExpandableTextImpressionsEnabled then nil else "gameNotice",
				viewportBoundsOffset = if not FFlagLuaAppExpandableTextImpressionsEnabled then nil else p20.props.viewportBoundsOffset
			}),
			RecommendedGames = v133 and Roact.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				LayoutOrder = if not FFlagLuaAppExperienceDetailsLayoutOrderConfig then v146() else t2.RecommendedGames,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				Carousel = Roact.createElement(RecommendedExperienceCarousel, {
					scrollingEnabled = true,
					universeId = universeId,
					pageContext = AppPage.GameDetail,
					onPeekViewClosed = p20.props.onPeekViewClosed,
					shouldHydrateLegacyIxp = if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else p20.props.shouldHydrateLegacyIxp
				})
			}),
			ExperienceSongsCarousel = if not FFlagSongEdpCarouselIxp or not p20.props.showSongCarousel then nil else Roact.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = if not FFlagLuaAppExperienceDetailsLayoutOrderConfig then v146() else t2.ExperienceSongsCarousel
			}, { Roact.createElement(ExperienceSongsCarousel, {
				collectionOrder = 2,
				clipsDescendants = false,
				universeId = universeId,
				universeTitle = gameDetail and gameDetail.name or (gameInfo and gameInfo.name or "")
			}) }),
			PlayWithRewardComponent = if not if not FFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable then FFlagEnablePlayWithRewardComponent and v148 else v150 then nil else Roact.createElement(PlayWithRewardComponent, {
				universeId = universeId,
				placeId = v132,
				placeIdOverride = p20.props.placeIdOverride,
				experienceJoinData = p20.props.experienceJoinData,
				flowId = not p20.props.playWithRewardData and "" or p20.props.playWithRewardData.flowId,
				fetchedUniverseId = if not p20.props.playWithRewardData then nil else p20.props.playWithRewardData.universeId,
				isAdDataExpected = not not p20.props.playWithRewardData and p20.props.playWithRewardData.isAdDataExpected,
				playWithRewardAdData = if not p20.props.playWithRewardData then nil else p20.props.playWithRewardData.adData
			})
		}

		if (FFlagLuaAppEdpBackendV2SduiInterleaveDefault or FFlagLuaAppEdpBackendV2SduiInterleaveIxp and p20.props.shouldInterleaveSduiIxp) and p20.props.sduiFeedItemConfigs then
			for v236, v237 in p20.props.sduiFeedItemConfigs do
				t3[`SduiFeedItem_{ v236 }`] = Roact.createElement("Frame", {
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					LayoutOrder = v237.portraitLayoutOrder
				}, {
					SduiComponent = v237.renderComponent()
				})
			end
		end

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, t3)
	end)
end
function v100.renderOnFailed(p26, p27, p28, p29) -- line: 811
	-- upvalues: EnumGameDetailErrorTypes (copy), Roact (copy), EmptyState (copy)
	if p26.props.gameInfo then
		return p26:renderOnLoaded(p28, p29, nil, p27)
	end

	local v155 = p26.props.gameDetailError and p26.props.gameDetailError.errorType == EnumGameDetailErrorTypes.ExperienceUnavailable

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		Padding = Roact.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 100),
			PaddingLeft = UDim.new(0, p29),
			PaddingRight = UDim.new(0, p29),
			PaddingBottom = UDim.new(0, 20)
		}),
		EmptyState = Roact.createElement(EmptyState, {
			onActivated = if not v155 then p26.fetchGameDetailsPageData else nil,
			text = if not v155 then p27.failedMessage else p27.experienceUnavailableMessage,
			maxSizeTextLabel = Vector2.new(p28 - 2 * p29, 1e999)
		})
	})
end
function v100.getImageSize(_, p31, p32, p33, p34) -- line: 841
	local v161 = p32 * 1.8
	local v162 = p34 / p33
	local v163 = math.max(v161, p31 * v162)
	local v164 = v163 / v162

	return Vector2.new(v164, v163)
end
function v100.render(p35) -- line: 852
	-- upvalues: getSafeAreaSize (copy), Roact (copy), withLocalization (copy), LoadingStateContainer (copy), RetrievalStatus2 (copy), FFlagEnablePlayWithRewardComponent (copy), RoactNavigation (copy)
	local screenSize = p35.props.screenSize
	local globalGuiInset = p35.props.globalGuiInset
	local gameDetailsPageDataStatus = p35.props.gameDetailsPageDataStatus
	local v169 = getSafeAreaSize(screenSize, globalGuiInset)
	local v170 = math.min(v169.X.Offset, 640)
	local YOffset = v169.Y.Offset
	local v172 = not (v170 < 600) and 40 or 20
	local v173 = Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = UDim2.new(0, 0, 0, 0)
	}, {
		GameDetails = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0)
		}, {
			Background = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				ZIndex = 1,
				Size = UDim2.new(1, 0, 0, YOffset),
				Position = UDim2.new(0, 0, 0, 0)
			}),
			LoadingState = withLocalization({
				failedMessage = "Feature.EmptyStatePage.Message.NoInternet",
				experienceUnavailableMessage = "Feature.GamePage.QuickLaunch.LaunchError.TemporarilyUnavailable",
				noticeHeader = "Feature.ExperienceDetails.Body.NotesTitle",
				noticeText = "Feature.ExperienceDetails.Notes.InExperiencePurchase",
				contentMaturityHeader = "Feature.GameDetails.Label.ContentMaturity"
			})(function(p36) -- line: 887
				-- upvalues: Roact (copy), LoadingStateContainer (copy), RetrievalStatus2 (copy), gameDetailsPageDataStatus (copy), p35 (copy), v170 (copy), v172 (copy)
				return Roact.createElement("Frame", {
					ZIndex = 2,
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					Position = UDim2.new(0, 0, 0, 0)
				}, {
					LoadingStateContainer = Roact.createElement(LoadingStateContainer, {
						dataStatus = RetrievalStatus2.fromRawValue(gameDetailsPageDataStatus),
						renderOnFailed = function() -- line: 897
							-- upvalues: p35 (copy), p36 (copy), v170 (copy), v172 (copy)
							return p35:renderOnFailed(p36, v170, v172)
						end,
						renderOnLoading = function() -- line: 900
							-- upvalues: p35 (copy), v172 (copy)
							return p35:renderOnLoading(v172)
						end,
						renderOnLoaded = function() -- line: 903
							-- upvalues: p35 (copy), v170 (copy), v172 (copy), gameDetailsPageDataStatus (copy), p36 (copy)
							return p35:renderOnLoaded(v170, v172, gameDetailsPageDataStatus, p36)
						end
					})
				})
			end)
		})
	})

	if FFlagEnablePlayWithRewardComponent then
		return Roact.createFragment({
			Content = v173,
			NavigationEvents = Roact.createElement(RoactNavigation.NavigationEvents, {
				onDidFocus = p35.onDidFocus
			})
		})
	end

	return v173
end
function v100.didMount(p37) -- line: 929
	-- upvalues: FFlagEnablePlayWithRewardComponent (copy)
	p37.fetchGameDetailsPageData()

	if FFlagEnablePlayWithRewardComponent then
		p37.maybeFetchPlayWithReward()
	end
end
function v100.didUpdate(p38) -- line: 936
	-- upvalues: FFlagEnablePlayWithRewardComponent (copy)
	if FFlagEnablePlayWithRewardComponent then
		p38.maybeFetchPlayWithReward()
	end
end
function v100.willUnmount(p39) -- line: 942
	-- upvalues: FFlagEnablePlayWithRewardComponent (copy)
	local eventIngest = p39.props.eventIngest
	local universeId = p39.props.universeId
	local v179 = p39.props.gameDetail and p39.props.gameDetail.rootPlaceId or nil
	local v180 = p39.props.source or "None"
	local v181 = p39.props.index or -1

	if eventIngest ~= nil and (universeId ~= nil and v179 ~= nil) then
		eventIngest:setRBXEventStream("GameDetailsCard", "viewClose", {
			universeId = universeId,
			rootPlaceId = v179,
			source = v180,
			index = v181
		})
	end

	if FFlagEnablePlayWithRewardComponent then
		p39.props.clearPlayWithReward()
	end
end

local v101 = memoize(function(p40, p41) -- line: 961
	-- upvalues: RetrievalStatus (copy)
	if p40 == RetrievalStatus.Done and (p41 == nil or #p41 == 0) then
		return false
	end

	return true
end)
local v102 = RoactRodux.connect(function(p42, p43) -- line: 971
	-- upvalues: FFlagEnablePlayWithRewardComponent (copy), FetchGamePlayabilityAndProductInfo (copy), RetrievalStatus (copy), PlayabilityStatusEnum (copy), PlayButtonStates (copy), FFlagLuaAppEdpBackendV2HydrateLegacyDefault (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), ApiFetchExperienceDetailsPage (copy), ApiFetchGameDetails (copy), RecommendedGames (copy), FFlagLuaAppEdpKeepCachedDetailsOnRefetch (copy), u96 (ref), GameInfosReducer (copy), v101 (copy)
	local v186 = if not FFlagEnablePlayWithRewardComponent then nil else FetchGamePlayabilityAndProductInfo.GetFetchingStatus(p42, p43.universeId)
	local v187 = if not FFlagEnablePlayWithRewardComponent then nil else p42.PlayabilityStatus and p42.PlayabilityStatus[p43.universeId] or nil
	local v188 = if not FFlagEnablePlayWithRewardComponent then nil else v186 == RetrievalStatus.Done and (v187 ~= nil and (v187.playabilityStatus == PlayabilityStatusEnum.Playable and p43.playButtonState == PlayButtonStates.Playable))
	local v189, v190

	if FFlagLuaAppEdpBackendV2HydrateLegacyDefault or FFlagLuaAppEdpBackendV2HydrateLegacyIxp and p43.shouldHydrateLegacyIxp then
		v189 = ApiFetchExperienceDetailsPage.GetFetchingStatus(p42, p43.universeId)
		v190 = ApiFetchExperienceDetailsPage.GetFetchingStatus(p42, p43.universeId)
	else
		v189 = ApiFetchGameDetails.GetFetchingStatus(p42, p43.universeId)
		v190 = RecommendedGames.GetFetchingStatus(p42, p43.universeId)
	end

	local v191 = nil
	local v192 = nil

	if FFlagLuaAppEdpKeepCachedDetailsOnRefetch then
		v191 = if not FFlagLuaAppEdpBackendV2HydrateLegacyDefault and (not FFlagLuaAppEdpBackendV2HydrateLegacyIxp or not p43.shouldHydrateLegacyIxp) then p42.GameDetails[p43.universeId] else p42.GameDetailsV2[p43.universeId]
		v192 = u96(p42, p43.universeId, v189, v191)
	end

	local v193 = p42.Personalization[GameInfosReducer.key][p43.universeId]
	local PlayWithRewardState = nil

	if FFlagEnablePlayWithRewardComponent and p42.PlayWithRewardState.universeId == p43.universeId then
		PlayWithRewardState = p42.PlayWithRewardState
	end

	return {
		topBarHeight = 0,
		gameDetail = if not FFlagLuaAppEdpKeepCachedDetailsOnRefetch then if not FFlagLuaAppEdpBackendV2HydrateLegacyDefault and (not FFlagLuaAppEdpBackendV2HydrateLegacyIxp or not p43.shouldHydrateLegacyIxp) then p42.GameDetails[p43.universeId] else p42.GameDetailsV2[p43.universeId] else v191,
		gameDetailError = p42.GameDetailErrors[p43.universeId],
		gameDetailsPageDataStatus = if not FFlagLuaAppEdpKeepCachedDetailsOnRefetch then v189 else v192,
		gameInfo = v193,
		screenSize = p42.ScreenSize,
		globalGuiInset = p42.GlobalGuiInset,
		showLoadingBackground = ((if not FFlagLuaAppEdpKeepCachedDetailsOnRefetch then v189 else v192)) ~= RetrievalStatus.Done,
		showRecommendedGames = v101(v190, p42.RecommendedGameEntries[p43.universeId]),
		ageRecommendations = p42.AgeRecommendations[p43.universeId],
		playWithRewardData = if not FFlagEnablePlayWithRewardComponent then nil else PlayWithRewardState,
		isPlayabilitySettledAndPlayable = if not FFlagEnablePlayWithRewardComponent then nil else v188,
		localUserId = if not FFlagEnablePlayWithRewardComponent then nil else p42.LocalUserId
	}
end, function(p44) -- line: 1046
	-- upvalues: FetchGameDetailsPageData (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), FFlagLuaAppEdpBackendV2SduiInterleaveIxp (copy), FFlagLuaAppEdpBackendV2SduiInterleaveDefault (copy), FFlagEnablePlayWithRewardComponent (copy), SetPlayWithRewardState (copy), FetchPlayWithRewardState (copy), AdService (copy), OpenRefundPolicyLearnMorePage (copy), OpenWebview (copy)
	return {
		fetchGameDetailsPageData = function(p45, p46, p47, p48, p49) -- line: 1048
			-- upvalues: p44 (copy), FetchGameDetailsPageData (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), FFlagLuaAppEdpBackendV2SduiInterleaveIxp (copy), FFlagLuaAppEdpBackendV2SduiInterleaveDefault (copy)
			return p44(FetchGameDetailsPageData(p45, p46, nil, if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else p47, if not FFlagLuaAppEdpBackendV2SduiInterleaveIxp then nil else p48, if not FFlagLuaAppEdpBackendV2SduiInterleaveDefault and (not FFlagLuaAppEdpBackendV2SduiInterleaveIxp or not p48) then nil else p49))
		end,
		clearPlayWithReward = if not FFlagEnablePlayWithRewardComponent then nil else function() -- line: 1070
			-- upvalues: p44 (copy), SetPlayWithRewardState (copy)
			return p44(SetPlayWithRewardState("", "", false, nil))
		end,
		fetchPlayWithReward = if not FFlagEnablePlayWithRewardComponent then nil else function(s1: string, n3: number) -- line: 1075
			-- upvalues: p44 (copy), FetchPlayWithRewardState (copy), AdService (copy)
			return p44(FetchPlayWithRewardState(AdService, s1, n3))
		end,
		openRefundPolicyLearnMorePage = function(p50) -- line: 1079
			-- upvalues: p44 (copy), OpenRefundPolicyLearnMorePage (copy)
			return p44(OpenRefundPolicyLearnMorePage(p50))
		end,
		openWebview = function(p51, p52) -- line: 1082
			-- upvalues: p44 (copy), OpenWebview (copy)
			return p44(OpenWebview(p51, p52))
		end
	}
end)(v100)
local v103 = RoactServices.connect({
	networking = RoactNetworking,
	eventIngest = AppEventIngestService
})(v102)
local v104 = RoactAppPolicy.connect(function(p53, _) -- line: 1093
	return {
		enableRecommendedGames = p53.getRecommendedGames(),
		enableSocial = p53.getSocialLinks(),
		enableGameInfoList = p53.getGameInfoList(),
		enableGamePlaysAndRatings = p53.getGamePlaysAndRatings(),
		showGlobalCounters = p53.getShowGlobalCounters(),
		showLikesFavoritesCount = p53.getEnableAggregateLikesFavoritesCount(),
		enableGamePassPreview = p53.getShowPassesOnExperienceDetails(),
		webViewSupport = p53.getWebViewSupport(),
		notificationsCanAccessExperience = p53.getNotificationsCanReceiveExperience(),
		experienceDetailsNoticeType = p53.getExperienceDetailsNoticeType()
	}
end)(v103)

if FFlagLuaAppEdpBackendV2SduiInterleaveDefault or FFlagLuaAppEdpBackendV2SduiInterleaveIxp then
	local v105 = v104

	function v104(p55) -- line: 1110
		-- upvalues: FFlagLuaAppEdpBackendV2SduiInterleaveDefault (copy), FFlagLuaAppEdpBackendV2SduiInterleaveIxp (copy), ServerDrivenUi (copy), EdpSduiUtils (copy), t2 (copy), ApiFetchExperienceDetailsPageCounters (copy), React (copy), SignalsReact (copy), useEdpServerIxpVariables (copy), FFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable (copy), useEdpPerUniverseVisibilityVariablesForUniverse (copy), Roact (copy), v105 (copy), Cryo (copy)
		local v199 = nil
		local v200 = nil
		local v201 = nil
		local v202 = nil

		if FFlagLuaAppEdpBackendV2SduiInterleaveDefault or FFlagLuaAppEdpBackendV2SduiInterleaveIxp then
			local v203 = ServerDrivenUi.useSduiContextFromSignalAndProcessConfigs(EdpSduiUtils.getUnprocessedEdpStoreKey((tostring(p55.universeId))), EdpSduiUtils.getEdpStoreKey((tostring(p55.universeId))), FFlagLuaAppEdpBackendV2SduiInterleaveDefault or FFlagLuaAppEdpBackendV2SduiInterleaveIxp and p55.shouldInterleaveSduiIxp)

			v199 = ServerDrivenUi.useSduiEdpFeedItemConfigs({
				sduiContext = v203,
				storeKey = EdpSduiUtils.getEdpStoreKey((tostring(p55.universeId))),
				portraitLayoutConfig = t2,
				landscapeLayoutConfig = t2,
				defaultLayoutOrder = t2.SduiFeedItemsDefault,
				logLayoutConflictFn = ApiFetchExperienceDetailsPageCounters.logSduiLayoutOrderConflict,
				shouldInterleaveSdui = FFlagLuaAppEdpBackendV2SduiInterleaveDefault or FFlagLuaAppEdpBackendV2SduiInterleaveIxp and p55.shouldInterleaveSduiIxp
			})

			local v204 = React.useMemo(function() -- line: 1132
				-- upvalues: FFlagLuaAppEdpBackendV2SduiInterleaveDefault (copy), FFlagLuaAppEdpBackendV2SduiInterleaveIxp (copy), p55 (copy), ServerDrivenUi (copy), EdpSduiUtils (copy)
				return function(p56) -- line: 1133
					-- upvalues: FFlagLuaAppEdpBackendV2SduiInterleaveDefault (copy), FFlagLuaAppEdpBackendV2SduiInterleaveIxp (copy), p55 (copy), ServerDrivenUi (copy), EdpSduiUtils (copy)
					if (FFlagLuaAppEdpBackendV2SduiInterleaveDefault or FFlagLuaAppEdpBackendV2SduiInterleaveIxp and p55.shouldInterleaveSduiIxp) and p55.universeId then
						return ServerDrivenUi.getSduiFeedStore(EdpSduiUtils.getEdpStoreKey((tostring(p55.universeId)))).getDataUpdatedTimestamp(p56)
					end

					return nil
				end
			end, {
				p55.universeId,
				p55.shouldInterleaveSduiIxp
			})

			v200 = SignalsReact.useSignalState(v204)
			v201 = useEdpServerIxpVariables()
			v202 = if not FFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable then nil else useEdpPerUniverseVisibilityVariablesForUniverse(p55.universeId)
		end

		return Roact.createElement(v105, Cryo.Dictionary.join(p55, {
			currentSduiDataTimestamp = v200,
			sduiFeedItemConfigs = v199,
			edpServerIxpVariables = v201,
			edpPerUniverseVisibilityVariables = v202
		}))
	end
end

if FFlagSongEdpCarouselIxp or FFlagLuaAppEdpMediaGalleryRedesignIxp or FFlagLuaAppEdpMediaGalleryVideoPreviewIxp then
	v104 = RoactAppExperiment.connectUserLayer({ AppUserLayers.ExperienceDetailsPageExposureLayer }, function(p57, _) -- line: 1169
		-- upvalues: AppUserLayers (copy), FFlagSongEdpCarouselIxp (copy), FFlagLuaAppEdpMediaGalleryRedesignIxp (copy), FFlagLuaAppEdpMediaGalleryVideoPreviewIxp (copy)
		local v207 = p57[AppUserLayers.ExperienceDetailsPageExposureLayer] or {}

		return {
			showSongCarousel = if not FFlagSongEdpCarouselIxp then nil else v207.showSongCarousel,
			mediaGalleryRedesignEnabledIxp = if not FFlagLuaAppEdpMediaGalleryRedesignIxp then nil else v207.MediaGalleryRedesignEnabled,
			mediaGalleryVideoPreviewEnabledIxp = if not FFlagLuaAppEdpMediaGalleryVideoPreviewIxp then nil else v207.MediaGalleryVideoPreviewEnabled
		}
	end, true)(v104)
end

if FFlagLuaAppEdpBackendV2HydrateLegacyIxp or FFlagLuaAppEdpBackendV2SduiInterleaveIxp or FFlagEDPTTITrackingEnabled or FFlagEnablePlayWithRewardComponent then
	local v106 = v104

	function v104(p59) -- line: 1193
		-- upvalues: FFlagEDPTTITrackingEnabled (copy), useFirstMediaCarouselImageUri (copy), useEDPTTITracking (copy), EDPTTIConstants (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), ExperienceDetailsExperimentation (copy), FFlagLuaAppEdpBackendV2SduiInterleaveIxp (copy), FFlagEnablePlayWithRewardComponent (copy), useRoactService (copy), RoactNetworking (copy), usePlayButtonState (copy), React (copy), IXPService (copy), AppUserLayers (copy), Roact (copy), v106 (copy), Cryo (copy)
		if FFlagEDPTTITrackingEnabled then
			local v209 = useFirstMediaCarouselImageUri(p59.universeId)

			useEDPTTITracking(EDPTTIConstants.EDP_IMPLEMENTATION.LEGACY_PEEK_VIEW, p59.universeId, v209)
		end

		local v210 = if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else ExperienceDetailsExperimentation.getShouldHydrateLegacy()
		local v211 = if not FFlagLuaAppEdpBackendV2SduiInterleaveIxp then nil else ExperienceDetailsExperimentation.getShouldInterleaveSdui()
		local playButtonState = nil

		if FFlagEnablePlayWithRewardComponent then
			local v213 = useRoactService(RoactNetworking)

			playButtonState = usePlayButtonState(v213, p59.universeId, nil).playButtonState
		end

		if FFlagLuaAppEdpBackendV2HydrateLegacyIxp or FFlagLuaAppEdpBackendV2SduiInterleaveIxp or FFlagEDPTTITrackingEnabled then
			React.useEffect(function() -- line: 1222
				-- upvalues: IXPService (copy), AppUserLayers (copy)
				IXPService:LogUserLayerExposure(AppUserLayers.ExperienceDetailsPageExposureLayer)
			end, {})
		end

		return Roact.createElement(v106, Cryo.Dictionary.join(p59, {
			shouldHydrateLegacyIxp = if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else v210,
			shouldInterleaveSduiIxp = if not FFlagLuaAppEdpBackendV2SduiInterleaveIxp then nil else v211,
			playButtonState = if not FFlagEnablePlayWithRewardComponent then nil else playButtonState
		}))
	end
end

return v104
