local ExperienceService = game:GetService("ExperienceService")

local module = require("@luauforge/deferred/eWH")
local module2 = require("@luauforge/deferred/eWI")
local module3 = require("@luauforge/deferred/eWJ")

local setTabBarVisible = require("@luauforge/deferred/eWK").Actions.SetTabBarVisible
local module4 = require("@luauforge/deferred/eWL")
local module5 = require("@luauforge/deferred/eWM")
local module6 = require("@luauforge/deferred/eWN")
local fullscreenPageWithSafeArea = module5.FullscreenPageWithSafeArea
local overflowMenu = module5.OverflowMenu
local getOverflowMenuSignalStore = module5.getOverflowMenuSignalStore
local useOverflowMenuOpen = module5.useOverflowMenuOpen
local closeCentralOverlay = module6.Thunks.CloseCentralOverlay
local setCentralOverlay = module6.Actions.SetCentralOverlay
local module7 = require("@luauforge/deferred/eWO")
local module8 = require("@luauforge/deferred/eWP")
local playButton = require("@luauforge/deferred/eWQ").PlayButton
local useNavigateToGameDetails = require("@luauforge/deferred/eWR").useNavigateToGameDetails
local useLocalization = require("@luauforge/deferred/eWS").Hooks.useLocalization
local useNavigation = require("@luauforge/deferred/eWT").useNavigation
local useNavigationFocus = require("@luauforge/deferred/eWT").useNavigationFocus
local canGoBack = require("@luauforge/deferred/eWT").canGoBack
local useDispatch = require("@luauforge/deferred/eWU").Hooks.RoactRodux.useDispatch
local useRoactService = require("@luauforge/deferred/eWV").useRoactService
local roactNetworking = require("@luauforge/deferred/eWW").RoactNetworking
local appSessionService = require("@luauforge/deferred/eWW").AppSessionService
local module9 = require("@luauforge/deferred/eWX")
local setGamePlaySession = module9.SetGamePlaySession
local sessionType = module9.SessionType
local sponsoredGamesRecordClick = require("@luauforge/deferred/eWY").Requests.sponsoredGamesRecordClick
local module10 = require("@luauforge/deferred/eWZ")
local omniRecommendationsContentType = module10.OmniRecommendationsContentType
local useNavigationProps = require("@luauforge/deferred/eXa").useNavigationProps
local useLazyFmod = require("@luauforge/deferred/eXb").useLazyFmod
local module11 = require("@luauforge/deferred/eXc")
local appPage = module11.AppPage
local centralOverlayType = module11.CentralOverlayType

local discoveryEventErrorLogger = require("@luauforge/deferred/eXd").DiscoveryEventErrorLogger

local module12 = require("@luauforge/deferred/eXe")
local videoDisplay = module12.VideoDisplay
local videoLoadingState = module12.VideoLoadingState
local module13 = require("@luauforge/deferred/eWF")
local videoPlaybackCoordinator = module13.VideoPlaybackCoordinator
local videoEndReason = module13.AnalyticsEnums.VideoEndReason

require("@luauforge/deferred/eWE")
local module14 = require("@luauforge/deferred/eXf")

local badge = module2.Badge
local button = module2.Button
local foundationProvider = module2.FoundationProvider
local icon = module2.Icon
local image = module2.Image
local text = module2.Text
local view = module2.View

local placement = module4.Placement
local useNavBarPlacement = module4.useNavBarPlacement
local badgeShape = module2.Enums.BadgeShape
local badgeSize = module2.Enums.BadgeSize
local badgeVariant = module2.Enums.BadgeVariant
local buttonVariant = module2.Enums.ButtonVariant
local colorMode = module2.Enums.ColorMode
local themeName = module2.Enums.ThemeName
local iconName = module2.Enums.IconName
local iconSize = module2.Enums.IconSize
local inputSize = module2.Enums.InputSize
local popoverAlign = module2.Enums.PopoverAlign
local popoverSide = module2.Enums.PopoverSide
local stateLayerAffordance = module2.Enums.StateLayerAffordance
local stateLayerMode = module2.Enums.StateLayerMode
local thumbnailType = module2.Enums.ThumbnailType
local getTokens = module2.Utility.getTokens
local getRbxThumb = module2.Utility.getRbxThumb

