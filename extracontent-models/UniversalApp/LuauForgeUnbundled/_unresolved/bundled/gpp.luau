local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local module = require("@luauforge/bundled/gnx")
local module2 = require("@luauforge/bundled/gnz")
local module3 = require("@luauforge/bundled/gow")

local useDesignTokens = require("@luauforge/bundled/gox").useDesignTokens
local useLocalization = require("@luauforge/bundled/goy").Hooks.useLocalization
local useDispatch = require("@luauforge/bundled/gnC").Hooks.RoactRodux.useDispatch
local useRoactService = require("@luauforge/bundled/gnP").useRoactService

local roactNetworking = require("@luauforge/bundled/gnQ").RoactNetworking

local fullscreenPageWithSafeArea = module3.FullscreenPageWithSafeArea
local useStyle = module2.Core.Style.useStyle
local styledTextLabel = module2.App.Text.StyledTextLabel

local module4 = require("@luauforge/bundled/goz")
local text = module4.Text
local textInput = module4.TextInput
local button = module4.Button
local buttonVariant = module4.Enums.ButtonVariant
local inputSize = module4.Enums.InputSize
local useTokens = module4.Hooks.useTokens
local scrollView = module4.ScrollView
local visibility = module4.Enums.Visibility

local logger = require("@luauforge/bundled/gnM").Logger

local getFFlagEnableContinueRecovery = require("@luauforge/bundled/god").GetFFlagEnableContinueRecovery

local useClearFocusOnUnmount = require("@luauforge/bundled/goA").useClearFocusOnUnmount

local module5 = require("@luauforge/bundled/gnU")
local module6 = require("@luauforge/bundled/gpq")
local module7 = require("@luauforge/bundled/gps")
require("@luauforge/bundled/gnE")
local module8 = require("@luauforge/bundled/goc")
local module9 = require("@luauforge/bundled/goH")
local module10 = require("@luauforge/bundled/gnG")
local module11 = require("@luauforge/bundled/goO")
local module12 = require("@luauforge/bundled/gnH")
local module13 = require("@luauforge/bundled/gou")
local module14 = require("@luauforge/bundled/gnF")
local module15 = require("@luauforge/bundled/goQ")
local module16 = require("@luauforge/bundled/gpl")
local module17 = require("@luauforge/bundled/goK")

