local SponsoredTiles = script:FindFirstAncestor("SponsoredTiles")
local parent = SponsoredTiles.Parent
local GameTile = require(parent.GameTile)

local getGameTileLayoutData = GameTile.getGameTileLayoutData
local formatExperienceThumbnail = GameTile.formatExperienceThumbnail
local useIsHoveredTile = GameTile.useIsHoveredTile
local useNavigateToGameDetails = GameTile.useNavigateToGameDetails
local GameTileThumbnailBadges = GameTile.GameTileThumbnailBadges
local getAvailableGameTileOverflowMenuItems = GameTile.getAvailableGameTileOverflowMenuItems
local SpanTileOverflowMenu = require(SponsoredTiles.SpanTileOverflowMenu.SpanTileOverflowMenu)
local SponsoredTilesTelemetry = require(parent.SponsoredTilesTelemetry)
local TwoByOneGameTileTelemetry = SponsoredTilesTelemetry.TwoByOneGameTileTelemetry
require(SponsoredTiles.types)
local HiddenTileContent = GameTile.HiddenTileContent
local ItemLayoutDataParsingUtils = GameTile.ItemLayoutDataParsingUtils
local HoverTileCoordinator = GameTile.HoverTileCoordinator

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local ButtonSize = Foundation.Enums.ButtonSize
local useTokens = Foundation.Hooks.useTokens
local Image = Foundation.Image
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local Responsive = require(parent.Responsive)
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local GameInfosRodux = require(parent.GameInfosRodux)
local GameInfosReducer = GameInfosRodux.GameInfosReducer
local AppBlox = require(parent.AppBlox)
local getOverflowMenuSignalStore = AppBlox.getOverflowMenuSignalStore
local useOverflowMenuOpen = AppBlox.useOverflowMenuOpen
local InteractionFeedback = require(parent.InteractionFeedback)
local useTriggerFeedback = InteractionFeedback.useTriggerFeedback
local Impressions = require(parent.Impressions)
local ImpressionsTagUtility = Impressions.ImpressionsTagUtility
local Style = require(parent.Style)
local GetTextSize = Style.GetTextSize
local GamePlayButton = require(parent.GamePlayButton)
local PlayButton = GamePlayButton.PlayButton
local GamePlayButton2 = require(parent.GamePlayButton)
local useOnPlayButtonCallback = GamePlayButton2.useOnPlayButtonCallback
local GamePlayButton3 = require(parent.GamePlayButton)
local usePlayButtonState = GamePlayButton3.usePlayButtonState
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local AppSessionService = RoactServiceTags.AppSessionService
local RobloxAppSessionization = require(parent.RobloxAppSessionization)
local SetGamePlaySession = RobloxAppSessionization.SetGamePlaySession
local SessionType = RobloxAppSessionization.SessionType
local SharedFlags = require(parent.SharedFlags)
local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local sponsoredGamesRecordClick = DiscoveryAnalytics.Requests.sponsoredGamesRecordClick
local DiscoveryTypes = require(parent.DiscoveryTypes)
local GameCollectionItemTypes = DiscoveryTypes.GameCollectionItemTypes
local useValidTileBadges = GameTile.useValidTileBadges
local VideoUtils = require(parent.VideoUtils)
local useTagAsViewportAutoplayCandidate = VideoUtils.useTagAsViewportAutoplayCandidate
local SponsoredAdViewability = require(parent.SponsoredAdViewability)
local useTagAsSponsoredAdViewabilityCandidate = SponsoredAdViewability.useTagAsSponsoredAdViewabilityCandidate

local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local FFlagLuaAppSponsoredTileBadgeContentPadding = require(SponsoredTiles.Flags.FFlagLuaAppSponsoredTileBadgeContentPadding)

local defineFastInt = game:DefineFastInt("LuaAppTwoByOneTileSmallScreenBreakpoint", 600)

local defineFastInt2 = game:DefineFastInt("LuaAppTwoByOneTileLogoHeightPercentLandscape", 20)

local defineFastInt3 = game:DefineFastInt("LuaAppTwoByOneTileLogoHeightPercentSquare", 36)

local defineFastInt4 = game:DefineFastInt("LuaAppTwoByOneTileGradientStartOpacityPercent", 30)

