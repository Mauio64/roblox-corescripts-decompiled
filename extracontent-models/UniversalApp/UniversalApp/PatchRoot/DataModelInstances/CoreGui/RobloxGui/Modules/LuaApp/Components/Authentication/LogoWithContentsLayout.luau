local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Common = Modules.Common
local Roact = require(Common.Roact)
local RoactRodux = require(Common.RoactRodux)
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local useBreakpointYOrSmaller = Responsive.useBreakpointYOrSmaller
local useBreakpointXOrSmaller = Responsive.useBreakpointXOrSmaller
local FullscreenPageWithSafeArea = require(Modules.LuaApp.Components.FullscreenPageWithSafeArea)
local AuthCommon = require(CorePackages.Workspace.Packages.AuthCommon)
local BackgroundFill = AuthCommon.Components.BackgroundFill
local AuthBackgroundContainer = AuthCommon.Components.AuthBackgroundContainer
local AuthBackgroundGate = AuthCommon.Components.AuthBackgroundGate
local DEPRECATED_ImageSetButton = require(Modules.LuaApp.Components.DEPRECATED_ImageSetButton)
local FitChildren = require(Modules.LuaApp.FitChildren)
local NavigateBack = require(Modules.LuaApp.Thunks.NavigateBack)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v20 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local AppPage = require(Modules.LuaApp.AppPage)
local getIndexOfTopMostPage = require(Modules.LuaApp.getIndexOfTopMostPage)
local useFocusedTextBox = require(CorePackages.Workspace.Packages.FocusNavigationUtils).useFocusedTextBox
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local Alignment = require(Modules.LuaApp.Enum.Alignment)
local Cryo = require(CorePackages.Packages.Cryo)
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local getSafeAreaSize = require(CorePackages.Workspace.Packages.InputUi).getSafeAreaSize
local AuthAnalytics = require(CorePackages.Workspace.Packages.AuthAnalytics)
local EventStreamConstants = AuthAnalytics.EventStreamConstants
local authTimingUtil = AuthAnalytics.authTimingUtil
local authPageload = AuthAnalytics.Events.authPageload
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local SpringAnimatedItem = UIBlox.Utility.SpringAnimatedItem
local Foundation = require(CorePackages.Packages.Foundation)
local Selectors = require(CorePackages.Workspace.Packages.NavigationRodux).Selectors
local FFlagEnableLuaAccountSwitch = require(Modules.LuaApp.Flags.FFlagEnableLuaAccountSwitch)
local FFlagLuaEnableLandingPageTTIMeasurements = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaEnableLandingPageTTIMeasurements
local FFlagUseNavigationSelectors = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUseNavigationSelectors
local FFlagSignalsNavP3eAuth = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3eAuth
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local v43 = if not FFlagSignalsNavP3eAuth then nil else require(CorePackages.Workspace.Packages.NavigationRodux).GetLegacyNavigationStore
local v44 = game:DefineFastInt("LogoAndBodyYPositionOffsetPercentage", 85)
local v45 = Roact.PureComponent:extend("LogoWithContentsLayout")

v45.defaultProps = {
	topButtonEnabled = true,
	LuobuLogoEnabled = false,
	VNAgeBadgeEnabled = false,
	FooterElement = nil,
	FooterHeight = 0,
	ContentAlign = Alignment.Top
}

local v46 = v44 / 100
local u47 = not FFlagEnableLuaAccountSwitch and 0 or 16
local v48 = game:DefineFastFlag("EnableHistoryBasedTopButtonHidingV2", false)

