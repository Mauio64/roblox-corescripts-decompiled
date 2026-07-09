local LoginV2 = script:FindFirstAncestor("LoginV2")
local LoginV2Parent = LoginV2.Parent
local UserInputService = game:GetService("UserInputService")
local React = require(LoginV2Parent.React)
local AppBlox = require(LoginV2Parent.AppBlox)
local AuthAnalytics = require(LoginV2Parent.AuthAnalytics)
local OtpLogin = require(LoginV2Parent.OtpLogin)
local useLocalization = require(LoginV2Parent.Localization).Hooks.useLocalization
local authPageload = AuthAnalytics.Events.authPageload
local authButtonClick = AuthAnalytics.Events.authButtonClick
local EventStreamConstants = AuthAnalytics.EventStreamConstants
local FullscreenPageWithSafeArea = AppBlox.FullscreenPageWithSafeArea
local UIBlox = require(LoginV2Parent.UIBlox)
local useDesignTokens = require(LoginV2Parent.Style).useDesignTokens
local useStyle = UIBlox.Core.Style.useStyle
local IconButton = UIBlox.App.Button.IconButton
local Images = UIBlox.App.ImageSet.Images
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local TextInput = require(LoginV2Parent.Foundation).TextInput
local LoginPageState = require(LoginV2.Enums.LoginPageState)
local LoginContext = require(LoginV2.Context.LoginContext)
local LoginActionType = require(LoginV2.Enums.LoginActionType)
local UserIdentifierHeading = require(LoginV2.Components.UserIdentifierHeading)
local ResendEmailOtpButton = require(LoginV2.Components.ResendEmailOtpButton)
local NeedHelpButton = require(LoginV2.Components.NeedHelpButton)
local Constants = require(LoginV2.Components.Constants)
local FFlagFixLoginV2LandscapeLayout = require(LoginV2Parent.SharedFlags).FFlagFixLoginV2LandscapeLayout
local Constants2 = OtpLogin.Constants

