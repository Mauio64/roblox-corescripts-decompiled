local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)

local module = require("@luauforge/bundled/hEc")

local module2 = require("@luauforge/bundled/hEi")

local module3 = require("@luauforge/bundled/fox")
local RobloxAppToastsRodux = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppToastsRodux/RobloxAppToastsRodux")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/dCu").NavigationCommands else nil

local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local useUiModeInfo = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useUiModeInfo
local uiMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").UiMode
local formFactor = require("@luauforge/bundled/dDI").Enums.FormFactor
local module5 = require("@luauforge/bundled/hEn")
local fullscreenFrame = require("@game/CorePackages/Workspace/Packages/AppBlox").FullscreenFrame

local module6 = require("@luauforge/bundled/hDz")

local module7 = require("@luauforge/bundled/hEd")

local fFlagEnableCrossDeviceApproverDialog = require("@game/CorePackages/Workspace/Packages/AuthCommon").Flags.FFlagEnableCrossDeviceApproverDialog

local extended = Roact.PureComponent:extend("CrossDeviceLoginPage")

function extended:init()
	self:setState({
		View = module5.InputCode,
		DeviceCode = "",
		HighKeyboardMode = false,
		KeyboardOffset = 0,
		DeviceName = "",
		Location = "",
		MapImagePath = "",
		ConfirmFailureCount = 0
	})

	function self.confirmDeviceCode(p2, p3, value, value2)
		self:setState({
			View = module5.Confirm,
			DeviceCode = p2,
			DeviceName = p3,
			Location = value or "",
			MapImagePath = value2 or ""
		})
	end

	function self.retryCrossDeviceLogin()
		self:setState({
			DeviceCode = "",
			DeviceName = "",
			Location = "",
			MapImagePath = "",
			View = module5.InputCode
		})
	end

	function self.showConfirmFailure()
		self:setState({
			DeviceCode = "",
			DeviceName = "",
			Location = "",
			MapImagePath = "",
			View = module5.InputCode,
			ConfirmFailureCount = self.state.ConfirmFailureCount + 1
		})
	end

	function self.closeCrossDeviceLogin()
		self.props.navigateBack()
	end

	self.continueButtonRef = Roact.createRef()
	self.codeFieldRef = Roact.createRef()
end

function extended:didMount()
	self.keyboardVisibleChanged = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):connect(function()
		local onScreenKeyboardVisible = UserInputService.OnScreenKeyboardVisible
		local y = onScreenKeyboardVisible and UserInputService.OnScreenKeyboardSize.Y or 0

		if onScreenKeyboardVisible then
			local current = self.continueButtonRef.current

			if
				current
				and y + current.AbsolutePosition.Y + current.AbsoluteSize.Y + 25 > self.props.screenSize.Y
			then
				self:setState({ HighKeyboardMode = true })
			end
		elseif self.state.HighKeyboardMode then
			self:setState({ HighKeyboardMode = false })
		end

		if module7() then
			local v5 = 0

			if onScreenKeyboardVisible then
				local current = self.codeFieldRef.current

				if current then
					local v6 = self.props.screenSize.Y - y
					v5 = math.max(0, current.AbsolutePosition.Y + current.AbsoluteSize.Y + 30 - v6)
				end
			end

			if self.state.KeyboardOffset ~= v5 then
				self:setState({ KeyboardOffset = v5 })
			end
		end
	end)
end

function extended:willUnmount()
	if self.keyboardVisibleChanged then
		self.keyboardVisibleChanged:disconnect()
		self.keyboardVisibleChanged = nil
	end
end

