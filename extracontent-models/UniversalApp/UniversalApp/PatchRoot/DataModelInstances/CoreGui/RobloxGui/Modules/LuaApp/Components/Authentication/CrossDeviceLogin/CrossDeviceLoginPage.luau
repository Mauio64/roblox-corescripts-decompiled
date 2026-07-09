local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local withStyle = require(CorePackages.Packages.UIBlox).Style.withStyle
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local CrossDeviceEnterCodeView = require(Modules.LuaApp.Components.Authentication.CrossDeviceLogin.CrossDeviceEnterCodeView)
local CrossDeviceConfirmLoginView = require(Modules.LuaApp.Components.Authentication.CrossDeviceLogin.CrossDeviceConfirmLoginView)
local TopBar = require(Modules.LuaApp.Components.TopBar.TopBar)
local NavigateBack = require(Modules.LuaApp.Thunks.NavigateBack)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v15 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local useUiModeInfo = require(CorePackages.Workspace.Packages.RobloxAppHooks).useUiModeInfo
local UiMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).UiMode
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local CrossDeviceLoginView = require(Modules.LuaApp.Enum.CrossDeviceLoginView)
local FFlagEnableLeftNavOnConsole = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableLeftNavOnConsole
local FullscreenFrame = require(CorePackages.Workspace.Packages.AppBlox).FullscreenFrame
local GetFFlagEnableCrossDeviceLoginUsingQRCodes = require(Modules.LuaApp.Flags.GetFFlagEnableCrossDeviceLoginUsingQRCodes)
local GetFFlagEnableCrossDeviceEnterCodeRefresh = require(Modules.LuaApp.Flags.GetFFlagEnableCrossDeviceEnterCodeRefresh)
local v25 = Roact.PureComponent:extend("CrossDeviceLoginPage")

function v25.init(p1) -- line: 44
	-- upvalues: CrossDeviceLoginView (copy), Roact (copy)
	p1:setState({
		DeviceCode = "",
		HighKeyboardMode = false,
		KeyboardOffset = 0,
		DeviceName = "",
		View = CrossDeviceLoginView.InputCode
	})

	function p1.confirmDeviceCode(p2, p3) -- line: 53
		-- upvalues: p1 (copy), CrossDeviceLoginView (copy)
		p1:setState({
			View = CrossDeviceLoginView.Confirm,
			DeviceCode = p2,
			DeviceName = p3
		})
	end
	function p1.retryCrossDeviceLogin() -- line: 61
		-- upvalues: p1 (copy), CrossDeviceLoginView (copy)
		p1:setState({
			DeviceCode = "",
			DeviceName = "",
			View = CrossDeviceLoginView.InputCode
		})
	end
	function p1.closeCrossDeviceLogin() -- line: 69
		-- upvalues: p1 (copy)
		p1.props.navigateBack()
	end

	p1.continueButtonRef = Roact.createRef()
	p1.codeFieldRef = Roact.createRef()
end
function v25.didMount(p4) -- line: 77
	-- upvalues: UserInputService (copy), GetFFlagEnableCrossDeviceEnterCodeRefresh (copy)
	p4.keyboardVisibleChanged = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):connect(function() -- line: 79
		-- upvalues: UserInputService (copy), p4 (copy), GetFFlagEnableCrossDeviceEnterCodeRefresh (copy)
		local OnScreenKeyboardVisible = UserInputService.OnScreenKeyboardVisible
		local v46 = OnScreenKeyboardVisible and UserInputService.OnScreenKeyboardSize.Y or 0

		if OnScreenKeyboardVisible then
			local current = p4.continueButtonRef.current

			if current and v46 + current.AbsolutePosition.Y + current.AbsoluteSize.Y + 25 > p4.props.screenSize.Y then
				p4:setState({
					HighKeyboardMode = true
				})
			end
		elseif p4.state.HighKeyboardMode then
			p4:setState({
				HighKeyboardMode = false
			})
		end

		if GetFFlagEnableCrossDeviceEnterCodeRefresh() then
			local n1 = 0

			if OnScreenKeyboardVisible then
				local current = p4.codeFieldRef.current

				if current then
					local v50 = p4.props.screenSize.Y - v46

					n1 = math.max(0, current.AbsolutePosition.Y + current.AbsoluteSize.Y + 30 - v50)
				end
			end

			if n1 ~= p4.state.KeyboardOffset then
				p4:setState({
					KeyboardOffset = n1
				})
			end
		end
	end)
end
function v25.willUnmount(p5) -- line: 123
	if p5.keyboardVisibleChanged then
		p5.keyboardVisibleChanged:disconnect()
		p5.keyboardVisibleChanged = nil
	end
