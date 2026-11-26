local GuiService = game:GetService("GuiService")

local UserInputService = game:GetService("UserInputService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local EventIngestService = game:GetService("EventIngestService")
local RunService = game:GetService("RunService")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/PeekView/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PeekView/React")
local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/PeekView/Roact")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/PeekView/UIBlox")
local RoactGamepad = require("@game/CorePackages/Workspace/Packages/_Workspace/PeekView/RoactGamepad")
local focusable = RoactGamepad.Focusable
local RoactRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/PeekView/RoactRodux")
local PeekViewState = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/PeekViewState")
local Scrim = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/Scrim")
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local images = UIBlox.App.ImageSet.Images
local externalEventConnection = require("@game/CorePackages/Workspace/Packages/_Workspace/PeekView/RoactUtils").ExternalEventConnection
local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/ArgCheck")
local inputTypeConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/PeekView/InputType").InputTypeConstants
local gamepadUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/PeekView/InputUi").Gamepad.GamepadUtils
local getInputGroup = require("@game/CorePackages/Workspace/Packages/_Workspace/PeekView/InputType").getInputGroup
local peekViewDismissedEvent = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/analytics/peekViewDismissedEvent")
local eventIngest = require("@game/CorePackages/Workspace/Packages/_Workspace/PeekView/Analytics").AnalyticsReporters.EventIngest.new(EventIngestService)
local switchAccountScrimError = require("@game/CorePackages/Workspace/Packages/_Workspace/PeekView/UiShellEvents").switchAccountScrimError
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/PeekView/FocusNavigationUtils")
local focusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local usePeekViewFocusNavigationBindings = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/usePeekViewFocusNavigationBindings")

local getFFlagEnablePeekViewStateOnMountParam = require("@game/CorePackages/Workspace/Packages/_Workspace/PeekView/SharedFlags").GetFFlagEnablePeekViewStateOnMountParam
local getFIntPeekViewTransitionDelayTiming = require("@game/CorePackages/Workspace/Packages/_Workspace/PeekView/SharedFlags").GetFIntPeekViewTransitionDelayTiming
local fFlagProfilePlatformNewProfileHeader = require("@game/CorePackages/Workspace/Packages/_Workspace/PeekView/SharedFlags").FFlagProfilePlatformNewProfileHeader
local fFlagProfilePlatformPeekDraggerContrast = require("@game/CorePackages/Workspace/Packages/_Workspace/PeekView/SharedFlags").FFlagProfilePlatformPeekDraggerContrast
local defineFastFlag = game:DefineFastFlag("EnableFastScrollingFixTest", false)
local getFFlagPreventSuperBriefPeekViewClose = require("@game/CorePackages/Workspace/Packages/_Workspace/PeekView/SharedFlags").GetFFlagPreventSuperBriefPeekViewClose
local defineFastFlag2 = game:DefineFastFlag("AXMigratePeekViewToFocusNavigation", false)
local defineFastFlag3 = game:DefineFastFlag("FixPeekViewAnimationJitter", false)
local fFlagPeekViewFixBriefHeightLayoutRace = require("@game/CorePackages/Workspace/Packages/_Workspace/PeekView/SharedFlags").FFlagPeekViewFixBriefHeightLayoutRace

local rect = Rect.new(9, 9, 9, 9)
local iconsnavigationswipe = images["icons/navigation/swipe"]

local v5 = 0.1 * getFIntPeekViewTransitionDelayTiming()

local hidden = PeekViewState.Hidden
local closed = PeekViewState.Closed
local superBrief = PeekViewState.SuperBrief
local brief = PeekViewState.Brief
local full = PeekViewState.Full
local extended = PeekViewState.Extended

local extended2 = Roact.PureComponent:extend("PeekView")

