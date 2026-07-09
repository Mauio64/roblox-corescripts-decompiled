local CorePackages = game:GetService("CorePackages")
local IXPService = game:GetService("IXPService")
local FFlagUseNavigationSelectors = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUseNavigationSelectors
local FFlagSignalsNavP3fGameDetails = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3fGameDetails
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local v6 = if not FFlagSignalsNavP3fGameDetails then nil else require(CorePackages.Workspace.Packages.NavigationRodux).GetLegacyNavigationStore
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(Modules.Common.Roact)
local RoactLocalization = require(Modules.LuaApp.Services.RoactLocalization)
local RoactRodux = require(Modules.Common.RoactRodux)
local memoize = require(Modules.Common.memoize)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local AppEventIngestService = require(Modules.LuaApp.Services.AppEventIngestService)
local Cryo = require(CorePackages.Packages.Cryo)
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local ImpressionsTagUtility = require(CorePackages.Workspace.Packages.Impressions).ImpressionsTagUtility
local Selectors = require(CorePackages.Workspace.Packages.NavigationRodux).Selectors
local AppPage = require(Modules.LuaApp.AppPage)
local ApiFetchGamePasses = require(Modules.LuaApp.Thunks.Games.ApiFetchGamePasses)
local OpenCentralOverlayForLeaveRobloxAlert = require(Modules.LuaApp.Thunks.OpenCentralOverlayForLeaveRobloxAlert)
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local GameInfoRow = require(Modules.LuaApp.Components.GameDetails.GameInfoRow)
local PassesGrid = require(Modules.LuaApp.Components.Passes.PassesGrid)
local EdpSocialLinksImpressionsDetector = require(Modules.LuaApp.Components.ExperienceDetails.EdpSocialLinksImpressionsDetector)
local CommunityLinks = require(CorePackages.Workspace.Packages.CommunityLinks)
local ExperienceCommunityLink = CommunityLinks.Components.ExperienceCommunityLink
local getCommunityUrl = CommunityLinks.Utils.getCommunityUrl
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local AppLinking = require(CorePackages.Workspace.Packages.RoactServiceTags).AppLinking
local UrlBuilder = require(Modules.LuaApp.Http.UrlBuilder)
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local SocialMediaGroup = require(Modules.LuaApp.Components.GameDetails.SocialMediaGroup)
local VerifiedBadges = require(CorePackages.Workspace.Packages.VerifiedBadges)
local GuildedLogoWhiteAsset = require(CorePackages.Workspace.Packages.CommunityLinks).Constants.GuildedLogoWhiteAsset
local Constants = require(CorePackages.Workspace.Packages.CommunityLinks).Analytics.Constants
local clickCommunityLinkEvent = require(CorePackages.Workspace.Packages.CommunityLinks).Analytics.Events.clickCommunityLinkEvent
local ExperienceDetailsExperimentation = require(Modules.LuaApp.Components.ExperienceDetails.ExperienceDetailsExperimentation)
local GetFFlagGameDetailsSeparateChatFeatureRows = require(Modules.LuaApp.Flags.GetFFlagGameDetailsSeparateChatFeatureRows)
local GetFFlagLuaAppFixExperienceInfoShowServersPolicy = require(Modules.LuaApp.Flags.GetFFlagLuaAppFixExperienceInfoShowServersPolicy)
local FStringLuaAppGenreOverride = require(Modules.Personalization.Flags.FStringLuaAppGenreOverride)
local EnableCommunityProfilePageIXP = require(CorePackages.Workspace.Packages.ProfilePlatform.EnableCommunityProfilePageIXP)
local FFlagLuaAppUseExperienceLogoTrayInGameInfoList = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppUseExperienceLogoTrayInGameInfoList
local FFlagLuaAppEdpBackendV2HydrateLegacyDefault = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyDefault
local FFlagLuaAppEdpBackendV2HydrateLegacyIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyIxp
local ExperienceLogoTray = require(Modules.LuaApp.Components.ExperienceDetails.ExperienceLogoTray)
local FFlagLuaAppUpdateContentDescriptorsTranslation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppUpdateContentDescriptorsTranslation
local EdpStoreAnalytics = require(CorePackages.Workspace.Packages.EdpStoreAnalytics)
local Constants2 = EdpStoreAnalytics.Constants
local EdpStoreImpressionsDetector = EdpStoreAnalytics.EdpStoreImpressionsDetector
local GetFFlagEnableEdpStoreClickLogging = require(Modules.LuaApp.Flags.GetFFlagEnableEdpStoreClickLogging)
local abbreviateCount = require(CorePackages.Workspace.Packages.Localization).abbreviateCount
local FFlagLuaAppEdpBackendV2SduiInterleaveDefault = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2SduiInterleaveDefault
local FFlagLuaAppEdpBackendV2SduiInterleaveIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2SduiInterleaveIxp
local useEdpServerIxpVariables = require(Modules.LuaApp.Components.ExperienceDetails.Hooks.useEdpServerIxpVariables)
local GetFFlagEnableEdpStoreGridPositionLogging = require(Modules.LuaApp.Flags.GetFFlagEnableEdpStoreGridPositionLogging)
local FFlagLuaAppBadgesSeeAllEnabled = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppBadgesSeeAllEnabled
local FFlagLuaAppAddSocialLinkImpressionsTelemetryToEdp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppAddSocialLinkImpressionsTelemetryToEdp
local FFlagLuaAppAddSocialLinkClickTelemetryToEdp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppAddSocialLinkClickTelemetryToEdp
local FFlagLuaAppHideEdpStoreForUnplayable = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppHideEdpStoreForUnplayable
local FFlagEnableBlackbirdPageCloseCallback = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableBlackbirdPageCloseCallback
local getSubscriptionPurchaseCloseCallback = require(CorePackages.Workspace.Packages.RobloxSubscriptionPurchaseApp).Utils.getSubscriptionPurchaseCloseCallback
local FFlagLuaAppGamePassesDataHydrationMigrationEnabled = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppGamePassesDataHydrationMigrationEnabled
local DataHydration = require(CorePackages.Workspace.Packages.DataHydration)
local useGamePasses = require(Modules.LuaApp.Components.ExperienceDetails.Hooks.useGamePasses)
local v70 = Roact.PureComponent:extend("GameInfoList")
local t1 = {
	All = "Feature.GameDetails.Label.GenreAll",
	Adventure = "Feature.GameDetails.Label.GenreAdventure",
	Building = "Feature.GameDetails.Label.GenreBuilding",
	Comedy = "Feature.GameDetails.Label.GenreComedy",
	Fighting = "Feature.GameDetails.Label.GenreFighting",
	FPS = "Feature.GameDetails.Label.GenreFPS",
	Horror = "Feature.GameDetails.Label.LabelGenreHorror",
	Medieval = "Feature.GameDetails.Label.GenreMedieval",
	Military = "Feature.GameDetails.Label.GenreMilitary",
	Naval = "Feature.GameDetails.Label.GenreNaval",
	RPG = "Feature.GameDetails.Label.GenreRPG",
	["Sci-Fi"] = "Feature.GameDetails.Label.GenreSciFi",
	Sports = "Feature.GameDetails.Label.LabelGenreSports",
	["Town and City"] = "Feature.GameDetails.Label.LabelGenreTownAndCity",
	Western = "Feature.GameDetails.Label.GenreWestern"
}

