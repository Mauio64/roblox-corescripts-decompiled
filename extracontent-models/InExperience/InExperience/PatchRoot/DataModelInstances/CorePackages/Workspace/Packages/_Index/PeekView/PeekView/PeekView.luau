local GuiService = game:GetService("GuiService")
local parent = script:FindFirstAncestor("PeekView").Parent
local UserInputService = game:GetService("UserInputService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local EventIngestService = game:GetService("EventIngestService")
local RunService = game:GetService("RunService")
local Cryo = require(parent.Cryo)
local React = require(parent.React)
local Roact = require(parent.Roact)
local UIBlox = require(parent.UIBlox)
local RoactGamepad = require(parent.RoactGamepad)
local Focusable = RoactGamepad.Focusable
local RoactRodux = require(parent.RoactRodux)
local PeekViewState = require(script.Parent.PeekViewState)
local Scrim = require(script.Parent.Scrim)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local RoactUtils = require(parent.RoactUtils)
local ExternalEventConnection = RoactUtils.ExternalEventConnection
local ArgCheck = require(parent.ArgCheck)
local InputType = require(parent.InputType)
local InputTypeConstants = InputType.InputTypeConstants
local InputUi = require(parent.InputUi)
local GamepadUtils = InputUi.Gamepad.GamepadUtils
local InputType2 = require(parent.InputType)
local getInputGroup = InputType2.getInputGroup
local peekViewDismissedEvent = require(script.Parent.analytics.peekViewDismissedEvent)
local Analytics = require(parent.Analytics)
local eventIngest = Analytics.AnalyticsReporters.EventIngest.new(EventIngestService)
local UiShellEvents = require(parent.UiShellEvents)
local switchAccountScrimError = UiShellEvents.switchAccountScrimError
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local usePeekViewFocusNavigationBindings = require(script.Parent.usePeekViewFocusNavigationBindings)

local SharedFlags = require(parent.SharedFlags)
local GetFFlagEnablePeekViewStateOnMountParam = SharedFlags.GetFFlagEnablePeekViewStateOnMountParam
local SharedFlags2 = require(parent.SharedFlags)
local GetFIntPeekViewTransitionDelayTiming = SharedFlags2.GetFIntPeekViewTransitionDelayTiming
local SharedFlags3 = require(parent.SharedFlags)
local FFlagProfilePlatformNewProfileHeader = SharedFlags3.FFlagProfilePlatformNewProfileHeader
local SharedFlags4 = require(parent.SharedFlags)
local FFlagProfilePlatformPeekDraggerContrast = SharedFlags4.FFlagProfilePlatformPeekDraggerContrast
local defineFastFlag = game:DefineFastFlag("EnableFastScrollingFixTest", false)
local SharedFlags5 = require(parent.SharedFlags)
local GetFFlagPreventSuperBriefPeekViewClose = SharedFlags5.GetFFlagPreventSuperBriefPeekViewClose
local defineFastFlag2 = game:DefineFastFlag("AXMigratePeekViewToFocusNavigation", false)
local defineFastFlag3 = game:DefineFastFlag("FixPeekViewAnimationJitter", false)
local SharedFlags6 = require(parent.SharedFlags)
local FFlagPeekViewFixBriefHeightLayoutRace = SharedFlags6.FFlagPeekViewFixBriefHeightLayoutRace

local rect = Rect.new(9, 9, 9, 9)
local iconsnavigationswipe = Images["icons/navigation/swipe"]

local v = 0.1 * GetFIntPeekViewTransitionDelayTiming()

local Hidden = PeekViewState.Hidden
local Closed = PeekViewState.Closed
local SuperBrief = PeekViewState.SuperBrief
local Brief = PeekViewState.Brief
local Full = PeekViewState.Full
local Extended = PeekViewState.Extended

local extended = Roact.PureComponent:extend("PeekView")

local defaultProps = {
	superBriefViewContentHeight = nil,
	briefViewContentHeight = UDim.new(0.5, 0),
	fullViewContentHeight = 0,
	bottomDockedContainerHeight = 0,
	bottomDockedContainerContent = nil,
	elasticBehavior = 0,
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
	shouldCaptureFocus = true,
	hasSolidDragger = true,
	draggerImageStyle = nil
}
local fullViewContentHeight

if not defineFastFlag2 then
	fullViewContentHeight = UDim.new(1, 0)
end

defaultProps.fullViewContentHeight = fullViewContentHeight

defaultProps.elasticBehavior = Enum.ElasticBehavior.Always
extended.defaultProps = defaultProps

function extended:init()
	self.isMounted = false

	self.isTouched = false
	self.isInGoToState = false

	self.useReducedMotion = UserGameSettings.ReducedMotion

	self.viewType = Hidden
	self:setState({
		scrollableViewType = false,
		absoluteWindowSizeX = 0,
		absoluteWindowSizeY = 0,
		lastInputGroup = getInputGroup(UserInputService:GetLastInputType()),
		canvasGroupTransparency = 0
	})

	self.containerFrameRef = Roact.createRef()
	self.clipFrameRef = Roact.createRef()
	self.shadowRef = Roact.createRef()
	self.fillingAreaRef = Roact.createRef()
	self.swipeScrollingFrameRef = Roact.createRef()
	self.bottomContainerRef = Roact.createRef()

	local binding, setTransitionPercent = Roact.createBinding(0)
	self.transitionPercent = binding
	self.setTransitionPercent = setTransitionPercent

	function self.onAbsoluteWindowSizeChanged(p)
		if
			p.AbsoluteWindowSize.X ~= self.state.absoluteWindowSizeX
			or p.AbsoluteWindowSize.Y ~= self.state.absoluteWindowSizeY
		then
			self:setState({
				absoluteWindowSizeX = p.AbsoluteWindowSize.X,
				absoluteWindowSizeY = p.AbsoluteWindowSize.Y
			})
		end
	end

	function self.withStyle(callback)
		if self.props.withNewThemeProvider then
			return UIBlox.Style.withStyle(callback)
		end

		return callback({
			Theme = {
				BackgroundDefault = { Color = Color3.fromRGB(35, 37, 39), Transparency = 0 },
				UIEmphasis = { Color = Color3.fromRGB(255, 255, 255), Transparency = 0.7 },
				DropShadow = { Color = Color3.fromRGB(0, 0, 0), Transparency = 0 }
			},
			Settings = { ReducedMotion = false }
		})
	end

	function self.inputBeganCallback(p)
		if not (self.isMounted and p.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		self.isTouched = true
	end

	function self.inputEndedCallback(p)
		if not (self.isMounted and p.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		self.isTouched = false
		self.checkGoTo()
	end

	function self.getViewSize(p)
		if not (p ~= Hidden and p ~= Closed) then
			return UDim.new(0, 0)
		end

		if p == SuperBrief then
			if not self.props.superBriefViewContentHeight then
				return UDim.new(0, 0)
			end

			local superBriefViewContentHeight = self.props.superBriefViewContentHeight
			return UDim.new(superBriefViewContentHeight.Scale, superBriefViewContentHeight.Offset + 25)
		end

		if p == Brief then
			local briefViewContentHeight = self.props.briefViewContentHeight
			return UDim.new(briefViewContentHeight.Scale, briefViewContentHeight.Offset + 25)
		end

		if p == Full then
			return self.props.fullViewContentHeight
		end

		return nil
	end

	function self.hasNilRefs(): boolean
		local current

		if defineFastFlag2 then
			current = self.props.swipeScrollingFrameRef.current
		else
			current = self.swipeScrollingFrameRef.current
		end

		local current2

		if defineFastFlag2 then
			current2 = self.props.containerFrameRef.current
		else
			current2 = self.containerFrameRef.current
		end

		local current3 = self.clipFrameRef.current
		local current4 = self.shadowRef.current
		local current5 = self.fillingAreaRef.current

		return not (current and current2 and current3 and current4 and current5)
	end

	function self.reportRefStatus(callSite, p, p2, p3, p4, p5)
		switchAccountScrimError(eventIngest, "switchAccountScrimError", {
			callSite = callSite,
			swipeScrollingFrame = p and "true" or "nil",
			containerFrame = p2 and "true" or "nil",
			clipFrame = p3 and "true" or "nil",
			shadow = p4 and "true" or "nil",
			fillingArea = p5 and "true" or "nil"
		})
	end

	function self.reconcileRbxInstances(p: string?)
		local current

		if defineFastFlag2 then
			current = self.props.swipeScrollingFrameRef.current
		else
			current = self.swipeScrollingFrameRef.current
		end

		local y = current and current.CanvasPosition.Y or 0
		local current2

		if defineFastFlag2 then
			current2 = self.props.containerFrameRef.current
		else
			current2 = self.containerFrameRef.current
		end

		local current3 = self.clipFrameRef.current
		local current4 = self.shadowRef.current
		local current5 = self.fillingAreaRef.current

		if self.hasNilRefs() then
			self.reportRefStatus(p, current, current2, current3, current4, current5)
			return
		end

		local x = current2.AbsoluteSize.X
		local y2 = current2.AbsoluteSize.Y

		current3.Size = UDim2.new(0, x, 0, y)
		current4.Size = UDim2.new(0, x, 0, 36)

		current3.Position = UDim2.new(0, 0, 1, -y)
		current4.Position = UDim2.new(0, 0, 1, -y - 30)

		current.Size = UDim2.new(0, x, 0, y2)
		current.Position = UDim2.new(0, 0, 0, -(y2 - y))

		current5.Size = UDim2.new(0, x, 0, y2)

		local current6 = self.bottomContainerRef.current

		if current6 then
			local bottomDockedContainerHeight = self.props.bottomDockedContainerHeight
			local y3 = current3.AbsoluteSize.Y

			if 25 + bottomDockedContainerHeight < y3 then
				current6.Active = true
				current6.Position = UDim2.new(0, 0, 1, -bottomDockedContainerHeight)
			else
				current6.Active = false
				current6.Position = UDim2.new(0, 0, 1, -current3.AbsoluteSize.Y + 25)
			end
		end

		self.transitionCallbacks()

		if self.props.peekHeaderPositionYChange then
			self.props.peekHeaderPositionYChange(y)
		end
	end

	function self.updateSwipeScrollingFrame()
		local viewSize = self.getViewSize(self.viewType)
		local v2

		if defineFastFlag2 then
			v2 = self.props.containerFrameRef.current and self.props.swipeScrollingFrameRef.current
		else
			v2 = self.containerFrameRef.current and self.swipeScrollingFrameRef.current
		end

		if viewSize and v2 then
			local v3

			if defineFastFlag2 then
				v3 = self.props.containerFrameRef.current
			else
				v3 = self.containerFrameRef.current
			end

			local y = v3.AbsoluteSize.Y
			local current

			if defineFastFlag2 then
				current = self.props.swipeScrollingFrameRef.current
			else
				current = self.swipeScrollingFrameRef.current
			end

			local v4 = y * viewSize.Scale + viewSize.Offset

			if current.CanvasPosition.Y ~= v4 then
				current.CanvasPosition = Vector2.new(0, v4)

				if self.props.peekHeaderPositionYChange then
					self.props.peekHeaderPositionYChange(v4)
				end
			end
		end
	end

	function self.onContainerFrameAbsoluteSizeChanged()
		if not self.isMounted then
			return
		end

		self.reconcileRbxInstances("onContainerFrameAbsoluteSizeChanged")

		if defineFastFlag3 then
			if not self:isAnimating() or self.viewType ~= Hidden then
				self.updateSwipeScrollingFrame()
			end
		else
			self.updateSwipeScrollingFrame()
		end
	end

	if FFlagPeekViewFixBriefHeightLayoutRace then
		function self.onAbsoluteCanvasSizeChanged()
			if
				not self.isMounted
				or self:isAnimating()
				or self.isTouched
				or self.viewType ~= Brief and self.viewType ~= SuperBrief
			then
				return
			end

			local viewSize = self.getViewSize(self.viewType)

			if not viewSize then
				return
			end

			local current

			if defineFastFlag2 then
				current = self.props.swipeScrollingFrameRef.current
			else
				current = self.swipeScrollingFrameRef.current
			end

			local current2

			if defineFastFlag2 then
				current2 = self.props.containerFrameRef.current
			else
				current2 = self.containerFrameRef.current
			end

			if not (current and current2) then
				return
			end

			local v2 = current2.AbsoluteSize.Y * viewSize.Scale + viewSize.Offset
			local v3 = current.AbsoluteCanvasSize.Y - current.AbsoluteWindowSize.Y

			if current.CanvasPosition.Y < v2 and v2 <= v3 then
				current.CanvasPosition = Vector2.new(0, v2)
			end
		end
	end

	function self.onSwipeScrollingFrameCanvasPositionChanged()
		if not self.isMounted then
			return
		end

		local current

		if defineFastFlag2 then
			current = self.props.swipeScrollingFrameRef.current
		else
			current = self.swipeScrollingFrameRef.current
		end

		local y = current.CanvasPosition.Y

		if y ~= math.floor(y) then
			if not defineFastFlag then
				if GetFFlagPreventSuperBriefPeekViewClose() then
					local v2 = math.floor(y + 0.5)

					if self.viewType == PeekViewState.SuperBrief and self.props.minimizeToSuperBrief then
						local superBriefViewY = self.getSuperBriefViewY()

						if superBriefViewY ~= nil and v2 ~= nil and v2 < superBriefViewY then
							v2 = superBriefViewY
						end
					end

					current.CanvasPosition = Vector2.new(0, v2)
				else
					current.CanvasPosition = Vector2.new(0, (math.floor(y + 0.5)))
				end
			end

			if self.props.peekHeaderPositionYChange then
				self.props.peekHeaderPositionYChange(y)
			end

			if not defineFastFlag then
				return
			end
		end

		self.reconcileRbxInstances("onSwipeScrollingFrameCanvasPositionChanged")

		if self.state.lastInputGroup ~= InputTypeConstants.Gamepad then
			self.checkGoTo()
		end
	end

	function self.getBriefViewY()
		local y

		if defineFastFlag2 then
			y = self.props.containerFrameRef.current.AbsoluteSize.Y
		else
			y = self.containerFrameRef.current.AbsoluteSize.Y
		end

		local briefViewContentHeight = self.props.briefViewContentHeight
		return y * briefViewContentHeight.Scale + briefViewContentHeight.Offset + 25
	end

	function self.getSuperBriefViewY()
		if defineFastFlag2 then
			if not (self.props.superBriefViewContentHeight and self.props.containerFrameRef:getValue()) then
				return nil
			end
		elseif not (self.props.superBriefViewContentHeight and self.containerFrameRef:getValue()) then
			return nil
		end

		local y

		if defineFastFlag2 then
			y = self.props.containerFrameRef:getValue().AbsoluteSize.Y
		else
			y = self.containerFrameRef:getValue().AbsoluteSize.Y
		end

		local superBriefViewContentHeight = self.props.superBriefViewContentHeight
		return y * superBriefViewContentHeight.Scale + superBriefViewContentHeight.Offset + 25
	end

	function self.getFullViewY()
		return self.containerFrameRef.current.AbsoluteSize.Y * self.props.fullViewContentHeight.Scale + self.props.fullViewContentHeight.Offset
	end

	function self.transitionCallbacks()
		local briefToFullTransitionPercent = self.props.briefToFullTransitionPercent
		local v2

		if defineFastFlag2 then
			v2 = self.props.swipeScrollingFrameRef.current
		else
			v2 = self.swipeScrollingFrameRef.current
		end

		local y = v2.CanvasPosition.Y
		local briefViewY = self.getBriefViewY()
		local v3

		if defineFastFlag2 then
			v3 = self.props.getFullViewY()
		else
			v3 = self.getFullViewY()
		end

		local v4 = v3 - briefViewY
		local v5 = 0
		local v6

		if briefViewY < y and y <= v3 then
			v6 = (y - briefViewY) / v4
		else
			v6 = v3 < y and 1 or v5
		end

		self.setTransitionPercent(v6)

		if briefToFullTransitionPercent then
			briefToFullTransitionPercent(v6)
		end
	end

	function self.checkGoTo()
		if self.isInGoToState or self.isTouched then
			return
		end

		local current

		if defineFastFlag2 then
			current = self.props.swipeScrollingFrameRef.current
		else
			current = self.swipeScrollingFrameRef.current
		end

		if current and self.state.absoluteWindowSizeX == 0 and self.state.absoluteWindowSizeY == 0 then
			return
		end

		local briefViewY = self.getBriefViewY()
		local superBriefViewY = self.getSuperBriefViewY()
		local v2

		if defineFastFlag2 then
			v2 = self.props.getFullViewY()
		else
			v2 = self.getFullViewY()
		end

		if
			v2 < briefViewY
			or superBriefViewY and briefViewY < superBriefViewY
			or current.AbsoluteWindowSize.Y + 25 + self.props.bottomDockedContainerHeight > (current.AbsoluteCanvasSize.Y or current.CanvasSize.Y.Offset)
		then
			return
		end

		local y = current.ScrollVelocity.Y
		local v3 = y < 0
		local v4 = y > 0
		local y2 = current.CanvasPosition.Y
		local v5

		if self.viewType == PeekViewState.Brief then
			v5 = y2 == briefViewY
		else
			v5 = false
		end

		local v6

		if self.viewType == PeekViewState.Full then
			v6 = y2 == v2
		else
			v6 = false
		end

		if (v5 or v6) and y == 0 then
			return
		end

		if v2 < y2 then
			self:handleCurYAboveFullViewY(v3)
		elseif briefViewY < y2 and y2 <= v2 then
			self:handleCurYFromBriefToFull(y2, y, v3, v4)
		elseif superBriefViewY then
			if superBriefViewY < y2 and y2 <= briefViewY then
				self:handleCurYFromSuperBriefToBrief(y2, superBriefViewY, y, v3, v4)
			elseif y2 <= superBriefViewY then
				self:handleCurYFromClosedToSuperBrief(y2, superBriefViewY, y, v4, v3)
			end
		elseif y2 <= briefViewY then
			self:handleCurYFromClosedToBrief(y2, v4, v3)
		end
	end

	function self.onPeekHeaderActivated()
		if self.viewType == Closed then
			self.goTo(Brief)
		elseif self.viewType == Brief then
			self.goTo(Full)
		elseif self.viewType == SuperBrief then
			self.goTo(Brief)
		elseif self.viewType == Full then
			if self.props.peekHeaderClose then
				self.goTo(Closed, nil, nil, {
					dismissMethod = peekViewDismissedEvent.dismissMethodEnum.handleTap
				})
			else
				self.goTo(Brief)
			end
		end
	end

	function self.setViewType(viewType, options)
		if self.goToAnimationConnection then
			self.goToAnimationConnection:disconnect()
			self.goToAnimationConnection = nil
		end

		self.isInGoToState = false
		self.clipFrameRef.current.Active = false

		local viewType2 = self.viewType

		if viewType2 ~= viewType then
			self.viewType = viewType
			self:setState({
				scrollableViewType = self.viewType == Extended or self.viewType == Full
			})

			local viewStateChanged = self.props.viewStateChanged

			if viewStateChanged then
				viewStateChanged(viewType, viewType2, options or {})
			end
		end

		self.updateSwipeScrollingFrame()
	end

	function self.goTo(p, p2, p3, p4)
		if
			self.viewType == p
			or ArgCheck.isEqual(self.isInGoToState, false, "self.isInGoToState")
			or ArgCheck.isEqual(self.goToAnimationConnection, nil, "self.goToAnimationConnection")
		then
			return
		end

		self.isInGoToState = true

		if defineFastFlag2 then
			local value = self.props.swipeScrollingFrameRef:getValue()
			value.ScrollVelocity = Vector2.new(0, 0)
		else
			local value = self.swipeScrollingFrameRef:getValue()
			value.ScrollVelocity = Vector2.new(0, 0)
		end

		self.clipFrameRef.current.Active = true

		if p2 == false then
			self.setViewType(p, p4)

			if p == Full then
				self:adjustScrollingFramePosition()
			end
		else
			local lastTime = tick()

			if p3 then
				if p ~= Closed then
					self.setViewType(p, p4)

					if p == Full then
						self:adjustScrollingFramePosition()
					end
				end

				self:setState({
					canvasGroupTransparency = p == Closed and 0 or 1
				})

				self.goToAnimationConnection = RunService.RenderStepped:Connect(function()
					if not self.isMounted then
						return
					end

					if p == Full then
						self.updateSwipeScrollingFrame()
					end

					local v2 = tick() - lastTime

					if v2 >= 0.35 then
						self:setState({
							canvasGroupTransparency = p == Closed and 1 or 0
						})

						self.setViewType(p, p4)

						if p == Full then
							self:adjustScrollingFramePosition()
						end
					else
						local canvasGroupTransparency

						if p == Closed then
							canvasGroupTransparency = v2 / 0.35
						else
							canvasGroupTransparency = 1 - v2 / 0.35
						end

						self:setState({ canvasGroupTransparency = canvasGroupTransparency })
					end
				end)
			else
				self:setState({
					canvasGroupTransparency = p == Closed and 1 or 0
				})

				self.goToAnimationConnection = RunService.RenderStepped:Connect(function()
					if not self.isMounted then
						return
					end

					local v2 = tick() - lastTime

					if p ~= Brief or v <= v2 then
						if defineFastFlag2 then
							local value = self.props.swipeScrollingFrameRef:getValue()
							value.ScrollVelocity = Vector2.new(0, 0)
						else
							local value = self.swipeScrollingFrameRef:getValue()
							value.ScrollVelocity = Vector2.new(0, 0)
						end

						local current

						if defineFastFlag2 then
							current = self.props.swipeScrollingFrameRef.current
						else
							current = self.swipeScrollingFrameRef.current
						end

						local y

						if defineFastFlag2 then
							y = self.props.containerFrameRef.current.AbsoluteSize.Y
						else
							y = self.containerFrameRef.current.AbsoluteSize.Y
						end

						local notNil = ArgCheck.isNotNil(self.getViewSize(p), "self.goTo.viewSize")
						local v3 = y * notNil.Scale + notNil.Offset

						if p == Brief then
							v2 -= v
						end

						if v2 >= 0.35 then
							self.setViewType(p, p4)

							if p == Full then
								self:adjustScrollingFramePosition()
							end
						else
							local y2 = current.CanvasPosition.Y
							local v4 = v3 - y2
							current.CanvasPosition = Vector2.new(0, y2 + v4 * math.sin(v2 * 2.468394227820552))
						end
					end
				end)
			end
		end
	end

	self.selectedCoreObjectConnection = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):connect(function()
		if defineFastFlag2 then
			if
				self.props.swipeScrollingFrameRef.current
				and self.state.lastInputGroup == InputTypeConstants.Gamepad
			then
				self:adjustScrollingFramePosition()
			end
		elseif self.swipeScrollingFrameRef.current and self.state.lastInputGroup == InputTypeConstants.Gamepad then
			self:adjustScrollingFramePosition()
		end
	end)
end

function extended:handleCurYAboveFullViewY(p)
	if self.viewType == Full or self.viewType == Extended then
		if self.viewType == Full then
			self.setViewType(Extended)
		end
	elseif p then
		self.goTo(Full)
	else
		self.setViewType(Extended)
	end
end

function extended:handleCurYFromBriefToFull(p, p2, p3, p4)
	local canDragFullViewToBrief = self.props.canDragFullViewToBrief
	local minimizeToSuperBrief = self.props.minimizeToSuperBrief
	local v2

	if defineFastFlag2 then
		v2 = self.props.swipeScrollingFrameRef:getValue()
	else
		v2 = self.swipeScrollingFrameRef:getValue()
	end

	local briefViewY = self.getBriefViewY()
	local v3

	if defineFastFlag2 then
		v3 = self.props.getFullViewY()
	else
		v3 = self.getFullViewY()
	end

	local v4 = v3 - briefViewY

	if self.viewType == Full then
		if v2.AbsoluteCanvasSize.Y - v2.AbsoluteWindowSize.Y - 1 < p then
			return
		end

		if p4 or p < briefViewY + v4 * 0.8 then
			local v5 = p4 and p2 > 500

			if canDragFullViewToBrief and (not v5 or minimizeToSuperBrief) then
				self.goTo(Brief)
			else
				self.goTo(Closed, nil, nil, {
					dismissMethod = peekViewDismissedEvent.dismissMethodEnum.swipe
				})
			end
		end
	elseif self.viewType == Extended then
		if not p4 or p < briefViewY + v4 * 0.8 or p2 > -1 then
			self.goTo(Full)
		end
	elseif p3 or briefViewY + v4 * 0.2 < p then
		self.goTo(Full)
	else
		self.goTo(Brief)
	end
end

function extended:handleCurYFromSuperBriefToBrief(p, p2, p3, p4, p5)
	local canDragFullViewToBrief = self.props.canDragFullViewToBrief
	local minimizeToSuperBrief = self.props.minimizeToSuperBrief
	local v2

	if defineFastFlag2 then
		v2 = self.props.getFullViewY()
	else
		v2 = self.getFullViewY()
	end

	local v3 = v2 - p2

	if self.viewType == Full then
		if not (p5 or p < p2 + v3 * 0.8) then
			self.goTo(Brief)
			return
		end

		local v4 = p5 and p3 > 500

		if canDragFullViewToBrief and (not v4 or minimizeToSuperBrief) then
			self.goTo(SuperBrief)
		else
			self.goTo(Closed, nil, nil, {
				dismissMethod = peekViewDismissedEvent.dismissMethodEnum.swipe
			})
		end
	elseif self.viewType == Extended then
		if not p5 or p < p2 + v3 * 0.8 or p3 > -1 then
			self.goTo(Brief)
		end
	else
		if p4 or p2 + v3 * 0.2 < p then
			self.goTo(Brief)
			return
		end

		local v4 = p5 and p3 > 500

		if canDragFullViewToBrief and (not v4 or minimizeToSuperBrief) then
			self.goTo(SuperBrief)
		else
			self.goTo(Closed, nil, nil, {
				dismissMethod = peekViewDismissedEvent.dismissMethodEnum.swipe
			})
		end
	end
end

function extended:handleCurYFromClosedToSuperBrief(p, p2, p3, p4, p5)
	local v2 = p2 - 0
	local minimizeToSuperBrief = self.props.minimizeToSuperBrief

	if self.viewType == SuperBrief then
		if (p4 or p < v2 * 0.8) and not minimizeToSuperBrief then
			self.goTo(Closed, nil, nil, {
				dismissMethod = peekViewDismissedEvent.dismissMethodEnum.swipe
			})
		else
			self.goTo(SuperBrief)
		end
	elseif (p4 and p3 > 500 or not (p5 or v2 * 0.8 < p)) and not minimizeToSuperBrief then
		self.goTo(Closed, nil, nil, {
			dismissMethod = peekViewDismissedEvent.dismissMethodEnum.swipe
		})
	else
		self.goTo(SuperBrief)
	end
end

function extended:handleCurYFromClosedToBrief(p, p2, p3)
	local v2 = self.getBriefViewY() - 0

	if self.viewType == Brief then
		if p2 or p < 0 + v2 * 0.8 then
			self.goTo(Closed, nil, nil, {
				dismissMethod = peekViewDismissedEvent.dismissMethodEnum.swipe
			})
		else
			self.goTo(Brief)
		end
	elseif p3 or 0 + v2 * 0.2 < p then
		self.goTo(Brief)
	else
		self.goTo(Closed, nil, nil, {
			dismissMethod = peekViewDismissedEvent.dismissMethodEnum.swipe
		})
	end
end

function extended:adjustScrollingFramePosition()
	local selectedCoreObject = GuiService.SelectedCoreObject

	if not (selectedCoreObject and self.props.contentFrameRef and selectedCoreObject:IsDescendantOf(self.props.contentFrameRef.current)) then
		return
	end

	local current

	if defineFastFlag2 then
		current = self.props.swipeScrollingFrameRef.current
	else
		current = self.swipeScrollingFrameRef.current
	end

	if self.viewType == Extended or self.viewType == Full then
		local v2 = selectedCoreObject.AbsolutePosition.Y - self.props.topBarHeight
		local y = selectedCoreObject.AbsoluteSize.Y
		local y2 = current.AbsoluteWindowSize.Y
		local v3 = y2 - (v2 + y)
		local v4 = current.CanvasPosition.Y

		if v3 < self.props.bottomDockedContainerHeight then
			v4 = v4 + self.props.bottomDockedContainerHeight - v3
		elseif v2 + y + (v4 - y2) < y2 - self.props.bottomDockedContainerHeight then
			v4 = y2
		end

		local v5 = math.max(
			0,
			(math.min(v4, (current.AbsoluteCanvasSize.Y or current.CanvasSize.Y.Offset) - current.AbsoluteWindowSize.Y))
		)
		current.CanvasPosition = Vector2.new(current.CanvasPosition.X, v5)
	else
		local notNil = ArgCheck.isNotNil(self.getViewSize(self.viewType), "self.adjustScrollingFramePosition.viewSize")
		current.CanvasPosition = Vector2.new(current.CanvasPosition.X, notNil.Offset)
	end
end

function extended:handleThumbstickInput(p, p2)
	local position = p.Position
	local value = self.swipeScrollingFrameRef:getValue()

	if self.containerFrameRef:getValue() and value then
		local v2 = value.CanvasPosition.Y + p2 * -GamepadUtils.normalizeStickByDeadzone(position).Y * 1000

		if self.getFullViewY() < v2 then
			value.CanvasPosition = Vector2.new(0, v2)
		end
	end
end

function extended:renderWithStyle(p)
	local v2 = self.props[Roact.Children]

	local bottomDockedContainerHeight = self.props.bottomDockedContainerHeight
	local bottomDockedContainerContent = self.props.bottomDockedContainerContent
	local scrollableViewType = self.props.thumbstickScrollEnabled and self.state.scrollableViewType

	local backgroundColor = p.Theme.BackgroundContrast.Color

	local v3 = FFlagProfilePlatformNewProfileHeader and not self.props.hasSolidDragger
	local imageColor, transparency

	if FFlagProfilePlatformPeekDraggerContrast then
		local draggerImageStyle = self.props.draggerImageStyle

		if draggerImageStyle then
			imageColor = draggerImageStyle.Color3
		else
			imageColor = p.Theme.UIEmphasis.Color
		end

		if draggerImageStyle then
			transparency = draggerImageStyle.Transparency
		else
			transparency = p.Theme.UIEmphasis.Transparency
		end
	else
		imageColor = p.Theme.UIEmphasis.Color
		transparency = p.Theme.UIEmphasis.Transparency
	end

	local function getDraggerTransparency()
		local current

		if defineFastFlag2 then
			current = self.props.swipeScrollingFrameRef.current
		else
			current = self.swipeScrollingFrameRef.current
		end

		if not current then
			return transparency
		end

		local y = current.CanvasPosition.Y
		local briefViewY = self.getBriefViewY()
		local v4

		if defineFastFlag2 then
			v4 = self.props.getFullViewY()
		else
			v4 = self.getFullViewY()
		end

		return transparency + math.max(0, (math.min(1, (y - briefViewY) / (v4 - briefViewY)))) * (1 - transparency)
	end

	local imageTransparency

	if v3 then
		imageTransparency = getDraggerTransparency()
	else
		imageTransparency = transparency
	end

	local createElement = Roact.createElement
	local onPeekHeaderActivatedsByActivated = {
		Text = "",
		LayoutOrder = 3,
		ZIndex = 3,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 25),
		[Roact.Event.Activated] = self.onPeekHeaderActivated,
		Selectable = false
	}
	local dragger

	if not (self.props.hideDraggerInSuperBrief and self.props.peekViewState == SuperBrief) then
		dragger = Roact.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 36, 0, 36),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Image = iconsnavigationswipe,
			ImageColor3 = imageColor,
			ImageTransparency = imageTransparency,
			Active = false
		})
	end

	local element = createElement("TextButton", onPeekHeaderActivatedsByActivated, {
		Dragger = dragger
	})

	local createElement2 = Roact.createElement
	local frame = Focusable.Frame
	local clipFrameRefsByRef = {
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		[Roact.Ref] = self.clipFrameRef,
		restorePreviousChildFocus = true,
		inputBindings = not defineFastFlag2 and scrollableViewType and {
			ScrollPeekView = RoactGamepad.Input.onStep(Enum.KeyCode.Thumbstick2, function(p2, p3)
				self:handleThumbstickInput(p2, p3)
			end)
		} or nil
	}

	local createElement3 = Roact.createElement
	local v4 = {
		["AutomaticCanvasSize"] = Enum.AutomaticSize.Y,
		Selectable = false,
		CanvasSize = UDim2.fromScale(1, 0),
		Active = true,
		BackgroundTransparency = 1,
		ZIndex = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 0,
		ClipsDescendants = false,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ElasticBehavior = self.props.elasticBehavior,
		ScrollingEnabled = self.props.isScrollingEnabled
	}
	local ref = Roact.Ref
	local v5

	if defineFastFlag2 then
		v5 = self.props.swipeScrollingFrameRef
	else
		v5 = self.swipeScrollingFrameRef
	end

	v4[ref] = v5

	v4[Roact.Change.CanvasPosition] = self.onSwipeScrollingFrameCanvasPositionChanged
	v4[Roact.Change.AbsoluteWindowSize] = self.onAbsoluteWindowSizeChanged
	local absoluteCanvasSize = Roact.Change.AbsoluteCanvasSize
	local v6

	if FFlagPeekViewFixBriefHeightLayoutRace then
		v6 = self.onAbsoluteCanvasSizeChanged
	end

	v4[absoluteCanvasSize] = v6

	local children = {
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
			[Roact.Ref] = self.fillingAreaRef
		}),
		BackgroundFrame = 0,
		PeekHeader = 0,
		ContentFrame = 0,
		BottomContainerPlaceHolder = 0
	}

	local createElement4 = Roact.createElement
	local v7 = { LayoutOrder = 2, ZIndex = 1, Size = UDim2.new(1, 0, 0, 0), Active = false }

	local createElement5 = Roact.createElement
	local v8 = {
		Size = UDim2.new(1, 0, 0, 9999),
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = rect,
		BackgroundColor3 = 0,
		Active = false
	}

	if self.props.customBackground then
		backgroundColor = self.props.customBackground
	end

	v8.BackgroundColor3 = backgroundColor
	children.BackgroundFrame = createElement4("Frame", v7, {
		BackgroundImage = createElement5(ImageSetLabel, v8)
	})
	local peekHeader

	if not (FFlagProfilePlatformNewProfileHeader and not self.props.hasSolidDragger) then
		peekHeader = element
	end

	children.PeekHeader = peekHeader

	children.ContentFrame = Roact.createElement(Focusable.Frame, {
		LayoutOrder = 4,
		ZIndex = 2,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = false,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		[Roact.Ref] = self.props.contentFrameRef,
		restorePreviousChildFocus = true,
		onFocusGained = function()
			if self.viewType == Brief and self.props.peekViewState ~= Full then
				self.goTo(Full)
			end
		end
	}, FFlagProfilePlatformNewProfileHeader and not self.props.hasSolidDragger and {
		PeekHeader = element,
		Content = Roact.createElement(
			"Frame",
			{
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			},
			v2
		)
	} or v2)

	children.BottomContainerPlaceHolder = bottomDockedContainerHeight > 0
		and Roact.createElement("Frame", {
			LayoutOrder = 5,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, bottomDockedContainerHeight),
			Active = false
		})
	local v9 = {
		SwipeScrollingFrame = createElement3("ScrollingFrame", v4, children),
		BottomContainer = 0
	}
	local bottomContainer

	if bottomDockedContainerHeight > 0 then
		bottomContainer = Roact.createElement("Frame", {
			Active = true,
			ZIndex = 2,
			Size = UDim2.new(1, 0, 0, bottomDockedContainerHeight),
			BackgroundTransparency = 1,
			[Roact.Ref] = self.bottomContainerRef
		}, bottomDockedContainerContent)
	else
		bottomContainer = false
	end

	v9.BottomContainer = bottomContainer
	local element2 = createElement2(frame, clipFrameRefsByRef, v9)

	local createFragment = Roact.createFragment
	local children2 = {
		DropShadowBackground = Roact.createElement(
			"Frame",
			{ ZIndex = 0, Visible = self.props.showDropShadow, [Roact.Ref] = self.shadowRef },
			{
				UIGradient = Roact.createElement("UIGradient", {
					Rotation = 90,
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, p.Theme.DropShadow.Color),
						ColorSequenceKeypoint.new(1, p.Theme.DropShadow.Color)
					}),
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 1),
						NumberSequenceKeypoint.new(1, 0.7)
					})
				})
			}
		),
		ClipFrameContainer = 0,
		ClipFrame = 0,
		InputBegan = 0,
		InputEnded = 0
	}
	local clipFrameContainer

	if self.props.shouldCaptureFocus then
		clipFrameContainer = Roact.createElement(
			FocusNavigableSurfaceWrapper,
			{
				surfaceIdentifier = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum.PeekView,
				isIsolated = true
			},
			{ ClipFrame = element2 }
		)
	end

	children2.ClipFrameContainer = clipFrameContainer

	if self.props.shouldCaptureFocus then
		element2 = nil
	end

	children2.ClipFrame = element2
	children2.InputBegan = Roact.createElement(ExternalEventConnection, {
		event = UserInputService.InputBegan,
		callback = self.inputBeganCallback
	})

	children2.InputEnded = Roact.createElement(ExternalEventConnection, {
		event = UserInputService.InputEnded,
		callback = self.inputEndedCallback
	})
	return createFragment(children2)
