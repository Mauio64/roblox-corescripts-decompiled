local TextService = game:GetService("TextService")
local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local dependencies = require(ParentParent.dependencies)
local RoactRodux = dependencies.RoactRodux
local RoactUtils = dependencies.RoactUtils
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local UIBlox = dependencies.UIBlox
local useLocalization = dependencies.Localization.Hooks.useLocalization
local React = dependencies.React
local useEffect = React.useEffect
local AnalyticsEvents = require(ParentParent.Analytics.AnalyticsEvents)
local EventConstants = require(ParentParent.Analytics.EventConstants)
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local useStyle = UIBlox.Core.Style.useStyle
local useNavigation = dependencies.Hooks.useNavigation
local AppPage = dependencies.RobloxAppEnums.AppPage
local NavigateDown = dependencies.NavigationRodux.Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = dependencies.SharedFlags.FFlagSignalsNavP3Dispatch
local v22 = if not FFlagSignalsNavP3Dispatch then nil else require(ParentParentParent.RobloxAppNavigation).NavigationCommands
local PeekView = dependencies.PeekView.PeekView
local PeekViewState = dependencies.PeekView.PeekViewState
local useState = React.useState
local AppBtidLayers = dependencies.ExperimentLayers.AppBtidLayers
local RoactAppExperiment = dependencies.RoactAppExperiment
local v28 = game:DefineFastFlag("EnableAddAccountPeekviewRemoveSuperBriefState", false)
local FFlagEnableLuaLoginRevamp = dependencies.SharedFlags.FFlagEnableLuaLoginRevamp
local FStringLuaLoginRevampIxpLayer = dependencies.SharedFlags.FStringLuaLoginRevampIxpLayer
local GetFFlagEnableMultiPageSignup = dependencies.SharedFlags.GetFFlagEnableMultiPageSignup
local GetFFlagLuaAppEnableTopBanner = dependencies.SharedFlags.GetFFlagLuaAppEnableTopBanner
local n1 = 240

