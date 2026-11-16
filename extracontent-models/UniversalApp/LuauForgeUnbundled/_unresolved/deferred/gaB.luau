local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Dash = require(CorePackages.Packages.Dash)
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local Localization = require("@game/CorePackages/Workspace/Packages/Localization")
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useLocalization = Localization.Hooks.useLocalization
local retrievalStatus = require("@game/CorePackages/Workspace/Packages/Http").Enum.RetrievalStatus

local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local navigateToBadgesSeeAll = require("@luauforge/deferred/fXm").navigateToBadgesSeeAll

local navigateToDevStoreSeeAll = require("@luauforge/bundled/fXn").navigateToDevStoreSeeAll

local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local useUserExperiment = RoactAppExperiment.useUserExperiment

local VerifiedBadges = require("@game/CorePackages/Workspace/Packages/_Workspace/ItemDetails/VerifiedBadges")
local getCommunityUrl = require("@luauforge/bundled/dBe").Utils.getCommunityUrl
local apiFetchGameDetails = require("@luauforge/bundled/dyi").GameDetails.ApiFetchGameDetails
local abbreviateCount = require("@game/CorePackages/Workspace/Packages/Localization").abbreviateCount

local clickCommunityLinkEvent = require("@luauforge/bundled/dBe").Analytics.Events.clickCommunityLinkEvent

local module4 = require("@luauforge/bundled/fWW")
local module5 = require("@luauforge/deferred/fXe")

local module6 = require("@luauforge/bundled/dCp")
local module7 = require("@luauforge/deferred/gaC")
local module8 = require("@luauforge/bundled/fsq")
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppPolicy")
local module10 = require("@luauforge/deferred/gaD")
local module11 = require("@luauforge/bundled/eeH")
local module12 = require("@luauforge/bundled/eda")
local module13 = require("@luauforge/bundled/dYU")
local module14 = require("@luauforge/bundled/edB")
local module15 = require("@luauforge/deferred/fYy")
require("@luauforge/deferred/fWU")
local module16 = require("@luauforge/deferred/fYm")

local module17 = require("@luauforge/deferred/fXb")
local appUserLayers = require("@luauforge/bundled/dMA").AppUserLayers
local guildedLogoWhiteAsset = require("@luauforge/bundled/dBe").Constants.GuildedLogoWhiteAsset
local module18 = require("@luauforge/deferred/fWL")
local constants = require("@luauforge/bundled/dBe").Analytics.Constants
local module19 = require("@luauforge/deferred/fYa")

local module20 = require("@luauforge/deferred/gau")

local module21 = require("@luauforge/deferred/fXV")
local module22 = require("@luauforge/deferred/fXX")

local fFlagLuaAppEdpBackendV2HydrateLegacyDefault = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2HydrateLegacyDefault

local fFlagLuaAppEdpBackendV2HydrateLegacyIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2HydrateLegacyIxp

local fFlagLuaAppEdpBackendV2SduiInterleaveDefault = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2SduiInterleaveDefault

local fFlagLuaAppEdpBackendV2SduiInterleaveIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2SduiInterleaveIxp

local fFlagLuaAppUpdateContentDescriptorsTranslation = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppUpdateContentDescriptorsTranslation

local fFlagLuaAppBadgesSeeAllEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppBadgesSeeAllEnabled

local fFlagLuaAppDevStoreSeeAllSduiEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppDevStoreSeeAllSduiEnabled

local fFlagLuaAppHideEdpStoreForUnplayable = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppHideEdpStoreForUnplayable

local fFlagLuaAppEdpNonSduiBuildAttribution = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpNonSduiBuildAttribution
local module23 = require("@luauforge/deferred/fYb")

local fFlagEnableBlackbirdPageCloseCallback = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableBlackbirdPageCloseCallback

local fFlagLuaAppGamePassesDataHydrationMigrationEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppGamePassesDataHydrationMigrationEnabled

local fFlagUseSignalsForIsLocalUserUnder13 = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForIsLocalUserUnder13
local getIsLocalUserUnder13Store

if fFlagUseSignalsForIsLocalUserUnder13 then
	getIsLocalUserUnder13Store = require("@luauforge/bundled/cgr").Stores.GetIsLocalUserUnder13Store
else
	getIsLocalUserUnder13Store = nil
end