end

function extended:render()
	return self.withStyle(function(p)
		local v2

		if self.useReducedMotion then
			v2 = Roact.createElement(
				"CanvasGroup",
				{
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					GroupTransparency = self.state.canvasGroupTransparency
				},
				{ self:renderWithStyle(p) }
			)
		else
			v2 = self:renderWithStyle(p)
		end

		if self.props.hasScrim then
			local createElement = Roact.createElement
			local ref = Roact.Ref
			local v3

			if defineFastFlag2 then
				v3 = self.props.containerFrameRef
			else
				v3 = self.containerFrameRef
			end

			return createElement(Scrim, {
				[ref] = v3,
				onActivated = function()
					if self.isInGoToState then
						return
					end

					self.goTo(Closed, nil, nil, {
						dismissMethod = peekViewDismissedEvent.dismissMethodEnum.scrimTap
					})
				end,
				onSizeChanged = self.onContainerFrameAbsoluteSizeChanged
			}, v2)
		else
			local createElement = Roact.createElement
			local v3 = {
				["Size"] = nil,
				["Size"] = nil,
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				ClipsDescendants = false
			}

			local ref = Roact.Ref
			local v4

			if defineFastFlag2 then
				v4 = self.props.containerFrameRef
			else
				v4 = self.containerFrameRef
			end

			v3[ref] = v4

			v3[Roact.Change.AbsoluteSize] = self.onContainerFrameAbsoluteSizeChanged
			return createElement("Frame", v3, v2)
		end
	end)
