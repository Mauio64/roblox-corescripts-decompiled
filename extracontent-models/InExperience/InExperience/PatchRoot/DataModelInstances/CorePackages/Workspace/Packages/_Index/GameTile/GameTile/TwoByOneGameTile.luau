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
local FFlagLuaAppSupportSponsoredExplicitFeedback = SharedFlags.FFlagLuaAppSupportSponsoredExplicitFeedback
local FFlagLuaAppFixExplicitFeedbackTelemetry = SharedFlags.FFlagLuaAppFixExplicitFeedbackTelemetry
local FFlagLuaAppHomePageFirstImageLoadObserver = SharedFlags.FFlagLuaAppHomePageFirstImageLoadObserver
local FFlagLuaAppHapticTriggeredTelemetry = SharedFlags.FFlagLuaAppHapticTriggeredTelemetry
local FFlagLuaAppFixTwoByOneOverflowMenuTelemetry = SharedFlags.FFlagLuaAppFixTwoByOneOverflowMenuTelemetry
local FFlagLuaAppTileVideoCandidateOnly = SharedFlags.FFlagLuaAppTileVideoCandidateOnly
local FFlagLuaAppFixCustomTileBugs = SharedFlags.FFlagLuaAppFixCustomTileBugs
local FFlagLuaAppSponsoredAdViewabilityEnabled = SharedFlags.FFlagLuaAppSponsoredAdViewabilityEnabled
local FFlagLuaAppDemoModePlayButton = SharedFlags.FFlagLuaAppDemoModePlayButton
local FFlagLuaAppDemoModePlayButtonTelemetry = SharedFlags.FFlagLuaAppDemoModePlayButtonTelemetry
local gameTileOverflowMenuAction = DiscoveryAnalytics.Events.gameTileOverflowMenuAction
local color3 = Color3.new(1, 1, 1)
local color3_2 = Color3.new(0, 0, 0)
local v66 = v48 / 100
local v67 = v49 / 100
local v68 = v50 / 100
local v69 = v51 / 100
local v70 = v52 / 100
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

