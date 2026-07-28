local GuiService = game:GetService("GuiService")
local Parent = script:FindFirstAncestor("PeekView").Parent
local UserInputService = game:GetService("UserInputService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local EventIngestService = game:GetService("EventIngestService")
local RunService = game:GetService("RunService")
local Cryo = require(Parent.Cryo)
local React = require(Parent.React)
local Roact = require(Parent.Roact)
local UIBlox = require(Parent.UIBlox)
local RoactGamepad = require(Parent.RoactGamepad)
local Focusable = RoactGamepad.Focusable
local RoactRodux = require(Parent.RoactRodux)
local PeekViewState = require(script.Parent.PeekViewState)
local Scrim = require(script.Parent.Scrim)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local ExternalEventConnection = require(Parent.RoactUtils).ExternalEventConnection
local ArgCheck = require(Parent.ArgCheck)
local InputTypeConstants = require(Parent.InputType).InputTypeConstants
local GamepadUtils = require(Parent.InputUi).Gamepad.GamepadUtils
local getInputGroup = require(Parent.InputType).getInputGroup
local peekViewDismissedEvent = require(script.Parent.analytics.peekViewDismissedEvent)
local v24 = require(Parent.Analytics).AnalyticsReporters.EventIngest.new(EventIngestService)
local switchAccountScrimError = require(Parent.UiShellEvents).switchAccountScrimError
local FocusNavigationUtils = require(Parent.FocusNavigationUtils)
local FocusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local usePeekViewFocusNavigationBindings = require(script.Parent.usePeekViewFocusNavigationBindings)
local GetFFlagEnablePeekViewStateOnMountParam = require(Parent.SharedFlags).GetFFlagEnablePeekViewStateOnMountParam
local GetFIntPeekViewTransitionDelayTiming = require(Parent.SharedFlags).GetFIntPeekViewTransitionDelayTiming
local FFlagProfilePlatformNewProfileHeader = require(Parent.SharedFlags).FFlagProfilePlatformNewProfileHeader
local FFlagProfilePlatformPeekDraggerContrast = require(Parent.SharedFlags).FFlagProfilePlatformPeekDraggerContrast
local v33 = game:DefineFastFlag("EnableFastScrollingFixTest", false)
local FFlagEnablePeekViewFocusNav = require(Parent.SharedFlags).FFlagEnablePeekViewFocusNav
local GetFFlagPreventSuperBriefPeekViewClose = require(Parent.SharedFlags).GetFFlagPreventSuperBriefPeekViewClose
local v36 = game:DefineFastFlag("AXMigratePeekViewToFocusNavigation", false)
local FFlagAXMigrateAXToGlobalAutofocus = require(Parent.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local FFlagAXScrollingFramesShouldAnimateOnFocus = require(Parent.SharedFlags).FFlagAXScrollingFramesShouldAnimateOnFocus
local v39 = game:DefineFastFlag("FixPeekViewAnimationJitter", false)
local FFlagPeekViewFixBriefHeightLayoutRace = require(Parent.SharedFlags).FFlagPeekViewFixBriefHeightLayoutRace
local rect = Rect.new(9, 9, 9, 9)
local v42 = Images["icons/navigation/swipe"]
local v43 = 0.1 * GetFIntPeekViewTransitionDelayTiming()
local Hidden = PeekViewState.Hidden
local Closed = PeekViewState.Closed
local SuperBrief = PeekViewState.SuperBrief
local Brief = PeekViewState.Brief
local Full = PeekViewState.Full
local Extended = PeekViewState.Extended
local u50 = Roact.PureComponent:extend("PeekView")

u50.defaultProps = {
	superBriefViewContentHeight = nil,
	bottomDockedContainerHeight = 0,
	bottomDockedContainerContent = nil,
	hidden = false,
	showDraggerInClosedState = true,
	showDropShadow = true,
	stateOnMount = nil,
	mountAsFullView = false,
	mountAnimation = true,
	canDragFullViewToBrief = false,
	withNewThemeProvider = true,
	viewStateChanged = nil,
	briefToFullTransitionPercent = nil,
	peekHeaderClose = true,
	peekHeaderPositionYChange = nil,
	isScrollingEnabled = true,
	closeSignal = nil,
	hideDraggerInSuperBrief = false,
	minimizeToSuperBrief = false,
	customBackground = nil,
	hasSolidDragger = true,
	draggerImageStyle = nil,
	briefViewContentHeight = UDim.new(0.5, 0),
	fullViewContentHeight = if v36 then nil else UDim.new(1, 0),
	elasticBehavior = Enum.ElasticBehavior.Always,
	shouldCaptureFocus = not not FFlagAXMigrateAXToGlobalAutofocus or nil
}

function u50.init(p1) -- line: 142
	-- upvalues: UserGameSettings (copy), Hidden (copy), getInputGroup (copy), UserInputService (copy), Roact (copy), UIBlox (copy), Closed (copy), SuperBrief (copy), Brief (copy), Full (copy), v36 (copy), switchAccountScrimError (copy), v24 (copy), v39 (copy), FFlagPeekViewFixBriefHeightLayoutRace (copy), v33 (copy), GetFFlagPreventSuperBriefPeekViewClose (copy), PeekViewState (copy), InputTypeConstants (copy), peekViewDismissedEvent (copy), Extended (copy), ArgCheck (copy), RunService (copy), v43 (copy), GuiService (copy)
	p1.isMounted = false
	p1.isTouched = false
	p1.isInGoToState = false
	p1.useReducedMotion = UserGameSettings.ReducedMotion
	p1.viewType = Hidden
	p1:setState({
		scrollableViewType = false,
		absoluteWindowSizeX = 0,
		absoluteWindowSizeY = 0,
		canvasGroupTransparency = 0,
		lastInputGroup = getInputGroup(UserInputService:GetLastInputType())
	})
	p1.containerFrameRef = Roact.createRef()
	p1.clipFrameRef = Roact.createRef()
	p1.shadowRef = Roact.createRef()
	p1.fillingAreaRef = Roact.createRef()
	p1.swipeScrollingFrameRef = Roact.createRef()
	p1.bottomContainerRef = Roact.createRef()

	local v54, v55 = Roact.createBinding(0)

	p1.transitionPercent = v54
	p1.setTransitionPercent = v55

	function p1.onAbsoluteWindowSizeChanged(p2) -- line: 168
		-- upvalues: p1 (copy)
		if p2.AbsoluteWindowSize.X ~= p1.state.absoluteWindowSizeX or p2.AbsoluteWindowSize.Y ~= p1.state.absoluteWindowSizeY then
			p1:setState({
				absoluteWindowSizeX = p2.AbsoluteWindowSize.X,
				absoluteWindowSizeY = p2.AbsoluteWindowSize.Y
			})
		end
	end
	function p1.withStyle(p3) -- line: 180
		-- upvalues: p1 (copy), UIBlox (copy)
		if p1.props.withNewThemeProvider then
			return UIBlox.Style.withStyle(p3)
		end

		return p3({
			Theme = {
				BackgroundDefault = {
					Transparency = 0,
					Color = Color3.fromRGB(35, 37, 39)
				},
				UIEmphasis = {
					Transparency = 0.7,
					Color = Color3.fromRGB(255, 255, 255)
				},
				DropShadow = {
					Transparency = 0,
					Color = Color3.fromRGB(0, 0, 0)
				}
			},
			Settings = {
				ReducedMotion = false
			}
		})
	end
	function p1.inputBeganCallback(p4) -- line: 206
		-- upvalues: p1 (copy)
		if not p1.isMounted then
			return
		end

		if p4.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		p1.isTouched = true
	end
	function p1.inputEndedCallback(p5) -- line: 218
		-- upvalues: p1 (copy)
		if not p1.isMounted then
			return
		end

		if p5.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		p1.isTouched = false
		p1.checkGoTo()
	end
	function p1.getViewSize(p6) -- line: 231
		-- upvalues: Hidden (copy), Closed (copy), SuperBrief (copy), p1 (copy), Brief (copy), Full (copy)
		if p6 == Hidden then
			return UDim.new(0, 0)
		end

		if p6 == Closed then
			return UDim.new(0, 0)
		end

		if p6 == SuperBrief then
			if p1.props.superBriefViewContentHeight then
				local superBriefViewContentHeight = p1.props.superBriefViewContentHeight

				return UDim.new(superBriefViewContentHeight.Scale, superBriefViewContentHeight.Offset + 25)
			end

			return UDim.new(0, 0)
		end

		if p6 == Brief then
			local briefViewContentHeight = p1.props.briefViewContentHeight

			return UDim.new(briefViewContentHeight.Scale, briefViewContentHeight.Offset + 25)
		end

		if p6 == Full then
			return p1.props.fullViewContentHeight
		end

		return nil
	end
	function p1.hasNilRefs() -- line: 256
		-- upvalues: v36 (copy), p1 (copy)
		local v153 = if not v36 then p1.swipeScrollingFrameRef.current else p1.props.swipeScrollingFrameRef.current
		local v154 = if not v36 then p1.containerFrameRef.current else p1.props.containerFrameRef.current
		local current = p1.clipFrameRef.current
		local current2 = p1.shadowRef.current
		local current3 = p1.fillingAreaRef.current

		return not (v153 and (v154 and (current and (current2 and current3))))
	end
	function p1.reportRefStatus(p7, p8, p9, p10, p11, p12) -- line: 270
		-- upvalues: switchAccountScrimError (copy), v24 (copy)
		switchAccountScrimError(v24, "switchAccountScrimError", {
			callSite = p7,
			swipeScrollingFrame = not p8 and "nil" or "true",
			containerFrame = not p9 and "nil" or "true",
			clipFrame = not p10 and "nil" or "true",
			shadow = not p11 and "nil" or "true",
			fillingArea = not p12 and "nil" or "true"
		})
	end
	function p1.reconcileRbxInstances(s1: string?) -- line: 282
		-- upvalues: v36 (copy), p1 (copy)
		local v165 = if not v36 then p1.swipeScrollingFrameRef.current else p1.props.swipeScrollingFrameRef.current
		local v166 = v165 and v165.CanvasPosition.Y or 0
		local v167 = if not v36 then p1.containerFrameRef.current else p1.props.containerFrameRef.current
		local current = p1.clipFrameRef.current
		local current4 = p1.shadowRef.current
		local current5 = p1.fillingAreaRef.current

		if p1.hasNilRefs() then
			p1.reportRefStatus(s1, v165, v167, current, current4, current5)

			return
		end

		local AbsoluteSizeX = v167.AbsoluteSize.X
		local AbsoluteSizeY = v167.AbsoluteSize.Y

		current.Size = UDim2.new(0, AbsoluteSizeX, 0, v166)
		current4.Size = UDim2.new(0, AbsoluteSizeX, 0, 36)
		current.Position = UDim2.new(0, 0, 1, -v166)
		current4.Position = UDim2.new(0, 0, 1, -v166 - 30)
		v165.Size = UDim2.new(0, AbsoluteSizeX, 0, AbsoluteSizeY)
		v165.Position = UDim2.new(0, 0, 0, -(AbsoluteSizeY - v166))
		current5.Size = UDim2.new(0, AbsoluteSizeX, 0, AbsoluteSizeY)

		local current6 = p1.bottomContainerRef.current

		if current6 then
			local bottomDockedContainerHeight = p1.props.bottomDockedContainerHeight

			if current.AbsoluteSize.Y > 25 + bottomDockedContainerHeight then
				current6.Active = true
				current6.Position = UDim2.new(0, 0, 1, -bottomDockedContainerHeight)
			else
				current6.Active = false
				current6.Position = UDim2.new(0, 0, 1, -current.AbsoluteSize.Y + 25)
			end
		end

		p1.transitionCallbacks()

		if p1.props.peekHeaderPositionYChange then
			p1.props.peekHeaderPositionYChange(v166)
		end
	end
	function p1.updateSwipeScrollingFrame() -- line: 332
		-- upvalues: p1 (copy), v36 (copy)
		local v175 = p1.getViewSize(p1.viewType)
		local v176 = if not v36 then p1.containerFrameRef.current and p1.swipeScrollingFrameRef.current else p1.props.containerFrameRef.current and p1.props.swipeScrollingFrameRef.current

		if v175 and v176 then
			local AbsoluteSizeY = ((if not v36 then p1.containerFrameRef.current else p1.props.containerFrameRef.current)).AbsoluteSize.Y
			local v178 = if not v36 then p1.swipeScrollingFrameRef.current else p1.props.swipeScrollingFrameRef.current
			local v179 = AbsoluteSizeY * v175.Scale + v175.Offset

			if v179 ~= v178.CanvasPosition.Y then
				v178.CanvasPosition = Vector2.new(0, v179)

				if p1.props.peekHeaderPositionYChange then
					p1.props.peekHeaderPositionYChange(v179)
				end
			end
		end
	end
	function p1.onContainerFrameAbsoluteSizeChanged() -- line: 361
		-- upvalues: p1 (copy), v39 (copy), Hidden (copy)
		if not p1.isMounted then
			return
		end

		p1.reconcileRbxInstances("onContainerFrameAbsoluteSizeChanged")

		if v39 then
			if not p1:isAnimating() or p1.viewType ~= Hidden then
				p1.updateSwipeScrollingFrame()

				return
			end
		else
			p1.updateSwipeScrollingFrame()
		end
	end

	if FFlagPeekViewFixBriefHeightLayoutRace then
		function p1.onAbsoluteCanvasSizeChanged() -- line: 383
			-- upvalues: p1 (copy), Brief (copy), SuperBrief (copy), v36 (copy)
			if not p1.isMounted or (p1:isAnimating() or p1.isTouched) then
				return
			end

			if p1.viewType ~= Brief and p1.viewType ~= SuperBrief then
				return
			end

			local v180 = p1.getViewSize(p1.viewType)

			if not v180 then
				return
			end

			local v181 = if not v36 then p1.swipeScrollingFrameRef.current else p1.props.swipeScrollingFrameRef.current
			local v182 = if not v36 then p1.containerFrameRef.current else p1.props.containerFrameRef.current

			if not v181 or not v182 then
				return
			end

			local v183 = v182.AbsoluteSize.Y * v180.Scale + v180.Offset
			local v184 = v181.AbsoluteCanvasSize.Y - v181.AbsoluteWindowSize.Y

			if v183 > v181.CanvasPosition.Y and v183 <= v184 then
				v181.CanvasPosition = Vector2.new(0, v183)
			end
		end
	end

	function p1.onSwipeScrollingFrameCanvasPositionChanged() -- line: 414
		-- upvalues: p1 (copy), v36 (copy), v33 (copy), GetFFlagPreventSuperBriefPeekViewClose (copy), PeekViewState (copy), InputTypeConstants (copy)
		if not p1.isMounted then
			return
		end

		local v185 = if not v36 then p1.swipeScrollingFrameRef.current else p1.props.swipeScrollingFrameRef.current
		local CanvasPositionY = v185.CanvasPosition.Y

		if CanvasPositionY ~= math.floor(CanvasPositionY) then
			if not v33 then
				if GetFFlagPreventSuperBriefPeekViewClose() then
					local v187 = math.floor(CanvasPositionY + 0.5)

					if p1.viewType == PeekViewState.SuperBrief and p1.props.minimizeToSuperBrief then
						local v188 = p1.getSuperBriefViewY()

						if v188 ~= nil and v187 ~= nil and v187 < v188 then
							v187 = v188
						end
					end

					v185.CanvasPosition = Vector2.new(0, v187)
				else
					v185.CanvasPosition = Vector2.new(0, (math.floor(CanvasPositionY + 0.5)))
				end
			end

			if p1.props.peekHeaderPositionYChange then
				p1.props.peekHeaderPositionYChange(CanvasPositionY)
			end

			if not v33 then
				return
			end
		end

		p1.reconcileRbxInstances("onSwipeScrollingFrameCanvasPositionChanged")

		if p1.state.lastInputGroup ~= InputTypeConstants.Gamepad then
			p1.checkGoTo()
		end
	end
	function p1.getBriefViewY() -- line: 463
		-- upvalues: v36 (copy), p1 (copy)
		local v189 = if not v36 then p1.containerFrameRef.current.AbsoluteSize.Y else p1.props.containerFrameRef.current.AbsoluteSize.Y
		local briefViewContentHeight = p1.props.briefViewContentHeight

		return v189 * briefViewContentHeight.Scale + briefViewContentHeight.Offset + 25
	end
	function p1.getSuperBriefViewY() -- line: 471
		-- upvalues: v36 (copy), p1 (copy)
		if v36 then
			if not p1.props.superBriefViewContentHeight or not p1.props.containerFrameRef:getValue() then
				return nil
			end
		elseif not p1.props.superBriefViewContentHeight or not p1.containerFrameRef:getValue() then
			return nil
		end

		local v191 = if not v36 then p1.containerFrameRef:getValue().AbsoluteSize.Y else p1.props.containerFrameRef:getValue().AbsoluteSize.Y
		local superBriefViewContentHeight = p1.props.superBriefViewContentHeight

		return v191 * superBriefViewContentHeight.Scale + superBriefViewContentHeight.Offset + 25
	end
	function p1.getFullViewY() -- line: 489
		-- upvalues: p1 (copy)
		return p1.containerFrameRef.current.AbsoluteSize.Y * p1.props.fullViewContentHeight.Scale + p1.props.fullViewContentHeight.Offset
	end
	function p1.transitionCallbacks() -- line: 494
		-- upvalues: p1 (copy), v36 (copy)
		local briefToFullTransitionPercent = p1.props.briefToFullTransitionPercent
		local CanvasPositionY = ((if not v36 then p1.swipeScrollingFrameRef.current else p1.props.swipeScrollingFrameRef.current)).CanvasPosition.Y
		local v195 = p1.getBriefViewY()
		local v196 = if not v36 then p1.getFullViewY() else p1.props.getFullViewY()
		local v197 = v196 - v195
		local n1 = 0

		if v195 < CanvasPositionY and CanvasPositionY <= v196 then
			n1 = (CanvasPositionY - v195) / v197
		elseif v196 < CanvasPositionY then
			n1 = 1
		end

		p1.setTransitionPercent(n1)

		if briefToFullTransitionPercent then
			briefToFullTransitionPercent(n1)
		end
	end
	function p1.checkGoTo() -- line: 531
		-- upvalues: p1 (copy), v36 (copy), PeekViewState (copy)
		if p1.isInGoToState then
			return
		end

		if p1.isTouched then
			return
		end

		local v199 = if not v36 then p1.swipeScrollingFrameRef.current else p1.props.swipeScrollingFrameRef.current

		if v199 and p1.state.absoluteWindowSizeX == 0 and p1.state.absoluteWindowSizeY == 0 then
			return
		end

		local v200 = p1.getBriefViewY()
		local v201 = p1.getSuperBriefViewY()
		local v202 = if not v36 then p1.getFullViewY() else p1.props.getFullViewY()

		if v202 < v200 then
			return
		end

		if v201 and v200 < v201 then
			return
		end

		if v199.AbsoluteWindowSize.Y + 25 + p1.props.bottomDockedContainerHeight > (v199.AbsoluteCanvasSize.Y or v199.CanvasSize.Y.Offset) then
			return
		end

		local ScrollVelocityY = v199.ScrollVelocity.Y
		local v204 = ScrollVelocityY < 0
		local v205 = ScrollVelocityY > 0
		local CanvasPositionY = v199.CanvasPosition.Y
		local v207 = p1.viewType == PeekViewState.Brief and CanvasPositionY == v200
		local v208 = p1.viewType == PeekViewState.Full and CanvasPositionY == v202

		if (v207 or v208) and ScrollVelocityY == 0 then
			return
		end

		if v202 < CanvasPositionY then
			p1:handleCurYAboveFullViewY(v204)

			return
		end

		if v200 < CanvasPositionY and CanvasPositionY <= v202 then
			p1:handleCurYFromBriefToFull(CanvasPositionY, ScrollVelocityY, v204, v205)

			return
		end

		if v201 then
			if v201 < CanvasPositionY and CanvasPositionY <= v200 then
				p1:handleCurYFromSuperBriefToBrief(CanvasPositionY, v201, ScrollVelocityY, v204, v205)

				return
			end

			if CanvasPositionY <= v201 then
				p1:handleCurYFromClosedToSuperBrief(CanvasPositionY, v201, ScrollVelocityY, v205, v204)

				return
			end
		elseif CanvasPositionY <= v200 then
			p1:handleCurYFromClosedToBrief(CanvasPositionY, v205, v204)
		end
	end
	function p1.onPeekHeaderActivated() -- line: 618
		-- upvalues: p1 (copy), Closed (copy), Brief (copy), Full (copy), SuperBrief (copy), peekViewDismissedEvent (copy)
		if p1.viewType == Closed then
			p1.goTo(Brief)

			return
		end

		if p1.viewType == Brief then
			p1.goTo(Full)

			return
		end

		if p1.viewType == SuperBrief then
			p1.goTo(Brief)

			return
		end

		if p1.viewType == Full then
			if p1.props.peekHeaderClose then
				p1.goTo(Closed, nil, nil, {
					dismissMethod = peekViewDismissedEvent.dismissMethodEnum.handleTap
				})

				return
			end

			p1.goTo(Brief)
		end
	end
	function p1.setViewType(p13, p14) -- line: 636
		-- upvalues: p1 (copy), Extended (copy), Full (copy)
		if p1.goToAnimationConnection then
			p1.goToAnimationConnection:disconnect()
			p1.goToAnimationConnection = nil
		end

		p1.isInGoToState = false
		p1.clipFrameRef.current.Active = false

		local viewType = p1.viewType

		if viewType ~= p13 then
			p1.viewType = p13

			local v212 = p1.viewType == Extended or p1.viewType == Full

			p1:setState({
				scrollableViewType = v212
			})

			local viewStateChanged = p1.props.viewStateChanged

			if viewStateChanged then
				viewStateChanged(p13, viewType, p14 or {})
			end
		end

		p1.updateSwipeScrollingFrame()
	end
	function p1.goTo(p15, p16, p17, p18) -- line: 664
		-- upvalues: p1 (copy), ArgCheck (copy), v36 (copy), Full (copy), Closed (copy), RunService (copy), Brief (copy), v43 (copy)
		if p15 == p1.viewType then
			return
		end

		if ArgCheck.isEqual(p1.isInGoToState, false, "self.isInGoToState") then
			return
		end

		if ArgCheck.isEqual(p1.goToAnimationConnection, nil, "self.goToAnimationConnection") then
			return
		end

		p1.isInGoToState = true

		if v36 then
			p1.props.swipeScrollingFrameRef:getValue().ScrollVelocity = Vector2.new(0, 0)
		else
			p1.swipeScrollingFrameRef:getValue().ScrollVelocity = Vector2.new(0, 0)
		end

		p1.clipFrameRef.current.Active = true

		if p16 == false then
			p1.setViewType(p15, p18)

			if p15 == Full then
				p1:adjustScrollingFramePosition()

				return
			end
		else
			local timestamp = tick()

			if not p17 then
				p1:setState({
					canvasGroupTransparency = p15 ~= Closed and 0 or 1
				})
				p1.goToAnimationConnection = RunService.RenderStepped:Connect(function() -- line: 699
					-- upvalues: p1 (copy), timestamp (copy), p15 (copy), Brief (copy), v43 (copy), v36 (copy), ArgCheck (copy), p18 (copy), Full (copy)
					if not p1.isMounted then
						return
					end

					local v234 = tick() - timestamp

					if p15 ~= Brief or v234 >= v43 then
						if v36 then
							p1.props.swipeScrollingFrameRef:getValue().ScrollVelocity = Vector2.new(0, 0)
						else
							p1.swipeScrollingFrameRef:getValue().ScrollVelocity = Vector2.new(0, 0)
						end

						local v235 = if not v36 then p1.swipeScrollingFrameRef.current else p1.props.swipeScrollingFrameRef.current
						local v236 = if not v36 then p1.containerFrameRef.current.AbsoluteSize.Y else p1.props.containerFrameRef.current.AbsoluteSize.Y
						local v237 = ArgCheck.isNotNil(p1.getViewSize(p15), "self.goTo.viewSize")
						local v238 = v236 * v237.Scale + v237.Offset

						if p15 == Brief then
							v234 -= v43
						end

						if v234 >= 0.35 then
							p1.setViewType(p15, p18)

							if p15 == Full then
								p1:adjustScrollingFramePosition()
							end

							return
						end

						local CanvasPositionY = v235.CanvasPosition.Y
						local v240 = v238 - CanvasPositionY

						v235.CanvasPosition = Vector2.new(0, CanvasPositionY + v240 * math.sin(v234 * 2.468394227820552))
					end
				end)

				return
			end

			if p15 ~= Closed then
				p1.setViewType(p15, p18)

				if p15 == Full then
					p1:adjustScrollingFramePosition()
				end
			end

			p1:setState({
				canvasGroupTransparency = p15 ~= Closed and 1 or 0
			})
			p1.goToAnimationConnection = RunService.RenderStepped:Connect(function() -- line: 752
				-- upvalues: p1 (copy), p15 (copy), Full (copy), timestamp (copy), Closed (copy), p18 (copy)
				if not p1.isMounted then
					return
				end

				if p15 == Full then
					p1.updateSwipeScrollingFrame()
				end

				local v241 = tick() - timestamp

				if v241 >= 0.35 then
					p1:setState({
						canvasGroupTransparency = p15 ~= Closed and 0 or 1
					})
					p1.setViewType(p15, p18)

					if p15 == Full then
						p1:adjustScrollingFramePosition()
					end

					return
				end

				p1:setState({
					canvasGroupTransparency = if p15 ~= Closed then 1 - v241 / 0.35 else v241 / 0.35
				})
			end)
		end
	end

	p1.selectedCoreObjectConnection = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):connect(function() -- line: 786
		-- upvalues: v36 (copy), p1 (copy), InputTypeConstants (copy)
		if v36 then
			if p1.props.swipeScrollingFrameRef.current and p1.state.lastInputGroup == InputTypeConstants.Gamepad then
				p1:adjustScrollingFramePosition()

				return
			end
		elseif p1.swipeScrollingFrameRef.current and p1.state.lastInputGroup == InputTypeConstants.Gamepad then
			p1:adjustScrollingFramePosition()
		end
	end)
end
function u50.handleCurYAboveFullViewY(p19, p20) -- line: 812
	-- upvalues: Full (copy), Extended (copy)
	if p19.viewType ~= Full and p19.viewType ~= Extended then
		if p20 then
			p19.goTo(Full)

			return
		end

		p19.setViewType(Extended)

		return
	end

	if p19.viewType == Full then
		p19.setViewType(Extended)
	end
end
function u50.handleCurYFromBriefToFull(p21, p22, p23, p24, p25) -- line: 824
	-- upvalues: v36 (copy), Full (copy), Brief (copy), Closed (copy), peekViewDismissedEvent (copy), Extended (copy)
	local canDragFullViewToBrief = p21.props.canDragFullViewToBrief
	local minimizeToSuperBrief = p21.props.minimizeToSuperBrief
	local v65 = if not v36 then p21.swipeScrollingFrameRef:getValue() else p21.props.swipeScrollingFrameRef:getValue()
	local v66 = p21.getBriefViewY()
	local v67 = ((if not v36 then p21.getFullViewY() else p21.props.getFullViewY())) - v66

	if p21.viewType == Full then
		if p22 > v65.AbsoluteCanvasSize.Y - v65.AbsoluteWindowSize.Y - 1 then
			return
		end

		if p25 or p22 < v66 + v67 * 0.8 then
			local v68 = p25 and p23 > 500

			if canDragFullViewToBrief and (not v68 or minimizeToSuperBrief) then
				p21.goTo(Brief)

				return
			end

			p21.goTo(Closed, nil, nil, {
				dismissMethod = peekViewDismissedEvent.dismissMethodEnum.swipe
			})

			return
		end
	elseif p21.viewType == Extended then
		if not p25 or p22 < v66 + v67 * 0.8 or p23 > -1 then
			p21.goTo(Full)

			return
		end
	else
		if p24 or p22 > v66 + v67 * 0.2 then
			p21.goTo(Full)

			return
		end

		p21.goTo(Brief)
	end
end
function u50.handleCurYFromSuperBriefToBrief(p26, p27, p28, p29, p30, p31) -- line: 865
	-- upvalues: v36 (copy), Full (copy), SuperBrief (copy), Closed (copy), peekViewDismissedEvent (copy), Brief (copy), Extended (copy)
	local canDragFullViewToBrief = p26.props.canDragFullViewToBrief
	local minimizeToSuperBrief = p26.props.minimizeToSuperBrief
	local v77 = ((if not v36 then p26.getFullViewY() else p26.props.getFullViewY())) - p28

	if p26.viewType == Full then
		if p31 or p27 < p28 + v77 * 0.8 then
			local v78 = p31 and p29 > 500

			if canDragFullViewToBrief and (not v78 or minimizeToSuperBrief) then
				p26.goTo(SuperBrief)

				return
			end

			p26.goTo(Closed, nil, nil, {
				dismissMethod = peekViewDismissedEvent.dismissMethodEnum.swipe
			})

			return
		end

		p26.goTo(Brief)

		return
	end

	if p26.viewType == Extended then
		if not p31 or p27 < p28 + v77 * 0.8 or p29 > -1 then
			p26.goTo(Brief)

			return
		end
	else
		if p30 or p27 > p28 + v77 * 0.2 then
			p26.goTo(Brief)

			return
		end

		local v79 = p31 and p29 > 500

		if canDragFullViewToBrief and (not v79 or minimizeToSuperBrief) then
			p26.goTo(SuperBrief)

			return
		end

		p26.goTo(Closed, nil, nil, {
			dismissMethod = peekViewDismissedEvent.dismissMethodEnum.swipe
		})
	end
end
function u50.handleCurYFromClosedToSuperBrief(p32, p33, p34, p35, p36, p37) -- line: 903
	-- upvalues: SuperBrief (copy), Closed (copy), peekViewDismissedEvent (copy)
	local v86 = p34 - 0
	local minimizeToSuperBrief = p32.props.minimizeToSuperBrief

	if p32.viewType == SuperBrief then
		if (p36 or p33 < v86 * 0.8) and not minimizeToSuperBrief then
			p32.goTo(Closed, nil, nil, {
				dismissMethod = peekViewDismissedEvent.dismissMethodEnum.swipe
			})

			return
		end

		p32.goTo(SuperBrief)

		return
	end

	if (not p36 or not (p35 > 500)) and (p37 or p33 > v86 * 0.8) or minimizeToSuperBrief then
		p32.goTo(SuperBrief)

		return
	end

	p32.goTo(Closed, nil, nil, {
		dismissMethod = peekViewDismissedEvent.dismissMethodEnum.swipe
	})
end
function u50.handleCurYFromClosedToBrief(p38, p39, p40, p41) -- line: 926
	-- upvalues: Brief (copy), Closed (copy), peekViewDismissedEvent (copy)
	local v92 = p38.getBriefViewY() - 0

	if p38.viewType == Brief then
		if p40 or p39 < 0 + v92 * 0.8 then
			p38.goTo(Closed, nil, nil, {
				dismissMethod = peekViewDismissedEvent.dismissMethodEnum.swipe
			})

			return
		end

		p38.goTo(Brief)

		return
	end

	if p41 or p39 > 0 + v92 * 0.2 then
		p38.goTo(Brief)

		return
	end

	p38.goTo(Closed, nil, nil, {
		dismissMethod = peekViewDismissedEvent.dismissMethodEnum.swipe
	})
end
function u50.adjustScrollingFramePosition(p42) -- line: 949
	-- upvalues: GuiService (copy), v36 (copy), Extended (copy), Full (copy), ArgCheck (copy)
	local SelectedCoreObject = GuiService.SelectedCoreObject

	if not SelectedCoreObject or (not p42.props.contentFrameRef or not SelectedCoreObject:IsDescendantOf(p42.props.contentFrameRef.current)) then
		return
	end

	local v95 = if not v36 then p42.swipeScrollingFrameRef.current else p42.props.swipeScrollingFrameRef.current

	if p42.viewType ~= Extended and p42.viewType ~= Full then
		local v96 = ArgCheck.isNotNil(p42.getViewSize(p42.viewType), "self.adjustScrollingFramePosition.viewSize")

		v95.CanvasPosition = Vector2.new(v95.CanvasPosition.X, v96.Offset)

		return
	end

	local v97 = SelectedCoreObject.AbsolutePosition.Y - p42.props.topBarHeight
	local AbsoluteSizeY = SelectedCoreObject.AbsoluteSize.Y
	local AbsoluteWindowSizeY = v95.AbsoluteWindowSize.Y
	local v100 = AbsoluteWindowSizeY - (v97 + AbsoluteSizeY)
	local CanvasPositionY = v95.CanvasPosition.Y

	if v100 < p42.props.bottomDockedContainerHeight then
		CanvasPositionY = CanvasPositionY + p42.props.bottomDockedContainerHeight - v100
	elseif v97 + AbsoluteSizeY + (CanvasPositionY - AbsoluteWindowSizeY) < AbsoluteWindowSizeY - p42.props.bottomDockedContainerHeight then
		CanvasPositionY = AbsoluteWindowSizeY
	end

	local v102 = math.max(0, (math.min(CanvasPositionY, (v95.AbsoluteCanvasSize.Y or v95.CanvasSize.Y.Offset) - v95.AbsoluteWindowSize.Y)))

	v95.CanvasPosition = Vector2.new(v95.CanvasPosition.X, v102)
end
function u50.handleThumbstickInput(p43, p44, p45) -- line: 996
	-- upvalues: GamepadUtils (copy)
	local p44Position = p44.Position
	local v107 = p43.swipeScrollingFrameRef:getValue()

	if p43.containerFrameRef:getValue() and v107 then
		local v108 = v107.CanvasPosition.Y + p45 * -GamepadUtils.normalizeStickByDeadzone(p44Position).Y * 1000

		if v108 > p43.getFullViewY() then
			v107.CanvasPosition = Vector2.new(0, v108)
		end
	end
end
function u50.renderWithStyle(p46, p47) -- line: 1009
	-- upvalues: Roact (copy), FFlagProfilePlatformNewProfileHeader (copy), FFlagProfilePlatformPeekDraggerContrast (copy), v36 (copy), SuperBrief (copy), ImageSetLabel (copy), v42 (copy), Focusable (copy), RoactGamepad (copy), FFlagEnablePeekViewFocusNav (copy), FFlagPeekViewFixBriefHeightLayoutRace (copy), rect (copy), Brief (copy), Full (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), FocusNavigableSurfaceWrapper (copy), FocusNavigationUtils (copy), ExternalEventConnection (copy), UserInputService (copy)
	local v111 = p46.props[Roact.Children]
	local bottomDockedContainerHeight = p46.props.bottomDockedContainerHeight
	local bottomDockedContainerContent = p46.props.bottomDockedContainerContent
	local v114 = p46.props.thumbstickScrollEnabled and p46.state.scrollableViewType
	local BackgroundContrastColor = p47.Theme.BackgroundContrast.Color
	local v116 = FFlagProfilePlatformNewProfileHeader and not p46.props.hasSolidDragger
	local v118, u119

	if FFlagProfilePlatformPeekDraggerContrast then
		local draggerImageStyle = p46.props.draggerImageStyle

		v118 = if not draggerImageStyle then p47.Theme.UIEmphasis.Color else draggerImageStyle.Color3
		u119 = if not draggerImageStyle then p47.Theme.UIEmphasis.Transparency else draggerImageStyle.Transparency
	else
		v118 = p47.Theme.UIEmphasis.Color
		u119 = p47.Theme.UIEmphasis.Transparency
	end

	local function getDraggerTransparency() -- line: 1036
		-- upvalues: v36 (copy), p46 (copy), u119 (ref)
		local v219 = if not v36 then p46.swipeScrollingFrameRef.current else p46.props.swipeScrollingFrameRef.current

		if not v219 then
			return u119
		end

		local CanvasPositionY = v219.CanvasPosition.Y
		local v221 = p46.getBriefViewY()
		local v222 = if not v36 then p46.getFullViewY() else p46.props.getFullViewY()
		local v223 = math.max(0, (math.min(1, (CanvasPositionY - v221) / (v222 - v221))))

		return u119 + v223 * (1 - u119)
	end

	local v121 = if not v116 then u119 else getDraggerTransparency()
	local v122 = Roact.createElement("TextButton", {
		Text = "",
		LayoutOrder = 3,
		ZIndex = 3,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 25),
		[Roact.Event.Activated] = p46.onPeekHeaderActivated,
		Selectable = false
	}, {
		Dragger = if not p46.props.hideDraggerInSuperBrief or p46.props.peekViewState ~= SuperBrief then Roact.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			Active = false,
			Size = UDim2.new(0, 36, 0, 36),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Image = v42,
			ImageColor3 = v118,
			ImageTransparency = v121
		}) else nil
	})
	local v123 = Roact.createElement(Focusable.Frame, {
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		[Roact.Ref] = p46.clipFrameRef,
		restorePreviousChildFocus = true,
		inputBindings = if v36 or not v114 then nil else {
			ScrollPeekView = RoactGamepad.Input.onStep(Enum.KeyCode.Thumbstick2, function(p48, p49) -- line: 1087
				-- upvalues: p46 (copy)
				p46:handleThumbstickInput(p48, p49)
			end)
		}
	}, {
		SwipeScrollingFrame = Roact.createElement("ScrollingFrame", {
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			Selectable = not FFlagEnablePeekViewFocusNav and nil,
			CanvasSize = UDim2.fromScale(1, 0),
			Active = true,
			BackgroundTransparency = 1,
			ZIndex = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = 0,
			ClipsDescendants = false,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			ElasticBehavior = p46.props.elasticBehavior,
			ScrollingEnabled = p46.props.isScrollingEnabled,
			[Roact.Ref] = if not v36 then p46.swipeScrollingFrameRef else p46.props.swipeScrollingFrameRef,
			[Roact.Change.CanvasPosition] = p46.onSwipeScrollingFrameCanvasPositionChanged,
			[Roact.Change.AbsoluteWindowSize] = p46.onAbsoluteWindowSizeChanged,
			[Roact.Change.AbsoluteCanvasSize] = if not FFlagPeekViewFixBriefHeightLayoutRace then nil else p46.onAbsoluteCanvasSizeChanged
		}, {
			UIListLayout = Roact.createElement("UIListLayout", {
				Padding = UDim.new(0, 0),
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Top
			}),
			FillingArea = Roact.createElement("Frame", {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				Active = false,
				[Roact.Ref] = p46.fillingAreaRef
			}),
			BackgroundFrame = Roact.createElement("Frame", {
				LayoutOrder = 2,
				ZIndex = 1,
				Active = false,
				Size = UDim2.new(1, 0, 0, 0)
			}, {
				BackgroundImage = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 0,
					BorderSizePixel = 0,
					Active = false,
					Size = UDim2.new(1, 0, 0, 9999),
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = rect,
					BackgroundColor3 = if not p46.props.customBackground then BackgroundContrastColor else p46.props.customBackground
				})
			}),
			PeekHeader = if not FFlagProfilePlatformNewProfileHeader or p46.props.hasSolidDragger then v122 else nil,
			ContentFrame = Roact.createElement(Focusable.Frame, {
				LayoutOrder = 4,
				ZIndex = 2,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ClipsDescendants = false,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				[Roact.Ref] = p46.props.contentFrameRef,
				restorePreviousChildFocus = true,
				onFocusGained = function() -- line: 1161
					-- upvalues: p46 (copy), Brief (copy), Full (copy)
					if p46.viewType == Brief and p46.props.peekViewState ~= Full then
						p46.goTo(Full)
					end
				end
			}, if not FFlagProfilePlatformNewProfileHeader or p46.props.hasSolidDragger then v111 else {
				PeekHeader = v122,
				Content = Roact.createElement("Frame", {
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}, v111)
			}),
			BottomContainerPlaceHolder = bottomDockedContainerHeight > 0 and Roact.createElement("Frame", {
				LayoutOrder = 5,
				BackgroundTransparency = 1,
				Active = false,
				Size = UDim2.new(1, 0, 0, bottomDockedContainerHeight)
			})
		}),
		BottomContainer = bottomDockedContainerHeight > 0 and Roact.createElement("Frame", {
			Active = true,
			ZIndex = 2,
			Size = UDim2.new(1, 0, 0, bottomDockedContainerHeight),
			BackgroundTransparency = 1,
			[Roact.Ref] = p46.bottomContainerRef
		}, bottomDockedContainerContent)
	})
	local v124 = if not FFlagAXMigrateAXToGlobalAutofocus or p46.props.shouldCaptureFocus then if not FFlagEnablePeekViewFocusNav then nil else Roact.createElement(FocusNavigableSurfaceWrapper, {
		isIsolated = true,
		surfaceIdentifier = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum.PeekView
	}, {
		ClipFrame = v123
	}) else nil

	return Roact.createFragment({
		DropShadowBackground = Roact.createElement("Frame", {
			ZIndex = 0,
			Visible = p46.props.showDropShadow,
			[Roact.Ref] = p46.shadowRef
		}, {
			UIGradient = Roact.createElement("UIGradient", {
				Rotation = 90,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, p47.Theme.DropShadow.Color),
					ColorSequenceKeypoint.new(1, p47.Theme.DropShadow.Color)
				}),
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(1, 0.7)
				})
			})
		}),
		ClipFrameContainer = v124,
		ClipFrame = if not FFlagAXMigrateAXToGlobalAutofocus or p46.props.shouldCaptureFocus then if not FFlagEnablePeekViewFocusNav then v123 else nil else v123,
		InputBegan = Roact.createElement(ExternalEventConnection, {
			event = UserInputService.InputBegan,
			callback = p46.inputBeganCallback
		}),
		InputEnded = Roact.createElement(ExternalEventConnection, {
			event = UserInputService.InputEnded,
			callback = p46.inputEndedCallback
		})
	})