local function renderTopButton(p1) -- line: 111
	-- upvalues: withStyle (copy), Roact (copy), DEPRECATED_ImageSetButton (copy), u47 (ref)
	local v54 = p1.layoutOrder or 0
	local showCloseIcon = p1.showCloseIcon
	local onActivated = p1.onActivated
	local p1ZIndex = p1.ZIndex
	local s1 = "LuaApp/icons/navigation/pushBack"

	if showCloseIcon then
		s1 = "LuaApp/icons/navigation/close"
	end

	return withStyle(function(p2) -- line: 122
		-- upvalues: Roact (copy), DEPRECATED_ImageSetButton (copy), v54 (copy), u47 (ref), s1 (ref), p1ZIndex (copy), onActivated (copy)
		return Roact.createElement(DEPRECATED_ImageSetButton, {
			LayoutOrder = v54,
			Size = UDim2.new(0, 27, 0, 27),
			Position = UDim2.new(0, u47, 0, 0),
			Image = s1,
			ImageColor3 = p2.Theme.TextEmphasis.Color,
			ImageTransparency = p2.Theme.TextEmphasis.Transparency,
			BackgroundTransparency = 1,
			ZIndex = p1ZIndex,
			[Roact.Event.Activated] = onActivated
		})
	end)
end

function v45.init(p3) -- line: 137
	-- upvalues: Roact (copy)
	p3.state = {
		onScreenKeyboardHeight = 0,
		childrenContainerPosition = Vector2.new(),
		childrenContainerSize = Vector2.new()
	}
	p3.isMounted = false
	p3.prevFocusedTextBox = nil

	local v60, v61 = Roact.createBinding(Vector2.new())

	p3.canvasPosition = v60
	p3.updateCanvasPosition = v61

	function p3.onScrollingFrameSizeChanged(p4) -- line: 148
		-- upvalues: p3 (copy)
		local onScreenKeyboardHeight = p3.state.onScreenKeyboardHeight
		local focusedTextBox = p3.props.focusedTextBox

		if focusedTextBox then
			onScreenKeyboardHeight = math.min(focusedTextBox.AbsolutePosition.Y + p4.CanvasPosition.Y - 20, onScreenKeyboardHeight)
		end

		p3.updateCanvasPosition(Vector2.new(0, onScreenKeyboardHeight))
	end
	function p3.onTopButtonActivated() -- line: 159
		-- upvalues: p3 (copy)
		local topButtonEnabled = p3.props.topButtonEnabled
		local navigateBack = p3.props.navigateBack
		local topButtonActivatedTracking = p3.props.topButtonActivatedTracking

		if topButtonActivatedTracking then
			topButtonActivatedTracking()
		end

		if topButtonEnabled then
			navigateBack()
		end
	end
end
function v45.didMount(p5) -- line: 174
	-- upvalues: UserInputService (copy)
	p5.isMounted = true
	p5.keyboardVisibleChanged = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):connect(function() -- line: 178
		-- upvalues: UserInputService (copy), p5 (copy)
		local OnScreenKeyboardVisible = UserInputService.OnScreenKeyboardVisible
		local v85 = OnScreenKeyboardVisible and UserInputService.OnScreenKeyboardSize.Y or 0
		local focusedTextBox = p5.props.focusedTextBox
		local prevFocusedTextBox = p5.prevFocusedTextBox
		local v88 = not OnScreenKeyboardVisible and (prevFocusedTextBox ~= nil and (focusedTextBox ~= nil and prevFocusedTextBox ~= focusedTextBox))
		local v89

		if OnScreenKeyboardVisible then
			v89 = true
		elseif v88 then
			p5._prevFocusedTextBox = focusedTextBox
			v89 = false
		else
			v89 = true
			v85 = 0
		end

		if v89 then
			p5:setState({
				onScreenKeyboardHeight = v85
			})
		end
	end)
end
function v45.didUpdate(p6, p7, _) -- line: 212
	if p7.focusedTextBox ~= p6.props.focusedTextBox then
		p6.prevFocusedTextBox = p7.focusedTextBox
	end
end
function v45.willUnmount(p9) -- line: 218
	p9.isMounted = false

	if p9.keyboardVisibleChanged then
		p9.keyboardVisibleChanged:disconnect()
		p9.keyboardVisibleChanged = nil
	end
