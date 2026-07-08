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

local function SduiGameTile(p1) -- line: 72
	-- upvalues: useTokens (copy), usePreferences (copy), FFlagSduiTileDisableLegacyHover (copy), FFlagLuaAppSduiGameTileHoverShadow (copy), React (copy), useUidRefString (copy), SduiErrors (copy), GetInputModeStore (copy), SduiParseHelpers (copy), SduiParsers (copy), SduiActionType (copy), default (copy), Responsive (copy), FFlagLuaAppResetHoverOnSduiPlayButtonActivation (copy), SduiBuilder (copy), SduiPlayButton (copy), FFlagLuaAppSduiGameTilePlayButtonDefaults (copy), localizeStrings (copy), DiscoveryAnalytics (copy), SduiHoldToPlay (copy), SduiGameTileFooter (copy), SduiTile (copy), Cryo (copy), ZoomAnimatedFrame (copy), TileHoverShadow (copy)
	local v33 = useTokens()
	local v34 = usePreferences()
	local v35 = not FFlagSduiTileDisableLegacyHover and p1.enableLegacyHoverState
	local u36 = nil

	if FFlagLuaAppSduiGameTileHoverShadow then
		u36 = React.useRef(nil)
	end

	local current = useUidRefString().current
	local universeId = p1.universeId
	local placeId = p1.placeId
	local v40 = React.useRef(nil)
	local v41 = React.useCallback(function(p2) -- line: 89
		-- upvalues: v40 (copy), p1 (copy)
		v40.current = p2

		if p1.setGuiObject then
			p1.setGuiObject(p2)
		end
	end, { p1.setGuiObject })
	local v42 = React.useRef(false)
	local v43 = React.useCallback(function(b1: boolean) -- line: 97
		-- upvalues: v42 (copy)
		v42.current = b1
	end, {})
	local v44 = React.useCallback(function() -- line: 101
		-- upvalues: p1 (copy), SduiErrors (copy), GetInputModeStore (copy), SduiParseHelpers (copy), v42 (copy), SduiParsers (copy), SduiActionType (copy), placeId (copy), universeId (copy)
		p1.sduiContext.dependencies.logger.reportCounter(SduiErrors.SduiCounterName.GameTileActivated, {
			name = GetInputModeStore(false).getLastInputType(false)
		}, true)

		local function logFailure(p3) -- line: 106
			-- upvalues: SduiParseHelpers (copy), p1 (copy), SduiErrors (copy), GetInputModeStore (copy)
			local v80 = not p3 and "" or SduiParseHelpers.stringifyValue(p3)
			local v81 = SduiParseHelpers.stringifyValue(p1.componentConfig)

			p1.sduiContext.dependencies.logger.reportError(SduiErrors.SduiErrorType.FailedToExecuteAction, {
				componentType = "GameTile",
				message = `Error executing GameTile.onActivated error: '{ v80 }' config: { v81 }`,
				name = GetInputModeStore(false).getLastInputType(false)
			}, p1.sduiContext.appPage)
		end

		local ok, result = pcall(function() -- line: 116
			-- upvalues: v42 (copy), p1 (copy), SduiParsers (copy), SduiActionType (copy), placeId (copy), universeId (copy), SduiErrors (copy), GetInputModeStore (copy), logFailure (copy)
			if not v42.current then
				if p1.onActivated then
					p1.onActivated()

					return
				end

				local v82 = SduiParsers.safeParseCallback({
					actionType = SduiActionType.OpenGameDetails,
					actionParams = {
						placeId = placeId,
						universeId = universeId
					}
				}, p1.sduiContext, p1.analyticsContext)

				if v82 then
					p1.sduiContext.dependencies.logger.reportCounter(SduiErrors.SduiCounterName.GameTileActivatedExecuteCallback, {
						name = GetInputModeStore(false).getLastInputType(false)
					}, true)
					v82()

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
	local v45, v46 = React.useState(false)
	local v47, v48 = React.useState(false)
	local v49 = React.useCallback(function() -- line: 161
		-- upvalues: v46 (copy), p1 (copy)
		v46(true)

		if p1.setCustomConditionState then
			p1.setCustomConditionState("selected", true)
		end
	end, { p1.setCustomConditionState })
	local v50 = React.useCallback(function() -- line: 168
		-- upvalues: v46 (copy), p1 (copy)
		v46(false)

		if p1.setCustomConditionState then
			p1.setCustomConditionState("selected", false)
		end
	end, { p1.setCustomConditionState })
	local v51 = React.useRef(0)

	if v47 == false then
		v51.current = 0
	end

	local default2 = default.default
	local v53 = React.useCallback(function() -- line: 192
		-- upvalues: v51 (copy), current (copy), GetInputModeStore (copy), Responsive (copy), default2 (copy)
		if v51.current == 0 and (current and GetInputModeStore(false).getLastInputType(false) == Responsive.Input.Pointer) then
			default2:requestHover(current)
		end

		local v68 = v51

		v68.current = v68.current + 1
	end, { current })
	local v54 = React.useCallback(function() -- line: 202
		-- upvalues: v51 (copy), current (copy), default2 (copy)
		local v69 = v51

		v69.current = v69.current - 1

		if v51.current < 0 then
			v51.current = 0
		end

		if v51.current == 0 and current then
			default2:cancelHover(current)
		end
	end, { current })

	React.useEffect(function() -- line: 212
		-- upvalues: current (copy), v47 (copy), default2 (copy), v48 (copy), p1 (copy), v51 (copy)
		local v70 = current
		local u71 = v47
		local u72 = default2.changed:connect(function(p4) -- line: 216
			-- upvalues: current (copy), v48 (copy), p1 (copy), u71 (ref)
			local v84 = p4 == current

			v48(v84)

			if p1.setCustomConditionState and v84 ~= u71 then
				p1.setCustomConditionState("hovered", v84)
			end

			u71 = v84
		end)

		return function() -- line: 225
			-- upvalues: default2 (copy), v70 (copy), v51 (copy), u72 (ref)
			default2:cancelHover(v70)
			v51.current = 0

			if u72 ~= nil then
				u72:disconnect()
			end
		end
	end, {
		current,
		p1.setCustomConditionState
	})

	local v55 = if not FFlagLuaAppResetHoverOnSduiPlayButtonActivation then nil else React.useCallback(function() -- line: 236
		-- upvalues: v47 (copy), default2 (copy)
		if v47 then
			default2:reset()
		end
	end, { v47 })
	local v56 = React.useMemo(function() -- line: 244
		-- upvalues: p1 (copy), v47 (copy), SduiBuilder (copy), universeId (copy), placeId (copy), FFlagSduiTileDisableLegacyHover (copy), React (copy), SduiPlayButton (copy), FFlagLuaAppResetHoverOnSduiPlayButtonActivation (copy), v55 (copy), FFlagLuaAppSduiGameTilePlayButtonDefaults (copy), localizeStrings (copy)
		if p1.ctaButtonComponent then
			return p1.ctaButtonComponent
		end

		if not v47 then
			return nil
		end

		local v73 = SduiBuilder.buildAnalyticsContext({}, p1.analyticsContext, {
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
				squadButtonHeight = UDim.new(0, 40),
				sduiContext = p1.sduiContext,
				analyticsContext = v73,
				onActivatedEffect = if not FFlagLuaAppResetHoverOnSduiPlayButtonActivation then nil else v55,
				enableUiBloxButton = if not FFlagLuaAppSduiGameTilePlayButtonDefaults then nil else p1.enableUiBloxButton == nil or p1.enableUiBloxButton,
				openGameDetailsOnPurchaseRequired = if not FFlagLuaAppSduiGameTilePlayButtonDefaults then nil else p1.openGameDetailsOnPurchaseRequired == nil or p1.openGameDetailsOnPurchaseRequired
			})
		end

		local localization = p1.sduiContext.dependencies.localization
		local v75 = localizeStrings(localization, {
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
			playableText = v75.Join,
			width = UDim.new(0, 60),
			analyticsContext = v73,
			squadButtonHeight = UDim.new(0, 40),
			onActivatedEffect = if not FFlagLuaAppResetHoverOnSduiPlayButtonActivation then nil else v55,
			enableUiBloxButton = if not FFlagLuaAppSduiGameTilePlayButtonDefaults then nil else p1.enableUiBloxButton == nil or p1.enableUiBloxButton,
			openGameDetailsOnPurchaseRequired = if not FFlagLuaAppSduiGameTilePlayButtonDefaults then nil else p1.openGameDetailsOnPurchaseRequired == nil or p1.openGameDetailsOnPurchaseRequired
		})
	end, {
		v47,
		p1.enableLegacyHoverState,
		universeId,
		placeId,
		p1.ctaButtonComponent,
		p1.analyticsContext,
		p1.sduiContext,
		if not FFlagLuaAppResetHoverOnSduiPlayButtonActivation then nil else v55,
		if not FFlagLuaAppSduiGameTilePlayButtonDefaults then nil else p1.enableUiBloxButton,
		if not FFlagLuaAppSduiGameTilePlayButtonDefaults then nil else p1.openGameDetailsOnPurchaseRequired
	})
	local v57 = if not FFlagSduiTileDisableLegacyHover then React.useCallback(function(n1: number, color3: Color3, n2: number) -- line: 332
		-- upvalues: p1 (copy), React (copy), v53 (copy), v54 (copy), FFlagLuaAppSduiGameTileHoverShadow (copy), u36 (ref), v56 (copy)
		if p1.enableLegacyHoverState then
			return React.createElement("Frame", {
				AutomaticSize = Enum.AutomaticSize.Y,
				Position = UDim2.new(0, -n1, 0, -n1),
				Size = UDim2.new(1, n1 * 2, 0, 0),
				BackgroundColor3 = color3,
				BorderSizePixel = 0,
				BackgroundTransparency = 0,
				[React.Event.MouseEnter] = v53,
				[React.Event.MouseLeave] = v54,
				ref = if not FFlagLuaAppSduiGameTileHoverShadow then nil else u36
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
				ctaButtonComponent = v56
			})
		end

		return nil
	end, {
		v56,
		v53,
		v54,
		p1.enableLegacyHoverState
	}) else nil
	local v58 = nil

	if v45 then
		if p1.focusNavActionsComponent then
			v58 = React.cloneElement(p1.focusNavActionsComponent, {
				extraLocalProps = {
					guiObject = v40.current
				}
			})
		elseif not p1.disableHoldToPlay then
			local v59 = SduiBuilder.buildAnalyticsContext({}, p1.analyticsContext, {
				eventContext = DiscoveryAnalytics.Constants.Context.HoldToPlayLauncher,
				referralSource = p1.sduiContext.appPage
			})

			v58 = React.createElement(SduiHoldToPlay, {
				sduiContext = p1.sduiContext,
				analyticsContext = v59,
				universeId = universeId,
				placeId = p1.placeId,
				guiObject = v40.current,
				setDisabledForHold = v43
			})
		end
	end

	local v60 = React.useMemo(function() -- line: 393
		-- upvalues: p1 (copy), React (copy), SduiGameTileFooter (copy), v47 (copy), v45 (copy), universeId (copy), placeId (copy)
		if p1.disableDefaultFooterLogic then
			return p1.footerComponent
		end

		return React.createElement(SduiGameTileFooter, {
			isHovered = v47,
			isSelected = v45,
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
		v47,
		v45,
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
	local v61 = React.createElement(SduiTile, Cryo.Dictionary.join(p1, {
		testId = "--sdui-game-tile",
		ctaButtonComponent = v56,
		onMouseEnter = v53,
		onMouseLeave = v54,
		onSelectionGained = v49,
		onSelectionLost = v50,
		renderLegacyHoverState = if not FFlagSduiTileDisableLegacyHover then v57 else nil,
		isHovered = v47,
		setGuiObject = v41,
		onActivated = v44,
		focusNavActionsComponent = v58,
		footerComponent = v60
	}))

	if v35 then
		local XSmall = v33.Gap.XSmall

		return React.createElement(ZoomAnimatedFrame, {
			isZoomEnabled = v47,
			expansionOffsetX = XSmall * 2,
			expansionOffsetTop = XSmall,
			expansionOffsetBottom = XSmall,
			reducedMotion = v34.reducedMotion
		}, {
			HoverShadow = if not FFlagLuaAppSduiGameTileHoverShadow or (not v47 or not u36) then nil else React.createElement(TileHoverShadow, {
				contentRef = u36,
				hoverPadding = p1.containmentPadding,
				containmentPadding = p1.containmentPadding
			}),
			Tile = v61
		})
	end

	return v61
end

return React.memo(SduiGameTile)