local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local getSubscriptionPurchaseCloseCallback = require("@luauforge/bundled/fzr").Utils.getSubscriptionPurchaseCloseCallback

return function(p2, p3, p4)
	local v5

	if fFlagLuaAppBadgesSeeAllEnabled or fFlagLuaAppDevStoreSeeAllSduiEnabled then
		v5 = useNavigation()
	else
		v5 = nil
	end

	local v6

	if fFlagLuaAppGamePassesDataHydrationMigrationEnabled then
		local v7 = module19(p2)
		v6 = not v7 or #v7 > 0
	else
		v6 = nil
	end

	local v7 = useSelector(function(data)
		local v8

		if not fFlagLuaAppGamePassesDataHydrationMigrationEnabled then
			v8 = data.GamePasses[p2]
		end

		local gameBadge = data.GameBadges[p2]

		local isUserOptIn = data.VoiceChatOptInStatus.isUserOptIn or false
		local v9, v10

		if data.ShowAgeVerificationOverlay[p2] then
			v9 = data.ShowAgeVerificationOverlay[p2].isUniverseEnabledForVoice
			v10 = data.ShowAgeVerificationOverlay[p2].isUniverseEnabledForAvatarVideo
		else
			v9 = false
			v10 = false
		end

		local v11 = module7(data.GameSocialLinks, p2, "groupLink")
		local v12

		if not module20() then
			v12 = VerifiedBadges.isCreatorOfGameVerified(data, {
				universeId = p2,
				shouldUseV2GameDetails = (fFlagLuaAppEdpBackendV2HydrateLegacyDefault or fFlagLuaAppEdpBackendV2HydrateLegacyIxp and p3) and true or nil
			})
		end

		local v13

		if
			fFlagLuaAppEdpBackendV2HydrateLegacyDefault
			or fFlagLuaAppEdpBackendV2HydrateLegacyIxp and p3
		then
			v13 = module18.GetFetchingStatus(data, p2)
		else
			v13 = apiFetchGameDetails.GetFetchingStatus(data, p2)
		end

		local v14 = data.CommunityLinks.ExperienceCommunityLinks[p2] or nil

		local v16 = if fFlagLuaAppEdpBackendV2HydrateLegacyDefault or fFlagLuaAppEdpBackendV2HydrateLegacyIxp and p3 then data.GameDetailsV2[p2] or {} else data.GameDetails[p2] or {}
		local v15 = {
			dataStatus = v13,
			gameDetail = v16,
			creatorVerified = v12,
			showPasses = not v8 or #v8 > 0,
			showBadges = not gameBadge or #gameBadge > 0,
			userVoiceEnabled = isUserOptIn,
			experienceVoiceEnabled = v9,
			experienceVideoEnabled = v10,
			groupLink = v11,
			communityLink = v14,
			isLocalUserUnder13 = 0,
			ageRecommendations = 0,
			ageRecommendationHeader = 0,
			isPlayable = 0
		}

		local v17 = if not fFlagUseSignalsForIsLocalUserUnder13 then data.IsLocalUserUnder13 else nil
		v15.isLocalUserUnder13 = v17
		v15.ageRecommendations = data.AgeRecommendations[p2]
		v15.ageRecommendationHeader = data.AgeRecommendationHeaders.headerDisplayName

		local v18 = if fFlagLuaAppHideEdpStoreForUnplayable then data.PlayabilityStatus and data.PlayabilityStatus[p2] and data.PlayabilityStatus[p2].isPlayable else nil
		v15.isPlayable = v18
		return v15
	end)
	local v8

	if fFlagUseSignalsForIsLocalUserUnder13 then
		v8 = useSignalState(getIsLocalUserUnder13Store(false).getIsLocalUserUnder13)
	else
		v8 = v7.isLocalUserUnder13
	end

	local v9 = useDispatch()
	local v10

	if fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp then
		v10 = module5()
	else
		v10 = nil
	end

	local v12 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then p3 else nil
	local v13 = module16(v12)
	local v14

	if module4.FFlagIsSetupEnabled then
		v14 = module4.useIsFeatureActive({ isExposureEnabled = false })
	else
		v14 = nil
	end

	local v15 = React.useCallback(function()
		v13.openExperienceGuidelinesExplained(p2, p4)
	end, { v9, p2, v13 })

	local v16 = module11(module12)

	local function fn()
		v9(module15(v16, p2, nil, if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then p3 else nil))
	end

	local v19 = React.useCallback(fn, {
		v9,
		v16,
		p2,
		if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then p3 else nil
	})

	local v20 = module11(module13)

	local v21 = useAppPolicy(function(data)
		return {
			showBadgesRow = data.getGameInfoShowBadges(),
			showCreatedRow = data.getGameInfoShowCreated(),
			showDeveloperRow = data.getGameInfoListDeveloper(),
			showRNVDeveloper = data.getGameInfoListShowRNVDeveloper(),
			showGamepassesRow = data.getGameInfoShowGamepasses(),
			showGenreRow = data.getGameInfoShowGenre(),
			showSubgenreRow = data.getGameInfoShowSubgenre(),
			showMaxPlayersRow = data.getGameInfoShowMaxPlayers(),
			showServersRow = data.getGameInfoShowServers(),
			showUpdatedRow = data.getGameInfoShowUpdated(),
			enableGroupLinks = data.getSocialGroupLinks(),
			webViewSupport = data.getWebViewSupport(),
			showAgeRecommendationRow = data.getGameInfoShowAgeRecommendation()
		}
	end)

	local v22 = useLocalization({
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
		visits = (fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp) and "Feature.GameDetails.Label.Visits" or nil,
		strongLanguage = (fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp) and "Feature.AgeGuidelines.DisplayName.StrongLanguage" or nil,
		creatorEnabled = (fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp) and "Feature.AgeGuidelines.Label.CreatorEnabled" or nil
	})

	local v23 = useLocalization({
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

	local v24 = useUserExperiment({ appUserLayers.EDPCommunityLinksLayer }, function(p5)
		return (p5[appUserLayers.EDPCommunityLinksLayer] or {}).communityLinkDisplayConfig or {}
	end, false)

	local v25 = React.useMemo(function()
		local inTreatment = v24.inTreatment
		local linkVariant = v24.linkVariant

		if inTreatment and v7.communityLink and linkVariant == "infolist" then
			return {
				infoName = v22.community,
				infoIcon = guildedLogoWhiteAsset,
				linkUrl = getCommunityUrl(v7.communityLink.communityId),
				linkClickCallback = function()
					clickCommunityLinkEvent(v20, constants.Context.ExperienceInfoList, {
						guildedServerId = v7.communityLink.communityId,
						entityType = "universe",
						entityId = p2
					})
				end,
				testId = "--community-row-tail"
			}
		end
	end, { v22.community, v7.communityLink })

	local v26 = React.useMemo(function()
		if not v21.showAgeRecommendationRow then
			return
		end

		local v27 = module7(v7.ageRecommendations, "summary", "ageRecommendation", "displayName")

		local v29 = if v7.ageRecommendationHeader then v7.ageRecommendationHeader else v22.contentMaturity
		local v28 = {
			infoName = v29,
			infoData = v27 or v22.unavailable,
			navigateOverride = if v27 then v15 else nil,
			analyticsSubPage = 0,
			testId = "--content-maturity-row-tail"
		}

		local v31 = if v27 then module6.ExperienceGuidelinesExplained else nil
		v28.analyticsSubPage = v31
		return v28
	end, {
		v21.showAgeRecommendationRow,
		v22.contentMaturity,
		v22.unavailable,
		v7.ageRecommendations,
		v7.ageRecommendationHeader,
		v15
	})

	local v27 = React.useMemo(function()
		if v21.showAgeRecommendationRow then
			local v28 = module7(v7.ageRecommendations, "summary", "ageRecommendation", "minimumAgeDisplay")

			if v28 and v28 ~= "" then
				return { infoName = v22.age, infoData = v28, testId = "--age-row-tail" }
			end
		end
	end, { v21.showAgeRecommendationRow, v22.age, v7.ageRecommendations })

	local useMemo = React.useMemo
	local function fn2()
		local creator = v7.gameDetail.creator

		if not (creator and (v21.showDeveloperRow or v21.showRNVDeveloper and creator.isRNVAccount)) then
			return
		end

		local id = creator.id
		local name = creator.name
		local kind = creator.type
		local v28 = if module20() then creator.hasVerifiedBadge or false else v7.creatorVerified or false

		if module4.FFlagIsSetupEnabled and v14 and kind == Enum.CreatorType.Group.Name then
			return {
				infoName = v22.developer,
				infoData = name,
				infoDataOverride = function(callback)
					return callback(name, id, p2, v28)
				end,
				navigateOverride = function()
					v13.openCommunityProfilePage(id, "ExperienceDetailsPage:Developer")
				end,
				analyticsSubPage = "Developer",
				testId = "--developer-row-tail"
			}
		end

		if kind == Enum.CreatorType.User.Name then
			return {
				infoName = v22.developer,
				infoData = name,
				infoDataOverride = function(callback)
					return callback(name, id, p2, v28)
				end,
				navigateOverride = function()
					v13.openUserProfilePage(id, "ExperienceDetailsPage:Developer")
				end,
				analyticsSubPage = "Developer",
				testId = "--developer-row-tail"
			}
		end

		local v29 = {
			infoName = v22.developer,
			infoData = name,
			infoDataOverride = function(callback)
				return callback(name, id, p2, v28)
			end,
			linkPage = 0,
			analyticsSubPage = "Developer",
			testId = "--developer-row-tail"
		}

		local v30 = if v21.webViewSupport then module8.game.info.creator({
			creatorType = kind,
			creatorId = id
		}) else nil
		v29.linkPage = v30
		return v29
	end

	local developer = v22.developer
	local showDeveloperRow = v21.showDeveloperRow
	local showRNVDeveloper = v21.showRNVDeveloper
	local webViewSupport = v21.webViewSupport

	local gameDetail = v7.gameDetail
	local creatorVerified = v7.creatorVerified
	local v29 = if module4.FFlagIsSetupEnabled then v14 else nil
	local v30 = useMemo(fn2, {
		developer,
		showDeveloperRow,
		showRNVDeveloper,
		webViewSupport,
		p2,
		gameDetail,
		creatorVerified,
		v29
	})

	local v31 = React.useMemo(function()
		if v21.showMaxPlayersRow then
			return {
				infoName = v22.maxPlayers,
				infoData = tostring(v7.gameDetail.maxPlayers or "--"),
				testId = "--server-size-row-tail"
			}
		end
	end, { v21.showMaxPlayersRow, v7.gameDetail })

	local v32 = React.useMemo(function()
		local v33 = nil

		if v7.gameDetail.genre_l1 and v7.gameDetail.genre_l1 ~= "" then
			v33 = v7.gameDetail.genre_l1
		elseif module22 == "N/A" then
			v33 = v22.unavailable
		elseif module22 == "All" then
			v33 = v23.All
		end

		if not v21.showGenreRow then
			return
		end

		if not v33 then
			v33 = if v7.gameDetail.genre then v23[v7.gameDetail.genre] else nil
		end

		return {
			infoName = v22.genre,
			infoData = v33 or "--",
			testId = "--genre-row-tail"
		}
	end, { v21.showGenreRow, v7.gameDetail })

	local v33 = React.useMemo(function()
		if v21.showSubgenreRow and v7.gameDetail.genre_l2 and v7.gameDetail.genre_l2 ~= "" then
			return {
				infoName = v22.subgenre,
				infoData = v7.gameDetail.genre_l2,
				testId = "--subgenre-row-tail"
			}
		end
	end, { v21.showSubgenreRow, v7.gameDetail })

	local v34 = module10(v7.gameDetail.created)
	local v35 = React.useMemo(function()
		if v21.showCreatedRow then
			return {
				infoName = v22.created,
				infoData = v34 or "--",
				testId = "--created-row-tail"
			}
		end
	end, { v21.showCreatedRow, v34 })

	local v36 = module10(v7.gameDetail.updated)
	local v37 = React.useMemo(function()
		if v21.showUpdatedRow then
			return {
				infoName = v22.updated,
				infoData = v36 or "--",
				testId = "--updated-row-tail"
			}
		end
	end, { v21.showUpdatedRow, v36 })

	local v38 = nil
	local v39 = nil
	local v40 = nil

	if module21() then
		v39 = React.useMemo(function()
			local v41 = v22.notSupported

			if v8 then
				return nil
			end

			if v7.experienceVoiceEnabled then
				v41 = v22.supported
			end

			return {
				infoName = v22.voiceChat,
				infoData = v41,
				testId = "--voice-chat-row-tail"
			}
		end, { v7.experienceVoiceEnabled, v8 })

		v40 = React.useMemo(function()
			local v41 = v22.notSupported

			if v7.experienceVideoEnabled then
				v41 = v22.supported
			end

			return {
				infoName = v22.camera,
				infoData = v41,
				testId = "--camera-row-tail"
			}
		end, { v7.experienceVideoEnabled })
	else
		v38 = React.useMemo(function()
			local v41 = {}

			if v7.experienceVoiceEnabled and not v8 then
				table.insert(v41, v22.microphone)
			end

			if v7.experienceVideoEnabled then
				table.insert(v41, v22.camera)
			end

			if #v41 < 1 then
				table.insert(v41, v22.none)
			end

			return {
				infoName = v22.communication,
				infoData = table.concat(v41, ", "),
				testId = "--communication-row-tail"
			}
		end, { v7.experienceVoiceEnabled, v7.experienceVideoEnabled, v8 })
	end

	local useMemo2 = React.useMemo
	local function fn3()
		local v41 = v21.showGamepassesRow

		if v41 then
			v41 = (if fFlagLuaAppGamePassesDataHydrationMigrationEnabled then v6 else v7.showPasses)
				and (not fFlagLuaAppHideEdpStoreForUnplayable or v7.isPlayable)
		end

		if fFlagLuaAppDevStoreSeeAllSduiEnabled and v41 then
			return {
				infoName = v22.passesAndGear,
				navigateOverride = function()
					navigateToDevStoreSeeAll(v5, p2)
				end,
				analyticsSubPage = "PassesAndGear",
				testId = "--store-row-tail"
			}
		end

		if not (v21.webViewSupport and v41) then
			return
		end

		local v42 = {
			infoName = v22.passesAndGear,
			linkPage = module8.game.info.store({ universeId = p2 }),
			analyticsSubPage = "PassesAndGear",
			testId = "--store-row-tail",
			onClose = 0
		}

		local v43 = if fFlagEnableBlackbirdPageCloseCallback and getSubscriptionPurchaseCloseCallback then getSubscriptionPurchaseCloseCallback() else nil
		v42.onClose = v43
		return v42
	end

	local webViewSupport2 = v21.webViewSupport
	local showGamepassesRow = v21.showGamepassesRow
	local v42 = if fFlagLuaAppGamePassesDataHydrationMigrationEnabled then v6 else v7.showPasses
	local isPlayable = if fFlagLuaAppHideEdpStoreForUnplayable then v7.isPlayable else nil
	local passesAndGear = if fFlagLuaAppGamePassesDataHydrationMigrationEnabled then v22.passesAndGear else nil
	local v44 = useMemo2(fn3, {
		p2,
		webViewSupport2,
		showGamepassesRow,
		v42,
		isPlayable,
		passesAndGear,
		if fFlagLuaAppDevStoreSeeAllSduiEnabled then v5 else nil
	})

	local useMemo3 = React.useMemo
	local function fn4()
		if fFlagLuaAppBadgesSeeAllEnabled and v21.showBadgesRow and v7.showBadges then
			return {
				infoName = v22.badges,
				navigateOverride = function()
					navigateToBadgesSeeAll(v5, p2)
				end,
				analyticsSubPage = "Badges",
				testId = "--badges-row-tail"
			}
		end

		if v21.webViewSupport and v21.showBadgesRow and v7.showBadges then
			return {
				infoName = v22.badges,
				linkPage = module8.game.info.badges({ universeId = p2 }),
				analyticsSubPage = "Badges",
				testId = "--badges-row-tail"
			}
		end
	end

	local webViewSupport3 = v21.webViewSupport
	local showBadgesRow = v21.showBadgesRow
	local showPasses = if not fFlagLuaAppGamePassesDataHydrationMigrationEnabled then v7.showPasses else nil

	local showBadges = v7.showBadges
	local v46 = if fFlagLuaAppGamePassesDataHydrationMigrationEnabled then v22.badges else nil
	local v47 = useMemo3(fn4, {
		p2,
		webViewSupport3,
		showBadgesRow,
		showPasses,
		v5,
		showBadges,
		v46
	})

	local v48 = React.useMemo(function()
		if not (v21.webViewSupport and v21.showServersRow) then
			return
		end

		local v49 = {
			infoName = v22.servers,
			linkPage = module8.game.info.servers({ universeId = p2 }),
			analyticsSubPage = "Servers",
			testId = "--servers-row-tail",
			onClose = 0
		}

		local v50 = if fFlagEnableBlackbirdPageCloseCallback and getSubscriptionPurchaseCloseCallback then getSubscriptionPurchaseCloseCallback() else nil
		v49.onClose = v50
		return v49
	end, { p2, v21.webViewSupport, v21.showServersRow })

	local useMemo4 = React.useMemo
	local function fn5()
		if module4.FFlagIsSetupEnabled and v14 then
			if v21.enableGroupLinks and v7.groupLink then
				if v7.groupLink.communityId ~= nil then
					return {
						infoName = v22.group,
						navigateOverride = function()
							v13.openCommunityProfilePage(
								v7.groupLink.communityId,
								"ExperienceDetailsPage:Group"
							)
						end,
						analyticsSubPage = "Group",
						testId = "--group-row-tail"
					}
				end

				if v21.webViewSupport then
					return {
						infoName = v22.group,
						linkPage = v7.groupLink.url,
						analyticsSubPage = "Group",
						testId = "--group-row-tail"
					}
				end
			end
		elseif v21.webViewSupport and v21.enableGroupLinks and v7.groupLink then
			return {
				infoName = v22.group,
				linkPage = v7.groupLink.url,
				analyticsSubPage = "Group",
				testId = "--group-row-tail"
			}
		end
	end

	local webViewSupport4 = v21.webViewSupport
	local enableGroupLinks = v21.enableGroupLinks
	local groupLink = v7.groupLink
	local v50 = if module4.FFlagIsSetupEnabled then v14 else nil
	local v51 = useMemo4(fn5, { p2, webViewSupport4, enableGroupLinks, groupLink, v50 })
	local v52, v53

	if fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp then
		local locale = module11(module14):GetLocale()

		v52 = React.useMemo(function()
			if
				not (fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and module17.getShouldInterleaveSdui())
				or not v10
				or v10.showVisitsInInfoList ~= true
			then
				return
			end

			local gameDetail2 = v7.gameDetail
			local v54 = abbreviateCount(gameDetail2 and gameDetail2.visits or 0, locale) or "--"
			return {
				infoName = v22.visits,
				infoData = v54,
				testId = "--visits-row-tail"
			}
		end, { v10, v7.gameDetail, v22.visits, locale })

		v53 = React.useMemo(function()
			if
				(fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and module17.getShouldInterleaveSdui())
				and v10
				and v10.showContentDescriptorsInInfoList == true
				and v7.ageRecommendations
			then
				local descriptorUsages = v7.ageRecommendations.descriptorUsages

				if descriptorUsages and #descriptorUsages > 0 then
					for i, descriptorUsage in ipairs(descriptorUsages) do
						if descriptorUsage.name == "strong-language" and descriptorUsage.contains then
							local v54 = if fFlagLuaAppUpdateContentDescriptorsTranslation then v22.creatorEnabled else v22.communication
							return {
								infoName = v54,
								infoData = v22.strongLanguage,
								testId = "--content-descriptors-row-tail"
							}
						end
					end
				end
			end
		end, {
			v10,
			v7.ageRecommendations,
			v22.contentDescriptors,
			v22.containsStrongLanguage
		})
	end

	React.useEffect(function()
		if v7.dataStatus == retrievalStatus.NotStarted then
			v19()
		end
	end)

	local v54 = {
		rootPlaceId = tostring(v7.gameDetail.rootPlaceId),
		isBuildContent = 0,
		rows = 0
	}
	local v55 = if fFlagLuaAppEdpNonSduiBuildAttribution then module23(v7.gameDetail) else nil
	v54.isBuildContent = v55
	v54.rows = Dash.append(
		{ v25 },
		(fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and module17.getShouldInterleaveSdui()) and v10 and v10.showVisitsInInfoList == true and v52 and { v52 } or nil,
		{ v26 },
		{ v27 },
		(fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and module17.getShouldInterleaveSdui()) and v10 and v10.showContentDescriptorsInInfoList == true and v53 and { v53 } or nil,
		{ v30 },
		{ v31 },
		{ v32 },
		{ v33 },
		{ v35 },
		{ v37 },
		not module21() and { v38 } or nil,
		module21() and { v39 } or nil,
		module21() and { v40 } or nil,
		{ v44 },
		{ v47 },
		{ v48 },
		{ v51 }
	)

	return v54, v7.dataStatus, v19
end
