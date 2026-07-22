local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local React = require(ServerDrivenUiParent.React)
local Responsive = require(ServerDrivenUiParent.Responsive)
local GetInputModeStore = Responsive.GetInputModeStore
local Foundation = require(ServerDrivenUiParent.Foundation)
local Cryo = require(ServerDrivenUiParent.Cryo)
local DiscoveryAnalytics = require(ServerDrivenUiParent.DiscoveryAnalytics)
local localizeStrings = require(ServerDrivenUiParent.Localization).localizeStrings
local useTokens = Foundation.Hooks.useTokens
local usePreferences = Foundation.Hooks.usePreferences
local SduiCoreSystem = require(ServerDrivenUiParent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiBuilder = SduiCoreSystem.SduiBuilder
local SduiErrors = SduiCoreSystem.SduiErrors
local SduiPlayButton = require(ServerDrivenUiParent.SduiSharedContent).SduiPlayButton
local SduiParsers = SduiCoreSystem.SduiParsers
local SduiParseHelpers = SduiCoreSystem.SduiParseHelpers
local useUidRefString = SduiCoreSystem.useUidRefString
local GameTile = require(ServerDrivenUiParent.GameTile)
local default = GameTile.HoverTileCoordinator.default
local ZoomAnimatedFrame = GameTile.ZoomAnimatedFrame
local SduiTile = require(ServerDrivenUi.Content.SduiTile)
local TileHoverShadow = require(ServerDrivenUi.Content.TileHoverShadow)
local SduiGameTileFooter = require(ServerDrivenUi.Content.SduiGameTileFooter)
local SduiHoldToPlay = require(ServerDrivenUi.FocusNavigation.SduiHoldToPlay)
local FFlagSduiTileDisableLegacyHover = require(ServerDrivenUi.Flags).FFlagSduiTileDisableLegacyHover
local FFlagLuaAppResetHoverOnSduiPlayButtonActivation = require(ServerDrivenUiParent.SharedFlags).FFlagLuaAppResetHoverOnSduiPlayButtonActivation
local FFlagLuaAppSduiGameTileHoverShadow = require(ServerDrivenUiParent.SharedFlags).FFlagLuaAppSduiGameTileHoverShadow
local FFlagLuaAppSduiGameTilePlayButtonDefaults = require(ServerDrivenUiParent.SharedFlags).FFlagLuaAppSduiGameTilePlayButtonDefaults
local FFlagLuaAppDemoModePlayButton = require(ServerDrivenUiParent.SharedFlags).FFlagLuaAppDemoModePlayButton

local function SduiGameTile(p1) -- line: 73
	-- upvalues: useTokens (copy), usePreferences (copy), FFlagSduiTileDisableLegacyHover (copy), FFlagLuaAppSduiGameTileHoverShadow (copy), React (copy), useUidRefString (copy), SduiErrors (copy), GetInputModeStore (copy), SduiParseHelpers (copy), SduiParsers (copy), SduiActionType (copy), default (copy), Responsive (copy), FFlagLuaAppResetHoverOnSduiPlayButtonActivation (copy), SduiBuilder (copy), SduiPlayButton (copy), FFlagLuaAppDemoModePlayButton (copy), FFlagLuaAppSduiGameTilePlayButtonDefaults (copy), localizeStrings (copy), DiscoveryAnalytics (copy), SduiHoldToPlay (copy), SduiGameTileFooter (copy), SduiTile (copy), Cryo (copy), ZoomAnimatedFrame (copy), TileHoverShadow (copy)
	local v34 = useTokens()
	local v35 = usePreferences()
	local v36 = not FFlagSduiTileDisableLegacyHover and p1.enableLegacyHoverState
	local u37 = nil

	if FFlagLuaAppSduiGameTileHoverShadow then
		u37 = React.useRef(nil)
	end

	local current = useUidRefString().current
	local universeId = p1.universeId
	local placeId = p1.placeId
	local v41 = React.useRef(nil)
	local v42 = React.useCallback(function(p2) -- line: 90
		-- upvalues: v41 (copy), p1 (copy)
		v41.current = p2

		if p1.setGuiObject then
			p1.setGuiObject(p2)
		end
	end, { p1.setGuiObject })
	local v43 = React.useRef(false)
	local v44 = React.useCallback(function(b1: boolean) -- line: 98
		-- upvalues: v43 (copy)
		v43.current = b1
	end, {})
	local v45 = React.useCallback(function() -- line: 102
		-- upvalues: p1 (copy), SduiErrors (copy), GetInputModeStore (copy), SduiParseHelpers (copy), v43 (copy), SduiParsers (copy), SduiActionType (copy), placeId (copy), universeId (copy)
		p1.sduiContext.dependencies.logger.reportCounter(SduiErrors.SduiCounterName.GameTileActivated, {
			name = GetInputModeStore(false).getLastInputType(false)
		}, true)

		local function logFailure(p3) -- line: 107
			-- upvalues: SduiParseHelpers (copy), p1 (copy), SduiErrors (copy), GetInputModeStore (copy)
			local v81 = not p3 and "" or SduiParseHelpers.stringifyValue(p3)
			local v82 = SduiParseHelpers.stringifyValue(p1.componentConfig)

			p1.sduiContext.dependencies.logger.reportError(SduiErrors.SduiErrorType.FailedToExecuteAction, {
				componentType = "GameTile",
				message = `Error executing GameTile.onActivated error: '{ v81 }' config: { v82 }`,
				name = GetInputModeStore(false).getLastInputType(false)
			}, p1.sduiContext.appPage)
		end

		local ok, result = pcall(function() -- line: 117
			-- upvalues: v43 (copy), p1 (copy), SduiParsers (copy), SduiActionType (copy), placeId (copy), universeId (copy), SduiErrors (copy), GetInputModeStore (copy), logFailure (copy)
			if not v43.current then
				if p1.onActivated then
					p1.onActivated()

					return
				end

				local v83 = SduiParsers.safeParseCallback({
					actionType = SduiActionType.OpenGameDetails,
					actionParams = {
						placeId = placeId,
						universeId = universeId
					}
				}, p1.sduiContext, p1.analyticsContext)

				if v83 then
					p1.sduiContext.dependencies.logger.reportCounter(SduiErrors.SduiCounterName.GameTileActivatedExecuteCallback, {
						name = GetInputModeStore(false).getLastInputType(false)
					}, true)
					v83()

					return
				end

				logFailure("Callback is nil after parsing")

				return
			end

			p1.sduiContext.dependencies.logger.reportCounter(SduiErrors.SduiCounterName.GameTileActivatedWhenDisabled, {
				name = GetInputModeStore(false).getLastInputType(false)
			})
		end)

		if not ok then
			logFailure(result)
		end
	end, {
		p1.onActivated,
		p1.sduiContext,
		p1.analyticsContext,
		placeId,
		universeId,
		p1.componentConfig
	})
	local v46, v47 = React.useState(false)
	local v48, v49 = React.useState(false)
	local v50 = React.useCallback(function() -- line: 162
		-- upvalues: v47 (copy), p1 (copy)
		v47(true)

		if p1.setCustomConditionState then
			p1.setCustomConditionState("selected", true)
		end
	end, { p1.setCustomConditionState })
	local v51 = React.useCallback(function() -- line: 169
		-- upvalues: v47 (copy), p1 (copy)
		v47(false)

		if p1.setCustomConditionState then
			p1.setCustomConditionState("selected", false)
		end
	end, { p1.setCustomConditionState })
	local v52 = React.useRef(0)

	if v48 == false then
		v52.current = 0
	end

	local default2 = default.default
	local v54 = React.useCallback(function() -- line: 193
		-- upvalues: v52 (copy), current (copy), GetInputModeStore (copy), Responsive (copy), default2 (copy)
		if v52.current == 0 and (current and GetInputModeStore(false).getLastInputType(false) == Responsive.Input.Pointer) then
			default2:requestHover(current)
		end

		local v69 = v52

		v69.current = v69.current + 1
	end, { current })
	local v55 = React.useCallback(function() -- line: 203
		-- upvalues: v52 (copy), current (copy), default2 (copy)
		local v70 = v52

		v70.current = v70.current - 1

		if v52.current < 0 then
			v52.current = 0
		end

		if v52.current == 0 and current then
			default2:cancelHover(current)
		end
	end, { current })

	React.useEffect(function() -- line: 213
		-- upvalues: current (copy), v48 (copy), default2 (copy), v49 (copy), p1 (copy), v52 (copy)
		local v71 = current
		local u72 = v48
		local u73 = default2.changed:connect(function(p4) -- line: 217
			-- upvalues: current (copy), v49 (copy), p1 (copy), u72 (ref)
			local v85 = p4 == current

			v49(v85)

			if p1.setCustomConditionState and v85 ~= u72 then
				p1.setCustomConditionState("hovered", v85)
			end

			u72 = v85
		end)

		return function() -- line: 226
			-- upvalues: default2 (copy), v71 (copy), v52 (copy), u73 (ref)
			default2:cancelHover(v71)
			v52.current = 0

			if u73 ~= nil then
				u73:disconnect()
			end
		end
	end, {
		current,
		p1.setCustomConditionState
	})

	local v56 = if not FFlagLuaAppResetHoverOnSduiPlayButtonActivation then nil else React.useCallback(function() -- line: 237
		-- upvalues: v48 (copy), default2 (copy)
		if v48 then
			default2:reset()
		end
	end, { v48 })
	local v57 = React.useMemo(function() -- line: 245
		-- upvalues: p1 (copy), v48 (copy), SduiBuilder (copy), universeId (copy), placeId (copy), FFlagSduiTileDisableLegacyHover (copy), React (copy), SduiPlayButton (copy), FFlagLuaAppDemoModePlayButton (copy), FFlagLuaAppResetHoverOnSduiPlayButtonActivation (copy), v56 (copy), FFlagLuaAppSduiGameTilePlayButtonDefaults (copy), localizeStrings (copy)
		if p1.ctaButtonComponent then
			return p1.ctaButtonComponent
		end

		if not v48 then
			return nil
		end

		local v74 = SduiBuilder.buildAnalyticsContext({}, p1.analyticsContext, {
			eventContext = "ExperienceTile",
			universeId = universeId,
			placeId = placeId,
			referralSource = p1.sduiContext.appPage
		})

		if not FFlagSduiTileDisableLegacyHover and p1.enableLegacyHoverState then
			return React.createElement(SduiPlayButton, {
				buttonSize = "Medium",
				fillBehavior = "Fill",
				isPlayableWhenLoading = true,
				universeId = universeId,
				placeId = placeId,
				preferSecondaryPlayButton = not not FFlagLuaAppDemoModePlayButton or nil,
				sduiContext = p1.sduiContext,
				analyticsContext = v74,
				onActivatedEffect = if not FFlagLuaAppResetHoverOnSduiPlayButtonActivation then nil else v56,
				enableUiBloxButton = if not FFlagLuaAppSduiGameTilePlayButtonDefaults then nil else p1.enableUiBloxButton == nil or p1.enableUiBloxButton,
				openGameDetailsOnPurchaseRequired = if not FFlagLuaAppSduiGameTilePlayButtonDefaults then nil else p1.openGameDetailsOnPurchaseRequired == nil or p1.openGameDetailsOnPurchaseRequired
			})
		end

		local localization = p1.sduiContext.dependencies.localization
		local v76 = localizeStrings(localization, {
			Join = "Common.VisitGame.Label.Play"
		})

		return React.createElement(SduiPlayButton, {
			hidePlayableIcon = true,
			height = 40,
			buttonSize = "Medium",
			hideOptionalText = true,
			isPlayableWhenLoading = true,
			universeId = universeId,
			placeId = placeId,
			sduiContext = p1.sduiContext,
			playableText = v76.Join,
			width = UDim.new(0, 60),
			analyticsContext = v74,
			preferSecondaryPlayButton = not not FFlagLuaAppDemoModePlayButton or nil,
			onActivatedEffect = if not FFlagLuaAppResetHoverOnSduiPlayButtonActivation then nil else v56,
			enableUiBloxButton = if not FFlagLuaAppSduiGameTilePlayButtonDefaults then nil else p1.enableUiBloxButton == nil or p1.enableUiBloxButton,
			openGameDetailsOnPurchaseRequired = if not FFlagLuaAppSduiGameTilePlayButtonDefaults then nil else p1.openGameDetailsOnPurchaseRequired == nil or p1.openGameDetailsOnPurchaseRequired
		})
	end, {
		v48,
		p1.enableLegacyHoverState,
		universeId,
		placeId,
		p1.ctaButtonComponent,
		p1.analyticsContext,
		p1.sduiContext,
		if not FFlagLuaAppResetHoverOnSduiPlayButtonActivation then nil else v56,
		if not FFlagLuaAppSduiGameTilePlayButtonDefaults then nil else p1.enableUiBloxButton,
		if not FFlagLuaAppSduiGameTilePlayButtonDefaults then nil else p1.openGameDetailsOnPurchaseRequired
	})
	local v58 = if not FFlagSduiTileDisableLegacyHover then React.useCallback(function(n1: number, color3: Color3, n2: number) -- line: 333
		-- upvalues: p1 (copy), React (copy), v54 (copy), v55 (copy), FFlagLuaAppSduiGameTileHoverShadow (copy), u37 (ref), v57 (copy)
		if p1.enableLegacyHoverState then
			return React.createElement("Frame", {
				AutomaticSize = Enum.AutomaticSize.Y,
				Position = UDim2.new(0, -n1, 0, -n1),
				Size = UDim2.new(1, n1 * 2, 0, 0),
				BackgroundColor3 = color3,
				BorderSizePixel = 0,
				BackgroundTransparency = 0,
				[React.Event.MouseEnter] = v54,
				[React.Event.MouseLeave] = v55,
				ref = if not FFlagLuaAppSduiGameTileHoverShadow then nil else u37
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalFlex = Enum.UIFlexAlignment.Fill
				}),
				UIPadding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, n1),
					PaddingRight = UDim.new(0, n1),
					PaddingBottom = UDim.new(0, n1),
					PaddingTop = UDim.new(0, n1 * 2)
				}),
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, n2)
				}),
				ctaButtonComponent = v57
			})
		end

		return nil
	end, {
		v57,
		v54,
		v55,
		p1.enableLegacyHoverState
	}) else nil
	local v59 = nil

	if v46 then
		if p1.focusNavActionsComponent then
			v59 = React.cloneElement(p1.focusNavActionsComponent, {
				extraLocalProps = {
					guiObject = v41.current
				}
			})
		elseif not p1.disableHoldToPlay then
			local v60 = SduiBuilder.buildAnalyticsContext({}, p1.analyticsContext, {
				eventContext = DiscoveryAnalytics.Constants.Context.HoldToPlayLauncher,
				referralSource = p1.sduiContext.appPage
			})

			v59 = React.createElement(SduiHoldToPlay, {
				sduiContext = p1.sduiContext,
				analyticsContext = v60,
				universeId = universeId,
				placeId = p1.placeId,
				guiObject = v41.current,
				setDisabledForHold = v44
			})
		end
	end

	local v61 = React.useMemo(function() -- line: 394
		-- upvalues: p1 (copy), React (copy), SduiGameTileFooter (copy), v48 (copy), v46 (copy), universeId (copy), placeId (copy)
		if p1.disableDefaultFooterLogic then
			return p1.footerComponent
		end

		return React.createElement(SduiGameTileFooter, {
			isHovered = v48,
			isSelected = v46,
			ageRatingText = p1.ageRatingText,
			footerComponent = p1.footerComponent,
			sduiContext = p1.sduiContext,
			universeId = universeId,
			placeId = placeId,
			analyticsContext = p1.analyticsContext,
			ratingText = p1.ratingText,
			playerCount = p1.playerCount
		})
	end, {
		v48,
		v46,
		universeId,
		placeId,
		p1.ageRatingText,
		p1.disableDefaultFooterLogic,
		p1.footerComponent,
		p1.sduiContext,
		p1.analyticsContext,
		p1.ratingText,
		p1.playerCount
	})
	local v62 = React.createElement(SduiTile, Cryo.Dictionary.join(p1, {
		testId = "--sdui-game-tile",
		ctaButtonComponent = v57,
		onMouseEnter = v54,
		onMouseLeave = v55,
		onSelectionGained = v50,
		onSelectionLost = v51,
		renderLegacyHoverState = if not FFlagSduiTileDisableLegacyHover then v58 else nil,
		isHovered = v48,
		setGuiObject = v42,
		onActivated = v45,
		focusNavActionsComponent = v59,
		footerComponent = v61
	}))

	if v36 then
		local XSmall = v34.Gap.XSmall

		return React.createElement(ZoomAnimatedFrame, {
			isZoomEnabled = v48,
			expansionOffsetX = XSmall * 2,
			expansionOffsetTop = XSmall,
			expansionOffsetBottom = XSmall,
			reducedMotion = v35.reducedMotion
		}, {
			HoverShadow = if not FFlagLuaAppSduiGameTileHoverShadow or (not v48 or not u37) then nil else React.createElement(TileHoverShadow, {
				contentRef = u37,
				hoverPadding = p1.containmentPadding,
				containmentPadding = p1.containmentPadding
			}),
			Tile = v62
		})
	end

	return v62
end

return React.memo(SduiGameTile)
