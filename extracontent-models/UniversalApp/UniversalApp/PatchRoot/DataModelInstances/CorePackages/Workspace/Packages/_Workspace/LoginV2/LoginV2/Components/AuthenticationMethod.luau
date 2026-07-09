local LoginV2 = script:FindFirstAncestor("LoginV2")
local LoginV2Parent = LoginV2.Parent
local React = require(LoginV2Parent.React)
local UIBlox = require(LoginV2Parent.UIBlox)
local AuthAnalytics = require(LoginV2Parent.AuthAnalytics)
local useLocalization = require(LoginV2Parent.Localization).Hooks.useLocalization
local useDesignTokens = require(LoginV2Parent.Style).useDesignTokens
local useStyle = UIBlox.Core.Style.useStyle
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Images = UIBlox.App.ImageSet.Images
local StandardButtonSize = UIBlox.App.Button.Enum.StandardButtonSize
local TextInput = require(LoginV2Parent.Foundation).TextInput
local LoginActionType = require(LoginV2.Enums.LoginActionType)
local LoginContext = require(LoginV2.Context.LoginContext)
local LoginPageState = require(LoginV2.Enums.LoginPageState)
local AuthenticationMethodType = require(LoginV2.Enums.AuthenticationMethodType)
local Constants = require(LoginV2.Components.Constants)
local authFormInteraction = AuthAnalytics.Events.authFormInteraction
local EventStreamConstants = AuthAnalytics.EventStreamConstants
local UIConstants = require(LoginV2Parent.AuthCommon).Common.UIConstants