end
function v45.render(p10) -- line: 227
	-- upvalues: withStyle (copy), Roact (copy), FFlagSignalsNavP3eAuth (copy), FFlagUseNavigationSelectors (copy), AppPage (copy), getIndexOfTopMostPage (copy), v48 (copy), getSafeAreaSize (copy), FormFactor (copy), v46 (copy), Alignment (copy), UserInputService (copy), FitChildren (copy), FFlagLuaEnableLandingPageTTIMeasurements (copy), authTimingUtil (copy), EventStreamConstants (copy), authPageload (copy), HttpService (copy), FullscreenPageWithSafeArea (copy), AuthBackgroundGate (copy), AuthBackgroundContainer (copy), BackgroundFill (copy), SpringAnimatedItem (copy), Foundation (copy), renderTopButton (copy)
	return withStyle(function(_) -- line: 228
		-- upvalues: p10 (copy), Roact (copy), FFlagSignalsNavP3eAuth (copy), FFlagUseNavigationSelectors (copy), AppPage (copy), getIndexOfTopMostPage (copy), v48 (copy), getSafeAreaSize (copy), FormFactor (copy), v46 (copy), Alignment (copy), UserInputService (copy), FitChildren (copy), FFlagLuaEnableLandingPageTTIMeasurements (copy), authTimingUtil (copy), EventStreamConstants (copy), authPageload (copy), HttpService (copy), FullscreenPageWithSafeArea (copy), AuthBackgroundGate (copy), AuthBackgroundContainer (copy), BackgroundFill (copy), SpringAnimatedItem (copy), Foundation (copy), renderTopButton (copy)
		local v91 = p10.props[Roact.Children]
		local ContentAlign = p10.props.ContentAlign
		local statusBarHeight = p10.props.statusBarHeight
		local screenSize = p10.props.screenSize
		local globalGuiInset = p10.props.globalGuiInset
		local v96 = if not FFlagSignalsNavP3eAuth then if not FFlagUseNavigationSelectors then p10.props.navigation.history else p10.props.history else p10.props.history
		local v97 = v96[#v96]
		local name = v97[#v97].name
		local Landing = AppPage.Landing
		local v100 = #v96[#v96]
		local v101 = v100 - (getIndexOfTopMostPage(Landing, v96) or 0) <= 1
		local v102 = if not v48 then name ~= Landing else v100 > 1
		local LuobuLogoEnabled = p10.props.LuobuLogoEnabled
		local VNAgeBadgeEnabled = p10.props.VNAgeBadgeEnabled
		local v105 = getSafeAreaSize(screenSize, globalGuiInset).Y.Offset - statusBarHeight
		local n1, n2

		if LuobuLogoEnabled or VNAgeBadgeEnabled then
			if p10.props.formFactor == FormFactor.COMPACT then
				n1 = 0.3
				n2 = 0.35
			else
				n1 = 0.3
				n2 = 0.4
			end
		elseif p10.props.formFactor == FormFactor.COMPACT then
			n1 = 0.15
			n2 = 0.3
		else
			n1 = 0.25
			n2 = 0.45
		end

		local s2, n3

		if LuobuLogoEnabled then
			s2 = "rbxasset://textures/ui/LuaApp/graphic/Auth/logo_white_luobu.png"
			n3 = 4.0546875
		else
			s2 = "rbxasset://textures/ui/LuaApp/graphic/Auth/logo_white_1x.png"
			n3 = 5.409090909090909
		end

		local v110 = v105 * n1
		local v111 = v105 * n2

		if p10.props.isShortScreen and not p10.props.isCompactScreen then
			v110 *= v46
			v111 *= v46
		end

		local v112 = v105 * 0.05
		local uDim2 = UDim2.new(1, 0, n2, p10.state.childrenContainerSize.Y)
		local t1 = {
			[Alignment.Top] = {
				Position = UDim2.new(0.5, 0, 0, 0),
				AnchorPoint = Vector2.new(0.5, 0)
			},
			[Alignment.Bottom] = {
				Position = UDim2.new(0.5, 0, 1, 0),
				AnchorPoint = Vector2.new(0.5, 1)
			}
		}

		UDim2.new(0, p10.state.childrenContainerPosition.X + p10.state.childrenContainerSize.X / 2, 0, p10.state.childrenContainerPosition.Y + p10.state.childrenContainerSize.Y / 2)

		local OnScreenKeyboardAnimationDuration = UserInputService.OnScreenKeyboardAnimationDuration
		local t2 = {
			dampingRatio = 1,
			frequency = 1 / math.max(OnScreenKeyboardAnimationDuration, 0.1)
		}
		local isDualLayout = p10.props.isDualLayout
		local xOffset = p10.props.tokens.LuaApps.LoginView.xOffset
		local FooterElement = p10.props.FooterElement
		local FooterHeight = p10.props.FooterHeight
		local isCompactScreen = p10.props.isCompactScreen
		local v122 = not isCompactScreen and 40 or 15
		local v123 = (not FooterElement or not isCompactScreen) and 0 or FooterHeight
		local t3 = {
			VNAgeBadge = VNAgeBadgeEnabled and Roact.createElement("ImageLabel", {
				Position = UDim2.new(0.05, 0, 0, v112),
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 0),
				Size = UDim2.new(0.7, 0, 0.7, 0),
				Image = "rbxasset://textures/ui/LuaApp/graphic/Auth/vn_agebadge.png",
				ZIndex = 1,
				[Roact.Children] = {
					UISizeConstraint = Roact.createElement("UISizeConstraint", {
						MaxSize = Vector2.new(460, 87.78625954198473)
					}),
					UIAspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
						AspectRatio = 5.24,
						AspectType = Enum.AspectType.FitWithinMaxSize
					})
				}
			}),
			Logo = Roact.createElement("ImageLabel", {
				Position = UDim2.new(0.5, 0, 0, v110),
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.new(0.7, 0, 0.7, 0),
				Image = s2,
				ZIndex = 1,
				[Roact.Children] = {
					UISizeConstraint = Roact.createElement("UISizeConstraint", {
						MaxSize = Vector2.new(460, 460 / n3)
					}),
					UIAspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
						AspectRatio = n3,
						AspectType = Enum.AspectType.FitWithinMaxSize
					})
				}
			}),
			AlignmentContainer = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				ZIndex = 2,
				Position = if not isDualLayout then UDim2.new(0.5, 0, 0, v111) else UDim2.new(0, xOffset, 0, v111),
				Size = if not isDualLayout then UDim2.new(1, 0, 1, -v111 - v123) else UDim2.new(1, -(2 * xOffset), 1, -v111 - v123),
				AnchorPoint = if not isDualLayout then Vector2.new(0.5, 0) else Vector2.new(0, 0)
			}, {
				Content = Roact.createElement(FitChildren.FitFrame, {
					Position = t1[ContentAlign].Position,
					Size = UDim2.new(1, 0, 0, 0),
					fitAxis = FitChildren.FitAxis.Height,
					AnchorPoint = t1[ContentAlign].AnchorPoint,
					BackgroundTransparency = 1,
					[Roact.Change.AbsoluteSize] = function(p12) -- line: 394
						-- upvalues: p10 (copy)
						spawn(function() -- line: 395
							-- upvalues: p10 (copy), p12 (copy)
							if not p10.isMounted then
								return
							end

							p10:setState({
								childrenContainerSize = p12.AbsoluteSize
							})
						end)
					end,
					[Roact.Change.AbsolutePosition] = function(p13) -- line: 404
						-- upvalues: p10 (copy)
						spawn(function() -- line: 405
							-- upvalues: p10 (copy), p13 (copy)
							if not p10.isMounted then
								return
							end

							p10:setState({
								childrenContainerPosition = p13.AbsolutePosition
							})
						end)
					end,
					[Roact.Children] = v91
				})
			})
		}

		if FFlagLuaEnableLandingPageTTIMeasurements and name == AppPage.Landing then
			local v125 = authTimingUtil.landingPageLoadFinish()

			if v125 then
				local t4 = {
					variant = EventStreamConstants.Context.LandingScreen,
					timing = v125
				}

				authPageload(EventStreamConstants.Context.LandingPageRender, HttpService:JSONEncode(t4))
			end
		end

		return Roact.createElement(FullscreenPageWithSafeArea, {
			includeStatusBar = true,
			buttonRef = p10.props.buttonRef,
			renderFullscreenBackground = function(_) -- line: 432
				-- upvalues: Roact (copy), AuthBackgroundGate (copy), AuthBackgroundContainer (copy), BackgroundFill (copy)
				return Roact.createElement(AuthBackgroundGate, {
					renderTreatment = function() -- line: 434
						-- upvalues: Roact (copy), AuthBackgroundContainer (copy)
						return Roact.createElement(AuthBackgroundContainer, {})
					end,
					renderLegacy = function() -- line: 437
						-- upvalues: Roact (copy), BackgroundFill (copy)
						return Roact.createElement(BackgroundFill, {
							Image = "rbxasset://textures/ui/LuaApp/graphic/Auth/GridBackground.jpg",
							AspectRatio = 1
						})
					end
				})
			end
		}, {
			ReverseVignette = nil,
			AuthScrollingFrame = Roact.createElement(SpringAnimatedItem.AnimatedScrollingFrame, {
				regularProps = {
					Selectable = false,
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					[Roact.Children] = t3,
					CanvasSize = uDim2,
					CanvasPosition = p10.canvasPosition,
					ScrollingDirection = Enum.ScrollingDirection.Y,
					ScrollBarThickness = 0,
					ZIndex = 2,
					[Roact.Change.AbsoluteSize] = p10.onScrollingFrameSizeChanged
				},
				animatedValues = {
					onScreenKeyboardHeight = p10.state.onScreenKeyboardHeight
				},
				mapValuesToProps = function(p15) -- line: 477
					return {
						Size = UDim2.new(1, 0, 1, -p15.onScreenKeyboardHeight)
					}
				end,
				springOptions = t2
			}),
			Footer = FooterElement and Roact.createElement(Foundation.View, {
				ZIndex = 3,
				tag = "col align-x-center",
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Position = UDim2.new(0.5, 0, 1, -v122),
				AnchorPoint = Vector2.new(0.5, 1)
			}, {
				Content = FooterElement
			}),
			TopButton = v102 and Roact.createElement(renderTopButton, {
				ZIndex = 3,
				showCloseIcon = v101,
				onActivated = p10.onTopButtonActivated
			}) or nil
		})
	end)
