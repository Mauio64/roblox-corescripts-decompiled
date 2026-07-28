local GameTile = script:FindFirstAncestor("GameTile")
local getGameTileLayoutData = require(GameTile.getGameTileLayoutData)
local formatExperienceThumbnail = require(GameTile.formatExperienceThumbnail)
local useIsHoveredTile = require(GameTile.useIsHoveredTile)
local useNavigateToGameDetails = require(GameTile.useNavigateToGameDetails)
local GameTileOverflowMenu = require(GameTile.GameTileOverflowMenu)
local GameTileThumbnailBadges = require(GameTile.Overlays.GameTileThumbnailBadges)
local getAvailableGameTileOverflowMenuItems = require(GameTile.getAvailableGameTileOverflowMenuItems)
local TwoByOneGameTileTelemetry = require(GameTile.TwoByOneGameTileTelemetry)
local HiddenTileContent = require(GameTile.HiddenGameTile.HiddenTileContent)
local ItemLayoutDataParsingUtils = require(GameTile.ItemLayoutDataParsingUtils)
local HoverTileCoordinator = require(GameTile.HoverTileCoordinator)
local GameTileParent = GameTile.Parent
local React = require(GameTileParent.React)
local Foundation = require(GameTileParent.Foundation)
local ButtonSize = Foundation.Enums.ButtonSize
local useTokens = Foundation.Hooks.useTokens
local FoundationImage = Foundation.Image
local Responsive = require(GameTileParent.Responsive)
local useSelector = require(GameTileParent.RoactUtils).Hooks.RoactRodux.useSelector
local GameInfosReducer = require(GameTileParent.GameInfosRodux).GameInfosReducer
local AppBlox = require(GameTileParent.AppBlox)
local getOverflowMenuSignalStore = AppBlox.getOverflowMenuSignalStore
local useOverflowMenuOpen = AppBlox.useOverflowMenuOpen
local useTriggerFeedback = require(GameTileParent.InteractionFeedback).useTriggerFeedback
local ImpressionsTagUtility = require(GameTileParent.Impressions).ImpressionsTagUtility
local GetTextSize = require(GameTileParent.Style).GetTextSize
local GamePlayButton = require(GameTileParent.GamePlayButton)

require(GameTile.GameTileTypes)