local function AccountSwitchingAddAccountPeekView(t1: {[any]: any}) -- line: 61
	-- upvalues: useStyle (copy), useNavigation (copy), useDispatch (copy), useState (copy), PeekViewState (copy), useSelector (copy), GetFFlagLuaAppEnableTopBanner (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v22 (copy), NavigateDown (copy), useLocalization (copy), FFlagEnableLuaLoginRevamp (copy), RoactAppExperiment (copy), FStringLuaLoginRevampIxpLayer (copy), TextService (copy), n1 (ref), useEffect (copy), AnalyticsEvents (copy), EventConstants (copy), GetFFlagEnableMultiPageSignup (copy), React (copy), PeekView (copy), v28 (copy), Button (copy), ButtonType (copy)
	local v36 = useStyle()
	local v37 = useNavigation()
	local v38 = useDispatch()
	local BackgroundContrastColor = v36.Theme.BackgroundContrast.Color
	local v40, v41 = useState(PeekViewState.Full)
	local BaseSize = v36.Font.BaseSize
	local v43 = v36.Font.Header1.RelativeSize * BaseSize
	local v44 = useSelector(function(p1) -- line: 70
		return p1.ScreenSize
	end)
	local v45 = not GetFFlagLuaAppEnableTopBanner() and 0 or useSelector(function(p2) -- line: 75
		return p2.GlobalGuiInset.top
	end)
	local v46 = v44.X - 48

	local function v47() -- line: 82
		-- upvalues: AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v22 (copy), v38 (copy), NavigateDown (copy)
		local t2 = {
			name = AppPage.MultiPageSignup,
			extraProps = {
				enforceResetState = true
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v22.down(v22.fromLegacyPage(t2))

			return
		end

		v38(NavigateDown(t2))
	end

	local v48 = useLocalization({
		titleText = "Authentication.AccountSwitch.Action.AddAccount",
		loginText = "Authentication.Login.Heading.LoginRobloxAccountSwitching",
		createText = "Authentication.AccountSwitch.Action.CreateNewAccount"
	})
	local t3 = {
		showLoginRevamp = false
	}

	if FFlagEnableLuaLoginRevamp then
		t3 = RoactAppExperiment.useBrowserTrackerExperiment({ FStringLuaLoginRevampIxpLayer }, function(p3) -- line: 102
			-- upvalues: FStringLuaLoginRevampIxpLayer (copy)
			return {
				showLoginRevamp = (p3[FStringLuaLoginRevampIxpLayer] or {}).showLoginRevamp
			}
		end)
	end

	if GetFFlagLuaAppEnableTopBanner() then
		n1 = 193 + TextService:GetTextSize(v48.titleText, v43, v36.Font.Header1.Font, Vector2.new(0, 0)).Y
	end

	useEffect(function() -- line: 138
		-- upvalues: AnalyticsEvents (copy), EventConstants (copy), t1 (copy)
		AnalyticsEvents.sendModalShownEvent(EventConstants.ctx.accountSwitcherAddAccount, t1.origin)
	end, {})

	local function navigateToLogin() -- line: 142
		-- upvalues: AnalyticsEvents (copy), EventConstants (copy), t1 (copy), FFlagEnableLuaLoginRevamp (copy), t3 (ref)
		AnalyticsEvents.sendButtonClickEvent(EventConstants.ctx.accountSwitcherAddAccount, t1.origin, EventConstants.btn.login)

		if FFlagEnableLuaLoginRevamp and t3.showLoginRevamp then
			t1.navigateToLoginV2()

			return
		end

		t1.navigateToLogin()
	end
	local function navigateToSignUp() -- line: 156
		-- upvalues: AnalyticsEvents (copy), EventConstants (copy), t1 (copy), GetFFlagEnableMultiPageSignup (copy), v47 (copy)
		AnalyticsEvents.sendButtonClickEvent(EventConstants.ctx.accountSwitcherAddAccount, t1.origin, EventConstants.btn.signup)

		if GetFFlagEnableMultiPageSignup() and t1.shouldEnableMultiPageSignup then
			v47()

			return
		end

		t1.navigateToSignUp()
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = if not GetFFlagLuaAppEnableTopBanner() then UDim2.new(1, 0, 0, v44.Y) else UDim2.new(1, 0, 0, v44.Y - v45),
		BackgroundColor3 = v36.Theme.Overlay.Color
	}, { React.createElement(PeekView, {
		hasScrim = true,
		peekHeaderClose = false,
		canDragFullViewToBrief = true,
		returnToFullView = true,
		thumbstickScrollEnabled = true,
		showDraggerInClosedState = true,
		screenSize = v44,
		briefViewContentHeight = UDim.new(0, n1),
		superBriefViewContentHeight = if not v28 then UDim.new(0, 40) else nil,
		style = v36,
		stateOnMount = PeekViewState.Brief,
		peekHeaderPositionYChange = function(p4) -- line: 124
			-- upvalues: v41 (copy), PeekViewState (copy)
			if p4 < 10 then
				v41(PeekViewState.Closed)
			end
		end,
		viewStateChanged = function(p5, _) -- line: 131
			-- upvalues: v41 (copy), PeekViewState (copy), v37 (copy)
			v41(p5)

			if p5 == PeekViewState.Closed or p5 == PeekViewState.Hidden then
				v37.goBack()
			end
		end,
		peekViewState = v40
	}, {
		Content = React.createElement("Frame", {
			BackgroundTransparency = 0,
			Size = UDim2.new(1, 0, 0, 0),
			BorderColor3 = BackgroundContrastColor,
			BackgroundColor3 = BackgroundContrastColor,
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			ContentPadding = React.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, 48)
			}),
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 12),
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			TitleFrame = React.createElement("Frame", {
				LayoutOrder = 0,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				ContentPadding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 24),
					PaddingRight = UDim.new(0, 24)
				}),
				TitleText = React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					TextWrapped = true,
					Text = v48.titleText,
					TextSize = v43,
					TextColor3 = v36.Theme.TextEmphasis.Color,
					TextTransparency = v36.Theme.TextDefault.Transparency,
					Font = v36.Font.Header2.Font,
					TextXAlignment = Enum.TextXAlignment.Center,
					Size = UDim2.new(0, v46, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				})
			}),
			Divider = React.createElement("Frame", {
				LayoutOrder = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 1),
				BackgroundColor3 = v36.Theme.Divider.Color,
				BackgroundTransparency = v36.Theme.Divider.Transparency
			}),
			ButtonContentFrame = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 3,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Center
				}),
				UIPadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 24)
				}),
				LoginButton = React.createElement("Frame", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, -40, 0, 48)
				}, {
					UIPadding = React.createElement("UIPadding", {
						PaddingBottom = UDim.new(0, 60)
					}),
					Button = React.createElement(Button, {
						buttonType = ButtonType.PrimarySystem,
						size = UDim2.new(1, 0, 0, 48),
						text = v48.loginText,
						onActivated = navigateToLogin
					})
				}),
				SignupButton = React.createElement("Frame", {
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, -40, 0, 48)
				}, {
					Button = React.createElement(Button, {
						buttonType = ButtonType.Secondary,
						size = UDim2.new(1, 0, 0, 48),
						text = v48.createText,
						onActivated = navigateToSignUp
					})
				})
			})
		})
	}) })
end

if GetFFlagEnableMultiPageSignup() then
	AccountSwitchingAddAccountPeekView = RoactAppExperiment.connectBrowserTrackerLayer({ AppBtidLayers.SignupLayer }, function(p7, _) -- line: 304
		-- upvalues: AppBtidLayers (copy)
		return {
			shouldEnableMultiPageSignup = (p7[AppBtidLayers.SignupLayer] or {}).shouldEnableMultiPageSignup
		}
	end)(AccountSwitchingAddAccountPeekView)
end

return (RoactRodux.connect(nil, function(p9) -- line: 314
	-- upvalues: AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v22 (copy), NavigateDown (copy)
	return {
		navigateToLogin = function() -- line: 316
			-- upvalues: AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v22 (copy), p9 (copy), NavigateDown (copy)
			local t4 = {
				name = AppPage.Login
			}

			if FFlagSignalsNavP3Dispatch then
				v22.down(v22.fromLegacyPage(t4))

				return
			end

			p9(NavigateDown(t4))
		end,
		navigateToLoginV2 = function() -- line: 325
			-- upvalues: AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v22 (copy), p9 (copy), NavigateDown (copy)
			local t5 = {
				name = AppPage.LoginV2
			}

			if FFlagSignalsNavP3Dispatch then
				v22.down(v22.fromLegacyPage(t5))

				return
			end

			p9(NavigateDown(t5))
		end,
		navigateToSignUp = function() -- line: 334
			-- upvalues: AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v22 (copy), p9 (copy), NavigateDown (copy)
			local t6 = {
				name = AppPage.SinglePageSignUp
			}

			if FFlagSignalsNavP3Dispatch then
				v22.down(v22.fromLegacyPage(t6))

				return
			end

			p9(NavigateDown(t6))
		end
	}
end)(AccountSwitchingAddAccountPeekView))