function extended.render(props)
	local designTokens = props.props.designTokens
	local v5 = props.props.formFactor == formFactor.WIDE or props.props.isTenFootUiMode
	local v6

	if props.props.isTenFootUiMode then
		local backgroundGradientOffset = designTokens.LuaApps.More.BackgroundGradientOffset
		local safeAreaMargin = designTokens.LuaApps.More.SafeAreaMargin

		v6 = React.createElement("Frame", {
			Position = UDim2.new(0, -safeAreaMargin.X, 0, -backgroundGradientOffset),
			Size = UDim2.new(
				1,
				safeAreaMargin.X + safeAreaMargin.X,
				1,
				backgroundGradientOffset + safeAreaMargin.Y
			),
			ZIndex = -1
		}, {
			UIGradient = React.createElement("UIGradient", {
				Color = ColorSequence.new(Color3.new(0, 0, 0)),
				Transparency = NumberSequence.new(1, 0.4),
				Rotation = 90
			})
		})
	else
		v6 = nil
	end

	local v7 = { nil, nil }
	local v8

	if fFlagEnableCrossDeviceApproverDialog or props.state.View == module5.InputCode then
		v8 = Roact.createElement(module, {
			isWideView = v5,
			code = module6() and props.props.code,
			continueButtonRef = props.continueButtonRef,
			codeFieldRef = props.codeFieldRef,
			highKeyboardMode = props.state.HighKeyboardMode,
			keyboardOffset = props.state.KeyboardOffset,
			confirmDeviceCode = props.confirmDeviceCode,
			confirmFailureCount = props.state.ConfirmFailureCount
		})
	else
		v8 = false
	end

	v7[1], v7[2] = v8, props.state.View == module5.Confirm and Roact.createElement(module2, {
	isWideView = v5,
	continueButtonRef = props.continueButtonRef,
	highKeyboardMode = props.state.HighKeyboardMode,
	deviceString = props.state.DeviceName,
	location = props.state.Location,
	mapImagePath = props.state.MapImagePath,
	deviceCode = props.state.DeviceCode,
	closeCallback = props.closeCrossDeviceLogin,
	retryCallback = props.retryCrossDeviceLogin,
	failCallback = props.showConfirmFailure,
	source = props.props.source
})

	return withStyle(function(p2)
		local backgroundColor = designTokens.LuaApps.App.Page.BackgroundColor
		local backgroundTransparency = designTokens.LuaApps.App.Page.BackgroundTransparency
		local v10 = math.min(props.props.screenSize.X, props.props.screenSize.Y)
		local v11 = props.props.formFactor == formFactor.WIDE and v10 > 0 and v10 < 700

		local devicePadding = designTokens.LuaApps.CrossDeviceLogin.getDevicePadding(v5 and not v11)
		local verticalPadding = designTokens.LuaApps.CrossDeviceLogin.verticalPadding
		local v12

		if module7() then
			v12 = verticalPadding + props.props.topBarSize
		elseif props.state.HighKeyboardMode then
			v12 = props.props.topBarSize
		else
			v12 = verticalPadding + props.props.topBarSize
		end

		local createElement = Roact.createElement
		local v13 = not props.props.isTenFootUiMode and "Frame" or fullscreenFrame
		local v15 = if not props.props.isTenFootUiMode then UDim2.new(1, 0, 1, 0) else nil

		local v17 = if props.props.isTenFootUiMode then v6 else nil
		local v18 = if not props.props.isTenFootUiMode then Roact.createElement(module3.Container, {
			leftItem = module3.BackButton,
			rightItems = { module3.BuyRobuxButton, module3.NotificationsButton }
		}) else nil
		return createElement(
			v13,
			{
				Size = v15,
				BorderSizePixel = 0,
				BackgroundColor3 = backgroundColor,
				BackgroundTransparency = backgroundTransparency
			},
			{
				BackgroundFrame = v17,
				TopBar = v18,
				PageContent = Roact.createElement("Frame", {
					Size = UDim2.new(
						1,
						-2 * devicePadding,
						1,
						-2 * verticalPadding - props.props.topBarSize
					),
					Position = UDim2.new(0, devicePadding, 0, v12),
					BackgroundTransparency = 1
				}, v7)
			}
		)
	end)
end

local v5 = RoactRodux.connect(function(data, p2)
	return {
		formFactor = data.FormFactor,
		topBarSize = p2.isTenFootUiMode and 0 or data.TopBar.topBarHeight,
		screenSize = data.ScreenSize
	}
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

return (RoactNavigation.withNavigation(function(p2)
	local v6 = useDesignTokens()
	local v7 = useUiModeInfo()

	return React.createElement(v5, Cryo.Dictionary.join(p2, {
		designTokens = v6,
		isTenFootUiMode = v7.uiMode == uiMode.TenFoot,
		code = p2.navigation.getParam("extraProps", {}).code,
		source = p2.navigation.getParam("extraProps", {}).source
	}))
end))