local defineFastInt5 = game:DefineFastInt("LuaAppTwoByOneTileGradientEndOpacityPercent", 100)
local defineFastInt6 = game:DefineFastInt("LuaAppTwoByOneTileGradientWidthPercent", 50)
local FFlagLuaAppHomePageFirstImageLoadObserver = SharedFlags.FFlagLuaAppHomePageFirstImageLoadObserver
local FFlagLuaAppFeatureTileHapticsFix = SharedFlags.FFlagLuaAppFeatureTileHapticsFix
local FFlagLuaAppTileVideoCandidateOnly = SharedFlags.FFlagLuaAppTileVideoCandidateOnly
local FFlagLuaAppDemoModePlayButtonTelemetry = SharedFlags.FFlagLuaAppDemoModePlayButtonTelemetry
local FFlagLuaAppHomeThumbnailPrefetch = SharedFlags.FFlagLuaAppHomeThumbnailPrefetch
local FFlagMigrateGameInfoToStore = SharedFlags.FFlagMigrateGameInfoToStore
local FFlagLuaAppSduiSponsoredTwoByOneTile = SharedFlags.FFlagLuaAppSduiSponsoredTwoByOneTile
local FFlagLuaAppEnableReportExperience = SharedFlags.FFlagLuaAppEnableReportExperience
local resolveGameTileThumbnailUri

if FFlagLuaAppHomeThumbnailPrefetch then
	resolveGameTileThumbnailUri = GameTile.resolveGameTileThumbnailUri
else
	resolveGameTileThumbnailUri = nil
end

local v = FFlagLuaAppFeatureTileHapticsFix and "TileLongPress" or "TwoByOneTileLongPress"
local color = Color3.new(1, 1, 1)
local color2 = Color3.new(0, 0, 0)

local v2 = defineFastInt2 / 100
local v3 = defineFastInt3 / 100
local v4 = defineFastInt4 / 100
local v5 = defineFastInt5 / 100
local v6 = defineFastInt6 / 100

local _ = { JoinGame = "JoinGame", OpenEdp = "OpenEdp" }

local _ = { StandardLight = "StandardLight", OverMedia = "OverMedia" }