local v6 = {
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
local v7 = if not defineFastFlag2 then UDim.new(1, 0) else nil
v6.fullViewContentHeight = v7

v6.elasticBehavior = Enum.ElasticBehavior.Always
extended2.defaultProps = v6

function extended2:init()
	self.isMounted = false

	self.isTouched = false
	self.isInGoToState = false

	self.useReducedMotion = UserGameSettings.ReducedMotion

	self.viewType = hidden
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

	local binding, v8 = Roact.createBinding(0)
	self.transitionPercent = binding
	self.setTransitionPercent = v8

	function self.onAbsoluteWindowSizeChanged(p2)
		if
			p2.AbsoluteWindowSize.X ~= self.state.absoluteWindowSizeX
			or p2.AbsoluteWindowSize.Y ~= self.state.absoluteWindowSizeY
		then
			self:setState({
				absoluteWindowSizeX = p2.AbsoluteWindowSize.X,
				absoluteWindowSizeY = p2.AbsoluteWindowSize.Y
			})
		end
	end

	function self.withStyle(callback)
		if self.props.withNewThemeProvider then
			return UIBlox.Style.withStyle(callback)
		end

		return callback({
			Theme = {
				BackgroundDefault = {
					Color = Color3.fromRGB(35, 37, 39),
					Transparency = 0
				},
				UIEmphasis = {
					Color = Color3.fromRGB(255, 255, 255),
					Transparency = 0.7
				},
				DropShadow = { Color = Color3.fromRGB(0, 0, 0), Transparency = 0 }
			},
			Settings = { ReducedMotion = false }
		})
	end

	function self.inputBeganCallback(p2)
		if not (self.isMounted and p2.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		self.isTouched = true
	end

	function self.inputEndedCallback(p2)
		if not (self.isMounted and p2.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		self.isTouched = false
		self.checkGoTo()
	end

	function self.getViewSize(p2)
		if not (p2 ~= hidden and p2 ~= closed) then
			return UDim.new(0, 0)
		end

		if p2 == superBrief then
			if not self.props.superBriefViewContentHeight then
				return UDim.new(0, 0)
			end

			local superBriefViewContentHeight = self.props.superBriefViewContentHeight
			return UDim.new(superBriefViewContentHeight.Scale, superBriefViewContentHeight.Offset + 25)
		end

		if p2 == brief then
			local briefViewContentHeight = self.props.briefViewContentHeight
			return UDim.new(briefViewContentHeight.Scale, briefViewContentHeight.Offset + 25)
		end

		if p2 == full then
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

	function self.reportRefStatus(p2, p3, p4, p5, p6, p7)
		switchAccountScrimError(eventIngest, "switchAccountScrimError", {
			callSite = p2,
			swipeScrollingFrame = p3 and "true" or "nil",
			containerFrame = p4 and "true" or "nil",
			clipFrame = p5 and "true" or "nil",
			shadow = p6 and "true" or "nil",
			fillingArea = p7 and "true" or "nil"
		})
	end

	function self.reconcileRbxInstances(p2)
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
			self.reportRefStatus(p2, current, current2, current3, current4, current5)
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
		local v9

		if defineFastFlag2 then
			v9 = self.props.containerFrameRef.current and self.props.swipeScrollingFrameRef.current
		else
			v9 = self.containerFrameRef.current and self.swipeScrollingFrameRef.current
		end

		if viewSize and v9 then
			local y = (if defineFastFlag2 then self.props.containerFrameRef.current else self.containerFrameRef.current).AbsoluteSize.Y
			local current

			if defineFastFlag2 then
				current = self.props.swipeScrollingFrameRef.current
			else
				current = self.swipeScrollingFrameRef.current
			end

			local v11 = y * viewSize.Scale + viewSize.Offset

			if current.CanvasPosition.Y ~= v11 then
				current.CanvasPosition = Vector2.new(0, v11)

				if self.props.peekHeaderPositionYChange then
					self.props.peekHeaderPositionYChange(v11)
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
			if not self:isAnimating() or self.viewType ~= hidden then
				self.updateSwipeScrollingFrame()
			end
		else
			self.updateSwipeScrollingFrame()
		end
	end

	if fFlagPeekViewFixBriefHeightLayoutRace then
		function self.onAbsoluteCanvasSizeChanged()
			if
				not self.isMounted
				or self:isAnimating()
				or self.isTouched
				or self.viewType ~= brief and self.viewType ~= superBrief
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

			local v9 = current2.AbsoluteSize.Y * viewSize.Scale + viewSize.Offset
			local v10 = current.AbsoluteCanvasSize.Y - current.AbsoluteWindowSize.Y

			if current.CanvasPosition.Y < v9 and v9 <= v10 then
				current.CanvasPosition = Vector2.new(0, v9)
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
				if getFFlagPreventSuperBriefPeekViewClose() then
					local v9 = math.floor(y + 0.5)

					if self.viewType == PeekViewState.SuperBrief and self.props.minimizeToSuperBrief then
						local superBriefViewY = self.getSuperBriefViewY()

						if superBriefViewY ~= nil and v9 ~= nil and v9 < superBriefViewY then
							v9 = superBriefViewY
						end
					end

					current.CanvasPosition = Vector2.new(0, v9)
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

		if self.state.lastInputGroup ~= inputTypeConstants.Gamepad then
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

		local y = (if defineFastFlag2 then self.props.swipeScrollingFrameRef.current else self.swipeScrollingFrameRef.current).CanvasPosition.Y
		local briefViewY = self.getBriefViewY()

		local v10 = if defineFastFlag2 then self.props.getFullViewY() else self.getFullViewY()
		local v11 = v10 - briefViewY
		local v12 = 0
		local v13 = if briefViewY < y and y <= v10 then (y - briefViewY) / v11 else v10 < y and 1 or v12

		self.setTransitionPercent(v13)

		if briefToFullTransitionPercent then
			briefToFullTransitionPercent(v13)
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

		local v9 = if defineFastFlag2 then self.props.getFullViewY() else self.getFullViewY()

		if
			v9 < briefViewY
			or superBriefViewY and briefViewY < superBriefViewY
			or current.AbsoluteWindowSize.Y + 25 + self.props.bottomDockedContainerHeight > (current.AbsoluteCanvasSize.Y or current.CanvasSize.Y.Offset)
		then
			return
		end

		local y = current.ScrollVelocity.Y
		local v10 = y < 0
		local v11 = y > 0
		local y2 = current.CanvasPosition.Y

		local v12 = self.viewType == PeekViewState.Brief and y2 == briefViewY
		local v13 = self.viewType == PeekViewState.Full and y2 == v9

		if (v12 or v13) and y == 0 then
			return
		end

		if v9 < y2 then
			self:handleCurYAboveFullViewY(v10)
		elseif briefViewY < y2 and y2 <= v9 then
			self:handleCurYFromBriefToFull(y2, y, v10, v11)
		elseif superBriefViewY then
			if superBriefViewY < y2 and y2 <= briefViewY then
				self:handleCurYFromSuperBriefToBrief(y2, superBriefViewY, y, v10, v11)
			elseif y2 <= superBriefViewY then
				self:handleCurYFromClosedToSuperBrief(y2, superBriefViewY, y, v11, v10)
			end
		elseif y2 <= briefViewY then
			self:handleCurYFromClosedToBrief(y2, v11, v10)
		end
	end

	function self.onPeekHeaderActivated()
		if self.viewType == closed then
			self.goTo(brief)
		elseif self.viewType == brief then
			self.goTo(full)
		elseif self.viewType == superBrief then
			self.goTo(brief)
		elseif self.viewType == full then
			if self.props.peekHeaderClose then
				self.goTo(closed, nil, nil, {
					dismissMethod = peekViewDismissedEvent.dismissMethodEnum.handleTap
				})
			else
				self.goTo(brief)
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
				scrollableViewType = self.viewType == extended or self.viewType == full
			})

			local viewStateChanged = self.props.viewStateChanged

			if viewStateChanged then
				viewStateChanged(viewType, viewType2, options or {})
			end
		end

		self.updateSwipeScrollingFrame()
	end

	function self.goTo(p2, p3, p4, p5)
		if
			self.viewType == p2
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
			local value_2 = self.swipeScrollingFrameRef:getValue()
			value_2.ScrollVelocity = Vector2.new(0, 0)
		end

		self.clipFrameRef.current.Active = true

		if p3 == false then
			self.setViewType(p2, p5)

			if p2 == full then
				self:adjustScrollingFramePosition()
			end
		else
			local lastTime = tick()

			if p4 then
				if p2 ~= closed then
					self.setViewType(p2, p5)

					if p2 == full then
						self:adjustScrollingFramePosition()
					end
				end

				self:setState({
					canvasGroupTransparency = p2 == closed and 0 or 1
				})

				self.goToAnimationConnection = RunService.RenderStepped:Connect(function()
					if not self.isMounted then
						return
					end

					if p2 == full then
						self.updateSwipeScrollingFrame()
					end

					local v9 = tick() - lastTime

					if v9 >= 0.35 then
						self:setState({
							canvasGroupTransparency = p2 == closed and 1 or 0
						})

						self.setViewType(p2, p5)

						if p2 == full then
							self:adjustScrollingFramePosition()
						end
					else
						local v12 = if p2 == closed then v9 / 0.35 else 1 - v9 / 0.35
						self:setState({ canvasGroupTransparency = v12 })
					end
				end)
			else
				self:setState({
					canvasGroupTransparency = p2 == closed and 1 or 0
				})

				self.goToAnimationConnection = RunService.RenderStepped:Connect(function()
					if not self.isMounted then
						return
					end

					local v9 = tick() - lastTime

					if p2 ~= brief or v5 <= v9 then
						if defineFastFlag2 then
							local value = self.props.swipeScrollingFrameRef:getValue()
							value.ScrollVelocity = Vector2.new(0, 0)
						else
							local value_2 = self.swipeScrollingFrameRef:getValue()
							value_2.ScrollVelocity = Vector2.new(0, 0)
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

						local notNil = ArgCheck.isNotNil(self.getViewSize(p2), "self.goTo.viewSize")
						local v10 = y * notNil.Scale + notNil.Offset

						if p2 == brief then
							v9 -= v5
						end

						if v9 >= 0.35 then
							self.setViewType(p2, p5)

							if p2 == full then
								self:adjustScrollingFramePosition()
							end
						else
							local y2 = current.CanvasPosition.Y
							local v11 = v10 - y2
							current.CanvasPosition = Vector2.new(0, y2 + v11 * math.sin(v9 * 2.468394227820552))
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
				and self.state.lastInputGroup == inputTypeConstants.Gamepad
			then
				self:adjustScrollingFramePosition()
			end
		elseif
			self.swipeScrollingFrameRef.current
			and self.state.lastInputGroup == inputTypeConstants.Gamepad
		then
			self:adjustScrollingFramePosition()
		end
	end)
end

function extended2:handleCurYAboveFullViewY(p2)
	if self.viewType == full or self.viewType == extended then
		if self.viewType == full then
			self.setViewType(extended)
		end
	elseif p2 then
		self.goTo(full)
	else
		self.setViewType(extended)
	end
end

function extended2:handleCurYFromBriefToFull(p2, p3, p4, p5)
	local canDragFullViewToBrief = self.props.canDragFullViewToBrief
	local minimizeToSuperBrief = self.props.minimizeToSuperBrief
	local v8

	if defineFastFlag2 then
		v8 = self.props.swipeScrollingFrameRef:getValue()
	else
		v8 = self.swipeScrollingFrameRef:getValue()
	end

	local briefViewY = self.getBriefViewY()
	local v10 = (if defineFastFlag2 then self.props.getFullViewY() else self.getFullViewY()) - briefViewY

	if self.viewType == full then
		if v8.AbsoluteCanvasSize.Y - v8.AbsoluteWindowSize.Y - 1 < p2 then
			return
		end

		if p5 or p2 < briefViewY + v10 * 0.8 then
			local v11 = p5 and p3 > 500

			if canDragFullViewToBrief and (not v11 or minimizeToSuperBrief) then
				self.goTo(brief)
			else
				self.goTo(closed, nil, nil, {
					dismissMethod = peekViewDismissedEvent.dismissMethodEnum.swipe
				})
			end
		end
	elseif self.viewType == extended then
		if not p5 or p2 < briefViewY + v10 * 0.8 or p3 > -1 then
			self.goTo(full)
		end
	elseif p4 or briefViewY + v10 * 0.2 < p2 then
		self.goTo(full)
	else
		self.goTo(brief)
	end
end

function extended2:handleCurYFromSuperBriefToBrief(p2, p3, p4, p5, p6)
	local canDragFullViewToBrief = self.props.canDragFullViewToBrief
	local minimizeToSuperBrief = self.props.minimizeToSuperBrief
	local v9 = (if defineFastFlag2 then self.props.getFullViewY() else self.getFullViewY()) - p3

	if self.viewType == full then
		if not (p6 or p2 < p3 + v9 * 0.8) then
			self.goTo(brief)
			return
		end

		local v10 = p6 and p4 > 500

		if canDragFullViewToBrief and (not v10 or minimizeToSuperBrief) then
			self.goTo(superBrief)
		else
			self.goTo(closed, nil, nil, {
				dismissMethod = peekViewDismissedEvent.dismissMethodEnum.swipe
			})
		end
	elseif self.viewType == extended then
		if not p6 or p2 < p3 + v9 * 0.8 or p4 > -1 then
			self.goTo(brief)
		end
	else
		if p5 or p3 + v9 * 0.2 < p2 then
			self.goTo(brief)
			return
		end

		local v10 = p6 and p4 > 500

		if canDragFullViewToBrief and (not v10 or minimizeToSuperBrief) then
			self.goTo(superBrief)
		else
			self.goTo(closed, nil, nil, {
				dismissMethod = peekViewDismissedEvent.dismissMethodEnum.swipe
			})
		end
	end
end

function extended2:handleCurYFromClosedToSuperBrief(p2, p3, p4, p5, p6)
	local v8 = p3 - 0
	local minimizeToSuperBrief = self.props.minimizeToSuperBrief

	if self.viewType == superBrief then
		if (p5 or p2 < v8 * 0.8) and not minimizeToSuperBrief then
			self.goTo(closed, nil, nil, {
				dismissMethod = peekViewDismissedEvent.dismissMethodEnum.swipe
			})
		else
			self.goTo(superBrief)
		end
	elseif (p5 and p4 > 500 or not (p6 or v8 * 0.8 < p2)) and not minimizeToSuperBrief then
		self.goTo(closed, nil, nil, { dismissMethod = peekViewDismissedEvent.dismissMethodEnum.swipe })
	else
		self.goTo(superBrief)
	end
end

function extended2:handleCurYFromClosedToBrief(p2, p3, p4)
	local v8 = self.getBriefViewY() - 0

	if self.viewType == brief then
		if p3 or p2 < 0 + v8 * 0.8 then
			self.goTo(closed, nil, nil, {
				dismissMethod = peekViewDismissedEvent.dismissMethodEnum.swipe
			})
		else
			self.goTo(brief)
		end
	elseif p4 or 0 + v8 * 0.2 < p2 then
		self.goTo(brief)
	else
		self.goTo(closed, nil, nil, { dismissMethod = peekViewDismissedEvent.dismissMethodEnum.swipe })
	end
end

function extended2:adjustScrollingFramePosition()
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

	if self.viewType == extended or self.viewType == full then
		local v8 = selectedCoreObject.AbsolutePosition.Y - self.props.topBarHeight
		local y = selectedCoreObject.AbsoluteSize.Y
		local y2 = current.AbsoluteWindowSize.Y
		local v9 = y2 - (v8 + y)
		local v10 = current.CanvasPosition.Y

		if v9 < self.props.bottomDockedContainerHeight then
			v10 = v10 + self.props.bottomDockedContainerHeight - v9
		elseif v8 + y + (v10 - y2) < y2 - self.props.bottomDockedContainerHeight then
			v10 = y2
		end

		local v11 = math.max(
			0,
			(math.min(
				v10,
				(current.AbsoluteCanvasSize.Y or current.CanvasSize.Y.Offset) - current.AbsoluteWindowSize.Y
			))
		)
		current.CanvasPosition = Vector2.new(current.CanvasPosition.X, v11)
	else
		local notNil = ArgCheck.isNotNil(
			self.getViewSize(self.viewType),
			"self.adjustScrollingFramePosition.viewSize"
		)
		current.CanvasPosition = Vector2.new(current.CanvasPosition.X, notNil.Offset)
	end
end

function extended2:handleThumbstickInput(p2, p3)
	local position = p2.Position
	local value = self.swipeScrollingFrameRef:getValue()

	if self.containerFrameRef:getValue() and value then
		local v8 = value.CanvasPosition.Y + p3 * -gamepadUtils.normalizeStickByDeadzone(position).Y * 1000

		if self.getFullViewY() < v8 then
			value.CanvasPosition = Vector2.new(0, v8)
		end
	end
end

function extended2:renderWithStyle(p2)
	local v8 = self.props[Roact.Children]

	local bottomDockedContainerHeight = self.props.bottomDockedContainerHeight
	local bottomDockedContainerContent = self.props.bottomDockedContainerContent
	local scrollableViewType = self.props.thumbstickScrollEnabled and self.state.scrollableViewType

	local v9 = p2.Theme.BackgroundContrast.Color

	local v10 = fFlagProfilePlatformNewProfileHeader and not self.props.hasSolidDragger
	local v11, transparency

	if fFlagProfilePlatformPeekDraggerContrast then
		local draggerImageStyle = self.props.draggerImageStyle
		v11 = if draggerImageStyle then draggerImageStyle.Color3 else p2.Theme.UIEmphasis.Color

		if draggerImageStyle then
			transparency = draggerImageStyle.Transparency
		else
			transparency = p2.Theme.UIEmphasis.Transparency
		end
	else
		v11 = p2.Theme.UIEmphasis.Color
		transparency = p2.Theme.UIEmphasis.Transparency
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

		local v12 = if defineFastFlag2 then self.props.getFullViewY() else self.getFullViewY()

		return transparency + math.max(0, (math.min(1, (y - briefViewY) / (v12 - briefViewY)))) * (1 - transparency)
	end

	local v12 = if v10 then getDraggerTransparency() else transparency

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

	local v15 = if not self.props.hideDraggerInSuperBrief or self.props.peekViewState ~= superBrief then Roact.createElement(imageSetLabel, {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 36, 0, 36),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Image = iconsnavigationswipe,
		ImageColor3 = v11,
		ImageTransparency = v12,
		Active = false
	}) else nil
	local element = createElement("TextButton", onPeekHeaderActivatedsByActivated, {
		Dragger = v15
	})

	local createElement2 = Roact.createElement
	local frame = focusable.Frame
	local clipFrameRefsByRef = {
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		[Roact.Ref] = self.clipFrameRef,
		restorePreviousChildFocus = true,
		inputBindings = not defineFastFlag2 and scrollableViewType and {
			ScrollPeekView = RoactGamepad.Input.onStep(Enum.KeyCode.Thumbstick2, function(p3, p4)
				self:handleThumbstickInput(p3, p4)
			end)
		} or nil
	}

	local createElement3 = Roact.createElement
	local v18 = {
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
	local v19 = if defineFastFlag2 then self.props.swipeScrollingFrameRef else self.swipeScrollingFrameRef
	v18[ref] = v19

	v18[Roact.Change.CanvasPosition] = self.onSwipeScrollingFrameCanvasPositionChanged
	v18[Roact.Change.AbsoluteWindowSize] = self.onAbsoluteWindowSizeChanged
	local absoluteCanvasSize = Roact.Change.AbsoluteCanvasSize
	local v20 = if fFlagPeekViewFixBriefHeightLayoutRace then self.onAbsoluteCanvasSizeChanged else nil
	v18[absoluteCanvasSize] = v20

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

	local createElement5 = Roact.createElement
	local v22 = {
		LayoutOrder = 2,
		ZIndex = 1,
		Size = UDim2.new(1, 0, 0, 0),
		Active = false
	}

	local createElement6 = Roact.createElement
	local v25 = {
		Size = UDim2.new(1, 0, 0, 9999),
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = rect,
		BackgroundColor3 = 0,
		Active = false
	}

	if self.props.customBackground then
		v9 = self.props.customBackground
	end

	v25.BackgroundColor3 = v9
	children.BackgroundFrame = createElement5("Frame", v22, {
		BackgroundImage = createElement6(imageSetLabel, v25)
	})

	local v26 = if not (fFlagProfilePlatformNewProfileHeader and not self.props.hasSolidDragger) then element else nil
	children.PeekHeader = v26

	children.ContentFrame = Roact.createElement(focusable.Frame, {
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
			if self.viewType == brief and self.props.peekViewState ~= full then
				self.goTo(full)
			end
		end
	}, fFlagProfilePlatformNewProfileHeader and not self.props.hasSolidDragger and {
		PeekHeader = element,
		Content = Roact.createElement(
			"Frame",
			{
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			},
			v8
		)
	} or v8)

	children.BottomContainerPlaceHolder = bottomDockedContainerHeight > 0
		and Roact.createElement("Frame", {
			LayoutOrder = 5,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, bottomDockedContainerHeight),
			Active = false
		})
	local v16 = {
		SwipeScrollingFrame = createElement3("ScrollingFrame", v18, children),
		BottomContainer = 0
	}
	local v28

	if bottomDockedContainerHeight > 0 then
		v28 = Roact.createElement("Frame", {
			Active = true,
			ZIndex = 2,
			Size = UDim2.new(1, 0, 0, bottomDockedContainerHeight),
			BackgroundTransparency = 1,
			[Roact.Ref] = self.bottomContainerRef
		}, bottomDockedContainerContent)
	else
		v28 = false
	end

	v16.BottomContainer = v28
	local element2 = createElement2(frame, clipFrameRefsByRef, v16)

	local createFragment = Roact.createFragment
	local children2 = {
		DropShadowBackground = Roact.createElement(
			"Frame",
			{
				ZIndex = 0,
				Visible = self.props.showDropShadow,
				[Roact.Ref] = self.shadowRef
			},
			{
				UIGradient = Roact.createElement("UIGradient", {
					Rotation = 90,
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, p2.Theme.DropShadow.Color),
						ColorSequenceKeypoint.new(1, p2.Theme.DropShadow.Color)
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

	local v29 = if self.props.shouldCaptureFocus then Roact.createElement(
		focusNavigableSurfaceWrapper,
		{
			surfaceIdentifier = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum.PeekView,
			isIsolated = true
		},
		{ ClipFrame = element2 }
	) else nil
	children2.ClipFrameContainer = v29

	if self.props.shouldCaptureFocus then
		element2 = nil
	end

	children2.ClipFrame = element2
	children2.InputBegan = Roact.createElement(externalEventConnection, {
		event = UserInputService.InputBegan,
		callback = self.inputBeganCallback
	})

	children2.InputEnded = Roact.createElement(externalEventConnection, {
		event = UserInputService.InputEnded,
		callback = self.inputEndedCallback
	})
	return createFragment(children2)
end

function extended2:render()
	return self.withStyle(function(p2)
		local v8

		if self.useReducedMotion then
			v8 = Roact.createElement(
				"CanvasGroup",
				{
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					GroupTransparency = self.state.canvasGroupTransparency
				},
				{ self:renderWithStyle(p2) }
			)
		else
			v8 = self:renderWithStyle(p2)
		end

		if self.props.hasScrim then
			local createElement = Roact.createElement
			local ref = Roact.Ref
			local v11 = if defineFastFlag2 then self.props.containerFrameRef else self.containerFrameRef
			return createElement(Scrim, {
				[ref] = v11,
				onActivated = function()
					if self.isInGoToState then
						return
					end

					self.goTo(closed, nil, nil, {
						dismissMethod = peekViewDismissedEvent.dismissMethodEnum.scrimTap
					})
				end,
				onSizeChanged = self.onContainerFrameAbsoluteSizeChanged
			}, v8)
		else
			local createElement = Roact.createElement
			local v10 = {
				["Size"] = nil,
				["Size"] = nil,
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				ClipsDescendants = false
			}

			local ref = Roact.Ref
			local v11 = if defineFastFlag2 then self.props.containerFrameRef else self.containerFrameRef
			v10[ref] = v11

			v10[Roact.Change.AbsoluteSize] = self.onContainerFrameAbsoluteSizeChanged
			return createElement("Frame", v10, v8)
		end
	end)
end

function extended2:didMount()
	self.isMounted = true

	if self.props.closeSignal then
		self.closeSignalConnection = self.props.closeSignal:connect(function()
			if not self.isInGoToState then
				self.goTo(closed, true, self.useReducedMotion)
			end
		end)
	end

	local hidden2 = self.props.hidden

	local mountAsFullView = self.props.mountAsFullView
	local mountAnimation = self.props.mountAnimation
	local stateOnMount = if getFFlagEnablePeekViewStateOnMountParam() then self.props.stateOnMount else nil

	if not hidden2 then
		if mountAsFullView then
			self.goTo(full, mountAnimation, self.useReducedMotion)
		elseif stateOnMount == nil then
			self.goTo(brief, mountAnimation, self.useReducedMotion)
		else
			self.goTo(stateOnMount, mountAnimation, self.useReducedMotion)
		end
	end

	self:setState({
		lastInputGroup = getInputGroup(UserInputService:GetLastInputType())
	})
	UserInputService.LastInputTypeChanged:Connect(function(p2)
		self:setState({ lastInputGroup = getInputGroup(p2) })
	end)
end

function extended2:isAnimating(): boolean
	return self.goToAnimationConnection ~= nil
end

function extended2:didUpdate(data, p2)
	if
		p2.absoluteWindowSizeX ~= self.state.absoluteWindowSizeX
		or p2.absoluteWindowSizeY ~= self.state.absoluteWindowSizeY
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
		self.goTo(hidden)
	elseif data.hidden == true and self.props.hidden == false then
		self.goTo(brief)
	end

	local peekViewState = self.props.peekViewState

	local isInGoToState = self.isInGoToState

	if
		peekViewState ~= data.peekViewState
		and self.viewType == data.peekViewState
		and peekViewState ~= extended
		and not isInGoToState
	then
		self.goTo(self.props.peekViewState)
	end
end

function extended2:willUnmount()
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

local function mapStateToProps(p2, p3)
	return {
		topBarHeight = p2.TopBar and p2.TopBar.topBarHeight or 0
	}
end

local function PeekViewContainer(p2)
	local v8 = React.useRef(nil)

	if p2.scrollingFrameRef then
		v8 = p2.scrollingFrameRef
	end

	local ref = React.useRef(nil)

	local v9 = if p2.fullViewContentHeight then p2.fullViewContentHeight else UDim.new(1, 0)

	local v10 = React.useCallback(function()
		return ref.current.AbsoluteSize.Y * v9.Scale + v9.Offset
	end, { v9, ref })

	usePeekViewFocusNavigationBindings((React.useCallback(function(p3, p4)
		local position = p3.Position
		local value = v8:getValue()

		if ref:getValue() and value then
			local v12 = value.CanvasPosition.Y + p4 * -gamepadUtils.normalizeStickByDeadzone(position).Y * 1000

			if v10() < v12 then
				value.CanvasPosition = Vector2.new(0, v12)
			end
		end
	end, { v10, v8, ref })))

	return React.createElement(
		extended2,
		Cryo.Dictionary.join(p2, {
			swipeScrollingFrameRef = v8,
			containerFrameRef = ref,
			fullViewContentHeight = v9,
			getFullViewY = v10
		})
	)
end

extended2 = RoactRodux.connect(mapStateToProps, nil)(extended2)

if defineFastFlag2 then
	return PeekViewContainer
end

return extended2
