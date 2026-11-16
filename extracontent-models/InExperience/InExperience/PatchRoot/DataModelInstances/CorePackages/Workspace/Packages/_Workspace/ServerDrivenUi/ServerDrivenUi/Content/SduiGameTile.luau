local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent
local React = require(parent.React)
local Responsive = require(parent.Responsive)
local GetInputModeStore = Responsive.GetInputModeStore
local AppBlox = require(parent.AppBlox)
local Foundation = require(parent.Foundation)
local Cryo = require(parent.Cryo)
local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local Localization = require(parent.Localization)
local localizeStrings = Localization.localizeStrings
local useTokens = Foundation.Hooks.useTokens
local usePreferences = Foundation.Hooks.usePreferences
local gameTileOverflowMenuAction = DiscoveryAnalytics.Events.gameTileOverflowMenuAction

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiBuilder = SduiCoreSystem.SduiBuilder
local SduiErrors = SduiCoreSystem.SduiErrors
local getSduiComponentWrapper = SduiCoreSystem.getSduiComponentWrapper
local SduiSharedContent = require(parent.SduiSharedContent)
local SduiPlayButton = SduiSharedContent.SduiPlayButton
local SduiTileOverflowMenu = SduiSharedContent.SduiTileOverflowMenu
local SduiParsers = SduiCoreSystem.SduiParsers
local SduiParseHelpers = SduiCoreSystem.SduiParseHelpers
local useUidRefString = SduiCoreSystem.useUidRefString
local findAnalyticsFieldInAncestors = SduiCoreSystem.findAnalyticsFieldInAncestors
local VideoUtils = require(parent.VideoUtils)
local VideoEndReason = VideoUtils.AnalyticsEnums.VideoEndReason

local GameTile = require(parent.GameTile)
local default = GameTile.HoverTileCoordinator.default
local ZoomAnimatedFrame = GameTile.ZoomAnimatedFrame
local getGameTileHiddenStore = GameTile.getGameTileHiddenStore
local getOverflowMenuSignalStore = AppBlox.getOverflowMenuSignalStore
local SduiTile = require(ServerDrivenUi.Content.SduiTile)
local SduiGameVideoThumbnail = require(ServerDrivenUi.Content.SduiGameVideoThumbnail)
local TileHoverShadow = require(ServerDrivenUi.Content.TileHoverShadow)
local SduiGameTileFooter = require(ServerDrivenUi.Content.SduiGameTileFooter)
local SduiHoldToPlay = require(ServerDrivenUi.FocusNavigation.SduiHoldToPlay)
local SduiDefaultTileImage = require(ServerDrivenUi.Content.SduiDefaultTileImage)

local Flags = require(ServerDrivenUi.Flags)
local FFlagSduiTileDisableLegacyHover = Flags.FFlagSduiTileDisableLegacyHover
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableGameJoinEarlyAccess = SharedFlags.FFlagEnableGameJoinEarlyAccess
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppSduiVideoThumbnail = SharedFlags2.FFlagLuaAppSduiVideoThumbnail
local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppSduiGameTileFeedback = SharedFlags3.FFlagLuaAppSduiGameTileFeedback
local SharedFlags4 = require(parent.SharedFlags)
local FFlagLuaAppSduiGameTileMetadataFontStyle = SharedFlags4.FFlagLuaAppSduiGameTileMetadataFontStyle
local SharedFlags5 = require(parent.SharedFlags)
local FFlagSduiFixSearchTelemetry = SharedFlags5.FFlagSduiFixSearchTelemetry

local defineFastFlag = game:DefineFastFlag("SduiGameTileDisableDefaultPlayButtonOnHover", false)
local SharedFlags6 = require(parent.SharedFlags)
local FFlagSduiGameTileEnableHoverInVR = SharedFlags6.FFlagSduiGameTileEnableHoverInVR
local SharedFlags7 = require(parent.SharedFlags)
local FFlagSduiGameTileDirectAction = SharedFlags7.FFlagSduiGameTileDirectAction

local SharedFlags8 = require(parent.SharedFlags)
local FFlagSduiGameTileUseFooterComponentAsDefault = SharedFlags8.FFlagSduiGameTileUseFooterComponentAsDefault
local v

if FFlagLuaAppSduiGameTileFeedback then
	v = Signals.createSignal(false)