end

function extended:didMount()
	self.isMounted = true

	if self.props.closeSignal then
		self.closeSignalConnection = self.props.closeSignal:connect(function()
			if not self.isInGoToState then
				self.goTo(Closed, true, self.useReducedMotion)
			end
		end)
	end

	local hidden = self.props.hidden

	local mountAsFullView = self.props.mountAsFullView
	local mountAnimation = self.props.mountAnimation
	local stateOnMount

	if GetFFlagEnablePeekViewStateOnMountParam() then
		stateOnMount = self.props.stateOnMount
	end

	if not hidden then
		if mountAsFullView then
			self.goTo(Full, mountAnimation, self.useReducedMotion)
		elseif stateOnMount == nil then
			self.goTo(Brief, mountAnimation, self.useReducedMotion)
		else
			self.goTo(stateOnMount, mountAnimation, self.useReducedMotion)
		end
	end

	self:setState({
		lastInputGroup = getInputGroup(UserInputService:GetLastInputType())
	})
	UserInputService.LastInputTypeChanged:Connect(function(p)
		self:setState({ lastInputGroup = getInputGroup(p) })
	end)
end

function extended:isAnimating(): boolean
	return self.goToAnimationConnection ~= nil
end

function extended:didUpdate(data, p)
	if
		p.absoluteWindowSizeX ~= self.state.absoluteWindowSizeX
		or p.absoluteWindowSizeY ~= self.state.absoluteWindowSizeY
	then
		self.reconcileRbxInstances("didUpdate")

		if not self:isAnimating() then
			self.updateSwipeScrollingFrame()
		end
	end

	if data.bottomDockedContainerHeight ~= self.props.bottomDockedContainerHeight then
		self.onContainerFrameAbsoluteSizeChanged()
	end

	if data.briefViewContentHeight ~= self.props.briefViewContentHeight and not self:isAnimating() then
		self.updateSwipeScrollingFrame()
	end

	if data.hidden == false and self.props.hidden == true then
		self.goTo(Hidden)
	elseif data.hidden == true and self.props.hidden == false then
		self.goTo(Brief)
	end

	local peekViewState = self.props.peekViewState

	local isInGoToState = self.isInGoToState

	if
		peekViewState ~= data.peekViewState
		and self.viewType == data.peekViewState
		and peekViewState ~= Extended
		and not isInGoToState
	then
		self.goTo(self.props.peekViewState)
	end