end
function u50.render(p50) -- line: 1240
	-- upvalues: Roact (copy), Scrim (copy), v36 (copy), Closed (copy), peekViewDismissedEvent (copy)
	return p50.withStyle(function(p51) -- line: 1241
		-- upvalues: p50 (copy), Roact (copy), Scrim (copy), v36 (copy), Closed (copy), peekViewDismissedEvent (copy)
		local v227 = if not p50.useReducedMotion then p50:renderWithStyle(p51) else Roact.createElement("CanvasGroup", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			GroupTransparency = p50.state.canvasGroupTransparency
		}, { p50:renderWithStyle(p51) })

		if p50.props.hasScrim then
			return Roact.createElement(Scrim, {
				[Roact.Ref] = if not v36 then p50.containerFrameRef else p50.props.containerFrameRef,
				onActivated = function() -- line: 1257
					-- upvalues: p50 (copy), Closed (copy), peekViewDismissedEvent (copy)
					if p50.isInGoToState then
						return
					end

					p50.goTo(Closed, nil, nil, {
						dismissMethod = peekViewDismissedEvent.dismissMethodEnum.scrimTap
					})
				end,
				onSizeChanged = p50.onContainerFrameAbsoluteSizeChanged
			}, v227)
		end

		return Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			ClipsDescendants = false,
			[Roact.Ref] = if not v36 then p50.containerFrameRef else p50.props.containerFrameRef,
			[Roact.Change.AbsoluteSize] = p50.onContainerFrameAbsoluteSizeChanged
		}, v227)
	end)