v70.defaultProps = {
	leftPadding = 0,
	rightPadding = 0
}

function v70.init(p1) -- line: 136
	-- upvalues: Roact (copy), AppCommonLib (copy), EdpStoreImpressionsDetector (copy), Constants2 (copy), ImpressionsTagUtility (copy), GameInfoRow (copy), GetFFlagEnableEdpStoreGridPositionLogging (copy), PassesGrid (copy), GetFFlagEnableEdpStoreClickLogging (copy), IXPService (copy), AppUserLayers (copy)
	function p1.createGamePassPreviewRow(p2, p3, p4, p5) -- line: 137
		-- upvalues: p1 (copy), Roact (copy), AppCommonLib (copy), EdpStoreImpressionsDetector (copy), Constants2 (copy), ImpressionsTagUtility (copy), GameInfoRow (copy), GetFFlagEnableEdpStoreGridPositionLogging (copy), PassesGrid (copy), GetFFlagEnableEdpStoreClickLogging (copy)
		local v205 = p1.props.gameDetail and p1.props.gameDetail.rootPlaceId
		local passes = p1.props.passes

		if not passes or not v205 then
			return
		end

		local leftPadding = p1.props.leftPadding
		local rightPadding = p1.props.rightPadding
		local width = p1.props.width
		local v210 = Roact.createRef()
		local v211 = Roact.createRef()

		v211.current = AppCommonLib.Signal.new()

		local v212 = Roact.createElement(EdpStoreImpressionsDetector, {
			parentRef = v210,
			scrollViewPositionChangedSignal = v211,
			impressionsTag = Constants2.ImpressionsTags.Preview,
			parameters = {
				universeId = p2,
				productType = Constants2.StoreEnums.ProductType.GamePasses,
				locationType = Constants2.StoreEnums.LocationType.Edp
			}
		})

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0),
			LayoutOrder = p3
		}, {
			UIListLayout = Roact.createElement("UIListLayout", {
				Padding = UDim.new(0, 10),
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical
			}),
			PassesAndGears = Roact.createElement(GameInfoRow, {
				LayoutOrder = 1,
				topPadding = 10,
				bottomPadding = 10,
				Size = UDim2.new(1, 0, 0, 57),
				useVerifiedBadgeEmojiWrapper = p4.useVerifiedBadgeEmojiWrapper,
				viewWidth = if not GetFFlagEnableEdpStoreGridPositionLogging() then nil else width,
				placeId = v205,
				infoName = p4.infoName,
				infoData = p4.infoData,
				linkPage = p4.linkPage,
				linkView = p4.linkView,
				universeId = p2,
				leftPadding = leftPadding,
				rightPadding = rightPadding,
				analyticsSubPage = p4.analyticsSubPage,
				testId = p4.testId
			}),
			GamePassPreview = Roact.createElement("Frame", {
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, 0),
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				[Roact.Ref] = function(p6) -- line: 168
					-- upvalues: v210 (copy), ImpressionsTagUtility (copy), Constants2 (copy), p3 (copy)
					v210.current = p6
					ImpressionsTagUtility.AddTag(v210, Constants2.ImpressionsTags.Preview, p3)
				end,
				[Roact.Change.AbsolutePosition] = function(_) -- line: 153
					-- upvalues: v211 (copy)
					v211.current:fire()
				end
			}, {
				Layout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center
				}),
				Padding = Roact.createElement("UIPadding", {
					PaddingBottom = UDim.new(0, 20),
					PaddingLeft = UDim.new(0, leftPadding),
					PaddingRight = UDim.new(0, rightPadding)
				}),
				Grid = Roact.createElement(PassesGrid, {
					numRows = 1,
					universeId = p2,
					passes = passes,
					viewWidth = width,
					textSizeOffset = p5,
					locationType = if not GetFFlagEnableEdpStoreClickLogging() then nil else Constants2.StoreEnums.LocationType.Edp
				})
			}),
			ImpressionsDetecter = v212
		})
	end
	function p1.checkCommunityLinkExposureLogging() -- line: 240
		-- upvalues: p1 (copy), IXPService (copy), AppUserLayers (copy)
		if p1.props.communityLink then
			IXPService:LogUserLayerExposure(AppUserLayers.EDPCommunityLinksLayer)
		end
	end