end

function extended:willUnmount()
	self.isMounted = false

	if self.closeSignalConnection then
		self.closeSignalConnection:disconnect()
		self.closeSignalConnection = nil
	end

	if self.goToAnimationConnection then
		self.goToAnimationConnection:disconnect()
		self.goToAnimationConnection = nil
	end

	if self.selectedCoreObjectConnection then
		self.selectedCoreObjectConnection:disconnect()
		self.selectedCoreObjectConnection = nil
	end
end

local function mapStateToProps(p, _)
	return {
		topBarHeight = p.TopBar and p.TopBar.topBarHeight or 0
	}
end

local function PeekViewContainer(p)
	local swipeScrollingFrameRef = React.useRef(nil)

	if p.scrollingFrameRef then
		swipeScrollingFrameRef = p.scrollingFrameRef
	end

	local ref = React.useRef(nil)
	local fullViewContentHeight2

	if p.fullViewContentHeight then
		fullViewContentHeight2 = p.fullViewContentHeight
	else
		fullViewContentHeight2 = UDim.new(1, 0)
	end

	local getFullViewY = React.useCallback(function()
		return ref.current.AbsoluteSize.Y * fullViewContentHeight2.Scale + fullViewContentHeight2.Offset
	end, { fullViewContentHeight2, ref })

	usePeekViewFocusNavigationBindings((React.useCallback(function(p2, p3: number)
		local position = p2.Position
		local value = swipeScrollingFrameRef:getValue()

		if ref:getValue() and value then
			local v2 = value.CanvasPosition.Y + p3 * -GamepadUtils.normalizeStickByDeadzone(position).Y * 1000

			if getFullViewY() < v2 then
				value.CanvasPosition = Vector2.new(0, v2)
			end
		end
	end, { getFullViewY, swipeScrollingFrameRef, ref })))

	return React.createElement(
		extended,
		Cryo.Dictionary.join(p, {
			swipeScrollingFrameRef = swipeScrollingFrameRef,
			containerFrameRef = ref,
			fullViewContentHeight = fullViewContentHeight2,
			getFullViewY = getFullViewY
		})
	)
end

extended = RoactRodux.connect(mapStateToProps, nil)(extended)
return if defineFastFlag2 then PeekViewContainer else extended