function EmailOtpScreen(t1: {[any]: any}) -- line: 48
	-- upvalues: React (copy), LoginContext (copy), useDesignTokens (copy), useStyle (copy), LoginActionType (copy), LoginPageState (copy), EventStreamConstants (copy), useLocalization (copy), authButtonClick (copy), UserInputService (copy), authPageload (copy), Constants2 (copy), FullscreenPageWithSafeArea (copy), FFlagFixLoginV2LandscapeLayout (copy), IconButton (copy), Images (copy), StyledTextLabel (copy), Constants (copy), UserIdentifierHeading (copy), TextInput (copy), ResendEmailOtpButton (copy), NeedHelpButton (copy)
	local v30 = React.useContext(LoginContext)
	local v31 = useDesignTokens()
	local v32 = useStyle()
	local state = v30.state
	local utils = v30.utils
	local v35, v36 = React.useState(false)
	local v37 = state and state.userIdentifier or ""

	local function v38(p1) -- line: 59
		-- upvalues: v30 (copy), LoginActionType (copy), LoginPageState (copy)
		v30.dispatch({
			type = LoginActionType.SetComponentState,
			data = {
				component = LoginPageState.EmailOtpScreen,
				payload = p1
			}
		})
	end

	local v39 = state and state.componentState[LoginPageState.EmailOtpScreen].sessionToken or ""
	local v40 = state and state.componentState[LoginPageState.EmailOtpScreen].emailOtp or ""
	local v41, v42 = React.useState(v40)
	local v43 = state and state.componentState[LoginPageState.EmailOtpScreen].errorKey or ""
	local t2 = {
		isLoginByOtp = true,
		setInProgress = v36,
		setErrorKey = function(p2) -- line: 86
			-- upvalues: v38 (copy)
			v38({
				errorKey = p2
			})
		end,
		navigation = t1.navigation,
		eventContext = EventStreamConstants.Context.LoginFormV2EmailOtp
	}
	local v45 = useLocalization({
		emailOtpLabelText = "Authentication.Login.Label.EnterOneTimeCodeLoginHelp",
		signInHeadingText = "Authentication.Login.Heading.SignIn",
		errorText = if v43 == "" then nil else v43
	})

	React.useEffect(function() -- line: 130
		-- upvalues: authPageload (copy), EventStreamConstants (copy)
		authPageload(EventStreamConstants.Context.LoginFormV2EmailOtp)
	end, {})
	React.useEffect(function() -- line: 135
		-- upvalues: v41 (copy), Constants2 (copy), v36 (copy), UserInputService (copy), authButtonClick (copy), EventStreamConstants (copy), v38 (copy), utils (copy), v39 (copy), t2 (copy)
		if #v41 == Constants2.DEFAULT_CODE_LENGTH then
			v36(true)

			local FocusedTextBox = UserInputService:GetFocusedTextBox()

			if FocusedTextBox then
				FocusedTextBox:ReleaseFocus()
			end

			authButtonClick(EventStreamConstants.Context.LoginFormV2EmailOtp, EventStreamConstants.Button.OtpSubmit, nil, nil)

			local v53 = v41

			v38({
				emailOtp = v53
			})
			utils.handleLoginWithOtp(v39, v41, nil, nil, t2):finally(function() -- line: 146
				-- upvalues: v38 (copy)
				v38({
					emailOtp = ""
				})
			end)
		end
	end, { v41 })

	return React.createElement(FullscreenPageWithSafeArea, {
		includeStatusBar = true,
		BackgroundColor3 = v32.Theme.BackgroundDefault.Color
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v31.Size.Size_200),
			PaddingLeft = UDim.new(0, v31.Size.Size_200),
			PaddingRight = UDim.new(0, v31.Size.Size_200),
			PaddingBottom = UDim.new(0, v31.Size.Size_200)
		}),
		Wrapper = React.createElement(not FFlagFixLoginV2LandscapeLayout and "Frame" or "ScrollingFrame", if not FFlagFixLoginV2LandscapeLayout then {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0)
		} else {
			BackgroundTransparency = 1,
			ScrollBarThickness = 0,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			CanvasSize = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.XY,
			ScrollingDirection = Enum.ScrollingDirection.Y
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = if not FFlagFixLoginV2LandscapeLayout then nil else Enum.HorizontalAlignment.Center
			}),
			Header = React.createElement("Frame", {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			}, {
				BackButton = React.createElement(IconButton, {
					layoutOrder = 1,
					icon = Images["icons/actions/cycleLeft"],
					onActivated = function() -- line: 196
						-- upvalues: authButtonClick (copy), EventStreamConstants (copy), v38 (copy), t1 (copy), LoginPageState (copy)
						authButtonClick(EventStreamConstants.Context.LoginFormV2EmailOtp, EventStreamConstants.Button.Back)
						v38({
							errorKey = ""
						})
						v38({
							emailOtp = ""
						})
						v38({
							sessionToken = ""
						})
						t1.navigation.navigate(LoginPageState.AuthenticationScreen)
					end,
					size = UDim2.new(0, 36, 0, 36),
					isDisabled = v35
				}),
				SignInHeadingFrame = React.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 0, 1, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					AutomaticSize = Enum.AutomaticSize.X
				}, {
					SignInHeadingText = React.createElement(StyledTextLabel, {
						text = v45.signInHeadingText,
						fontStyle = v32.Font.Header1,
						colorStyle = v32.Theme.TextEmphasis,
						textXAlignment = Enum.TextXAlignment.Center
					})
				})
			}),
			ButtonSpacing = React.createElement("Frame", {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, v31.Size.Size_200)
			}),
			Content = React.createElement("Frame", {
				LayoutOrder = 3,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			}, {
				UISizeConstraint = FFlagFixLoginV2LandscapeLayout and React.createElement("UISizeConstraint", {
					MaxSize = Vector2.new(Constants.CONTENT_MAX_WIDTH, 1e999)
				}),
				UIPadding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, v31.Size.Size_200),
					PaddingRight = UDim.new(0, v31.Size.Size_200),
					PaddingTop = UDim.new(0, v31.Size.Size_400),
					PaddingBottom = if not FFlagFixLoginV2LandscapeLayout then nil else UDim.new(0, v31.Size.Size_800)
				}),
				UIListLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					Padding = UDim.new(0, v31.Size.Size_50)
				}),
				Heading = React.createElement(UserIdentifierHeading, {
					layoutOrder = 1,
					userIdentifier = v37
				}),
				OneTimeCodeLabel = React.createElement(StyledTextLabel, {
					layoutOrder = 2,
					text = v45.emailOtpLabelText,
					fontStyle = v32.Font.Body,
					colorStyle = v32.Theme.TextEmphasis
				}),
				EmailOtpTextField = React.createElement(TextInput, {
					LayoutOrder = 3,
					label = "",
					text = v40,
					width = UDim.new(1, 0),
					onChanged = function(p3) -- line: 267
						-- upvalues: v42 (copy)
						v42(p3)
					end,
					isDisabled = v35,
					textInputType = Enum.TextInputType.OneTimePassword
				}),
				ErrorTextSpacing = v45.errorText and React.createElement("Frame", {
					LayoutOrder = 4,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, v31.Size.Size_100)
				}),
				ErrorTextLabel = v45.errorText and React.createElement(StyledTextLabel, {
					layoutOrder = 5,
					textWrapped = true,
					text = v45.errorText,
					fontStyle = v32.Font.BodySmall,
					colorStyle = v32.Theme.Alert,
					automaticSize = Enum.AutomaticSize.XY
				}),
				ButtonSpacing = React.createElement("Frame", {
					LayoutOrder = 6,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, v31.Size.Size_400)
				}),
				ResendOtpButton = React.createElement(ResendEmailOtpButton, {
					layoutOrder = 7,
					onPress = function() -- line: 111
						-- upvalues: authButtonClick (copy), EventStreamConstants (copy), utils (copy), v39 (copy), v38 (copy), t2 (copy)
						authButtonClick(EventStreamConstants.Context.LoginFormV2EmailOtp, EventStreamConstants.Button.ResendCode, nil, nil)
						utils.handleResendEmailOtp(v39, function(p4) -- line: 118
							-- upvalues: v38 (copy)
							v38({
								sessionToken = p4
							})
						end, t2)
					end,
					isLoading = v35
				}),
				HelpButtonFrame = React.createElement("Frame", {
					LayoutOrder = 8,
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0)
				}, {
					ListLayout = React.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center
					}),
					HelpButton = React.createElement(NeedHelpButton, {
						layoutOrder = 1,
						textKey = "Authentication.Login.Action.NeedHelp",
						isDisabled = v35,
						originPage = EventStreamConstants.Context.LoginFormV2Auth,
						identifierAutofill = v37
					})
				})
			})
		})
	})
end

return EmailOtpScreen