local v7 = {
	Default = { ctaStyle = nil, onCtaActivation = "JoinGame", onTileActivation = "OpenEdp" },
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
	local v8 = useNavigateToGameDetails()
	local v9 = useRoactService(RoactNetworking)
	local v10 = useRoactService(AppSessionService)

	local v11 = useLocalization({
		sponsoredText = "Feature.GamePage.Label.Sponsored",
		joinButtonText = "Common.VisitGame.Label.Play"
	})
	local v12

	if props.ctaText then
		v12 = props.ctaText
	else
		v12 = v11.joinButtonText
	end

	local v13 = v7[props.tileVariant] or v7.Default

	local v14 = useTokens()
	local udim = UDim.new(0, v14.Radius.Medium)
	local v15, v16, v17, v18, v19, v20, buttonSize, v21, v22

	if Responsive.useResponsive({
		{ Key = "Smaller", maxWidth = defineFastInt }
	}) == "Smaller" then
		v15 = v14.Padding.Medium
		v16 = v14.Padding.Medium
		v17 = v14.Typography.TitleLarge
		v18 = v14.Typography.BodySmall
		v19 = v14.Typography.CaptionSmall
		v20 = v14.Gap.XXSmall
		buttonSize = ButtonSize.Small
		v21 = v14.Size.Size_800
		v22 = v14.Typography.TitleSmall
	else
		v15 = v14.Padding.Large
		v16 = v14.Padding.Large
		v17 = v14.Typography.HeadingMedium
		v18 = v14.Typography.BodyMedium
		v19 = v14.Typography.CaptionMedium
		v20 = v14.Gap.XSmall
		buttonSize = ButtonSize.Medium
		v21 = v14.Size.Size_1000
		v22 = v14.Typography.TitleMedium
	end

	local v23 = v14.Padding.Large * 4

	local width = React.useMemo(function()
		local textSize = GetTextSize(v12, v22.FontSize, v22.Font, Vector2.new(1e999, 1e999))

		return UDim.new(0, textSize.X + v23)
	end, { v12, v22, v23 })
	local color3

	if v13.ctaStyle == "StandardLight" then
		color3 = v14.Color.Extended.White.White_20.Color3
	else
		color3 = v14.LightMode.ActionOverMedia.Background.Color3
	end

	local transparency

	if v13.ctaStyle == "StandardLight" then
		transparency = v14.Color.Extended.White.White_20.Transparency
	else
		transparency = v14.LightMode.ActionOverMedia.Background.Transparency
	end

	local logoAspectRatio = tonumber(props.logoAspectRatio)
	local aspectRatio = not (logoAspectRatio and logoAspectRatio > 0) and 1 or logoAspectRatio
	local v24 = if aspectRatio == 3 then v2 else v3

	local universeId = props.universeId
	local placeId = props.placeId

	local v25 = useValidTileBadges(universeId, props.topicId, props.badgeOverride)

	local hoverKey = props.hoverKey
	local state, setState = React.useState(false)
	local ref = React.useRef(nil)
	local v26 = useTriggerFeedback()
	local v27 = useOverflowMenuOpen(hoverKey)

	local isHovered = useIsHoveredTile(ref, hoverKey, true)

	local ref2 = React.useRef(false)

	local useCallback = React.useCallback
	local function fn()
		if
			props.isSponsored
			and props.adId
			and not (FFlagLuaAppSduiSponsoredTwoByOneTile and props.disableSponsoredClickRecording)
		then
			sponsoredGamesRecordClick(v9, props.adId)
		end
	end

	local isSponsored = props.isSponsored
	local adId = props.adId
	local v28

	if FFlagLuaAppSduiSponsoredTwoByOneTile then
		v28 = props.disableSponsoredClickRecording
	end

	local v29 = useCallback(fn, { v9, isSponsored, adId, v28 })

	local v30 = React.useCallback(function()
		ref2.current = false
	end, {})

	local useCallback2 = React.useCallback
	local function fn2()
		if FFlagLuaAppSduiSponsoredTwoByOneTile and props.onOpenGameDetails then
			props.onOpenGameDetails()
		else
			local v31 = {
				index = props.index,
				placeIdOverride = props.placeIdOverride,
				experienceJoinData = 0
			}
			local launchData

			if props.launchDataOverride then
				launchData = props.launchDataOverride
			end

			v31.experienceJoinData = {
				launchData = launchData,
				tileType = GameCollectionItemTypes.GameCollectionItemType.TwoByOneTile,
				nativeAdData = props.adId
			}

			v8(universeId, v31)

			if not FFlagLuaAppSduiSponsoredTwoByOneTile then
				TwoByOneGameTileTelemetry.logTwoByOneTileViewGameDetailsActivated()
			end

			if props.reportGameDetailOpened then
				props.reportGameDetailOpened(props.index, universeId)
			end
		end

		if FFlagLuaAppSduiSponsoredTwoByOneTile then
			TwoByOneGameTileTelemetry.logTwoByOneTileViewGameDetailsActivated()
		end
	end

	local index = props.index
	local placeIdOverride = props.placeIdOverride
	local launchDataOverride = props.launchDataOverride
	local reportGameDetailOpened = props.reportGameDetailOpened
	local adId2 = props.adId
	local v31

	if FFlagLuaAppSduiSponsoredTwoByOneTile then
		v31 = props.onOpenGameDetails
	end

	local v32 = useCallback2(fn2, {
		v8,
		universeId,
		index,
		placeIdOverride,
		launchDataOverride,
		reportGameDetailOpened,
		adId2,
		v31
	})

	local v39 = React.useCallback(function()
		setState(true)

		if props.onSelectionGained then
			props.onSelectionGained()
		end
	end, { props.onSelectionGained })

	local v40 = React.useCallback(function()
		setState(false)

		if props.onSelectionLost then
			props.onSelectionLost()
		end
	end, { props.onSelectionLost })

	local isSponsored2 = props.isSponsored
	local useMemo = React.useMemo
	local function fn3()
		local v41 = {
			isSponsored = isSponsored2,
			enableSponsoredFeedback = props.enableSponsoredFeedback,
			enableReportAd = props.enableReportAd,
			enableReportExperience = 0,
			enableExplicitFeedback = 0
		}
		local enableReportExperience

		if FFlagLuaAppEnableReportExperience then
			enableReportExperience = props.enableReportExperience
		end

		v41.enableReportExperience = enableReportExperience

		v41.enableExplicitFeedback = props.enableExplicitFeedback
		return getAvailableGameTileOverflowMenuItems(v41)
	end

	local enableSponsoredFeedback = props.enableSponsoredFeedback
	local enableReportAd = props.enableReportAd
	local v42

	if FFlagLuaAppEnableReportExperience then
		v42 = props.enableReportExperience
	end

	local availableMenuItems = useMemo(fn3, {
		isSponsored2,
		enableSponsoredFeedback,
		enableReportAd,
		v42,
		props.enableExplicitFeedback
	})

	local useCallback3 = React.useCallback
	local function fn4()
		local current = ref2.current
		ref2.current = true

		if FFlagLuaAppSduiSponsoredTwoByOneTile and current == false and props.onTouchLongPress then
			props.onTouchLongPress()
		elseif current == false and next(availableMenuItems) ~= nil then
			if v26 and not v27 then
				local v44 = { universeId = universeId, sortId = props.topicId }

				v26(v, "Press", props.appPage or "Unknown", v44)
			end

			getOverflowMenuSignalStore().openMenu(hoverKey)
		end
	end

	local appPage = props.appPage
	local topicId = props.topicId
	local v45

	if FFlagLuaAppSduiSponsoredTwoByOneTile then
		v45 = props.onTouchLongPress
	end

	local v46 = useCallback3(fn4, {
		hoverKey,
		appPage,
		topicId,
		v26,
		availableMenuItems,
		v27,
		universeId,
		v45
	})

	local reportExperienceLaunched = React.useCallback(function(p: string?)
		if v10 then
			SetGamePlaySession(v10, SessionType.StructuralIdentifier.GamePlayFromHoverTile, true)
		end

		if isHovered then
			HoverTileCoordinator.default:reset()
		end

		if props.reportExperienceLaunched then
			local v48 = {
				placeId = placeId,
				universeId = universeId,
				adId = props.adId,
				tileType = GameCollectionItemTypes.GameCollectionItemType.TwoByOneTile,
				placeIdOverride = props.placeIdOverride,
				launchDataOverride = props.launchDataOverride
			}

			local reportExperienceLaunched = props.reportExperienceLaunched

			local appPage2 = props.appPage
			local twoByOneTile = GameCollectionItemTypes.GameCollectionItemType.TwoByOneTile
			local twoByOneTile2 = GameCollectionItemTypes.GameCollectionItemType.TwoByOneTile
			local index2 = props.index

			if not FFlagLuaAppDemoModePlayButtonTelemetry then
				p = nil
			end

			reportExperienceLaunched(v48, appPage2, twoByOneTile, twoByOneTile2, index2, p)
		end
	end, {
		v10,
		props.reportExperienceLaunched,
		placeId,
		universeId,
		props.appPage,
		props.index,
		props.adId,
		props.placeIdOverride,
		props.launchDataOverride,
		isHovered
	})

	local v48 = usePlayButtonState(v9, universeId)

	local appPage2 = props.appPage

	local v52 = {
		launchData = props.launchDataOverride,
		tileType = GameCollectionItemTypes.GameCollectionItemType.TwoByOneTile,
		nativeAdData = props.adId
	}
	local v53

	if props.placeIdOverride then
		v53 = props.placeIdOverride
	else
		v53 = props.placeId
	end

	local v54 = useOnPlayButtonCallback(universeId, appPage2, "TwoByOneTile", nil, "TwoByOneTile", v52, v53)

	local onActivated = React.useCallback(function()
		TwoByOneGameTileTelemetry.logTwoByOneTileGameJoinInitiated()
		TwoByOneGameTileTelemetry.logTwoByOneTileCtaActivated()
		v29()
	end, { v29 })

	local v56 = React.useCallback(function()
		TwoByOneGameTileTelemetry.logTwoByOneTileCtaActivated()
		v29()
		v32()
	end, { v29, v32 })
	local v57 = React.useCallback(function()
		TwoByOneGameTileTelemetry.logTwoByOneTileGameJoinInitiated()

		v54(v48.playButtonState, reportExperienceLaunched)
	end, { v54, v48.playButtonState, reportExperienceLaunched })

	local v58 = React.useCallback(function()
		if ref2.current then
			ref2.current = false
			return
		end

		if isHovered then
			HoverTileCoordinator.default:reset()
		end

		TwoByOneGameTileTelemetry.logTwoByOneTileActivated()
		v29()

		if v13.onTileActivation == "OpenEdp" then
			v32()
		elseif v13.onTileActivation == "JoinGame" then
			v57()
		end
	end, { isHovered, v13.onTileActivation, v32, v57, v29 })
	local v59

	if not FFlagMigrateGameInfoToStore then
		v59 = useSelector(function(p)
			return p.Personalization[GameInfosReducer.key][universeId]
		end)
	end

	local image

	if FFlagLuaAppHomeThumbnailPrefetch then
		local v62 = {
			placeId = placeId,
			useGridTile = true,
			isEmphasized = true,
			perEntryWideAssetId = 0,
			game = 0,
			topicId = 0
		}
		local perEntryWideAssetId

		if FFlagMigrateGameInfoToStore then
			perEntryWideAssetId = props.wideAssetId
		else
			perEntryWideAssetId = props.primaryWideImageAssetId
		end

		v62.perEntryWideAssetId = perEntryWideAssetId
		local Game

		if not FFlagMigrateGameInfoToStore then
			Game = v59
		end

		v62.game = Game
		v62.topicId = props.topicId
		image = resolveGameTileThumbnailUri(v62)
	elseif FFlagMigrateGameInfoToStore then
		image = formatExperienceThumbnail(props.wideAssetId, placeId, true)
	else
		local gameTileLayoutData = getGameTileLayoutData(v59, props.topicId)
		local v61

		if props.primaryWideImageAssetId then
			v61 = props.primaryWideImageAssetId
		else
			v61 = ItemLayoutDataParsingUtils.getWideImageAssetId(gameTileLayoutData)
		end

		if not v61 then
			if v59 then
				v61 = v59.primaryWideAssetId or nil
			else
				v61 = nil
			end
		end

		image = formatExperienceThumbnail(v61, placeId, true)
	end

	local text

	if FFlagMigrateGameInfoToStore then
		text = props.ageRatingLabel
	else
		text = v59 and v59.ageRecommendationDisplayName or nil
	end

	local ref3 = React.useRef(nil)
	React.useEffect(function()
		ImpressionsTagUtility.AddTag(ref3, props.impressionsTag, props.index)
		return function()
			ImpressionsTagUtility.RemoveTag(ref3, props.impressionsTag, props.index)
		end
	end, { props.impressionsTag, props.index })

	useTagAsViewportAutoplayCandidate(ref3, props.videoPlaybackContext, not FFlagLuaAppTileVideoCandidateOnly and nil)

	useTagAsSponsoredAdViewabilityCandidate(
		ref3,
		props.isSponsored and props.adId ~= nil and not props.isHidden and {
			encryptedAdTrackingData = props.adId,
			tileType = GameCollectionItemTypes.GameCollectionItemType.TwoByOneTile,
			mediaType = "image"
		} or nil
	)

	if props.isHidden then
		local createElement = React.createElement
		local size

		if FFlagLuaAppSduiSponsoredTwoByOneTile then
			size = props.rootSize
		end

		local v64 = {
			Size = size,
			LayoutOrder = props.layoutOrder,
			ZIndex = props.zIndex,
			BackgroundTransparency = 1,
			ref = ref3
		}

		local createElement2 = React.createElement
		local v68 = {
			Size = props.size or UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			ref = ref,
			Selectable = false,
			SelectionOrder = props.SelectionOrder
		}
		local hiddenTileContent

		if FFlagLuaAppSduiSponsoredTwoByOneTile and props.renderHiddenState then
			hiddenTileContent = props.renderHiddenState(ref)
		else
			hiddenTileContent = React.createElement(HiddenTileContent, {
				appPage = props.appPage,
				collectionId = props.topicId,
				setGameHidden = props.setGameHidden,
				universeId = universeId,
				parentRef = ref,
				isSponsored = isSponsored2
			})
		end

		return createElement("Frame", v64, {
			TwoByOneTileContainer = createElement2("TextButton", v68, {
				HiddenTileContent = hiddenTileContent
			})
		})
	else
		local createElement = React.createElement
		local size

		if FFlagLuaAppSduiSponsoredTwoByOneTile then
			size = props.rootSize
		end

		local v64 = {
			Size = size,
			LayoutOrder = props.layoutOrder,
			ZIndex = props.zIndex,
			BackgroundTransparency = 1,
			ref = ref3
		}

		local createElement2 = React.createElement
		local v68 = {
			Size = props.size or UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Text = "",
			AutoButtonColor = false,
			ref = ref,
			SelectionOrder = props.SelectionOrder,
			[React.Event.TouchLongPress] = v46,
			[React.Event.Activated] = v58,
			[React.Event.SelectionGained] = v39,
			[React.Event.SelectionLost] = v40,
			[React.Change.GuiState] = v30
		}
		local children = {
			BackgroundImage = React.createElement("ImageLabel", {
				[React.Tag] = FFlagLuaAppHomePageFirstImageLoadObserver and "observed-image" or nil,
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				Image = image,
				ScaleType = Enum.ScaleType.Crop,
				ZIndex = 0
			}, {
				UICorner = React.createElement("UICorner", { CornerRadius = udim })
			}),
			GradientOverlayLeft = React.createElement("Frame", {
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.new(0, 0, 1, 0),
				Size = UDim2.new(v6, 0, 1, 0),
				BackgroundColor3 = color,
				BackgroundTransparency = 0,
				BorderSizePixel = 0,
				ZIndex = 1
			}, {
				UICorner = React.createElement("UICorner", { CornerRadius = udim }),
				UIGradientLeft = React.createElement("UIGradient", {
					Rotation = 0,
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, v4),
						NumberSequenceKeypoint.new(1, v5)
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
				Size = UDim2.new(1, 0, v6, 0),
				BackgroundColor3 = color,
				BackgroundTransparency = 0,
				BorderSizePixel = 0,
				ZIndex = 1
			}, {
				UICorner = React.createElement("UICorner", { CornerRadius = udim }),
				UIGradientBottom = React.createElement("UIGradient", {
					Rotation = 90,
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, v5),
						NumberSequenceKeypoint.new(1, v4)
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

		if v25 then
			local createElement3 = React.createElement
			local v71 = { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 2 }

			local createElement4 = React.createElement
			local padding

			if FFlagLuaAppSponsoredTileBadgeContentPadding then
				padding = v15
			end

			v25 = createElement3("Frame", v71, {
				Badge = createElement4(GameTileThumbnailBadges, {
					tileBadgesByPosition = v25,
					padding = padding
				})
			})
		end

		children.TileBadge = v25

		local createElement3 = React.createElement
		local v71 = { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 3 }

		local children2 = {
			UIPadding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, v15),
				PaddingRight = UDim.new(0, v15),
				PaddingTop = UDim.new(0, v16),
				PaddingBottom = UDim.new(0, v16)
			}),
			Logo = props.logoImageAssetId and React.createElement(Image, {
				Position = UDim2.new(1, 0, 0, 0),
				AnchorPoint = Vector2.new(1, 0),
				Image = "rbxassetid://" .. tostring(props.logoImageAssetId),
				Size = UDim2.new(1, 0, v24, 0),
				aspectRatio = aspectRatio
			}),
			HeaderFrame = 0,
			JoinButtonContainer = 0,
			ViewGameDetailsButton = 0,
			BottomRightLabel = 0
		}

		local createElement4 = React.createElement
		local v73 = {
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
				Padding = UDim.new(0, v20)
			}),
			Headline = 0,
			Subtitle = 0
		}

		local createElement5 = React.createElement
		local v75 = {
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
		local font

		if not FoundationFontFaceMigration then
			font = v17.Font
		end

		v75.Font = font
		local fontFace

		if FoundationFontFaceMigration then
			fontFace = normalizeFontFace(v17.Font)
		end

		v75.FontFace = fontFace

		v75.TextSize = v17.FontSize
		v75.TextColor3 = color
		v75.TextXAlignment = Enum.TextXAlignment.Left
		v75.TextYAlignment = Enum.TextYAlignment.Top
		children3.Headline = createElement5("TextLabel", v75)

		local createElement6 = React.createElement
		local v79 = {
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
		local font2

		if not FoundationFontFaceMigration then
			font2 = v18.Font
		end

		v79.Font = font2
		local fontFace2

		if FoundationFontFaceMigration then
			fontFace2 = normalizeFontFace(v18.Font)
		end

		v79.FontFace = fontFace2

		v79.TextSize = v18.FontSize
		v79.TextColor3 = color
		v79.TextXAlignment = Enum.TextXAlignment.Left
		v79.TextYAlignment = Enum.TextYAlignment.Top
		children3.Subtitle = createElement6("TextLabel", v79)
		children2.HeaderFrame = createElement4("Frame", v73, children3)
		local joinButtonContainer

		if v13.onCtaActivation == "JoinGame" then
			local createElement7 = React.createElement
			local v84 = {
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 0, 1, 0),
				AnchorPoint = Vector2.new(0, 1)
			}

			local createElement8 = React.createElement
			local v86 = {
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
			local placeId2

			if props.placeIdOverride then
				placeId2 = props.placeIdOverride
			else
				placeId2 = placeId
			end

			v86.placeId = placeId2
			v86.referralSource = props.appPage

			v86.playableText = v12

			v86.buttonSize = buttonSize
			v86.width = width

			v86.onActivated = onActivated
			v86.reportExperienceLaunched = reportExperienceLaunched
			v86.experienceJoinData = props.launchDataOverride and {
				launchData = props.launchDataOverride
			} or nil
			joinButtonContainer = createElement7("Frame", v84, {
				JoinButton = createElement8(PlayButton, v86)
			})
		else
			joinButtonContainer = false
		end

		children2.JoinButtonContainer = joinButtonContainer
		local viewGameDetailsButton

		if v13.onCtaActivation == "OpenEdp" then
			local createElement7 = React.createElement
			local v85 = {}
			v85.Size = UDim2.new(width.Scale, width.Offset, 0, v21)
			v85.Position = UDim2.new(0, 0, 1, 0)
			v85.AnchorPoint = Vector2.new(0, 1)
			v85.BackgroundColor3 = color3
			v85.BackgroundTransparency = transparency
			v85.Text = v12
			v85.TextColor3 = v14.LightMode.ActionOverMedia.Foreground.Color3
			local font3

			if not FoundationFontFaceMigration then
				font3 = v22.Font
			end

			v85.Font = font3
			local fontFace3

			if FoundationFontFaceMigration then
				fontFace3 = normalizeFontFace(v22.Font)
			end

			v85.FontFace = fontFace3

			v85.TextSize = v22.FontSize
			v85[React.Event.Activated] = v56
			viewGameDetailsButton = createElement7("TextButton", v85, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, v14.Radius.Medium)
				})
			})
		else
			viewGameDetailsButton = false
		end

		children2.ViewGameDetailsButton = viewGameDetailsButton

		local createElement7 = React.createElement
		local v85 = {
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(0, 0, 0, v19.FontSize * v19.LineHeight),
			BackgroundTransparency = 1,
			Text = text,
			TextSize = v19.FontSize,
			Font = 0,
			FontFace = 0,
			TextColor3 = 0,
			TextXAlignment = 0,
			TextTruncate = 0,
			AnchorPoint = 0,
			Position = 0
		}
		local font3

		if not FoundationFontFaceMigration then
			font3 = v19.Font
		end

		v85.Font = font3
		local fontFace3

		if FoundationFontFaceMigration then
			fontFace3 = normalizeFontFace(v19.Font)
		end

		v85.FontFace = fontFace3

		v85.TextColor3 = v14.Color.Extended.Gray.Gray_400.Color3
		v85.TextXAlignment = Enum.TextXAlignment.Right
		v85.TextTruncate = Enum.TextTruncate.SplitWord
		v85.AnchorPoint = Vector2.new(1, 1)
		v85.Position = UDim2.new(1, 0, 1, 0)
		children2.BottomRightLabel = createElement7("TextLabel", v85)
		children.ContentOverlay = createElement3("Frame", v71, children2)
		local overflowMenu

		if FFlagLuaAppSduiSponsoredTwoByOneTile and props.renderOverflowMenu then
			overflowMenu = props.renderOverflowMenu({
				isHovered = isHovered,
				isSelected = state,
				menuKey = hoverKey,
				parentRef = ref
			})
		else
			overflowMenu = React.createElement(SpanTileOverflowMenu, {
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
				isHovered = isHovered,
				isSelected = state,
				availableMenuItems = availableMenuItems
			})
		end

		children.OverflowMenu = overflowMenu
		return createElement("Frame", v64, {
			TwoByOneTileContainer = createElement2("TextButton", v68, children)
		})
	end
end
