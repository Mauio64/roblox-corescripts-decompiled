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
local v32 = game:DefineFastFlag("EnableFastScrollingFixTest", false)
local FFlagEnablePeekViewFocusNav = require(Parent.SharedFlags).FFlagEnablePeekViewFocusNav
local GetFFlagPreventSuperBriefPeekViewClose = require(Parent.SharedFlags).GetFFlagPreventSuperBriefPeekViewClose
local v35 = game:DefineFastFlag("AXMigratePeekViewToFocusNavigation", false)
local FFlagAXMigrateAXToGlobalAutofocus = require(Parent.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local FFlagAXScrollingFramesShouldAnimateOnFocus = require(Parent.SharedFlags).FFlagAXScrollingFramesShouldAnimateOnFocus
local v38 = game:DefineFastFlag("FixPeekViewAnimationJitter", false)
local FFlagPeekViewFixBriefHeightLayoutRace = require(Parent.SharedFlags).FFlagPeekViewFixBriefHeightLayoutRace
local rect = Rect.new(9, 9, 9, 9)
local v41 = Images["icons/navigation/swipe"]
local v42 = 0.1 * GetFIntPeekViewTransitionDelayTiming()
local Hidden = PeekViewState.Hidden
local Closed = PeekViewState.Closed
local SuperBrief = PeekViewState.SuperBrief
local Brief = PeekViewState.Brief
local Full = PeekViewState.Full
local Extended = PeekViewState.Extended
local u49 = Roact.PureComponent:extend("PeekView")

u49.defaultProps = {
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
	briefViewContentHeight = UDim.new(0.5, 0),
	fullViewContentHeight = if v35 then nil else UDim.new(1, 0),
	elasticBehavior = Enum.ElasticBehavior.Always,
	shouldCaptureFocus = not not FFlagAXMigrateAXToGlobalAutofocus or nil
}

function u49.init(p1) -- line: 140
	-- upvalues: UserGameSettings (copy), Hidden (copy), getInputGroup (copy), UserInputService (copy), Roact (copy), UIBlox (copy), Closed (copy), SuperBrief (copy), Brief (copy), Full (copy), v35 (copy), switchAccountScrimError (copy), v24 (copy), v38 (copy), FFlagPeekViewFixBriefHeightLayoutRace (copy), v32 (copy), GetFFlagPreventSuperBriefPeekViewClose (copy), PeekViewState (copy), InputTypeConstants (copy), peekViewDismissedEvent (copy), Extended (copy), ArgCheck (copy), RunService (copy), v42 (copy), GuiService (copy)
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

	local v53, v54 = Roact.createBinding(0)

	p1.transitionPercent = v53
	p1.setTransitionPercent = v54

	function p1.onAbsoluteWindowSizeChanged(p2) -- line: 166
		-- upvalues: p1 (copy)
		if p2.AbsoluteWindowSize.X ~= p1.state.absoluteWindowSizeX or p2.AbsoluteWindowSize.Y ~= p1.state.absoluteWindowSizeY then
			p1:setState({
				absoluteWindowSizeX = p2.AbsoluteWindowSize.X,
				absoluteWindowSizeY = p2.AbsoluteWindowSize.Y
			})
		end
	end
	function p1.withStyle(p3) -- line: 178
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
	function p1.inputBeganCallback(p4) -- line: 204
		-- upvalues: p1 (copy)
		if not p1.isMounted then
			return
		end

		if p4.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		p1.isTouched = true
	end
	function p1.inputEndedCallback(p5) -- line: 216
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
	function p1.getViewSize(p6) -- line: 229
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
	function p1.hasNilRefs() -- line: 254
		-- upvalues: v35 (copy), p1 (copy)
		local v147 = if not v35 then p1.swipeScrollingFrameRef.current else p1.props.swipeScrollingFrameRef.current
		local v148 = if not v35 then p1.containerFrameRef.current else p1.props.containerFrameRef.current
		local current = p1.clipFrameRef.current
		local current2 = p1.shadowRef.current
		local current3 = p1.fillingAreaRef.current

		return not (v147 and (v148 and (current and (current2 and current3))))
	end
	function p1.reportRefStatus(p7, p8, p9, p10, p11, p12) -- line: 268
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
	function p1.reconcileRbxInstances(s1: string?) -- line: 280
		-- upvalues: v35 (copy), p1 (copy)
		local v159 = if not v35 then p1.swipeScrollingFrameRef.current else p1.props.swipeScrollingFrameRef.current
		local v160 = v159 and v159.CanvasPosition.Y or 0
		local v161 = if not v35 then p1.containerFrameRef.current else p1.props.containerFrameRef.current
		local current = p1.clipFrameRef.current
		local current4 = p1.shadowRef.current
		local current5 = p1.fillingAreaRef.current

		if p1.hasNilRefs() then
			p1.reportRefStatus(s1, v159, v161, current, current4, current5)

			return
		end

		local AbsoluteSizeX = v161.AbsoluteSize.X
		local AbsoluteSizeY = v161.AbsoluteSize.Y

		current.Size = UDim2.new(0, AbsoluteSizeX, 0, v160)
		current4.Size = UDim2.new(0, AbsoluteSizeX, 0, 36)
		current.Position = UDim2.new(0, 0, 1, -v160)
		current4.Position = UDim2.new(0, 0, 1, -v160 - 30)
		v159.Size = UDim2.new(0, AbsoluteSizeX, 0, AbsoluteSizeY)
		v159.Position = UDim2.new(0, 0, 0, -(AbsoluteSizeY - v160))
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
			p1.props.peekHeaderPositionYChange(v160)
		end
	end
	function p1.updateSwipeScrollingFrame() -- line: 330
		-- upvalues: p1 (copy), v35 (copy)
		local v169 = p1.getViewSize(p1.viewType)
		local v170 = if not v35 then p1.containerFrameRef.current and p1.swipeScrollingFrameRef.current else p1.props.containerFrameRef.current and p1.props.swipeScrollingFrameRef.current

		if v169 and v170 then
			local AbsoluteSizeY = ((if not v35 then p1.containerFrameRef.current else p1.props.containerFrameRef.current)).AbsoluteSize.Y
			local v172 = if not v35 then p1.swipeScrollingFrameRef.current else p1.props.swipeScrollingFrameRef.current
			local v173 = AbsoluteSizeY * v169.Scale + v169.Offset

			if v173 ~= v172.CanvasPosition.Y then
				v172.CanvasPosition = Vector2.new(0, v173)

				if p1.props.peekHeaderPositionYChange then
					p1.props.peekHeaderPositionYChange(v173)
				end
			end
		end
	end
	function p1.onContainerFrameAbsoluteSizeChanged() -- line: 359
		-- upvalues: p1 (copy), v38 (copy), Hidden (copy)
		if not p1.isMounted then
			return
		end

		p1.reconcileRbxInstances("onContainerFrameAbsoluteSizeChanged")

		if v38 then
			if not p1:isAnimating() or p1.viewType ~= Hidden then
				p1.updateSwipeScrollingFrame()

				return
			end
		else
			p1.updateSwipeScrollingFrame()
		end
	end

	if FFlagPeekViewFixBriefHeightLayoutRace then
		function p1.onAbsoluteCanvasSizeChanged() -- line: 381
			-- upvalues: p1 (copy), Brief (copy), SuperBrief (copy), v35 (copy)
			if not p1.isMounted or (p1:isAnimating() or p1.isTouched) then
				return
			end

			if p1.viewType ~= Brief and p1.viewType ~= SuperBrief then
				return
			end

			local v174 = p1.getViewSize(p1.viewType)

			if not v174 then
				return
			end

			local v175 = if not v35 then p1.swipeScrollingFrameRef.current else p1.props.swipeScrollingFrameRef.current
			local v176 = if not v35 then p1.containerFrameRef.current else p1.props.containerFrameRef.current

			if not v175 or not v176 then
				return
			end

			local v177 = v176.AbsoluteSize.Y * v174.Scale + v174.Offset
			local v178 = v175.AbsoluteCanvasSize.Y - v175.AbsoluteWindowSize.Y

			if v177 > v175.CanvasPosition.Y and v177 <= v178 then
				v175.CanvasPosition = Vector2.new(0, v177)
			end
		end
	end

	function p1.onSwipeScrollingFrameCanvasPositionChanged() -- line: 412
		-- upvalues: p1 (copy), v35 (copy), v32 (copy), GetFFlagPreventSuperBriefPeekViewClose (copy), PeekViewState (copy), InputTypeConstants (copy)
		if not p1.isMounted then
			return
		end

		local v179 = if not v35 then p1.swipeScrollingFrameRef.current else p1.props.swipeScrollingFrameRef.current
		local CanvasPositionY = v179.CanvasPosition.Y

		if CanvasPositionY ~= math.floor(CanvasPositionY) then
			if not v32 then
				if GetFFlagPreventSuperBriefPeekViewClose() then
					local v181 = math.floor(CanvasPositionY + 0.5)

					if p1.viewType == PeekViewState.SuperBrief and p1.props.minimizeToSuperBrief then
						local v182 = p1.getSuperBriefViewY()

						if v182 ~= nil and v181 ~= nil and v181 < v182 then
							v181 = v182
						end
					end

					v179.CanvasPosition = Vector2.new(0, v181)
				else
					v179.CanvasPosition = Vector2.new(0, (math.floor(CanvasPositionY + 0.5)))
				end
			end

			if p1.props.peekHeaderPositionYChange then
				p1.props.peekHeaderPositionYChange(CanvasPositionY)
			end

			if not v32 then
				return
			end
		end

		p1.reconcileRbxInstances("onSwipeScrollingFrameCanvasPositionChanged")

		if p1.state.lastInputGroup ~= InputTypeConstants.Gamepad then
			p1.checkGoTo()
		end
	end
	function p1.getBriefViewY() -- line: 461
		-- upvalues: v35 (copy), p1 (copy)
		local v183 = if not v35 then p1.containerFrameRef.current.AbsoluteSize.Y else p1.props.containerFrameRef.current.AbsoluteSize.Y
		local briefViewContentHeight = p1.props.briefViewContentHeight

		return v183 * briefViewContentHeight.Scale + briefViewContentHeight.Offset + 25
	end
	function p1.getSuperBriefViewY() -- line: 469
		-- upvalues: v35 (copy), p1 (copy)
		if v35 then
			if not p1.props.superBriefViewContentHeight or not p1.props.containerFrameRef:getValue() then
				return nil
			end
		elseif not p1.props.superBriefViewContentHeight or not p1.containerFrameRef:getValue() then
			return nil
		end

		local v185 = if not v35 then p1.containerFrameRef:getValue().AbsoluteSize.Y else p1.props.containerFrameRef:getValue().AbsoluteSize.Y
		local superBriefViewContentHeight = p1.props.superBriefViewContentHeight

		return v185 * superBriefViewContentHeight.Scale + superBriefViewContentHeight.Offset + 25
	end
	function p1.getFullViewY() -- line: 487
		-- upvalues: p1 (copy)
		return p1.containerFrameRef.current.AbsoluteSize.Y * p1.props.fullViewContentHeight.Scale + p1.props.fullViewContentHeight.Offset
	end
	function p1.transitionCallbacks() -- line: 492
		-- upvalues: p1 (copy), v35 (copy)
		local briefToFullTransitionPercent = p1.props.briefToFullTransitionPercent
		local CanvasPositionY = ((if not v35 then p1.swipeScrollingFrameRef.current else p1.props.swipeScrollingFrameRef.current)).CanvasPosition.Y
		local v189 = p1.getBriefViewY()
		local v190 = if not v35 then p1.getFullViewY() else p1.props.getFullViewY()
		local v191 = v190 - v189
		local n1 = 0

		if v189 < CanvasPositionY and CanvasPositionY <= v190 then
			n1 = (CanvasPositionY - v189) / v191
		elseif v190 < CanvasPositionY then
			n1 = 1
		end

		p1.setTransitionPercent(n1)

		if briefToFullTransitionPercent then
			briefToFullTransitionPercent(n1)
		end
	end
	function p1.checkGoTo() -- line: 529
		-- upvalues: p1 (copy), v35 (copy), PeekViewState (copy)
		if p1.isInGoToState then
			return
		end

		if p1.isTouched then
			return
		end

		local v193 = if not v35 then p1.swipeScrollingFrameRef.current else p1.props.swipeScrollingFrameRef.current

		if v193 and p1.state.absoluteWindowSizeX == 0 and p1.state.absoluteWindowSizeY == 0 then
			return
		end

		local v194 = p1.getBriefViewY()
		local v195 = p1.getSuperBriefViewY()
		local v196 = if not v35 then p1.getFullViewY() else p1.props.getFullViewY()

		if v196 < v194 then
			return
		end

		if v195 and v194 < v195 then
			return
		end

		if v193.AbsoluteWindowSize.Y + 25 + p1.props.bottomDockedContainerHeight > (v193.AbsoluteCanvasSize.Y or v193.CanvasSize.Y.Offset) then
			return
		end

		local ScrollVelocityY = v193.ScrollVelocity.Y
		local v198 = ScrollVelocityY < 0
		local v199 = ScrollVelocityY > 0
		local CanvasPositionY = v193.CanvasPosition.Y
		local v201 = p1.viewType == PeekViewState.Brief and CanvasPositionY == v194
		local v202 = p1.viewType == PeekViewState.Full and CanvasPositionY == v196

		if (v201 or v202) and ScrollVelocityY == 0 then
			return
		end

		if v196 < CanvasPositionY then
			p1:handleCurYAboveFullViewY(v198)

			return
		end

		if v194 < CanvasPositionY and CanvasPositionY <= v196 then
			p1:handleCurYFromBriefToFull(CanvasPositionY, ScrollVelocityY, v198, v199)

			return
		end

		if v195 then
			if v195 < CanvasPositionY and CanvasPositionY <= v194 then
				p1:handleCurYFromSuperBriefToBrief(CanvasPositionY, v195, ScrollVelocityY, v198, v199)

				return
			end

			if CanvasPositionY <= v195 then
				p1:handleCurYFromClosedToSuperBrief(CanvasPositionY, v195, ScrollVelocityY, v199, v198)

				return
			end
		elseif CanvasPositionY <= v194 then
			p1:handleCurYFromClosedToBrief(CanvasPositionY, v199, v198)
		end
	end
	function p1.onPeekHeaderActivated() -- line: 616
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
	function p1.setViewType(p13, p14) -- line: 634
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

			local v206 = p1.viewType == Extended or p1.viewType == Full

			p1:setState({
				scrollableViewType = v206
			})

			local viewStateChanged = p1.props.viewStateChanged

			if viewStateChanged then
				viewStateChanged(p13, viewType, p14 or {})
			end
		end

		p1.updateSwipeScrollingFrame()
	end
	function p1.goTo(p15, p16, p17, p18) -- line: 662
		-- upvalues: p1 (copy), ArgCheck (copy), v35 (copy), Full (copy), Closed (copy), RunService (copy), Brief (copy), v42 (copy)
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

		if v35 then
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
				p1.goToAnimationConnection = RunService.RenderStepped:Connect(function() -- line: 697
					-- upvalues: p1 (copy), timestamp (copy), p15 (copy), Brief (copy), v42 (copy), v35 (copy), ArgCheck (copy), p18 (copy), Full (copy)
					if not p1.isMounted then
						return
					end

					local v228 = tick() - timestamp

					if p15 ~= Brief or v228 >= v42 then
						if v35 then
							p1.props.swipeScrollingFrameRef:getValue().ScrollVelocity = Vector2.new(0, 0)
						else
							p1.swipeScrollingFrameRef:getValue().ScrollVelocity = Vector2.new(0, 0)
						end

						local v229 = if not v35 then p1.swipeScrollingFrameRef.current else p1.props.swipeScrollingFrameRef.current
						local v230 = if not v35 then p1.containerFrameRef.current.AbsoluteSize.Y else p1.props.containerFrameRef.current.AbsoluteSize.Y
						local v231 = ArgCheck.isNotNil(p1.getViewSize(p15), "self.goTo.viewSize")
						local v232 = v230 * v231.Scale + v231.Offset

						if p15 == Brief then
							v228 -= v42
						end

						if v228 >= 0.35 then
							p1.setViewType(p15, p18)

							if p15 == Full then
								p1:adjustScrollingFramePosition()
							end

							return
						end

						local CanvasPositionY = v229.CanvasPosition.Y
						local v234 = v232 - CanvasPositionY

						v229.CanvasPosition = Vector2.new(0, CanvasPositionY + v234 * math.sin(v228 * 2.468394227820552))
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
			p1.goToAnimationConnection = RunService.RenderStepped:Connect(function() -- line: 750
				-- upvalues: p1 (copy), p15 (copy), Full (copy), timestamp (copy), Closed (copy), p18 (copy)
				if not p1.isMounted then
					return
				end

				if p15 == Full then
					p1.updateSwipeScrollingFrame()
				end

				local v235 = tick() - timestamp

				if v235 >= 0.35 then
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
					canvasGroupTransparency = if p15 ~= Closed then 1 - v235 / 0.35 else v235 / 0.35
				})
			end)
		end
	end

	p1.selectedCoreObjectConnection = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):connect(function() -- line: 784
		-- upvalues: v35 (copy), p1 (copy), InputTypeConstants (copy)
		if v35 then
			if p1.props.swipeScrollingFrameRef.current and p1.state.lastInputGroup == InputTypeConstants.Gamepad then
				p1:adjustScrollingFramePosition()

				return
			end
		elseif p1.swipeScrollingFrameRef.current and p1.state.lastInputGroup == InputTypeConstants.Gamepad then
			p1:adjustScrollingFramePosition()
		end
	end)
