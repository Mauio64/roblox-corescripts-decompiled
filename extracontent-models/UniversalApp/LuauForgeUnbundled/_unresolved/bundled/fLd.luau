local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/fJc")
local module2 = require("@luauforge/bundled/fJe")
local module3 = require("@luauforge/bundled/fKb")

local useDesignTokens = require("@luauforge/bundled/fKc").useDesignTokens
local useLocalization = require("@luauforge/bundled/fKd").Hooks.useLocalization
local useDispatch = require("@luauforge/bundled/fJh").Hooks.RoactRodux.useDispatch
local useRoactService = require("@luauforge/bundled/fJu").useRoactService

local roactNetworking = require("@luauforge/bundled/fJv").RoactNetworking

local fullscreenPageWithSafeArea = module3.FullscreenPageWithSafeArea
local useStyle = module2.Core.Style.useStyle
local styledTextLabel = module2.App.Text.StyledTextLabel

local module4 = require("@luauforge/bundled/fKe")
local text = module4.Text
local useTokens = module4.Hooks.useTokens
local scrollView = module4.ScrollView
local visibility = module4.Enums.Visibility
local inputSize = module4.Enums.InputSize
local button = module4.Button
local buttonVariant = module4.Enums.ButtonVariant

local logger = require("@luauforge/bundled/fJr").Logger

local module5 = require("@luauforge/bundled/fJy")
local module6 = require("@luauforge/bundled/fLe")
local getUserById = module5.Thunks.GetUserById
local authTextInputValidator = module6.Components.AuthTextInputValidator
local inputValidity = module5.Enums.InputValidity
local passwordValidator = module6.Thunks.PasswordValidator
local passwordIssue = module5.Enums.PasswordIssue

local appStorageUtilities = module5.Utils.AppStorageUtilities

local useClearFocusOnUnmount = require("@luauforge/bundled/fKf").useClearFocusOnUnmount

local challengeType = require("@luauforge/bundled/fJx").Types.ChallengeType
local twoStepVerificationActionType = require("@luauforge/bundled/fJx").Types.TwoStepVerificationActionType

local module7 = require("@luauforge/bundled/fJz")
local module8 = require("@luauforge/bundled/fKm")
local module9 = require("@luauforge/bundled/fKt")
local module10 = require("@luauforge/bundled/fMm")
local module11 = require("@luauforge/bundled/fMo")
local module12 = require("@luauforge/bundled/fMp")
local module13 = require("@luauforge/bundled/fMq")
local module14 = require("@luauforge/bundled/fJD")
local module15 = require("@luauforge/bundled/fKv")
local module16 = require("@luauforge/bundled/fJC")
local module17 = require("@luauforge/bundled/fJN")
local module18 = require("@luauforge/bundled/fKx")
require("@luauforge/bundled/fJj")
local module19 = require("@luauforge/bundled/fJO")
local module20 = require("@luauforge/bundled/fJH")
local module21 = require("@luauforge/bundled/fJU")
local module22 = require("@luauforge/bundled/fJW")

local module23 = require("@luauforge/bundled/fJS")
local module24 = require("@luauforge/bundled/fJT")
local module25 = require("@luauforge/bundled/fKp")

local module26 = require("@luauforge/bundled/fJI")

local getFFlagEnableAutoLoginAfterRecovery = module26.GetFFlagEnableAutoLoginAfterRecovery
local getFFlagEnableSavePasswordAfterRecovery = module26.GetFFlagEnableSavePasswordAfterRecovery
local getFFlagPasswordErrorLength = require("@luauforge/bundled/fJI").GetFFlagPasswordErrorLength

local module27 = require("@luauforge/bundled/fMr")
local appBtidLayers = require("@luauforge/bundled/fMs").AppBtidLayers

local module28 = require("@luauforge/bundled/fKI")
local constants = module28.Constants
local default = module28.CredentialsProtocol.default

local getFIntLuaAppCredentialsProtocolAvailableTimeout = module28.Flags.GetFIntLuaAppCredentialsProtocolAvailableTimeout

local v5 = { passwordIssue.Length, passwordIssue.UsernameMatch, passwordIssue.Simple }

