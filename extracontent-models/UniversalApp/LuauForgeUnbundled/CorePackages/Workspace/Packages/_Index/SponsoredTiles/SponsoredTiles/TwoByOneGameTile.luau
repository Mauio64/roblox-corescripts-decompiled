local GameTile = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/GameTile")

local getGameTileLayoutData = GameTile.getGameTileLayoutData
local formatExperienceThumbnail = GameTile.formatExperienceThumbnail
local useIsHoveredTile = GameTile.useIsHoveredTile
local useNavigateToGameDetails = GameTile.useNavigateToGameDetails
local gameTileThumbnailBadges = GameTile.GameTileThumbnailBadges
local getAvailableGameTileOverflowMenuItems = GameTile.getAvailableGameTileOverflowMenuItems
local SpanTileOverflowMenu = require("@game/CorePackages/Workspace/Packages/_Index/SponsoredTiles/SponsoredTiles/SpanTileOverflowMenu/SpanTileOverflowMenu")
local twoByOneGameTileTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/SponsoredTilesTelemetry").TwoByOneGameTileTelemetry
require("@game/CorePackages/Workspace/Packages/_Index/SponsoredTiles/SponsoredTiles/types")
local hiddenTileContent = GameTile.HiddenTileContent
local itemLayoutDataParsingUtils = GameTile.ItemLayoutDataParsingUtils
local hoverTileCoordinator = GameTile.HoverTileCoordinator

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/Foundation")
local buttonSize = Foundation.Enums.ButtonSize
local useTokens = Foundation.Hooks.useTokens
local image = Foundation.Image
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/Responsive")
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/RoactUtils").Hooks.RoactRodux.useSelector
local gameInfosReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/GameInfosRodux").GameInfosReducer
local AppBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/AppBlox")
local getOverflowMenuSignalStore = AppBlox.getOverflowMenuSignalStore
local useOverflowMenuOpen = AppBlox.useOverflowMenuOpen
local useTriggerFeedback = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/InteractionFeedback").useTriggerFeedback
local impressionsTagUtility = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/Impressions").ImpressionsTagUtility
local getTextSize = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/Style").GetTextSize
local playButton = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/GamePlayButton").PlayButton
local useOnPlayButtonCallback = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/GamePlayButton").useOnPlayButtonCallback
local usePlayButtonState = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/GamePlayButton").usePlayButtonState
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/Localization").Hooks.useLocalization
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/RobloxAppHooks").useRoactService
local RoactServiceTags = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/RoactServiceTags")
local roactNetworking = RoactServiceTags.RoactNetworking
local appSessionService = RoactServiceTags.AppSessionService
local RobloxAppSessionization = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/RobloxAppSessionization")
local setGamePlaySession = RobloxAppSessionization.SetGamePlaySession
local sessionType = RobloxAppSessionization.SessionType
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/SharedFlags")
local sponsoredGamesRecordClick = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/DiscoveryAnalytics").Requests.sponsoredGamesRecordClick
local gameCollectionItemTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/DiscoveryTypes").GameCollectionItemTypes
local useValidTileBadges = GameTile.useValidTileBadges
local useTagAsViewportAutoplayCandidate = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/VideoUtils").useTagAsViewportAutoplayCandidate
local useTagAsSponsoredAdViewabilityCandidate = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/SponsoredAdViewability").useTagAsSponsoredAdViewabilityCandidate

local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local FFlagLuaAppSponsoredTileBadgeContentPadding = require("@game/CorePackages/Workspace/Packages/_Index/SponsoredTiles/SponsoredTiles/Flags/FFlagLuaAppSponsoredTileBadgeContentPadding")

local defineFastInt = game:DefineFastInt("LuaAppTwoByOneTileSmallScreenBreakpoint", 600)

local defineFastInt2 = game:DefineFastInt("LuaAppTwoByOneTileLogoHeightPercentLandscape", 20)