local module15 = require("@luauforge/deferred/eXg")
local fFlagLuaAppDemoModePlayButtonTelemetry = module15.FFlagLuaAppDemoModePlayButtonTelemetry
local fFlagLuaAppSduiSponsoredOneByTwoTile = module15.FFlagLuaAppSduiSponsoredOneByTwoTile

local defineFastFlag = game:DefineFastFlag("LuaAppFeatureTileAdPlayerAdClickoutEvent", false)

local module16 = require("@luauforge/deferred/eXh")
local module17 = require("@luauforge/deferred/eXi")
local useTagAsSponsoredAdViewabilityCandidate = module16.useTagAsSponsoredAdViewabilityCandidate

local tokens = getTokens(colorMode.Dark, nil, nil, nil, themeName.Default)

local function FeatureTileAdPlayer()
	local v5 = useNavigation()
	local v6 = useNavigateToGameDetails()
	local v7 = useNavigationFocus()
	local v8 = useDispatch()
	local v9 = module2.Hooks.useTokens()
	local v10 = useNavBarPlacement()
	local v11 = module3.useResponsive({ module3.BreakpointConfig.sizes.Small }) == module3.Keys.Small
	local v12 = useLocalization({
		adLabel = "Feature.EnhancedVideo.Label.Ad",
		joinButtonText = "Common.VisitGame.Label.Play",
		reportAdLabel = "Feature.GameDetails.Action.ReportAd",
		whyThisAdLabel = "Feature.GameDetails.Action.WhyThisAd"
	})

	local v13 = useNavigationProps(function(p2, data)
		local v14 = {
			videoAssetId = data.videoAssetId,
			imageAssetId = data.imageAssetId,
			startPlaybackProgress = data.startPlaybackProgress,
			attributionThumbnailAssetId = data.attributionThumbnailAssetId,
			videoPlaybackContext = data.videoPlaybackContext,
			title = data.title,
			subtitle = data.subtitle,
			contentType = data.contentType,
			payerName = data.payerName,
			sponsoredUserCohort = data.sponsoredUserCohort,
			adId = data.adId,
			enableReportAd = data.enableReportAd,
			clickoutUrl = data.clickoutUrl,
			ctaText = data.ctaText or "",
			universeId = data.universeId,
			index = data.index,
			placeId = data.placeId,
			placeIdOverride = data.placeIdOverride,
			launchDataOverride = data.launchDataOverride,
			referralSource = data.referralSource,
			source = data.source,
			launchExperienceEventContext = data.launchExperienceEventContext,
			reportGameDetailOpened = data.reportGameDetailOpened,
			reportExperienceLaunched = data.reportExperienceLaunched,
			onOpenGameDetails = 0,
			disableGameLaunchSponsoredClickRecording = 0
		}
		local v15 = if fFlagLuaAppSduiSponsoredOneByTwoTile then data.onOpenGameDetails else nil
		v14.onOpenGameDetails = v15

		local v16 = if fFlagLuaAppSduiSponsoredOneByTwoTile then data.disableGameLaunchSponsoredClickRecording else nil
		v14.disableGameLaunchSponsoredClickRecording = v16
		return v14
	end)

	useLazyFmod()

	local v14 = useRoactService(roactNetworking)
	local v15 = useRoactService(appSessionService)

	local v16 = module.useCallback(function()
		if v13.adId then
			sponsoredGamesRecordClick(v14, v13.adId)
		end
	end, { v14, v13.adId })
	local v17

	if fFlagLuaAppSduiSponsoredOneByTwoTile then
		v17 = module.useCallback(function()
			if not v13.disableGameLaunchSponsoredClickRecording then
				v16()
			end
		end, { v13.disableGameLaunchSponsoredClickRecording, v16 })
	end

	local v18, v19 = module.useBinding(v13.startPlaybackProgress or 0)

	local state, setState = module.useState(videoLoadingState.Idle)
	local state2, setState2 = module.useState(true)
	local state3, setState3 = module.useState(nil)
	local state4, setState4 = module.useState(true)

	local state5, setState5 = module.useState(v13.startPlaybackProgress)

	local ref = module.useRef(false)
	local ref2 = module.useRef(v13.startPlaybackProgress or 0)
	local ref3 = module.useRef(nil)
	local formatted = `rbxassetid://{v13.videoAssetId}`
	local v20 = not (v13.adId == nil) and v13.adId ~= ""
	local ref4 = module.useRef(nil)
	local ref5 = module.useRef(nil)

	useTagAsSponsoredAdViewabilityCandidate(ref4, v20 and {
		encryptedAdTrackingData = v13.adId,
		tileType = module10.GameCollectionItemTypes.GameCollectionItemType.OneByTwoTile,
		mediaType = "video",
		videoPlaybackStateRef = ref5,
		videoSource = formatted,
		isFullscreen = true
	} or nil)

	local v21 = module.useCallback(function()
		setState2(false)
	end, {})

	local v22 = module.useCallback(function()
		local current = ref3.current

		if current then
			current.VideoContent = Content.none
			ref3.current = nil
			ref.current = true
			setState(videoLoadingState.Idle)
			setState3(nil)
			setState4(false)
		end
	end, {})

	local v23 = module.useCallback(function(current)
		if not ref.current then
			ref2.current = current
			v19(current)
		end
	end, { v19 })

	local state6, setState6 = module.useState(false)

	local v24 = module.useCallback(function(p2)
		if not p2 then
			v21()
		end
	end, { v21 })

	local overflowMenuSignalStore = getOverflowMenuSignalStore()
	local v25 = useOverflowMenuOpen("FeatureTileAdPlayerAdDisclosure")

	local v26 = module.useCallback(function()
		v24(v25)
		overflowMenuSignalStore.toggleMenu("FeatureTileAdPlayerAdDisclosure")
	end, { v25, v24, overflowMenuSignalStore })

	local v27 = module.useMemo(function()
		local v28 = {
			{
				id = "whyThisAd",
				icon = iconName.CircleI,
				text = v12.whyThisAdLabel,
				onActivated = function()
					v8(setCentralOverlay(centralOverlayType.WhyThisAdModal, {
						universeId = v13.universeId,
						payerName = v13.payerName,
						sponsoredUserCohort = v13.sponsoredUserCohort,
						contentType = v13.contentType
					}))
				end
			}
		}

		if v13.enableReportAd and v13.adId ~= nil and v13.adId ~= "" then
			table.insert(v28, {
				id = "reportAd",
				icon = iconName.Flag,
				text = v12.reportAdLabel,
				onActivated = function()
					v8(module8({
						abuseVector = module7.AdV2,
						targetId = v13.adId,
						onClose = function()
							v8(closeCentralOverlay())
						end
					}))
				end
			})
		end

		return v28
	end, {
		v8,
		v12.reportAdLabel,
		v12.whyThisAdLabel,
		v13.adId,
		v13.contentType,
		v13.enableReportAd,
		v13.payerName,
		v13.sponsoredUserCohort,
		v13.universeId
	})
	local v28

	if v13.videoPlaybackContext then
		v28 = v13.videoPlaybackContext.videoPlaybackCoordinator
	else
		v28 = videoPlaybackCoordinator.default
	end

	local v29 = module.useCallback(function()
		setState2(true)
	end, {})

	local v30 = module.useCallback(function()
		if canGoBack(v5) then
			v5.goBack()
		else
			discoveryEventErrorLogger.reportError(
				"FeatureTileAdPlayer_CloseWithNoBackStack",
				"FeatureTileAdPlayer close pressed but navigation stack cannot go back"
			)
		end
	end, { v5 })

	local v31 = module.useCallback(function()
		local clickoutUrl = v13.clickoutUrl

		if clickoutUrl == nil or clickoutUrl == "" then
			discoveryEventErrorLogger.reportError(
				"FeatureTileAdPlayer_ClickoutCtaMissingUrl",
				"FeatureTileAdPlayer clickout CTA activated without a clickoutUrl"
			)

			return
		end

		v21()
		v16()

		if defineFastFlag then
			local adId = v13.adId

			if adId ~= nil and adId ~= "" then
				module17.Events.adClickout(
					adId,
					module10.GameCollectionItemTypes.GameCollectionItemType.OneByTwoTile,
					clickoutUrl
				)
			end
		end

		v5.navigate(appPage.GenericWebPage, {
			detail = clickoutUrl,
			extraProps = { showDomainAsTitle = true }
		})
	end, { v5, v13.clickoutUrl, v21, v16 })

	local v32 = module.useCallback(function(p2)
		if v15 then
			setGamePlaySession(v15, sessionType.StructuralIdentifier.GameDetailSource, false)
		end

		if v13.reportGameDetailOpened then
			v13.reportGameDetailOpened(v13.index, p2)
		end
	end, { v15, v13.reportGameDetailOpened, v13.index })

	local v33 = module.useCallback(function(p2)
		if v15 then
			setGamePlaySession(v15, sessionType.StructuralIdentifier.GamePlayFromHoverTile, true)
		end

		if v13.reportExperienceLaunched then
			local v34 = {
				placeId = v13.placeId,
				universeId = v13.universeId,
				adId = v13.adId,
				tileType = v13.source,
				placeIdOverride = v13.placeIdOverride,
				launchDataOverride = v13.launchDataOverride
			}

			local reportExperienceLaunched = v13.reportExperienceLaunched

			local referralSource = v13.referralSource

			local launchExperienceEventContext = v13.launchExperienceEventContext
			local index = v13.index

			if not fFlagLuaAppDemoModePlayButtonTelemetry then
				p2 = nil
			end

			reportExperienceLaunched(
				v34,
				referralSource,
				"FeatureTileAdPlayer",
				launchExperienceEventContext,
				index,
				p2
			)
		end
	end, {
		v15,
		v13.reportExperienceLaunched,
		v13.placeId,
		v13.universeId,
		v13.adId,
		v13.placeIdOverride,
		v13.launchDataOverride,
		v13.referralSource,
		v13.source,
		v13.launchExperienceEventContext,
		v13.index
	})

	local useCallback = module.useCallback
	local function fn()
		local universeId = v13.universeId

		if universeId == nil or universeId == "" then
			return
		end

		v21()

		if fFlagLuaAppSduiSponsoredOneByTwoTile and v13.onOpenGameDetails then
			v13.onOpenGameDetails()
			return
		end

		v16()
		v32(universeId)
		local v35 = {
			index = v13.index,
			placeIdOverride = v13.placeIdOverride,
			experienceJoinData = 0
		}

		local v37 = if v13.launchDataOverride then v13.launchDataOverride else nil
		v35.experienceJoinData = {
			launchData = v37,
			tileType = v13.source,
			nativeAdData = v13.adId
		}
		v6(universeId, v35)
	end

	local adId = v13.adId
	local index = v13.index
	local launchDataOverride = v13.launchDataOverride
	local placeIdOverride = v13.placeIdOverride
	local source = v13.source
	local universeId = v13.universeId

	local v35 = if fFlagLuaAppSduiSponsoredOneByTwoTile then v13.onOpenGameDetails else nil
	local v36 = useCallback(fn, {
		v6,
		adId,
		index,
		launchDataOverride,
		placeIdOverride,
		source,
		universeId,
		v21,
		v32,
		v16,
		v35
	})

	module.useEffect(function()
		local connection = ExperienceService:RegisterForExperienceJoin(function()
			v28:reset(videoEndReason.ExperienceLaunched, nil, v13.universeId, nil)
			v22()
			v21()
		end)

		local connection2 = ExperienceService:RegisterForExperienceLeave(function()
			if not ref.current then
				return
			end

			ref.current = false
			v28:forcePlayback("FeatureTileAdPlayer", "FeatureTileAdPlayer returned from experience")

			setState5(ref2.current)
			setState4(true)
		end)

		return function()
			connection:Disconnect()
			connection2:Disconnect()
		end
	end, { v13.universeId, v21, v22, v28 })

	module.useEffect(function()
		pcall(function()
			v28:forcePlayback("FeatureTileAdPlayer", "FeatureTileAdPlayer started")
		end)

		return function()
			v28:cancelPlayback("FeatureTileAdPlayer", videoEndReason.Unmounted)
		end
	end, { v28 })

	module.useEffect(function()
		if v7 then
			v8(setTabBarVisible(v10 == placement.Left))
		end
	end, { v8, v7, v10 })

	local v37 = v13.contentType == omniRecommendationsContentType.AdLink
	local universeId2 = v13.universeId
	local v38 = not (universeId2 == nil) and universeId2 ~= ""

	local v39 = if v37 then v13.ctaText elseif v13.ctaText == "" then v12.joinButtonText else v13.ctaText

	local v40 = if v37 then not (v13.clickoutUrl == nil or v13.clickoutUrl == "") and v39 ~= "" else v37

	local v41 = not (v13.attributionThumbnailAssetId == nil) and v13.attributionThumbnailAssetId ~= ""
	local v42

	if v41 then
		v42 = `rbxassetid://{v13.attributionThumbnailAssetId}`
	elseif not (v37 or not v38) then
		v42 = getRbxThumb(thumbnailType.GameIcon, universeId2)
	end

	local v43 = nil

	if v37 then
		if v40 then
			v43 = module.createElement(button, {
				LayoutOrder = 2,
				onActivated = v31,
				size = inputSize.Medium,
				text = v39,
				variant = buttonVariant.Emphasis
			})
		end
	elseif v38 then
		local createElement = module.createElement
		local v45 = {
			LayoutOrder = 2,
			universeId = universeId2,
			placeId = v13.placeIdOverride or v13.placeId,
			referralSource = v13.referralSource,
			eventContext = v13.launchExperienceEventContext,
			launchSource = "FeatureTileAdPlayer",
			playableText = v39,
			hidePlayableIcon = true,
			buttonSize = inputSize.Medium,
			preferSecondaryPlayButton = true,
			onActivated = 0,
			reportExperienceLaunched = 0,
			experienceJoinData = 0
		}

		if not fFlagLuaAppSduiSponsoredOneByTwoTile then
			v17 = v16
		end

		v45.onActivated = v17

		v45.reportExperienceLaunched = v33

		local v47 = if v13.launchDataOverride then v13.launchDataOverride else nil
		v45.experienceJoinData = {
			launchData = v47,
			tileType = v13.source,
			nativeAdData = v13.adId
		}
		v43 = createElement(playButton, v45)
	end

	local v44 = state == videoLoadingState.Loaded
	local v45 = state == videoLoadingState.Failed
	local v46 = v44 and state3 ~= nil and true or v45
	local children = {
		InputSink = module.createElement(view, {
			tag = "size-full",
			BackgroundTransparency = 1,
			ZIndex = 2,
			onActivated = function()
				if state2 then
					v21()
				else
					v29()
				end
			end,
			stateLayer = { affordance = stateLayerAffordance.None }
		}),
		CenterPlayButton = 0,
		BottomControls = 0,
		CloseButton = 0
	}

	local v47 = if not state2 then module.createElement(
		view,
		{
			ZIndex = 3,
			onActivated = v29,
			backgroundStyle = tokens.Color.OverMedia.OverMedia_100,
			tag = "position-center-center anchor-center-center auto-xy padding-medium radius-circle"
		},
		{
			Icon = module.createElement(icon, {
				name = iconName.PlayLarge,
				size = iconSize.Medium,
				style = tokens.Color.Extended.White.White_100
			})
		}
	) else nil
	children.CenterPlayButton = v47

	local createElement = module.createElement
	local v49 = {
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.fromScale(0.5, 1),
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 4
	}

	local v50 = {
		SizeConstraint = module.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(600, 1e999)
		}),
		Padding = module.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v9.Size.Size_1200),
			PaddingRight = UDim.new(0, v9.Size.Size_500),
			PaddingBottom = UDim.new(0, v9.Size.Size_400),
			PaddingLeft = UDim.new(0, v9.Size.Size_500)
		}),
		Layout = module.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Bottom
		}),
		BottomContent = 0
	}

	local createElement2 = module.createElement
	local v52 = {
		LayoutOrder = 1,
		tag = "size-full-0 auto-y",
		BackgroundTransparency = 1,
		ZIndex = 4,
		layout = {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, v9.Gap.Large),
			SortOrder = Enum.SortOrder.LayoutOrder
		}
	}

	local createElement3 = module.createElement
	local v54 = {
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, v9.Size.Size_1200),
		BackgroundTransparency = 1
	}

	local children3 = {
		AdBadge = module.createElement(foundationProvider, {
			colorMode = colorMode.Dark
		}, {
			Badge = module.createElement(badge, {
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.fromScale(0, 1),
				shape = badgeShape.Box,
				size = badgeSize.Small,
				text = v12.adLabel,
				variant = badgeVariant.Neutral
			})
		}),
		MuteButton = 0,
		AdDisclosureOverflowButton = 0,
		AdDisclosureOverflowMenu = 0
	}

	local createElement4 = module.createElement
	local v56 = {
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, 0, 1, -v9.Size.Size_1200 - v9.Gap.Medium),
		BackgroundTransparency = 1,
		onActivated = function()
			setState6(not state6)
		end,
		stateLayer = { mode = stateLayerMode.Dark },
		tag = "auto-xy padding-medium radius-circle"
	}

	local createElement5 = module.createElement
	local v60 = if state6 then iconName.SpeakerSlash else iconName.Speaker
	children3.MuteButton = createElement4(view, v56, {
		Icon = createElement5(icon, {
			name = v60,
			size = iconSize.Large,
			style = v9.Color.Extended.White.White_100
		})
	})

	children3.AdDisclosureOverflowButton = module.createElement(view, {
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		onActivated = v26,
		stateLayer = { mode = stateLayerMode.Dark },
		tag = "auto-xy padding-medium radius-circle"
	}, {
		Icon = module.createElement(icon, {
			name = iconName.ThreeDotsVertical,
			size = iconSize.Large,
			style = v9.Color.Extended.White.White_100
		})
	})

	children3.AdDisclosureOverflowMenu = module.createElement(overflowMenu, {
		anchorPoint = Vector2.new(1, 1),
		anchorPosition = UDim2.fromScale(1, 1),
		hasOverflowButton = false,
		menuItemSize = inputSize.Medium,
		menuItems = v27,
		menuKey = "FeatureTileAdPlayerAdDisclosure",
		menuWidth = UDim.new(0, 180),
		onMenuOpenChanged = v24,
		popoverAlign = popoverAlign.End,
		popoverSide = popoverSide.Top,
		shouldShowAnchor = true
	})
	local children2 = {
		TopControls = createElement3(view, v54, children3),
		Progress = module.createElement(module14, { LayoutOrder = 2, progress = v18 }),
		Attribution = 0
	}

	local createElement6 = module.createElement
	local v62 = {
		LayoutOrder = 3,
		Size = UDim2.new(1, 0, 0, v9.Size.Size_1000),
		BackgroundTransparency = 1,
		tag = "row align-x-left align-y-center gap-medium"
	}

	local createElement7 = module.createElement
	local v67

	if v42 then
		local createElement8 = module.createElement
		local v69 = {
			LayoutOrder = 1,
			Size = UDim2.fromOffset(v9.Size.Size_1000, v9.Size.Size_1000),
			cornerRadius = UDim.new(0, v9.Radius.Medium),
			onActivated = 0
		}

		if v37 or not v38 then
			v36 = nil
		end

		v69.onActivated = v36
		v67 = createElement8(view, v69, {
			Image = module.createElement(image, {
				Image = v42,
				tag = "size-full",
				ScaleType = Enum.ScaleType.Crop,
				cornerRadius = UDim.new(0, v9.Radius.Medium)
			})
		})
	end

	local createElement8 = module.createElement

	local v71 = if v13.title then module.createElement(text, {
		LayoutOrder = 1,
		Text = v13.title,
		fontStyle = v9.Typography.TitleMedium,
		textStyle = v9.Color.Extended.White.White_100,
		tag = "size-full-0 auto-y text-align-x-left text-align-y-top text-truncate-end"
	}) else nil

	local v72 = if v13.subtitle then module.createElement(text, {
		LayoutOrder = 2,
		Text = v13.subtitle,
		fontStyle = v9.Typography.BodyMedium,
		textStyle = v9.Color.Extended.White.White_80,
		tag = "size-full-0 auto-y text-align-x-left text-align-y-center text-truncate-end"
	}) else nil
	children2.Attribution = createElement6(view, v62, {
		MediaAndMetadata = createElement7(
			view,
			{
				LayoutOrder = 1,
				tag = "row align-x-left align-y-center grow gap-medium auto-y"
			},
			{
				Thumbnail = v67,
				Metadata = createElement8(
					view,
					{
						LayoutOrder = 2,
						tag = "col align-x-left align-y-center grow auto-y"
					},
					{ Title = v71, Subtitle = v72 }
				)
			}
		),
		Cta = v43
	})
	v50.BottomContent = createElement2(view, v52, children2)
	children.BottomControls = createElement("Frame", v49, v50)

	children.CloseButton = module.createElement(view, {
		tag = "row align-x-center align-y-center anchor-top-right",
		Position = UDim2.new(1, -v9.Padding.XLarge, 0, v9.Padding.XLarge),
		Size = UDim2.fromOffset(v9.Size.Size_1000, v9.Size.Size_1000),
		ZIndex = 4,
		backgroundStyle = v9.Color.Extended.Black.Black_60,
		cornerRadius = UDim.new(0, v9.Radius.Circle),
		onActivated = v30,
		stateLayer = { mode = stateLayerMode.Dark }
	}, {
		Icon = module.createElement(icon, {
			name = iconName.X,
			size = iconSize.Large,
			style = v9.Color.Extended.White.White_100
		})
	})

	local createElement9 = module.createElement

	local createElement10 = module.createElement

	local v78 = {
		Backdrop = module.createElement(view, {
			tag = "size-full",
			BackgroundTransparency = 1,
			ZIndex = 1,
			onActivated = v30,
			stateLayer = { affordance = stateLayerAffordance.None }
		}),
		VideoContainer = 0
	}

	local createElement11 = module.createElement

	local createElement12 = module.createElement

	if not v20 then
		ref4 = nil
	end

	local v83 = {
		ref = ref4,
		tag = "size-full clip",
		BackgroundTransparency = 1,
		Visible = v46,
		ZIndex = 1,
		sizeConstraint = { MaxSize = Vector2.new(1e999, 1000) },
		aspectRatio = not v45 and state3 and {
			AspectRatio = state3,
			AspectType = Enum.AspectType.FitWithinMaxSize
		} or nil
	}
	local v85

	if state4 then
		local createElement13 = module.createElement

		local v88 = if v45 then "rbxassetid://" .. v13.imageAssetId else nil
		local v87 = {
			video = formatted,
			thumbnail = v88,
			shouldStartPlayback = state2,
			muted = state6,
			looped = false,
			startPlaybackProgress = state5,
			preservePlaybackPosition = true,
			showVideoWhenPaused = true,
			loadImmediately = true,
			videoPlayerRef = ref3,
			videoPlaybackStateRef = nil,
			Size = 0,
			ScaleType = 0,
			ZIndex = 1,
			onLoadingStateChanged = 0,
			onAspectRatioChanged = 0,
			onVideoEnded = 0,
			onVideoProgressChanged = 0
		}

		if not v20 then
			ref5 = nil
		end

		v87.videoPlaybackStateRef = ref5
		v87.Size = UDim2.fromScale(1, 1)
		v87.ScaleType = Enum.ScaleType.Fit

		v87.onLoadingStateChanged = setState
		v87.onAspectRatioChanged = setState3
		v87.onVideoEnded = v21
		v87.onVideoProgressChanged = v23
		v85 = createElement13(videoDisplay, v87)
	end

	local v84 = {
		Video = v85,
		BottomContentGradient = module.createElement("Frame", {
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.fromScale(0, 1),
			Size = UDim2.fromScale(1, 0.5),
			BackgroundColor3 = Color3.new(0, 0, 0),
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			ZIndex = 2
		}, {
			Gradient = module.createElement("UIGradient", {
				Rotation = 90,
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(1, 0.25)
				})
			})
		}),
		Controls = 0
	}

	local v86 = if v46 then module.createElement(module.Fragment, nil, children) else nil
	v84.Controls = v86
	v78.VideoContainer = createElement11(
		view,
		{
			BackgroundTransparency = 1,
			ZIndex = 2,
			tag = "col align-x-center align-y-center size-full"
		},
		{
			VideoFrameContainer = createElement12(view, v83, v84)
		}
	)
	return createElement9(fullscreenPageWithSafeArea, {
		BackgroundTransparency = 1,
		includeStatusBar = true,
		renderFullscreenBackground = v11 and function()
			return module.createElement("Frame", {
				Name = "FeatureTileAdPlayerFullscreenBackground",
				Size = UDim2.fromScale(1, 1),
				BackgroundColor3 = v9.Color.Common.NavigationBar.Color3,
				BackgroundTransparency = v9.Color.Common.NavigationBar.Transparency,
				BorderSizePixel = 0
			})
		end or nil,
		useFullScalePage = false
	}, {
		Root = createElement10(view, { tag = "size-full" }, v78)
	})
end

return FeatureTileAdPlayer
