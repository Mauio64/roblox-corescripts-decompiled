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
local useTriggerGameTileFeedbackCallbacks = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/GameCollections").useTriggerGameTileFeedbackCallbacks
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

local fFlagLuaAppSduiGameTileInteractionFeedback = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppSduiGameTileInteractionFeedback
local fFlagSduiFixSearchTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiFixSearchTelemetry

local defineFastFlag = game:DefineFastFlag("SduiGameTileDisableDefaultPlayButtonOnHover", false)
local fFlagSduiGameTileEnableHoverInVR = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiGameTileEnableHoverInVR
local fFlagSduiGameTileDirectAction = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiGameTileDirectAction

local fFlagSduiGameTileUseFooterComponentAsDefault = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiGameTileUseFooterComponentAsDefault

local fFlagLuaAppSduiGameTileFooterTrailingComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppSduiGameTileFooterTrailingComponent
local fFlagSduiActiveFriendsFooterTreatment = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiActiveFriendsFooterTreatment

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
		triggerFeedback = nil
		v10 = nil
		v9 = nil
	end

	local ref3 = React.useRef(false)
	local v11 = React.useCallback(function(current2)
		ref3.current = current2
	end, {})
	local v12, v13

	if fFlagLuaAppSduiGameTileInteractionFeedback then
		v12, v13 = useTriggerGameTileFeedbackCallbacks(triggerFeedback)
	else
		v13 = nil
	end

	local useCallback = React.useCallback
	local function fn()
		props.sduiContext.dependencies.logger.reportCounter(
			sduiErrors.SduiCounterName.GameTileActivated,
			{
				name = getInputModeStore(false).getLastInputType(false)
			},
			true
		)

		local function logFailure(p2)
			local v14 = not p2 and "" or sduiParseHelpers.stringifyValue(p2)
			local stringifyValue = sduiParseHelpers.stringifyValue(props.componentConfig)
			props.sduiContext.dependencies.logger.reportError(
				sduiErrors.SduiErrorType.FailedToExecuteAction,
				{
					componentType = "GameTile",
					message = `Error executing GameTile.onActivated error: '{v14}' config: {stringifyValue}`,
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

		if fFlagLuaAppSduiGameTileInteractionFeedback and v13 then
			v13()
		end
	end

	local onActivated = props.onActivated
	local sduiContext = props.sduiContext
	local analyticsContext = props.analyticsContext

	local componentConfig = props.componentConfig
	local v15 = if fFlagLuaAppSduiVideoThumbnail then videoPlaybackContext else nil
	local v17 = useCallback(fn, {
		onActivated,
		sduiContext,
		analyticsContext,
		placeId,
		universeId,
		componentConfig,
		v15,
		if fFlagLuaAppSduiGameTileInteractionFeedback then v13 else nil
	})

	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)

	local v18 = React.useCallback(function()
		setState(true)

		if props.setCustomConditionState then
			props.setCustomConditionState("selected", true)
		end
	end, { props.setCustomConditionState })

	local v19 = React.useCallback(function()
		setState(false)

		if props.setCustomConditionState then
			props.setCustomConditionState("selected", false)
		end
	end, { props.setCustomConditionState })

	if fFlagLuaAppSduiGameTileFeedback then
		React.useEffect(function()
			if v10 then
				getOverflowMenuSignalStore().closeMenu(current)
				v19()
			end
		end, { v10, current, v19 })
	end

	local ref4 = React.useRef(0)

	if state2 == false then
		ref4.current = 0
	end

	local default2 = default.default
	local v20 = React.useCallback(function()
		if ref4.current == 0 and current then
			local v21

			if fFlagSduiGameTileEnableHoverInVR then
				v21 = getInputModeStore(false).getPreferredInputType(false) == Responsive.Input.Pointer
			else
				v21 = getInputModeStore(false).getLastInputType(false) == Responsive.Input.Pointer
			end

			if v21 then
				default2:requestHover(current)
			end
		end

		ref4.current += 1
	end, { current })
	local v21 = React.useCallback(function()
		ref4.current -= 1

		if ref4.current < 0 then
			ref4.current = 0
		end

		if ref4.current == 0 and current then
			default2:cancelHover(current)
		end
	end, { current })

	React.useEffect(function()
		local v22 = current
		local v23 = state2

		local changedConnection = default2.changed:connect(function(p2)
			local v24 = p2 == current
			setState2(v24)

			if props.setCustomConditionState and v24 ~= v23 then
				props.setCustomConditionState("hovered", v24)
			end

			v23 = v24
		end)
		return function()
			default2:cancelHover(v22)
			ref4.current = 0

			if changedConnection ~= nil then
				changedConnection:disconnect()
			end
		end
	end, { current, props.setCustomConditionState })
	local v22, v23

	if fFlagLuaAppSduiGameTileFeedback then
		v22 = React.useCallback(function(p2)
			gameTileOverflowMenuAction({
				universeId = universeId,
				sortId = props.collectionId,
				actionType = p2 and "GameTileOverflowMenuClosed" or "GameTileOverflowMenuOpened"
			}, props.sduiContext.appPage)
		end, { universeId, props.collectionId, props.sduiContext.appPage })

		v23 = React.useCallback(function()
			local overflowMenuSignalStore = getOverflowMenuSignalStore()

			if triggerFeedback and not overflowMenuSignalStore.getIsMenuOpen(current) then
				triggerFeedback("TileLongPress", "Press", props.sduiContext.appPage or "Unknown", {
					universeId = universeId,
					sortId = props.collectionId
				})
			end

			overflowMenuSignalStore.openMenu(current)
			v22(false)
		end, {
			triggerFeedback,
			current,
			props.sduiContext.appPage,
			props.collectionId,
			v22,
			universeId
		})
	else
		v22 = nil
	end

	local v24 = React.useCallback(function()
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
			local v25 = localizeStrings(props.sduiContext.dependencies.localization, {
				Join = "Common.VisitGame.Label.Play"
			})

			return React.createElement(sduiPlayButton, {
				universeId = universeId,
				placeId = placeId,
				sduiContext = props.sduiContext,
				playableText = v25.Join,
				hidePlayableIcon = true,
				height = 40,
				width = UDim.new(0, 60),
				buttonSize = "Medium",
				analyticsContext = analyticsContext2,
				hideOptionalText = true,
				isPlayableWhenLoading = true,
				preferSecondaryPlayButton = true,
				enableEarlyAccessState = if fFlagEnableGameJoinEarlyAccess then false else nil,
				onActivatedEffect = v24,
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
			onActivatedEffect = v24,
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
	local v26 = if defineFastFlag then props.disableDefaultPlayButtonOnHover else nil
	local v27 = useMemo(fn2, {
		state2,
		enableLegacyHoverState2,
		universeId,
		placeId,
		ctaButtonComponent,
		analyticsContext2,
		sduiContext2,
		v24,
		enableUiBloxButton,
		openGameDetailsOnPurchaseRequired,
		v26
	})
	local v28

	if not fFlagSduiTileDisableLegacyHover then
		v28 = React.useCallback(function(p2, p3, p4)
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
				[React.Event.MouseEnter] = v20,
				[React.Event.MouseLeave] = v21,
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
				ctaButtonComponent = v27
			})
		end, { v27, v20, v21, props.enableLegacyHoverState })
	end

	local v29 = nil

	if state then
		if props.focusNavActionsComponent then
			v29 = React.cloneElement(props.focusNavActionsComponent, {
				extraLocalProps = { guiObject = ref2.current }
			})
		elseif not props.disableHoldToPlay then
			local analyticsContext3 = sduiBuilder.buildAnalyticsContext({}, props.analyticsContext, {
				eventContext = DiscoveryAnalytics.Constants.Context.HoldToPlayLauncher,
				referralSource = props.sduiContext.appPage
			})

			v29 = React.createElement(SduiHoldToPlay, {
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
		local v31 = {
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
			metadataFontStyle = 0,
			activeFriendsFooterComponent = 0
		}

		local v32 = if fFlagSduiGameTileUseFooterComponentAsDefault then props.useFooterComponentAsDefault else nil
		v31.useFooterComponentAsDefault = v32

		v31.sduiContext = props.sduiContext
		v31.universeId = universeId
		v31.placeId = placeId
		v31.analyticsContext = props.analyticsContext
		v31.ratingText = props.ratingText
		v31.playerCount = props.playerCount
		v31.metadataFontStyle = props.metadataFontStyle

		local v33 = if fFlagSduiActiveFriendsFooterTreatment then props.activeFriendsFooterComponent else nil
		v31.activeFriendsFooterComponent = v33
		return createElement(SduiGameTileFooter, v31)
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
	local metadataFontStyle = props.metadataFontStyle
	local v31 = if fFlagSduiActiveFriendsFooterTreatment then props.activeFriendsFooterComponent else nil
	local v32 = useMemo2(fn3, {
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
		metadataFontStyle,
		v31
	})
	local v33

	if fFlagLuaAppSduiGameTileFooterTrailingComponent then
		v33 = React.useMemo(function()
			if props.footerTrailingComponent then
				return React.createElement(
					"Frame",
					{
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundTransparency = 1,
						Size = UDim2.fromScale(1, 0)
					},
					{
						UIListLayout = React.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Vertical,
							SortOrder = Enum.SortOrder.Name,
							HorizontalFlex = Enum.UIFlexAlignment.Fill
						}),
						["1_Footer"] = v32,
						["2_FooterTrailing"] = props.footerTrailingComponent
					}
				)
			end

			return v32
		end, { props.footerTrailingComponent, v32 })
	end

	local v34

	if fFlagLuaAppSduiGameTileFeedback and v9 and props.overflowMenuComponent and not v10 then
		local createElement = React.createElement
		local v36 = {
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

		local v37 = if fFlagSduiGameTileDirectAction then props.directActionComponent else nil
		v36.directActionComponentConfig = v37
		v36.isHovered = state2
		v36.isSelected = state
		v36.menuKey = current
		v36.onMenuOpenChanged = v22
		v36.parentRef = ref2
		v36.sduiContext = props.sduiContext
		v34 = createElement(sduiTileOverflowMenu, v36)
	end

	local v35

	if
		fFlagLuaAppSduiVideoThumbnail
		and props.videoPlayer
		and not (fFlagLuaAppSduiGameTileFeedback and v10)
	then
		local cornerRadius = props.cornerRadius or v6.Radius.Medium

		local v36 = props.imageComponent

		if not props.imageComponent and props.image ~= nil then
			v36 = React.createElement(SduiDefaultTileImage, {
				image = props.image,
				thumbnailBackgroundStyle = props.thumbnailBackgroundStyle,
				isContained = props.isContained,
				cardCornerRadius = cornerRadius
			})
		end

		v35 = React.createElement(SduiGameVideoThumbnail, {
			sduiContext = props.sduiContext,
			analyticsContext = props.analyticsContext,
			videoPlayer = props.videoPlayer,
			imageComponent = v36,
			universeId = universeId,
			placeId = placeId,
			cornerRadius = cornerRadius,
			isHovered = state2,
			isSelected = state,
			playbackCandidateRef = ref2
		})
	end

	local v36

	if fFlagLuaAppSduiGameTileFeedback and v10 and props.hiddenStateComponent then
		local element = React.createElement(getSduiComponentWrapper(props.hiddenStateComponent), {
			componentConfig = props.hiddenStateComponent,
			debugName = "SduiGameTile.HiddenState",
			extraLocalProps = { parentRef = ref2 },
			sduiContext = props.sduiContext
		})

		v36 = React.createElement(SduiTile, {
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
			onMouseEnter = v20,
			onMouseLeave = v21,
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
		local v38 = {
			ctaButtonComponent = v27,
			onMouseEnter = v20,
			onMouseLeave = v21,
			onSelectionGained = v18,
			onSelectionLost = v19,
			onGuiStateChanged = nil,
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

		if not fFlagLuaAppSduiGameTileInteractionFeedback then
			v12 = nil
		end

		v38.onGuiStateChanged = v12

		if fFlagSduiTileDisableLegacyHover then
			v28 = nil
		end

		v38.renderLegacyHoverState = v28
		v38.isHovered = state2
		v38.imageComponent = fFlagLuaAppSduiVideoThumbnail and v35 or props.imageComponent
		v38.setGuiObject = v8
		v38.onActivated = v17

		if not (fFlagLuaAppSduiGameTileFeedback and v34) then
			v23 = nil
		end

		v38.onTouchLongPress = v23

		if not fFlagLuaAppSduiGameTileFeedback then
			v34 = nil
		end

		v38.thumbnailOverflowMenuComponent = v34
		v38.focusNavActionsComponent = v29

		if not fFlagLuaAppSduiGameTileFooterTrailingComponent then
			v33 = v32
		end

		v38.footerComponent = v33
		v36 = createElement(SduiTile, join(props, v38))
	end

	if not enableLegacyHoverState then
		return v36
	end

	local xSmall = v6.Gap.XSmall
	local createElement = React.createElement
	local v38 = {
		isZoomEnabled = state2 and (not fFlagLuaAppSduiGameTileFeedback or not v10),
		expansionOffsetX = xSmall * 2,
		expansionOffsetTop = xSmall,
		expansionOffsetBottom = xSmall,
		reducedMotion = v7.reducedMotion
	}

	local v40 = if state2 and not (fFlagLuaAppSduiGameTileFeedback and v10) and ref then React.createElement(TileHoverShadow, {
		contentRef = ref,
		hoverPadding = props.containmentPadding,
		containmentPadding = props.containmentPadding
	}) else nil
	return createElement(zoomAnimatedFrame, v38, { HoverShadow = v40, Tile = v36 })
end

return React.memo(SduiGameTile)
