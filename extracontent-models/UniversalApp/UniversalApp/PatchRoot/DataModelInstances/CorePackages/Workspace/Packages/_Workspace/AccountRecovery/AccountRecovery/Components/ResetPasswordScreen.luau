local AccountRecovery = script:FindFirstAncestor("AccountRecovery")
local AccountRecoveryParent = AccountRecovery.Parent
local HttpService = game:GetService("HttpService")
local React = require(AccountRecoveryParent.React)
local UIBlox = require(AccountRecoveryParent.UIBlox)
local AppBlox = require(AccountRecoveryParent.AppBlox)
local useDesignTokens = require(AccountRecoveryParent.Style).useDesignTokens
local useLocalization = require(AccountRecoveryParent.Localization).Hooks.useLocalization
local useDispatch = require(AccountRecoveryParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useRoactService = require(AccountRecoveryParent.RobloxAppHooks).useRoactService
local RoactNetworking = require(AccountRecoveryParent.RoactServiceTags).RoactNetworking
local FullscreenPageWithSafeArea = AppBlox.FullscreenPageWithSafeArea
local useStyle = UIBlox.Core.Style.useStyle
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local Foundation = require(AccountRecoveryParent.Foundation)
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local ScrollView = Foundation.ScrollView
local Visibility = Foundation.Enums.Visibility
local InputSize = Foundation.Enums.InputSize
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local Logger = require(AccountRecoveryParent.Loggers).Logger
local AuthCommon = require(AccountRecoveryParent.AuthCommon)
local AuthSignup = require(AccountRecoveryParent.AuthSignup)
local GetUserById = AuthCommon.Thunks.GetUserById
local AuthTextInputValidator = AuthSignup.Components.AuthTextInputValidator
local InputValidity = AuthCommon.Enums.InputValidity
local PasswordValidator = AuthSignup.Thunks.PasswordValidator
local PasswordIssue = AuthCommon.Enums.PasswordIssue
local AppStorageUtilities = AuthCommon.Utils.AppStorageUtilities
local useClearFocusOnUnmount = require(AccountRecovery.Hooks).useClearFocusOnUnmount
local ChallengeType = require(AccountRecoveryParent.GenericChallenges).Types.ChallengeType
local TwoStepVerificationActionType = require(AccountRecoveryParent.GenericChallenges).Types.TwoStepVerificationActionType
local AccountRecoveryContext = require(AccountRecovery.Store.AccountRecoveryContext)
local RecoveryHeader = require(AccountRecovery.Components.RecoveryHeader)
local UserHeader = require(AccountRecovery.Components.UserHeader)
local ConfirmPasswordValidator = require(AccountRecovery.Thunks.ConfirmPasswordValidator)
local ConfirmPasswordIssue = require(AccountRecovery.Enums.ConfirmPasswordIssue)
local EmailValidator = require(AccountRecovery.Thunks.EmailValidator)
local EmailIssue = require(AccountRecovery.Enums.EmailIssue)
local ModalState = require(AccountRecovery.Enums.ModalState)
local getModal = require(AccountRecovery.Components.getModal)
local AccountRecoveryActionType = require(AccountRecovery.Enums.AccountRecoveryActionType)
local ResetPassword = require(AccountRecovery.Thunks.ResetPassword)
local SetEmail = require(AccountRecovery.Thunks.SetEmail)

require(AccountRecovery.Common.AccountRecoveryRequestTypes)

local ResetPasswordErrorCodes = require(AccountRecovery.Enums.ResetPasswordErrorCodes)
local Constants = require(AccountRecovery.Components.Constants)
local EventService = require(AccountRecovery.Analytics.EventService)
local EventConstants = require(AccountRecovery.Analytics.EventConstants)
local GetFFlagEnable2SVRecovery = require(AccountRecovery.Flags.GetFFlagEnable2SVRecovery)
local SharedFlags = require(AccountRecoveryParent.SharedFlags)
local GetFFlagEnableAutoLoginAfterRecovery = SharedFlags.GetFFlagEnableAutoLoginAfterRecovery
local GetFFlagEnableSavePasswordAfterRecovery = SharedFlags.GetFFlagEnableSavePasswordAfterRecovery
local GetFFlagPasswordErrorLength = require(AccountRecoveryParent.SharedFlags).GetFFlagPasswordErrorLength
local RoactAppExperiment = require(AccountRecoveryParent.RoactAppExperiment)
local AppBtidLayers = require(AccountRecoveryParent.ExperimentLayers).AppBtidLayers
local CredentialsProtocol = require(AccountRecoveryParent.CredentialsProtocol)
local Constants2 = CredentialsProtocol.Constants
local default = CredentialsProtocol.CredentialsProtocol.default
local GetFIntLuaAppCredentialsProtocolAvailableTimeout = CredentialsProtocol.Flags.GetFIntLuaAppCredentialsProtocolAvailableTimeout
local t1 = {
	PasswordIssue.Length,
	PasswordIssue.UsernameMatch,
	PasswordIssue.Simple
}
local GetFFlagPasswordErrorSimple = require(AccountRecoveryParent.SharedFlags).GetFFlagPasswordErrorSimple
local t2 = {
	[PasswordIssue.Length] = not GetFFlagPasswordErrorLength() and "Authentication.SignUp.Label.NewPasswordError1" or "Authentication.SignUp.Label.PasswordErrorLengthNew",
	[PasswordIssue.UsernameMatch] = "Authentication.SignUp.Label.NewPasswordError2",
	[PasswordIssue.Simple] = not GetFFlagPasswordErrorSimple() and "Authentication.SignUp.Label.NewPasswordError3" or "Authentication.SignUp.Label.PasswordErrorSimple"
}
local t3 = {
	[ConfirmPasswordIssue.PasswordsNotMatch] = "Authentication.AccountRecovery.MessagePasswordsDoNotMatch"
}
local t4 = {
	[EmailIssue.InvalidEmail] = "Authentication.AccountRecovery.Message.Error.InvalidEmail"
}

return function(t5: {[any]: any}) -- line: 138
	-- upvalues: React (copy), AccountRecoveryContext (copy), useStyle (copy), useTokens (copy), useDesignTokens (copy), useDispatch (copy), useRoactService (copy), RoactNetworking (copy), RoactAppExperiment (copy), AppBtidLayers (copy), InputValidity (copy), useClearFocusOnUnmount (copy), GetUserById (copy), Logger (copy), GetFFlagEnableAutoLoginAfterRecovery (copy), EventService (copy), GetFFlagEnableSavePasswordAfterRecovery (copy), EventConstants (copy), default (copy), GetFIntLuaAppCredentialsProtocolAvailableTimeout (copy), HttpService (copy), Constants2 (copy), SetEmail (copy), ResetPassword (copy), ChallengeType (copy), TwoStepVerificationActionType (copy), Constants (copy), AppStorageUtilities (copy), ResetPasswordErrorCodes (copy), GetFFlagEnable2SVRecovery (copy), AccountRecoveryActionType (copy), ModalState (copy), useLocalization (copy), FullscreenPageWithSafeArea (copy), RecoveryHeader (copy), ScrollView (copy), Visibility (copy), UserHeader (copy), FoundationText (copy), StyledTextLabel (copy), AuthTextInputValidator (copy), PasswordValidator (copy), t1 (copy), t2 (copy), InputSize (copy), ConfirmPasswordValidator (copy), t3 (copy), EmailValidator (copy), t4 (copy), Button (copy), ButtonVariant (copy), getModal (copy)
	local v71 = React.useContext(AccountRecoveryContext)
	local v72 = useStyle()
	local v73 = useTokens()
	local v74 = useDesignTokens()
	local v75 = useDispatch()
	local v76 = useRoactService(RoactNetworking)
	local v77 = RoactAppExperiment.useBrowserTrackerExperiment({ AppBtidLayers.IosPasswordSavingLayer }, function(p1) -- line: 149
		-- upvalues: AppBtidLayers (copy)
		return (p1[AppBtidLayers.IosPasswordSavingLayer] or {}).enableNewIosPasswordSaving or false
	end)
	local v78, v79 = React.useState("")
	local v80, v81 = React.useState("")
	local v82, v83 = React.useState("")
	local v84, v85 = React.useState(InputValidity.Unvalidated)
	local v86, v87 = React.useState("")
	local v88, v89 = React.useState(InputValidity.Unvalidated)
	local v90, v91 = React.useState("")
	local v92, v93 = React.useState(InputValidity.Unvalidated)
	local v94, v95 = React.useState(false)
	local v96, v97 = React.useState(false)
	local v98, v99 = React.useState("")
	local v100, v101 = React.useState(Vector2.new(0, 0))
	local v102 = t5.navigation.getParam("userID")
	local v103 = t5.navigation.getParam("shouldAddContactMethod")

	useClearFocusOnUnmount()
	React.useEffect(function() -- line: 177
		-- upvalues: GetUserById (copy), v76 (copy), v102 (copy), v81 (copy), v79 (copy), Logger (copy)
		GetUserById(v76, `{ v102 }`):andThen(function(p2) -- line: 178
			-- upvalues: v81 (copy), v79 (copy)
			v81(p2.name)
			v79(p2.displayName)
		end):catch(function(p3) -- line: 181
			-- upvalues: Logger (copy)
			Logger:warning("Error getting user info: {}", p3)
		end)
	end, {})
	React.useEffect(function() -- line: 188
		-- upvalues: v95 (copy), v96 (copy), v84 (copy), InputValidity (copy), v88 (copy), v103 (copy), v92 (copy)
		v95(not v96 and (v84 == InputValidity.Valid and (v88 == InputValidity.Valid and (not v103 or v92 == InputValidity.Valid))))
	end, {
		v96,
		v84,
		v88,
		v92
	})

	local function v104(b1: boolean?) -- line: 217
		-- upvalues: GetFFlagEnableAutoLoginAfterRecovery (copy), EventService (copy), v71 (copy)
		if b1 and GetFFlagEnableAutoLoginAfterRecovery() then
			EventService.sendPasswordResetEvent(v71.state.recoverySessionId, "launchApp")
			v71.utils.launchApp()

			return
		end

		EventService.sendPasswordResetEvent(v71.state.recoverySessionId, "closeRecoveryFlow")
		v71.parentNavigation.goBack()
	end
	local function v105(b2: boolean?) -- line: 227
		-- upvalues: v71 (copy), GetFFlagEnableSavePasswordAfterRecovery (copy), v77 (copy), EventService (copy), EventConstants (copy), v104 (copy), v80 (copy), v82 (copy), default (copy), GetFIntLuaAppCredentialsProtocolAvailableTimeout (copy), HttpService (copy), Logger (copy), Constants2 (copy)
		local recoverySessionId = v71.state.recoverySessionId

		if not GetFFlagEnableSavePasswordAfterRecovery() and not v77 then
			if EventService and EventService.sendPasswordUpdateSkippedEvent ~= nil then
				EventService.sendPasswordUpdateSkippedEvent(recoverySessionId, EventConstants.passwordUpdateSkipReason.featureDisabled)
			end

			v104(b2)

			return
		end

		if not v80 then
			if EventService and EventService.sendPasswordUpdateSkippedEvent ~= nil then
				EventService.sendPasswordUpdateSkippedEvent(recoverySessionId, EventConstants.passwordUpdateSkipReason.missingUsername)
			end

			v104(b2)

			return
		end

		if not v82 then
			if EventService and EventService.sendPasswordUpdateSkippedEvent ~= nil then
				EventService.sendPasswordUpdateSkippedEvent(recoverySessionId, EventConstants.passwordUpdateSkipReason.missingPassword)
			end

			v104(b2)

			return
		end

		default:isAvailable(default.CredentialsTypes.all, GetFIntLuaAppCredentialsProtocolAvailableTimeout()):andThen(function(p4) -- line: 270
			-- upvalues: EventService (copy), recoverySessionId (copy), EventConstants (copy), v104 (copy), b2 (copy), v80 (copy), v82 (copy), HttpService (copy), Logger (copy), default (copy), Constants2 (copy)
			if not p4.password or not p4.password.isAvailable then
				if EventService and EventService.sendPasswordUpdateSkippedEvent ~= nil then
					EventService.sendPasswordUpdateSkippedEvent(recoverySessionId, EventConstants.passwordUpdateSkipReason.protocolNotAvailable)
				end

				v104(b2)

				return
			end

			local t6 = {
				username = v80,
				password = v82
			}
			local json = HttpService:JSONEncode(t6)

			Logger:info("[ResetPasswordScreen] Calling registerCredentials for user: {}", v80)

			if EventService and EventService.sendPasswordUpdateAttemptedEvent ~= nil then
				EventService.sendPasswordUpdateAttemptedEvent(recoverySessionId, v80)
			end

			default:registerCredentials(default.CredentialsTypes.password, json, Constants2.Defaults.PASSWORD_REGISTRATION_CREDENTIALSPROTOCOL_TIMEOUT):andThen(function(p5) -- line: 303
				-- upvalues: HttpService (copy), Logger (copy), EventService (copy), recoverySessionId (copy), v80 (copy), v104 (copy), b2 (copy)
				local v148 = if not p5 then {} else HttpService:JSONDecode(p5)

				if v148 and v148.errorCode == nil then
					Logger:info("Successfully registered password after recovery")

					if EventService and EventService.sendPasswordUpdateSuccessEvent ~= nil then
						EventService.sendPasswordUpdateSuccessEvent(recoverySessionId, v80)
					end
				else
					Logger:warning("Error registering password after recovery: {}", v148.errorMsg or "unknown")

					if EventService and EventService.sendPasswordUpdateFailureEvent ~= nil then
						EventService.sendPasswordUpdateFailureEvent(recoverySessionId, v80, v148.errorMsg)
					end
				end

				v104(b2)
			end, function(p6) -- line: 327
				-- upvalues: Logger (copy), EventService (copy), recoverySessionId (copy), v80 (copy), v104 (copy), b2 (copy)
				Logger:warning("Error registering password after recovery: {}", p6)

				if EventService and EventService.sendPasswordUpdateFailureEvent ~= nil then
					EventService.sendPasswordUpdateFailureEvent(recoverySessionId, v80, (tostring(p6)))
				end

				v104(b2)
			end)
		end):catch(function(p7) -- line: 337
			-- upvalues: Logger (copy), EventService (copy), recoverySessionId (copy), EventConstants (copy), v104 (copy), b2 (copy)
			Logger:warning("[ResetPasswordScreen] Error checking CredentialsProtocol availability: {}", p7)

			if EventService and EventService.sendPasswordUpdateSkippedEvent ~= nil then
				EventService.sendPasswordUpdateSkippedEvent(recoverySessionId, EventConstants.passwordUpdateSkipReason.availabilityCheckFailed)
			end

			v104(b2)
		end)
	end
	local function v106(t7: {[any]: any}, p8: ((...any) -> ...any)) -- line: 375
		-- upvalues: HttpService (copy), v71 (copy), ChallengeType (copy), TwoStepVerificationActionType (copy), v102 (copy), v97 (copy), v99 (copy), Constants (copy)
		local v126 = t7 and (not not t7.errors and (not not t7.errors[1] and t7.errors[1].fieldData)) or nil
		local v127

		if type(v126) ~= "string" then
			v127 = nil
		else
			local data = HttpService:JSONDecode(v126)

			v127 = data and data.challengeId or nil
		end

		local v129 = v127

		if v129 == nil then
			return
		end

		v71.utils.renderChallenge({
			title = "Authentication.AccountRecovery.LabelTwoStepVerification",
			challengeType = ChallengeType.TwoStepVerification,
			challengeParameters = {
				allowRememberDevice = false,
				actionType = TwoStepVerificationActionType.PasswordReset,
				challengeId = v129,
				userId = v102
			},
			callbacks = {
				OnChallengeCompleted = function(p9) -- line: 396
					-- upvalues: p8 (copy), v129 (copy)
					p8(v129, p9.data.verificationToken)
				end,
				OnChallengeInvalidated = function(_) -- line: 399
					-- upvalues: v97 (copy), v99 (copy), Constants (copy)
					v97(false)
					v99(Constants.UnknownErrorKey)
				end,
				OnChallengeAbandoned = function(_) -- line: 403
					-- upvalues: v97 (copy)
					v97(false)
				end,
				OnChallengeLoadFailed = function(_) -- line: 406
					-- upvalues: v97 (copy), v99 (copy), Constants (copy)
					v97(false)
					v99(Constants.UnknownErrorKey)
				end
			}
		})
	end
	local function handleUpdatePassword(s1: string?, s2: string?) -- line: 414
		-- upvalues: v97 (copy), AppStorageUtilities (copy), v71 (copy), v75 (copy), ResetPassword (copy), v76 (copy), v102 (copy), v82 (copy), v86 (copy), v90 (copy), ResetPasswordErrorCodes (copy), v106 (copy), handleUpdatePassword (copy), Logger (copy), HttpService (copy), v99 (copy), Constants (copy), GetFFlagEnable2SVRecovery (copy), AccountRecoveryActionType (copy), ModalState (copy), v105 (copy), v80 (copy), SetEmail (copy)
		v97(true)

		local v132 = AppStorageUtilities.getAccountBlob() or ""
		local recoverySessionId = v71.state.recoverySessionId

		v75(ResetPassword(v76, {
			targetType = "RecoverySessionID",
			ticket = recoverySessionId,
			userId = v102,
			password = v82,
			passwordRepeated = v86,
			twoStepVerificationChallengeId = s1,
			twoStepVerificationToken = s2,
			accountBlob = v132,
			newEmail = v90
		})):andThen(function(p13) -- line: 423
			-- upvalues: ResetPasswordErrorCodes (copy), v106 (copy), handleUpdatePassword (copy), Logger (copy), HttpService (copy), v99 (copy), Constants (copy), v97 (copy), GetFFlagEnable2SVRecovery (copy), v71 (copy), AccountRecoveryActionType (copy), ModalState (copy), v105 (copy), v102 (copy), v80 (copy), v75 (copy), SetEmail (copy), v76 (copy)
			if p13.isError then
				if p13.errorCode == ResetPasswordErrorCodes.TwoStepVerificationRequired and p13.errorRaw ~= nil then
					v106(p13.errorRaw, handleUpdatePassword)

					return
				end

				Logger:warning("Error sending code: {}", HttpService:JSONEncode(p13))
				v99(p13.errorKey or Constants.UnknownErrorKey)
				v97(false)

				return
			end

			if GetFFlagEnable2SVRecovery() and p13.data.shouldPromptPasskeyAddition then
				v71.dispatch({
					type = AccountRecoveryActionType.SET_MODAL_STATE_AND_PROPS,
					data = {
						modalStateAndProps = {
							modalState = ModalState.ADD_NEW_PASSKEY,
							props = {
								onPasswordResetSuccess = function() -- line: 447
									-- upvalues: v105 (copy), p13 (copy)
									v105(p13.data.shouldAutoLoginFromRecovery)
								end,
								shouldUpdateEmail = p13.data.shouldUpdateEmail,
								email = p13.data.shouldUpdateEmail and p13.data.recoveryEmail or "",
								userId = v102,
								username = v80
							}
						}
					}
				})

				return
			end

			if GetFFlagEnable2SVRecovery() and p13.data.shouldPrompt2svRemoval then
				v71.dispatch({
					type = AccountRecoveryActionType.SET_MODAL_STATE_AND_PROPS,
					data = {
						modalStateAndProps = {
							modalState = ModalState.SAVE_OR_DELETE_TWO_STEP_METHOD,
							props = {
								onPasswordResetSuccess = function() -- line: 465
									-- upvalues: v105 (copy), p13 (copy)
									v105(p13.data.shouldAutoLoginFromRecovery)
								end,
								shouldUpdateEmail = p13.data.shouldUpdateEmail,
								email = p13.data.shouldUpdateEmail and p13.data.recoveryEmail or ""
							}
						}
					}
				})

				return
			end

			if p13.data.shouldUpdateEmail then
				v71.dispatch({
					type = AccountRecoveryActionType.SET_MODAL_STATE_AND_PROPS,
					data = {
						modalStateAndProps = {
							modalState = ModalState.UPDATE_EMAIL,
							props = {
								email = p13.data.recoveryEmail,
								onPasswordResetSuccess = function() -- line: 482
									-- upvalues: v105 (copy), p13 (copy)
									v105(p13.data.shouldAutoLoginFromRecovery)
								end
							}
						}
					}
				})

				return
			end

			local recoverySessionId2 = v71.state.recoverySessionId

			v75(SetEmail(v76, {
				recoverySessionId = recoverySessionId2
			})):andThen(function() -- line: 491
				-- upvalues: v105 (copy), p13 (copy)
				v105(p13.data.shouldAutoLoginFromRecovery)
			end)
		end):await()
	end

	local v108 = useLocalization({
		resetPasswordHeadingText = "Authentication.AccountRecovery.Heading.ResetPassword",
		createNewPasswordText = "Authentication.AccountRecovery.Description.CreateNewPassword",
		createNewPasswordAddEmailText = "Authentication.AccountRecovery.Description.CreateNewPasswordAddEmail",
		newPasswordLabelText = "Authentication.AccountRecovery.Label.NewPasswordV2",
		confirmPasswordLabelText = "Authentication.AccountRecovery.Label.ConfirmNewPasswordV2",
		updatePasswordButtonText = "Authentication.AccountRecovery.Action.UpdatePassword",
		addEmailLabelText = "Authentication.AccountRecovery.Label.AddEmail",
		requestErrorText = if v98 == "" then nil else v98
	})

	return React.createElement(FullscreenPageWithSafeArea, {
		includeStatusBar = true,
		BackgroundColor3 = v72.Theme.BackgroundDefault.Color
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v74.Size.Size_200),
			PaddingLeft = UDim.new(0, v74.Size.Size_300),
			PaddingRight = UDim.new(0, v74.Size.Size_300),
			PaddingBottom = UDim.new(0, v74.Size.Size_200)
		}),
		Wrapper = React.createElement("Frame", {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0)
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, v74.Size.Size_500)
			}),
			PreScrollContent = React.createElement("Frame", {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0),
				[React.Change.AbsoluteSize] = function(p14) -- line: 501
					-- upvalues: v100 (copy), v101 (copy)
					if v100 ~= p14.AbsoluteSize then
						v101(p14.AbsoluteSize)
					end
				end
			}, {
				Header = React.createElement(RecoveryHeader, {
					LayoutOrder = 1,
					currentComponent = "resetPassword",
					onBackActivated = function() -- line: 547
						-- upvalues: t5 (copy)
						t5.navigation.goBack()
					end,
					backButtonDisabled = v96,
					recoveryHeadingText = v108.resetPasswordHeadingText,
					recoverySessionId = v71.state.recoverySessionId
				})
			}),
			ContentScrollView = React.createElement(ScrollView, {
				LayoutOrder = 2,
				scroll = {
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					CanvasSize = UDim2.new(1, 0, 0, 0),
					ScrollingDirection = Enum.ScrollingDirection.Y,
					scrollBarVisibility = Visibility.Auto
				},
				Size = UDim2.new(1, 0, 1, -v100.Y)
			}, {
				UIPadding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, v74.Size.Size_200),
					PaddingRight = UDim.new(0, v74.Size.Size_200)
				}),
				UIListLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					Padding = UDim.new(0, v74.Size.Size_50)
				}),
				UserHeader = React.createElement(UserHeader, {
					LayoutOrder = 1,
					userId = v102,
					displayName = v78,
					username = v80
				}),
				BodyText = React.createElement(FoundationText, {
					LayoutOrder = 2,
					TextWrapped = true,
					Text = v103 and v108.createNewPasswordAddEmailText or v108.createNewPasswordText,
					fontStyle = v73.Typography.BodyMedium,
					textStyle = v73.Color.Content.Default,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					padding = {
						top = UDim.new(0, v73.Size.Size_300),
						bottom = UDim.new(0, v73.Size.Size_300)
					}
				}),
				NewPasswordLabel = React.createElement(StyledTextLabel, {
					layoutOrder = 3,
					text = v108.newPasswordLabelText,
					fontStyle = v73.Typography.TitleMedium,
					colorStyle = v72.Theme.TextEmphasis,
					automaticSize = Enum.AutomaticSize.XY
				}),
				NewPasswordFrame = React.createElement("Frame", {
					LayoutOrder = 4,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}, {
					NewPasswordPadding = React.createElement("UIPadding", {
						PaddingTop = UDim.new(0, v73.Size.Size_50),
						PaddingBottom = UDim.new(0, v73.Size.Size_300)
					}),
					NewPasswordField = React.createElement(AuthTextInputValidator, {
						layoutOrder = 1,
						customPadding = 0,
						hideIconButton = true,
						useFoundationTextForIssue = true,
						textInputType = Enum.TextInputType.Password,
						disabled = v96,
						validator = PasswordValidator,
						validatorAdditionalProps = {
							username = v80
						},
						validatorIssuePriorityList = t1,
						validatorIssueMessageList = t2,
						onTextChanged = function(s3: string, p15) -- line: 199
							-- upvalues: v83 (copy), v85 (copy)
							v83(s3)
							v85(p15)
						end,
						issueHeight = v73.Size.Size_500,
						foundationIssueTextPadding = v73.Size.Size_200,
						size = InputSize.Medium
					})
				}),
				ConfirmPasswordLabel = React.createElement(StyledTextLabel, {
					layoutOrder = 5,
					text = v108.confirmPasswordLabelText,
					fontStyle = v73.Typography.TitleMedium,
					colorStyle = v72.Theme.TextEmphasis,
					automaticSize = Enum.AutomaticSize.XY
				}),
				ConfirmPasswordFrame = React.createElement("Frame", {
					LayoutOrder = 6,
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0)
				}, {
					ConfirmPasswordPadding = React.createElement("UIPadding", {
						PaddingTop = UDim.new(0, v73.Size.Size_50),
						PaddingBottom = UDim.new(0, v73.Size.Size_300)
					}),
					ConfirmPasswordField = React.createElement(AuthTextInputValidator, {
						layoutOrder = 2,
						customPadding = 0,
						hideIconButton = true,
						useFoundationTextForIssue = true,
						textInputType = Enum.TextInputType.Password,
						disabled = v96,
						validator = ConfirmPasswordValidator,
						validatorAdditionalProps = {
							password = v82
						},
						validationDependencies = { v82 },
						validatorIssueMessageList = t3,
						onTextChanged = function(s4: string, p16) -- line: 204
							-- upvalues: v87 (copy), v89 (copy)
							v87(s4)
							v89(p16)
						end,
						issueHeight = v73.Size.Size_500,
						foundationIssueTextPadding = v73.Size.Size_200,
						size = InputSize.Medium
					})
				}),
				AddEmailLabel = v103 and React.createElement(StyledTextLabel, {
					layoutOrder = 7,
					text = v108.addEmailLabelText,
					fontStyle = v73.Typography.TitleMedium,
					colorStyle = v72.Theme.TextEmphasis,
					automaticSize = Enum.AutomaticSize.XY
				}),
				AddEmailFrame = v103 and React.createElement("Frame", {
					LayoutOrder = 8,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}, {
					AddEmailPadding = React.createElement("UIPadding", {
						PaddingTop = UDim.new(0, v73.Size.Size_50),
						PaddingBottom = UDim.new(0, v73.Size.Size_300)
					}),
					AddEmailField = v103 and React.createElement(AuthTextInputValidator, {
						layoutOrder = 3,
						customPadding = 0,
						hideIconButton = true,
						useFoundationTextForIssue = true,
						textInputType = Enum.TextInputType.Email,
						disabled = v96,
						validator = EmailValidator,
						validatorIssueMessageList = t4,
						onTextChanged = function(s5: string, p17) -- line: 209
							-- upvalues: v91 (copy), v93 (copy)
							v91(s5)
							v93(p17)
						end,
						issueHeight = v73.Size.Size_500,
						foundationIssueTextPadding = v73.Size.Size_200,
						size = InputSize.Medium
					})
				}),
				UpdatePasswordButton = React.createElement(Button, {
					LayoutOrder = 9,
					variant = ButtonVariant.Emphasis,
					size = InputSize.Medium,
					text = v108.updatePasswordButtonText,
					width = UDim.new(1, 0),
					onActivated = function() -- line: 709
						-- upvalues: handleUpdatePassword (copy)
						handleUpdatePassword()
					end,
					isDisabled = not v94
				}),
				RequestErrorTextLabel = React.createElement(FoundationText, {
					LayoutOrder = 11,
					Text = v108.requestErrorText or "",
					fontStyle = v73.Typography.CaptionSmall,
					textStyle = v73.Color.System.Alert,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					padding = {
						top = UDim.new(0, v73.Size.Size_200)
					}
				}),
				Modal = getModal(v71.state.modalStateAndProps)
			})
		})
	})
end
