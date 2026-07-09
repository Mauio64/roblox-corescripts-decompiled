local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Dash = require(CorePackages.Packages.Dash)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local Localization = require(CorePackages.Workspace.Packages.Localization)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useLocalization = Localization.Hooks.useLocalization
local RetrievalStatus = require(CorePackages.Workspace.Packages.Http).Enum.RetrievalStatus
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local navigateToBadgesSeeAll = require(CorePackages.Workspace.Packages.Badges).navigateToBadgesSeeAll
local navigateToDevStoreSeeAll = require(CorePackages.Workspace.Packages.DevStore).navigateToDevStoreSeeAll
local useUserExperiment = require(CorePackages.Packages.RoactAppExperiment).useUserExperiment
local VerifiedBadges = require(CorePackages.Workspace.Packages.VerifiedBadges)
local getCommunityUrl = require(CorePackages.Workspace.Packages.CommunityLinks).Utils.getCommunityUrl
local ApiFetchGameDetails = require(CorePackages.Workspace.Packages.GameDetailRodux).GameDetails.ApiFetchGameDetails
local abbreviateCount = require(CorePackages.Workspace.Packages.Localization).abbreviateCount
local clickCommunityLinkEvent = require(CorePackages.Workspace.Packages.CommunityLinks).Analytics.Events.clickCommunityLinkEvent
local EnableCommunityProfilePageIXP = require(CorePackages.Workspace.Packages.ProfilePlatform.EnableCommunityProfilePageIXP)
local useEdpServerIxpVariables = require(script.Parent.useEdpServerIxpVariables)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local AppPage = require(Modules.LuaApp.AppPage)
local safeGet = require(Modules.LuaApp.Common.safeGet)
local UrlBuilder = require(Modules.LuaApp.Http.UrlBuilder)
local useAppPolicy = require(Modules.LuaApp.Hooks.useAppPolicy)
local useLocalTime = require(Modules.LuaApp.Hooks.useLocalTime)
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local AppEventIngestService = require(Modules.LuaApp.Services.AppEventIngestService)
local RoactLocalization = require(Modules.LuaApp.Services.RoactLocalization)
local FetchGameDetailsPageData = require(Modules.LuaApp.Thunks.Games.FetchGameDetailsPageData)

require(Modules.LuaApp.Models.GamesApi.GameSocialLink)

local useExperienceDetailsNavigation = require(script.Parent.Parent.useExperienceDetailsNavigation)
local ExperienceDetailsExperimentation = require(script.Parent.Parent.Parent.ExperienceDetails.ExperienceDetailsExperimentation)
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local GuildedLogoWhiteAsset = require(CorePackages.Workspace.Packages.CommunityLinks).Constants.GuildedLogoWhiteAsset
local ApiFetchExperienceDetailsPage = require(Modules.LuaApp.Thunks.Games.ApiFetchExperienceDetailsPage)
local Constants = require(CorePackages.Workspace.Packages.CommunityLinks).Analytics.Constants
local useGamePasses = require(Modules.LuaApp.Components.ExperienceDetails.Hooks.useGamePasses)
local GetFFlagRemoveVerifiedBadgeReducer = require(Modules.LuaApp.Flags.GetFFlagRemoveVerifiedBadgeReducer)
local GetFFlagGameDetailsSeparateChatFeatureRows = require(Modules.LuaApp.Flags.GetFFlagGameDetailsSeparateChatFeatureRows)
local FStringLuaAppGenreOverride = require(Modules.Personalization.Flags.FStringLuaAppGenreOverride)
local FFlagLuaAppEdpBackendV2HydrateLegacyDefault = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyDefault
local FFlagLuaAppEdpBackendV2HydrateLegacyIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyIxp
local FFlagLuaAppEdpBackendV2SduiInterleaveDefault = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2SduiInterleaveDefault
local FFlagLuaAppEdpBackendV2SduiInterleaveIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2SduiInterleaveIxp
local FFlagLuaAppUpdateContentDescriptorsTranslation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppUpdateContentDescriptorsTranslation
local FFlagLuaAppBadgesSeeAllEnabled = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppBadgesSeeAllEnabled
local FFlagLuaAppDevStoreSeeAllSduiEnabled = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppDevStoreSeeAllSduiEnabled
local v49 = game:DefineFastFlag("LuaAppHideBadgesRowFix", false)
local FFlagLuaAppHideEdpStoreForUnplayable = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppHideEdpStoreForUnplayable
local FFlagEnableBlackbirdPageCloseCallback = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableBlackbirdPageCloseCallback
local FFlagLuaAppGamePassesDataHydrationMigrationEnabled = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppGamePassesDataHydrationMigrationEnabled
local getSubscriptionPurchaseCloseCallback = require(CorePackages.Workspace.Packages.RobloxSubscriptionPurchaseApp).Utils.getSubscriptionPurchaseCloseCallback

