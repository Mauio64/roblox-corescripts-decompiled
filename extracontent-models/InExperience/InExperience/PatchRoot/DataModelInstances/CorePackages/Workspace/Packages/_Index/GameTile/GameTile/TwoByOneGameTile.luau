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
local FFlagLuaAppTileVideoCandidateOnly = SharedFlags.FFlagLuaAppTileVideoCandidateOnly
local FFlagLuaAppSponsoredAdViewabilityEnabled = SharedFlags.FFlagLuaAppSponsoredAdViewabilityEnabled
local FFlagLuaAppDemoModePlayButton = SharedFlags.FFlagLuaAppDemoModePlayButton
local FFlagLuaAppDemoModePlayButtonTelemetry = SharedFlags.FFlagLuaAppDemoModePlayButtonTelemetry
local FFlagLuaAppHomeThumbnailPrefetch = SharedFlags.FFlagLuaAppHomeThumbnailPrefetch
local v61 = if not FFlagLuaAppHomeThumbnailPrefetch then nil else require(GameTile.resolveGameTileThumbnailUri)
local gameTileOverflowMenuAction = DiscoveryAnalytics.Events.gameTileOverflowMenuAction
local color3 = Color3.new(1, 1, 1)
local color3_2 = Color3.new(0, 0, 0)
local v65 = v48 / 100
local v66 = v49 / 100
local v67 = v50 / 100
local v68 = v51 / 100
local v69 = v52 / 100
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

