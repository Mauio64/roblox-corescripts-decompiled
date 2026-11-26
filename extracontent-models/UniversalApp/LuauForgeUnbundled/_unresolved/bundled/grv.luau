local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/ego")
local useSheetNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/FoundationFork/Sheet/useSheetNavigation")

local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")
local useBreakpointYOrSmaller = Responsive.useBreakpointYOrSmaller
local useBreakpointXOrSmaller = Responsive.useBreakpointXOrSmaller

local module4 = require("@luauforge/bundled/ect")
local AuthCommon = require("@game/CorePackages/Workspace/Packages/AuthCommon")
local authBackgroundContainer = AuthCommon.Components.AuthBackgroundContainer
local module6 = require("@luauforge/bundled/egM")
local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")
local RobloxAppToastsRodux = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppToastsRodux/RobloxAppToastsRodux")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/dFz").NavigationCommands else nil

local module9 = require("@luauforge/bundled/dFu")
local module10 = require("@luauforge/bundled/grw")
local module11 = require("@luauforge/bundled/grx")
local useFocusedTextBox = require("@luauforge/bundled/ehL").useFocusedTextBox

local formFactor = require("@luauforge/bundled/dGN").Enums.FormFactor
local alignment = AuthCommon.Enums.Alignment
local Cryo = require(CorePackages.Packages.Cryo)
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local getSafeAreaSize = require("@luauforge/bundled/fCf").getSafeAreaSize
local module12 = require("@luauforge/bundled/fzT")
local eventStreamConstants = module12.EventStreamConstants
local authTimingUtil = module12.authTimingUtil
local authPageload = module12.Events.authPageload

local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle

local springAnimatedItem = UIBlox.Utility.SpringAnimatedItem

local Foundation = require(CorePackages.Packages.Foundation)
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Selectors

local module13 = require("@luauforge/bundled/ghR")
local module14 = require("@luauforge/bundled/gry")

local fFlagLuaEnableLandingPageTTIMeasurements = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaEnableLandingPageTTIMeasurements
local fFlagUseNavigationSelectors = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseNavigationSelectors
local fFlagSignalsNavP3eAuth = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3eAuth
local React = require(CorePackages.Packages.React)

local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local getLegacyNavigationStore = if fFlagSignalsNavP3eAuth then require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore else nil

local defineFastInt = game:DefineFastInt("LogoAndBodyYPositionOffsetPercentage", 85)

local extended = module.PureComponent:extend("LogoWithContentsLayout")
extended.defaultProps = {
	ContentAlign = alignment.Top,
	topButtonEnabled = true,
	LuobuLogoEnabled = false,
	VNAgeBadgeEnabled = false,
	FooterElement = nil,
	FooterHeight = 0
}

local v5 = defineFastInt / 100
local v6 = module13 and 16 or 0
local defineFastFlag = game:DefineFastFlag("EnableHistoryBasedTopButtonHidingV2", false)

local function renderTopButton(data)
	local layoutOrder = data.layoutOrder or 0
	local showCloseIcon = data.showCloseIcon
	local onActivated = data.onActivated
	local zIndex = data.ZIndex
	local v7 = showCloseIcon and "LuaApp/icons/navigation/close" or "LuaApp/icons/navigation/pushBack"
	return withStyle(function(p2)
		return module.createElement(module6, {
			LayoutOrder = layoutOrder,
			Size = UDim2.new(0, 27, 0, 27),
			Position = UDim2.new(0, v6, 0, 0),
			Image = v7,
			ImageColor3 = p2.Theme.TextEmphasis.Color,
			ImageTransparency = p2.Theme.TextEmphasis.Transparency,
			BackgroundTransparency = 1,
			ZIndex = zIndex,
			[module.Event.Activated] = onActivated
		})
	end)
end

function extended:init()
	self.state = {
		onScreenKeyboardHeight = 0,
		childrenContainerPosition = Vector2.new(),
		childrenContainerSize = Vector2.new()
	}

	self.isMounted = false
	self.prevFocusedTextBox = nil
	self.contentsContainerRef = module.createRef()

	local binding, v7 = module.createBinding(Vector2.new())
	self.canvasPosition = binding
	self.updateCanvasPosition = v7
	function self.onScrollingFrameSizeChanged(p2)
		local onScreenKeyboardHeight = self.state.onScreenKeyboardHeight
		local focusedTextBox = self.props.focusedTextBox

		if focusedTextBox then
			onScreenKeyboardHeight = math.min(
				focusedTextBox.AbsolutePosition.Y + p2.CanvasPosition.Y - 20,
				onScreenKeyboardHeight
			)
		end

		self.updateCanvasPosition(Vector2.new(0, onScreenKeyboardHeight))
	end

	function self.onTopButtonActivated()
		local topButtonEnabled = self.props.topButtonEnabled
		local navigateBack = self.props.navigateBack
		local topButtonActivatedTracking = self.props.topButtonActivatedTracking

		if topButtonActivatedTracking then
			topButtonActivatedTracking()
		end

		if topButtonEnabled then
			navigateBack()
		end
	end