end
function v25.render(p6) -- line: 130
	-- upvalues: FormFactor (copy), React (copy), CrossDeviceLoginView (copy), Roact (copy), CrossDeviceEnterCodeView (copy), GetFFlagEnableCrossDeviceLoginUsingQRCodes (copy), CrossDeviceConfirmLoginView (copy), withStyle (copy), GetFFlagEnableCrossDeviceEnterCodeRefresh (copy), FFlagEnableLeftNavOnConsole (copy), FullscreenFrame (copy), TopBar (copy)
	local designTokens = p6.props.designTokens
	local v32 = p6.props.formFactor == FormFactor.WIDE or p6.props.isTenFootUiMode
	local u33 = nil

	if p6.props.isTenFootUiMode then
		local BackgroundGradientOffset = designTokens.LuaApps.More.BackgroundGradientOffset
		local SafeAreaMargin = designTokens.LuaApps.More.SafeAreaMargin

		u33 = React.createElement("Frame", {
			ZIndex = -1,
			Position = UDim2.new(0, -SafeAreaMargin.X, 0, -BackgroundGradientOffset),
			Size = UDim2.new(1, SafeAreaMargin.X + SafeAreaMargin.X, 1, BackgroundGradientOffset + SafeAreaMargin.Y)
		}, {
			UIGradient = React.createElement("UIGradient", {
				Rotation = 90,
				Color = ColorSequence.new(Color3.new(0, 0, 0)),
				Transparency = NumberSequence.new(1, 0.4)
			})
		})
	end

	local t1 = {
		p6.state.View == CrossDeviceLoginView.InputCode and Roact.createElement(CrossDeviceEnterCodeView, {
			isWideView = v32,
			code = GetFFlagEnableCrossDeviceLoginUsingQRCodes() and p6.props.code,
			continueButtonRef = p6.continueButtonRef,
			codeFieldRef = p6.codeFieldRef,
			highKeyboardMode = p6.state.HighKeyboardMode,
			keyboardOffset = p6.state.KeyboardOffset,
			confirmDeviceCode = p6.confirmDeviceCode
		}),
		p6.state.View == CrossDeviceLoginView.Confirm and Roact.createElement(CrossDeviceConfirmLoginView, {
			isWideView = v32,
			continueButtonRef = p6.continueButtonRef,
			highKeyboardMode = p6.state.HighKeyboardMode,
			deviceString = p6.state.DeviceName,
			deviceCode = p6.state.DeviceCode,
			closeCallback = p6.closeCrossDeviceLogin,
			retryCallback = p6.retryCrossDeviceLogin,
			source = p6.props.source
		})
	}

	return withStyle(function(_) -- line: 174
		-- upvalues: designTokens (copy), p6 (copy), FormFactor (copy), v32 (copy), GetFFlagEnableCrossDeviceEnterCodeRefresh (copy), Roact (copy), FFlagEnableLeftNavOnConsole (copy), FullscreenFrame (copy), u33 (ref), TopBar (copy), t1 (copy)
		local BackgroundColor = designTokens.LuaApps.App.Page.BackgroundColor
		local PageBackgroundTransparency = designTokens.LuaApps.App.Page.BackgroundTransparency
		local v54 = math.min(p6.props.screenSize.X, p6.props.screenSize.Y)
		local v55 = p6.props.formFactor == FormFactor.WIDE and (v54 > 0 and v54 < 700)
		local v56 = designTokens.LuaApps.CrossDeviceLogin.getDevicePadding(v32 and not v55)
		local verticalPadding = designTokens.LuaApps.CrossDeviceLogin.verticalPadding
		local v58 = if not GetFFlagEnableCrossDeviceEnterCodeRefresh() then if not p6.state.HighKeyboardMode then verticalPadding + p6.props.topBarSize else p6.props.topBarSize else verticalPadding + p6.props.topBarSize

		return Roact.createElement(not FFlagEnableLeftNavOnConsole and "Frame" or FullscreenFrame, {
			BorderSizePixel = 0,
			Size = if not FFlagEnableLeftNavOnConsole then UDim2.new(1, 0, 1, 0) else nil,
			BackgroundColor3 = BackgroundColor,
			BackgroundTransparency = PageBackgroundTransparency
		}, {
			BackgroundFrame = if not p6.props.isTenFootUiMode then nil else u33,
			TopBar = if not p6.props.isTenFootUiMode then Roact.createElement(TopBar.Container, {
				leftItem = TopBar.BackButton,
				rightItems = {
					TopBar.BuyRobuxButton,
					TopBar.NotificationsButton
				}
			}) else nil,
			PageContent = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -2 * v56, 1, -2 * verticalPadding - p6.props.topBarSize),
				Position = UDim2.new(0, v56, 0, v58)
			}, t1)
		})
	end)
end

local v26 = RoactRodux.connect(function(p8, p9) -- line: 218
	return {
		formFactor = p8.FormFactor,
		topBarSize = if not p9.isTenFootUiMode then p8.TopBar.topBarHeight else 0,
		screenSize = p8.ScreenSize
	}
end, function(p10) -- line: 224
	-- upvalues: FFlagSignalsNavP3Dispatch (copy), v15 (copy), NavigateBack (copy)
	return {
		navigateBack = function() -- line: 226
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v15 (copy), p10 (copy), NavigateBack (copy)
			if FFlagSignalsNavP3Dispatch then
				return v15.back()
			end

			return p10(NavigateBack())
		end
	}
end)(v25)

return (RoactNavigation.withNavigation(function(p11) -- line: 237
	-- upvalues: useDesignTokens (copy), useUiModeInfo (copy), React (copy), v26 (copy), Cryo (copy), UiMode (copy)
	local v41 = useDesignTokens()
	local v42 = useUiModeInfo()

	return React.createElement(v26, Cryo.Dictionary.join(p11, {
		designTokens = v41,
		isTenFootUiMode = v42.uiMode == UiMode.TenFoot,
		code = p11.navigation.getParam("extraProps", {}).code,
		source = p11.navigation.getParam("extraProps", {}).source
	}))
end))