return function(t2: {[any]: any}) -- line: 167
	-- upvalues: useNavigateToGameDetails (copy), useRoactService (copy), RoactNetworking (copy), AppSessionService (copy), useLocalization (copy), t1 (copy), useTokens (copy), Responsive (copy), v47 (copy), ButtonSize (copy), React (copy), GetTextSize (copy), v65 (copy), v66 (copy), useValidTileBadges (copy), useTriggerFeedback (copy), useOverflowMenuOpen (copy), useIsHoveredTile (copy), sponsoredGamesRecordClick (copy), GameCollectionItemTypes (copy), TwoByOneGameTileTelemetry (copy), getAvailableGameTileOverflowMenuItems (copy), FFlagLuaAppFixExplicitFeedbackTelemetry (copy), gameTileOverflowMenuAction (copy), FFlagLuaAppHapticTriggeredTelemetry (copy), getOverflowMenuSignalStore (copy), SetGamePlaySession (copy), SessionType (copy), HoverTileCoordinator (copy), FFlagLuaAppDemoModePlayButtonTelemetry (copy), usePlayButtonState (copy), useOnPlayButtonCallback (copy), useSelector (copy), GameInfosReducer (copy), FFlagLuaAppHomeThumbnailPrefetch (copy), v61 (copy), getGameTileLayoutData (copy), ItemLayoutDataParsingUtils (copy), formatExperienceThumbnail (copy), ImpressionsTagUtility (copy), useTagAsViewportAutoplayCandidate (copy), FFlagLuaAppTileVideoCandidateOnly (copy), FFlagLuaAppSponsoredAdViewabilityEnabled (copy), useTagAsSponsoredAdViewabilityCandidate (copy), HiddenTileContent (copy), FFlagLuaAppHomePageFirstImageLoadObserver (copy), v69 (copy), color3 (copy), v67 (copy), v68 (copy), color3_2 (copy), GameTileThumbnailBadges (copy), FoundationImage (copy), PlayButton (copy), FFlagLuaAppDemoModePlayButton (copy), GameTileOverflowMenu (copy)
	local v74 = useNavigateToGameDetails()
	local v75 = useRoactService(RoactNetworking)
	local v76 = useRoactService(AppSessionService)
	local v77 = useLocalization({
		sponsoredText = "Feature.GamePage.Label.Sponsored",
		joinButtonText = "Common.VisitGame.Label.Play"
	})
	local v78 = if not t2.ctaText then v77.joinButtonText else t2.ctaText
	local v79 = t1[t2.tileVariant] or t1.Default
	local v80 = useTokens()
	local uDim = UDim.new(0, v80.Radius.Medium)
	local Medium, Medium2, TitleLarge, BodySmall, CaptionSmall, XXSmall, Small, Size_800, TitleSmall

	if Responsive.useResponsive({{
		Key = "Smaller",
		maxWidth = v47
	}}) == "Smaller" then
		Medium = v80.Padding.Medium
		Medium2 = v80.Padding.Medium
		TitleLarge = v80.Typography.TitleLarge
		BodySmall = v80.Typography.BodySmall
		CaptionSmall = v80.Typography.CaptionSmall
		XXSmall = v80.Gap.XXSmall
		Small = ButtonSize.Small
		Size_800 = v80.Size.Size_800
		TitleSmall = v80.Typography.TitleSmall
	else
		Medium = v80.Padding.Large
		Medium2 = v80.Padding.Large
		TitleLarge = v80.Typography.HeadingMedium
		BodySmall = v80.Typography.BodyMedium
		CaptionSmall = v80.Typography.CaptionMedium
		XXSmall = v80.Gap.XSmall
		Small = ButtonSize.Medium
		Size_800 = v80.Size.Size_1000
		TitleSmall = v80.Typography.TitleMedium
	end

	local v91 = v80.Padding.Large * 4
	local v92 = React.useMemo(function() -- line: 214
		-- upvalues: GetTextSize (copy), v78 (copy), TitleSmall (ref), v91 (copy)
		local v133 = GetTextSize(v78, TitleSmall.FontSize, TitleSmall.Font, Vector2.new(1e999, 1e999))

		return UDim.new(0, v133.X + v91)
	end, {
		v78,
		TitleSmall,
		v91
	})
	local v93 = if v79.ctaStyle ~= "StandardLight" then v80.LightMode.ActionOverMedia.Background.Color3 else v80.Color.Extended.White.White_20.Color3
	local v94 = if v79.ctaStyle ~= "StandardLight" then v80.LightMode.ActionOverMedia.Background.Transparency else v80.Color.Extended.White.White_20.Transparency
	local num = tonumber(t2.logoAspectRatio)
	local v96 = (not num or not (num > 0)) and 1 or num
	local v97 = if v96 ~= 3 then v66 else v65
	local universeId = t2.universeId
	local placeId = t2.placeId
	local v100 = useValidTileBadges(universeId, t2.topicId, t2.badgeOverride)
	local hoverKey = t2.hoverKey
	local v102, v103 = React.useState(false)
	local v104 = React.useRef(nil)
	local v105 = useTriggerFeedback()
	local v106 = useOverflowMenuOpen(hoverKey)
	local v107 = useIsHoveredTile(v104, hoverKey, true)
	local v108 = React.useRef(false)
	local v109 = React.useCallback(function() -- line: 259
		-- upvalues: t2 (copy), sponsoredGamesRecordClick (copy), v75 (copy)
		if t2.isSponsored and t2.adId then
			sponsoredGamesRecordClick(v75, t2.adId)
		end
	end, {
		v75,
		t2.isSponsored,
		t2.adId
	})
	local v110 = React.useCallback(function() -- line: 265
		-- upvalues: v108 (copy)
		v108.current = false
	end, {})
	local v111 = React.useCallback(function() -- line: 270
		-- upvalues: t2 (copy), GameCollectionItemTypes (copy), v74 (copy), universeId (copy), TwoByOneGameTileTelemetry (copy)
		local t3 = {
			index = t2.index,
			placeIdOverride = t2.placeIdOverride,
			experienceJoinData = {
				launchData = if not t2.launchDataOverride then nil else t2.launchDataOverride,
				tileType = GameCollectionItemTypes.GameCollectionItemType.TwoByOneTile,
				nativeAdData = t2.adId
			}
		}

		v74(universeId, t3)
		TwoByOneGameTileTelemetry.logTwoByOneTileViewGameDetailsActivated()

		if t2.reportGameDetailOpened then
			t2.reportGameDetailOpened(t2.index, universeId)
		end
	end, {
		v74,
		universeId,
		t2.index,
		t2.placeIdOverride,
		t2.launchDataOverride,
		t2.reportGameDetailOpened,
		t2.adId
	})
	local v112 = React.useCallback(function() -- line: 301
		-- upvalues: v103 (copy), t2 (copy)
		v103(true)

		if t2.onSelectionGained then
			t2.onSelectionGained()
		end
	end, { t2.onSelectionGained })
	local v113 = React.useCallback(function() -- line: 313
		-- upvalues: v103 (copy), t2 (copy)
		v103(false)

		if t2.onSelectionLost then
			t2.onSelectionLost()
		end
	end, { t2.onSelectionLost })
	local isSponsored = t2.isSponsored
	local v115 = React.useMemo(function() -- line: 325
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
	local v116 = (v107 or (v102 or v106)) and next(v115) ~= nil
	local v117 = React.useCallback(function(b1: boolean, s1: string?) -- line: 337
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
	local v118 = React.useCallback(function() -- line: 357
		-- upvalues: v108 (copy), v115 (copy), v105 (copy), v106 (copy), FFlagLuaAppHapticTriggeredTelemetry (copy), universeId (copy), t2 (copy), getOverflowMenuSignalStore (copy), hoverKey (copy), v117 (copy)
		local current = v108.current

		v108.current = true

		if current == false and next(v115) ~= nil then
			if v105 and not v106 then
				local v139 = if not FFlagLuaAppHapticTriggeredTelemetry then nil else {
					universeId = universeId,
					sortId = t2.topicId
				}

				v105("TwoByOneTileLongPress", "Press", if not FFlagLuaAppHapticTriggeredTelemetry then nil else t2.appPage or "Unknown", if not FFlagLuaAppHapticTriggeredTelemetry then nil else v139)
			end

			getOverflowMenuSignalStore().openMenu(hoverKey)

			local t5 = {}

			for v141, _ in v115 do
				table.insert(t5, v141)
			end

			v117(false, table.concat(t5, ","))
		end
	end, {
		hoverKey,
		t2.appPage,
		t2.topicId,
		v105,
		v115,
		v106,
		universeId,
		v117
	})
	local v119 = React.useCallback(function(s2: string?) -- line: 398
		-- upvalues: v76 (copy), SetGamePlaySession (copy), SessionType (copy), v107 (copy), HoverTileCoordinator (copy), t2 (copy), placeId (copy), universeId (copy), GameCollectionItemTypes (copy), FFlagLuaAppDemoModePlayButtonTelemetry (copy)
		if v76 then
			SetGamePlaySession(v76, SessionType.StructuralIdentifier.GamePlayFromHoverTile, true)
		end

		if v107 then
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
		v76,
		t2.reportExperienceLaunched,
		placeId,
		universeId,
		t2.appPage,
		t2.index,
		t2.adId,
		t2.placeIdOverride,
		t2.launchDataOverride,
		v107
	})
	local v120 = usePlayButtonState(v75, universeId)
	local v121 = useOnPlayButtonCallback(universeId, t2.appPage, "TwoByOneTile", nil, "TwoByOneTile", {
		launchData = t2.launchDataOverride,
		tileType = GameCollectionItemTypes.GameCollectionItemType.TwoByOneTile,
		nativeAdData = t2.adId
	}, if not t2.placeIdOverride then t2.placeId else t2.placeIdOverride)
	local v122 = React.useCallback(function() -- line: 456
		-- upvalues: TwoByOneGameTileTelemetry (copy), v109 (copy)
		TwoByOneGameTileTelemetry.logTwoByOneTileGameJoinInitiated()
		TwoByOneGameTileTelemetry.logTwoByOneTileCtaActivated()
		v109()
	end, { v109 })
	local v123 = React.useCallback(function() -- line: 462
		-- upvalues: TwoByOneGameTileTelemetry (copy), v109 (copy), v111 (copy)
		TwoByOneGameTileTelemetry.logTwoByOneTileCtaActivated()
		v109()
		v111()
	end, {
		v109,
		v111
	})
	local v124 = React.useCallback(function() -- line: 468
		-- upvalues: TwoByOneGameTileTelemetry (copy), v121 (copy), v120 (copy), v119 (copy)
		TwoByOneGameTileTelemetry.logTwoByOneTileGameJoinInitiated()
		v121(v120.playButtonState, v119)
	end, {
		v121,
		v120.playButtonState,
		v119
	})
	local v125 = React.useCallback(function() -- line: 480
		-- upvalues: v108 (copy), v107 (copy), HoverTileCoordinator (copy), TwoByOneGameTileTelemetry (copy), v109 (copy), v79 (copy), v111 (copy), v124 (copy)
		if v108.current then
			v108.current = false

			return
		end

		if v107 then
			HoverTileCoordinator.default:reset()
		end

		TwoByOneGameTileTelemetry.logTwoByOneTileActivated()
		v109()

		if v79.onTileActivation == "OpenEdp" then
			v111()

			return
		end

		if v79.onTileActivation == "JoinGame" then
			v124()
		end
	end, {
		v107,
		v79.onTileActivation,
		v111,
		v124,
		v109
	})
	local v126 = useSelector(function(p1) -- line: 508
		-- upvalues: GameInfosReducer (copy), universeId (copy)
		return p1.Personalization[GameInfosReducer.key][universeId]
	end)
	local v127

	if FFlagLuaAppHomeThumbnailPrefetch then
		v127 = v61({
			useGridTile = true,
			isEmphasized = true,
			placeId = placeId,
			perEntryWideAssetId = t2.primaryWideImageAssetId,
			game = v126,
			topicId = t2.topicId
		})
	else
		local v128 = getGameTileLayoutData(v126, t2.topicId)
		local v129 = ((if not t2.primaryWideImageAssetId then ItemLayoutDataParsingUtils.getWideImageAssetId(v128) else t2.primaryWideImageAssetId)) or (v126 and v126.primaryWideAssetId or nil)

		v127 = formatExperienceThumbnail(v129, placeId, true)
	end

	local v130 = v126 and v126.ageRecommendationDisplayName or nil
	local v131 = React.useRef(nil)

	React.useEffect(function() -- line: 534
		-- upvalues: ImpressionsTagUtility (copy), v131 (copy), t2 (copy)
		ImpressionsTagUtility.AddTag(v131, t2.impressionsTag, t2.index)

		return function() -- line: 536
			-- upvalues: ImpressionsTagUtility (copy), v131 (copy), t2 (copy)
			ImpressionsTagUtility.RemoveTag(v131, t2.impressionsTag, t2.index)
		end
	end, {
		t2.impressionsTag,
		t2.index
	})
	useTagAsViewportAutoplayCandidate(v131, t2.videoPlaybackContext, not FFlagLuaAppTileVideoCandidateOnly and nil)

	if FFlagLuaAppSponsoredAdViewabilityEnabled then
		local t7 = nil

		if t2.isSponsored and t2.adId ~= nil and not t2.isHidden then
			t7 = {
				encryptedAdTrackingData = t2.adId,
				tileType = GameCollectionItemTypes.GameCollectionItemType.TwoByOneTile
			}
		end

		useTagAsSponsoredAdViewabilityCandidate(v131, t7)
	end

	if t2.isHidden then
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = t2.layoutOrder,
			ZIndex = t2.zIndex,
			ref = v131
		}, {
			TwoByOneTileContainer = React.createElement("TextButton", {
				BackgroundTransparency = 1,
				Selectable = false,
				Size = t2.size or UDim2.fromScale(1, 1),
				ref = v104,
				SelectionOrder = t2.SelectionOrder
			}, {
				HiddenTileContent = React.createElement(HiddenTileContent, {
					appPage = t2.appPage,
					collectionId = t2.topicId,
					setGameHidden = t2.setGameHidden,
					universeId = universeId,
					parentRef = v104,
					isSponsored = isSponsored
				})
			})
		})
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = t2.layoutOrder,
		ZIndex = t2.zIndex,
		ref = v131
	}, {
		TwoByOneTileContainer = React.createElement("TextButton", {
			Size = t2.size or UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Text = "",
			AutoButtonColor = false,
			ref = v104,
			SelectionOrder = t2.SelectionOrder,
			[React.Event.TouchLongPress] = v118,
			[React.Event.Activated] = v125,
			[React.Event.SelectionGained] = v112,
			[React.Event.SelectionLost] = v113,
			[React.Change.GuiState] = v110
		}, {
			BackgroundImage = React.createElement("ImageLabel", {
				[React.Tag] = if not FFlagLuaAppHomePageFirstImageLoadObserver then nil else "observed-image",
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				Image = v127,
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
				Size = UDim2.new(v69, 0, 1, 0),
				BackgroundColor3 = color3
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = uDim
				}),
				UIGradientLeft = React.createElement("UIGradient", {
					Rotation = 0,
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, v67),
						NumberSequenceKeypoint.new(1, v68)
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
				Size = UDim2.new(1, 0, v69, 0),
				BackgroundColor3 = color3
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = uDim
				}),
				UIGradientBottom = React.createElement("UIGradient", {
					Rotation = 90,
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, v68),
						NumberSequenceKeypoint.new(1, v67)
					}),
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, color3_2),
						ColorSequenceKeypoint.new(1, color3_2)
					})
				})
			}),
			TileBadge = v100 and React.createElement("Frame", {
				BackgroundTransparency = 1,
				ZIndex = 2,
				Size = UDim2.fromScale(1, 1)
			}, {
				Badge = React.createElement(GameTileThumbnailBadges, {
					tileBadgesByPosition = v100
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
					Size = UDim2.new(1, 0, v97, 0),
					aspectRatio = v96
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
				JoinButtonContainer = v79.onCtaActivation == "JoinGame" and React.createElement("Frame", {
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
						playableText = v78,
						buttonSize = Small,
						width = v92,
						preferSecondaryPlayButton = not not FFlagLuaAppDemoModePlayButton or nil,
						onActivated = v122,
						reportExperienceLaunched = v119,
						experienceJoinData = if not t2.launchDataOverride then nil else {
							launchData = t2.launchDataOverride
						}
					})
				}),
				ViewGameDetailsButton = v79.onCtaActivation == "OpenEdp" and React.createElement("TextButton", {
					Size = UDim2.new(v92.Scale, v92.Offset, 0, Size_800),
					Position = UDim2.new(0, 0, 1, 0),
					AnchorPoint = Vector2.new(0, 1),
					BackgroundColor3 = v93,
					BackgroundTransparency = v94,
					Text = v78,
					TextColor3 = v80.LightMode.ActionOverMedia.Foreground.Color3,
					Font = TitleSmall.Font,
					TextSize = TitleSmall.FontSize,
					[React.Event.Activated] = v123
				}, {
					UICorner = React.createElement("UICorner", {
						CornerRadius = UDim.new(0, v80.Radius.Medium)
					})
				}),
				BottomRightLabel = React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2.new(0, 0, 0, CaptionSmall.FontSize * CaptionSmall.LineHeight),
					Text = v130,
					TextSize = CaptionSmall.FontSize,
					Font = CaptionSmall.Font,
					TextColor3 = v80.Color.Extended.Gray.Gray_400.Color3,
					TextXAlignment = Enum.TextXAlignment.Right,
					TextTruncate = Enum.TextTruncate.SplitWord,
					AnchorPoint = Vector2.new(1, 1),
					Position = UDim2.new(1, 0, 1, 0)
				})
			}),
			OverflowMenuContainer = v116 and React.createElement("Frame", {
				BackgroundTransparency = 1,
				ZIndex = 4,
				Size = UDim2.fromScale(1, 1)
			}, {
				OverflowMenu = React.createElement(GameTileOverflowMenu, {
					isHovered = v107,
					isSelected = v102,
					universeId = universeId,
					collectionId = t2.topicId,
					appPage = t2.appPage,
					setGameHidden = t2.setGameHidden or function() -- line: 815
					end,
					menuKey = hoverKey,
					menuOpen = v106,
					onMenuOpenChanged = v117,
					parentRef = v104,
					isSponsored = t2.isSponsored,
					payerName = t2.payerName,
					sponsoredUserCohort = t2.sponsoredUserCohort,
					adId = t2.adId,
					availableMenuItems = v115
				})
			})
		})
	})
end
