local AccountRecovery = script:FindFirstAncestor("AccountRecovery")
local AccountRecoveryParent = AccountRecovery.Parent
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
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
local TextInput = Foundation.TextInput
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local useTokens = Foundation.Hooks.useTokens
local ScrollView = Foundation.ScrollView
local Visibility = Foundation.Enums.Visibility
local Logger = require(AccountRecoveryParent.Loggers).Logger
local GetFFlagEnableContinueRecovery = require(AccountRecoveryParent.SharedFlags).GetFFlagEnableContinueRecovery
local useClearFocusOnUnmount = require(AccountRecovery.Hooks).useClearFocusOnUnmount
local AccountRecoveryContext = require(AccountRecovery.Store.AccountRecoveryContext)
local VerifyCode = require(AccountRecovery.Thunks.VerifyCode)
local ResendCode = require(AccountRecovery.Thunks.ResendCode)

require(AccountRecovery.Common.AccountRecoveryRequestTypes)

local Constants = require(AccountRecovery.Components.Constants)
local RecoveryHeader = require(AccountRecovery.Components.RecoveryHeader)
local ContactMethodType = require(AccountRecovery.Enums.ContactMethodType)
local UserHeader = require(AccountRecovery.Components.UserHeader)
local IdentifierType = require(AccountRecovery.Enums.IdentifierType)
local AccountRecoveryPageState = require(AccountRecovery.Enums.AccountRecoveryPageState)
local RecoveryState = require(AccountRecovery.Enums.RecoveryState)
local getModal = require(AccountRecovery.Components.getModal)
local GetFFlagEnableSkipPasswordReset = require(AccountRecovery.Flags.GetFFlagEnableSkipPasswordReset)