end
function u50.didMount(p52) -- line: 1282
	-- upvalues: Closed (copy), GetFFlagEnablePeekViewStateOnMountParam (copy), Full (copy), Brief (copy), getInputGroup (copy), UserInputService (copy)
	p52.isMounted = true

	if p52.props.closeSignal then
		p52.closeSignalConnection = p52.props.closeSignal:connect(function() -- line: 1286
			-- upvalues: p52 (copy), Closed (copy)
			if not p52.isInGoToState then
				p52.goTo(Closed, true, p52.useReducedMotion)
			end
		end)
	end

	local hidden = p52.props.hidden
	local mountAsFullView = p52.props.mountAsFullView
	local mountAnimation = p52.props.mountAnimation
	local v130 = if not GetFFlagEnablePeekViewStateOnMountParam() then nil else p52.props.stateOnMount

	if not hidden then
		if mountAsFullView then
			p52.goTo(Full, mountAnimation, p52.useReducedMotion)
		elseif v130 ~= nil then
			p52.goTo(v130, mountAnimation, p52.useReducedMotion)
		else
			p52.goTo(Brief, mountAnimation, p52.useReducedMotion)
		end
	end

	p52:setState({
		lastInputGroup = getInputGroup(UserInputService:GetLastInputType())
	})
	UserInputService.LastInputTypeChanged:Connect(function(p53) -- line: 1314
		-- upvalues: p52 (copy), getInputGroup (copy)
		p52:setState({
			lastInputGroup = getInputGroup(p53)
		})
	end)