end
function u49.handleCurYAboveFullViewY(p19, p20) -- line: 810
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
function u49.handleCurYFromBriefToFull(p21, p22, p23, p24, p25) -- line: 822
	-- upvalues: v35 (copy), Full (copy), Brief (copy), Closed (copy), peekViewDismissedEvent (copy), Extended (copy)
	local canDragFullViewToBrief = p21.props.canDragFullViewToBrief
	local minimizeToSuperBrief = p21.props.minimizeToSuperBrief
	local v64 = if not v35 then p21.swipeScrollingFrameRef:getValue() else p21.props.swipeScrollingFrameRef:getValue()
	local v65 = p21.getBriefViewY()
	local v66 = ((if not v35 then p21.getFullViewY() else p21.props.getFullViewY())) - v65

	if p21.viewType == Full then
		if p22 > v64.AbsoluteCanvasSize.Y - v64.AbsoluteWindowSize.Y - 1 then
			return
		end

		if p25 or p22 < v65 + v66 * 0.8 then
			local v67 = p25 and p23 > 500

			if canDragFullViewToBrief and (not v67 or minimizeToSuperBrief) then
				p21.goTo(Brief)

				return
			end

			p21.goTo(Closed, nil, nil, {
				dismissMethod = peekViewDismissedEvent.dismissMethodEnum.swipe
			})

			return
		end
	elseif p21.viewType == Extended then
		if not p25 or p22 < v65 + v66 * 0.8 or p23 > -1 then
			p21.goTo(Full)

			return
		end
	else
		if p24 or p22 > v65 + v66 * 0.2 then
			p21.goTo(Full)

			return
		end

		p21.goTo(Brief)
	end