end
function v70.makeGameInfoListData(p8) -- line: 248
	-- upvalues: GetFFlagLuaAppFixExperienceInfoShowServersPolicy (copy), FFlagLuaAppHideEdpStoreForUnplayable (copy), AppPage (copy), GuildedLogoWhiteAsset (copy), getCommunityUrl (copy), clickCommunityLinkEvent (copy), Constants (copy), FFlagLuaAppEdpBackendV2SduiInterleaveDefault (copy), FFlagLuaAppEdpBackendV2SduiInterleaveIxp (copy), ExperienceDetailsExperimentation (copy), abbreviateCount (copy), FFlagLuaAppUpdateContentDescriptorsTranslation (copy), EnableCommunityProfilePageIXP (copy), UrlBuilder (copy), FStringLuaAppGenreOverride (copy), t1 (copy), GetFFlagGameDetailsSeparateChatFeatureRows (copy), FFlagLuaAppBadgesSeeAllEnabled (copy), FFlagEnableBlackbirdPageCloseCallback (copy), getSubscriptionPurchaseCloseCallback (copy)
	local localization = p8.props.localization
	local universeId = p8.props.universeId
	local maxPlayers = p8.props.gameDetail.maxPlayers
	local creator = p8.props.gameDetail.creator
	local id = p8.props.gameDetail.creator.id
	local type = p8.props.gameDetail.creator.type
	local name = p8.props.gameDetail.creator.name
	local creatorVerified = p8.props.creatorVerified
	local genre = p8.props.gameDetail.genre
	local genre_l1 = p8.props.gameDetail.genre_l1
	local genre_l2 = p8.props.gameDetail.genre_l2
	local dateTime = DateTime.fromIsoDate(p8.props.gameDetail.created)
	local dateTime2 = DateTime.fromIsoDate(p8.props.gameDetail.updated)
	local showPasses = p8.props.showPasses
	local showSubscriptionProducts = p8.props.showSubscriptionProducts
	local showDeveloperProducts = p8.props.showDeveloperProducts
	local showBadges = p8.props.showBadges
	local groupLink = p8.props.groupLink
	local v98 = nil
	local v99 = nil

	if p8.props.ageRecommendations then
		local summary = p8.props.ageRecommendations.summary

		v98 = if not summary or not summary.ageRecommendation then nil else summary.ageRecommendation.displayName
		v99 = if not summary or not summary.ageRecommendation then nil else summary.ageRecommendation.minimumAgeDisplay
	end

	local enableGroupLinks = p8.props.enableGroupLinks
	local showBadgesRow = p8.props.showBadgesRow
	local showCreatedRow = p8.props.showCreatedRow
	local showDeveloperRow = p8.props.showDeveloperRow
	local showRNVDeveloper = p8.props.showRNVDeveloper
	local showGamepassesRow = p8.props.showGamepassesRow
	local showGenreRow = p8.props.showGenreRow
	local showSubgenreRow = p8.props.showSubgenreRow
	local showMaxPlayersRow = p8.props.showMaxPlayersRow
	local v110 = if not GetFFlagLuaAppFixExperienceInfoShowServersPolicy() then p8.props.showGamepassesRow else p8.props.showServersRow
	local showUpdatedRow = p8.props.showUpdatedRow
	local experienceVoiceEnabled = p8.props.experienceVoiceEnabled
	local experienceVideoEnabled = p8.props.experienceVideoEnabled
	local enableGamePassPreview = p8.props.enableGamePassPreview

	if showBadgesRow == false then
		showBadges = false
	end

	if showGamepassesRow == false then
		showPasses = false
		showSubscriptionProducts = false
		showDeveloperProducts = false
	end

	p8.gameInfoListData = {}

	local Locale = localization:GetLocale()
	local v116 = dateTime:FormatLocalTime("l", Locale)
	local v117 = dateTime2:FormatLocalTime("l", Locale)

	if showPasses and enableGamePassPreview and (not FFlagLuaAppHideEdpStoreForUnplayable or p8.props.isPlayable) then
		table.insert(p8.gameInfoListData, {
			renderFunction = p8.createGamePassPreviewRow,
			itemInfo = {
				infoName = "Feature.GameDetails.Label.Store",
				infoData = "",
				analyticsSubPage = "PassesAndGear",
				testId = "--store-row-tail",
				linkView = AppPage.PassesPage
			}
		})
	end

	local communityLink = p8.props.communityLink
	local communityLinksEnabled = p8.props.communityLinksEnabled
	local communityLinkVariant = p8.props.communityLinkVariant

	if communityLinksEnabled and communityLinkVariant == "infolist" and communityLink then
		table.insert(p8.gameInfoListData, {
			infoName = "Feature.GameDetails.Label.Community",
			infoData = "",
			testId = "--community-row-tail",
			infoIcon = GuildedLogoWhiteAsset,
			linkUrl = getCommunityUrl(communityLink.communityId),
			linkClickCallback = function() -- line: 339
				-- upvalues: clickCommunityLinkEvent (copy), p8 (copy), Constants (copy), communityLink (copy), universeId (copy)
				clickCommunityLinkEvent(p8.props.eventIngest, Constants.Context.ExperienceInfoList, {
					entityType = "universe",
					guildedServerId = communityLink.communityId,
					entityId = universeId
				})
			end
		})
	end

	local edpServerIxpVariables = p8.props.edpServerIxpVariables

	if (FFlagLuaAppEdpBackendV2SduiInterleaveDefault or FFlagLuaAppEdpBackendV2SduiInterleaveIxp and ExperienceDetailsExperimentation.getShouldInterleaveSdui()) and (edpServerIxpVariables and edpServerIxpVariables.showVisitsInInfoList == true) then
		local v122 = p8.props.gameDetail and p8.props.gameDetail.visits or 0

		table.insert(p8.gameInfoListData, {
			infoName = "Feature.GameDetails.Label.Visits",
			testId = "--visits-row-tail",
			infoData = abbreviateCount(v122, Locale) or "--"
		})
	end

	table.insert(p8.gameInfoListData, {
		testId = "--content-maturity-row-tail",
		infoName = not p8.props.ageRecommendationHeader and "Feature.GameDetails.Label.ContentMaturity" or p8.props.ageRecommendationHeader,
		infoData = v98 or localization:Format("Feature.GameDetails.Label.Unavailable"),
		linkView = if not v98 then nil else AppPage.ExperienceGuidelinesExplained,
		analyticsSubPage = AppPage.ExperienceGuidelinesExplained,
		disableInfoNameLocalization = p8.props.ageRecommendationHeader ~= nil
	})

	if v99 and v99 ~= "" then
		table.insert(p8.gameInfoListData, {
			infoName = "Feature.GameDetails.Label.Age",
			testId = "--age-row-tail",
			infoData = v99
		})
	end

	if (FFlagLuaAppEdpBackendV2SduiInterleaveDefault or FFlagLuaAppEdpBackendV2SduiInterleaveIxp and ExperienceDetailsExperimentation.getShouldInterleaveSdui()) and (edpServerIxpVariables and edpServerIxpVariables.showContentDescriptorsInInfoList == true and p8.props.ageRecommendations and p8.props.ageRecommendations.descriptorUsages and #p8.props.ageRecommendations.descriptorUsages > 0) then
		for _, v in ipairs(p8.props.ageRecommendations.descriptorUsages) do
			if v.name == "strong-language" and v.contains then
				table.insert(p8.gameInfoListData, {
					testId = "--content-descriptors-row-tail",
					infoName = not FFlagLuaAppUpdateContentDescriptorsTranslation and "Feature.AccountSettings.Heading.Communication" or "Feature.AgeGuidelines.Label.CreatorEnabled",
					infoData = localization:Format("Feature.AgeGuidelines.DisplayName.StrongLanguage")
				})

				break
			end
		end
	end

	if showDeveloperRow or showRNVDeveloper and creator.isRNVAccount then
		if EnableCommunityProfilePageIXP.FFlagIsSetupEnabled and p8.props.communityProfilePageEnabled and type == Enum.CreatorType.Group.Name then
			table.insert(p8.gameInfoListData, {
				infoName = "Feature.GameDetails.Label.Developer",
				linkView = "CommunityProfilePlatform",
				analyticsSubPage = "Developer",
				testId = "--developer-row-tail",
				infoData = name,
				linkViewData = id,
				useVerifiedBadgeEmojiWrapper = creatorVerified
			})
		elseif type == Enum.CreatorType.User.Name then
			table.insert(p8.gameInfoListData, {
				infoName = "Feature.GameDetails.Label.Developer",
				linkView = "UserProfilePlatform",
				analyticsSubPage = "Developer",
				testId = "--developer-row-tail",
				infoData = name,
				linkViewData = id,
				useVerifiedBadgeEmojiWrapper = creatorVerified
			})
		else
			table.insert(p8.gameInfoListData, {
				infoName = "Feature.GameDetails.Label.Developer",
				analyticsSubPage = "Developer",
				testId = "--developer-row-tail",
				infoData = name,
				linkPage = UrlBuilder.game.info.creator({
					creatorType = type,
					creatorId = id
				}),
				useVerifiedBadgeEmojiWrapper = creatorVerified
			})
		end
	end

	if showMaxPlayersRow then
		table.insert(p8.gameInfoListData, {
			infoName = "Feature.GameDetails.Label.MaxPlayers",
			testId = "--server-size-row-tail",
			infoData = tostring(maxPlayers)
		})
	end

	local v125 = nil

	if genre_l1 and genre_l1 ~= "" then
		v125 = genre_l1
	elseif FStringLuaAppGenreOverride == "N/A" then
		v125 = localization:Format("Feature.GameDetails.Label.Unavailable")
	elseif FStringLuaAppGenreOverride == "All" then
		v125 = localization:Format("Feature.GameDetails.Label.GenreAll")
	end

	local v126 = t1[genre]

	if v125 then
		genre = v125
	elseif v126 ~= nil then
		genre = localization:Format(v126)
	end

	if showGenreRow then
		table.insert(p8.gameInfoListData, {
			infoName = "Feature.GameDetails.Label.Genre",
			testId = "--genre-row-tail",
			infoData = genre
		})
	end

	if showSubgenreRow and genre_l2 and genre_l2 ~= "" then
		table.insert(p8.gameInfoListData, {
			infoName = "Feature.GameDetails.Label.Subgenre",
			testId = "--subgenre-row-tail",
			infoData = genre_l2
		})
	end

	if showCreatedRow then
		table.insert(p8.gameInfoListData, {
			infoName = "Feature.GameDetails.Label.Created",
			testId = "--created-row-tail",
			infoData = v116
		})
	end

	if showUpdatedRow then
		table.insert(p8.gameInfoListData, {
			infoName = "Feature.GameDetails.Label.Updated",
			testId = "--updated-row-tail",
			infoData = v117
		})
	end

	if GetFFlagGameDetailsSeparateChatFeatureRows() then
		local v127 = localization:Format("Feature.GameDetails.Label.NotSupported")
		local v128 = localization:Format("Feature.GameDetails.Label.NotSupported")

		if experienceVideoEnabled then
			v128 = localization:Format("Feature.GameDetails.Label.Supported")
		end

		if experienceVoiceEnabled then
			v127 = localization:Format("Feature.GameDetails.Label.Supported")
		end

		if not p8.props.isLocalUserUnder13 then
			table.insert(p8.gameInfoListData, {
				infoName = "Feature.GameDetails.Label.VoiceChat",
				testId = "--voice-chat-row-tail",
				infoData = v127
			})
		end

		table.insert(p8.gameInfoListData, {
			infoName = "Feature.GameDetails.Label.Camera",
			testId = "--camera-row-tail",
			infoData = v128
		})
	else
		local t2 = {}

		if experienceVoiceEnabled and not p8.props.isLocalUserUnder13 then
			table.insert(t2, localization:Format("Feature.GameDetails.Label.Microphone"))
		end

		if experienceVideoEnabled then
			table.insert(t2, localization:Format("Feature.GameDetails.Label.Camera"))
		end

		if #t2 < 1 then
			table.insert(t2, localization:Format("Feature.GameDetails.Label.None"))
		end

		table.insert(p8.gameInfoListData, {
			infoName = "Feature.AccountSettings.Heading.Communication",
			testId = "--communication-row-tail",
			infoData = table.concat(t2, ", ")
		})
	end

	if not enableGamePassPreview and (showPasses or showSubscriptionProducts or showDeveloperProducts) and (not FFlagLuaAppHideEdpStoreForUnplayable or p8.props.isPlayable) then
		table.insert(p8.gameInfoListData, {
			infoName = "Feature.GameDetails.Label.Store",
			infoData = "",
			analyticsSubPage = "PassesAndGear",
			testId = "--store-row-tail",
			linkView = AppPage.PassesPage
		})
	end

	if showBadges then
		table.insert(p8.gameInfoListData, {
			infoName = "CommonUI.Features.Label.Badges",
			infoData = "",
			analyticsSubPage = "Badges",
			testId = "--badges-row-tail",
			linkPage = if not FFlagLuaAppBadgesSeeAllEnabled then UrlBuilder.game.info.badges({
				universeId = universeId
			}) else nil,
			linkView = if not FFlagLuaAppBadgesSeeAllEnabled then nil else AppPage.BadgesSeeAll
		})
	end

	if v110 then
		table.insert(p8.gameInfoListData, {
			infoName = "Feature.GameDetails.Label.Servers",
			infoData = "",
			analyticsSubPage = "Servers",
			testId = "--servers-row-tail",
			linkPage = UrlBuilder.game.info.servers({
				universeId = universeId
			}),
			onClose = if not FFlagEnableBlackbirdPageCloseCallback or not getSubscriptionPurchaseCloseCallback then nil else getSubscriptionPurchaseCloseCallback()
		})
	end

	if groupLink and enableGroupLinks then
		if EnableCommunityProfilePageIXP.FFlagIsSetupEnabled and p8.props.communityProfilePageEnabled and groupLink.communityId ~= nil then
			table.insert(p8.gameInfoListData, {
				infoName = "Feature.GameDetails.Label.Group",
				infoData = "",
				linkView = "CommunityProfilePlatform",
				analyticsSubPage = "Group",
				testId = "--group-row-tail",
				linkViewData = groupLink.communityId
			})

			return
		end

		table.insert(p8.gameInfoListData, {
			infoName = "Feature.GameDetails.Label.Group",
			infoData = "",
			analyticsSubPage = "Group",
			testId = "--group-row-tail",
			linkPage = groupLink.url
		})
	end
end
function v70.createSocialMediaRow(p9, p10, p11) -- line: 628
	-- upvalues: FFlagLuaAppAddSocialLinkImpressionsTelemetryToEdp (copy), Roact (copy), AppCommonLib (copy), EdpSocialLinksImpressionsDetector (copy), AppPage (copy), FFlagLuaAppUseExperienceLogoTrayInGameInfoList (copy), ExperienceLogoTray (copy), FFlagLuaAppAddSocialLinkClickTelemetryToEdp (copy), SocialMediaGroup (copy)
	local v133 = if not FFlagLuaAppAddSocialLinkImpressionsTelemetryToEdp then nil else `EXPERIENCE_SOCIAL_LINKS_{ p10 }`
	local v134 = if not FFlagLuaAppAddSocialLinkImpressionsTelemetryToEdp then nil else Roact.createRef()
	local v135 = if not FFlagLuaAppAddSocialLinkImpressionsTelemetryToEdp then nil else AppCommonLib.Signal.new()
	local v136 = if not FFlagLuaAppAddSocialLinkImpressionsTelemetryToEdp then nil else function(_) -- line: 644
		-- upvalues: v135 (copy)
		v135:fire()
	end
	local leftPadding = p9.props.leftPadding
	local rightPadding = p9.props.rightPadding

	return Roact.createElement("Frame", {
		LayoutOrder = p11,
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.Y,
		[Roact.Ref] = if not FFlagLuaAppAddSocialLinkImpressionsTelemetryToEdp then nil else v134,
		[Roact.Change.AbsolutePosition] = if not FFlagLuaAppAddSocialLinkImpressionsTelemetryToEdp then nil else v136
	}, {
		ListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Padding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, leftPadding),
			PaddingRight = UDim.new(0, rightPadding),
			PaddingTop = UDim.new(0, 10),
			PaddingBottom = UDim.new(0, 10)
		}),
		EdpSocialLinksImpressionsDetector = if not FFlagLuaAppAddSocialLinkImpressionsTelemetryToEdp then nil else Roact.createElement(EdpSocialLinksImpressionsDetector, {
			parentRef = v134,
			scrollViewPositionChangedSignal = v135,
			pageContext = AppPage.GameDetail,
			impressionsTag = v133,
			socialLinks = if not p9.props.socialLinks then nil else p9.props.socialLinks.externalLinks,
			universeId = p10
		}),
		SocialLinks = if not FFlagLuaAppUseExperienceLogoTrayInGameInfoList then Roact.createElement(SocialMediaGroup, {
			universeId = p10,
			impressionsTag = if not FFlagLuaAppAddSocialLinkImpressionsTelemetryToEdp then nil else v133
		}) else if not p9.props.socialLinks or not p9.props.socialLinks.externalLinks then nil else Roact.createElement(ExperienceLogoTray, {
			socialLinks = p9.props.socialLinks.externalLinks,
			linking = p9.props.linking,
			openLeaveRobloxAlertUIBlox = p9.props.openLeaveRobloxAlertUIBlox,
			closeAlert = p9.props.closeAlert,
			impressionsTag = if not FFlagLuaAppAddSocialLinkImpressionsTelemetryToEdp then nil else v133,
			universeId = if not FFlagLuaAppAddSocialLinkClickTelemetryToEdp then nil else p9.props.universeId
		})
	})