else
	v = nil
end

local function SduiGameTile(props)
	local v2 = useTokens()
	local v3 = usePreferences()
	local enableLegacyHoverState = not FFlagSduiTileDisableLegacyHover and props.enableLegacyHoverState
	local videoPlaybackContext

	if FFlagLuaAppSduiVideoThumbnail then
		videoPlaybackContext = props.sduiContext.videoPlaybackContext
	else
		videoPlaybackContext = nil
	end

	local ref = React.useRef(nil)

	local current = useUidRefString().current

	local universeId = props.universeId
	local placeId = props.placeId

	local ref2 = React.useRef(nil)
	local setGuiObject = React.useCallback(function(current2)
		ref2.current = current2

		if props.setGuiObject then
			props.setGuiObject(current2)
		end
	end, { props.setGuiObject })
	local v4, v5, triggerFeedback

	if FFlagLuaAppSduiGameTileFeedback then
		v4 = props.overflowMenuComponent ~= nil
			and props.collectionId ~= nil
			and props.collectionId ~= ""
			and props.hiddenStateComponent ~= nil

		local v6 = React.useMemo(function()
			if not v4 then
				return v
			end

			local getHiddenGames = getGameTileHiddenStore(props.collectionId).getHiddenGames
			return Signals.createComputed(function(p): boolean
				return getHiddenGames(p)[universeId] == true
			end)
		end, { v4, props.collectionId, universeId })

		v5 = SignalsReact.useSignalState(v6)

		triggerFeedback = props.sduiContext.dependencies.triggerFeedback
	else
		v5 = nil
		triggerFeedback = nil
		v4 = nil
	end

	local ref3 = React.useRef(false)
	local setDisabledForHold = React.useCallback(function(current2: boolean)
		ref3.current = current2
	end, {})
	local useCallback = React.useCallback
	local function fn()
		props.sduiContext.dependencies.logger.reportCounter(
			SduiErrors.SduiCounterName.GameTileActivated,
			{
				name = GetInputModeStore(false).getLastInputType(false)
			},
			true
		)

		local function logFailure(p)
			local v6 = not p and "" or SduiParseHelpers.stringifyValue(p)
			local stringifyValue = SduiParseHelpers.stringifyValue(props.componentConfig)
			props.sduiContext.dependencies.logger.reportError(
				SduiErrors.SduiErrorType.FailedToExecuteAction,
				{
					componentType = "GameTile",
					message = `Error executing GameTile.onActivated error: '{v6}' config: {stringifyValue}`,
					name = GetInputModeStore(false).getLastInputType(false)
				},
				props.sduiContext.appPage
			)
		end

		local success, result = pcall(function()
			if ref3.current then
				props.sduiContext.dependencies.logger.reportCounter(
					SduiErrors.SduiCounterName.GameTileActivatedWhenDisabled,
					{
						name = GetInputModeStore(false).getLastInputType(false)
					}
				)

				return
			end

			if FFlagLuaAppSduiVideoThumbnail and videoPlaybackContext then
				videoPlaybackContext.videoPlaybackCoordinator:reset(VideoEndReason.TileClicked, nil, universeId, nil)
			end

			if props.onActivated then
				props.onActivated()
				return
			end

			local safeParseCallback = SduiParsers.safeParseCallback({
				actionType = SduiActionType.OpenGameDetails,
				actionParams = { placeId = placeId, universeId = universeId }
			}, props.sduiContext, props.analyticsContext)

			if not safeParseCallback then
				logFailure("Callback is nil after parsing")
				return
			end

			props.sduiContext.dependencies.logger.reportCounter(
				SduiErrors.SduiCounterName.GameTileActivatedExecuteCallback,
				{
					name = GetInputModeStore(false).getLastInputType(false)
				},
				true
			)

			safeParseCallback()
		end)

		if not success then
			logFailure(result)
		end
	end

	local onActivated = props.onActivated
	local sduiContext = props.sduiContext
	local analyticsContext = props.analyticsContext

	local componentConfig = props.componentConfig
	local v6

	if FFlagLuaAppSduiVideoThumbnail then
		v6 = videoPlaybackContext
	end

	local onActivated2 = useCallback(fn, {
		onActivated,
		sduiContext,
		analyticsContext,
		placeId,
		universeId,
		componentConfig,
		v6
	})

	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)

	local onSelectionGained = React.useCallback(function()
		setState(true)

		if props.setCustomConditionState then
			props.setCustomConditionState("selected", true)
		end
	end, { props.setCustomConditionState })

	local onSelectionLost = React.useCallback(function()
		setState(false)

		if props.setCustomConditionState then
			props.setCustomConditionState("selected", false)
		end
	end, { props.setCustomConditionState })

	if FFlagLuaAppSduiGameTileFeedback then
		React.useEffect(function()
			if v5 then
				getOverflowMenuSignalStore().closeMenu(current)
				onSelectionLost()
			end
		end, { v5, current, onSelectionLost })
	end

	local ref4 = React.useRef(0)

	if state2 == false then
		ref4.current = 0
	end

	local default2 = default.default
	local onMouseEnter = React.useCallback(function()
		if ref4.current == 0 and current then
			local v7

			if FFlagSduiGameTileEnableHoverInVR then
				v7 = GetInputModeStore(false).getPreferredInputType(false) == Responsive.Input.Pointer
			else
				v7 = GetInputModeStore(false).getLastInputType(false) == Responsive.Input.Pointer
			end

			if v7 then
				default2:requestHover(current)
			end
		end

		ref4.current += 1
	end, { current })
	local onMouseLeave = React.useCallback(function()
		ref4.current -= 1

		if ref4.current < 0 then
			ref4.current = 0
		end

		if ref4.current == 0 and current then
			default2:cancelHover(current)
		end
	end, { current })

	React.useEffect(function()
		local v7 = current
		local v8 = state2

		local changedConnection = default2.changed:connect(function(p)
			local v9 = p == current
			setState2(v9)

			if props.setCustomConditionState and v9 ~= v8 then
				props.setCustomConditionState("hovered", v9)
			end

			v8 = v9
		end)
		return function()
			default2:cancelHover(v7)
			ref4.current = 0

			if changedConnection ~= nil then
				changedConnection:disconnect()
			end
		end
	end, { current, props.setCustomConditionState })
	local onMenuOpenChanged, onTouchLongPress

	if FFlagLuaAppSduiGameTileFeedback then
		onMenuOpenChanged = React.useCallback(function(flag: boolean)
			gameTileOverflowMenuAction({
				universeId = universeId,
				sortId = props.collectionId,
				actionType = flag and "GameTileOverflowMenuClosed" or "GameTileOverflowMenuOpened"
			}, props.sduiContext.appPage)
		end, { universeId, props.collectionId, props.sduiContext.appPage })

		onTouchLongPress = React.useCallback(function()
			local overflowMenuSignalStore = getOverflowMenuSignalStore()

			if triggerFeedback and not overflowMenuSignalStore.getIsMenuOpen(current) then
				triggerFeedback("TileLongPress", "Press", props.sduiContext.appPage or "Unknown", {
					universeId = universeId,
					sortId = props.collectionId
				})
			end

			overflowMenuSignalStore.openMenu(current)
			onMenuOpenChanged(false)
		end, {
			triggerFeedback,
			current,
			props.sduiContext.appPage,
			props.collectionId,
			onMenuOpenChanged,
			universeId
		})
	else
		onMenuOpenChanged = nil
	end

	local onActivatedEffect = React.useCallback(function()
		if state2 then
			default2:reset()
		end
	end, { state2 })

	local useMemo = React.useMemo
	local function fn2()
		if props.ctaButtonComponent then
			return props.ctaButtonComponent
		end

		if not state2 or defineFastFlag and props.disableDefaultPlayButtonOnHover then
			return nil
		end

		local analyticsContext2 = SduiBuilder.buildAnalyticsContext({}, props.analyticsContext, {
			universeId = universeId,
			placeId = placeId,
			eventContext = not FFlagSduiFixSearchTelemetry and "ExperienceTile" or findAnalyticsFieldInAncestors(
				"eventContext",
				props.analyticsContext,
				"ExperienceTile"
			),
			referralSource = props.sduiContext.appPage
		})

		if FFlagSduiTileDisableLegacyHover or not props.enableLegacyHoverState then
			local v7 = localizeStrings(props.sduiContext.dependencies.localization, {
				Join = "Common.VisitGame.Label.Play"
			})

			return React.createElement(SduiPlayButton, {
				universeId = universeId,
				placeId = placeId,
				sduiContext = props.sduiContext,
				playableText = v7.Join,
				hidePlayableIcon = true,
				height = 40,
				width = UDim.new(0, 60),
				buttonSize = "Medium",
				analyticsContext = analyticsContext2,
				hideOptionalText = true,
				isPlayableWhenLoading = true,
				preferSecondaryPlayButton = true,
				enableEarlyAccessState = not FFlagEnableGameJoinEarlyAccess and nil,
				onActivatedEffect = onActivatedEffect,
				enableUiBloxButton = props.enableUiBloxButton == nil or props.enableUiBloxButton,
				openGameDetailsOnPurchaseRequired = props.openGameDetailsOnPurchaseRequired == nil or props.openGameDetailsOnPurchaseRequired
			})
		end

		return React.createElement(SduiPlayButton, {
			universeId = universeId,
			placeId = placeId,
			buttonSize = "Medium",
			fillBehavior = "Fill",
			isPlayableWhenLoading = true,
			preferSecondaryPlayButton = true,
			sduiContext = props.sduiContext,
			analyticsContext = analyticsContext2,
			enableEarlyAccessState = not FFlagEnableGameJoinEarlyAccess and nil,
			onActivatedEffect = onActivatedEffect,
			enableUiBloxButton = props.enableUiBloxButton == nil or props.enableUiBloxButton,
			openGameDetailsOnPurchaseRequired = props.openGameDetailsOnPurchaseRequired == nil or props.openGameDetailsOnPurchaseRequired
		})
	end

	local enableLegacyHoverState2 = props.enableLegacyHoverState

	local ctaButtonComponent = props.ctaButtonComponent
	local analyticsContext2 = props.analyticsContext
	local sduiContext2 = props.sduiContext

	local enableUiBloxButton = props.enableUiBloxButton
	local openGameDetailsOnPurchaseRequired = props.openGameDetailsOnPurchaseRequired
	local v7

	if defineFastFlag then
		v7 = props.disableDefaultPlayButtonOnHover
	end

	local ctaButtonComponent2 = useMemo(fn2, {
		state2,
		enableLegacyHoverState2,
		universeId,
		placeId,
		ctaButtonComponent,
		analyticsContext2,
		sduiContext2,
		onActivatedEffect,
		enableUiBloxButton,
		openGameDetailsOnPurchaseRequired,
		v7
	})
	local renderLegacyHoverState

	if not FFlagSduiTileDisableLegacyHover then
		renderLegacyHoverState = React.useCallback(function(p: number, backgroundColor: Color3, p2: number)
			if not props.enableLegacyHoverState then
				return nil
			end

			return React.createElement("Frame", {
				AutomaticSize = Enum.AutomaticSize.Y,
				Position = UDim2.new(0, -p, 0, -p),
				Size = UDim2.new(1, p * 2, 0, 0),
				BackgroundColor3 = backgroundColor,
				BorderSizePixel = 0,
				BackgroundTransparency = 0,
				[React.Event.MouseEnter] = onMouseEnter,
				[React.Event.MouseLeave] = onMouseLeave,
				ref = ref
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalFlex = Enum.UIFlexAlignment.Fill
				}),
				UIPadding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, p),
					PaddingRight = UDim.new(0, p),
					PaddingBottom = UDim.new(0, p),
					PaddingTop = UDim.new(0, p * 2)
				}),
				UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0, p2) }),
				ctaButtonComponent = ctaButtonComponent2
			})
		end, { ctaButtonComponent2, onMouseEnter, onMouseLeave, props.enableLegacyHoverState })
	end

	local focusNavActionsComponent = nil

	if state then
		if props.focusNavActionsComponent then
			focusNavActionsComponent = React.cloneElement(props.focusNavActionsComponent, {
				extraLocalProps = { guiObject = ref2.current }
			})
		elseif not props.disableHoldToPlay then
			local analyticsContext3 = SduiBuilder.buildAnalyticsContext({}, props.analyticsContext, {
				eventContext = DiscoveryAnalytics.Constants.Context.HoldToPlayLauncher,
				referralSource = props.sduiContext.appPage
			})

			focusNavActionsComponent = React.createElement(SduiHoldToPlay, {
				sduiContext = props.sduiContext,
				analyticsContext = analyticsContext3,
				universeId = universeId,
				placeId = props.placeId,
				guiObject = ref2.current,
				setDisabledForHold = setDisabledForHold
			})
		end
	end

	local useMemo2 = React.useMemo
	local function fn3()
		if props.disableDefaultFooterLogic then
			return props.footerComponent
		end

		local createElement = React.createElement
		local v8 = {
			isHovered = state2,
			isSelected = state,
			ageRatingText = props.ageRatingText,
			footerComponent = props.footerComponent,
			useFooterComponentAsDefault = 0,
			sduiContext = 0,
			universeId = 0,
			placeId = 0,
			analyticsContext = 0,
			ratingText = 0,
			playerCount = 0,
			metadataFontStyle = 0
		}
		local useFooterComponentAsDefault

		if FFlagSduiGameTileUseFooterComponentAsDefault then
			useFooterComponentAsDefault = props.useFooterComponentAsDefault
		end

		v8.useFooterComponentAsDefault = useFooterComponentAsDefault

		v8.sduiContext = props.sduiContext
		v8.universeId = universeId
		v8.placeId = placeId
		v8.analyticsContext = props.analyticsContext
		v8.ratingText = props.ratingText
		v8.playerCount = props.playerCount
		local metadataFontStyle

		if FFlagLuaAppSduiGameTileMetadataFontStyle then
			metadataFontStyle = props.metadataFontStyle
		end

		v8.metadataFontStyle = metadataFontStyle
		return createElement(SduiGameTileFooter, v8)
	end

	local ageRatingText = props.ageRatingText
	local disableDefaultFooterLogic = props.disableDefaultFooterLogic
	local footerComponent = props.footerComponent
	local useFooterComponentAsDefault

	if FFlagSduiGameTileUseFooterComponentAsDefault then
		useFooterComponentAsDefault = props.useFooterComponentAsDefault
	end

	local sduiContext3 = props.sduiContext
	local analyticsContext3 = props.analyticsContext
	local ratingText = props.ratingText
	local playerCount = props.playerCount
	local v8

	if FFlagLuaAppSduiGameTileMetadataFontStyle then
		v8 = props.metadataFontStyle
	end

	local footerComponent2 = useMemo2(fn3, {
		state2,
		state,
		universeId,
		placeId,
		ageRatingText,
		disableDefaultFooterLogic,
		footerComponent,
		useFooterComponentAsDefault,
		sduiContext3,
		analyticsContext3,
		ratingText,
		playerCount,
		v8
	})
	local thumbnailOverflowMenuComponent

	if FFlagLuaAppSduiGameTileFeedback and v4 and props.overflowMenuComponent and not v5 then
		local createElement = React.createElement
		local v9 = {
			componentConfig = props.overflowMenuComponent,
			debugName = "SduiGameTile.OverflowMenu",
			directActionComponentConfig = 0,
			isHovered = 0,
			isSelected = 0,
			menuKey = 0,
			onMenuOpenChanged = 0,
			parentRef = 0,
			sduiContext = 0,
			zIndex = 5
		}
		local directActionComponentConfig

		if FFlagSduiGameTileDirectAction then
			directActionComponentConfig = props.directActionComponent
		end

		v9.directActionComponentConfig = directActionComponentConfig
		v9.isHovered = state2
		v9.isSelected = state
		v9.menuKey = current
		v9.onMenuOpenChanged = onMenuOpenChanged
		v9.parentRef = ref2
		v9.sduiContext = props.sduiContext
		thumbnailOverflowMenuComponent = createElement(SduiTileOverflowMenu, v9)
	end

	local v9

	if FFlagLuaAppSduiVideoThumbnail and props.videoPlayer and not (FFlagLuaAppSduiGameTileFeedback and v5) then
		local cornerRadius = props.cornerRadius or v2.Radius.Medium

		local imageComponent = props.imageComponent

		if not props.imageComponent and props.image ~= nil then
			imageComponent = React.createElement(SduiDefaultTileImage, {
				image = props.image,
				thumbnailBackgroundStyle = props.thumbnailBackgroundStyle,
				isContained = props.isContained,
				cardCornerRadius = cornerRadius
			})
		end

		v9 = React.createElement(SduiGameVideoThumbnail, {
			sduiContext = props.sduiContext,
			analyticsContext = props.analyticsContext,
			videoPlayer = props.videoPlayer,
			imageComponent = imageComponent,
			universeId = universeId,
			placeId = placeId,
			cornerRadius = cornerRadius,
			isHovered = state2,
			isSelected = state,
			playbackCandidateRef = ref2
		})
	end

	local tile

	if FFlagLuaAppSduiGameTileFeedback and v5 and props.hiddenStateComponent then
		local element = React.createElement(getSduiComponentWrapper(props.hiddenStateComponent), {
			componentConfig = props.hiddenStateComponent,
			debugName = "SduiGameTile.HiddenState",
			extraLocalProps = { parentRef = ref2 },
			sduiContext = props.sduiContext
		})

		tile = React.createElement(SduiTile, {
			anchorPoint = props.anchorPoint,
			automaticSize = props.automaticSize,
			backgroundColor3 = props.backgroundColor3,
			backgroundStyle = props.backgroundStyle,
			containmentPadding = props.containmentPadding,
			cornerRadius = props.cornerRadius,
			imageAspectRatio = props.imageAspectRatio,
			imageComponent = element,
			isContained = props.isContained,
			isDisabled = true,
			isHovered = false,
			layoutOrder = props.layoutOrder,
			onMouseEnter = onMouseEnter,
			onMouseLeave = onMouseLeave,
			position = props.position,
			sduiContext = props.sduiContext,
			selectable = false,
			selectionOrder = props.selectionOrder,
			setGuiObject = setGuiObject,
			size = props.size,
			testId = "--sdui-game-tile",
			zIndex = props.zIndex
		})
	else
		local createElement = React.createElement

		local join = Cryo.Dictionary.join
		local v10 = {
			ctaButtonComponent = ctaButtonComponent2,
			onMouseEnter = onMouseEnter,
			onMouseLeave = onMouseLeave,
			onSelectionGained = onSelectionGained,
			onSelectionLost = onSelectionLost,
			renderLegacyHoverState = nil,
			isHovered = nil,
			imageComponent = 0,
			setGuiObject = 0,
			onActivated = 0,
			onTouchLongPress = 0,
			thumbnailOverflowMenuComponent = 0,
			focusNavActionsComponent = 0,
			footerComponent = 0,
			testId = "--sdui-game-tile"
		}

		if FFlagSduiTileDisableLegacyHover then
			renderLegacyHoverState = nil
		end

		v10.renderLegacyHoverState = renderLegacyHoverState
		v10.isHovered = state2
		v10.imageComponent = FFlagLuaAppSduiVideoThumbnail and v9 or props.imageComponent
		v10.setGuiObject = setGuiObject
		v10.onActivated = onActivated2

		if not (FFlagLuaAppSduiGameTileFeedback and thumbnailOverflowMenuComponent) then
			onTouchLongPress = nil
		end

		v10.onTouchLongPress = onTouchLongPress

		if not FFlagLuaAppSduiGameTileFeedback then
			thumbnailOverflowMenuComponent = nil
		end

		v10.thumbnailOverflowMenuComponent = thumbnailOverflowMenuComponent
		v10.focusNavActionsComponent = focusNavActionsComponent
		v10.footerComponent = footerComponent2
		tile = createElement(SduiTile, join(props, v10))
	end

	if not enableLegacyHoverState then
		return tile
	end

	local xSmall = v2.Gap.XSmall
	local createElement = React.createElement
	local v10 = {
		isZoomEnabled = state2 and (not FFlagLuaAppSduiGameTileFeedback or not v5),
		expansionOffsetX = xSmall * 2,
		expansionOffsetTop = xSmall,
		expansionOffsetBottom = xSmall,
		reducedMotion = v3.reducedMotion
	}
	local hoverShadow

	if state2 and not (FFlagLuaAppSduiGameTileFeedback and v5) and ref then
		hoverShadow = React.createElement(TileHoverShadow, {
			contentRef = ref,
			hoverPadding = props.containmentPadding,
			containmentPadding = props.containmentPadding
		})
	end

	return createElement(ZoomAnimatedFrame, v10, { HoverShadow = hoverShadow, Tile = tile })
end

return React.memo(SduiGameTile)