end
function u49.handleCurYFromSuperBriefToBrief(p26, p27, p28, p29, p30, p31) -- line: 863
	-- upvalues: v35 (copy), Full (copy), SuperBrief (copy), Closed (copy), peekViewDismissedEvent (copy), Brief (copy), Extended (copy)
	local canDragFullViewToBrief = p26.props.canDragFullViewToBrief
	local minimizeToSuperBrief = p26.props.minimizeToSuperBrief
	local v76 = ((if not v35 then p26.getFullViewY() else p26.props.getFullViewY())) - p28

	if p26.viewType == Full then
		if p31 or p27 < p28 + v76 * 0.8 then
			local v77 = p31 and p29 > 500

			if canDragFullViewToBrief and (not v77 or minimizeToSuperBrief) then
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
		if not p31 or p27 < p28 + v76 * 0.8 or p29 > -1 then
			p26.goTo(Brief)

			return
		end
	else
		if p30 or p27 > p28 + v76 * 0.2 then
			p26.goTo(Brief)

			return
		end

		local v78 = p31 and p29 > 500

		if canDragFullViewToBrief and (not v78 or minimizeToSuperBrief) then
			p26.goTo(SuperBrief)

			return
		end

		p26.goTo(Closed, nil, nil, {
			dismissMethod = peekViewDismissedEvent.dismissMethodEnum.swipe
		})
	end