end
function u50.isAnimating(p54) -- line: 1319
	return p54.goToAnimationConnection ~= nil
end
function u50.didUpdate(p55, p56, p57) -- line: 1323
	-- upvalues: Hidden (copy), Brief (copy), Extended (copy)
	if p57.absoluteWindowSizeX ~= p55.state.absoluteWindowSizeX or p57.absoluteWindowSizeY ~= p55.state.absoluteWindowSizeY then
		p55.reconcileRbxInstances("didUpdate")

		if not p55:isAnimating() then
			p55.updateSwipeScrollingFrame()
		end
	end

	if p56.bottomDockedContainerHeight ~= p55.props.bottomDockedContainerHeight then
		p55.onContainerFrameAbsoluteSizeChanged()
	end

	if p56.briefViewContentHeight ~= p55.props.briefViewContentHeight and not p55:isAnimating() then
		p55.updateSwipeScrollingFrame()
	end

	if p56.hidden == false and p55.props.hidden == true then
		p55.goTo(Hidden)
	elseif p56.hidden == true and p55.props.hidden == false then
		p55.goTo(Brief)
	end

	local peekViewState = p55.props.peekViewState
	local isInGoToState = p55.isInGoToState

	if peekViewState ~= p56.peekViewState and p55.viewType == p56.peekViewState and peekViewState ~= Extended and not isInGoToState then
		p55.goTo(p55.props.peekViewState)
	end