function AuthenticationMethod(t1: {[any]: any}) -- line: 46
	-- upvalues: React (copy), LoginContext (copy), useStyle (copy), useDesignTokens (copy), LoginActionType (copy), LoginPageState (copy), useLocalization (copy), AuthenticationMethodType (copy), StyledTextLabel (copy), TextInput (copy), authFormInteraction (copy), EventStreamConstants (copy), UIConstants (copy), Button (copy), Constants (copy), StandardButtonSize (copy), ButtonType (copy), Images (copy)
	local v24 = React.useContext(LoginContext)
	local v25 = useStyle()
	local v26 = useDesignTokens()
	local state = v24.state

	local function v28(p1) -- line: 53
		-- upvalues: v24 (copy), LoginActionType (copy), LoginPageState (copy)
		v24.dispatch({
			type = LoginActionType.SetComponentState,
			data = {
				component = LoginPageState.AuthenticationScreen,
				payload = p1
			}
		})
	end

	local v29 = state and state.componentState[LoginPageState.AuthenticationScreen].password or ""
	local v30, v31 = React.useState(false)
	local v32 = state and state.componentState[LoginPageState.AuthenticationScreen].errorKey or ""
	local v33 = state and state.componentState[LoginPageState.AuthenticationScreen].errorType or ""
	local v34 = useLocalization({
		passwordLabelText = "Authentication.Login.Label.Password",
		nextActionText = "Authentication.Login.Action.Next",
		usePasskeyActionText = "Authentication.Login.Action.UsePasskey",
		emailOneTimeCodeActionText = "Authentication.Login.Action.EmailACode",
		passwordErrorText = v32 ~= "" and (v33 == AuthenticationMethodType.Password and v32) or nil
	})
	local Size_200 = v26.Size.Size_200

	if t1.authMethod == AuthenticationMethodType.Password then
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = t1.layoutOrder,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0)
		}, {
			UIPadding = React.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, Size_200)
			}),
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, v26.Size.Size_50)
			}),
			PasswordLabel = React.createElement(StyledTextLabel, {
				layoutOrder = 1,
				richText = true,
				text = v34.passwordLabelText,
				fontStyle = v25.Font.Body,
				colorStyle = v25.Theme.TextEmphasis
			}),
			PasswordField = React.createElement(TextInput, {
				LayoutOrder = 2,
				text = "",
				label = "",
				textInputType = if not v30 then Enum.TextInputType.Password else Enum.TextInputType.PasswordShown,
				width = UDim.new(1, 0),
				onChanged = function(p2) -- line: 121
					-- upvalues: v32 (copy), v33 (copy), AuthenticationMethodType (copy), v28 (copy)
					if v32 ~= "" and v33 == AuthenticationMethodType.Password then
						v28({
							errorKey = ""
						})
					end

					v28({
						password = p2
					})
				end,
				onFocusGained = function() -- line: 127
					-- upvalues: authFormInteraction (copy), EventStreamConstants (copy)
					authFormInteraction(EventStreamConstants.Context.LoginFormV2Auth, EventStreamConstants.Field.Password, nil, nil, nil)
				end,
				iconTrailing = {
					name = if not v30 then UIConstants.HIDE_PASSWORD_ICON else UIConstants.SHOW_PASSWORD_ICON,
					onActivated = function() -- line: 140
						-- upvalues: v31 (copy), v30 (copy)
						v31(not v30)
					end
				},
				isDisabled = t1.isLoginInProgress,
				textBoxRef = t1.textBoxRef
			}),
			ErrorTextSpacing = v34.passwordErrorText and React.createElement("Frame", {
				LayoutOrder = 3,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, v26.Size.Size_100)
			}),
			ErrorTextLabel = v34.passwordErrorText and React.createElement(StyledTextLabel, {
				layoutOrder = 4,
				textWrapped = true,
				text = v34.passwordErrorText,
				fontStyle = v25.Font.BodySmall,
				colorStyle = v25.Theme.Alert,
				automaticSize = Enum.AutomaticSize.XY
			}),
			SubmitButtonSpacing = React.createElement("Frame", {
				LayoutOrder = 5,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, v26.Size.Size_400)
			}),
			SubmitButton = React.createElement(Button, {
				layoutOrder = 6,
				text = v34.nextActionText,
				buttonTextOverride = Constants.getButtonTextOverrideConfig(),
				onActivated = function() -- line: 169
					-- upvalues: t1 (copy), v29 (copy)
					t1.onSubmit(v29)
				end,
				standardSize = StandardButtonSize.Regular,
				buttonType = ButtonType.PrimaryContextual,
				isLoading = t1.isLoginInProgress,
				isDisabled = v29 == ""
			})
		})
	end

	if t1.authMethod == AuthenticationMethodType.Passkey then
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = t1.layoutOrder,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0)
		}, {
			UIPadding = React.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, Size_200)
			}),
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, v26.Size.Size_50)
			}),
			PasskeyButton = React.createElement(Button, {
				layoutOrder = 1,
				text = v34.usePasskeyActionText,
				buttonTextOverride = Constants.getButtonTextOverrideConfig(),
				onActivated = function() -- line: 197
					-- upvalues: t1 (copy)
					t1.onSubmit(nil)
				end,
				standardSize = StandardButtonSize.Regular,
				buttonType = if not t1.isFirstItemInList then ButtonType.Secondary else ButtonType.PrimaryContextual,
				isLoading = t1.isLoginInProgress,
				icon = Images["icons/menu/passkey"]
			})
		})
	end

	if t1.authMethod == AuthenticationMethodType.EmailOtp then
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = t1.layoutOrder,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0)
		}, {
			UIPadding = React.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, Size_200)
			}),
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, v26.Size.Size_50)
			}),
			EmailOtpButton = React.createElement(Button, {
				layoutOrder = 1,
				text = v34.emailOneTimeCodeActionText,
				buttonTextOverride = Constants.getButtonTextOverrideConfig(),
				onActivated = function() -- line: 225
					-- upvalues: t1 (copy)
					t1.onSubmit(nil)
				end,
				standardSize = StandardButtonSize.Regular,
				buttonType = if not t1.isFirstItemInList then ButtonType.Secondary else ButtonType.PrimaryContextual,
				isLoading = t1.isLoginInProgress,
				icon = Images["icons/menu/email"]
			})
		})
	end

	error("Invalid auth method")

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = t1.layoutOrder,
		Size = UDim2.new(0, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	})
end

return AuthenticationMethod