end
function v70.createCommunityRow(p13, p14) -- line: 701
	-- upvalues: Roact (copy), ExperienceCommunityLink (copy)
	local leftPadding = p13.props.leftPadding
	local rightPadding = p13.props.rightPadding

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = p14,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		Padding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, leftPadding),
			PaddingRight = UDim.new(0, rightPadding),
			PaddingTop = UDim.new(0, 30),
			PaddingBottom = UDim.new(0, 10)
		}),
		ExperienceCommunityLink = Roact.createElement(ExperienceCommunityLink, {
			communityInfo = p13.props.communityLink,
			experienceName = p13.props.gameDetail.name,
			universeId = p13.props.universeId
		})
	})
end
function v70.render(p15) -- line: 726
	-- upvalues: Roact (copy), withStyle (copy), GameInfoRow (copy), EnableCommunityProfilePageIXP (copy), FFlagEnableBlackbirdPageCloseCallback (copy)
	local textSizeOffset = p15.props.textSizeOffset

	p15:makeGameInfoListData()

	local rootPlaceId = p15.props.gameDetail.rootPlaceId
	local universeId = p15.props.universeId
	local showSocial = p15.props.showSocial
	local propsLayoutOrder = p15.props.LayoutOrder
	local leftPadding = p15.props.leftPadding
	local rightPadding = p15.props.rightPadding
	local t3 = {
		Layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Right
		})
	}

	return withStyle(function(p16) -- line: 745
		-- upvalues: p15 (copy), t3 (copy), universeId (copy), textSizeOffset (copy), Roact (copy), GameInfoRow (copy), rootPlaceId (copy), EnableCommunityProfilePageIXP (copy), leftPadding (copy), rightPadding (copy), FFlagEnableBlackbirdPageCloseCallback (copy), showSocial (copy), propsLayoutOrder (copy)
		local DividerColor = p16.Theme.Divider.Color
		local DividerTransparency = p16.Theme.Divider.Transparency
		local n1 = 0
		local v218 = #p15.gameInfoListData

		for i, v in ipairs(p15.gameInfoListData) do
			local renderFunction = v.renderFunction
			local v222 = n1 + 1

			if renderFunction then
				t3["GameInfoRow" .. i] = renderFunction(universeId, v222, v.itemInfo, textSizeOffset)
			else
				t3["GameInfoRow" .. i] = Roact.createElement(GameInfoRow, {
					topPadding = 10,
					bottomPadding = 10,
					Size = UDim2.new(1, 0, 0, 57),
					useVerifiedBadgeEmojiWrapper = v.useVerifiedBadgeEmojiWrapper,
					LayoutOrder = v222,
					placeId = rootPlaceId,
					infoName = v.infoName,
					infoData = v.infoData,
					infoIcon = v.infoIcon,
					linkPage = v.linkPage,
					linkView = v.linkView,
					linkViewData = if not EnableCommunityProfilePageIXP.FFlagIsSetupEnabled then nil else v.linkViewData,
					linkUrl = v.linkUrl,
					linkClickCallback = v.linkClickCallback,
					universeId = universeId,
					leftPadding = leftPadding,
					rightPadding = rightPadding,
					analyticsSubPage = v.analyticsSubPage,
					disableInfoNameLocalization = v.disableInfoNameLocalization,
					testId = v.testId,
					onClose = if not FFlagEnableBlackbirdPageCloseCallback then nil else v.onClose
				})
			end

			n1 = v222 + 1
			t3["Divider" .. i] = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				Size = UDim2.new(1, -leftPadding, 0, 1),
				BackgroundColor3 = DividerColor,
				BackgroundTransparency = DividerTransparency,
				LayoutOrder = n1
			})
		end

		local communityLinksEnabled = p15.props.communityLinksEnabled
		local communityLinkVariant = p15.props.communityLinkVariant

		if communityLinksEnabled and communityLinkVariant == "banner" then
			local v225 = p15.props.communityLink and p15:createCommunityRow(n1 + 1) or nil

			if v225 ~= nil then
				v218 += 1
				n1 += 1
				t3["GameInfoRow" .. v218] = v225
			end
		end

		local v226 = n1 + 1
		local v227 = showSocial and p15:createSocialMediaRow(universeId, v226) or nil

		if v227 ~= nil then
			t3["GameInfoRow" .. v218 + 1] = v227
		end

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ClipsDescendants = false,
			Size = UDim2.new(1, leftPadding + rightPadding, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = propsLayoutOrder
		}, t3)
	end)
