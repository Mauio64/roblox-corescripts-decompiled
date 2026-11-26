local TextService = game:GetService("TextService")

local module = require("@luauforge/bundled/gtJ")
local roactRodux = module.RoactRodux
local roactUtils = module.RoactUtils
local useDispatch = roactUtils.Hooks.RoactRodux.useDispatch
local useSelector = roactUtils.Hooks.RoactRodux.useSelector
local uiBlox = module.UIBlox
local useLocalization = module.Localization.Hooks.useLocalization
local react = module.React
local useEffect = react.useEffect
local module2 = require("@luauforge/bundled/guk")
local module3 = require("@luauforge/bundled/gul")
local button = uiBlox.App.Button.Button
local buttonType = uiBlox.App.Button.Enum.ButtonType
local useStyle = uiBlox.Core.Style.useStyle
local useNavigation = module.Hooks.useNavigation
local appPage = module.RobloxAppEnums.AppPage
local navigateDown = module.NavigationRodux.Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = module.SharedFlags.FFlagSignalsNavP3Dispatch
local fFlagLoginV2FullFlowDevOverride = module.SharedFlags.FFlagLoginV2FullFlowDevOverride

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/gun").NavigationCommands else nil

local peekView = module.PeekView.PeekView
local peekViewState = module.PeekView.PeekViewState
local useState = react.useState
local appBtidLayers = module.ExperimentLayers.AppBtidLayers

local roactAppExperiment = module.RoactAppExperiment

local defineFastFlag = game:DefineFastFlag("EnableAddAccountPeekviewRemoveSuperBriefState", false)
local authCommon = module.AuthCommon
local fFlagEnableAccountSwitchSsoLogin = module.SharedFlags.FFlagEnableAccountSwitchSsoLogin
local fStringLuaLoginRevampIxpLayer = module.SharedFlags.FStringLuaLoginRevampIxpLayer
local getFFlagEnableMultiPageSignup = module.SharedFlags.GetFFlagEnableMultiPageSignup
local getFFlagLuaAppEnableTopBanner = module.SharedFlags.GetFFlagLuaAppEnableTopBanner

local v5 = 240

