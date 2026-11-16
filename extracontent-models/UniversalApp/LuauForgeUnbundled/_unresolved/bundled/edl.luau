local UserInputService = game:GetService("UserInputService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CorePackages = game:GetService("CorePackages")
local fFlagUseNavigationSelectors = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseNavigationSelectors
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")

local module = require("@luauforge/bundled/ecR")
local React = require(CorePackages.Packages.React)
local useSheetNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/FoundationFork/Sheet/useSheetNavigation")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local appNotificationService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppNotificationService
local module3 = require("@luauforge/bundled/edm")
local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")
local module5 = require("@luauforge/bundled/dHu")
local module6 = require("@luauforge/bundled/dUd")
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Selectors

local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")
local module8 = require("@luauforge/bundled/edq")
local module9 = require("@luauforge/bundled/edx")

local module10 = require("@luauforge/bundled/edz")

local defineFastFlag = game:DefineFastFlag("SetRSFNotSelectable", false)
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local fFlagLuaAppLayoutParamsInContext = SharedFlags.FFlagLuaAppLayoutParamsInContext
local fFlagLuaAppSduiSeeAllLayoutParamsFix = SharedFlags.FFlagLuaAppSduiSeeAllLayoutParamsFix
local fFlagExtendScrollingFramesBySafeInsets = SharedFlags.FFlagExtendScrollingFramesBySafeInsets
local fFlagSignalsNavP3dRouteGated = SharedFlags.FFlagSignalsNavP3dRouteGated
local fFlagLuaAppSupportHomeBackToTop = SharedFlags.FFlagLuaAppSupportHomeBackToTop

local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local getLegacyNavigationStore

if fFlagSignalsNavP3dRouteGated then
	getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore
else
	getLegacyNavigationStore = nil
end

local Cryo = require(CorePackages.Packages.Cryo)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local getIconSize = UIBlox.App.ImageSet.getIconSize

local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local iconSize = getIconSize(UIBlox.App.ImageSet.Enum.IconSize.Medium)

local function Spinner(props)
	local activated = props.activated
	local offset = props.offset
	local position = props.Position
	local timer = props.timer
	local tween = props.tween

	local v5 = 0
	local v6 = 1
	local v7 = 0

	if offset > 0 then
		return
	end

	local v8

	if activated then
		v5 = timer * 540
		v8 = 0
	elseif tween then
		v7 = 2 * timer
		v8 = 0
	elseif offset > -52 then
		v8 = -offset
		v5 = 9.6 * v8 - 240
		v7 = 1 - 0.04 * v8
	else
		v6 = 1
		v8 = 52
	end

	local imageColor3 = props.ImageColor3
	return module.createElement(imageSetLabel, {
		Size = UDim2.new(0, iconSize * v6, 0, iconSize * v6),
		Position = position + UDim2.new(0.5, 0, 0, v8 - iconSize / 2),
		ImageTransparency = v7,
		Image = images["icons/common/refresh"],
		ImageColor3 = imageColor3,
		BackgroundTransparency = 1,
		Rotation = v5,
		AnchorPoint = Vector2.new(0.5, 0.5)
	})
end

local extended = module.Component:extend("RefreshScrollingFrame")

extended.defaultProps = {
	preloadDistance = 2000,
	createEndOfScrollElement = false,
	Selectable = if defineFastFlag then false else nil,
	canvasTopPadding = fFlagAppIaScrollAway and 0 or nil,
	canvasSidePadding = fFlagLuaAppLayoutParamsInContext and 0 or nil,
	bottomPadding = fFlagExtendScrollingFramesBySafeInsets and 0 or nil,
	shouldExtendIntoSafeArea = fFlagExtendScrollingFramesBySafeInsets and {
		left = false,
		top = false,
		right = false,
		bottom = false
	} or nil
}

function extended:startTweenBack()
	self:setState({ activated = false, tween = true, timer = 0, offset = 0 })
end

function extended:startSpin()
	self:setState({ activated = true, tween = false, timer = 0 })
end

function extended:startTween()
	self:setState({ activated = true, tween = true, timer = 0 })
end

function extended:didMount()
	self._isMounted = true

	self.updateIsScrollable()
end

function extended:willUnmount()
	self._isMounted = false

	if self.luaAppReloadPageEventConnection ~= nil then
		self.luaAppReloadPageEventConnection:disconnect()
		self.luaAppReloadPageEventConnection = nil
	end
end

function extended:init()
	self._inputCount = 0

	self._isMounted = false

	self._isUserInteracting = false
	self._isRefreshing = false

	self._lastReloadEventTime = tick()

	self.state = {
		activated = false,
		tween = false,
		timer = 0,
		offset = 0,
		isScrollable = false
	}

	self.fitFieldCanvasSize = { CanvasSize = FitChildren.FitAxis.Height }

	local forwardRef = self.props.forwardRef

	if type(forwardRef) == "table" then
		self.scrollingFrameRef = forwardRef
	else
		self.scrollingFrameRef = module.createRef()
	end

	function self.setScrollingFrameRef(current)
		self.scrollingFrameRef.current = current

		if type(forwardRef) == "function" then
			forwardRef(current)
		end
	end

	self.contentFrameRef = module.createRef()

	if fFlagLuaAppLayoutParamsInContext then
		function self.setContentFrameRef(current)
			self.contentFrameRef.current = current

			if self.props.contentFrameRefCallback then
				self.props.contentFrameRefCallback(current)
			end
		end
	end

	function self.scrollBackWithFocus(instance)
		local tween = TweenService:Create(instance, TweenInfo.new(0.3), {
			CanvasPosition = Vector2.new(0, 0)
		})
		tween:Play()
		tween.Completed:Connect(function()
			GuiService:Select(instance)
		end)
	end

	function self.scrollBack()
		if self.scrollingFrameRef.current then
			if UserGameSettings.ReducedMotion then
				self.scrollingFrameRef.current.CanvasPosition = Vector2.new(0, 0)
			elseif self.props.isInputDirectional then
				self.scrollBackWithFocus(self.scrollingFrameRef.current)
			else
				self.scrollingFrameRef.current:ScrollToTop()
			end
		end
	end

	function self.dispatchRefresh()
		local refresh = self.props.refresh

		if self._isMounted and self.scrollingFrameRef.current then
			local y = self.scrollingFrameRef.current.CanvasPosition.Y

			if refresh and not self._isRefreshing then
				self._isRefreshing = true

				if y < -52 then
					self:startSpin()
				else
					self:startTween()
				end

				refresh():andThen(function()
					self._isRefreshing = false

					if self._isMounted then
						self:startTweenBack()
					end
				end, function()
					self._isRefreshing = false

					if self._isMounted then
						self:startTweenBack()
					end
				end)
			end
		end
	end

	function self.onCanvasPositionChanged(p2)
		local refresh = self.props.refresh
		local onCanvasPositionChangedCallback = self.props.onCanvasPositionChangedCallback

		local y = p2.CanvasPosition.Y

		if refresh and y < 52 then
			self:setState({ offset = y })
		end

		if fFlagAppIaScrollAway and module5.getScrollAwayEnabled() and y <= 0 then
			module5.VisibilityControl.show()
		end

		if onCanvasPositionChangedCallback then
			onCanvasPositionChangedCallback(p2)
		end
	end

	function self.renderSteppedCallback(p2)
		if self.state.activated or self.state.tween then
			local v7 = {
				timer = self.state.timer + p2
			}

			if self.state.tween and self.state.timer > 0.5 then
				v7.tween = false
			end

			self:setState(v7)
		end
	end

	function self.inputBeganCallback(p2)
		if p2.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		self._isUserInteracting = true
		self._inputCount += 1
	end

	function self.inputEndedCallback(p2)
		if p2.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		if self._inputCount > 0 then
			self._inputCount -= 1
		end

		if self._inputCount > 0 then
			return
		end

		self._isUserInteracting = false

		if self.state.offset < -52 and not self.state.activated then
			self.dispatchRefresh()
		end
	end

	function self.statusBarTapCallback()
		self.scrollBack()
	end

	function self.onReloadPage()
		if self._isMounted and self.scrollingFrameRef.current then
			local y = self.scrollingFrameRef.current.CanvasPosition.Y
			local now = tick()

			if y == 0 then
				self.dispatchRefresh()
			else
				self.scrollBack()

				if now - self._lastReloadEventTime < 0.5 then
					self.dispatchRefresh()
				end
			end

			self._lastReloadEventTime = now
		end
	end

	function self.onNavigationEventReceived(data)
		local parentAppPage = self.props.parentAppPage
		local v7

		if fFlagSignalsNavP3dRouteGated then
			v7 = getLegacyNavigationStore(false).getCurrentLegacyRoute(false)
		else
			v7 = self.props.currentRoute
		end

		if
			data.namespace == "Navigations"
			and data.detailType == "Reload"
			and HttpService:JSONDecode(data.detail).appName == parentAppPage
			and #v7 == 1
		then
			self.onReloadPage()
		end
	end

	self.luaAppReloadPageEventConnection = module9.ReloadPage:connect(function(p2)
		local parentAppPage = self.props.parentAppPage
		local v7

		if fFlagSignalsNavP3dRouteGated then
			v7 = getLegacyNavigationStore(false).getCurrentLegacyRoute(false)
		else
			v7 = self.props.currentRoute
		end

		if p2 == parentAppPage and #v7 == 1 then
			self.onReloadPage()
		end
	end)

	function self.updateIsScrollable()
		if self.scrollingFrameRef.current and self.contentFrameRef and self.contentFrameRef.current then
			local y = self.scrollingFrameRef.current.AbsoluteSize.Y
			local y2 = self.contentFrameRef.current.AbsoluteSize.Y
			local v7 = y < y2

			if y >= 0 and y2 >= 0 and v7 ~= self.state.isScrollable then
				self:setState({ isScrollable = v7 })
			end
		end
	end

	function self.onCanvasSizeChanged(p2)
		if self.props.onCanvasSizeChangedCallback ~= nil then
			self.props.onCanvasSizeChangedCallback(p2)
		end
	end
end

function extended:render()
	local position

	if fFlagExtendScrollingFramesBySafeInsets then
		position = self.props.Position or UDim2.new(0, 0, 0, 0)

		if self.props.shouldExtendIntoSafeArea.left then
			position += UDim2.fromOffset(-self.props.deviceSafePadding.left, 0)
		end

		if self.props.shouldExtendIntoSafeArea.top then
			position += UDim2.fromOffset(0, -self.props.deviceSafePadding.top)
		end
	else
		position = nil
	end

	local size = self.props.Size

	if fFlagExtendScrollingFramesBySafeInsets then
		if self.props.shouldExtendIntoSafeArea.left then
			size += UDim2.new(0, self.props.deviceSafePadding.left, 0, 0)
		end

		if self.props.shouldExtendIntoSafeArea.top then
			size += UDim2.new(0, 0, 0, self.props.deviceSafePadding.top)
		end

		if self.props.shouldExtendIntoSafeArea.right then
			size += UDim2.new(0, self.props.deviceSafePadding.right, 0, 0)
		end

		if self.props.shouldExtendIntoSafeArea.bottom then
			size += UDim2.new(0, 0, 0, self.props.deviceSafePadding.bottom)
		end
	end

	local backgroundColor3 = self.props.BackgroundColor3
	local backgroundTransparency = self.props.BackgroundTransparency
	local scrollBarImageColor3 = self.props.ScrollBarImageColor3
	local scrollBarThickness = self.props.ScrollBarThickness or 0
	local scrollBarImageTransparency = self.props.ScrollBarImageTransparency or 0
	local canvasTopPadding = if fFlagAppIaScrollAway then self.props.canvasTopPadding else nil
	local canvasSidePadding = if fFlagLuaAppLayoutParamsInContext then self.props.canvasSidePadding else nil
	local v7

	if fFlagExtendScrollingFramesBySafeInsets then
		v7 = position.Y.Offset
	else
		v7 = self.props.Position.Y.Offset
	end

	local notificationService = self.props.NotificationService
	local createFooter = self.props.createFooter
	local useAutomaticSizeContentFrame = self.props.useAutomaticSizeContentFrame
	local activated = self.state.activated
	local tween = self.state.tween
	local offset = self.state.offset
	local createEndOfScrollElement = self.state.isScrollable and self.props.createEndOfScrollElement
	local v8 = activated or tween or self._isUserInteracting

	if activated then
		if offset > 0 and offset < 52 then
			v7 = v7 - offset + 52
		elseif offset <= 0 then
			v7 += 52
		end
	end

	local function renderRSF(p2, p3, color, scrollBarImageColor)
		local createElement = module.createElement
		local onAbsoluteSizeChangedCallbacksByAbsoluteSize = {
			Size = UDim2.new(1, 0, 1, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = p2,
			BackgroundTransparency = p3,
			[module.Change.AbsoluteSize] = self.props.onAbsoluteSizeChangedCallback
		}
		local children = {
			layout = module.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				VerticalAlignment = Enum.VerticalAlignment.Top
			}),
			spinnerFrame = module.createElement(module8.SimpleMotion, {
				style = { sizeY = module8.spring(v7, 150, 18, 2) },
				render = function(p4)
					local sizeY = self.state.tween and p4.sizeY or v7

					if fFlagAppIaScrollAway and canvasTopPadding > 0 then
						sizeY += canvasTopPadding
					end

					return module.createElement(
						"Frame",
						{
							Size = UDim2.new(1, 0, 0, p4.sizeY),
							BackgroundTransparency = 1,
							LayoutOrder = 1
						},
						{
							spinner = v8 and Spinner({
								Position = UDim2.new(0, 0, 0, sizeY),
								ImageColor3 = color,
								offset = self.state.offset,
								activated = self.state.activated,
								timer = self.state.timer,
								tween = self.state.tween
							})
						}
					)
				end
			}),
			scrollingFrame = 0,
			renderStepped = 0,
			inputBegan = 0,
			inputEnded = 0,
			statusBarTapped = 0,
			bottomBarButtonPressed = 0
		}

		local createElement2 = module.createElement
		local fitScrollingFrame = FitChildren.FitScrollingFrame
		local v10 = {
			["Position"] = nil,
			["Position"] = nil,
			["Position"] = nil,
			["Position"] = nil,
			["Position"] = nil,
			["Position"] = nil,
			["Position"] = nil,
			["Position"] = nil,
			["Position"] = nil,
			["Position"] = nil,
			["Position"] = nil,
			Position = if fFlagExtendScrollingFramesBySafeInsets then position else nil,
			Size = size,
			CanvasPosition = self.props.canvasPosition,
			ScrollBarThickness = scrollBarThickness,
			ScrollBarImageColor3 = scrollBarImageColor,
			ScrollBarImageTransparency = scrollBarImageTransparency
		}

		local v12 = if defineFastFlag then self.props.Selectable else nil
		v10.Selectable = v12
		v10.BorderSizePixel = 0
		v10.BackgroundTransparency = 1
		v10.LayoutOrder = 2
		v10.ScrollingEnabled = self.props.ScrollingEnabled
		v10.ElasticBehavior = Enum.ElasticBehavior.Always
		v10.ScrollingDirection = Enum.ScrollingDirection.Y
		v10.fitFields = self.fitFieldCanvasSize

		local v13 = if fFlagLuaAppSduiSeeAllLayoutParamsFix then self.props.AutomaticCanvasSize else nil
		v10.AutomaticCanvasSize = v13

		v10[module.Ref] = self.setScrollingFrameRef
		v10[module.Change.CanvasPosition] = self.onCanvasPositionChanged
		v10[module.Change.CanvasSize] = self.onCanvasSizeChanged
		v10[module.Change.AbsoluteWindowSize] = self.props.onAbsoluteWindowSizeChangedCallback
		v10[module.Event.SelectionChanged] = self.props.onSelectionChanged
		local children2 = {
			Layout = module.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				[module.Change.AbsoluteContentSize] = self.props.onAbsoluteContentSizeChanged
			}),
			UIPadding = 0,
			Content = 0,
			Footer = 0,
			EndOfScroll = 0
		}
		local v14

		if
			fFlagAppIaScrollAway and canvasTopPadding > 0
			or fFlagLuaAppLayoutParamsInContext and canvasSidePadding > 0
			or fFlagExtendScrollingFramesBySafeInsets
		then
			local createElement4 = module.createElement

			local v17 = if fFlagAppIaScrollAway or fFlagExtendScrollingFramesBySafeInsets then UDim.new(
				0,
				canvasTopPadding + (fFlagExtendScrollingFramesBySafeInsets and self.props.shouldExtendIntoSafeArea.top and self.props.deviceSafePadding.top or 0)
			) else nil

			local v18 = if fFlagLuaAppLayoutParamsInContext or fFlagExtendScrollingFramesBySafeInsets then UDim.new(
				0,
				canvasSidePadding + (fFlagExtendScrollingFramesBySafeInsets and self.props.shouldExtendIntoSafeArea.left and self.props.deviceSafePadding.left or 0)
			) else nil

			local v19 = if fFlagLuaAppLayoutParamsInContext or fFlagExtendScrollingFramesBySafeInsets then UDim.new(
				0,
				canvasSidePadding + (fFlagExtendScrollingFramesBySafeInsets and self.props.shouldExtendIntoSafeArea.right and self.props.deviceSafePadding.right or 0)
			) else nil

			local v20 = if fFlagExtendScrollingFramesBySafeInsets and not createEndOfScrollElement then UDim.new(
				0,
				self.props.shouldExtendIntoSafeArea.bottom and self.props.deviceSafePadding.bottom or 0
			) else nil
			v14 = createElement4("UIPadding", {
				PaddingTop = v17,
				PaddingLeft = v18,
				PaddingRight = v19,
				PaddingBottom = v20
			})
		end

		children2.UIPadding = v14

		local createElement4 = module.createElement
		local v15 = useAutomaticSizeContentFrame and "Frame" or FitChildren.FitFrame
		local v16 = {
			["BackgroundTransparency"] = nil,
			["BackgroundTransparency"] = nil,
			["BackgroundTransparency"] = nil,
			["BackgroundTransparency"] = nil,
			["BackgroundTransparency"] = nil,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 1,
			[React.Tag] = self.props.contentTag
		}
		local v17 = if useAutomaticSizeContentFrame then UDim2.new(1, 0, 0, 0) else UDim2.new(1, 0, 1, 0)
		v16.Size = v17
		v16.fitFields = not useAutomaticSizeContentFrame and {
			Size = FitChildren.FitAxis.Height
		} or nil

		local v18 = if useAutomaticSizeContentFrame then Enum.AutomaticSize.Y else nil
		v16.AutomaticSize = v18
		v16[module.Ref] = self.setContentFrameRef
		v16[module.Change.AbsoluteSize] = function()
			spawn(self.updateIsScrollable)
		end

		children2.Content = createElement4(v15, v16, self.props[module.Children])
		children2.Footer = createFooter and module.createElement(FitChildren.FitFrame, {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			fitFields = { Size = FitChildren.FitAxis.Height },
			LayoutOrder = 2
		}, { FooterContent = createFooter() })

		local v19 = createEndOfScrollElement

		if v19 then
			local createElement5 = module.createElement

			local v22 = if fFlagExtendScrollingFramesBySafeInsets then self.props.bottomPadding + (self.props.shouldExtendIntoSafeArea.bottom and self.props.deviceSafePadding.bottom or 0) else self.props.bottomPadding
			local v21 = {
				bottomPadding = v22,
				backToTopCallback = self.scrollBack,
				pageContext = 0,
				LayoutOrder = 3
			}
			local v23 = if fFlagLuaAppSupportHomeBackToTop then self.props.parentAppPage else nil
			v21.pageContext = v23
			v19 = createElement5(module10, v21)
		end

		children2.EndOfScroll = v19
		children.scrollingFrame = createElement2(fitScrollingFrame, v10, children2)

		children.renderStepped = module.createElement(module3, {
			event = RunService.renderStepped,
			callback = self.renderSteppedCallback
		})

		children.inputBegan = module.createElement(module3, {
			event = UserInputService.InputBegan,
			callback = self.inputBeganCallback
		})

		children.inputEnded = module.createElement(module3, {
			event = UserInputService.InputEnded,
			callback = self.inputEndedCallback
		})

		children.statusBarTapped = not _G.__TESTEZ_RUNNING_TEST__
			and module.createElement(module3, {
				event = UserInputService.StatusBarTapped,
				callback = self.statusBarTapCallback
			})

		children.bottomBarButtonPressed = module.createElement(module3, {
			event = notificationService.RobloxEventReceived,
			callback = self.onNavigationEventReceived
		})
		return createElement("Frame", onAbsoluteSizeChangedCallbacksByAbsoluteSize, children)
	end

	return withStyle(function(p2)
		return renderRSF(
			backgroundColor3 or p2.Theme.BackgroundDefault.Color,
			backgroundTransparency or p2.Theme.BackgroundDefault.Transparency,
			p2.Theme.IconEmphasis.Color,
			scrollBarImageColor3 or p2.Theme.UIEmphasis.Color
		)
	end)
end

if not fFlagSignalsNavP3dRouteGated then
	extended = useSheetNavigation.connect(function(p2, p3)
		local v8 = if fFlagUseNavigationSelectors then selectors.selectCurrentLegacyRoute(p2) else p2.Navigation.history[#p2.Navigation.history]
		return { currentRoute = v8 }
	end)(extended)
end

local v7 = roactServices.connect({ NotificationService = appNotificationService })(extended)

return module.forwardRef(function(p2, p3)
	local v8 = Responsive.useLastInput() == Responsive.Input.Directional
	local v9

	if fFlagExtendScrollingFramesBySafeInsets then
		v9 = useSignalState(module6.GetDisplayStore().getDeviceSafePadding)
	end

	local createElement = module.createElement

	local join = Cryo.Dictionary.join

	if not fFlagExtendScrollingFramesBySafeInsets then
		v9 = nil
	end

	return createElement(v7, join(p2, {
		forwardRef = p3,
		isInputDirectional = v8,
		deviceSafePadding = v9
	}))
end)