end
function v70.didMount(p17) -- line: 823
	p17.checkCommunityLinkExposureLogging()
end
function v70.didUpdate(p18, p19, _) -- line: 827
	-- upvalues: AppPage (copy), FFlagLuaAppGamePassesDataHydrationMigrationEnabled (copy), DataHydration (copy)
	local topPage = p18.props.topPage
	local topPage2 = p19.topPage

	if topPage.name ~= topPage2.name and (topPage2.name == AppPage.GenericWebPage and ((if not topPage2.extraProps then nil else topPage2.extraProps.passOwned)) == false) then
		if FFlagLuaAppGamePassesDataHydrationMigrationEnabled then
			DataHydration.Game.getGamePassStore(false).fetchPassesForUniverse(p18.props.universeId)
		else
			p18.props.fetchGamePasses(p18.props.networking, p18.props.universeId)
		end
	end

	if not p19.communityLink then
		p18.checkCommunityLinkExposureLogging()
	end
end

local v72 = memoize(function(p21) -- line: 848
	local t4 = {}

	if not p21 then
		return t4
	end

	for _, v in ipairs(p21) do
		if v.price ~= nil then
			table.insert(t4, v)
		end
	end

	return t4
end)

local function getTopPageInfo(p22) -- line: 864
	-- upvalues: FFlagUseNavigationSelectors (copy), Selectors (copy)
	local v163 = if not FFlagUseNavigationSelectors then p22.Navigation.history else Selectors.selectLegacyHistory(p22)
	local v164 = v163[#v163]

	return v164[#v164]
end

local v74 = RoactRodux.connect(function(p23, p24) -- line: 873
	-- upvalues: v72 (copy), VerifiedBadges (copy), FFlagLuaAppEdpBackendV2HydrateLegacyDefault (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), FFlagLuaAppGamePassesDataHydrationMigrationEnabled (copy), FFlagSignalsNavP3fGameDetails (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), FFlagLuaAppAddSocialLinkImpressionsTelemetryToEdp (copy), FFlagLuaAppUseExperienceLogoTrayInGameInfoList (copy), FFlagLuaAppHideEdpStoreForUnplayable (copy)
	local v167 = p23.GamePasses and v72(p23.GamePasses[p24.universeId])
	local v168 = p23.GameSubscriptionProducts[p24.universeId]
	local v169 = p23.GameDeveloperProducts[p24.universeId]
	local v170 = p23.GameBadges[p24.universeId]
	local v171 = true
	local v172 = v168 and #v168 > 0
	local v173 = v169 and #v169 > 0
	local v174 = true
	local v175 = p23.GameSocialLinks[p24.universeId]
	local v176 = v175 and v175.groupLink
	local v177 = false
	local v178 = VerifiedBadges.isCreatorOfGameVerified(p23, if not FFlagLuaAppEdpBackendV2HydrateLegacyDefault and (not FFlagLuaAppEdpBackendV2HydrateLegacyIxp or not p24.shouldHydrateLegacyIxp) then p24 else {
		shouldUseV2GameDetails = true,
		universeId = p24.universeId
	})
	local v179 = p23.CommunityLinks.ExperienceCommunityLinks[p24.universeId] or nil

	if v167 and #v167 == 0 then
		v171 = false
	end

	if v170 and #v170 == 0 then
		v174 = false
	end

	local v180 = p23.VoiceChatOptInStatus.isUserOptIn or false
	local v181 = false

	if p23.ShowAgeVerificationOverlay[p24.universeId] ~= nil then
		v177 = p23.ShowAgeVerificationOverlay[p24.universeId].isUniverseEnabledForVoice or false
		v181 = p23.ShowAgeVerificationOverlay[p24.universeId].isUniverseEnabledForAvatarVideo or false
	end

	local t5 = {
		gameDetail = if not FFlagLuaAppEdpBackendV2HydrateLegacyDefault and (not FFlagLuaAppEdpBackendV2HydrateLegacyIxp or not p24.shouldHydrateLegacyIxp) then p23.GameDetails[p24.universeId] else p23.GameDetailsV2[p24.universeId],
		creatorVerified = v178,
		showPasses = if not FFlagLuaAppGamePassesDataHydrationMigrationEnabled then v171 else nil,
		passes = if not FFlagLuaAppGamePassesDataHydrationMigrationEnabled then v167 else nil,
		showSubscriptionProducts = v172,
		showDeveloperProducts = v173,
		showBadges = v174,
		groupLink = v176,
		communityLink = v179,
		userVoiceEnabled = v180,
		experienceVoiceEnabled = v177,
		experienceVideoEnabled = v181,
		isLocalUserUnder13 = p23.IsLocalUserUnder13
	}
	local v183

	if FFlagSignalsNavP3fGameDetails then
		v183 = nil
	else
		local v184 = if not FFlagUseNavigationSelectors then p23.Navigation.history else Selectors.selectLegacyHistory(p23)
		local v185 = v184[#v184]

		v183 = v185[#v185]
	end

	t5.topPage = v183
	t5.ageRecommendationHeader = p23.AgeRecommendationHeaders.headerDisplayName
	t5.socialLinks = if not FFlagLuaAppAddSocialLinkImpressionsTelemetryToEdp and not FFlagLuaAppUseExperienceLogoTrayInGameInfoList then nil else v175
	t5.isPlayable = if not FFlagLuaAppHideEdpStoreForUnplayable then nil else p23.PlayabilityStatus and (p23.PlayabilityStatus[p24.universeId] and p23.PlayabilityStatus[p24.universeId].isPlayable)

	return t5
end, function(p25) -- line: 943
	-- upvalues: FFlagLuaAppGamePassesDataHydrationMigrationEnabled (copy), ApiFetchGamePasses (copy), FFlagLuaAppUseExperienceLogoTrayInGameInfoList (copy), OpenCentralOverlayForLeaveRobloxAlert (copy), CloseCentralOverlay (copy)
	return {
		fetchGamePasses = not FFlagLuaAppGamePassesDataHydrationMigrationEnabled and function(p26, p27) -- line: 947
			-- upvalues: p25 (copy), ApiFetchGamePasses (copy)
			return p25(ApiFetchGamePasses(p26, p27))
		end or nil,
		openLeaveRobloxAlertUIBlox = if not FFlagLuaAppUseExperienceLogoTrayInGameInfoList then nil else function(p28) -- line: 951
			-- upvalues: p25 (copy), OpenCentralOverlayForLeaveRobloxAlert (copy)
			p25(OpenCentralOverlayForLeaveRobloxAlert(p28))
		end,
		closeAlert = if not FFlagLuaAppUseExperienceLogoTrayInGameInfoList then nil else function() -- line: 956
			-- upvalues: p25 (copy), CloseCentralOverlay (copy)
			p25(CloseCentralOverlay())
		end
	}
end)(v70)
local v75 = RoactAppExperiment.connectUserLayer({
	AppUserLayers.EDPCommunityLinksLayer,
	EnableCommunityProfilePageIXP.EnableCommunityProfilePageExperimentLayer
}, function(p29) -- line: 966
	-- upvalues: AppUserLayers (copy), EnableCommunityProfilePageIXP (copy)
	local v188 = (p29[AppUserLayers.EDPCommunityLinksLayer] or {}).communityLinkDisplayConfig or {}
	local v189 = if not EnableCommunityProfilePageIXP.FFlagIsSetupEnabled then nil else EnableCommunityProfilePageIXP.isFeatureActive(p29)

	return {
		communityLinksEnabled = v188.inTreatment,
		communityLinkVariant = v188.linkVariant,
		communityProfilePageEnabled = if not EnableCommunityProfilePageIXP.FFlagIsSetupEnabled then nil else v189
	}
end, false)(v74)
local v76 = RoactAppPolicy.connect(function(p30, _) -- line: 982
	return {
		enableGroupLinks = p30.getSocialGroupLinks(),
		showBadgesRow = p30.getGameInfoShowBadges(),
		showCreatedRow = p30.getGameInfoShowCreated(),
		showDeveloperRow = p30.getGameInfoListDeveloper(),
		showRNVDeveloper = p30.getGameInfoListShowRNVDeveloper(),
		showGamepassesRow = p30.getGameInfoShowGamepasses(),
		showGenreRow = p30.getGameInfoShowGenre(),
		showSubgenreRow = p30.getGameInfoShowSubgenre(),
		showMaxPlayersRow = p30.getGameInfoShowMaxPlayers(),
		showServersRow = p30.getGameInfoShowServers(),
		showUpdatedRow = p30.getGameInfoShowUpdated()
	}
end)(v75)
local u77 = RoactServices.connect({
	localization = RoactLocalization,
	networking = RoactNetworking,
	eventIngest = AppEventIngestService,
	linking = if not FFlagLuaAppUseExperienceLogoTrayInGameInfoList then nil else AppLinking
})(v76)

return function(p32) -- line: 1005
	-- upvalues: useTextSizeOffset (copy), FFlagLuaAppEdpBackendV2SduiInterleaveDefault (copy), FFlagLuaAppEdpBackendV2SduiInterleaveIxp (copy), useEdpServerIxpVariables (copy), FFlagLuaAppGamePassesDataHydrationMigrationEnabled (copy), useGamePasses (copy), v72 (copy), FFlagSignalsNavP3fGameDetails (copy), v6 (copy), useSignalState (copy), Cryo (copy), ExperienceDetailsExperimentation (copy), Roact (copy), u77 (ref)
	local v193 = useTextSizeOffset()
	local v194 = nil

	if FFlagLuaAppEdpBackendV2SduiInterleaveDefault or FFlagLuaAppEdpBackendV2SduiInterleaveIxp then
		v194 = useEdpServerIxpVariables()
	end

	local v195 = nil
	local v196 = nil

	if FFlagLuaAppGamePassesDataHydrationMigrationEnabled then
		local v197 = useGamePasses(p32.universeId)

		v195 = if not v197 then nil else v72(v197)
		v196 = v195 == nil or #v195 > 0
	end

	local v198 = nil

	if FFlagSignalsNavP3fGameDetails then
		local v199 = v6(false)

		v198 = useSignalState(v199.getCurrentPage)
	end

	local v200 = Cryo.Dictionary.join(p32, {
		textSizeOffset = v193,
		edpServerIxpVariables = if not FFlagLuaAppEdpBackendV2SduiInterleaveDefault and (not FFlagLuaAppEdpBackendV2SduiInterleaveIxp or not ExperienceDetailsExperimentation.getShouldInterleaveSdui()) then nil else v194,
		passes = if not FFlagLuaAppGamePassesDataHydrationMigrationEnabled then nil else v195,
		showPasses = if not FFlagLuaAppGamePassesDataHydrationMigrationEnabled then nil else v196,
		topPage = if not FFlagSignalsNavP3fGameDetails then nil else v198
	})

	return Roact.createElement(u77, v200)
end