local getFFlagPasswordErrorSimple = require("@luauforge/bundled/fJI").GetFFlagPasswordErrorSimple

local v6 = {
	[passwordIssue.Length] = getFFlagPasswordErrorLength() and "Authentication.SignUp.Label.PasswordErrorLengthNew" or "Authentication.SignUp.Label.NewPasswordError1",
	[passwordIssue.UsernameMatch] = "Authentication.SignUp.Label.NewPasswordError2",
	[passwordIssue.Simple] = getFFlagPasswordErrorSimple() and "Authentication.SignUp.Label.PasswordErrorSimple" or "Authentication.SignUp.Label.NewPasswordError3"
}

local v7 = {
	[module11.PasswordsNotMatch] = "Authentication.AccountRecovery.MessagePasswordsDoNotMatch"
}

local v8 = {
	[module13.InvalidEmail] = "Authentication.AccountRecovery.Message.Error.InvalidEmail"
}

return function(p2)
	local v9 = module.useContext(module7)

	local v10 = useStyle()
	local v11 = useTokens()
	local v12 = useDesignTokens()
	local v13 = useDispatch()
	local v14 = useRoactService(roactNetworking)

	local v15 = module27.useBrowserTrackerExperiment({ appBtidLayers.IosPasswordSavingLayer }, function(p3)
		return (p3[appBtidLayers.IosPasswordSavingLayer] or {}).enableNewIosPasswordSaving or false
	end)

	local state, setState = module.useState("")
	local state2, setState2 = module.useState("")

	local state3, setState3 = module.useState("")
	local state4, setState4 = module.useState(inputValidity.Unvalidated)
	local state5, setState5 = module.useState("")

	local state6, setState6 = module.useState(inputValidity.Unvalidated)
	local state7, setState7 = module.useState("")
	local state8, setState8 = module.useState(inputValidity.Unvalidated)

	local state9, setState9 = module.useState(false)

	local state10, setState10 = module.useState(false)
	local state11, setState11 = module.useState("")

	local state12, setState12 = module.useState(Vector2.new(0, 0))

	local param = p2.navigation.getParam("userID")
	local param2 = p2.navigation.getParam("shouldAddContactMethod")

	useClearFocusOnUnmount()

	module.useEffect(function()
		getUserById(v14, `{param}`):andThen(function(p3)
			setState2(p3.name)
			setState(p3.displayName)
		end):catch(function(p3)
			logger:warning("Error getting user info: {}", p3)
		end)
	end, {})

	module.useEffect(function()
		local v17 = not state10

		if v17 then
			if state4 == inputValidity.Valid and state6 == inputValidity.Valid then
				v17 = not param2 or state8 == inputValidity.Valid
			else
				v17 = false
			end
		end

		setState9(v17)
	end, { state10, state4, state6, state8 })

	local function onTextChanged(p3, p4)
		setState3(p3)
		setState4(p4)
	end

	local function onTextChanged2(p3, p4)
		setState5(p3)
		setState6(p4)
	end

	local function onTextChanged3(p3, p4)
		setState7(p3)
		setState8(p4)
	end

	local function fn(p3)
		if p3 and getFFlagEnableAutoLoginAfterRecovery() then
			module21.sendPasswordResetEvent(v9.state.recoverySessionId, "launchApp")
			v9.utils.launchApp()
		else
			module21.sendPasswordResetEvent(v9.state.recoverySessionId, "closeRecoveryFlow")
			v9.parentNavigation.goBack()
		end
	end

	local function fn2(shouldAutoLoginFromRecovery)
		local recoverySessionId = v9.state.recoverySessionId

		if getFFlagEnableSavePasswordAfterRecovery() or v15 then
			if state2 then
				if state3 then
					default:isAvailable(
						default.CredentialsTypes.all,
						getFIntLuaAppCredentialsProtocolAvailableTimeout()
					):andThen(function(p3)
						if p3.password and p3.password.isAvailable then
							local jsonEncode = HttpService:JSONEncode({
								username = state2,
								password = state3
							})

							logger:info(
								"[ResetPasswordScreen] Calling registerCredentials for user: {}",
								state2
							)

							if module21 and module21.sendPasswordUpdateAttemptedEvent ~= nil then
								module21.sendPasswordUpdateAttemptedEvent(recoverySessionId, state2)
							end

							default:registerCredentials(
								default.CredentialsTypes.password,
								jsonEncode,
								constants.Defaults.PASSWORD_REGISTRATION_CREDENTIALSPROTOCOL_TIMEOUT
							):andThen(
								function(json)
									local v16 = not json and {} or HttpService:JSONDecode(json)

									if v16 and v16.errorCode == nil then
										logger:info("Successfully registered password after recovery")

										if module21 and module21.sendPasswordUpdateSuccessEvent ~= nil then
											module21.sendPasswordUpdateSuccessEvent(
												recoverySessionId,
												state2
											)
										end
									else
										logger:warning(
											"Error registering password after recovery: {}",
											v16.errorMsg or "unknown"
										)

										if module21 and module21.sendPasswordUpdateFailureEvent ~= nil then
											module21.sendPasswordUpdateFailureEvent(
												recoverySessionId,
												state2,
												v16.errorMsg
											)
										end
									end

									fn(shouldAutoLoginFromRecovery)
								end,
								function(p4)
									logger:warning("Error registering password after recovery: {}", p4)

									if module21 and module21.sendPasswordUpdateFailureEvent ~= nil then
										module21.sendPasswordUpdateFailureEvent(
											recoverySessionId,
											state2,
											(tostring(p4))
										)
									end

									fn(shouldAutoLoginFromRecovery)
								end
							)
						else
							if module21 and module21.sendPasswordUpdateSkippedEvent ~= nil then
								module21.sendPasswordUpdateSkippedEvent(
									recoverySessionId,
									module22.passwordUpdateSkipReason.protocolNotAvailable
								)
							end

							fn(shouldAutoLoginFromRecovery)
						end
					end):catch(function(p3)
						logger:warning(
							"[ResetPasswordScreen] Error checking CredentialsProtocol availability: {}",
							p3
						)

						if module21 and module21.sendPasswordUpdateSkippedEvent ~= nil then
							module21.sendPasswordUpdateSkippedEvent(
								recoverySessionId,
								module22.passwordUpdateSkipReason.availabilityCheckFailed
							)
						end

						fn(shouldAutoLoginFromRecovery)
					end)
					return
				end

				if module21 and module21.sendPasswordUpdateSkippedEvent ~= nil then
					module21.sendPasswordUpdateSkippedEvent(
						recoverySessionId,
						module22.passwordUpdateSkipReason.missingPassword
					)
				end
			elseif module21 and module21.sendPasswordUpdateSkippedEvent ~= nil then
				module21.sendPasswordUpdateSkippedEvent(
					recoverySessionId,
					module22.passwordUpdateSkipReason.missingUsername
				)
			end
		elseif module21 and module21.sendPasswordUpdateSkippedEvent ~= nil then
			module21.sendPasswordUpdateSkippedEvent(
				recoverySessionId,
				module22.passwordUpdateSkipReason.featureDisabled
			)
		end

		fn(shouldAutoLoginFromRecovery)
	end

	local function fn3(errorRaw, handleUpdatePassword)
		local fieldData = errorRaw
			and errorRaw.errors
			and errorRaw.errors[1]
			and errorRaw.errors[1].fieldData
			or nil
		local challengeId

		if type(fieldData) == "string" then
			local jsonDecode = HttpService:JSONDecode(fieldData)
			challengeId = jsonDecode and jsonDecode.challengeId or nil
		else
			challengeId = nil
		end

		if challengeId == nil then
			return
		end

		v9.utils.renderChallenge({
			title = "Authentication.AccountRecovery.LabelTwoStepVerification",
			challengeType = challengeType.TwoStepVerification,
			challengeParameters = {
				actionType = twoStepVerificationActionType.PasswordReset,
				challengeId = challengeId,
				userId = param,
				allowRememberDevice = false
			},
			callbacks = {
				OnChallengeCompleted = function(p3)
					handleUpdatePassword(challengeId, p3.data.verificationToken)
				end,
				OnChallengeInvalidated = function(p3)
					setState10(false)
					setState11(module20.UnknownErrorKey)
				end,
				OnChallengeAbandoned = function(p3)
					setState10(false)
				end,
				OnChallengeLoadFailed = function(p3)
					setState10(false)
					setState11(module20.UnknownErrorKey)
				end
			}
		})
	end

	local function handleUpdatePassword(p3, p4)
		setState10(true)
		local v16 = appStorageUtilities.getAccountBlob() or ""
		v13(module17(v14, {
			targetType = "RecoverySessionID",
			ticket = v9.state.recoverySessionId,
			userId = param,
			password = state3,
			passwordRepeated = state5,
			twoStepVerificationChallengeId = p3,
			twoStepVerificationToken = p4,
			accountBlob = v16,
			newEmail = state7
		})):andThen(function(data)
			if data.isError then
				if data.errorCode == module19.TwoStepVerificationRequired and data.errorRaw ~= nil then
					fn3(data.errorRaw, handleUpdatePassword)

					return
				end

				logger:warning("Error sending code: {}", HttpService:JSONEncode(data))
				setState11(data.errorKey or module20.UnknownErrorKey)
				setState10(false)
			else
				if module24() and data.data.shouldPromptCredentialInvalidation then
					v9.dispatch({
						type = module16.SET_MODAL_STATE_AND_PROPS,
						data = {
							modalStateAndProps = {
								modalState = module14.INVALIDATE_CREDENTIALS,
								props = {
									onPasswordResetSuccess = function()
										fn2(data.data.shouldAutoLoginFromRecovery)
									end,
									shouldPromptPasskeyAddition = data.data.shouldPromptPasskeyAddition,
									userId = param,
									username = state2,
									shouldPrompt2svRemoval = data.data.shouldPrompt2svRemoval,
									shouldUpdateEmail = data.data.shouldUpdateEmail,
									email = data.data.shouldUpdateEmail and data.data.recoveryEmail or ""
								}
							}
						}
					})
					return
				end

				if module23() and data.data.shouldPromptPasskeyAddition then
					v9.dispatch({
						type = module16.SET_MODAL_STATE_AND_PROPS,
						data = {
							modalStateAndProps = {
								modalState = module14.ADD_NEW_PASSKEY,
								props = {
									onPasswordResetSuccess = function()
										fn2(data.data.shouldAutoLoginFromRecovery)
									end,
									shouldUpdateEmail = data.data.shouldUpdateEmail,
									email = data.data.shouldUpdateEmail and data.data.recoveryEmail or "",
									userId = param,
									username = state2
								}
							}
						}
					})
					return
				end

				if module23() and data.data.shouldPrompt2svRemoval then
					v9.dispatch({
						type = module16.SET_MODAL_STATE_AND_PROPS,
						data = {
							modalStateAndProps = {
								modalState = module14.SAVE_OR_DELETE_TWO_STEP_METHOD,
								props = {
									onPasswordResetSuccess = function()
										fn2(data.data.shouldAutoLoginFromRecovery)
									end,
									shouldUpdateEmail = data.data.shouldUpdateEmail,
									email = data.data.shouldUpdateEmail and data.data.recoveryEmail or ""
								}
							}
						}
					})
					return
				end

				if data.data.shouldUpdateEmail then
					v9.dispatch({
						type = module16.SET_MODAL_STATE_AND_PROPS,
						data = {
							modalStateAndProps = {
								modalState = module14.UPDATE_EMAIL,
								props = {
									email = data.data.recoveryEmail,
									onPasswordResetSuccess = function()
										fn2(data.data.shouldAutoLoginFromRecovery)
									end
								}
							}
						}
					})
					return
				end

				v13(module18(v14, { recoverySessionId = v9.state.recoverySessionId })):andThen(function()
					fn2(data.data.shouldAutoLoginFromRecovery)
				end)
			end
		end):await()
	end

	local function fn4(p3)
		if state12 ~= p3.AbsoluteSize then
			setState12(p3.AbsoluteSize)
		end
	end

	if state11 == "" then
		state11 = nil
	end

	local v18 = useLocalization({
		resetPasswordHeadingText = "Authentication.AccountRecovery.Heading.ResetPassword",
		createNewPasswordText = "Authentication.AccountRecovery.Description.CreateNewPassword",
		createNewPasswordAddEmailText = "Authentication.AccountRecovery.Description.CreateNewPasswordAddEmail",
		newPasswordLabelText = "Authentication.AccountRecovery.Label.NewPasswordV2",
		confirmPasswordLabelText = "Authentication.AccountRecovery.Label.ConfirmNewPasswordV2",
		updatePasswordButtonText = "Authentication.AccountRecovery.Action.UpdatePassword",
		addEmailLabelText = "Authentication.AccountRecovery.Label.AddEmail",
		requestErrorText = state11
	})

	local createElement = module.createElement
	local v20 = {
		includeStatusBar = true,
		BackgroundColor3 = v10.Theme.BackgroundDefault.Color
	}
	local v21 = {
		UIPadding = module.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v12.Size.Size_200),
			PaddingLeft = UDim.new(0, v12.Size.Size_300),
			PaddingRight = UDim.new(0, v12.Size.Size_300),
			PaddingBottom = UDim.new(0, v12.Size.Size_200)
		}),
		Wrapper = 0
	}

	local createElement2 = module.createElement
	local v23 = {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0)
	}

	local createElement3 = module.createElement
	local v25 = {
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Vertical,
		Padding = UDim.new(0, v12.Size.Size_500),
		HorizontalAlignment = 0
	}
	local v26 = if module25() then Enum.HorizontalAlignment.Center else nil
	v25.HorizontalAlignment = v26
	v21.Wrapper = createElement2("Frame", v23, {
		UIListLayout = createElement3("UIListLayout", v25),
		PreScrollContent = module.createElement("Frame", {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0),
			[module.Change.AbsoluteSize] = fn4
		}, {
			Header = module.createElement(module8, {
				LayoutOrder = 1,
				onBackActivated = function()
					p2.navigation.goBack()
				end,
				backButtonDisabled = state10,
				recoveryHeadingText = v18.resetPasswordHeadingText,
				currentComponent = "resetPassword",
				recoverySessionId = v9.state.recoverySessionId
			})
		}),
		ContentScrollView = module.createElement(scrollView, {
			LayoutOrder = 2,
			sizeConstraint = module25() and {
				MaxSize = Vector2.new(module20.ContentMaxWidth, 1e999)
			} or nil,
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.new(1, 0, 0, 0),
				ScrollingDirection = Enum.ScrollingDirection.Y,
				scrollBarVisibility = visibility.Auto
			},
			Size = UDim2.new(1, 0, 1, -state12.Y)
		}, {
			UIPadding = module.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, v12.Size.Size_200),
				PaddingRight = UDim.new(0, v12.Size.Size_200)
			}),
			UIListLayout = module.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, v12.Size.Size_50)
			}),
			UserHeader = module.createElement(module9, {
				LayoutOrder = 1,
				userId = param,
				displayName = state,
				username = state2
			}),
			BodyText = module.createElement(text, {
				LayoutOrder = 2,
				Text = param2 and v18.createNewPasswordAddEmailText or v18.createNewPasswordText,
				TextWrapped = true,
				fontStyle = v11.Typography.BodyMedium,
				textStyle = v11.Color.Content.Default,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				padding = {
					top = UDim.new(0, v11.Size.Size_300),
					bottom = UDim.new(0, v11.Size.Size_300)
				}
			}),
			NewPasswordLabel = module.createElement(styledTextLabel, {
				layoutOrder = 3,
				text = v18.newPasswordLabelText,
				fontStyle = v11.Typography.TitleMedium,
				colorStyle = v10.Theme.TextEmphasis,
				automaticSize = Enum.AutomaticSize.XY
			}),
			NewPasswordFrame = module.createElement(
				"Frame",
				{
					LayoutOrder = 4,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1
				},
				{
					NewPasswordPadding = module.createElement("UIPadding", {
						PaddingTop = UDim.new(0, v11.Size.Size_50),
						PaddingBottom = UDim.new(0, v11.Size.Size_300)
					}),
					NewPasswordField = module.createElement(authTextInputValidator, {
						layoutOrder = 1,
						textInputType = Enum.TextInputType.Password,
						disabled = state10,
						validator = passwordValidator,
						validatorAdditionalProps = { username = state2 },
						validatorIssuePriorityList = v5,
						validatorIssueMessageList = v6,
						onTextChanged = onTextChanged,
						customPadding = 0,
						issueHeight = v11.Size.Size_500,
						hideIconButton = true,
						useFoundationTextForIssue = true,
						foundationIssueTextPadding = v11.Size.Size_200,
						size = inputSize.Medium
					})
				}
			),
			ConfirmPasswordLabel = module.createElement(styledTextLabel, {
				layoutOrder = 5,
				text = v18.confirmPasswordLabelText,
				fontStyle = v11.Typography.TitleMedium,
				colorStyle = v10.Theme.TextEmphasis,
				automaticSize = Enum.AutomaticSize.XY
			}),
			ConfirmPasswordFrame = module.createElement(
				"Frame",
				{
					LayoutOrder = 6,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0),
					BackgroundTransparency = 1
				},
				{
					ConfirmPasswordPadding = module.createElement("UIPadding", {
						PaddingTop = UDim.new(0, v11.Size.Size_50),
						PaddingBottom = UDim.new(0, v11.Size.Size_300)
					}),
					ConfirmPasswordField = module.createElement(authTextInputValidator, {
						layoutOrder = 2,
						textInputType = Enum.TextInputType.Password,
						disabled = state10,
						validator = module10,
						validatorAdditionalProps = { password = state3 },
						validationDependencies = { state3 },
						validatorIssueMessageList = v7,
						onTextChanged = onTextChanged2,
						customPadding = 0,
						issueHeight = v11.Size.Size_500,
						hideIconButton = true,
						useFoundationTextForIssue = true,
						foundationIssueTextPadding = v11.Size.Size_200,
						size = inputSize.Medium
					})
				}
			),
			AddEmailLabel = param2 and module.createElement(styledTextLabel, {
				layoutOrder = 7,
				text = v18.addEmailLabelText,
				fontStyle = v11.Typography.TitleMedium,
				colorStyle = v10.Theme.TextEmphasis,
				automaticSize = Enum.AutomaticSize.XY
			}),
			AddEmailFrame = param2 and module.createElement(
				"Frame",
				{
					LayoutOrder = 8,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1
				},
				{
					AddEmailPadding = module.createElement("UIPadding", {
						PaddingTop = UDim.new(0, v11.Size.Size_50),
						PaddingBottom = UDim.new(0, v11.Size.Size_300)
					}),
					AddEmailField = param2 and module.createElement(authTextInputValidator, {
						layoutOrder = 3,
						textInputType = Enum.TextInputType.Email,
						disabled = state10,
						validator = module12,
						validatorIssueMessageList = v8,
						onTextChanged = onTextChanged3,
						customPadding = 0,
						issueHeight = v11.Size.Size_500,
						hideIconButton = true,
						useFoundationTextForIssue = true,
						foundationIssueTextPadding = v11.Size.Size_200,
						size = inputSize.Medium
					})
				}
			),
			UpdatePasswordButton = module.createElement(button, {
				LayoutOrder = 9,
				variant = buttonVariant.Emphasis,
				size = inputSize.Medium,
				text = v18.updatePasswordButtonText,
				width = UDim.new(1, 0),
				onActivated = function()
					handleUpdatePassword()
				end,
				isDisabled = not state9
			}),
			RequestErrorTextLabel = module.createElement(text, {
				LayoutOrder = 11,
				Text = v18.requestErrorText or "",
				fontStyle = v11.Typography.CaptionSmall,
				textStyle = v11.Color.System.Alert,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				padding = { top = UDim.new(0, v11.Size.Size_200) }
			}),
			Modal = module15(v9.state.modalStateAndProps)
		})
	})
	return createElement(fullscreenPageWithSafeArea, v20, v21)
end