return function(p2)
	local v5 = module.useContext(module5)

	local v6 = useStyle()
	local v7 = useTokens()
	local v8 = useDesignTokens()
	local v9 = useDispatch()
	local v10 = useRoactService(roactNetworking)

	local state, setState = module.useState("")
	local state2, setState2 = module.useState("")

	local state3, setState3 = module.useState(true)
	local state4, setState4 = module.useState(false)
	local state5, setState5 = module.useState(module8.SecondsBetweenResends)
	local state6, setState6 = module.useState(nil)

	local state7, setState7 = module.useState("")
	local state8, setState8 = module.useState("")
	local state9, setState9 = module.useState(false)

	local state10, setState10 = module.useState(Vector2.new(0, 0))

	useClearFocusOnUnmount()

	local v11 = 0
	local v12 = ""
	local v13 = ""
	local v14 = ""
	local param = p2.navigation.getParam("identifierInfo")
	local v15

	if param.identifierType == module12.Username then
		v11 = param.userId
		v12 = param.username
		v13 = param.displayName
		v15 = true
	else
		v14 = param.contactMethod
		v15 = false
	end

	local v16 = p2.navigation.getParam("contactMethodNumber") or 0

	module.useEffect(function()
		local function updateTimer()
			while state3 do
				task.wait(1)
				setState5(function(p3)
					local v17 = p3 - 1

					if v17 <= 0 then
						setState4(true)
						setState3(false)
						return 0
					end

					return v17
				end)
			end
		end

		if state3 then
			setState6((task.spawn(updateTimer)))
		end

		return function()
			setState3(false)

			if state6 then
				task.cancel(state6)
			end
		end
	end, { state3 })

	local function resetTimer()
		setState4(false)
		setState5(module8.SecondsBetweenResends)

		if state3 then
			setState3(false)

			if state6 then
				task.cancel(state6)
			end
		end

		setState3(true)
	end

	local function fn(p3, data, fn2)
		if data == nil then
			fn2(module8.UnknownErrorKey)
		elseif data.recoveryState == module14.RECOVERY_STATE_CONTACT_METHOD_VERIFICATION_REQUIRED then
			p2.navigation.navigate(module13.SendCodeScreen, {
				userID = p3,
				isSecondContactMethodVerification = true,
				previousRecoveryMethod = data.previousRecoveryMethod,
				previousRecoveryMethodTypes = data.previousRecoveryMethodTypes,
				nextRecoveryMethodTypes = data.nextRecoveryMethodTypes
			})
		elseif data.recoveryState == module14.RECOVERY_STATE_ACCOUNT_VERIFIED then
			if v16 == 0 and v5.state.recover2sv then
				p2.navigation.replace(module13.AccountVerifiedConfirmationScreen, {
					userID = p3
				})
			elseif module16() and v5.state.recover2sv and not v5.state.recoverPassword then
				v5.utils.handleUpdatePassword(
					v5.state.recoverySessionId,
					p3,
					v12,
					"",
					"",
					fn2,
					v5.utils.launchAppOrGoBack
				)
			else
				p2.navigation.replace(module13.ChooseAccountScreen, { userID = p3 })
			end
		elseif data.recoveryState == module14.RECOVERY_STATE_AWAITING_REEVALUATION then
			p2.navigation.navigate(module13.CannotRecoverAccountScreen, { userID = p3 })
		else
			fn2(module8.UnknownErrorKey)
		end
	end

	module.useEffect(function()
		if #state == module8.VerificationCodeLength then
			setState9(true)
			local focusedTextBox = UserInputService:GetFocusedTextBox()

			if focusedTextBox then
				focusedTextBox:ReleaseFocus()
			end

			setState2(state)
			v9(module6(v10, {
				recoverySessionId = v5.state.recoverySessionId,
				code = state,
				contactMethodNumber = v16
			})):andThen(function(p3)
				if p3.isError then
					logger:warning("Error verifying code: {}", HttpService:JSONEncode(p3))
					setState8(p3.errorKey or module8.UnknownErrorKey)
					setState9(false)
				elseif getFFlagEnableContinueRecovery() and v15 then
					local function fn2(p4)
						p2.navigation.replace(module13.ContinueFallbackScreen, {
							userID = v11,
							displayName = v13,
							username = v12,
							didAbandon2SV = false,
							contactMethodNumber = v16
						})
					end
					v5.utils.handleContinueRecovery(v5.state.recoverySessionId, v11, function(p4)
						fn(v11, p4, fn2)
					end, fn2, function()
						p2.navigation.replace(module13.ContinueFallbackScreen, {
							userID = v11,
							displayName = v13,
							username = v12,
							didAbandon2SV = true,
							contactMethodNumber = v16
						})
					end)
				else
					p2.navigation.replace(module13.ChooseAccountScreen, { userID = v11 })

					setState9(false)
				end
			end):finally(function()
				setState2("")
			end)
		end
	end, { state })

	local function fn2(p3)
		if state10 ~= p3.AbsoluteSize then
			setState10(p3.AbsoluteSize)
		end
	end

	local v18 = {
		recoveryHeadingText = "Authentication.AccountRecovery.Heading.RobloxAccountRecovery",
		emailCodeSentText = "Authentication.AccountRecovery.Description.EmailCodeSent",
		emailCodeSentForUserText = "Authentication.AccountRecovery.Description.EmailCodeSentForUser",
		phoneCodeSentText = "Authentication.AccountRecovery.Description.PhoneCodeSent",
		phoneCodeSentForUserText = "Authentication.AccountRecovery.Description.PhoneCodeSentForUser",
		enterCodeText = "Authentication.AccountRecovery.Label.EnterCode",
		resendCodeTimerText = {
			"Authentication.AccountRecovery.Label.ResendCodeTimer",
			timeLeft = `{state5}`
		},
		resendCodeText = "Authentication.AccountRecovery.Label.ResendCode",
		codeErrorText = 0,
		resendErrorText = 0
	}
	local v19 = if state8 ~= "" then state8 else nil
	v18.codeErrorText = v19

	if state7 == "" then
		state7 = nil
	end

	v18.resendErrorText = state7
	local v20 = useLocalization(v18)

	local v21 = ""

	if param.contactMethodType == module10.Email then
		v21 = v15 and v20.emailCodeSentForUserText or v20.emailCodeSentText
	elseif param.contactMethodType == module10.Phone then
		v21 = v15 and v20.phoneCodeSentForUserText or v20.phoneCodeSentText
	end

	local createElement = module.createElement
	local v23 = {
		includeStatusBar = true,
		BackgroundColor3 = v6.Theme.BackgroundDefault.Color
	}
	local v24 = {
		UIPadding = module.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v8.Size.Size_200),
			PaddingLeft = UDim.new(0, v8.Size.Size_300),
			PaddingRight = UDim.new(0, v8.Size.Size_300),
			PaddingBottom = UDim.new(0, v8.Size.Size_200)
		}),
		Wrapper = 0
	}

	local createElement2 = module.createElement
	local v26 = {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0)
	}

	local createElement3 = module.createElement
	local v28 = {
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = 0
	}
	local v29 = if module17() then Enum.HorizontalAlignment.Center else nil
	v28.HorizontalAlignment = v29
	v24.Wrapper = createElement2("Frame", v26, {
		UIListLayout = createElement3("UIListLayout", v28),
		Header = module.createElement(module9, {
			LayoutOrder = 1,
			onBackActivated = function()
				p2.navigation.goBack()
			end,
			backButtonDisabled = state9,
			recoveryHeadingText = v20.recoveryHeadingText,
			currentComponent = "resendOrVerifyCode",
			recoverySessionId = v5.state.recoverySessionId
		}),
		Content = module.createElement(
			"Frame",
			{
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			},
			{
				UISizeConstraint = module17() and module.createElement("UISizeConstraint", {
					MaxSize = Vector2.new(module8.ContentMaxWidth, 1e999)
				}),
				UIListLayout = module.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical
				}),
				PreScrollContent = module.createElement("Frame", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0),
					[module.Change.AbsoluteSize] = fn2
				}, {
					UIPadding = module.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, v8.Size.Size_200),
						PaddingRight = UDim.new(0, v8.Size.Size_200)
					}),
					UIListLayout = module.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						Padding = UDim.new(0, v8.Size.Size_50)
					}),
					RecoveryHeadingSpacing = module.createElement("Frame", {
						LayoutOrder = 1,
						Size = UDim2.new(1, 0, 0, v8.Size.Size_500),
						BackgroundTransparency = 1
					})
				}),
				InputsOverflowScrollView = module.createElement(scrollView, {
					LayoutOrder = 2,
					scroll = {
						AutomaticCanvasSize = Enum.AutomaticSize.Y,
						CanvasSize = UDim2.new(1, 0, 0, 0),
						ScrollingDirection = Enum.ScrollingDirection.Y,
						scrollBarVisibility = visibility.Always
					},
					Size = UDim2.new(1, 0, 1, -state10.Y)
				}, {
					UIPadding = module.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, v8.Size.Size_200),
						PaddingRight = UDim.new(0, v8.Size.Size_200)
					}),
					UIListLayout = module.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						Padding = UDim.new(0, v8.Size.Size_50)
					}),
					UserHeader = v15 and module.createElement(module11, {
						LayoutOrder = 2,
						userId = `{v11}`,
						displayName = v13,
						username = v12
					}),
					ContactMethodHeader = not v15 and module.createElement(text, {
						Text = v14,
						LayoutOrder = 3,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						fontStyle = v7.Typography.HeadingSmall,
						textStyle = v7.Color.Content.Emphasis,
						TextXAlignment = Enum.TextXAlignment.Center,
						TextYAlignment = Enum.TextYAlignment.Center
					}),
					HeaderSpacing = module.createElement("Frame", {
						LayoutOrder = 4,
						Size = UDim2.new(1, 0, 0, v7.Size.Size_400),
						BackgroundTransparency = 1
					}),
					BodyText = module.createElement(text, {
						LayoutOrder = 5,
						Text = v21,
						TextWrapped = true,
						fontStyle = v7.Typography.BodyMedium,
						textStyle = v7.Color.Content.Default,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center
					}),
					BodyTextSpacing = module.createElement("Frame", {
						LayoutOrder = 6,
						Size = UDim2.new(1, 0, 0, v8.Size.Size_300),
						BackgroundTransparency = 1
					}),
					EnterCodeLabel = module.createElement(styledTextLabel, {
						layoutOrder = 7,
						text = v20.enterCodeText,
						fontStyle = v7.Typography.TitleMedium,
						colorStyle = v6.Theme.TextEmphasis,
						automaticSize = Enum.AutomaticSize.XY
					}),
					EnterCodeLabelSpacing = module.createElement("Frame", {
						LayoutOrder = 8,
						Size = UDim2.new(1, 0, 0, v8.Size.Size_100),
						BackgroundTransparency = 1
					}),
					EnterCodeField = module.createElement(textInput, {
						LayoutOrder = 9,
						text = state2,
						label = "",
						width = UDim.new(1, 0),
						textInputType = Enum.TextInputType.OneTimePassword,
						onChanged = function(p3)
							if state8 ~= "" then
								setState8("")
							end

							setState(p3)
						end,
						isDisabled = state9,
						size = inputSize.Medium
					}),
					ErrorTextSpacing = module.createElement("Frame", {
						LayoutOrder = 10,
						Size = UDim2.new(1, 0, 0, v7.Size.Size_200),
						BackgroundTransparency = 1
					}),
					ErrorTextLabel = module.createElement(text, {
						Text = v20.codeErrorText or "",
						fontStyle = v7.Typography.CaptionSmall,
						textStyle = v7.Color.System.Alert,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center,
						LayoutOrder = 11
					}),
					ResendCodeButtonSpacing = module.createElement("Frame", {
						LayoutOrder = 12,
						Size = UDim2.new(1, 0, 0, v7.Size.Size_300),
						BackgroundTransparency = 1
					}),
					ResendCodeButton = module.createElement(button, {
						LayoutOrder = 13,
						variant = buttonVariant.Emphasis,
						size = inputSize.Medium,
						text = state4 and v20.resendCodeText or v20.resendCodeTimerText,
						width = UDim.new(1, 0),
						onActivated = function()
							v9(module7(v10, {
								recoverySessionId = v5.state.recoverySessionId,
								contactMethodNumber = v16
							})):andThen(function(p3)
								if not p3.isError then
									return
								end

								logger:warning("Error resending code: {}", HttpService:JSONEncode(p3))
								setState7(p3.errorKey or module8.UnknownErrorKey)
							end)
							setState4(false)
							setState5(module8.SecondsBetweenResends)

							if state3 then
								setState3(false)

								if state6 then
									task.cancel(state6)
								end
							end

							setState3(true)
						end,
						isDisabled = not state4 or state9
					}),
					ResendErrorTextSpacing = module.createElement("Frame", {
						LayoutOrder = 14,
						Size = UDim2.new(1, 0, 0, v7.Size.Size_200),
						BackgroundTransparency = 1
					}),
					ResendErrorTextLabel = module.createElement(text, {
						Text = v20.resendErrorText or "",
						fontStyle = v7.Typography.CaptionSmall,
						textStyle = v7.Color.System.Alert,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center,
						LayoutOrder = 15
					}),
					Modal = module16() and module15(v5.state.modalStateAndProps)
				})
			}
		)
	})
	return createElement(fullscreenPageWithSafeArea, v23, v24)
end