local PlayButton = GamePlayButton.PlayButton
local useOnPlayButtonCallback = require(GameTileParent.GamePlayButton).useOnPlayButtonCallback
local usePlayButtonState = require(GameTileParent.GamePlayButton).usePlayButtonState
local useLocalization = require(GameTileParent.Localization).Hooks.useLocalization
local useRoactService = require(GameTileParent.RobloxAppHooks).useRoactService
local RoactServiceTags = require(GameTileParent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local AppSessionService = RoactServiceTags.AppSessionService
local RobloxAppSessionization = require(GameTileParent.RobloxAppSessionization)
local SetGamePlaySession = RobloxAppSessionization.SetGamePlaySession
local SessionType = RobloxAppSessionization.SessionType
local SharedFlags = require(GameTileParent.SharedFlags)
local DiscoveryAnalytics = require(GameTileParent.DiscoveryAnalytics)
local sponsoredGamesRecordClick = DiscoveryAnalytics.Requests.sponsoredGamesRecordClick
local GameCollectionItemTypes = require(GameTileParent.DiscoveryTypes).GameCollectionItemTypes
local useValidTileBadges = require(GameTile.Overlays.useValidTileBadges)
local useTagAsViewportAutoplayCandidate = require(GameTileParent.VideoUtils).useTagAsViewportAutoplayCandidate
local useTagAsSponsoredAdViewabilityCandidate = require(GameTileParent.SponsoredAdViewability).useTagAsSponsoredAdViewabilityCandidate
local v47 = game:DefineFastInt("LuaAppTwoByOneTileSmallScreenBreakpoint", 600)
local v48 = game:DefineFastInt("LuaAppTwoByOneTileLogoHeightPercentLandscape", 20)
local v49 = game:DefineFastInt("LuaAppTwoByOneTileLogoHeightPercentSquare", 36)
local v50 = game:DefineFastInt("LuaAppTwoByOneTileGradientStartOpacityPercent", 30)
local v51 = game:DefineFastInt("LuaAppTwoByOneTileGradientEndOpacityPercent", 100)
local v52 = game:DefineFastInt("LuaAppTwoByOneTileGradientWidthPercent", 50)
local FFlagLuaAppFixExplicitFeedbackTelemetry = SharedFlags.FFlagLuaAppFixExplicitFeedbackTelemetry
local FFlagLuaAppHomePageFirstImageLoadObserver = SharedFlags.FFlagLuaAppHomePageFirstImageLoadObserver
local FFlagLuaAppHapticTriggeredTelemetry = SharedFlags.FFlagLuaAppHapticTriggeredTelemetry
local FFlagLuaAppFixTwoByOneOverflowMenuTelemetry = SharedFlags.FFlagLuaAppFixTwoByOneOverflowMenuTelemetry
local FFlagLuaAppTileVideoCandidateOnly = SharedFlags.FFlagLuaAppTileVideoCandidateOnly
local FFlagLuaAppFixCustomTileBugs = SharedFlags.FFlagLuaAppFixCustomTileBugs
local FFlagLuaAppSponsoredAdViewabilityEnabled = SharedFlags.FFlagLuaAppSponsoredAdViewabilityEnabled
local FFlagLuaAppDemoModePlayButton = SharedFlags.FFlagLuaAppDemoModePlayButton
local FFlagLuaAppDemoModePlayButtonTelemetry = SharedFlags.FFlagLuaAppDemoModePlayButtonTelemetry
local FFlagLuaAppHomeThumbnailPrefetch = SharedFlags.FFlagLuaAppHomeThumbnailPrefetch
local v63 = if not FFlagLuaAppHomeThumbnailPrefetch then nil else require(GameTile.resolveGameTileThumbnailUri)
local gameTileOverflowMenuAction = DiscoveryAnalytics.Events.gameTileOverflowMenuAction
local color3 = Color3.new(1, 1, 1)
local color3_2 = Color3.new(0, 0, 0)
local v67 = v48 / 100
local v68 = v49 / 100
local v69 = v50 / 100
local v70 = v51 / 100
local v71 = v52 / 100
local _ = {
	JoinGame = "JoinGame",
	OpenEdp = "OpenEdp"
}
local _ = {
	StandardLight = "StandardLight",
	OverMedia = "OverMedia"
}
local t1 = {
	Default = {
		ctaStyle = nil,
		onCtaActivation = "JoinGame",
		onTileActivation = "OpenEdp"
	},
	Variant1 = {
		ctaStyle = nil,
		onCtaActivation = nil,
		onTileActivation = "JoinGame"
	},
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

return function(t2: {[any]: any}) -- line: 169
	-- upvalues: useNavigateToGameDetails (copy), useRoactService (copy), RoactNetworking (copy), AppSessionService (copy), useLocalization (copy), t1 (copy), useTokens (copy), Responsive (copy), v47 (copy), ButtonSize (copy), React (copy), GetTextSize (copy), v67 (copy), v68 (copy), useValidTileBadges (copy), useTriggerFeedback (copy), useOverflowMenuOpen (copy), useIsHoveredTile (copy), sponsoredGamesRecordClick (copy), FFlagLuaAppFixTwoByOneOverflowMenuTelemetry (copy), getOverflowMenuSignalStore (copy), GameCollectionItemTypes (copy), TwoByOneGameTileTelemetry (copy), getAvailableGameTileOverflowMenuItems (copy), FFlagLuaAppFixExplicitFeedbackTelemetry (copy), gameTileOverflowMenuAction (copy), FFlagLuaAppHapticTriggeredTelemetry (copy), SetGamePlaySession (copy), SessionType (copy), HoverTileCoordinator (copy), FFlagLuaAppDemoModePlayButtonTelemetry (copy), usePlayButtonState (copy), useOnPlayButtonCallback (copy), useSelector (copy), GameInfosReducer (copy), FFlagLuaAppHomeThumbnailPrefetch (copy), v63 (copy), getGameTileLayoutData (copy), ItemLayoutDataParsingUtils (copy), formatExperienceThumbnail (copy), ImpressionsTagUtility (copy), useTagAsViewportAutoplayCandidate (copy), FFlagLuaAppTileVideoCandidateOnly (copy), FFlagLuaAppSponsoredAdViewabilityEnabled (copy), useTagAsSponsoredAdViewabilityCandidate (copy), FFlagLuaAppFixCustomTileBugs (copy), HiddenTileContent (copy), FFlagLuaAppHomePageFirstImageLoadObserver (copy), v71 (copy), color3 (copy), v69 (copy), v70 (copy), color3_2 (copy), GameTileThumbnailBadges (copy), FoundationImage (copy), PlayButton (copy), FFlagLuaAppDemoModePlayButton (copy), GameTileOverflowMenu (copy)
	local v76 = useNavigateToGameDetails()
	local v77 = useRoactService(RoactNetworking)
	local v78 = useRoactService(AppSessionService)
	local v79 = useLocalization({
		sponsoredText = "Feature.GamePage.Label.Sponsored",
		joinButtonText = "Common.VisitGame.Label.Play"
	})
	local v80 = if not t2.ctaText then v79.joinButtonText else t2.ctaText
	local v81 = t1[t2.tileVariant] or t1.Default
	local v82 = useTokens()
	local uDim = UDim.new(0, v82.Radius.Medium)
	local Medium, Medium2, TitleLarge, BodySmall, CaptionSmall, XXSmall, Small, Size_800, TitleSmall

	if Responsive.useResponsive({{
		Key = "Smaller",
		maxWidth = v47
	}}) == "Smaller" then
		Medium = v82.Padding.Medium
		Medium2 = v82.Padding.Medium
		TitleLarge = v82.Typography.TitleLarge
		BodySmall = v82.Typography.BodySmall
		CaptionSmall = v82.Typography.CaptionSmall
		XXSmall = v82.Gap.XXSmall
		Small = ButtonSize.Small
		Size_800 = v82.Size.Size_800
		TitleSmall = v82.Typography.TitleSmall
	else
		Medium = v82.Padding.Large
		Medium2 = v82.Padding.Large
		TitleLarge = v82.Typography.HeadingMedium
		BodySmall = v82.Typography.BodyMedium
		CaptionSmall = v82.Typography.CaptionMedium
		XXSmall = v82.Gap.XSmall
		Small = ButtonSize.Medium
		Size_800 = v82.Size.Size_1000
		TitleSmall = v82.Typography.TitleMedium
	end

	local v93 = v82.Padding.Large * 4
	local v94 = React.useMemo(function() -- line: 216
		-- upvalues: GetTextSize (copy), v80 (copy), TitleSmall (ref), v93 (copy)
		local v135 = GetTextSize(v80, TitleSmall.FontSize, TitleSmall.Font, Vector2.new(1e999, 1e999))

		return UDim.new(0, v135.X + v93)
	end, {
		v80,
		TitleSmall,
		v93
	})
	local v95 = if v81.ctaStyle ~= "StandardLight" then v82.LightMode.ActionOverMedia.Background.Color3 else v82.Color.Extended.White.White_20.Color3
	local v96 = if v81.ctaStyle ~= "StandardLight" then v82.LightMode.ActionOverMedia.Background.Transparency else v82.Color.Extended.White.White_20.Transparency
	local num = tonumber(t2.logoAspectRatio)
	local v98 = (not num or not (num > 0)) and 1 or num
	local v99 = if v98 ~= 3 then v68 else v67
	local universeId = t2.universeId
	local placeId = t2.placeId
	local v102 = useValidTileBadges(universeId, t2.topicId, t2.badgeOverride)
	local hoverKey = t2.hoverKey
	local v104, v105 = React.useState(false)
	local v106 = React.useRef(nil)
	local v107 = useTriggerFeedback()
	local v108 = useOverflowMenuOpen(hoverKey)
	local v109 = useIsHoveredTile(v106, hoverKey, true)
	local v110 = React.useRef(false)
	local v111 = React.useCallback(function() -- line: 261
		-- upvalues: t2 (copy), sponsoredGamesRecordClick (copy), v77 (copy)
		if t2.isSponsored and t2.adId then
			sponsoredGamesRecordClick(v77, t2.adId)
		end
	end, {
		v77,
		t2.isSponsored,
		t2.adId
	})
	local v112 = React.useCallback(function() -- line: 267
		-- upvalues: v110 (copy)
		v110.current = false
	end, {})
	local v113 = if not FFlagLuaAppFixTwoByOneOverflowMenuTelemetry then React.useCallback(function() -- line: 273
		-- upvalues: v110 (copy), v107 (copy), t2 (copy), getOverflowMenuSignalStore (copy), hoverKey (copy)
		local current = v110.current

		v110.current = true

		if current == false then
			v107("TwoByOneTileLongPress", "Press", t2.appPage, nil)
			getOverflowMenuSignalStore().openMenu(hoverKey)
		end
	end, {
		hoverKey,
		t2.appPage,
		v107
	}) else nil
	local v114 = React.useCallback(function() -- line: 283
		-- upvalues: t2 (copy), GameCollectionItemTypes (copy), v76 (copy), universeId (copy), TwoByOneGameTileTelemetry (copy)
		local t3 = {
			index = t2.index,
			placeIdOverride = t2.placeIdOverride,
			experienceJoinData = {
				launchData = if not t2.launchDataOverride then nil else t2.launchDataOverride,
				tileType = GameCollectionItemTypes.GameCollectionItemType.TwoByOneTile,
				nativeAdData = t2.adId
			}
		}

		v76(universeId, t3)
		TwoByOneGameTileTelemetry.logTwoByOneTileViewGameDetailsActivated()

		if t2.reportGameDetailOpened then
			t2.reportGameDetailOpened(t2.index, universeId)
		end
	end, {
		v76,
		universeId,
		t2.index,
		t2.placeIdOverride,
		t2.launchDataOverride,
		t2.reportGameDetailOpened,
		t2.adId
	})
	local v115 = React.useCallback(function() -- line: 314
		-- upvalues: v105 (copy), t2 (copy)
		v105(true)

		if t2.onSelectionGained then
			t2.onSelectionGained()
		end
	end, { t2.onSelectionGained })
	local v116 = React.useCallback(function() -- line: 326
		-- upvalues: v105 (copy), t2 (copy)
		v105(false)

		if t2.onSelectionLost then
			t2.onSelectionLost()
		end
	end, { t2.onSelectionLost })
	local isSponsored = t2.isSponsored
	local v118 = React.useMemo(function() -- line: 338
		-- upvalues: getAvailableGameTileOverflowMenuItems (copy), isSponsored (copy), t2 (copy)
		return getAvailableGameTileOverflowMenuItems({
			isSponsored = isSponsored,
			enableSponsoredFeedback = t2.enableSponsoredFeedback,
			enableReportAd = t2.enableReportAd,
			enableExplicitFeedback = t2.enableExplicitFeedback
		})
	end, {
		isSponsored,
		t2.enableSponsoredFeedback,
		t2.enableReportAd,
		t2.enableExplicitFeedback
	})
	local v119 = (v109 or (v104 or v108)) and next(v118) ~= nil
	local v120 = if not FFlagLuaAppFixTwoByOneOverflowMenuTelemetry then nil else React.useCallback(function(b1: boolean, s1: string?) -- line: 350
		-- upvalues: FFlagLuaAppFixExplicitFeedbackTelemetry (copy), t2 (copy), universeId (copy), gameTileOverflowMenuAction (copy)
		local t4 = {
			ctx = if not FFlagLuaAppFixExplicitFeedbackTelemetry then t2.appPage else nil,
			universeId = universeId,
			sortId = t2.topicId,
			actionType = not b1 and "GameTileOverflowMenuOpened" or "GameTileOverflowMenuClosed",
			availableMenuItems = s1
		}

		gameTileOverflowMenuAction(t4, if not FFlagLuaAppFixExplicitFeedbackTelemetry then nil else t2.appPage or "Unknown")
	end, {
		universeId,
		t2.appPage,
		t2.topicId
	})

	if FFlagLuaAppFixTwoByOneOverflowMenuTelemetry then
		v113 = React.useCallback(function() -- line: 370
			-- upvalues: v110 (copy), v118 (copy), v107 (copy), v108 (copy), FFlagLuaAppHapticTriggeredTelemetry (copy), universeId (copy), t2 (copy), getOverflowMenuSignalStore (copy), hoverKey (copy), v120 (copy)
			local current = v110.current

			v110.current = true

			if current == false and next(v118) ~= nil then
				if v107 and not v108 then
					local v142 = if not FFlagLuaAppHapticTriggeredTelemetry then nil else {
						universeId = universeId,
						sortId = t2.topicId
					}

					v107("TwoByOneTileLongPress", "Press", if not FFlagLuaAppHapticTriggeredTelemetry then nil else t2.appPage or "Unknown", if not FFlagLuaAppHapticTriggeredTelemetry then nil else v142)
				end

				getOverflowMenuSignalStore().openMenu(hoverKey)

				local t5 = {}

				for v144, _ in v118 do
					table.insert(t5, v144)
				end

				v120(false, table.concat(t5, ","))
			end
		end, {
			hoverKey,
			t2.appPage,
			t2.topicId,
			v107,
			v118,
			v108,
			universeId,
			v120
		})
	end

	local v121 = React.useCallback(function(s2: string?) -- line: 412
		-- upvalues: v78 (copy), SetGamePlaySession (copy), SessionType (copy), v109 (copy), HoverTileCoordinator (copy), t2 (copy), placeId (copy), universeId (copy), GameCollectionItemTypes (copy), FFlagLuaAppDemoModePlayButtonTelemetry (copy)
		if v78 then
			SetGamePlaySession(v78, SessionType.StructuralIdentifier.GamePlayFromHoverTile, true)
		end

		if v109 then
			HoverTileCoordinator.default:reset()
		end

		if t2.reportExperienceLaunched then
			local t6 = {
				placeId = placeId,
				universeId = universeId,
				adId = t2.adId,
				tileType = GameCollectionItemTypes.GameCollectionItemType.TwoByOneTile,
				placeIdOverride = t2.placeIdOverride,
				launchDataOverride = t2.launchDataOverride
			}

			t2.reportExperienceLaunched(t6, t2.appPage, GameCollectionItemTypes.GameCollectionItemType.TwoByOneTile, GameCollectionItemTypes.GameCollectionItemType.TwoByOneTile, t2.index, if not FFlagLuaAppDemoModePlayButtonTelemetry then nil else s2)
		end
	end, {
		v78,
		t2.reportExperienceLaunched,
		placeId,
		universeId,
		t2.appPage,
		t2.index,
		t2.adId,
		t2.placeIdOverride,
		t2.launchDataOverride,
		v109
	})
	local v122 = usePlayButtonState(v77, universeId)
	local v123 = useOnPlayButtonCallback(universeId, t2.appPage, "TwoByOneTile", nil, "TwoByOneTile", {
		launchData = t2.launchDataOverride,
		tileType = GameCollectionItemTypes.GameCollectionItemType.TwoByOneTile,
		nativeAdData = t2.adId
	}, if not t2.placeIdOverride then t2.placeId else t2.placeIdOverride)
	local v124 = React.useCallback(function() -- line: 470
		-- upvalues: TwoByOneGameTileTelemetry (copy), v111 (copy)
		TwoByOneGameTileTelemetry.logTwoByOneTileGameJoinInitiated()
		TwoByOneGameTileTelemetry.logTwoByOneTileCtaActivated()
		v111()
	end, { v111 })
	local v125 = React.useCallback(function() -- line: 476
		-- upvalues: TwoByOneGameTileTelemetry (copy), v111 (copy), v114 (copy)
		TwoByOneGameTileTelemetry.logTwoByOneTileCtaActivated()
		v111()
		v114()
	end, {
		v111,
		v114
	})
	local v126 = React.useCallback(function() -- line: 482
		-- upvalues: TwoByOneGameTileTelemetry (copy), v123 (copy), v122 (copy), v121 (copy)
		TwoByOneGameTileTelemetry.logTwoByOneTileGameJoinInitiated()
		v123(v122.playButtonState, v121)
	end, {
		v123,
		v122.playButtonState,
		v121
	})
	local v127 = React.useCallback(function() -- line: 494
		-- upvalues: v110 (copy), v109 (copy), HoverTileCoordinator (copy), TwoByOneGameTileTelemetry (copy), v111 (copy), v81 (copy), v114 (copy), v126 (copy)
		if v110.current then
			v110.current = false

			return
		end

		if v109 then
			HoverTileCoordinator.default:reset()
		end

		TwoByOneGameTileTelemetry.logTwoByOneTileActivated()
		v111()

		if v81.onTileActivation == "OpenEdp" then
			v114()

			return
		end

		if v81.onTileActivation == "JoinGame" then
			v126()
		end
	end, {
		v109,
		v81.onTileActivation,
		v114,
		v126,
		v111
	})
	local v128 = useSelector(function(p1) -- line: 522
		-- upvalues: GameInfosReducer (copy), universeId (copy)
		return p1.Personalization[GameInfosReducer.key][universeId]
	end)
	local v129

	if FFlagLuaAppHomeThumbnailPrefetch then
		v129 = v63({
			useGridTile = true,
			isEmphasized = true,
			placeId = placeId,
			perEntryWideAssetId = t2.primaryWideImageAssetId,
			game = v128,
			topicId = t2.topicId
		})
	else
		local v130 = getGameTileLayoutData(v128, t2.topicId)
		local v131 = ((if not t2.primaryWideImageAssetId then ItemLayoutDataParsingUtils.getWideImageAssetId(v130) else t2.primaryWideImageAssetId)) or (v128 and v128.primaryWideAssetId or nil)

		v129 = formatExperienceThumbnail(v131, placeId, true)
	end

	local v132 = v128 and v128.ageRecommendationDisplayName or nil
	local v133 = React.useRef(nil)

	React.useEffect(function() -- line: 548
		-- upvalues: ImpressionsTagUtility (copy), v133 (copy), t2 (copy)
		ImpressionsTagUtility.AddTag(v133, t2.impressionsTag, t2.index)

		return function() -- line: 550
			-- upvalues: ImpressionsTagUtility (copy), v133 (copy), t2 (copy)
			ImpressionsTagUtility.RemoveTag(v133, t2.impressionsTag, t2.index)
		end
	end, {
		t2.impressionsTag,
		t2.index
	})
	useTagAsViewportAutoplayCandidate(v133, t2.videoPlaybackContext, not FFlagLuaAppTileVideoCandidateOnly and nil)

	if FFlagLuaAppSponsoredAdViewabilityEnabled then
		local t7 = nil

		if t2.isSponsored and t2.adId ~= nil and not t2.isHidden then
			t7 = {
				encryptedAdTrackingData = t2.adId,
				tileType = GameCollectionItemTypes.GameCollectionItemType.TwoByOneTile
			}
		end

		useTagAsSponsoredAdViewabilityCandidate(v133, t7)
	end

	if t2.isHidden then
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = t2.layoutOrder,
			ZIndex = t2.zIndex,
			ref = v133
		}, {
			TwoByOneTileContainer = React.createElement("TextButton", {
				BackgroundTransparency = 1,
				Selectable = false,
				Size = t2.size or UDim2.fromScale(1, 1),
				ref = v106,
				SelectionOrder = if not FFlagLuaAppFixCustomTileBugs then nil else t2.SelectionOrder
			}, {
				HiddenTileContent = React.createElement(HiddenTileContent, {
					appPage = t2.appPage,
					collectionId = t2.topicId,
					setGameHidden = t2.setGameHidden,
					universeId = universeId,
					parentRef = v106,
					isSponsored = isSponsored
				})
			})
		})
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = t2.layoutOrder,
		ZIndex = t2.zIndex,
		ref = v133
	}, {
		TwoByOneTileContainer = React.createElement("TextButton", {
			Size = t2.size or UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Text = "",
			AutoButtonColor = false,
			ref = v106,
			SelectionOrder = if not FFlagLuaAppFixCustomTileBugs then nil else t2.SelectionOrder,
			[React.Event.TouchLongPress] = v113,
			[React.Event.Activated] = v127,
			[React.Event.SelectionGained] = v115,
			[React.Event.SelectionLost] = v116,
			[React.Change.GuiState] = v112
		}, {
			BackgroundImage = React.createElement("ImageLabel", {
				[React.Tag] = if not FFlagLuaAppHomePageFirstImageLoadObserver then nil else "observed-image",
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				Image = v129,
				ScaleType = Enum.ScaleType.Crop,
				ZIndex = 0
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = uDim
				})
			}),
			GradientOverlayLeft = React.createElement("Frame", {
				BackgroundTransparency = 0,
				BorderSizePixel = 0,
				ZIndex = 1,
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.new(0, 0, 1, 0),
				Size = UDim2.new(v71, 0, 1, 0),
				BackgroundColor3 = color3
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = uDim
				}),
				UIGradientLeft = React.createElement("UIGradient", {
					Rotation = 0,
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, v69),
						NumberSequenceKeypoint.new(1, v70)
					}),
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, color3_2),
						ColorSequenceKeypoint.new(1, color3_2)
					})
				})
			}),
			GradientOverlayBottom = React.createElement("Frame", {
				BackgroundTransparency = 0,
				BorderSizePixel = 0,
				ZIndex = 1,
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.new(0, 0, 1, 0),
				Size = UDim2.new(1, 0, v71, 0),
				BackgroundColor3 = color3
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = uDim
				}),
				UIGradientBottom = React.createElement("UIGradient", {
					Rotation = 90,
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, v70),
						NumberSequenceKeypoint.new(1, v69)
					}),
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, color3_2),
						ColorSequenceKeypoint.new(1, color3_2)
					})
				})
			}),
			TileBadge = v102 and React.createElement("Frame", {
				BackgroundTransparency = 1,
				ZIndex = 2,
				Size = UDim2.fromScale(1, 1)
			}, {
				Badge = React.createElement(GameTileThumbnailBadges, {
					tileBadgesByPosition = v102
				})
			}),
			ContentOverlay = React.createElement("Frame", {
				BackgroundTransparency = 1,
				ZIndex = 3,
				Size = UDim2.fromScale(1, 1)
			}, {
				UIPadding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, Medium),
					PaddingRight = UDim.new(0, Medium),
					PaddingTop = UDim.new(0, Medium2),
					PaddingBottom = UDim.new(0, Medium2)
				}),
				Logo = t2.logoImageAssetId and React.createElement(FoundationImage, {
					Position = UDim2.new(1, 0, 0, 0),
					AnchorPoint = Vector2.new(1, 0),
					Image = "rbxassetid://" .. tostring(t2.logoImageAssetId),
					Size = UDim2.new(1, 0, v99, 0),
					aspectRatio = v98
				}),
				HeaderFrame = React.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					Position = UDim2.new(0, 0, 0.47, 0),
					AnchorPoint = Vector2.new(0, 0.5)
				}, {
					UIListLayout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, XXSmall)
					}),
					Headline = React.createElement("TextLabel", {
						LayoutOrder = 1,
						BackgroundTransparency = 1,
						TextWrapped = true,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						Text = t2.headline or "",
						Font = TitleLarge.Font,
						TextSize = TitleLarge.FontSize,
						TextColor3 = color3,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top
					}),
					Subtitle = React.createElement("TextLabel", {
						LayoutOrder = 2,
						BackgroundTransparency = 1,
						TextWrapped = true,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						Text = t2.subtitle or "",
						Font = BodySmall.Font,
						TextSize = BodySmall.FontSize,
						TextColor3 = color3,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top
					})
				}),
				JoinButtonContainer = v81.onCtaActivation == "JoinGame" and React.createElement("Frame", {
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.XY,
					Position = UDim2.new(0, 0, 1, 0),
					AnchorPoint = Vector2.new(0, 1)
				}, {
					JoinButton = React.createElement(PlayButton, {
						eventContext = "TwoByOneTile",
						launchSource = "TwoByOneTile",
						hidePlayableIcon = true,
						universeId = universeId,
						placeId = if not t2.placeIdOverride then placeId else t2.placeIdOverride,
						referralSource = t2.appPage,
						playableText = v80,
						buttonSize = Small,
						width = v94,
						preferSecondaryPlayButton = not not FFlagLuaAppDemoModePlayButton or nil,
						onActivated = v124,
						reportExperienceLaunched = v121,
						experienceJoinData = if not t2.launchDataOverride then nil else {
							launchData = t2.launchDataOverride
						}
					})
				}),
				ViewGameDetailsButton = v81.onCtaActivation == "OpenEdp" and React.createElement("TextButton", {
					Size = UDim2.new(v94.Scale, v94.Offset, 0, Size_800),
					Position = UDim2.new(0, 0, 1, 0),
					AnchorPoint = Vector2.new(0, 1),
					BackgroundColor3 = v95,
					BackgroundTransparency = v96,
					Text = v80,
					TextColor3 = v82.LightMode.ActionOverMedia.Foreground.Color3,
					Font = TitleSmall.Font,
					TextSize = TitleSmall.FontSize,
					[React.Event.Activated] = v125
				}, {
					UICorner = React.createElement("UICorner", {
						CornerRadius = UDim.new(0, v82.Radius.Medium)
					})
				}),
				BottomRightLabel = React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2.new(0, 0, 0, CaptionSmall.FontSize * CaptionSmall.LineHeight),
					Text = v132,
					TextSize = CaptionSmall.FontSize,
					Font = CaptionSmall.Font,
					TextColor3 = v82.Color.Extended.Gray.Gray_400.Color3,
					TextXAlignment = Enum.TextXAlignment.Right,
					TextTruncate = Enum.TextTruncate.SplitWord,
					AnchorPoint = Vector2.new(1, 1),
					Position = UDim2.new(1, 0, 1, 0)
				})
			}),
			OverflowMenuContainer = v119 and React.createElement("Frame", {
				BackgroundTransparency = 1,
				ZIndex = 4,
				Size = UDim2.fromScale(1, 1)
			}, {
				OverflowMenu = React.createElement(GameTileOverflowMenu, {
					isHovered = v109,
					isSelected = if not FFlagLuaAppFixTwoByOneOverflowMenuTelemetry then nil else v104,
					universeId = universeId,
					collectionId = t2.topicId,
					appPage = t2.appPage,
					setGameHidden = t2.setGameHidden or function() -- line: 829
					end,
					menuKey = hoverKey,
					menuOpen = v108,
					onMenuOpenChanged = if not FFlagLuaAppFixTwoByOneOverflowMenuTelemetry then nil else v120,
					parentRef = v106,
					isSponsored = t2.isSponsored,
					payerName = t2.payerName,
					sponsoredUserCohort = t2.sponsoredUserCohort,
					adId = t2.adId,
					availableMenuItems = v118
				})
			})
		})
	})
end