end

function extended:didMount()
	self.isMounted = true

	local value = self.contentsContainerRef:getValue()

	if self.props.centerLogoAndContents and value and value.AbsoluteSize.Y > 0 then
		self:setState({
			childrenContainerPosition = value.AbsolutePosition,
			childrenContainerSize = value.AbsoluteSize
		})
	end

	self.keyboardVisibleChanged = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):connect(function()
		local onScreenKeyboardVisible = UserInputService.OnScreenKeyboardVisible
		local v7 = onScreenKeyboardVisible and UserInputService.OnScreenKeyboardSize.Y or 0

		local focusedTextBox = self.props.focusedTextBox
		local prevFocusedTextBox = self.prevFocusedTextBox
		local v8 = not onScreenKeyboardVisible

		if v8 then
			if prevFocusedTextBox == nil or focusedTextBox == nil then
				v8 = false
			else
				v8 = prevFocusedTextBox ~= focusedTextBox
			end
		end

		local flag

		if onScreenKeyboardVisible then
			flag = true
		elseif v8 then
			self._prevFocusedTextBox = focusedTextBox
			flag = false
		else
			flag = true
			v7 = 0
		end

		if flag then
			self:setState({ onScreenKeyboardHeight = v7 })
		end
	end)
end

function extended:didUpdate(p3, p4)
	if p3.focusedTextBox ~= self.props.focusedTextBox then
		self.prevFocusedTextBox = p3.focusedTextBox
	end
end

function extended:willUnmount()
	self.isMounted = false

	if self.keyboardVisibleChanged then
		self.keyboardVisibleChanged:disconnect()
		self.keyboardVisibleChanged = nil
	end
end