end
function u49.handleCurYFromClosedToSuperBrief(p32, p33, p34, p35, p36, p37) -- line: 901
	-- upvalues: SuperBrief (copy), Closed (copy), peekViewDismissedEvent (copy)
	local v85 = p34 - 0
	local minimizeToSuperBrief = p32.props.minimizeToSuperBrief

	if p32.viewType == SuperBrief then
		if (p36 or p33 < v85 * 0.8) and not minimizeToSuperBrief then
			p32.goTo(Closed, nil, nil, {
				dismissMethod = peekViewDismissedEvent.dismissMethodEnum.swipe
			})

			return
		end

		p32.goTo(SuperBrief)

		return
	end

	if (not p36 or not (p35 > 500)) and (p37 or p33 > v85 * 0.8) or minimizeToSuperBrief then
		p32.goTo(SuperBrief)

		return
	end

	p32.goTo(Closed, nil, nil, {
		dismissMethod = peekViewDismissedEvent.dismissMethodEnum.swipe
	})
end
function u49.handleCurYFromClosedToBrief(p38, p39, p40, p41) -- line: 924
	-- upvalues: Brief (copy), Closed (copy), peekViewDismissedEvent (copy)
	local v91 = p38.getBriefViewY() - 0

	if p38.viewType == Brief then
		if p40 or p39 < 0 + v91 * 0.8 then
			p38.goTo(Closed, nil, nil, {
				dismissMethod = peekViewDismissedEvent.dismissMethodEnum.swipe
			})

			return
		end

		p38.goTo(Brief)

		return
	end

	if p41 or p39 > 0 + v91 * 0.2 then
		p38.goTo(Brief)

		return
	end

	p38.goTo(Closed, nil, nil, {
		dismissMethod = peekViewDismissedEvent.dismissMethodEnum.swipe
	})