return function(s1: string, b1: boolean?, b2: boolean?) -- line: 106
	-- upvalues: FFlagLuaAppBadgesSeeAllEnabled (copy), FFlagLuaAppDevStoreSeeAllSduiEnabled (copy), useNavigation (copy), FFlagLuaAppGamePassesDataHydrationMigrationEnabled (copy), useGamePasses (copy), useSelector (copy), safeGet (copy), GetFFlagRemoveVerifiedBadgeReducer (copy), VerifiedBadges (copy), FFlagLuaAppEdpBackendV2HydrateLegacyDefault (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), ApiFetchExperienceDetailsPage (copy), ApiFetchGameDetails (copy), FFlagLuaAppHideEdpStoreForUnplayable (copy), useDispatch (copy), FFlagLuaAppEdpBackendV2SduiInterleaveDefault (copy), FFlagLuaAppEdpBackendV2SduiInterleaveIxp (copy), useEdpServerIxpVariables (copy), useExperienceDetailsNavigation (copy), EnableCommunityProfilePageIXP (copy), React (copy), useRoactService (copy), RoactNetworking (copy), FetchGameDetailsPageData (copy), AppEventIngestService (copy), useAppPolicy (copy), useLocalization (copy), useUserExperiment (copy), AppUserLayers (copy), GuildedLogoWhiteAsset (copy), getCommunityUrl (copy), clickCommunityLinkEvent (copy), Constants (copy), AppPage (copy), UrlBuilder (copy), FStringLuaAppGenreOverride (copy), useLocalTime (copy), GetFFlagGameDetailsSeparateChatFeatureRows (copy), navigateToDevStoreSeeAll (copy), FFlagEnableBlackbirdPageCloseCallback (copy), getSubscriptionPurchaseCloseCallback (copy), navigateToBadgesSeeAll (copy), v49 (copy), RoactLocalization (copy), ExperienceDetailsExperimentation (copy), abbreviateCount (copy), FFlagLuaAppUpdateContentDescriptorsTranslation (copy), RetrievalStatus (copy), Dash (copy)
	local v57 = if not FFlagLuaAppBadgesSeeAllEnabled and not FFlagLuaAppDevStoreSeeAllSduiEnabled then nil else useNavigation()
	local u58 = nil

	if FFlagLuaAppGamePassesDataHydrationMigrationEnabled then
		local v59 = useGamePasses(s1)

		u58 = not v59 or #v59 > 0
	end

	local v60 = useSelector(function(p1) -- line: 115
		-- upvalues: FFlagLuaAppGamePassesDataHydrationMigrationEnabled (copy), s1 (copy), safeGet (copy), GetFFlagRemoveVerifiedBadgeReducer (copy), VerifiedBadges (copy), FFlagLuaAppEdpBackendV2HydrateLegacyDefault (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), b1 (copy), ApiFetchExperienceDetailsPage (copy), ApiFetchGameDetails (copy), FFlagLuaAppHideEdpStoreForUnplayable (copy)
		local v95 = if not FFlagLuaAppGamePassesDataHydrationMigrationEnabled then p1.GamePasses[s1] else nil
		local v96 = p1.GameBadges[s1]
		local v97 = p1.VoiceChatOptInStatus.isUserOptIn or false
		local v98 = false
		local v99 = false

		if p1.ShowAgeVerificationOverlay[s1] then
			v98 = p1.ShowAgeVerificationOverlay[s1].isUniverseEnabledForVoice
			v99 = p1.ShowAgeVerificationOverlay[s1].isUniverseEnabledForAvatarVideo
		end

		local v100 = safeGet(p1.GameSocialLinks, s1, "groupLink")
		local v101 = if not GetFFlagRemoveVerifiedBadgeReducer() then VerifiedBadges.isCreatorOfGameVerified(p1, {
			universeId = s1,
			shouldUseV2GameDetails = FFlagLuaAppEdpBackendV2HydrateLegacyDefault and true or (FFlagLuaAppEdpBackendV2HydrateLegacyIxp and not not b1 or nil)
		}) else nil
		local v102 = if not FFlagLuaAppEdpBackendV2HydrateLegacyDefault and (not FFlagLuaAppEdpBackendV2HydrateLegacyIxp or not b1) then ApiFetchGameDetails.GetFetchingStatus(p1, s1) else ApiFetchExperienceDetailsPage.GetFetchingStatus(p1, s1)
		local v103 = p1.CommunityLinks.ExperienceCommunityLinks[s1] or nil

		return {
			dataStatus = v102,
			gameDetail = if not FFlagLuaAppEdpBackendV2HydrateLegacyDefault and (not FFlagLuaAppEdpBackendV2HydrateLegacyIxp or not b1) then p1.GameDetails[s1] or {} else p1.GameDetailsV2[s1] or {},
			creatorVerified = v101,
			showPasses = not v95 or #v95 > 0,
			showBadges = not v96 or #v96 > 0,
			userVoiceEnabled = v97,
			experienceVoiceEnabled = v98,
			experienceVideoEnabled = v99,
			groupLink = v100,
			communityLink = v103,
			isLocalUserUnder13 = p1.IsLocalUserUnder13,
			ageRecommendations = p1.AgeRecommendations[s1],
			ageRecommendationHeader = p1.AgeRecommendationHeaders.headerDisplayName,
			isPlayable = if not FFlagLuaAppHideEdpStoreForUnplayable then nil else p1.PlayabilityStatus and (p1.PlayabilityStatus[s1] and p1.PlayabilityStatus[s1].isPlayable)
		}
	end)
	local v61 = useDispatch()
	local u62 = nil

	if FFlagLuaAppEdpBackendV2SduiInterleaveDefault or FFlagLuaAppEdpBackendV2SduiInterleaveIxp then
		u62 = useEdpServerIxpVariables()
	end

	local v63 = useExperienceDetailsNavigation(if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else b1)
	local v64 = if not EnableCommunityProfilePageIXP.FFlagIsSetupEnabled then nil else EnableCommunityProfilePageIXP.useIsFeatureActive({
		isExposureEnabled = false
	})
	local v65 = React.useCallback(function() -- line: 187
		-- upvalues: v63 (copy), s1 (copy), b2 (copy)
		v63.openExperienceGuidelinesExplained(s1, b2)
	end, {
		v61,
		s1,
		v63
	})
	local v66 = useRoactService(RoactNetworking)
	local v67 = React.useCallback(function() -- line: 194
		-- upvalues: v61 (copy), FetchGameDetailsPageData (copy), v66 (copy), s1 (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), b1 (copy)
		v61(FetchGameDetailsPageData(v66, s1, nil, if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else b1))
	end, {
		v61,
		v66,
		s1,
		if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else b1
	})
	local v68 = useRoactService(AppEventIngestService)
	local v69 = useAppPolicy(function(p2) -- line: 214
		return {
			showBadgesRow = p2.getGameInfoShowBadges(),
			showCreatedRow = p2.getGameInfoShowCreated(),
			showDeveloperRow = p2.getGameInfoListDeveloper(),
			showRNVDeveloper = p2.getGameInfoListShowRNVDeveloper(),
			showGamepassesRow = p2.getGameInfoShowGamepasses(),
			showGenreRow = p2.getGameInfoShowGenre(),
			showSubgenreRow = p2.getGameInfoShowSubgenre(),
			showMaxPlayersRow = p2.getGameInfoShowMaxPlayers(),
			showServersRow = p2.getGameInfoShowServers(),
			showUpdatedRow = p2.getGameInfoShowUpdated(),
			enableGroupLinks = p2.getSocialGroupLinks(),
			webViewSupport = p2.getWebViewSupport(),
			showAgeRecommendationRow = p2.getGameInfoShowAgeRecommendation()
		}
	end)
	local v70 = useLocalization({
		yes = "Feature.GameDetails.Label.Yes",
		no = "Feature.GameDetails.Label.No",
		none = "Feature.GameDetails.Label.None",
		unavailable = "Feature.GameDetails.Label.Unavailable",
		contentMaturity = "Feature.GameDetails.Label.ContentMaturity",
		developer = "Feature.GameDetails.Label.Developer",
		maxPlayers = "Feature.GameDetails.Label.MaxPlayers",
		genre = "Feature.GameDetails.Label.Genre",
		created = "Feature.GameDetails.Label.Created",
		updated = "Feature.GameDetails.Label.Updated",
		voiceEnabled = "Feature.GameDetails.Label.VoiceEnabled",
		microphone = "Feature.GameDetails.Label.Microphone",
		camera = "Feature.GameDetails.Label.Camera",
		voiceChat = "Feature.GameDetails.Label.VoiceChat",
		supported = "Feature.GameDetails.Label.Supported",
		notSupported = "Feature.GameDetails.Label.NotSupported",
		chatFeatures = "Feature.GameDetails.Label.ChatFeatures",
		communication = "Feature.AccountSettings.Heading.Communication",
		passesAndGear = "Feature.GameDetails.Label.Store",
		badges = "CommonUI.Features.Label.Badges",
		servers = "Feature.GameDetails.Label.Servers",
		group = "Feature.GameDetails.Label.Group",
		community = "Feature.GameDetails.Label.Community",
		subgenre = "Feature.GameDetails.Label.Subgenre",
		age = "Feature.GameDetails.Label.Age",
		visits = if not FFlagLuaAppEdpBackendV2SduiInterleaveDefault and not FFlagLuaAppEdpBackendV2SduiInterleaveIxp then nil else "Feature.GameDetails.Label.Visits",
		strongLanguage = if not FFlagLuaAppEdpBackendV2SduiInterleaveDefault and not FFlagLuaAppEdpBackendV2SduiInterleaveIxp then nil else "Feature.AgeGuidelines.DisplayName.StrongLanguage",
		creatorEnabled = if not FFlagLuaAppEdpBackendV2SduiInterleaveDefault and not FFlagLuaAppEdpBackendV2SduiInterleaveIxp then nil else "Feature.AgeGuidelines.Label.CreatorEnabled"
	})
	local v71 = useLocalization({
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
	})
	local v72 = useUserExperiment({ AppUserLayers.EDPCommunityLinksLayer }, function(p3) -- line: 291
		-- upvalues: AppUserLayers (copy)
		return (p3[AppUserLayers.EDPCommunityLinksLayer] or {}).communityLinkDisplayConfig or {}
	end, false)
	local v73 = React.useMemo(function() -- line: 299
		-- upvalues: v72 (copy), v60 (copy), v70 (copy), GuildedLogoWhiteAsset (copy), getCommunityUrl (copy), clickCommunityLinkEvent (copy), v68 (copy), Constants (copy), s1 (copy)
		local inTreatment = v72.inTreatment
		local linkVariant = v72.linkVariant

		if inTreatment and (v60.communityLink and linkVariant == "infolist") then
			return {
				testId = "--community-row-tail",
				infoName = v70.community,
				infoIcon = GuildedLogoWhiteAsset,
				linkUrl = getCommunityUrl(v60.communityLink.communityId),
				linkClickCallback = function() -- line: 308
					-- upvalues: clickCommunityLinkEvent (copy), v68 (copy), Constants (copy), v60 (copy), s1 (copy)
					clickCommunityLinkEvent(v68, Constants.Context.ExperienceInfoList, {
						entityType = "universe",
						guildedServerId = v60.communityLink.communityId,
						entityId = s1
					})
				end
			}
		end
	end, {
		v70.community,
		v60.communityLink
	})
	local v74 = React.useMemo(function() -- line: 332
		-- upvalues: v69 (copy), safeGet (copy), v60 (copy), v70 (copy), v65 (copy), AppPage (copy)
		if v69.showAgeRecommendationRow then
			local v108 = safeGet(v60.ageRecommendations, "summary", "ageRecommendation", "displayName")

			return {
				testId = "--content-maturity-row-tail",
				infoName = if not v60.ageRecommendationHeader then v70.contentMaturity else v60.ageRecommendationHeader,
				infoData = v108 or v70.unavailable,
				navigateOverride = if not v108 then nil else v65,
				analyticsSubPage = if not v108 then nil else AppPage.ExperienceGuidelinesExplained
			}
		end
	end, {
		v69.showAgeRecommendationRow,
		v70.contentMaturity,
		v70.unavailable,
		v60.ageRecommendations,
		v60.ageRecommendationHeader,
		v65
	})
	local v75 = React.useMemo(function() -- line: 358
		-- upvalues: v69 (copy), safeGet (copy), v60 (copy), v70 (copy)
		if v69.showAgeRecommendationRow then
			local v109 = safeGet(v60.ageRecommendations, "summary", "ageRecommendation", "minimumAgeDisplay")

			if v109 and v109 ~= "" then
				return {
					testId = "--age-row-tail",
					infoName = v70.age,
					infoData = v109
				}
			end
		end
	end, {
		v69.showAgeRecommendationRow,
		v70.age,
		v60.ageRecommendations
	})
	local v76 = React.useMemo(function() -- line: 380
		-- upvalues: v60 (copy), v69 (copy), GetFFlagRemoveVerifiedBadgeReducer (copy), EnableCommunityProfilePageIXP (copy), v64 (copy), v70 (copy), s1 (copy), v63 (copy), UrlBuilder (copy)
		local creator = v60.gameDetail.creator

		if creator and (v69.showDeveloperRow or v69.showRNVDeveloper and creator.isRNVAccount) then
			local id = creator.id
			local name = creator.name
			local type = creator.type
			local v114 = if not GetFFlagRemoveVerifiedBadgeReducer() then v60.creatorVerified or false else creator.hasVerifiedBadge or false

			if EnableCommunityProfilePageIXP.FFlagIsSetupEnabled and v64 and type == Enum.CreatorType.Group.Name then
				return {
					analyticsSubPage = "Developer",
					testId = "--developer-row-tail",
					infoName = v70.developer,
					infoData = name,
					infoDataOverride = function(p4) -- line: 397
						-- upvalues: name (copy), id (copy), s1 (copy), v114 (copy)
						return p4(name, id, s1, v114)
					end,
					navigateOverride = function() -- line: 400
						-- upvalues: v63 (copy), id (copy)
						v63.openCommunityProfilePage(id, "ExperienceDetailsPage:Developer")
					end
				}
			end

			if type == Enum.CreatorType.User.Name then
				return {
					analyticsSubPage = "Developer",
					testId = "--developer-row-tail",
					infoName = v70.developer,
					infoData = name,
					infoDataOverride = function(p5) -- line: 414
						-- upvalues: name (copy), id (copy), s1 (copy), v114 (copy)
						return p5(name, id, s1, v114)
					end,
					navigateOverride = function() -- line: 417
						-- upvalues: v63 (copy), id (copy)
						v63.openUserProfilePage(id, "ExperienceDetailsPage:Developer")
					end
				}
			end

			return {
				analyticsSubPage = "Developer",
				testId = "--developer-row-tail",
				infoName = v70.developer,
				infoData = name,
				infoDataOverride = function(p6) -- line: 430
					-- upvalues: name (copy), id (copy), s1 (copy), v114 (copy)
					return p6(name, id, s1, v114)
				end,
				linkPage = if not v69.webViewSupport then nil else UrlBuilder.game.info.creator({
					creatorType = type,
					creatorId = id
				})
			}
		end
	end, {
		v70.developer,
		v69.showDeveloperRow,
		v69.showRNVDeveloper,
		v69.webViewSupport,
		s1,
		v60.gameDetail,
		v60.creatorVerified,
		if not EnableCommunityProfilePageIXP.FFlagIsSetupEnabled then nil else v64
	})
	local v77 = React.useMemo(function() -- line: 460
		-- upvalues: v69 (copy), v70 (copy), v60 (copy)
		if v69.showMaxPlayersRow then
			return {
				testId = "--server-size-row-tail",
				infoName = v70.maxPlayers,
				infoData = tostring(v60.gameDetail.maxPlayers or "--")
			}
		end
	end, {
		v69.showMaxPlayersRow,
		v60.gameDetail
	})
	local v78 = React.useMemo(function() -- line: 477
		-- upvalues: v60 (copy), FStringLuaAppGenreOverride (copy), v70 (copy), v71 (copy), v69 (copy)
		local genre_l1 = nil

		if v60.gameDetail.genre_l1 and v60.gameDetail.genre_l1 ~= "" then
			genre_l1 = v60.gameDetail.genre_l1
		elseif FStringLuaAppGenreOverride == "N/A" then
			genre_l1 = v70.unavailable
		elseif FStringLuaAppGenreOverride == "All" then
			genre_l1 = v71.All
		end

		if v69.showGenreRow then
			local v116 = if not genre_l1 then if not v60.gameDetail.genre then nil else v71[v60.gameDetail.genre] else genre_l1

			return {
				testId = "--genre-row-tail",
				infoName = v70.genre,
				infoData = v116 or "--"
			}
		end
	end, {
		v69.showGenreRow,
		v60.gameDetail
	})
	local v79 = React.useMemo(function() -- line: 506
		-- upvalues: v69 (copy), v60 (copy), v70 (copy)
		if v69.showSubgenreRow and (v60.gameDetail.genre_l2 and v60.gameDetail.genre_l2 ~= "") then
			return {
				testId = "--subgenre-row-tail",
				infoName = v70.subgenre,
				infoData = v60.gameDetail.genre_l2
			}
		end
	end, {
		v69.showSubgenreRow,
		v60.gameDetail
	})
	local v80 = useLocalTime(v60.gameDetail.created)
	local v81 = React.useMemo(function() -- line: 525
		-- upvalues: v69 (copy), v70 (copy), v80 (copy)
		if v69.showCreatedRow then
			return {
				testId = "--created-row-tail",
				infoName = v70.created,
				infoData = v80 or "--"
			}
		end
	end, {
		v69.showCreatedRow,
		v80
	})
	local v82 = useLocalTime(v60.gameDetail.updated)
	local v83 = React.useMemo(function() -- line: 543
		-- upvalues: v69 (copy), v70 (copy), v82 (copy)
		if v69.showUpdatedRow then
			return {
				testId = "--updated-row-tail",
				infoName = v70.updated,
				infoData = v82 or "--"
			}
		end
	end, {
		v69.showUpdatedRow,
		v82
	})
	local v84 = nil
	local v85 = nil
	local v86 = nil

	if GetFFlagGameDetailsSeparateChatFeatureRows() then
		v85 = React.useMemo(function() -- line: 564
			-- upvalues: v70 (copy), v60 (copy)
			local notSupported = v70.notSupported

			if v60.isLocalUserUnder13 then
				return nil
			end

			if v60.experienceVoiceEnabled then
				notSupported = v70.supported
			end

			return {
				testId = "--voice-chat-row-tail",
				infoName = v70.voiceChat,
				infoData = notSupported
			}
		end, {
			v60.experienceVoiceEnabled,
			v60.isLocalUserUnder13
		})
		v86 = React.useMemo(function() -- line: 587
			-- upvalues: v70 (copy), v60 (copy)
			local notSupported = v70.notSupported

			if v60.experienceVideoEnabled then
				notSupported = v70.supported
			end

			return {
				testId = "--camera-row-tail",
				infoName = v70.camera,
				infoData = notSupported
			}
		end, { v60.experienceVideoEnabled })
	else
		v84 = React.useMemo(function() -- line: 606
			-- upvalues: v60 (copy), v70 (copy)
			local t1 = {}

			if v60.experienceVoiceEnabled and not v60.isLocalUserUnder13 then
				table.insert(t1, v70.microphone)
			end

			if v60.experienceVideoEnabled then
				table.insert(t1, v70.camera)
			end

			if #t1 < 1 then
				table.insert(t1, v70.none)
			end

			return {
				testId = "--communication-row-tail",
				infoName = v70.communication,
				infoData = table.concat(t1, ", ")
			}
		end, {
			v60.experienceVoiceEnabled,
			v60.experienceVideoEnabled,
			v60.isLocalUserUnder13
		})
	end

	local v87 = React.useMemo(function() -- line: 633
		-- upvalues: v69 (copy), FFlagLuaAppGamePassesDataHydrationMigrationEnabled (copy), u58 (ref), v60 (copy), FFlagLuaAppHideEdpStoreForUnplayable (copy), FFlagLuaAppDevStoreSeeAllSduiEnabled (copy), v70 (copy), navigateToDevStoreSeeAll (copy), v57 (copy), s1 (copy), UrlBuilder (copy), FFlagEnableBlackbirdPageCloseCallback (copy), getSubscriptionPurchaseCloseCallback (copy)
		local v120 = v69.showGamepassesRow and (((if not FFlagLuaAppGamePassesDataHydrationMigrationEnabled then v60.showPasses else u58)) and (not FFlagLuaAppHideEdpStoreForUnplayable or v60.isPlayable))

		if FFlagLuaAppDevStoreSeeAllSduiEnabled and v120 then
			return {
				analyticsSubPage = "PassesAndGear",
				testId = "--store-row-tail",
				infoName = v70.passesAndGear,
				navigateOverride = function() -- line: 643
					-- upvalues: navigateToDevStoreSeeAll (copy), v57 (copy), s1 (copy)
					navigateToDevStoreSeeAll(v57, s1)
				end
			}
		end

		if v69.webViewSupport and v120 then
			return {
				analyticsSubPage = "PassesAndGear",
				testId = "--store-row-tail",
				infoName = v70.passesAndGear,
				linkPage = UrlBuilder.game.info.store({
					universeId = s1
				}),
				onClose = if not FFlagEnableBlackbirdPageCloseCallback or not getSubscriptionPurchaseCloseCallback then nil else getSubscriptionPurchaseCloseCallback()
			}
		end
	end, {
		s1,
		v69.webViewSupport,
		v69.showGamepassesRow,
		if not FFlagLuaAppGamePassesDataHydrationMigrationEnabled then v60.showPasses else u58,
		if not FFlagLuaAppHideEdpStoreForUnplayable then nil else v60.isPlayable,
		if not FFlagLuaAppGamePassesDataHydrationMigrationEnabled then nil else v70.passesAndGear,
		if not FFlagLuaAppDevStoreSeeAllSduiEnabled then nil else v57
	})
	local v88 = React.useMemo(function() -- line: 678
		-- upvalues: FFlagLuaAppBadgesSeeAllEnabled (copy), v69 (copy), v60 (copy), v70 (copy), navigateToBadgesSeeAll (copy), v57 (copy), s1 (copy), UrlBuilder (copy)
		if FFlagLuaAppBadgesSeeAllEnabled and (v69.showBadgesRow and v60.showBadges) then
			return {
				analyticsSubPage = "Badges",
				testId = "--badges-row-tail",
				infoName = v70.badges,
				navigateOverride = function() -- line: 682
					-- upvalues: navigateToBadgesSeeAll (copy), v57 (copy), s1 (copy)
					navigateToBadgesSeeAll(v57, s1)
				end
			}
		end

		if v69.webViewSupport and v69.showBadgesRow and v60.showBadges then
			return {
				analyticsSubPage = "Badges",
				testId = "--badges-row-tail",
				infoName = v70.badges,
				linkPage = UrlBuilder.game.info.badges({
					universeId = s1
				})
			}
		end
	end, {
		s1,
		v69.webViewSupport,
		v69.showBadgesRow,
		if not FFlagLuaAppGamePassesDataHydrationMigrationEnabled then v60.showPasses else nil,
		v57,
		if not v49 then nil else v60.showBadges,
		if not FFlagLuaAppGamePassesDataHydrationMigrationEnabled then nil else v70.badges
	})
	local v89 = React.useMemo(function() -- line: 712
		-- upvalues: v69 (copy), v70 (copy), UrlBuilder (copy), s1 (copy), FFlagEnableBlackbirdPageCloseCallback (copy), getSubscriptionPurchaseCloseCallback (copy)
		if v69.webViewSupport and v69.showServersRow then
			return {
				analyticsSubPage = "Servers",
				testId = "--servers-row-tail",
				infoName = v70.servers,
				linkPage = UrlBuilder.game.info.servers({
					universeId = s1
				}),
				onClose = if not FFlagEnableBlackbirdPageCloseCallback or not getSubscriptionPurchaseCloseCallback then nil else getSubscriptionPurchaseCloseCallback()
			}
		end
	end, {
		s1,
		v69.webViewSupport,
		v69.showServersRow
	})
	local v90 = React.useMemo(function() -- line: 736
		-- upvalues: EnableCommunityProfilePageIXP (copy), v64 (copy), v69 (copy), v60 (copy), v70 (copy), v63 (copy)
		if EnableCommunityProfilePageIXP.FFlagIsSetupEnabled and v64 then
			if v69.enableGroupLinks and v60.groupLink then
				if v60.groupLink.communityId ~= nil then
					return {
						analyticsSubPage = "Group",
						testId = "--group-row-tail",
						infoName = v70.group,
						navigateOverride = function() -- line: 742
							-- upvalues: v63 (copy), v60 (copy)
							v63.openCommunityProfilePage(v60.groupLink.communityId, "ExperienceDetailsPage:Group")
						end
					}
				end

				if v69.webViewSupport then
					return {
						analyticsSubPage = "Group",
						testId = "--group-row-tail",
						infoName = v70.group,
						linkPage = v60.groupLink.url
					}
				end
			end
		elseif v69.webViewSupport and v69.enableGroupLinks and v60.groupLink then
			return {
				analyticsSubPage = "Group",
				testId = "--group-row-tail",
				infoName = v70.group,
				linkPage = v60.groupLink.url
			}
		end
	end, {
		s1,
		v69.webViewSupport,
		v69.enableGroupLinks,
		v60.groupLink,
		if not EnableCommunityProfilePageIXP.FFlagIsSetupEnabled then nil else v64
	})
	local v91 = nil
	local v92 = nil

	if FFlagLuaAppEdpBackendV2SduiInterleaveDefault or FFlagLuaAppEdpBackendV2SduiInterleaveIxp then
		local Locale = useRoactService(RoactLocalization):GetLocale()

		v92 = React.useMemo(function() -- line: 788
			-- upvalues: FFlagLuaAppEdpBackendV2SduiInterleaveDefault (copy), FFlagLuaAppEdpBackendV2SduiInterleaveIxp (copy), ExperienceDetailsExperimentation (copy), u62 (ref), v60 (copy), abbreviateCount (copy), Locale (copy), v70 (copy)
			if (FFlagLuaAppEdpBackendV2SduiInterleaveDefault or FFlagLuaAppEdpBackendV2SduiInterleaveIxp and ExperienceDetailsExperimentation.getShouldInterleaveSdui()) and (u62 and u62.showVisitsInInfoList == true) then
				local gameDetail = v60.gameDetail
				local v122 = gameDetail and gameDetail.visits or 0
				local v123 = abbreviateCount(v122, Locale) or "--"

				return {
					testId = "--visits-row-tail",
					infoName = v70.visits,
					infoData = v123
				}
			end
		end, {
			u62,
			v60.gameDetail,
			v70.visits,
			Locale
		})
		v91 = React.useMemo(function() -- line: 820
			-- upvalues: FFlagLuaAppEdpBackendV2SduiInterleaveDefault (copy), FFlagLuaAppEdpBackendV2SduiInterleaveIxp (copy), ExperienceDetailsExperimentation (copy), u62 (ref), v60 (copy), FFlagLuaAppUpdateContentDescriptorsTranslation (copy), v70 (copy)
			if (FFlagLuaAppEdpBackendV2SduiInterleaveDefault or FFlagLuaAppEdpBackendV2SduiInterleaveIxp and ExperienceDetailsExperimentation.getShouldInterleaveSdui()) and (u62 and u62.showContentDescriptorsInInfoList == true and v60.ageRecommendations) then
				local descriptorUsages = v60.ageRecommendations.descriptorUsages

				if descriptorUsages and #descriptorUsages > 0 then
					for _, v in ipairs(descriptorUsages) do
						if v.name == "strong-language" and v.contains then
							return {
								testId = "--content-descriptors-row-tail",
								infoName = if not FFlagLuaAppUpdateContentDescriptorsTranslation then v70.communication else v70.creatorEnabled,
								infoData = v70.strongLanguage
							}
						end
					end
				end
			end
		end, {
			u62,
			v60.ageRecommendations,
			v70.contentDescriptors,
			v70.containsStrongLanguage
		})
	end

	React.useEffect(function() -- line: 860
		-- upvalues: v60 (copy), RetrievalStatus (copy), v67 (copy)
		if v60.dataStatus == RetrievalStatus.NotStarted then
			v67()
		end
	end)

	return {
		rootPlaceId = tostring(v60.gameDetail.rootPlaceId),
		rows = Dash.append({ v73 }, if not FFlagLuaAppEdpBackendV2SduiInterleaveDefault and (not FFlagLuaAppEdpBackendV2SduiInterleaveIxp or not ExperienceDetailsExperimentation.getShouldInterleaveSdui()) or (not u62 or (u62.showVisitsInInfoList ~= true or not v92)) then nil else { v92 }, { v74 }, { v75 }, if not FFlagLuaAppEdpBackendV2SduiInterleaveDefault and (not FFlagLuaAppEdpBackendV2SduiInterleaveIxp or not ExperienceDetailsExperimentation.getShouldInterleaveSdui()) or (not u62 or (u62.showContentDescriptorsInInfoList ~= true or not v91)) then nil else { v91 }, { v76 }, { v77 }, { v78 }, { v79 }, { v81 }, { v83 }, if GetFFlagGameDetailsSeparateChatFeatureRows() then nil else { v84 }, if not GetFFlagGameDetailsSeparateChatFeatureRows() then nil else { v85 }, if not GetFFlagGameDetailsSeparateChatFeatureRows() then nil else { v86 }, { v87 }, { v88 }, { v89 }, { v90 })
	}, v60.dataStatus, v67
end