function extended.render(object)
	return withStyle(function(p2)
		local v7 = object.props[module.Children]
		local v8 = if object.props.centerLogoAndContents then alignment.Top else object.props.ContentAlign

		local statusBarHeight = object.props.statusBarHeight
		local screenSize = object.props.screenSize
		local globalGuiInset = object.props.globalGuiInset
		local history

		if fFlagSignalsNavP3eAuth then
			history = object.props.history
		elseif fFlagUseNavigationSelectors then
			history = object.props.history
		else
			history = object.props.navigation.history
		end

		local v9 = history[#history]
		local name = v9[#v9].name

		local landing = module9.Landing

		local count = #history[#history]
		local v10 = module10(landing, history) or 0
		local v11 = count - v10 <= 1
		local v12 = if defineFastFlag then count > 1 else name ~= landing

		if module11(object.props.appPage, v10) then
			v12 = false
		end

		local luobuLogoEnabled = object.props.LuobuLogoEnabled
		local v13 = object.props.VNAgeBadgeEnabled

		local safeAreaSize = getSafeAreaSize(screenSize, globalGuiInset)
		local v14 = safeAreaSize.Y.Offset - statusBarHeight
		local v15, v16

		if luobuLogoEnabled or v13 then
			if object.props.formFactor == formFactor.COMPACT then
				v15 = 0.3
				v16 = 0.35
			else
				v15 = 0.3
				v16 = 0.4
			end
		elseif object.props.formFactor == formFactor.COMPACT then
			v15 = 0.15
			v16 = 0.3
		else
			v15 = 0.25
			v16 = 0.45
		end

		local logoPositionYScale = object.props.logoPositionYScale or v15
		local bodyPositionYScale = object.props.bodyPositionYScale or v16
		local v17, v18

		if luobuLogoEnabled then
			v17 = 4.0546875
			v18 = "rbxasset://textures/ui/LuaApp/graphic/Auth/logo_white_luobu.png"
		else
			v17 = 119 / 22
			v18 = "rbxasset://textures/ui/LuaApp/graphic/Auth/logo_white_1x.png"
		end

		local logoMaxWidth = object.props.logoMaxWidth or 460

		local footerElement = object.props.FooterElement
		local footerHeight = object.props.FooterHeight
		local isCompactScreen = object.props.isCompactScreen
		local v19 = isCompactScreen and 15 or 40
		local v20 = v14 * logoPositionYScale
		local v21 = v14 * bodyPositionYScale

		if object.props.isShortScreen and not object.props.isCompactScreen then
			v20 *= v5
			v21 *= v5
		end

		local vector2 = Vector2.new(0.5, 0.5)
		local minLogoBodyGap = object.props.minLogoBodyGap
		local v22 = math.min(math.min(safeAreaSize.X.Offset * 0.7, logoMaxWidth) / v17, v14 * 0.7)

		if object.props.centerLogoAndContents and object.state.childrenContainerSize.Y > 0 then
			local v23 = minLogoBodyGap or 0
			local v24 = math.max(
				0,
				(math.max(0, v14 - (not footerElement and 0 or footerHeight + v19)) - (v22 + v23 + object.state.childrenContainerSize.Y)) / 2
			)

			vector2 = Vector2.new(0.5, 1)
			v20 = v24 + v22
			v21 = v20 + v23
		elseif minLogoBodyGap then
			vector2 = Vector2.new(0.5, 1)
			v20 = math.min(v20 + v22 / 2, v21 - minLogoBodyGap)
		end

		local v23 = v14 * 0.05

		local udim = UDim2.new(1, 0, bodyPositionYScale, object.state.childrenContainerSize.Y)

		local v24 = {
			[alignment.Top] = {
				Position = UDim2.new(0.5, 0, 0, 0),
				AnchorPoint = Vector2.new(0.5, 0)
			},
			[alignment.Bottom] = {
				Position = UDim2.new(0.5, 0, 1, 0),
				AnchorPoint = Vector2.new(0.5, 1)
			}
		}

		UDim2.new(
			0,
			object.state.childrenContainerPosition.X + object.state.childrenContainerSize.X / 2,
			0,
			object.state.childrenContainerPosition.Y + object.state.childrenContainerSize.Y / 2
		)

		local v25 = {
			dampingRatio = 1,
			frequency = 1 / math.max(UserInputService.OnScreenKeyboardAnimationDuration, 0.1)
		}

		local isDualLayout = object.props.isDualLayout
		local xOffset = object.props.tokens.LuaApps.LoginView.xOffset
		local v26 = not (footerElement and isCompactScreen) and 0 or footerHeight

		if v13 then
			v13 = module.createElement("ImageLabel", {
				Position = UDim2.new(0.05, 0, 0, v23),
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 0),
				Size = UDim2.new(0.7, 0, 0.7, 0),
				Image = "rbxasset://textures/ui/LuaApp/graphic/Auth/vn_agebadge.png",
				ZIndex = 1,
				[module.Children] = {
					UISizeConstraint = module.createElement("UISizeConstraint", {
						MaxSize = Vector2.new(460, 11500 / 131)
					}),
					UIAspectRatioConstraint = module.createElement("UIAspectRatioConstraint", {
						AspectRatio = 5.24,
						AspectType = Enum.AspectType.FitWithinMaxSize
					})
				}
			})
		end

		local children = {
			VNAgeBadge = v13,
			Logo = module.createElement("ImageLabel", {
				Position = UDim2.new(0.5, 0, 0, v20),
				BackgroundTransparency = 1,
				AnchorPoint = vector2,
				Size = UDim2.new(0.7, 0, 0.7, 0),
				Image = v18,
				ZIndex = 1,
				[module.Children] = {
					UISizeConstraint = module.createElement("UISizeConstraint", {
						MaxSize = Vector2.new(logoMaxWidth, logoMaxWidth / v17)
					}),
					UIAspectRatioConstraint = module.createElement("UIAspectRatioConstraint", {
						AspectRatio = v17,
						AspectType = Enum.AspectType.FitWithinMaxSize
					})
				}
			}),
			AlignmentContainer = 0
		}

		local createElement2 = module.createElement

		local v30 = if isDualLayout then UDim2.new(0, xOffset, 0, v21) else UDim2.new(0.5, 0, 0, v21)

		local v31 = if isDualLayout then UDim2.new(1, -(2 * xOffset), 1, -v21 - v26) else UDim2.new(1, 0, 1, -v21 - v26)
		local v32 = if isDualLayout then Vector2.new(0, 0) else Vector2.new(0.5, 0)
		children.AlignmentContainer = createElement2("Frame", {
			BackgroundTransparency = 1,
			Position = v30,
			Size = v31,
			AnchorPoint = v32,
			ZIndex = 2
		}, {
			Content = module.createElement(FitChildren.FitFrame, {
				Position = v24[v8].Position,
				Size = UDim2.new(1, 0, 0, 0),
				fitAxis = FitChildren.FitAxis.Height,
				AnchorPoint = v24[v8].AnchorPoint,
				BackgroundTransparency = 1,
				[module.Ref] = object.contentsContainerRef,
				[module.Change.AbsoluteSize] = function(p3)
					spawn(function()
						if not object.isMounted then
							return
						end

						object:setState({ childrenContainerSize = p3.AbsoluteSize })
					end)
				end,
				[module.Change.AbsolutePosition] = function(p3)
					spawn(function()
						if not object.isMounted then
							return
						end

						object:setState({
							childrenContainerPosition = p3.AbsolutePosition
						})
					end)
				end,
				[module.Children] = v7
			})
		})

		local v35 = fFlagLuaEnableLandingPageTTIMeasurements
			and name == module9.Landing
			and authTimingUtil.landingPageLoadFinish()

		if v35 then
			local v36 = {
				variant = eventStreamConstants.Context.LandingScreen,
				timing = v35
			}

			authPageload(eventStreamConstants.Context.LandingPageRender, HttpService:JSONEncode(v36))
		end

		return module.createElement(module4, {
			includeStatusBar = true,
			buttonRef = object.props.buttonRef,
			renderFullscreenBackground = function(p3)
				local createElement5 = module.createElement
				local v40 = if object.props.mobileBackgroundFade then object.props.foundationTokens.Color.Surface.Surface_0.Color3 else nil
				return createElement5(authBackgroundContainer, { mobileFadeColor = v40 })
			end
		}, {
			ReverseVignette = nil,
			AuthScrollingFrame = module.createElement(springAnimatedItem.AnimatedScrollingFrame, {
				regularProps = {
					Selectable = false,
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					[module.Children] = children,
					CanvasSize = udim,
					CanvasPosition = object.canvasPosition,
					ScrollingDirection = Enum.ScrollingDirection.Y,
					ScrollBarThickness = 0,
					ZIndex = 2,
					[module.Change.AbsoluteSize] = object.onScrollingFrameSizeChanged
				},
				animatedValues = {
					onScreenKeyboardHeight = object.state.onScreenKeyboardHeight
				},
				mapValuesToProps = function(p3)
					return {
						Size = UDim2.new(1, 0, 1, -p3.onScreenKeyboardHeight)
					}
				end,
				springOptions = v25
			}),
			Footer = footerElement and module.createElement(Foundation.View, {
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Position = UDim2.new(0.5, 0, 1, -v19),
				AnchorPoint = Vector2.new(0.5, 1),
				ZIndex = 3,
				tag = "col align-x-center"
			}, { Content = footerElement }),
			TopButton = v12 and module.createElement(renderTopButton, {
				showCloseIcon = v11,
				onActivated = object.onTopButtonActivated,
				ZIndex = 3
			}) or nil
		})
	end)
end

local v7 = useSheetNavigation.connect(function(data, p2)
	local v8 = {
		formFactor = data.FormFactor,
		statusBarHeight = data.TopBar.statusBarHeight,
		globalGuiInset = data.GlobalGuiInset,
		screenSize = data.ScreenSize,
		navigation = 0,
		history = 0
	}

	local v9 = if not (fFlagSignalsNavP3eAuth or fFlagUseNavigationSelectors) then data.Navigation else nil
	v8.navigation = v9

	local v10 = if not (fFlagSignalsNavP3eAuth or not fFlagUseNavigationSelectors) then selectors.selectLegacyHistory(data) else nil
	v8.history = v10
	return v8
end, function(callback)
	return {
		navigateBack = function()
			if fFlagSignalsNavP3Dispatch then
				return navigationCommands.back()
			end

			return callback(RobloxAppToastsRodux())
		end
	}
end)(extended)
local v8

if fFlagSignalsNavP3eAuth then
	local function LogoWithContentsLayoutWithSignals(p2)
		local v9 = useSignalState(getLegacyNavigationStore(false).getHistory)
		return module.createElement(v7, Cryo.Dictionary.union(p2, { history = v9 }))
	end

	v8 = React.memo(LogoWithContentsLayoutWithSignals)
else
	v8 = v7
end

return function(p2)
	local v9 = useDesignTokens()
	local v10 = if module14 then Foundation.Hooks.useTokens() else nil

	local v11 = useFocusedTextBox()

	return module.createElement(v8, Cryo.Dictionary.join({
		tokens = v9,
		foundationTokens = v10,
		isShortScreen = useBreakpointYOrSmaller(Responsive.Keys.Medium),
		isCompactScreen = useBreakpointXOrSmaller(Responsive.Keys.Medium),
		focusedTextBox = v11
	}, p2))
end