end
function u49.adjustScrollingFramePosition(p42) -- line: 947
	-- upvalues: GuiService (copy), v35 (copy), Extended (copy), Full (copy), ArgCheck (copy)
	local SelectedCoreObject = GuiService.SelectedCoreObject

	if not SelectedCoreObject or (not p42.props.contentFrameRef or not SelectedCoreObject:IsDescendantOf(p42.props.contentFrameRef.current)) then
		return
	end

	local v94 = if not v35 then p42.swipeScrollingFrameRef.current else p42.props.swipeScrollingFrameRef.current

	if p42.viewType ~= Extended and p42.viewType ~= Full then
		local v95 = ArgCheck.isNotNil(p42.getViewSize(p42.viewType), "self.adjustScrollingFramePosition.viewSize")

		v94.CanvasPosition = Vector2.new(v94.CanvasPosition.X, v95.Offset)

		return
	end

	local v96 = SelectedCoreObject.AbsolutePosition.Y - p42.props.topBarHeight
	local AbsoluteSizeY = SelectedCoreObject.AbsoluteSize.Y
	local AbsoluteWindowSizeY = v94.AbsoluteWindowSize.Y
	local v99 = AbsoluteWindowSizeY - (v96 + AbsoluteSizeY)
	local CanvasPositionY = v94.CanvasPosition.Y

	if v99 < p42.props.bottomDockedContainerHeight then
		CanvasPositionY = CanvasPositionY + p42.props.bottomDockedContainerHeight - v99
	elseif v96 + AbsoluteSizeY + (CanvasPositionY - AbsoluteWindowSizeY) < AbsoluteWindowSizeY - p42.props.bottomDockedContainerHeight then
		CanvasPositionY = AbsoluteWindowSizeY
	end

	local v101 = math.max(0, (math.min(CanvasPositionY, (v94.AbsoluteCanvasSize.Y or v94.CanvasSize.Y.Offset) - v94.AbsoluteWindowSize.Y)))

	v94.CanvasPosition = Vector2.new(v94.CanvasPosition.X, v101)