end
function u50.willUnmount(p58) -- line: 1370
	p58.isMounted = false

	if p58.closeSignalConnection then
		p58.closeSignalConnection:disconnect()
		p58.closeSignalConnection = nil
	end

	if p58.goToAnimationConnection then
		p58.goToAnimationConnection:disconnect()
		p58.goToAnimationConnection = nil
	end

	if p58.selectedCoreObjectConnection then
		p58.selectedCoreObjectConnection:disconnect()
		p58.selectedCoreObjectConnection = nil
	end
end

local function mapStateToProps(p59, _) -- line: 1389
	return {
		topBarHeight = p59.TopBar and p59.TopBar.topBarHeight or 0
	}
end
local function PeekViewContainer(p61) -- line: 1395
	-- upvalues: React (copy), FFlagAXScrollingFramesShouldAnimateOnFocus (copy), GamepadUtils (copy), usePeekViewFocusNavigationBindings (copy), u50 (ref), Cryo (copy)
	local u141 = React.useRef(nil)

	if FFlagAXScrollingFramesShouldAnimateOnFocus and p61.scrollingFrameRef then
		u141 = p61.scrollingFrameRef
	end

	local v142 = React.useRef(nil)
	local u143 = if not p61.fullViewContentHeight then UDim.new(1, 0) else p61.fullViewContentHeight
	local v144 = React.useCallback(function() -- line: 1411
		-- upvalues: v142 (copy), u143 (ref)
		return v142.current.AbsoluteSize.Y * u143.Scale + u143.Offset
	end, {
		u143,
		v142
	})
	local v145 = React.useCallback(function(p62, n2: number) -- line: 1416
		-- upvalues: u141 (ref), v142 (copy), GamepadUtils (copy), v144 (copy)
		local p62Position = p62.Position
		local v232 = u141:getValue()

		if v142:getValue() and v232 then
			local v233 = v232.CanvasPosition.Y + n2 * -GamepadUtils.normalizeStickByDeadzone(p62Position).Y * 1000

			if v233 > v144() then
				v232.CanvasPosition = Vector2.new(0, v233)
			end
		end
	end, {
		v144,
		u141,
		v142
	})

	usePeekViewFocusNavigationBindings(v145)

	return React.createElement(u50, Cryo.Dictionary.join(p61, {
		swipeScrollingFrameRef = u141,
		containerFrameRef = v142,
		fullViewContentHeight = u143,
		getFullViewY = v144
	}))
end

u50 = RoactRodux.connect(mapStateToProps, nil)(u50)

if v36 then
	return PeekViewContainer
end

return u50