end

local v50 = RoactRodux.connect(function(p16, _) -- line: 503
	-- upvalues: FFlagSignalsNavP3eAuth (copy), FFlagUseNavigationSelectors (copy), Selectors (copy)
	return {
		formFactor = p16.FormFactor,
		statusBarHeight = p16.TopBar.statusBarHeight,
		globalGuiInset = p16.GlobalGuiInset,
		screenSize = p16.ScreenSize,
		navigation = if not FFlagSignalsNavP3eAuth then if not FFlagUseNavigationSelectors then p16.Navigation else nil else nil,
		history = if not FFlagSignalsNavP3eAuth then if not FFlagUseNavigationSelectors then nil else Selectors.selectLegacyHistory(p16) else nil
	}
end, function(p18) -- line: 516
	-- upvalues: FFlagSignalsNavP3Dispatch (copy), v20 (copy), NavigateBack (copy)
	return {
		navigateBack = function() -- line: 518
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v20 (copy), p18 (copy), NavigateBack (copy)
			if FFlagSignalsNavP3Dispatch then
				return v20.back()
			end

			return p18(NavigateBack())
		end
	}
end)(v45)

if FFlagSignalsNavP3eAuth then
	local v51 = v50

	function v50(p19) -- line: 530
		-- upvalues: v43 (copy), useSignalState (copy), Roact (copy), v51 (copy), Cryo (copy)
		local v72 = v43(false)
		local v73 = useSignalState(v72.getHistory)

		return Roact.createElement(v51, Cryo.Dictionary.union(p19, {
			history = v73
		}))
	end
end

local v52 = v50

return function(p20) -- line: 544
	-- upvalues: useDesignTokens (copy), useFocusedTextBox (copy), Roact (copy), v52 (copy), Cryo (copy), useBreakpointYOrSmaller (copy), Responsive (copy), useBreakpointXOrSmaller (copy)
	local v75 = useDesignTokens()
	local v76 = useFocusedTextBox()

	return Roact.createElement(v52, Cryo.Dictionary.join({
		tokens = v75,
		isShortScreen = useBreakpointYOrSmaller(Responsive.Keys.Medium),
		isCompactScreen = useBreakpointXOrSmaller(Responsive.Keys.Medium),
		focusedTextBox = v76
	}, p20))
end
