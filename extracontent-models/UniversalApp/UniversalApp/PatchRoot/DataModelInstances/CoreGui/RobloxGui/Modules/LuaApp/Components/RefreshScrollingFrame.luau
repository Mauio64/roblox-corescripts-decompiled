local Modules = game:GetService("CoreGui").RobloxGui.Modules
local UserInputService = game:GetService("UserInputService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CorePackages = game:GetService("CorePackages")
local FFlagUseNavigationSelectors = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUseNavigationSelectors
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")
local Roact = require(Modules.Common.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(Modules.Common.RoactRodux)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local AppNotificationService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppNotificationService
local ExternalEventConnection = require(Modules.Common.RoactUtilities.ExternalEventConnection)
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local AppNavBar = require(CorePackages.Workspace.Packages.AppNavBar)
local Display = require(CorePackages.Workspace.Packages.Display)
local Selectors = require(CorePackages.Workspace.Packages.NavigationRodux).Selectors
local FitChildren = require(Modules.LuaApp.FitChildren)
local RoactMotion = require(Modules.LuaApp.RoactMotion)
local LuaAppEvents = require(Modules.LuaApp.LuaAppEvents)
local EndOfScroll = require(Modules.LuaApp.Components.EndOfScroll)
local v24 = game:DefineFastFlag("SetRSFNotSelectable", false)
local FFlagSearchOmniAutocompletePage = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSearchOmniAutocompletePage
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local FFlagLuaAppLayoutParamsInContext = SharedFlags.FFlagLuaAppLayoutParamsInContext
local FFlagLuaAppSduiSeeAllLayoutParamsFix = SharedFlags.FFlagLuaAppSduiSeeAllLayoutParamsFix
local FFlagExtendScrollingFramesBySafeInsets = SharedFlags.FFlagExtendScrollingFramesBySafeInsets
local FFlagSignalsNavP3hMisc = SharedFlags.FFlagSignalsNavP3hMisc
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local v33 = if not FFlagSignalsNavP3hMisc then nil else require(CorePackages.Workspace.Packages.NavigationRodux).GetLegacyNavigationStore
local Cryo = require(CorePackages.Packages.Cryo)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local getIconSize = UIBlox.App.ImageSet.getIconSize
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local v40 = getIconSize(UIBlox.App.ImageSet.Enum.IconSize.Medium)

local function Spinner(p1) -- line: 99
	-- upvalues: Roact (copy), ImageSetLabel (copy), v40 (copy), Images (copy)
	local activated = p1.activated
	local offset = p1.offset
	local p1Position = p1.Position
	local timer = p1.timer
	local tween = p1.tween
	local n1 = 0
	local n2 = 1
	local n3 = 0

	if offset > 0 then
		return
	end

	local n4

	if activated then
		n1 = timer * 540
		n4 = 0
	elseif tween then
		n4 = 0
		n3 = 2 * timer
	elseif offset > -52 then
		n4 = -offset
		n1 = 9.6 * n4 - 240
		n3 = 1 - 0.04 * n4
	else
		n2 = 1
		n4 = 52
	end

	local p1ImageColor3 = p1.ImageColor3

	return Roact.createElement(ImageSetLabel, {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, v40 * n2, 0, v40 * n2),
		Position = p1Position + UDim2.new(0.5, 0, 0, n4 - v40 / 2),
		ImageTransparency = n3,
		Image = Images["icons/common/refresh"],
		ImageColor3 = p1ImageColor3,
		Rotation = n1,
		AnchorPoint = Vector2.new(0.5, 0.5)
	})
end

local v42 = Roact.Component:extend("RefreshScrollingFrame")

v42.defaultProps = {
	preloadDistance = 2000,
	createEndOfScrollElement = false,
	Selectable = not v24 and nil,
	canvasTopPadding = if not FFlagAppIaScrollAway then nil else 0,
	canvasSidePadding = if not FFlagLuaAppLayoutParamsInContext then nil else 0,
	bottomPadding = if not FFlagExtendScrollingFramesBySafeInsets then nil else 0,
	shouldExtendIntoSafeArea = if not FFlagExtendScrollingFramesBySafeInsets then nil else {
		left = false,
		top = false,
		right = false,
		bottom = false
	}
}

function v42.startTweenBack(p2) -- line: 162
	p2:setState({
		activated = false,
		tween = true,
		timer = 0,
		offset = 0
	})
end
function v42.startSpin(p3) -- line: 172
	p3:setState({
		activated = true,
		tween = false,
		timer = 0
	})
end
function v42.startTween(p4) -- line: 181
	p4:setState({
		activated = true,
		tween = true,
		timer = 0
	})
end
function v42.didMount(p5) -- line: 190
	p5._isMounted = true
	p5.updateIsScrollable()
end
function v42.willUnmount(p6) -- line: 196
	p6._isMounted = false

	if p6.luaAppReloadPageEventConnection ~= nil then
		p6.luaAppReloadPageEventConnection:disconnect()
		p6.luaAppReloadPageEventConnection = nil
	end
end
function v42.init(p7) -- line: 205
	-- upvalues: FitChildren (copy), Roact (copy), FFlagLuaAppLayoutParamsInContext (copy), TweenService (copy), GuiService (copy), UserGameSettings (copy), FFlagAppIaScrollAway (copy), AppNavBar (copy), HttpService (copy), LuaAppEvents (copy)
	p7._inputCount = 0
	p7._isMounted = false
	p7._isUserInteracting = false
	p7._isRefreshing = false
	p7._lastReloadEventTime = tick()
	p7.state = {
		activated = false,
		tween = false,
		timer = 0,
		offset = 0,
		isScrollable = false
	}
	p7.fitFieldCanvasSize = {
		CanvasSize = FitChildren.FitAxis.Height
	}

	local forwardRef = p7.props.forwardRef

	if type(forwardRef) == "table" then
		p7.scrollingFrameRef = forwardRef
	else
		p7.scrollingFrameRef = Roact.createRef()
	end

	function p7.setScrollingFrameRef(p8) -- line: 243
		-- upvalues: p7 (copy), forwardRef (copy)
		p7.scrollingFrameRef.current = p8

		if type(forwardRef) == "function" then
			forwardRef(p8)
		end
	end

	p7.contentFrameRef = Roact.createRef()

	if FFlagLuaAppLayoutParamsInContext then
		function p7.setContentFrameRef(p9) -- line: 252
			-- upvalues: p7 (copy)
			p7.contentFrameRef.current = p9

			if p7.props.contentFrameRefCallback then
				p7.props.contentFrameRefCallback(p9)
			end
		end
	end

	function p7.scrollBackWithFocus(p10) -- line: 260
		-- upvalues: TweenService (copy), GuiService (copy)
		local tweenInfo = TweenInfo.new(0.3)
		local tween = TweenService:Create(p10, tweenInfo, {
			CanvasPosition = Vector2.new(0, 0)
		})

		tween:Play()
		tween.Completed:Connect(function() -- line: 264
			-- upvalues: GuiService (copy), p10 (copy)
			GuiService:Select(p10)
		end)
	end
	function p7.scrollBack() -- line: 269
		-- upvalues: p7 (copy), UserGameSettings (copy)
		if p7.scrollingFrameRef.current then
			if UserGameSettings.ReducedMotion then
				p7.scrollingFrameRef.current.CanvasPosition = Vector2.new(0, 0)

				return
			end

			if p7.props.isInputDirectional then
				p7.scrollBackWithFocus(p7.scrollingFrameRef.current)

				return
			end

			p7.scrollingFrameRef.current:ScrollToTop()
		end
	end
	function p7.dispatchRefresh() -- line: 281
		-- upvalues: p7 (copy)
		local refresh = p7.props.refresh

		if p7._isMounted and p7.scrollingFrameRef.current then
			local CanvasPositionY = p7.scrollingFrameRef.current.CanvasPosition.Y

			if refresh and not p7._isRefreshing then
				p7._isRefreshing = true

				if CanvasPositionY < -52 then
					p7:startSpin()
				else
					p7:startTween()
				end

				refresh():andThen(function() -- line: 298
					-- upvalues: p7 (copy)
					p7._isRefreshing = false

					if p7._isMounted then
						p7:startTweenBack()
					end
				end, function() -- line: 303
					-- upvalues: p7 (copy)
					p7._isRefreshing = false

					if p7._isMounted then
						p7:startTweenBack()
					end
				end)
			end
		end
	end
	function p7.onCanvasPositionChanged(p11) -- line: 313
		-- upvalues: p7 (copy), FFlagAppIaScrollAway (copy), AppNavBar (copy)
		local refresh = p7.props.refresh
		local onCanvasPositionChangedCallback = p7.props.onCanvasPositionChangedCallback
		local CanvasPositionY = p11.CanvasPosition.Y

		if refresh and CanvasPositionY < 52 then
			p7:setState({
				offset = CanvasPositionY
			})
		end

		if FFlagAppIaScrollAway and AppNavBar.getScrollAwayEnabled() and CanvasPositionY <= 0 then
			AppNavBar.VisibilityControl.show()
		end

		if onCanvasPositionChangedCallback then
			onCanvasPositionChangedCallback(p11)
		end
	end
	function p7.renderSteppedCallback(p12) -- line: 339
		-- upvalues: p7 (copy)
		if p7.state.activated or p7.state.tween then
			local t1 = {
				timer = p7.state.timer + p12
			}

			if p7.state.tween and p7.state.timer > 0.5 then
				t1.tween = false
			end

			p7:setState(t1)
		end
	end
	function p7.inputBeganCallback(p13) -- line: 351
		-- upvalues: p7 (copy)
		if p13.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		p7._isUserInteracting = true
		p7._inputCount = p7._inputCount + 1
	end
	function p7.inputEndedCallback(p14) -- line: 361
		-- upvalues: p7 (copy)
		if p14.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		if p7._inputCount > 0 then
			p7._inputCount = p7._inputCount - 1
		end

		if p7._inputCount > 0 then
			return
		end

		p7._isUserInteracting = false

		if p7.state.offset < -52 and not p7.state.activated then
			p7.dispatchRefresh()
		end
	end
	function p7.statusBarTapCallback() -- line: 383
		-- upvalues: p7 (copy)
		p7.scrollBack()
	end
	function p7.onReloadPage() -- line: 387
		-- upvalues: p7 (copy)
		if p7._isMounted and p7.scrollingFrameRef.current then
			local CanvasPositionY = p7.scrollingFrameRef.current.CanvasPosition.Y
			local timestamp = tick()

			if CanvasPositionY ~= 0 then
				p7.scrollBack()

				if timestamp - p7._lastReloadEventTime < 0.5 then
					p7.dispatchRefresh()
				end
			else
				p7.dispatchRefresh()
			end

			p7._lastReloadEventTime = timestamp
		end
	end
	function p7.onNavigationEventReceived(p15) -- line: 407
		-- upvalues: p7 (copy), HttpService (copy)
		local parentAppPage = p7.props.parentAppPage
		local currentRoute = p7.props.currentRoute

		if p15.namespace == "Navigations" and (p15.detailType == "Reload" and parentAppPage == HttpService:JSONDecode(p15.detail).appName and #currentRoute == 1) then
			p7.onReloadPage()
		end
	end

	p7.luaAppReloadPageEventConnection = LuaAppEvents.ReloadPage:connect(function(p16) -- line: 420
		-- upvalues: p7 (copy)
		local parentAppPage = p7.props.parentAppPage
		local currentRoute = p7.props.currentRoute

		if p16 == parentAppPage and #currentRoute == 1 then
			p7.onReloadPage()
		end
	end)

	function p7.updateIsScrollable() -- line: 429
		-- upvalues: p7 (copy)
		if p7.scrollingFrameRef.current and (p7.contentFrameRef and p7.contentFrameRef.current) then
			local AbsoluteSizeY = p7.scrollingFrameRef.current.AbsoluteSize.Y
			local AbsoluteSizeY2 = p7.contentFrameRef.current.AbsoluteSize.Y
			local v118 = AbsoluteSizeY < AbsoluteSizeY2

			if AbsoluteSizeY >= 0 and AbsoluteSizeY2 >= 0 and v118 ~= p7.state.isScrollable then
				p7:setState({
					isScrollable = v118
				})
			end
		end
	end
	function p7.onCanvasSizeChanged(p17) -- line: 447
		-- upvalues: p7 (copy)
		if p7.props.onCanvasSizeChangedCallback ~= nil then
			p7.props.onCanvasSizeChangedCallback(p17)
		end
	end
end
function v42.render(p18) -- line: 454
	-- upvalues: FFlagExtendScrollingFramesBySafeInsets (copy), FFlagAppIaScrollAway (copy), FFlagLuaAppLayoutParamsInContext (copy), Roact (copy), RoactMotion (copy), Spinner (copy), FitChildren (copy), v24 (copy), FFlagLuaAppSduiSeeAllLayoutParamsFix (copy), FFlagSearchOmniAutocompletePage (copy), React (copy), EndOfScroll (copy), ExternalEventConnection (copy), RunService (copy), UserInputService (copy), withStyle (copy)
	local u65 = nil

	if FFlagExtendScrollingFramesBySafeInsets then
		u65 = p18.props.Position or UDim2.new(0, 0, 0, 0)

		if p18.props.shouldExtendIntoSafeArea.left then
			u65 += UDim2.fromOffset(-p18.props.deviceSafePadding.left, 0)
		end

		if p18.props.shouldExtendIntoSafeArea.top then
			u65 += UDim2.fromOffset(0, -p18.props.deviceSafePadding.top)
		end
	end

	local propsSize = p18.props.Size

	if FFlagExtendScrollingFramesBySafeInsets then
		if p18.props.shouldExtendIntoSafeArea.left then
			propsSize += UDim2.new(0, p18.props.deviceSafePadding.left, 0, 0)
		end

		if p18.props.shouldExtendIntoSafeArea.top then
			propsSize += UDim2.new(0, 0, 0, p18.props.deviceSafePadding.top)
		end

		if p18.props.shouldExtendIntoSafeArea.right then
			propsSize += UDim2.new(0, p18.props.deviceSafePadding.right, 0, 0)
		end

		if p18.props.shouldExtendIntoSafeArea.bottom then
			propsSize += UDim2.new(0, 0, 0, p18.props.deviceSafePadding.bottom)
		end
	end

	local propsBackgroundColor3 = p18.props.BackgroundColor3
	local propsBackgroundTransparency = p18.props.BackgroundTransparency
	local ScrollBarImageColor3 = p18.props.ScrollBarImageColor3
	local v70 = p18.props.ScrollBarThickness or 0
	local v71 = p18.props.ScrollBarImageTransparency or 0
	local v72 = if not FFlagAppIaScrollAway then nil else p18.props.canvasTopPadding
	local v73 = if not FFlagLuaAppLayoutParamsInContext then nil else p18.props.canvasSidePadding
	local u74 = if not FFlagExtendScrollingFramesBySafeInsets then p18.props.Position.Y.Offset else u65.Y.Offset
	local NotificationService = p18.props.NotificationService
	local createFooter = p18.props.createFooter
	local useAutomaticSizeContentFrame = p18.props.useAutomaticSizeContentFrame
	local activated = p18.state.activated
	local tween = p18.state.tween
	local offset = p18.state.offset
	local v81 = p18.state.isScrollable and p18.props.createEndOfScrollElement
	local v82 = activated or (tween or p18._isUserInteracting)

	if activated then
		if offset > 0 and offset < 52 then
			u74 = u74 - offset + 52
		elseif offset <= 0 then
			u74 += 52
		end
	end

	local function renderRSF(p19, p20, p21, p22) -- line: 509
		-- upvalues: Roact (copy), p18 (copy), RoactMotion (copy), u74 (ref), FFlagAppIaScrollAway (copy), v72 (copy), v82 (copy), Spinner (copy), FitChildren (copy), FFlagExtendScrollingFramesBySafeInsets (copy), u65 (ref), propsSize (ref), v70 (copy), v71 (copy), v24 (copy), FFlagLuaAppSduiSeeAllLayoutParamsFix (copy), FFlagSearchOmniAutocompletePage (copy), FFlagLuaAppLayoutParamsInContext (copy), v73 (copy), v81 (copy), useAutomaticSizeContentFrame (copy), React (copy), createFooter (copy), EndOfScroll (copy), ExternalEventConnection (copy), RunService (copy), UserInputService (copy), NotificationService (copy)
		return Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = p19,
			BackgroundTransparency = p20,
			[Roact.Change.AbsoluteSize] = p18.props.onAbsoluteSizeChangedCallback
		}, {
			layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				VerticalAlignment = Enum.VerticalAlignment.Top
			}),
			spinnerFrame = Roact.createElement(RoactMotion.SimpleMotion, {
				style = {
					sizeY = RoactMotion.spring(u74, 150, 18, 2)
				},
				render = function(p23) -- line: 526
					-- upvalues: p18 (copy), u74 (ref), FFlagAppIaScrollAway (copy), v72 (copy), Roact (copy), v82 (copy), Spinner (copy), p21 (copy)
					local v126 = p18.state.tween and p23.sizeY or u74

					if FFlagAppIaScrollAway and v72 > 0 then
						v126 += v72
					end

					return Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						LayoutOrder = 1,
						Size = UDim2.new(1, 0, 0, p23.sizeY)
					}, {
						spinner = v82 and Spinner({
							Position = UDim2.new(0, 0, 0, v126),
							ImageColor3 = p21,
							offset = p18.state.offset,
							activated = p18.state.activated,
							timer = p18.state.timer,
							tween = p18.state.tween
						})
					})
				end
			}),
			scrollingFrame = Roact.createElement(FitChildren.FitScrollingFrame, {
				Position = if not FFlagExtendScrollingFramesBySafeInsets then nil else u65,
				Size = propsSize,
				CanvasPosition = p18.props.canvasPosition,
				ScrollBarThickness = v70,
				ScrollBarImageColor3 = p22,
				ScrollBarImageTransparency = v71,
				Selectable = if not v24 then nil else p18.props.Selectable,
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				ScrollingEnabled = p18.props.ScrollingEnabled,
				ElasticBehavior = Enum.ElasticBehavior.Always,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				fitFields = p18.fitFieldCanvasSize,
				AutomaticCanvasSize = if not FFlagLuaAppSduiSeeAllLayoutParamsFix then nil else p18.props.AutomaticCanvasSize,
				[Roact.Ref] = p18.setScrollingFrameRef,
				[Roact.Change.CanvasPosition] = p18.onCanvasPositionChanged,
				[Roact.Change.CanvasSize] = p18.onCanvasSizeChanged,
				[Roact.Change.AbsoluteWindowSize] = p18.props.onAbsoluteWindowSizeChangedCallback,
				[Roact.Event.SelectionChanged] = p18.props.onSelectionChanged
			}, {
				Layout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					[Roact.Change.AbsoluteContentSize] = if not FFlagSearchOmniAutocompletePage then nil else p18.props.onAbsoluteContentSizeChanged
				}),
				UIPadding = if not (not not FFlagAppIaScrollAway and v72 > 0) and (not (not not FFlagLuaAppLayoutParamsInContext and v73 > 0) and not FFlagExtendScrollingFramesBySafeInsets) then nil else Roact.createElement("UIPadding", {
					PaddingTop = if not FFlagAppIaScrollAway and not FFlagExtendScrollingFramesBySafeInsets then nil else UDim.new(0, v72 + (FFlagExtendScrollingFramesBySafeInsets and (not not p18.props.shouldExtendIntoSafeArea.top and p18.props.deviceSafePadding.top) or 0)),
					PaddingLeft = if not FFlagLuaAppLayoutParamsInContext and not FFlagExtendScrollingFramesBySafeInsets then nil else UDim.new(0, v73 + (FFlagExtendScrollingFramesBySafeInsets and (not not p18.props.shouldExtendIntoSafeArea.left and p18.props.deviceSafePadding.left) or 0)),
					PaddingRight = if not FFlagLuaAppLayoutParamsInContext and not FFlagExtendScrollingFramesBySafeInsets then nil else UDim.new(0, v73 + (FFlagExtendScrollingFramesBySafeInsets and (not not p18.props.shouldExtendIntoSafeArea.right and p18.props.deviceSafePadding.right) or 0)),
					PaddingBottom = if not FFlagExtendScrollingFramesBySafeInsets or v81 then nil else UDim.new(0, p18.props.shouldExtendIntoSafeArea.bottom and p18.props.deviceSafePadding.bottom or 0)
				}),
				Content = Roact.createElement(if not useAutomaticSizeContentFrame then FitChildren.FitFrame else "Frame", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					LayoutOrder = 1,
					[React.Tag] = p18.props.contentTag,
					Size = if not useAutomaticSizeContentFrame then UDim2.new(1, 0, 1, 0) else UDim2.new(1, 0, 0, 0),
					fitFields = if not useAutomaticSizeContentFrame then {
						Size = FitChildren.FitAxis.Height
					} else nil,
					AutomaticSize = if not useAutomaticSizeContentFrame then nil else Enum.AutomaticSize.Y,
					[Roact.Ref] = p18.setContentFrameRef,
					[Roact.Change.AbsoluteSize] = function() -- line: 642
						-- upvalues: p18 (copy)
						spawn(p18.updateIsScrollable)
					end
				}, p18.props[Roact.Children]),
				Footer = createFooter and Roact.createElement(FitChildren.FitFrame, {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					LayoutOrder = 2,
					Size = UDim2.new(1, 0, 1, 0),
					fitFields = {
						Size = FitChildren.FitAxis.Height
					}
				}, {
					FooterContent = createFooter()
				}),
				EndOfScroll = v81 and Roact.createElement(EndOfScroll, {
					LayoutOrder = 3,
					bottomPadding = if not FFlagExtendScrollingFramesBySafeInsets then p18.props.bottomPadding else p18.props.bottomPadding + (p18.props.shouldExtendIntoSafeArea.bottom and p18.props.deviceSafePadding.bottom or 0),
					backToTopCallback = p18.scrollBack
				})
			}),
			renderStepped = Roact.createElement(ExternalEventConnection, {
				event = RunService.renderStepped,
				callback = p18.renderSteppedCallback
			}),
			inputBegan = Roact.createElement(ExternalEventConnection, {
				event = UserInputService.InputBegan,
				callback = p18.inputBeganCallback
			}),
			inputEnded = Roact.createElement(ExternalEventConnection, {
				event = UserInputService.InputEnded,
				callback = p18.inputEndedCallback
			}),
			statusBarTapped = not _G.__TESTEZ_RUNNING_TEST__ and Roact.createElement(ExternalEventConnection, {
				event = UserInputService.StatusBarTapped,
				callback = p18.statusBarTapCallback
			}),
			bottomBarButtonPressed = Roact.createElement(ExternalEventConnection, {
				event = NotificationService.RobloxEventReceived,
				callback = p18.onNavigationEventReceived
			})
		})
	end

	return withStyle(function(p24) -- line: 690
		-- upvalues: renderRSF (copy), propsBackgroundColor3 (copy), propsBackgroundTransparency (copy), ScrollBarImageColor3 (copy)
		return renderRSF(propsBackgroundColor3 or p24.Theme.BackgroundDefault.Color, propsBackgroundTransparency or p24.Theme.BackgroundDefault.Transparency, p24.Theme.IconEmphasis.Color, ScrollBarImageColor3 or p24.Theme.UIEmphasis.Color)
	end)