return function(t1: {[any]: any}) -- line: 61
	-- upvalues: React (copy), AccountRecoveryContext (copy), useStyle (copy), useTokens (copy), useDesignTokens (copy), useDispatch (copy), useRoactService (copy), RoactNetworking (copy), Constants (copy), useClearFocusOnUnmount (copy), IdentifierType (copy), VerifyCode (copy), UserInputService (copy), RecoveryState (copy), AccountRecoveryPageState (copy), GetFFlagEnableSkipPasswordReset (copy), Logger (copy), HttpService (copy), GetFFlagEnableContinueRecovery (copy), ResendCode (copy), useLocalization (copy), ContactMethodType (copy), FullscreenPageWithSafeArea (copy), RecoveryHeader (copy), ScrollView (copy), Visibility (copy), UserHeader (copy), FoundationText (copy), StyledTextLabel (copy), TextInput (copy), InputSize (copy), Button (copy), ButtonVariant (copy), getModal (copy)
	local v41 = React.useContext(AccountRecoveryContext)
	local v42 = useStyle()
	local v43 = useTokens()
	local v44 = useDesignTokens()
	local v45 = useDispatch()
	local v46 = useRoactService(RoactNetworking)
	local v47, v48 = React.useState("")
	local v49, v50 = React.useState("")
	local v51, v52 = React.useState(true)
	local v53, v54 = React.useState(false)
	local v55, v56 = React.useState(Constants.SecondsBetweenResends)
	local v57, v58 = React.useState(nil)
	local v59, v60 = React.useState("")
	local v61, v62 = React.useState("")
	local v63, v64 = React.useState(false)
	local v65, v66 = React.useState(Vector2.new(0, 0))

	useClearFocusOnUnmount()

	local n1 = 0
	local s1 = ""
	local s2 = ""
	local s3 = ""
	local v71 = t1.navigation.getParam("identifierInfo")
	local u72

	if v71.identifierType == IdentifierType.Username then
		u72 = true
		n1 = v71.userId
		s1 = v71.username
		s2 = v71.displayName
	else
		u72 = false
		s3 = v71.contactMethod
	end

	local v73 = t1.navigation.getParam("contactMethodNumber") or 0

	React.useEffect(function() -- line: 103
		-- upvalues: v51 (copy), v56 (copy), v54 (copy), v52 (copy), v58 (copy), v57 (copy)
		local function updateTimer() -- line: 104
			-- upvalues: v51 (copy), v56 (copy), v54 (copy), v52 (copy)
			while v51 do
				task.wait(1)
				v56(function(p1) -- line: 107
					-- upvalues: v54 (copy), v52 (copy)
					local v96 = p1 - 1

					if v96 <= 0 then
						v54(true)
						v52(false)

						return 0
					end

					return v96
				end)
			end
		end

		if v51 then
			local thread = task.spawn(updateTimer)

			v58(thread)
		end

		return function() -- line: 125
			-- upvalues: v52 (copy), v57 (copy)
			v52(false)

			if v57 then
				task.cancel(v57)
			end
		end
	end, { v51 })

	local function resetTimer() -- line: 133
		-- upvalues: v54 (copy), v56 (copy), Constants (copy), v51 (copy), v52 (copy), v57 (copy)
		v54(false)
		v56(Constants.SecondsBetweenResends)

		if v51 then
			v52(false)

			if v57 then
				task.cancel(v57)
			end
		end

		v52(true)
	end
	local function v75(n2: number, p2, p3: ((...any) -> ...any)) -- line: 160
		-- upvalues: Constants (copy), RecoveryState (copy), t1 (copy), AccountRecoveryPageState (copy), v73 (copy), v41 (copy), GetFFlagEnableSkipPasswordReset (copy), s1 (ref)
		if p2 == nil then
			p3(Constants.UnknownErrorKey)

			return
		end

		if p2.recoveryState == RecoveryState.RECOVERY_STATE_CONTACT_METHOD_VERIFICATION_REQUIRED then
			t1.navigation.navigate(AccountRecoveryPageState.SendCodeScreen, {
				isSecondContactMethodVerification = true,
				userID = n2,
				previousRecoveryMethod = p2.previousRecoveryMethod,
				previousRecoveryMethodTypes = p2.previousRecoveryMethodTypes,
				nextRecoveryMethodTypes = p2.nextRecoveryMethodTypes
			})

			return
		end

		if p2.recoveryState == RecoveryState.RECOVERY_STATE_ACCOUNT_VERIFIED then
			if v73 == 0 and v41.state.recover2sv then
				t1.navigation.replace(AccountRecoveryPageState.AccountVerifiedConfirmationScreen, {
					userID = n2
				})

				return
			end

			if GetFFlagEnableSkipPasswordReset() and v41.state.recover2sv and not v41.state.recoverPassword then
				v41.utils.handleUpdatePassword(v41.state.recoverySessionId, n2, s1, "", "", p3, v41.utils.launchAppOrGoBack)

				return
			end

			t1.navigation.replace(AccountRecoveryPageState.ChooseAccountScreen, {
				userID = n2
			})

			return
		end

		if p2.recoveryState == RecoveryState.RECOVERY_STATE_AWAITING_REEVALUATION then
			t1.navigation.navigate(AccountRecoveryPageState.CannotRecoverAccountScreen, {
				userID = n2
			})

			return
		end

		p3(Constants.UnknownErrorKey)
	end

	React.useEffect(function() -- line: 217
		-- upvalues: v47 (copy), Constants (copy), v64 (copy), UserInputService (copy), v50 (copy), v41 (copy), v45 (copy), VerifyCode (copy), v46 (copy), v73 (copy), Logger (copy), HttpService (copy), v62 (copy), GetFFlagEnableContinueRecovery (copy), u72 (ref), t1 (copy), AccountRecoveryPageState (copy), n1 (ref), s2 (ref), s1 (ref), v75 (copy)
		if #v47 == Constants.VerificationCodeLength then
			v64(true)

			local FocusedTextBox = UserInputService:GetFocusedTextBox()

			if FocusedTextBox then
				FocusedTextBox:ReleaseFocus()
			end

			v50(v47)

			local recoverySessionId = v41.state.recoverySessionId
			local v88 = v47

			v45(VerifyCode(v46, {
				recoverySessionId = recoverySessionId,
				code = v88,
				contactMethodNumber = v73
			})):andThen(function(p4) -- line: 224
				-- upvalues: Logger (copy), HttpService (copy), v62 (copy), Constants (copy), v64 (copy), GetFFlagEnableContinueRecovery (copy), u72 (ref), t1 (copy), AccountRecoveryPageState (copy), n1 (ref), s2 (ref), s1 (ref), v73 (copy), v41 (copy), v75 (copy)
				if p4.isError then
					Logger:warning("Error verifying code: {}", HttpService:JSONEncode(p4))
					v62(p4.errorKey or Constants.UnknownErrorKey)
					v64(false)

					return
				end

				if GetFFlagEnableContinueRecovery() and u72 then
					local function v92(_: string?) -- line: 232
						-- upvalues: t1 (copy), AccountRecoveryPageState (copy), n1 (ref), s2 (ref), s1 (ref), v73 (copy)
						t1.navigation.replace(AccountRecoveryPageState.ContinueFallbackScreen, {
							didAbandon2SV = false,
							userID = n1,
							displayName = s2,
							username = s1,
							contactMethodNumber = v73
						})
					end

					v41.utils.handleContinueRecovery(v41.state.recoverySessionId, n1, function(p5) -- line: 244
						-- upvalues: v75 (copy), n1 (ref), v92 (copy)
						v75(n1, p5, v92)
					end, v92, function() -- line: 248
						-- upvalues: t1 (copy), AccountRecoveryPageState (copy), n1 (ref), s2 (ref), s1 (ref), v73 (copy)
						t1.navigation.replace(AccountRecoveryPageState.ContinueFallbackScreen, {
							didAbandon2SV = true,
							userID = n1,
							displayName = s2,
							username = s1,
							contactMethodNumber = v73
						})
					end)

					return
				end

				t1.navigation.replace(AccountRecoveryPageState.ChooseAccountScreen, {
					userID = n1
				})
				v64(false)
			end):finally(function() -- line: 265
				-- upvalues: v50 (copy)
				v50("")
			end)
		end
	end, { v47 })

	local v76 = useLocalization({
		recoveryHeadingText = "Authentication.AccountRecovery.Heading.RobloxAccountRecovery",
		emailCodeSentText = "Authentication.AccountRecovery.Description.EmailCodeSent",
		emailCodeSentForUserText = "Authentication.AccountRecovery.Description.EmailCodeSentForUser",
		phoneCodeSentText = "Authentication.AccountRecovery.Description.PhoneCodeSent",
		phoneCodeSentForUserText = "Authentication.AccountRecovery.Description.PhoneCodeSentForUser",
		enterCodeText = "Authentication.AccountRecovery.Label.EnterCode",
		resendCodeText = "Authentication.AccountRecovery.Label.ResendCode",
		resendCodeTimerText = {
			"Authentication.AccountRecovery.Label.ResendCodeTimer",
			timeLeft = `{ v55 }`
		},
		codeErrorText = if v61 == "" then nil else v61,
		resendErrorText = if v59 == "" then nil else v59
	})
	local s5 = ""

	if v71.contactMethodType == ContactMethodType.Email then
		s5 = u72 and v76.emailCodeSentForUserText or v76.emailCodeSentText
	elseif v71.contactMethodType == ContactMethodType.Phone then
		s5 = u72 and v76.phoneCodeSentForUserText or v76.phoneCodeSentText
	end

	return React.createElement(FullscreenPageWithSafeArea, {
		includeStatusBar = true,
		BackgroundColor3 = v42.Theme.BackgroundDefault.Color
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v44.Size.Size_200),
			PaddingLeft = UDim.new(0, v44.Size.Size_300),
			PaddingRight = UDim.new(0, v44.Size.Size_300),
			PaddingBottom = UDim.new(0, v44.Size.Size_200)
		}),
		Wrapper = React.createElement("Frame", {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0)
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical
			}),
			Header = React.createElement(RecoveryHeader, {
				LayoutOrder = 1,
				currentComponent = "resendOrVerifyCode",
				onBackActivated = function() -- line: 339
					-- upvalues: t1 (copy)
					t1.navigation.goBack()
				end,
				backButtonDisabled = v63,
				recoveryHeadingText = v76.recoveryHeadingText,
				recoverySessionId = v41.state.recoverySessionId
			}),
			Content = React.createElement("Frame", {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical
				}),
				PreScrollContent = React.createElement("Frame", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0),
					[React.Change.AbsoluteSize] = function(p6) -- line: 287
						-- upvalues: v65 (copy), v66 (copy)
						if v65 ~= p6.AbsoluteSize then
							v66(p6.AbsoluteSize)
						end
					end
				}, {
					UIPadding = React.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, v44.Size.Size_200),
						PaddingRight = UDim.new(0, v44.Size.Size_200)
					}),
					UIListLayout = React.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						Padding = UDim.new(0, v44.Size.Size_50)
					}),
					RecoveryHeadingSpacing = React.createElement("Frame", {
						LayoutOrder = 1,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, v44.Size.Size_500)
					})
				}),
				InputsOverflowScrollView = React.createElement(ScrollView, {
					LayoutOrder = 2,
					scroll = {
						AutomaticCanvasSize = Enum.AutomaticSize.Y,
						CanvasSize = UDim2.new(1, 0, 0, 0),
						ScrollingDirection = Enum.ScrollingDirection.Y,
						scrollBarVisibility = Visibility.Always
					},
					Size = UDim2.new(1, 0, 1, -v65.Y)
				}, {
					UIPadding = React.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, v44.Size.Size_200),
						PaddingRight = UDim.new(0, v44.Size.Size_200)
					}),
					UIListLayout = React.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						Padding = UDim.new(0, v44.Size.Size_50)
					}),
					UserHeader = u72 and React.createElement(UserHeader, {
						LayoutOrder = 2,
						userId = `{ n1 }`,
						displayName = s2,
						username = s1
					}),
					ContactMethodHeader = not u72 and React.createElement(FoundationText, {
						LayoutOrder = 3,
						Text = s3,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						fontStyle = v43.Typography.HeadingSmall,
						textStyle = v43.Color.Content.Emphasis,
						TextXAlignment = Enum.TextXAlignment.Center,
						TextYAlignment = Enum.TextYAlignment.Center
					}),
					HeaderSpacing = React.createElement("Frame", {
						LayoutOrder = 4,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, v43.Size.Size_400)
					}),
					BodyText = React.createElement(FoundationText, {
						LayoutOrder = 5,
						TextWrapped = true,
						Text = s5,
						fontStyle = v43.Typography.BodyMedium,
						textStyle = v43.Color.Content.Default,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center
					}),
					BodyTextSpacing = React.createElement("Frame", {
						LayoutOrder = 6,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, v44.Size.Size_300)
					}),
					EnterCodeLabel = React.createElement(StyledTextLabel, {
						layoutOrder = 7,
						text = v76.enterCodeText,
						fontStyle = v43.Typography.TitleMedium,
						colorStyle = v42.Theme.TextEmphasis,
						automaticSize = Enum.AutomaticSize.XY
					}),
					EnterCodeLabelSpacing = React.createElement("Frame", {
						LayoutOrder = 8,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, v44.Size.Size_100)
					}),
					EnterCodeField = React.createElement(TextInput, {
						LayoutOrder = 9,
						label = "",
						text = v49,
						width = UDim.new(1, 0),
						textInputType = Enum.TextInputType.OneTimePassword,
						onChanged = function(p7) -- line: 455
							-- upvalues: v61 (copy), v62 (copy), v48 (copy)
							if v61 ~= "" then
								v62("")
							end

							v48(p7)
						end,
						isDisabled = v63,
						size = InputSize.Medium
					}),
					ErrorTextSpacing = React.createElement("Frame", {
						LayoutOrder = 10,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, v43.Size.Size_200)
					}),
					ErrorTextLabel = React.createElement(FoundationText, {
						LayoutOrder = 11,
						Text = v76.codeErrorText or "",
						fontStyle = v43.Typography.CaptionSmall,
						textStyle = v43.Color.System.Alert,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center
					}),
					ResendCodeButtonSpacing = React.createElement("Frame", {
						LayoutOrder = 12,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, v43.Size.Size_300)
					}),
					ResendCodeButton = React.createElement(Button, {
						LayoutOrder = 13,
						variant = ButtonVariant.Emphasis,
						size = InputSize.Medium,
						text = v53 and v76.resendCodeText or v76.resendCodeTimerText,
						width = UDim.new(1, 0),
						onActivated = function() -- line: 491
							-- upvalues: v45 (copy), ResendCode (copy), v46 (copy), v41 (copy), v73 (copy), Logger (copy), HttpService (copy), v60 (copy), Constants (copy), v54 (copy), v56 (copy), v51 (copy), v52 (copy), v57 (copy)
							v45(ResendCode(v46, {
								recoverySessionId = v41.state.recoverySessionId,
								contactMethodNumber = v73
							})):andThen(function(p8) -- line: 278
								-- upvalues: Logger (copy), HttpService (copy), v60 (copy), Constants (copy)
								if p8.isError then
									Logger:warning("Error resending code: {}", HttpService:JSONEncode(p8))
									v60(p8.errorKey or Constants.UnknownErrorKey)

									return
								end
							end)
							v54(false)
							v56(Constants.SecondsBetweenResends)

							if v51 then
								v52(false)

								if v57 then
									task.cancel(v57)
								end
							end

							v52(true)
						end,
						isDisabled = not v53 or v63
					}),
					ResendErrorTextSpacing = React.createElement("Frame", {
						LayoutOrder = 14,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, v43.Size.Size_200)
					}),
					ResendErrorTextLabel = React.createElement(FoundationText, {
						LayoutOrder = 15,
						Text = v76.resendErrorText or "",
						fontStyle = v43.Typography.CaptionSmall,
						textStyle = v43.Color.System.Alert,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center
					}),
					Modal = GetFFlagEnableSkipPasswordReset() and getModal(v41.state.modalStateAndProps)
				})
			})
		})
	})
end
