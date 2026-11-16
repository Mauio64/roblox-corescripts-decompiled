local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Responsive")
local getInputModeStore = Responsive.GetInputModeStore
local AppBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/AppBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Foundation")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Cryo")
local DiscoveryAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DiscoveryAnalytics")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SignalsReact")
local localizeStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Localization").localizeStrings
local useTokens = Foundation.Hooks.useTokens
local usePreferences = Foundation.Hooks.usePreferences
local gameTileOverflowMenuAction = DiscoveryAnalytics.Events.gameTileOverflowMenuAction

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiActionType = SduiCoreSystem.SduiActionType
local sduiBuilder = SduiCoreSystem.SduiBuilder
local sduiErrors = SduiCoreSystem.SduiErrors
local getSduiComponentWrapper = SduiCoreSystem.getSduiComponentWrapper
local SduiSharedContent = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedContent")
local sduiPlayButton = SduiSharedContent.SduiPlayButton
local sduiTileOverflowMenu = SduiSharedContent.SduiTileOverflowMenu
local sduiParsers = SduiCoreSystem.SduiParsers
local sduiParseHelpers = SduiCoreSystem.SduiParseHelpers
local useUidRefString = SduiCoreSystem.useUidRefString
local findAnalyticsFieldInAncestors = SduiCoreSystem.findAnalyticsFieldInAncestors
local videoEndReason = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/VideoUtils").AnalyticsEnums.VideoEndReason

local GameTile = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/GameTile")
local default = GameTile.HoverTileCoordinator.default
local zoomAnimatedFrame = GameTile.ZoomAnimatedFrame
local getGameTileHiddenStore = GameTile.getGameTileHiddenStore
local getOverflowMenuSignalStore = AppBlox.getOverflowMenuSignalStore
local SduiTile = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/SduiTile")
local SduiGameVideoThumbnail = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/SduiGameVideoThumbnail")
local TileHoverShadow = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/TileHoverShadow")
local SduiGameTileFooter = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/SduiGameTileFooter")
local SduiHoldToPlay = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/FocusNavigation/SduiHoldToPlay")
local SduiDefaultTileImage = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/SduiDefaultTileImage")

local fFlagSduiTileDisableLegacyHover = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Flags").FFlagSduiTileDisableLegacyHover
local fFlagEnableGameJoinEarlyAccess = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagEnableGameJoinEarlyAccess
local fFlagLuaAppSduiVideoThumbnail = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppSduiVideoThumbnail
local fFlagLuaAppSduiGameTileFeedback = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppSduiGameTileFeedback
local fFlagLuaAppSduiGameTileMetadataFontStyle = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppSduiGameTileMetadataFontStyle
local fFlagSduiFixSearchTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiFixSearchTelemetry

local defineFastFlag = game:DefineFastFlag("SduiGameTileDisableDefaultPlayButtonOnHover", false)
local fFlagSduiGameTileEnableHoverInVR = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiGameTileEnableHoverInVR
local fFlagSduiGameTileDirectAction = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiGameTileDirectAction

local fFlagSduiGameTileUseFooterComponentAsDefault = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiGameTileUseFooterComponentAsDefault

local v5 = if fFlagLuaAppSduiGameTileFeedback then Signals.createSignal(false) else nil