end

local v44

if FFlagSignalsNavP3hMisc then
	local v43 = v42

	function v44(p25) -- line: 702
		-- upvalues: v33 (copy), useSignalState (copy), Roact (copy), v43 (copy), Cryo (copy)
		local v85 = v33(false)
		local v86 = useSignalState(v85.getCurrentLegacyRoute)

		return Roact.createElement(v43, Cryo.Dictionary.union(p25, {
			currentRoute = v86
		}))
	end
else
	v44 = RoactRodux.connect(function(p26, _) -- line: 714
		-- upvalues: FFlagUseNavigationSelectors (copy), Selectors (copy)
		return {
			currentRoute = if not FFlagUseNavigationSelectors then p26.Navigation.history[#p26.Navigation.history] else Selectors.selectCurrentLegacyRoute(p26)
		}
	end)(v42)
end

local u45 = RoactServices.connect({
	NotificationService = AppNotificationService
})(v44)

return Roact.forwardRef(function(p28, p29) -- line: 727
	-- upvalues: Responsive (copy), FFlagExtendScrollingFramesBySafeInsets (copy), useSignalState (copy), Display (copy), Roact (copy), u45 (ref), Cryo (copy)
	local v91 = Responsive.useLastInput() == Responsive.Input.Directional
	local v92 = if not FFlagExtendScrollingFramesBySafeInsets then nil else useSignalState(Display.GetDisplayStore().getDeviceSafePadding)

	return Roact.createElement(u45, Cryo.Dictionary.join(p28, {
		forwardRef = p29,
		isInputDirectional = v91,
		deviceSafePadding = if not FFlagExtendScrollingFramesBySafeInsets then nil else v92
	}))
end)