end
function u49.handleThumbstickInput(p43, p44, p45) -- line: 994
	-- upvalues: GamepadUtils (copy)
	local p44Position = p44.Position
	local v106 = p43.swipeScrollingFrameRef:getValue()

	if p43.containerFrameRef:getValue() and v106 then
		local v107 = v106.CanvasPosition.Y + p45 * -GamepadUtils.normalizeStickByDeadzone(p44Position).Y * 1000

		if v107 > p43.getFullViewY() then
			v106.CanvasPosition = Vector2.new(0, v107)
		end
	end
end
function u49.renderWithStyle(p46, p47) -- line: 1007
	-- upvalues: Roact (copy), v35 (copy), SuperBrief (copy), ImageSetLabel (copy), v41 (copy), FFlagProfilePlatformNewProfileHeader (copy), Focusable (copy), RoactGamepad (copy), FFlagEnablePeekViewFocusNav (copy), FFlagPeekViewFixBriefHeightLayoutRace (copy), rect (copy), Brief (copy), Full (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), FocusNavigableSurfaceWrapper (copy), FocusNavigationUtils (copy), ExternalEventConnection (copy), UserInputService (copy)
	local v110 = p46.props[Roact.Children]
	local bottomDockedContainerHeight = p46.props.bottomDockedContainerHeight
	local bottomDockedContainerContent = p46.props.bottomDockedContainerContent
	local v113 = p46.props.thumbstickScrollEnabled and p46.state.scrollableViewType
	local BackgroundContrastColor = p47.Theme.BackgroundContrast.Color

	local function getDraggerTransparency() -- line: 1016
		-- upvalues: v35 (copy), p46 (copy), p47 (copy)
		local v213 = if not v35 then p46.swipeScrollingFrameRef.current else p46.props.swipeScrollingFrameRef.current

		if not v213 then
			return p47.Theme.UIEmphasis.Transparency
		end

		local CanvasPositionY = v213.CanvasPosition.Y
		local v215 = p46.getBriefViewY()
		local v216 = if not v35 then p46.getFullViewY() else p46.props.getFullViewY()
		local v217 = math.max(0, (math.min(1, (CanvasPositionY - v215) / (v216 - v215))))

		return p47.Theme.UIEmphasis.Transparency + v217 * (1 - p47.Theme.UIEmphasis.Transparency)
	end

	local v116 = Roact.createElement("TextButton", {
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
			Image = v41,
			ImageColor3 = p47.Theme.UIEmphasis.Color,
			ImageTransparency = if not FFlagProfilePlatformNewProfileHeader or p46.props.hasSolidDragger then p47.Theme.UIEmphasis.Transparency else getDraggerTransparency()
		}) else nil
	})
	local v117 = Roact.createElement(Focusable.Frame, {
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		[Roact.Ref] = p46.clipFrameRef,
		restorePreviousChildFocus = true,
		inputBindings = if v35 or not v113 then nil else {
			ScrollPeekView = RoactGamepad.Input.onStep(Enum.KeyCode.Thumbstick2, function(p48, p49) -- line: 1067
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
			[Roact.Ref] = if not v35 then p46.swipeScrollingFrameRef else p46.props.swipeScrollingFrameRef,
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
			PeekHeader = if not FFlagProfilePlatformNewProfileHeader or p46.props.hasSolidDragger then v116 else nil,
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
				onFocusGained = function() -- line: 1141
					-- upvalues: p46 (copy), Brief (copy), Full (copy)
					if p46.viewType == Brief and p46.props.peekViewState ~= Full then
						p46.goTo(Full)
					end
				end
			}, if not FFlagProfilePlatformNewProfileHeader or p46.props.hasSolidDragger then v110 else {
				PeekHeader = v116,
				Content = Roact.createElement("Frame", {
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}, v110)
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
	local v118 = if not FFlagAXMigrateAXToGlobalAutofocus or p46.props.shouldCaptureFocus then if not FFlagEnablePeekViewFocusNav then nil else Roact.createElement(FocusNavigableSurfaceWrapper, {
		isIsolated = true,
		surfaceIdentifier = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum.PeekView
	}, {
		ClipFrame = v117
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
		ClipFrameContainer = v118,
		ClipFrame = if not FFlagAXMigrateAXToGlobalAutofocus or p46.props.shouldCaptureFocus then if not FFlagEnablePeekViewFocusNav then v117 else nil else v117,
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
function u49.render(p50) -- line: 1220
	-- upvalues: Roact (copy), Scrim (copy), v35 (copy), Closed (copy), peekViewDismissedEvent (copy)
	return p50.withStyle(function(p51) -- line: 1221
		-- upvalues: p50 (copy), Roact (copy), Scrim (copy), v35 (copy), Closed (copy), peekViewDismissedEvent (copy)
		local v221 = if not p50.useReducedMotion then p50:renderWithStyle(p51) else Roact.createElement("CanvasGroup", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			GroupTransparency = p50.state.canvasGroupTransparency
		}, { p50:renderWithStyle(p51) })

		if p50.props.hasScrim then
			return Roact.createElement(Scrim, {
				[Roact.Ref] = if not v35 then p50.containerFrameRef else p50.props.containerFrameRef,
				onActivated = function() -- line: 1237
					-- upvalues: p50 (copy), Closed (copy), peekViewDismissedEvent (copy)
					if p50.isInGoToState then
						return
					end

					p50.goTo(Closed, nil, nil, {
						dismissMethod = peekViewDismissedEvent.dismissMethodEnum.scrimTap
					})
				end,
				onSizeChanged = p50.onContainerFrameAbsoluteSizeChanged
			}, v221)
		end

		return Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			ClipsDescendants = false,
			[Roact.Ref] = if not v35 then p50.containerFrameRef else p50.props.containerFrameRef,
			[Roact.Change.AbsoluteSize] = p50.onContainerFrameAbsoluteSizeChanged
		}, v221)
	end)
end
function u49.didMount(p52) -- line: 1262
	-- upvalues: Closed (copy), GetFFlagEnablePeekViewStateOnMountParam (copy), Full (copy), Brief (copy), getInputGroup (copy), UserInputService (copy)
	p52.isMounted = true

	if p52.props.closeSignal then
		p52.closeSignalConnection = p52.props.closeSignal:connect(function() -- line: 1266
			-- upvalues: p52 (copy), Closed (copy)
			if not p52.isInGoToState then
				p52.goTo(Closed, true, p52.useReducedMotion)
			end
		end)
	end

	local hidden = p52.props.hidden
	local mountAsFullView = p52.props.mountAsFullView
	local mountAnimation = p52.props.mountAnimation
	local v124 = if not GetFFlagEnablePeekViewStateOnMountParam() then nil else p52.props.stateOnMount

	if not hidden then
		if mountAsFullView then
			p52.goTo(Full, mountAnimation, p52.useReducedMotion)
		elseif v124 ~= nil then
			p52.goTo(v124, mountAnimation, p52.useReducedMotion)
		else
			p52.goTo(Brief, mountAnimation, p52.useReducedMotion)
		end
	end

	p52:setState({
		lastInputGroup = getInputGroup(UserInputService:GetLastInputType())
	})
	UserInputService.LastInputTypeChanged:Connect(function(p53) -- line: 1294
		-- upvalues: p52 (copy), getInputGroup (copy)
		p52:setState({
			lastInputGroup = getInputGroup(p53)
		})
	end)
end
function u49.isAnimating(p54) -- line: 1299
	return p54.goToAnimationConnection ~= nil
end
function u49.didUpdate(p55, p56, p57) -- line: 1303
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
function u49.willUnmount(p58) -- line: 1350
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

local function mapStateToProps(p59, _) -- line: 1369
	return {
		topBarHeight = p59.TopBar and p59.TopBar.topBarHeight or 0
	}
end
local function PeekViewContainer(p61) -- line: 1375
	-- upvalues: React (copy), FFlagAXScrollingFramesShouldAnimateOnFocus (copy), GamepadUtils (copy), usePeekViewFocusNavigationBindings (copy), u49 (ref), Cryo (copy)
	local u135 = React.useRef(nil)

	if FFlagAXScrollingFramesShouldAnimateOnFocus and p61.scrollingFrameRef then
		u135 = p61.scrollingFrameRef
	end

	local v136 = React.useRef(nil)
	local u137 = if not p61.fullViewContentHeight then UDim.new(1, 0) else p61.fullViewContentHeight
	local v138 = React.useCallback(function() -- line: 1391
		-- upvalues: v136 (copy), u137 (ref)
		return v136.current.AbsoluteSize.Y * u137.Scale + u137.Offset
	end, {
		u137,
		v136
	})
	local v139 = React.useCallback(function(p62, n2: number) -- line: 1396
		-- upvalues: u135 (ref), v136 (copy), GamepadUtils (copy), v138 (copy)
		local p62Position = p62.Position
		local v226 = u135:getValue()

		if v136:getValue() and v226 then
			local v227 = v226.CanvasPosition.Y + n2 * -GamepadUtils.normalizeStickByDeadzone(p62Position).Y * 1000

			if v227 > v138() then
				v226.CanvasPosition = Vector2.new(0, v227)
			end
		end
	end, {
		v138,
		u135,
		v136
	})

	usePeekViewFocusNavigationBindings(v139)

	return React.createElement(u49, Cryo.Dictionary.join(p61, {
		swipeScrollingFrameRef = u135,
		containerFrameRef = v136,
		fullViewContentHeight = u137,
		getFullViewY = v138
	}))
end

u49 = RoactRodux.connect(mapStateToProps, nil)(u49)

if v35 then
	return PeekViewContainer
end

return u49