local function SduiGameTile(props)
	local v6 = useTokens()
	local v7 = usePreferences()
	local enableLegacyHoverState = not fFlagSduiTileDisableLegacyHover and props.enableLegacyHoverState

	local videoPlaybackContext = if fFlagLuaAppSduiVideoThumbnail then props.sduiContext.videoPlaybackContext else nil

	local ref = React.useRef(nil)

	local current = useUidRefString().current

	local universeId = props.universeId
	local placeId = props.placeId

	local ref2 = React.useRef(nil)
	local v8 = React.useCallback(function(current2)
		ref2.current = current2

		if props.setGuiObject then
			props.setGuiObject(current2)
		end
	end, { props.setGuiObject })
	local v9, v10, triggerFeedback

	if fFlagLuaAppSduiGameTileFeedback then
		v9 = props.overflowMenuComponent ~= nil
			and props.collectionId ~= nil
			and props.collectionId ~= ""
			and props.hiddenStateComponent ~= nil

		local v12 = React.useMemo(function()
			if not v9 then
				return v5
			end

			local getHiddenGames = getGameTileHiddenStore(props.collectionId).getHiddenGames
			return Signals.createComputed(function(p2): boolean
				return getHiddenGames(p2)[universeId] == true
			end)
		end, { v9, props.collectionId, universeId })

		v10 = SignalsReact.useSignalState(v12)

		triggerFeedback = props.sduiContext.dependencies.triggerFeedback
	else
		v10 = nil
		triggerFeedback = nil
		v9 = nil
	end

	local ref3 = React.useRef(false)
	local v11 = React.useCallback(function(current2)
		ref3.current = current2
	end, {})

	local function fn()
		props.sduiContext.dependencies.logger.reportCounter(
			sduiErrors.SduiCounterName.GameTileActivated,
			{
				name = getInputModeStore(false).getLastInputType(false)
			},
			true
		)

		local function logFailure(p2)
			local v12 = not p2 and "" or sduiParseHelpers.stringifyValue(p2)
			local stringifyValue = sduiParseHelpers.stringifyValue(props.componentConfig)
			props.sduiContext.dependencies.logger.reportError(
				sduiErrors.SduiErrorType.FailedToExecuteAction,
				{
					componentType = "GameTile",
					message = `Error executing GameTile.onActivated error: '{v12}' config: {stringifyValue}`,
					name = getInputModeStore(false).getLastInputType(false)
				},
				props.sduiContext.appPage
			)
		end

		local success, result = pcall(function()
			if ref3.current then
				props.sduiContext.dependencies.logger.reportCounter(
					sduiErrors.SduiCounterName.GameTileActivatedWhenDisabled,
					{
						name = getInputModeStore(false).getLastInputType(false)
					}
				)

				return
			end

			if fFlagLuaAppSduiVideoThumbnail and videoPlaybackContext then
				videoPlaybackContext.videoPlaybackCoordinator:reset(
					videoEndReason.TileClicked,
					nil,
					universeId,
					nil
				)
			end

			if props.onActivated then
				props.onActivated()
				return
			end

			local safeParseCallback = sduiParsers.safeParseCallback({
				actionType = sduiActionType.OpenGameDetails,
				actionParams = { placeId = placeId, universeId = universeId }
			}, props.sduiContext, props.analyticsContext)

			if not safeParseCallback then
				logFailure("Callback is nil after parsing")
				return
			end

			props.sduiContext.dependencies.logger.reportCounter(
				sduiErrors.SduiCounterName.GameTileActivatedExecuteCallback,
				{
					name = getInputModeStore(false).getLastInputType(false)
				},
				true
			)

			safeParseCallback()
		end)

		if not success then
			logFailure(result)
		end
	end

	local v14 = React.useCallback(fn, {
		props.onActivated,
		props.sduiContext,
		props.analyticsContext,
		placeId,
		universeId,
		props.componentConfig,
		if fFlagLuaAppSduiVideoThumbnail then videoPlaybackContext else nil
	})

	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)

	local v15 = React.useCallback(function()
		setState(true)

		if props.setCustomConditionState then
			props.setCustomConditionState("selected", true)
		end
	end, { props.setCustomConditionState })

	local v16 = React.useCallback(function()
		setState(false)

		if props.setCustomConditionState then
			props.setCustomConditionState("selected", false)
		end
	end, { props.setCustomConditionState })

	if fFlagLuaAppSduiGameTileFeedback then
		React.useEffect(function()
			if v10 then
				getOverflowMenuSignalStore().closeMenu(current)
				v16()
			end
		end, { v10, current, v16 })
	end

	local ref4 = React.useRef(0)

	if state2 == false then
		ref4.current = 0
	end

	local default2 = default.default
	local v17 = React.useCallback(function()
		if ref4.current == 0 and current then
			local v18

			if fFlagSduiGameTileEnableHoverInVR then
				v18 = getInputModeStore(false).getPreferredInputType(false) == Responsive.Input.Pointer
			else
				v18 = getInputModeStore(false).getLastInputType(false) == Responsive.Input.Pointer
			end

			if v18 then
				default2:requestHover(current)
			end
		end

		ref4.current += 1
	end, { current })
	local v18 = React.useCallback(function()
		ref4.current -= 1

		if ref4.current < 0 then
			ref4.current = 0
		end

		if ref4.current == 0 and current then
			default2:cancelHover(current)
		end
	end, { current })

	React.useEffect(function()
		local v19 = current
		local v20 = state2

		local changedConnection = default2.changed:connect(function(p2)
			local v21 = p2 == current
			setState2(v21)

			if props.setCustomConditionState and v21 ~= v20 then
				props.setCustomConditionState("hovered", v21)
			end

			v20 = v21
		end)
		return function()
			default2:cancelHover(v19)
			ref4.current = 0

			if changedConnection ~= nil then
				changedConnection:disconnect()
			end
		end
	end, { current, props.setCustomConditionState })
	local v19, v20

	if fFlagLuaAppSduiGameTileFeedback then
		v19 = React.useCallback(function(p2)
			gameTileOverflowMenuAction({
				universeId = universeId,
				sortId = props.collectionId,
				actionType = p2 and "GameTileOverflowMenuClosed" or "GameTileOverflowMenuOpened"
			}, props.sduiContext.appPage)
		end, { universeId, props.collectionId, props.sduiContext.appPage })

		v20 = React.useCallback(function()
			local overflowMenuSignalStore = getOverflowMenuSignalStore()

			if triggerFeedback and not overflowMenuSignalStore.getIsMenuOpen(current) then
				triggerFeedback("TileLongPress", "Press", props.sduiContext.appPage or "Unknown", {
					universeId = universeId,
					sortId = props.collectionId
				})
			end

			overflowMenuSignalStore.openMenu(current)
			v19(false)
		end, {
			triggerFeedback,
			current,
			props.sduiContext.appPage,
			props.collectionId,
			v19,
			universeId
		})
	else
		v19 = nil
	end

	local v21 = React.useCallback(function()
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

		local analyticsContext2 = sduiBuilder.buildAnalyticsContext({}, props.analyticsContext, {
			universeId = universeId,
			placeId = placeId,
			eventContext = not fFlagSduiFixSearchTelemetry and "ExperienceTile" or findAnalyticsFieldInAncestors(
				"eventContext",
				props.analyticsContext,
				"ExperienceTile"
			),
			referralSource = props.sduiContext.appPage
		})

		if fFlagSduiTileDisableLegacyHover or not props.enableLegacyHoverState then
			local v22 = localizeStrings(props.sduiContext.dependencies.localization, {
				Join = "Common.VisitGame.Label.Play"
			})

			return React.createElement(sduiPlayButton, {
				universeId = universeId,
				placeId = placeId,
				sduiContext = props.sduiContext,
				playableText = v22.Join,
				hidePlayableIcon = true,
				height = 40,
				width = UDim.new(0, 60),
				buttonSize = "Medium",
				analyticsContext = analyticsContext2,
				hideOptionalText = true,
				isPlayableWhenLoading = true,
				preferSecondaryPlayButton = true,
				enableEarlyAccessState = if fFlagEnableGameJoinEarlyAccess then false else nil,
				onActivatedEffect = v21,
				enableUiBloxButton = props.enableUiBloxButton == nil or props.enableUiBloxButton,
				openGameDetailsOnPurchaseRequired = props.openGameDetailsOnPurchaseRequired == nil or props.openGameDetailsOnPurchaseRequired
			})
		end

		return React.createElement(sduiPlayButton, {
			universeId = universeId,
			placeId = placeId,
			buttonSize = "Medium",
			fillBehavior = "Fill",
			isPlayableWhenLoading = true,
			preferSecondaryPlayButton = true,
			sduiContext = props.sduiContext,
			analyticsContext = analyticsContext2,
			enableEarlyAccessState = if fFlagEnableGameJoinEarlyAccess then false else nil,
			onActivatedEffect = v21,
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
	local v23 = if defineFastFlag then props.disableDefaultPlayButtonOnHover else nil
	local v24 = useMemo(fn2, {
		state2,
		enableLegacyHoverState2,
		universeId,
		placeId,
		ctaButtonComponent,
		analyticsContext2,
		sduiContext2,
		v21,
		enableUiBloxButton,
		openGameDetailsOnPurchaseRequired,
		v23
	})
	local v25

	if not fFlagSduiTileDisableLegacyHover then
		v25 = React.useCallback(function(p2, p3, p4)
			if not props.enableLegacyHoverState then
				return nil
			end

			return React.createElement("Frame", {
				AutomaticSize = Enum.AutomaticSize.Y,
				Position = UDim2.new(0, -p2, 0, -p2),
				Size = UDim2.new(1, 2 * p2, 0, 0),
				BackgroundColor3 = p3,
				BorderSizePixel = 0,
				BackgroundTransparency = 0,
				[React.Event.MouseEnter] = v17,
				[React.Event.MouseLeave] = v18,
				ref = ref
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalFlex = Enum.UIFlexAlignment.Fill
				}),
				UIPadding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, p2),
					PaddingRight = UDim.new(0, p2),
					PaddingBottom = UDim.new(0, p2),
					PaddingTop = UDim.new(0, p2 * 2)
				}),
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, p4)
				}),
				ctaButtonComponent = v24
			})
		end, { v24, v17, v18, props.enableLegacyHoverState })
	end

	local v26 = nil

	if state then
		if props.focusNavActionsComponent then
			v26 = React.cloneElement(props.focusNavActionsComponent, {
				extraLocalProps = { guiObject = ref2.current }
			})
		elseif not props.disableHoldToPlay then
			local analyticsContext3 = sduiBuilder.buildAnalyticsContext({}, props.analyticsContext, {
				eventContext = DiscoveryAnalytics.Constants.Context.HoldToPlayLauncher,
				referralSource = props.sduiContext.appPage
			})

			v26 = React.createElement(SduiHoldToPlay, {
				sduiContext = props.sduiContext,
				analyticsContext = analyticsContext3,
				universeId = universeId,
				placeId = props.placeId,
				guiObject = ref2.current,
				setDisabledForHold = v11
			})
		end
	end

	local useMemo2 = React.useMemo
	local function fn3()
		if props.disableDefaultFooterLogic then
			return props.footerComponent
		end

		local createElement = React.createElement
		local v28 = {
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

		local v29 = if fFlagSduiGameTileUseFooterComponentAsDefault then props.useFooterComponentAsDefault else nil
		v28.useFooterComponentAsDefault = v29

		v28.sduiContext = props.sduiContext
		v28.universeId = universeId
		v28.placeId = placeId
		v28.analyticsContext = props.analyticsContext
		v28.ratingText = props.ratingText
		v28.playerCount = props.playerCount
		local v30 = if fFlagLuaAppSduiGameTileMetadataFontStyle then props.metadataFontStyle else nil
		v28.metadataFontStyle = v30
		return createElement(SduiGameTileFooter, v28)
	end

	local ageRatingText = props.ageRatingText
	local disableDefaultFooterLogic = props.disableDefaultFooterLogic
	local footerComponent = props.footerComponent
	local useFooterComponentAsDefault

	if fFlagSduiGameTileUseFooterComponentAsDefault then
		useFooterComponentAsDefault = props.useFooterComponentAsDefault
	end

	local sduiContext3 = props.sduiContext
	local analyticsContext3 = props.analyticsContext
	local ratingText = props.ratingText
	local playerCount = props.playerCount
	local v28 = if fFlagLuaAppSduiGameTileMetadataFontStyle then props.metadataFontStyle else nil
	local v29 = useMemo2(fn3, {
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
		v28
	})
	local v30

	if fFlagLuaAppSduiGameTileFeedback and v9 and props.overflowMenuComponent and not v10 then
		local createElement = React.createElement
		local v32 = {
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

		local v33 = if fFlagSduiGameTileDirectAction then props.directActionComponent else nil
		v32.directActionComponentConfig = v33
		v32.isHovered = state2
		v32.isSelected = state
		v32.menuKey = current
		v32.onMenuOpenChanged = v19
		v32.parentRef = ref2
		v32.sduiContext = props.sduiContext
		v30 = createElement(sduiTileOverflowMenu, v32)
	end

	local v31

	if
		fFlagLuaAppSduiVideoThumbnail
		and props.videoPlayer
		and not (fFlagLuaAppSduiGameTileFeedback and v10)
	then
		local cornerRadius = props.cornerRadius or v6.Radius.Medium

		local v32 = props.imageComponent

		if not props.imageComponent and props.image ~= nil then
			v32 = React.createElement(SduiDefaultTileImage, {
				image = props.image,
				thumbnailBackgroundStyle = props.thumbnailBackgroundStyle,
				isContained = props.isContained,
				cardCornerRadius = cornerRadius
			})
		end

		v31 = React.createElement(SduiGameVideoThumbnail, {
			sduiContext = props.sduiContext,
			analyticsContext = props.analyticsContext,
			videoPlayer = props.videoPlayer,
			imageComponent = v32,
			universeId = universeId,
			placeId = placeId,
			cornerRadius = cornerRadius,
			isHovered = state2,
			isSelected = state,
			playbackCandidateRef = ref2
		})
	end

	local v32

	if fFlagLuaAppSduiGameTileFeedback and v10 and props.hiddenStateComponent then
		local element = React.createElement(getSduiComponentWrapper(props.hiddenStateComponent), {
			componentConfig = props.hiddenStateComponent,
			debugName = "SduiGameTile.HiddenState",
			extraLocalProps = { parentRef = ref2 },
			sduiContext = props.sduiContext
		})

		v32 = React.createElement(SduiTile, {
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
			onMouseEnter = v17,
			onMouseLeave = v18,
			position = props.position,
			sduiContext = props.sduiContext,
			selectable = false,
			selectionOrder = props.selectionOrder,
			setGuiObject = v8,
			size = props.size,
			testId = "--sdui-game-tile",
			zIndex = props.zIndex
		})
	else
		local createElement = React.createElement

		local join = Cryo.Dictionary.join
		local v34 = {
			ctaButtonComponent = v24,
			onMouseEnter = v17,
			onMouseLeave = v18,
			onSelectionGained = v15,
			onSelectionLost = v16,
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

		if fFlagSduiTileDisableLegacyHover then
			v25 = nil
		end

		v34.renderLegacyHoverState = v25
		v34.isHovered = state2
		v34.imageComponent = fFlagLuaAppSduiVideoThumbnail and v31 or props.imageComponent
		v34.setGuiObject = v8
		v34.onActivated = v14

		if not (fFlagLuaAppSduiGameTileFeedback and v30) then
			v20 = nil
		end

		v34.onTouchLongPress = v20

		if not fFlagLuaAppSduiGameTileFeedback then
			v30 = nil
		end

		v34.thumbnailOverflowMenuComponent = v30
		v34.focusNavActionsComponent = v26
		v34.footerComponent = v29
		v32 = createElement(SduiTile, join(props, v34))
	end

	if not enableLegacyHoverState then
		return v32
	end

	local xSmall = v6.Gap.XSmall
	local createElement = React.createElement
	local v34 = {
		isZoomEnabled = state2 and (not fFlagLuaAppSduiGameTileFeedback or not v10),
		expansionOffsetX = xSmall * 2,
		expansionOffsetTop = xSmall,
		expansionOffsetBottom = xSmall,
		reducedMotion = v7.reducedMotion
	}

	local v36 = if state2 and not (fFlagLuaAppSduiGameTileFeedback and v10) and ref then React.createElement(TileHoverShadow, {
		contentRef = ref,
		hoverPadding = props.containmentPadding,
		containmentPadding = props.containmentPadding
	}) else nil
	return createElement(zoomAnimatedFrame, v34, { HoverShadow = v36, Tile = v32 })
end

return React.memo(SduiGameTile)