local defineFastInt3 = game:DefineFastInt("LuaAppTwoByOneTileLogoHeightPercentSquare", 36)

local defineFastInt4 = game:DefineFastInt("LuaAppTwoByOneTileGradientStartOpacityPercent", 30)

local defineFastInt5 = game:DefineFastInt("LuaAppTwoByOneTileGradientEndOpacityPercent", 100)
local defineFastInt6 = game:DefineFastInt("LuaAppTwoByOneTileGradientWidthPercent", 50)
local fFlagLuaAppHomePageFirstImageLoadObserver = SharedFlags.FFlagLuaAppHomePageFirstImageLoadObserver
local fFlagLuaAppFeatureTileHapticsFix = SharedFlags.FFlagLuaAppFeatureTileHapticsFix
local fFlagLuaAppTileVideoCandidateOnly = SharedFlags.FFlagLuaAppTileVideoCandidateOnly
local fFlagLuaAppDemoModePlayButtonTelemetry = SharedFlags.FFlagLuaAppDemoModePlayButtonTelemetry
local fFlagLuaAppHomeThumbnailPrefetch = SharedFlags.FFlagLuaAppHomeThumbnailPrefetch
local fFlagMigrateGameInfoToStore = SharedFlags.FFlagMigrateGameInfoToStore
local fFlagLuaAppSduiSponsoredTwoByOneTile = SharedFlags.FFlagLuaAppSduiSponsoredTwoByOneTile
local fFlagLuaAppEnableReportExperience = SharedFlags.FFlagLuaAppEnableReportExperience

local resolveGameTileThumbnailUri = if fFlagLuaAppHomeThumbnailPrefetch then GameTile.resolveGameTileThumbnailUri else nil
local v5 = fFlagLuaAppFeatureTileHapticsFix and "TileLongPress" or "TwoByOneTileLongPress"
local color = Color3.new(1, 1, 1)
local color2 = Color3.new(0, 0, 0)

local v6 = defineFastInt2 / 100
local v7 = defineFastInt3 / 100
local v8 = defineFastInt4 / 100
local v9 = defineFastInt5 / 100
local v10 = defineFastInt6 / 100

local v11 = { JoinGame = "JoinGame", OpenEdp = "OpenEdp" }

local v12 = { StandardLight = "StandardLight", OverMedia = "OverMedia" }

local v13 = {
	Default = {
		ctaStyle = nil,
		onCtaActivation = "JoinGame",
		onTileActivation = "OpenEdp"
	},
	Variant1 = { ctaStyle = nil, onCtaActivation = nil, onTileActivation = "JoinGame" },
	Variant2 = {
		ctaStyle = "StandardLight",
		onCtaActivation = "OpenEdp",
		onTileActivation = "JoinGame"
	},
	Variant3 = {
		ctaStyle = "OverMedia",
		onCtaActivation = "OpenEdp",
		onTileActivation = "JoinGame"
	}
}