return function(t2: {[any]: any}) -- line: 166
	-- upvalues: useNavigateToGameDetails (copy), useRoactService (copy), RoactNetworking (copy), AppSessionService (copy), useLocalization (copy), t1 (copy), useTokens (copy), Responsive (copy), v47 (copy), ButtonSize (copy), React (copy), GetTextSize (copy), v66 (copy), v67 (copy), useValidTileBadges (copy), useTriggerFeedback (copy), useOverflowMenuOpen (copy), useIsHoveredTile (copy), sponsoredGamesRecordClick (copy), FFlagLuaAppFixTwoByOneOverflowMenuTelemetry (copy), getOverflowMenuSignalStore (copy), GameCollectionItemTypes (copy), TwoByOneGameTileTelemetry (copy), getAvailableGameTileOverflowMenuItems (copy), FFlagLuaAppSupportSponsoredExplicitFeedback (copy), FFlagLuaAppFixExplicitFeedbackTelemetry (copy), gameTileOverflowMenuAction (copy), FFlagLuaAppHapticTriggeredTelemetry (copy), SetGamePlaySession (copy), SessionType (copy), HoverTileCoordinator (copy), FFlagLuaAppDemoModePlayButtonTelemetry (copy), usePlayButtonState (copy), useOnPlayButtonCallback (copy), useSelector (copy), GameInfosReducer (copy), getGameTileLayoutData (copy), ItemLayoutDataParsingUtils (copy), formatExperienceThumbnail (copy), ImpressionsTagUtility (copy), useTagAsViewportAutoplayCandidate (copy), FFlagLuaAppTileVideoCandidateOnly (copy), FFlagLuaAppSponsoredAdViewabilityEnabled (copy), useTagAsSponsoredAdViewabilityCandidate (copy), FFlagLuaAppFixCustomTileBugs (copy), HiddenTileContent (copy), FFlagLuaAppHomePageFirstImageLoadObserver (copy), v70 (copy), color3 (copy), v68 (copy), v69 (copy), color3_2 (copy), GameTileThumbnailBadges (copy), FoundationImage (copy), PlayButton (copy), FFlagLuaAppDemoModePlayButton (copy), GameTileOverflowMenu (copy)
	local v75 = useNavigateToGameDetails()
	local v76 = useRoactService(RoactNetworking)
	local v77 = useRoactService(AppSessionService)
	local v78 = useLocalization({
		sponsoredText = "Feature.GamePage.Label.Sponsored",
		joinButtonText = "Common.VisitGame.Label.Play"
	})
	local v79 = if not t2.ctaText then v78.joinButtonText else t2.ctaText
	local v80 = t1[t2.tileVariant] or t1.Default
	local v81 = useTokens()
	local uDim = UDim.new(0, v81.Radius.Medium)
	local Medium, Medium2, TitleLarge, BodySmall, CaptionSmall, XXSmall, Small, Size_800, TitleSmall

	if Responsive.useResponsive({{
		Key = "Smaller",
		maxWidth = v47
	}}) == "Smaller" then
		Medium = v81.Padding.Medium
		Medium2 = v81.Padding.Medium
		TitleLarge = v81.Typography.TitleLarge
		BodySmall = v81.Typography.BodySmall
		CaptionSmall = v81.Typography.CaptionSmall
		XXSmall = v81.Gap.XXSmall
		Small = ButtonSize.Small
		Size_800 = v81.Size.Size_800
		TitleSmall = v81.Typography.TitleSmall
	else
		Medium = v81.Padding.Large
		Medium2 = v81.Padding.Large
		TitleLarge = v81.Typography.HeadingMedium
		BodySmall = v81.Typography.BodyMedium
		CaptionSmall = v81.Typography.CaptionMedium
		XXSmall = v81.Gap.XSmall
		Small = ButtonSize.Medium
		Size_800 = v81.Size.Size_1000
		TitleSmall = v81.Typography.TitleMedium
	end

	local v92 = v81.Padding.Large * 4
	local v93 = React.useMemo(function() -- line: 213
		-- upvalues: GetTextSize (copy), v79 (copy), TitleSmall (ref), v92 (copy)
		local v134 = GetTextSize(v79, TitleSmall.FontSize, TitleSmall.Font, Vector2.new(1e999, 1e999))

		return UDim.new(0, v134.X + v92)
	end, {
		v79,
		TitleSmall,
		v92
	})
	local v94 = if v80.ctaStyle ~= "StandardLight" then v81.LightMode.ActionOverMedia.Background.Color3 else v81.Color.Extended.White.White_20.Color3
	local v95 = if v80.ctaStyle ~= "StandardLight" then v81.LightMode.ActionOverMedia.Background.Transparency else v81.Color.Extended.White.White_20.Transparency
	local num = tonumber(t2.logoAspectRatio)
	local v97 = (not num or not (num > 0)) and 1 or num
	local v98 = if v97 ~= 3 then v67 else v66
	local universeId = t2.universeId
	local placeId = t2.placeId
	local v101 = useValidTileBadges(universeId, t2.topicId, t2.badgeOverride)
	local hoverKey = t2.hoverKey
	local v103, v104 = React.useState(false)
	local v105 = React.useRef(nil)
	local v106 = useTriggerFeedback()
	local v107 = useOverflowMenuOpen(hoverKey)
	local v108 = useIsHoveredTile(v105, hoverKey, true)
	local v109 = React.useRef(false)
	local v110 = React.useCallback(function() -- line: 258
		-- upvalues: t2 (copy), sponsoredGamesRecordClick (copy), v76 (copy)
		if t2.isSponsored and t2.adId then
			sponsoredGamesRecordClick(v76, t2.adId)
		end
	end, {
		v76,
		t2.isSponsored,
		t2.adId
	})
	local v111 = React.useCallback(function() -- line: 264
		-- upvalues: v109 (copy)
		v109.current = false
	end, {})
	local v112 = if not FFlagLuaAppFixTwoByOneOverflowMenuTelemetry then React.useCallback(function() -- line: 270
		-- upvalues: v109 (copy), v106 (copy), t2 (copy), getOverflowMenuSignalStore (copy), hoverKey (copy)
		local current = v109.current

		v109.current = true

		if current == false then
			v106("TwoByOneTileLongPress", "Press", t2.appPage, nil)
			getOverflowMenuSignalStore().openMenu(hoverKey)
		end
	end, {
		hoverKey,
		t2.appPage,
		v106
	}) else nil
	local v113 = React.useCallback(function() -- line: 280
		-- upvalues: t2 (copy), GameCollectionItemTypes (copy), v75 (copy), universeId (copy), TwoByOneGameTileTelemetry (copy)
		local t3 = {
			index = t2.index,
			placeIdOverride = t2.placeIdOverride,
			experienceJoinData = {
				launchData = if not t2.launchDataOverride then nil else t2.launchDataOverride,
				tileType = GameCollectionItemTypes.GameCollectionItemType.TwoByOneTile,
				nativeAdData = t2.adId
			}
		}

		v75(universeId, t3)
		TwoByOneGameTileTelemetry.logTwoByOneTileViewGameDetailsActivated()

		if t2.reportGameDetailOpened then
			t2.reportGameDetailOpened(t2.index, universeId)
		end
	end, {
		v75,
		universeId,
		t2.index,
		t2.placeIdOverride,
		t2.launchDataOverride,
		t2.reportGameDetailOpened,
		t2.adId
	})
	local v114 = React.useCallback(function() -- line: 311
		-- upvalues: v104 (copy), t2 (copy)
		v104(true)

		if t2.onSelectionGained then
			t2.onSelectionGained()
		end
	end, { t2.onSelectionGained })
	local v115 = React.useCallback(function() -- line: 323
		-- upvalues: v104 (copy), t2 (copy)
		v104(false)

		if t2.onSelectionLost then
			t2.onSelectionLost()
		end
	end, { t2.onSelectionLost })
	local isSponsored = t2.isSponsored
	local v117 = React.useMemo(function() -- line: 335
		-- upvalues: getAvailableGameTileOverflowMenuItems (copy), isSponsored (copy), FFlagLuaAppSupportSponsoredExplicitFeedback (copy), t2 (copy)
		return getAvailableGameTileOverflowMenuItems({
			isSponsored = isSponsored,
			enableSponsoredFeedback = if not FFlagLuaAppSupportSponsoredExplicitFeedback then isSponsored else t2.enableSponsoredFeedback,
			enableReportAd = if not FFlagLuaAppSupportSponsoredExplicitFeedback then isSponsored else t2.enableReportAd,
			enableExplicitFeedback = if not FFlagLuaAppSupportSponsoredExplicitFeedback then nil else t2.enableExplicitFeedback
		})
	end, {
		isSponsored,
		t2.enableSponsoredFeedback,
		t2.enableReportAd,
		t2.enableExplicitFeedback
	})
	local v118 = (v108 or (v103 or v107)) and next(v117) ~= nil
	local v119 = if not FFlagLuaAppFixTwoByOneOverflowMenuTelemetry then nil else React.useCallback(function(b1: boolean, s1: string?) -- line: 351
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
		v112 = React.useCallback(function() -- line: 371
			-- upvalues: v109 (copy), v117 (copy), v106 (copy), v107 (copy), FFlagLuaAppHapticTriggeredTelemetry (copy), universeId (copy), t2 (copy), getOverflowMenuSignalStore (copy), hoverKey (copy), v119 (copy)
			local current = v109.current

			v109.current = true

			if current == false and next(v117) ~= nil then
				if v106 and not v107 then
					local v141 = if not FFlagLuaAppHapticTriggeredTelemetry then nil else {
						universeId = universeId,
						sortId = t2.topicId
					}

					v106("TwoByOneTileLongPress", "Press", if not FFlagLuaAppHapticTriggeredTelemetry then nil else t2.appPage or "Unknown", if not FFlagLuaAppHapticTriggeredTelemetry then nil else v141)
				end

				getOverflowMenuSignalStore().openMenu(hoverKey)

				local t5 = {}

				for v143, _ in v117 do
					table.insert(t5, v143)
				end

				v119(false, table.concat(t5, ","))
			end
		end, {
			hoverKey,
			t2.appPage,
			t2.topicId,
			v106,
			v117,
			v107,
			universeId,
			v119
		})
	end

	local v120 = React.useCallback(function(s2: string?) -- line: 413
		-- upvalues: v77 (copy), SetGamePlaySession (copy), SessionType (copy), v108 (copy), HoverTileCoordinator (copy), t2 (copy), placeId (copy), universeId (copy), GameCollectionItemTypes (copy), FFlagLuaAppDemoModePlayButtonTelemetry (copy)
		if v77 then
			SetGamePlaySession(v77, SessionType.StructuralIdentifier.GamePlayFromHoverTile, true)
		end

		if v108 then
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
		v77,
		t2.reportExperienceLaunched,
		placeId,
		universeId,
		t2.appPage,
		t2.index,
		t2.adId,
		t2.placeIdOverride,
		t2.launchDataOverride,
		v108
	})
	local v121 = usePlayButtonState(v76, universeId)
	local v122 = useOnPlayButtonCallback(universeId, t2.appPage, "TwoByOneTile", nil, "TwoByOneTile", {
		launchData = t2.launchDataOverride,
		tileType = GameCollectionItemTypes.GameCollectionItemType.TwoByOneTile,
		nativeAdData = t2.adId
	}, if not t2.placeIdOverride then t2.placeId else t2.placeIdOverride)
	local v123 = React.useCallback(function() -- line: 471
		-- upvalues: TwoByOneGameTileTelemetry (copy), v110 (copy)
		TwoByOneGameTileTelemetry.logTwoByOneTileGameJoinInitiated()
		TwoByOneGameTileTelemetry.logTwoByOneTileCtaActivated()
		v110()
	end, { v110 })
	local v124 = React.useCallback(function() -- line: 477
		-- upvalues: TwoByOneGameTileTelemetry (copy), v110 (copy), v113 (copy)
		TwoByOneGameTileTelemetry.logTwoByOneTileCtaActivated()
		v110()
		v113()
	end, {
		v110,
		v113
	})
	local v125 = React.useCallback(function() -- line: 483
		-- upvalues: TwoByOneGameTileTelemetry (copy), v122 (copy), v121 (copy), v120 (copy)
		TwoByOneGameTileTelemetry.logTwoByOneTileGameJoinInitiated()
		v122(v121.playButtonState, v120)
	end, {
		v122,
		v121.playButtonState,
		v120
	})
	local v126 = React.useCallback(function() -- line: 495
		-- upvalues: v109 (copy), v108 (copy), HoverTileCoordinator (copy), TwoByOneGameTileTelemetry (copy), v110 (copy), v80 (copy), v113 (copy), v125 (copy)
		if v109.current then
			v109.current = false

			return
		end

		if v108 then
			HoverTileCoordinator.default:reset()
		end

		TwoByOneGameTileTelemetry.logTwoByOneTileActivated()
		v110()

		if v80.onTileActivation == "OpenEdp" then
			v113()

			return
		end

		if v80.onTileActivation == "JoinGame" then
			v125()
		end
	end, {
		v108,
		v80.onTileActivation,
		v113,
		v125,
		v110
	})
	local v127 = useSelector(function(p1) -- line: 523
		-- upvalues: GameInfosReducer (copy), universeId (copy)
		return p1.Personalization[GameInfosReducer.key][universeId]
	end)
	local v128 = getGameTileLayoutData(v127, t2.topicId)
	local v129 = ((if not t2.primaryWideImageAssetId then ItemLayoutDataParsingUtils.getWideImageAssetId(v128) else t2.primaryWideImageAssetId)) or (v127 and v127.primaryWideAssetId or nil)
	local v130 = formatExperienceThumbnail(v129, placeId, true)
	local v131 = v127 and v127.ageRecommendationDisplayName or nil
	local v132 = React.useRef(nil)

	React.useEffect(function() -- line: 537
		-- upvalues: ImpressionsTagUtility (copy), v132 (copy), t2 (copy)
		ImpressionsTagUtility.AddTag(v132, t2.impressionsTag, t2.index)

		return function() -- line: 539
			-- upvalues: ImpressionsTagUtility (copy), v132 (copy), t2 (copy)
			ImpressionsTagUtility.RemoveTag(v132, t2.impressionsTag, t2.index)
		end
	end, {
		t2.impressionsTag,
		t2.index
	})
	useTagAsViewportAutoplayCandidate(v132, t2.videoPlaybackContext, not FFlagLuaAppTileVideoCandidateOnly and nil)

	if FFlagLuaAppSponsoredAdViewabilityEnabled then
		local t7 = nil

		if t2.isSponsored and t2.adId ~= nil and not t2.isHidden then
			t7 = {
				encryptedAdTrackingData = t2.adId,
				tileType = GameCollectionItemTypes.GameCollectionItemType.TwoByOneTile
			}
		end

		useTagAsSponsoredAdViewabilityCandidate(v132, t7)
	end

	if FFlagLuaAppSupportSponsoredExplicitFeedback and t2.isHidden then
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = t2.layoutOrder,
			ZIndex = t2.zIndex,
			ref = v132
		}, {
			TwoByOneTileContainer = React.createElement("TextButton", {
				BackgroundTransparency = 1,
				Selectable = false,
				Size = t2.size or UDim2.fromScale(1, 1),
				ref = v105,
				SelectionOrder = if not FFlagLuaAppFixCustomTileBugs then nil else t2.SelectionOrder
			}, {
				HiddenTileContent = React.createElement(HiddenTileContent, {
					appPage = t2.appPage,
					collectionId = t2.topicId,
					setGameHidden = t2.setGameHidden,
					universeId = universeId,
					parentRef = v105,
					isSponsored = isSponsored
				})
			})
		})
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = t2.layoutOrder,
		ZIndex = t2.zIndex,
		ref = v132
	}, {
		TwoByOneTileContainer = React.createElement("TextButton", {
			Size = t2.size or UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Text = "",
			AutoButtonColor = false,
			ref = v105,
			SelectionOrder = if not FFlagLuaAppFixCustomTileBugs then nil else t2.SelectionOrder,
			[React.Event.TouchLongPress] = v112,
			[React.Event.Activated] = v126,
			[React.Event.SelectionGained] = v114,
			[React.Event.SelectionLost] = v115,
			[React.Change.GuiState] = v111
		}, {
			BackgroundImage = React.createElement("ImageLabel", {
				[React.Tag] = if not FFlagLuaAppHomePageFirstImageLoadObserver then nil else "observed-image",
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				Image = v130,
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
				Size = UDim2.new(v70, 0, 1, 0),
				BackgroundColor3 = color3
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = uDim
				}),
				UIGradientLeft = React.createElement("UIGradient", {
					Rotation = 0,
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, v68),
						NumberSequenceKeypoint.new(1, v69)
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
				Size = UDim2.new(1, 0, v70, 0),
				BackgroundColor3 = color3
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = uDim
				}),
				UIGradientBottom = React.createElement("UIGradient", {
					Rotation = 90,
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, v69),
						NumberSequenceKeypoint.new(1, v68)
					}),
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, color3_2),
						ColorSequenceKeypoint.new(1, color3_2)
					})
				})
			}),
			TileBadge = v101 and React.createElement("Frame", {
				BackgroundTransparency = 1,
				ZIndex = 2,
				Size = UDim2.fromScale(1, 1)
			}, {
				Badge = React.createElement(GameTileThumbnailBadges, {
					tileBadgesByPosition = v101
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
					Size = UDim2.new(1, 0, v98, 0),
					aspectRatio = v97
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
				JoinButtonContainer = v80.onCtaActivation == "JoinGame" and React.createElement("Frame", {
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
						playableText = v79,
						buttonSize = Small,
						width = v93,
						preferSecondaryPlayButton = not not FFlagLuaAppDemoModePlayButton or nil,
						onActivated = v123,
						reportExperienceLaunched = v120,
						experienceJoinData = if not t2.launchDataOverride then nil else {
							launchData = t2.launchDataOverride
						}
					})
				}),
				ViewGameDetailsButton = v80.onCtaActivation == "OpenEdp" and React.createElement("TextButton", {
					Size = UDim2.new(v93.Scale, v93.Offset, 0, Size_800),
					Position = UDim2.new(0, 0, 1, 0),
					AnchorPoint = Vector2.new(0, 1),
					BackgroundColor3 = v94,
					BackgroundTransparency = v95,
					Text = v79,
					TextColor3 = v81.LightMode.ActionOverMedia.Foreground.Color3,
					Font = TitleSmall.Font,
					TextSize = TitleSmall.FontSize,
					[React.Event.Activated] = v124
				}, {
					UICorner = React.createElement("UICorner", {
						CornerRadius = UDim.new(0, v81.Radius.Medium)
					})
				}),
				BottomRightLabel = React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2.new(0, 0, 0, CaptionSmall.FontSize * CaptionSmall.LineHeight),
					Text = v131,
					TextSize = CaptionSmall.FontSize,
					Font = CaptionSmall.Font,
					TextColor3 = v81.Color.Extended.Gray.Gray_400.Color3,
					TextXAlignment = Enum.TextXAlignment.Right,
					TextTruncate = Enum.TextTruncate.SplitWord,
					AnchorPoint = Vector2.new(1, 1),
					Position = UDim2.new(1, 0, 1, 0)
				})
			}),
			OverflowMenuContainer = v118 and React.createElement("Frame", {
				BackgroundTransparency = 1,
				ZIndex = 4,
				Size = UDim2.fromScale(1, 1)
			}, {
				OverflowMenu = React.createElement(GameTileOverflowMenu, {
					isHovered = v108,
					isSelected = if not FFlagLuaAppFixTwoByOneOverflowMenuTelemetry then nil else v103,
					universeId = universeId,
					collectionId = t2.topicId,
					appPage = t2.appPage,
					setGameHidden = t2.setGameHidden or function() -- line: 818
					end,
					menuKey = hoverKey,
					menuOpen = v107,
					onMenuOpenChanged = if not FFlagLuaAppFixTwoByOneOverflowMenuTelemetry then nil else v119,
					parentRef = v105,
					isSponsored = t2.isSponsored,
					payerName = t2.payerName,
					sponsoredUserCohort = t2.sponsoredUserCohort,
					adId = t2.adId,
					availableMenuItems = v117
				})
			})
		})
	})
end
