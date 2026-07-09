local MultiPageSignup = script:FindFirstAncestor("MultiPageSignup")
local MultiPageSignupParent = MultiPageSignup.Parent
local React = require(MultiPageSignupParent.React)
local useDesignTokens = require(MultiPageSignupParent.Style).useDesignTokens
local useLocalization = require(MultiPageSignupParent.Localization).Hooks.useLocalization
local UIBlox = require(MultiPageSignupParent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local AuthCommon = require(MultiPageSignupParent.AuthCommon)
local AppStorageUtilities = AuthCommon.Utils.AppStorageUtilities
local InputValidity = AuthCommon.Enums.InputValidity
local DisclaimerLinks = AuthCommon.Components.DisclaimerLinks
local GetFFlagEnableSignupFoundationText = require(MultiPageSignupParent.SharedFlags).GetFFlagEnableSignupFoundationText
local Text = require(MultiPageSignupParent.Foundation).Text
local AuthAnalytics = require(MultiPageSignupParent.AuthAnalytics)
local authMsgShown = AuthAnalytics.Events.authMsgShown
local authFormInteraction = AuthAnalytics.Events.authFormInteraction
local authModalShown = AuthAnalytics.Events.authModalShown
local authClientError = AuthAnalytics.Events.authClientError
local EventStreamConstants = AuthAnalytics.EventStreamConstants
local useRoactService = require(MultiPageSignupParent.RobloxAppHooks).useRoactService
local RoactNetworking = require(MultiPageSignupParent.RoactServiceTags).RoactNetworking
local RoactAppExperiment = require(MultiPageSignupParent.RoactAppExperiment)
local useShowDisclaimerLinks = require(MultiPageSignup.Hooks.useShowDisclaimerLinks)
local AuthSignup = require(MultiPageSignupParent.AuthSignup)
local AuthTextInputValidator = AuthSignup.Components.AuthTextInputValidator
local PasswordValidator = AuthSignup.Thunks.PasswordValidator
local PasswordIssue = AuthCommon.Enums.PasswordIssue
local UserActivationFramework = require(MultiPageSignupParent.UserActivationFramework)
local FullPageActivationFrameworkContext = UserActivationFramework.Context.FullPageActivationFrameworkContext
local ActivationFrameworkWrapper = UserActivationFramework.Components.ActivationFrameworkWrapper
local PayloadKey = UserActivationFramework.Enums.PayloadKey
local CallbackStatus = UserActivationFramework.Enums.CallbackStatus
local FStringLuaMultiPageSignupIxpLayer = require(MultiPageSignupParent.SharedFlags).FStringLuaMultiPageSignupIxpLayer
local RegisterPreauthPasskey = AuthCommon.Thunks.RegisterPreauthPasskey
local getCredentialsProtocolAvailability = require(MultiPageSignup.Utils.getCredentialsProtocolAvailability)
local t1 = {
	PasswordIssue.Length,
	PasswordIssue.UsernameMatch,
	PasswordIssue.Simple
}
local GetFFlagPasswordErrorSimple = require(MultiPageSignupParent.SharedFlags).GetFFlagPasswordErrorSimple
local GetFFlagPasswordErrorLength = require(MultiPageSignupParent.SharedFlags).GetFFlagPasswordErrorLength
local t2 = {
	[PasswordIssue.Length] = not GetFFlagPasswordErrorLength() and "Authentication.SignUp.Label.NewPasswordError1" or "Authentication.SignUp.Label.PasswordErrorLengthNew",
	[PasswordIssue.UsernameMatch] = "Authentication.SignUp.Label.NewPasswordError2",
	[PasswordIssue.Simple] = not GetFFlagPasswordErrorSimple() and "Authentication.SignUp.Label.NewPasswordError3" or "Authentication.SignUp.Label.PasswordErrorSimple"
}

return function(t3: {[any]: any}) -- line: 79
	-- upvalues: useRoactService (copy), RoactNetworking (copy), React (copy), FullPageActivationFrameworkContext (copy), InputValidity (copy), useDesignTokens (copy), useStyle (copy), useShowDisclaimerLinks (copy), RoactAppExperiment (copy), FStringLuaMultiPageSignupIxpLayer (copy), PayloadKey (copy), AppStorageUtilities (copy), getCredentialsProtocolAvailability (copy), useLocalization (copy), ActivationFrameworkWrapper (copy), CallbackStatus (copy), RegisterPreauthPasskey (copy), authModalShown (copy), EventStreamConstants (copy), authClientError (copy), DisclaimerLinks (copy), GetFFlagEnableSignupFoundationText (copy), Text (copy), StyledTextLabel (copy), AuthTextInputValidator (copy), PasswordValidator (copy), t1 (copy), t2 (copy), authFormInteraction (copy), authMsgShown (copy)
	local v42 = useRoactService(RoactNetworking)
	local v43 = React.useContext(FullPageActivationFrameworkContext)
	local activationFrameworkState = v43.activationFrameworkState
	local v45, v46 = React.useState(false)
	local v47, v48 = React.useState(true)
	local v49, v50 = React.useState("")
	local v51, v52 = React.useState(InputValidity.Unvalidated)
	local v53, v54 = React.useState(false)
	local v55, v56 = React.useState(false)
	local v57 = React.useRef(nil)
	local v58 = useDesignTokens()
	local v59 = useStyle()
	local v60 = useShowDisclaimerLinks()
	local v61, v62 = React.useState("")
	local v63 = RoactAppExperiment.useBrowserTrackerExperiment({ FStringLuaMultiPageSignupIxpLayer }, function(p1) -- line: 105
		-- upvalues: FStringLuaMultiPageSignupIxpLayer (copy)
		local v68 = p1[FStringLuaMultiPageSignupIxpLayer] or {}

		return {
			shouldShowPasskeyOnMultiPageSignup = v68.shouldShowPasskeyOnMultiPageSignup or false,
			shouldAwaitPasswordRegistrationOnMultiPageSignup = v68.shouldAwaitPasswordRegistrationOnMultiPageSignup or false,
			shouldShowCreateAccountHeaderOnMultiPageSignup = v68.shouldShowCreateAccountHeaderOnMultiPageSignup or false,
			shouldPromptPasskey = v68.shouldPromptPasskey or false
		}
	end)

	React.useEffect(function() -- line: 119
		-- upvalues: activationFrameworkState (copy), PayloadKey (copy), v62 (copy), AppStorageUtilities (copy)
		if activationFrameworkState.payloadTable and activationFrameworkState.payloadTable[PayloadKey.SignupUsername] then
			v62(activationFrameworkState.payloadTable[PayloadKey.SignupUsername])

			return
		end

		v62(AppStorageUtilities.getIncompleteSignupUsername())
	end, {})
	React.useEffect(function() -- line: 130
		-- upvalues: v57 (copy)
		if v57.current and v57.current.focus then
			v57.current.focus()
		end
	end, {})
	React.useEffect(function() -- line: 137
		-- upvalues: v46 (copy), v51 (copy), InputValidity (copy)
		v46(v51 == InputValidity.Valid)
	end, { v51 })
	React.useEffect(function() -- line: 142
		-- upvalues: activationFrameworkState (copy), getCredentialsProtocolAvailability (copy), t3 (copy), v43 (copy), v56 (copy), v54 (copy)
		if not activationFrameworkState.payloadTable then
			return
		end

		local v69, v70, _ = getCredentialsProtocolAvailability(activationFrameworkState.payloadTable, t3.namespace, v43.dispatch)

		v56(v69)
		v54(v70)
	end, {})

	local v64 = useLocalization({
		passwordLabel = "Authentication.Login.Label.Password",
		passwordPlaceholder = "Authentication.SignUp.Label.Use8CharPassword"
	})
	local v65 = React.useCallback(function() -- line: 168
		-- upvalues: v63 (copy), v55 (copy)
		return v63.shouldShowPasskeyOnMultiPageSignup and v55
	end, {
		v63.shouldShowPasskeyOnMultiPageSignup,
		v55
	})
	local v66 = not v65() and "Authentication.SignUp.Header.CreatePassword" or "Authentication.SignUp.Header.CreatePasswordOrPasskey"

	return React.createElement(ActivationFrameworkWrapper, {
		bodyTextKey = "Authentication.SignUp.Description.ThisKeepYourAccountSecure",
		headingTextKey = "Authentication.SignUp.Action.CreateAccount",
		namespace = t3.namespace,
		titleTextKey = {
			v66,
			username = "@" .. v61
		},
		primaryButton = {
			buttonTextKey = "Authentication.SignUp.Action.NextWord",
			shouldShowButton = true,
			isButtonEnabled = v45,
			onButtonClicked = function() -- line: 191
				-- upvalues: PayloadKey (copy), v49 (copy), v53 (copy), CallbackStatus (copy)
				return {
					payloadAddendum = {
						[PayloadKey.SignupPassword] = v49,
						[PayloadKey.CredentialsProtocolPasswordRegistrationAvailable] = tostring(v53),
						[PayloadKey.SignupPasskeySessionId] = "",
						[PayloadKey.SignupPasskeyResult] = ""
					},
					status = CallbackStatus.Success
				}
			end
		},
		secondaryButton = {
			buttonTextKey = "Authentication.SignUp.Action.CreateAPasskey",
			icon = "icons/menu/passkey",
			shouldShowButton = v65(),
			isButtonEnabled = v55 and v47,
			onButtonClicked = function() -- line: 210
				-- upvalues: v46 (copy), v48 (copy), RegisterPreauthPasskey (copy), v42 (copy), v61 (copy), authModalShown (copy), EventStreamConstants (copy), PayloadKey (copy), CallbackStatus (copy), authClientError (copy), v51 (copy), InputValidity (copy)
				v46(false)
				v48(false)

				local _, v75 = RegisterPreauthPasskey(v42, v61):andThen(function(p2) -- line: 214
					-- upvalues: authModalShown (copy), EventStreamConstants (copy), PayloadKey (copy), CallbackStatus (copy)
					if p2 then
						authModalShown(EventStreamConstants.Context.MultiPageSignupPreauthPasskeyCreatedAuthPage, EventStreamConstants.State.Success)

						return {
							payloadAddendum = {
								[PayloadKey.SignupPasskeySessionId] = p2.sessionId,
								[PayloadKey.SignupPasskeyResult] = p2.result,
								[PayloadKey.SignupPassword] = ""
							},
							status = CallbackStatus.Success
						}
					end

					authModalShown(EventStreamConstants.Context.MultiPageSignupPreauthPasskeyCreatedAuthPage, EventStreamConstants.State.Unknown)

					return {
						payloadAddendum = nil,
						status = CallbackStatus.PageError
					}
				end, function(p3) -- line: 239
					-- upvalues: authModalShown (copy), EventStreamConstants (copy), authClientError (copy), CallbackStatus (copy)
					if p3.name then
						authModalShown(EventStreamConstants.Context.MultiPageSignupPreauthPasskeyCreatedAuthPage, p3.name)

						if type(p3.body) == "string" then
							authClientError(EventStreamConstants.Context.MultiPageSignupPreauthPasskeyCreatedAuthPage, p3.body, p3.source)
						end
					else
						authModalShown(EventStreamConstants.Context.MultiPageSignupPreauthPasskeyCreatedAuthPage, EventStreamConstants.State.Unknown)
					end

					return {
						payloadAddendum = nil,
						status = CallbackStatus.PageError
					}
				end):await()

				v46(v51 == InputValidity.Valid)
				v48(true)

				return v75
			end
		},
		shouldShowButtonDivider = v65(),
		navigation = t3.navigation,
		subFooterContent = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 0, 1, 0),
			AnchorPoint = Vector2.new(0, 1),
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Bottom,
				FillDirection = Enum.FillDirection.Vertical
			}),
			DisclaimerLinks = if not v60 then nil else React.createElement(DisclaimerLinks, {
				ctx = t3.namespace,
				state = activationFrameworkState.currentState
			})
		})
	}, {
		Content = React.createElement("Frame", {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0)
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, v58.Size.Size_50)
			}),
			ContentPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v58.Size.Size_50)
			}),
			PasswordInputLabel = if not GetFFlagEnableSignupFoundationText() then React.createElement(StyledTextLabel, {
				layoutOrder = 1,
				text = v64.passwordLabel,
				fontStyle = v59.Font.Body,
				colorStyle = v59.Theme.TextDefault,
				automaticSize = Enum.AutomaticSize.XY
			}) else React.createElement(Text, {
				LayoutOrder = 1,
				tag = "text-body-small auto-xy",
				Text = v64.passwordLabel
			}),
			PasswordLabelSpacing = React.createElement("Frame", {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, v58.Size.Size_100)
			}),
			PasswordField = React.createElement(AuthTextInputValidator, {
				layoutOrder = 3,
				textInputType = Enum.TextInputType.Password,
				placeholder = v64.passwordPlaceholder,
				validator = PasswordValidator,
				validatorAdditionalProps = {
					username = v61
				},
				validatorIssuePriorityList = t1,
				validatorIssueMessageList = t2,
				onTextChanged = function(s1: string, p4) -- line: 157
					-- upvalues: v50 (copy), v52 (copy)
					v50(s1)
					v52(p4)
				end,
				onTextFocusedGained = function() -- line: 334
					-- upvalues: authFormInteraction (copy), v43 (copy), EventStreamConstants (copy)
					authFormInteraction(v43.activationFrameworkState.namespace, EventStreamConstants.Field.Password, v43.activationFrameworkState.currentState, nil, true)
				end,
				onErrorShown = function(s2: string) -- line: 343
					-- upvalues: authMsgShown (copy), t3 (copy), activationFrameworkState (copy), EventStreamConstants (copy)
					authMsgShown(t3.namespace, activationFrameworkState.currentState, EventStreamConstants.Field.Password, s2)
				end,
				textBoxRef = v57
			})
		})
	})
end