return function(props)
	local v14 = useNavigateToGameDetails()
	local v15 = useRoactService(roactNetworking)
	local v16 = useRoactService(appSessionService)

	local v17 = useLocalization({
		sponsoredText = "Feature.GamePage.Label.Sponsored",
		joinButtonText = "Common.VisitGame.Label.Play"
	})

	local v18 = if props.ctaText then props.ctaText else v17.joinButtonText
	local v19 = v13[props.tileVariant] or v13.Default

	local v20 = useTokens()
	local udim = UDim.new(0, v20.Radius.Medium)
	local v21, v22, v23, v24, v25, v26, v27, v28, v29

	if Responsive.useResponsive({
		{ Key = "Smaller", maxWidth = defineFastInt }
	}) == "Smaller" then
		v21 = v20.Padding.Medium
		v22 = v20.Padding.Medium
		v23 = v20.Typography.TitleLarge
		v24 = v20.Typography.BodySmall
		v25 = v20.Typography.CaptionSmall
		v26 = v20.Gap.XXSmall
		v27 = buttonSize.Small
		v28 = v20.Size.Size_800
		v29 = v20.Typography.TitleSmall
	else
		v21 = v20.Padding.Large
		v22 = v20.Padding.Large
		v23 = v20.Typography.HeadingMedium
		v24 = v20.Typography.BodyMedium
		v25 = v20.Typography.CaptionMedium
		v26 = v20.Gap.XSmall
		v27 = buttonSize.Medium
		v28 = v20.Size.Size_1000
		v29 = v20.Typography.TitleMedium
	end

	local v30 = v20.Padding.Large * 4

	local v31 = React.useMemo(function()
		local textSize = getTextSize(v18, v29.FontSize, v29.Font, Vector2.new(1e999, 1e999))

		return UDim.new(0, textSize.X + v30)
	end, { v18, v29, v30 })
	local color3

	if v19.ctaStyle == "StandardLight" then
		color3 = v20.Color.Extended.White.White_20.Color3
	else
		color3 = v20.LightMode.ActionOverMedia.Background.Color3
	end

	local transparency

	if v19.ctaStyle == "StandardLight" then
		transparency = v20.Color.Extended.White.White_20.Transparency
	else
		transparency = v20.LightMode.ActionOverMedia.Background.Transparency
	end

	local logoAspectRatio = tonumber(props.logoAspectRatio)
	local v32 = not (logoAspectRatio and logoAspectRatio > 0) and 1 or logoAspectRatio
	local v33 = if v32 == 3 then v6 else v7

	local universeId = props.universeId
	local placeId = props.placeId

	local v34 = useValidTileBadges(universeId, props.topicId, props.badgeOverride)

	local hoverKey = props.hoverKey
	local state, setState = React.useState(false)
	local ref = React.useRef(nil)
	local v35 = useTriggerFeedback()
	local v36 = useOverflowMenuOpen(hoverKey)

	local v37 = useIsHoveredTile(ref, hoverKey, true)

	local ref2 = React.useRef(false)

	local useCallback = React.useCallback
	local function fn()
		if
			props.isSponsored
			and props.adId
			and not (fFlagLuaAppSduiSponsoredTwoByOneTile and props.disableSponsoredClickRecording)
		then
			sponsoredGamesRecordClick(v15, props.adId)
		end
	end

	local isSponsored = props.isSponsored
	local adId = props.adId
	local v39 = if fFlagLuaAppSduiSponsoredTwoByOneTile then props.disableSponsoredClickRecording else nil
	local v40 = useCallback(fn, { v15, isSponsored, adId, v39 })

	local v41 = React.useCallback(function()
		ref2.current = false
	end, {})

	local useCallback2 = React.useCallback
	local function fn2()
		if fFlagLuaAppSduiSponsoredTwoByOneTile and props.onOpenGameDetails then
			props.onOpenGameDetails()
		else
			local v42 = {
				index = props.index,
				placeIdOverride = props.placeIdOverride,
				experienceJoinData = 0
			}

			local v44 = if props.launchDataOverride then props.launchDataOverride else nil
			v42.experienceJoinData = {
				launchData = v44,
				tileType = gameCollectionItemTypes.GameCollectionItemType.TwoByOneTile,
				nativeAdData = props.adId
			}

			v14(universeId, v42)

			if not fFlagLuaAppSduiSponsoredTwoByOneTile then
				twoByOneGameTileTelemetry.logTwoByOneTileViewGameDetailsActivated()
			end

			if props.reportGameDetailOpened then
				props.reportGameDetailOpened(props.index, universeId)
			end
		end

		if fFlagLuaAppSduiSponsoredTwoByOneTile then
			twoByOneGameTileTelemetry.logTwoByOneTileViewGameDetailsActivated()
		end
	end

	local index = props.index
	local placeIdOverride = props.placeIdOverride
	local launchDataOverride = props.launchDataOverride
	local reportGameDetailOpened = props.reportGameDetailOpened
	local adId2 = props.adId
	local v43 = if fFlagLuaAppSduiSponsoredTwoByOneTile then props.onOpenGameDetails else nil
	local v44 = useCallback2(fn2, {
		v14,
		universeId,
		index,
		placeIdOverride,
		launchDataOverride,
		reportGameDetailOpened,
		adId2,
		v43
	})

	local v45 = React.useCallback(function()
		setState(true)

		if props.onSelectionGained then
			props.onSelectionGained()
		end
	end, { props.onSelectionGained })

	local v46 = React.useCallback(function()
		setState(false)

		if props.onSelectionLost then
			props.onSelectionLost()
		end
	end, { props.onSelectionLost })

	local isSponsored2 = props.isSponsored
	local useMemo = React.useMemo
	local function fn3()
		local v48 = {
			isSponsored = isSponsored2,
			enableSponsoredFeedback = props.enableSponsoredFeedback,
			enableReportAd = props.enableReportAd,
			enableReportExperience = 0,
			enableExplicitFeedback = 0
		}

		local v49 = if fFlagLuaAppEnableReportExperience then props.enableReportExperience else nil
		v48.enableReportExperience = v49

		v48.enableExplicitFeedback = props.enableExplicitFeedback
		return getAvailableGameTileOverflowMenuItems(v48)
	end

	local enableSponsoredFeedback = props.enableSponsoredFeedback
	local enableReportAd = props.enableReportAd
	local v48 = if fFlagLuaAppEnableReportExperience then props.enableReportExperience else nil
	local v49 = useMemo(fn3, {
		isSponsored2,
		enableSponsoredFeedback,
		enableReportAd,
		v48,
		props.enableExplicitFeedback
	})

	local useCallback3 = React.useCallback
	local function fn4()
		local current = ref2.current
		ref2.current = true

		if fFlagLuaAppSduiSponsoredTwoByOneTile and current == false and props.onTouchLongPress then
			props.onTouchLongPress()
		elseif current == false and next(v49) ~= nil then
			if v35 and not v36 then
				local v50 = { universeId = universeId, sortId = props.topicId }

				v35(v5, "Press", props.appPage or "Unknown", v50)
			end

			getOverflowMenuSignalStore().openMenu(hoverKey)
		end
	end

	local appPage = props.appPage
	local topicId = props.topicId

	local v51 = if fFlagLuaAppSduiSponsoredTwoByOneTile then props.onTouchLongPress else nil
	local v52 = useCallback3(fn4, {
		hoverKey,
		appPage,
		topicId,
		v35,
		v49,
		v36,
		universeId,
		v51
	})

	local v53 = React.useCallback(function(p2)
		if v16 then
			setGamePlaySession(v16, sessionType.StructuralIdentifier.GamePlayFromHoverTile, true)
		end

		if v37 then
			hoverTileCoordinator.default:reset()
		end

		if props.reportExperienceLaunched then
			local v54 = {
				placeId = placeId,
				universeId = universeId,
				adId = props.adId,
				tileType = gameCollectionItemTypes.GameCollectionItemType.TwoByOneTile,
				placeIdOverride = props.placeIdOverride,
				launchDataOverride = props.launchDataOverride
			}

			local reportExperienceLaunched = props.reportExperienceLaunched

			local appPage2 = props.appPage
			local twoByOneTile = gameCollectionItemTypes.GameCollectionItemType.TwoByOneTile
			local twoByOneTile2 = gameCollectionItemTypes.GameCollectionItemType.TwoByOneTile
			local index2 = props.index

			if not fFlagLuaAppDemoModePlayButtonTelemetry then
				p2 = nil
			end

			reportExperienceLaunched(v54, appPage2, twoByOneTile, twoByOneTile2, index2, p2)
		end
	end, {
		v16,
		props.reportExperienceLaunched,
		placeId,
		universeId,
		props.appPage,
		props.index,
		props.adId,
		props.placeIdOverride,
		props.launchDataOverride,
		v37
	})

	local v54 = usePlayButtonState(v15, universeId)

	local appPage2 = props.appPage

	local v59 = {
		launchData = props.launchDataOverride,
		tileType = gameCollectionItemTypes.GameCollectionItemType.TwoByOneTile,
		nativeAdData = props.adId
	}

	local v60 = if props.placeIdOverride then props.placeIdOverride else props.placeId
	local v61 = useOnPlayButtonCallback(universeId, appPage2, "TwoByOneTile", nil, "TwoByOneTile", v59, v60)

	local v62 = React.useCallback(function()
		twoByOneGameTileTelemetry.logTwoByOneTileGameJoinInitiated()
		twoByOneGameTileTelemetry.logTwoByOneTileCtaActivated()
		v40()
	end, { v40 })

	local v63 = React.useCallback(function()
		twoByOneGameTileTelemetry.logTwoByOneTileCtaActivated()
		v40()
		v44()
	end, { v40, v44 })
	local v64 = React.useCallback(function()
		twoByOneGameTileTelemetry.logTwoByOneTileGameJoinInitiated()

		v61(v54.playButtonState, v53)
	end, { v61, v54.playButtonState, v53 })

	local v65 = React.useCallback(function()
		if ref2.current then
			ref2.current = false
			return
		end

		if v37 then
			hoverTileCoordinator.default:reset()
		end

		twoByOneGameTileTelemetry.logTwoByOneTileActivated()
		v40()

		if v19.onTileActivation == "OpenEdp" then
			v44()
		elseif v19.onTileActivation == "JoinGame" then
			v64()
		end
	end, { v37, v19.onTileActivation, v44, v64, v40 })
	local v66

	if not fFlagMigrateGameInfoToStore then
		v66 = useSelector(function(p2)
			return p2.Personalization[gameInfosReducer.key][universeId]
		end)
	end

	local v67

	if fFlagLuaAppHomeThumbnailPrefetch then
		local v69 = {
			placeId = placeId,
			useGridTile = true,
			isEmphasized = true,
			perEntryWideAssetId = 0,
			game = 0,
			topicId = 0
		}

		local v70 = if fFlagMigrateGameInfoToStore then props.wideAssetId else props.primaryWideImageAssetId
		v69.perEntryWideAssetId = v70

		v69.game = if not fFlagMigrateGameInfoToStore then v66 else nil
		v69.topicId = props.topicId
		v67 = resolveGameTileThumbnailUri(v69)
	elseif fFlagMigrateGameInfoToStore then
		v67 = formatExperienceThumbnail(props.wideAssetId, placeId, true)
	else
		local gameTileLayoutData = getGameTileLayoutData(v66, props.topicId)
		local v68

		if props.primaryWideImageAssetId then
			v68 = props.primaryWideImageAssetId
		else
			v68 = itemLayoutDataParsingUtils.getWideImageAssetId(gameTileLayoutData)
		end

		if not v68 then
			v68 = if v66 then v66.primaryWideAssetId or nil else nil
		end

		v67 = formatExperienceThumbnail(v68, placeId, true)
	end

	local v68

	if fFlagMigrateGameInfoToStore then
		v68 = props.ageRatingLabel
	else
		v68 = v66 and v66.ageRecommendationDisplayName or nil
	end

	local ref3 = React.useRef(nil)
	React.useEffect(function()
		impressionsTagUtility.AddTag(ref3, props.impressionsTag, props.index)
		return function()
			impressionsTagUtility.RemoveTag(ref3, props.impressionsTag, props.index)
		end
	end, { props.impressionsTag, props.index })

	useTagAsViewportAutoplayCandidate(
		ref3,
		props.videoPlaybackContext,
		if fFlagLuaAppTileVideoCandidateOnly then false else nil
	)

	useTagAsSponsoredAdViewabilityCandidate(
		ref3,
		props.isSponsored and props.adId ~= nil and not props.isHidden and {
			encryptedAdTrackingData = props.adId,
			tileType = gameCollectionItemTypes.GameCollectionItemType.TwoByOneTile,
			mediaType = "image"
		} or nil
	)

	if props.isHidden then
		local createElement = React.createElement
		local v74 = if fFlagLuaAppSduiSponsoredTwoByOneTile then props.rootSize else nil
		local v73 = {
			Size = v74,
			LayoutOrder = props.layoutOrder,
			ZIndex = props.zIndex,
			BackgroundTransparency = 1,
			ref = ref3
		}

		local createElement2 = React.createElement
		local v77 = {
			Size = props.size or UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			ref = ref,
			Selectable = false,
			SelectionOrder = props.SelectionOrder
		}

		local v79 = if fFlagLuaAppSduiSponsoredTwoByOneTile and props.renderHiddenState then props.renderHiddenState(ref) else React.createElement(hiddenTileContent, {
			appPage = props.appPage,
			collectionId = props.topicId,
			setGameHidden = props.setGameHidden,
			universeId = universeId,
			parentRef = ref,
			isSponsored = isSponsored2
		})
		return createElement("Frame", v73, {
			TwoByOneTileContainer = createElement2("TextButton", v77, {
				HiddenTileContent = v79
			})
		})
	else
		local createElement = React.createElement
		local v74 = if fFlagLuaAppSduiSponsoredTwoByOneTile then props.rootSize else nil
		local v73 = {
			Size = v74,
			LayoutOrder = props.layoutOrder,
			ZIndex = props.zIndex,
			BackgroundTransparency = 1,
			ref = ref3
		}

		local createElement2 = React.createElement
		local v77 = {
			Size = props.size or UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Text = "",
			AutoButtonColor = false,
			ref = ref,
			SelectionOrder = props.SelectionOrder,
			[React.Event.TouchLongPress] = v52,
			[React.Event.Activated] = v65,
			[React.Event.SelectionGained] = v45,
			[React.Event.SelectionLost] = v46,
			[React.Change.GuiState] = v41
		}
		local children = {
			BackgroundImage = React.createElement("ImageLabel", {
				[React.Tag] = fFlagLuaAppHomePageFirstImageLoadObserver and "observed-image" or nil,
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				Image = v67,
				ScaleType = Enum.ScaleType.Crop,
				ZIndex = 0
			}, {
				UICorner = React.createElement("UICorner", { CornerRadius = udim })
			}),
			GradientOverlayLeft = React.createElement("Frame", {
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.new(0, 0, 1, 0),
				Size = UDim2.new(v10, 0, 1, 0),
				BackgroundColor3 = color,
				BackgroundTransparency = 0,
				BorderSizePixel = 0,
				ZIndex = 1
			}, {
				UICorner = React.createElement("UICorner", { CornerRadius = udim }),
				UIGradientLeft = React.createElement("UIGradient", {
					Rotation = 0,
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, v8),
						NumberSequenceKeypoint.new(1, v9)
					}),
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, color2),
						ColorSequenceKeypoint.new(1, color2)
					})
				})
			}),
			GradientOverlayBottom = React.createElement("Frame", {
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.new(0, 0, 1, 0),
				Size = UDim2.new(1, 0, v10, 0),
				BackgroundColor3 = color,
				BackgroundTransparency = 0,
				BorderSizePixel = 0,
				ZIndex = 1
			}, {
				UICorner = React.createElement("UICorner", { CornerRadius = udim }),
				UIGradientBottom = React.createElement("UIGradient", {
					Rotation = 90,
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, v9),
						NumberSequenceKeypoint.new(1, v8)
					}),
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, color2),
						ColorSequenceKeypoint.new(1, color2)
					})
				})
			}),
			TileBadge = 0,
			ContentOverlay = 0,
			OverflowMenu = 0
		}

		if v34 then
			v34 = React.createElement(
				"Frame",
				{ Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 2 },
				{
					Badge = React.createElement(gameTileThumbnailBadges, {
						tileBadgesByPosition = v34,
						padding = if FFlagLuaAppSponsoredTileBadgeContentPadding then v21 else nil
					})
				}
			)
		end

		children.TileBadge = v34

		local createElement4 = React.createElement
		local v80 = {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			ZIndex = 3
		}

		local children2 = {
			UIPadding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, v21),
				PaddingRight = UDim.new(0, v21),
				PaddingTop = UDim.new(0, v22),
				PaddingBottom = UDim.new(0, v22)
			}),
			Logo = props.logoImageAssetId and React.createElement(image, {
				Position = UDim2.new(1, 0, 0, 0),
				AnchorPoint = Vector2.new(1, 0),
				Image = "rbxassetid://" .. tostring(props.logoImageAssetId),
				Size = UDim2.new(1, 0, v33, 0),
				aspectRatio = v32
			}),
			HeaderFrame = 0,
			JoinButtonContainer = 0,
			ViewGameDetailsButton = 0,
			BottomRightLabel = 0
		}

		local createElement5 = React.createElement
		local v82 = {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Position = UDim2.new(0, 0, 0.47, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundTransparency = 1
		}

		local children3 = {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, v26)
			}),
			Headline = 0,
			Subtitle = 0
		}

		local createElement6 = React.createElement
		local v84 = {
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Text = props.headline or "",
			Font = 0,
			FontFace = 0,
			TextSize = 0,
			TextColor3 = 0,
			TextXAlignment = 0,
			TextYAlignment = 0,
			TextWrapped = true
		}
		local v85 = if not foundationFontFaceMigration then v23.Font else nil
		v84.Font = v85

		local v86 = if foundationFontFaceMigration then normalizeFontFace(v23.Font) else nil
		v84.FontFace = v86

		v84.TextSize = v23.FontSize
		v84.TextColor3 = color
		v84.TextXAlignment = Enum.TextXAlignment.Left
		v84.TextYAlignment = Enum.TextYAlignment.Top
		children3.Headline = createElement6("TextLabel", v84)

		local createElement7 = React.createElement
		local v88 = {
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Text = props.subtitle or "",
			Font = 0,
			FontFace = 0,
			TextSize = 0,
			TextColor3 = 0,
			TextXAlignment = 0,
			TextYAlignment = 0,
			TextWrapped = true
		}
		local v89 = if not foundationFontFaceMigration then v24.Font else nil
		v88.Font = v89

		local v90 = if foundationFontFaceMigration then normalizeFontFace(v24.Font) else nil
		v88.FontFace = v90

		v88.TextSize = v24.FontSize
		v88.TextColor3 = color
		v88.TextXAlignment = Enum.TextXAlignment.Left
		v88.TextYAlignment = Enum.TextYAlignment.Top
		children3.Subtitle = createElement7("TextLabel", v88)
		children2.HeaderFrame = createElement5("Frame", v82, children3)
		local v91

		if v19.onCtaActivation == "JoinGame" then
			local createElement8 = React.createElement
			local v93 = {
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 0, 1, 0),
				AnchorPoint = Vector2.new(0, 1)
			}

			local createElement9 = React.createElement
			local v96 = {
				universeId = universeId,
				placeId = 0,
				referralSource = 0,
				eventContext = "TwoByOneTile",
				launchSource = "TwoByOneTile",
				playableText = 0,
				hidePlayableIcon = true,
				buttonSize = 0,
				width = 0,
				preferSecondaryPlayButton = true,
				onActivated = 0,
				reportExperienceLaunched = 0,
				experienceJoinData = 0
			}

			local v97 = if props.placeIdOverride then props.placeIdOverride else placeId
			v96.placeId = v97
			v96.referralSource = props.appPage

			v96.playableText = v18

			v96.buttonSize = v27
			v96.width = v31

			v96.onActivated = v62
			v96.reportExperienceLaunched = v53
			v96.experienceJoinData = props.launchDataOverride
				and { launchData = props.launchDataOverride }
				or nil
			v91 = createElement8("Frame", v93, {
				JoinButton = createElement9(playButton, v96)
			})
		else
			v91 = false
		end

		children2.JoinButtonContainer = v91
		local v92

		if v19.onCtaActivation == "OpenEdp" then
			local createElement8 = React.createElement
			local v94 = {}
			v94.Size = UDim2.new(v31.Scale, v31.Offset, 0, v28)
			v94.Position = UDim2.new(0, 0, 1, 0)
			v94.AnchorPoint = Vector2.new(0, 1)
			v94.BackgroundColor3 = color3
			v94.BackgroundTransparency = transparency
			v94.Text = v18
			v94.TextColor3 = v20.LightMode.ActionOverMedia.Foreground.Color3
			local v95 = if not foundationFontFaceMigration then v29.Font else nil
			v94.Font = v95

			local v96 = if foundationFontFaceMigration then normalizeFontFace(v29.Font) else nil
			v94.FontFace = v96

			v94.TextSize = v29.FontSize
			v94[React.Event.Activated] = v63
			v92 = createElement8("TextButton", v94, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, v20.Radius.Medium)
				})
			})
		else
			v92 = false
		end

		children2.ViewGameDetailsButton = v92

		local createElement8 = React.createElement
		local v94 = {
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(0, 0, 0, v25.FontSize * v25.LineHeight),
			BackgroundTransparency = 1,
			Text = v68,
			TextSize = v25.FontSize,
			Font = 0,
			FontFace = 0,
			TextColor3 = 0,
			TextXAlignment = 0,
			TextTruncate = 0,
			AnchorPoint = 0,
			Position = 0
		}
		local v95 = if not foundationFontFaceMigration then v25.Font else nil
		v94.Font = v95

		local v96 = if foundationFontFaceMigration then normalizeFontFace(v25.Font) else nil
		v94.FontFace = v96

		v94.TextColor3 = v20.Color.Extended.Gray.Gray_400.Color3
		v94.TextXAlignment = Enum.TextXAlignment.Right
		v94.TextTruncate = Enum.TextTruncate.SplitWord
		v94.AnchorPoint = Vector2.new(1, 1)
		v94.Position = UDim2.new(1, 0, 1, 0)
		children2.BottomRightLabel = createElement8("TextLabel", v94)
		children.ContentOverlay = createElement4("Frame", v80, children2)
		local v97

		if fFlagLuaAppSduiSponsoredTwoByOneTile and props.renderOverflowMenu then
			v97 = props.renderOverflowMenu({
				isHovered = v37,
				isSelected = state,
				menuKey = hoverKey,
				parentRef = ref
			})
		else
			v97 = React.createElement(SpanTileOverflowMenu, {
				hoverKey = hoverKey,
				parentRef = ref,
				zIndex = 4,
				universeId = universeId,
				placeId = placeId,
				adId = props.adId,
				payerName = props.payerName,
				sponsoredUserCohort = props.sponsoredUserCohort,
				appPage = props.appPage,
				topicId = props.topicId,
				isSponsored = props.isSponsored,
				setGameHidden = props.setGameHidden or function() end,
				isHovered = v37,
				isSelected = state,
				availableMenuItems = v49
			})
		end

		children.OverflowMenu = v97
		return createElement("Frame", v73, {
			TwoByOneTileContainer = createElement2("TextButton", v77, children)
		})
	end
end