local function AccountSwitchingAddAccountPeekView(props)
	local v6 = useStyle()
	local v7 = useNavigation()
	local v8 = useDispatch()
	local color = v6.Theme.BackgroundContrast.Color
	local state, setState = useState(peekViewState.Full)
	local baseSize = v6.Font.BaseSize
	local v9 = v6.Font.Header1.RelativeSize * baseSize

	local v10 = useSelector(function(p2)
		return p2.ScreenSize
	end)

	local v11 = not getFFlagLuaAppEnableTopBanner() and 0 or useSelector(function(p2)
		return p2.GlobalGuiInset.top
	end)

	local v12 = v10.X - 48

	local function fn()
		local v13 = {
			name = appPage.MultiPageSignup,
			extraProps = { enforceResetState = true }
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v13))
		else
			v8(navigateDown(v13))
		end
	end

	local v13 = useLocalization({
		titleText = "Authentication.AccountSwitch.Action.AddAccount",
		loginText = "Authentication.Login.Heading.LoginRobloxAccountSwitching",
		createText = "Authentication.AccountSwitch.Action.CreateNewAccount"
	})

	local v14 = roactAppExperiment.useBrowserTrackerExperiment(
		{ fStringLuaLoginRevampIxpLayer },
		function(p2)
			local v15 = p2[fStringLuaLoginRevampIxpLayer] or {}

			return {
				showLoginRevamp = fFlagLoginV2FullFlowDevOverride or v15.showLoginRevamp
			}
		end
	)
	local v15

	if fFlagEnableAccountSwitchSsoLogin then
		v15 = authCommon.Experiments.useAuthEntryVariant(nil, false) ~= authCommon.Experiments.AuthEntryVariant.Control
	else
		v15 = false
	end

	if getFFlagLuaAppEnableTopBanner() then
		v5 = 193 + TextService:GetTextSize(v13.titleText, v9, v6.Font.Header1.Font, Vector2.new(0, 0)).Y
	end

	useEffect(function()
		module2.sendModalShownEvent(module3.ctx.accountSwitcherAddAccount, props.origin)
	end, {})

	local function navigateToLogin()
		module2.sendButtonClickEvent(module3.ctx.accountSwitcherAddAccount, props.origin, module3.btn.login)

		if v14.showLoginRevamp or v15 then
			props.navigateToLoginV2()
		else
			props.navigateToLogin()
		end
	end

	local function navigateToSignUp()
		module2.sendButtonClickEvent(
			module3.ctx.accountSwitcherAddAccount,
			props.origin,
			module3.btn.signup
		)

		if getFFlagEnableMultiPageSignup() and props.shouldEnableMultiPageSignup then
			fn()
		else
			props.navigateToSignUp()
		end
	end

	local createElement = react.createElement

	local v18 = if getFFlagLuaAppEnableTopBanner() then UDim2.new(1, 0, 0, v10.Y - v11) else UDim2.new(1, 0, 0, v10.Y)
	local v17 = {
		Size = v18,
		BackgroundColor3 = v6.Theme.Overlay.Color,
		BackgroundTransparency = 1
	}

	local createElement2 = react.createElement
	local v21 = {
		hasScrim = true,
		screenSize = v10,
		briefViewContentHeight = UDim.new(0, v5),
		superBriefViewContentHeight = 0,
		peekHeaderClose = false,
		style = 0,
		canDragFullViewToBrief = true,
		stateOnMount = 0,
		returnToFullView = true,
		peekHeaderPositionYChange = 0,
		thumbstickScrollEnabled = true,
		showDraggerInClosedState = true,
		viewStateChanged = 0,
		peekViewState = 0
	}

	local v22 = if not defineFastFlag then UDim.new(0, 40) else nil
	v21.superBriefViewContentHeight = v22

	v21.style = v6

	v21.stateOnMount = peekViewState.Brief

	function v21.peekHeaderPositionYChange(p2)
		if p2 < 10 then
			setState(peekViewState.Closed)
		end
	end

	function v21.viewStateChanged(p2, p3)
		setState(p2)

		if p2 == peekViewState.Closed or p2 == peekViewState.Hidden then
			v7.goBack()
		end
	end
	v21.peekViewState = state
	return createElement("Frame", v17, { createElement2(peekView, v21, {
			Content = react.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, 0),
				BackgroundTransparency = 0,
				BorderColor3 = color,
				BackgroundColor3 = color,
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				ContentPadding = react.createElement("UIPadding", {
					PaddingBottom = UDim.new(0, 48)
				}),
				UIListLayout = react.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 12),
					HorizontalAlignment = Enum.HorizontalAlignment.Center
				}),
				TitleFrame = react.createElement(
					"Frame",
					{
						Size = UDim2.new(1, 0, 0, 0),
						LayoutOrder = 0,
						BackgroundTransparency = 1,
						AutomaticSize = Enum.AutomaticSize.Y
					},
					{
						ContentPadding = react.createElement("UIPadding", {
							PaddingLeft = UDim.new(0, 24),
							PaddingRight = UDim.new(0, 24)
						}),
						TitleText = react.createElement("TextLabel", {
							BackgroundTransparency = 1,
							Text = v13.titleText,
							TextSize = v9,
							TextColor3 = v6.Theme.TextEmphasis.Color,
							TextTransparency = v6.Theme.TextDefault.Transparency,
							Font = v6.Font.Header2.Font,
							TextXAlignment = Enum.TextXAlignment.Center,
							TextWrapped = true,
							Size = UDim2.new(0, v12, 0, 0),
							AutomaticSize = Enum.AutomaticSize.Y
						})
					}
				),
				Divider = react.createElement("Frame", {
					LayoutOrder = 1,
					Size = UDim2.new(1, 0, 0, 1),
					BorderSizePixel = 0,
					BackgroundColor3 = v6.Theme.Divider.Color,
					BackgroundTransparency = v6.Theme.Divider.Transparency
				}),
				ButtonContentFrame = react.createElement(
					"Frame",
					{
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundTransparency = 1,
						LayoutOrder = 3
					},
					{
						UIListLayout = react.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Vertical,
							SortOrder = Enum.SortOrder.LayoutOrder,
							HorizontalAlignment = Enum.HorizontalAlignment.Center
						}),
						UIPadding = react.createElement("UIPadding", {
							PaddingTop = UDim.new(0, 24)
						}),
						LoginButton = react.createElement(
							"Frame",
							{
								LayoutOrder = 1,
								Size = UDim2.new(1, -40, 0, 48),
								BackgroundTransparency = 1
							},
							{
								UIPadding = react.createElement("UIPadding", {
									PaddingBottom = UDim.new(0, 60)
								}),
								Button = react.createElement(button, {
									buttonType = buttonType.PrimarySystem,
									size = UDim2.new(1, 0, 0, 48),
									text = v13.loginText,
									onActivated = navigateToLogin
								})
							}
						),
						SignupButton = react.createElement(
							"Frame",
							{
								LayoutOrder = 2,
								Size = UDim2.new(1, -40, 0, 48),
								BackgroundTransparency = 1
							},
							{
								Button = react.createElement(button, {
									buttonType = buttonType.Secondary,
									size = UDim2.new(1, 0, 0, 48),
									text = v13.createText,
									onActivated = navigateToSignUp
								})
							}
						)
					}
				)
			})
		}) })
end

if getFFlagEnableMultiPageSignup() then
	AccountSwitchingAddAccountPeekView = roactAppExperiment.connectBrowserTrackerLayer(
		{ appBtidLayers.SignupLayer },
		function(p2, p3)
			return {
				shouldEnableMultiPageSignup = (p2[appBtidLayers.SignupLayer] or {}).shouldEnableMultiPageSignup
			}
		end
	)(AccountSwitchingAddAccountPeekView)
end

return (roactRodux.connect(nil, function(callback)
	return {
		navigateToLogin = function()
			local v6 = { name = appPage.Login }

			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(v6))
			else
				callback(navigateDown(v6))
			end
		end,
		navigateToLoginV2 = function()
			local v6 = { name = appPage.LoginV2 }

			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(v6))
			else
				callback(navigateDown(v6))
			end
		end,
		navigateToSignUp = function()
			local v6 = { name = appPage.SinglePageSignUp }

			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(v6))
			else
				callback(navigateDown(v6))
			end
		end
	}
end)(AccountSwitchingAddAccountPeekView))
