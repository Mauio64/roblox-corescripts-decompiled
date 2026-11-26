local HttpService = game:GetService("HttpService")

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
local divider = module4.Divider
local dividerVariant = module4.Enums.DividerVariant
local orientation = module4.Enums.Orientation
local useTokens = module4.Hooks.useTokens
local scrollView = module4.ScrollView
local visibility = module4.Enums.Visibility
local systemBanner = module4.SystemBanner
local alertVariant = module4.Enums.AlertVariant
local alertSeverity = module4.Enums.AlertSeverity

local logger = require("@luauforge/bundled/gnM").Logger

local useClearFocusOnUnmount = require("@luauforge/bundled/goA").useClearFocusOnUnmount

local getUserById = require("@luauforge/bundled/gnT").Thunks.GetUserById

local module5 = require("@luauforge/bundled/gnU")
local module6 = require("@luauforge/bundled/goE")
local module7 = require("@luauforge/bundled/goM")
require("@luauforge/bundled/gnE")
local module8 = require("@luauforge/bundled/goc")
local module9 = require("@luauforge/bundled/goG")
local module10 = require("@luauforge/bundled/goH")
local module11 = require("@luauforge/bundled/gnG")
local module12 = require("@luauforge/bundled/goO")
local module13 = require("@luauforge/bundled/goQ")
local module14 = require("@luauforge/bundled/goI")
local module15 = require("@luauforge/bundled/gnH")
local module16 = require("@luauforge/bundled/gnI")
local module17 = require("@luauforge/bundled/gos")
local module18 = require("@luauforge/bundled/gou")
local module19 = require("@luauforge/bundled/gnF")
require("@luauforge/bundled/gnK")
local module20 = require("@luauforge/bundled/gop")
local module21 = require("@luauforge/bundled/goW")
local module22 = require("@luauforge/bundled/gpl")
local module23 = require("@luauforge/bundled/goK")

local function derivePreviousContactMethodType(p2, param)
	if not p2 or (not param or #param == 0) then
		return nil
	end

	for i, item in ipairs(param) do
		if item == module16.Phone then
			return module11.Phone
		end
	end

	return module11.Email
end

local function recoveryMethodTypesToInputTypes(param)
	if not param then
		return nil
	end

	local flag = false
	local v5 = {}
	local flag2 = false
	local flag3 = false

	for i, item in ipairs(param) do
		if
			item == module16.CurrentEmail
			or item == module16.BillingEmail
			or item == module16.HistoricalEmail
		then
			flag = true
		elseif item == module16.Phone then
			flag2 = true
		elseif item == module16.BackupCode then
			flag3 = true
		end
	end

	if flag then
		table.insert(v5, module17.Email)
	end

	if flag2 then
		table.insert(v5, module17.Phone)
	end

	if flag3 then
		table.insert(v5, module17.BackupCode)
	end

	return v5
end

local function deriveInitialRecoveryMethodInputType(p2, list)
	if not (p2 and module21()) then
		return module17.Email
	end

	if list and #list == 1 and list[1] == module17.BackupCode then
		return module17.BackupCode
	end

	if list and table.find(list, module17.Phone) ~= nil then
		return module17.Phone
	end

	return module17.Email
end

local function deriveSecondContactBannerDescription(p2, p3, p4, data)
	if p2 then
		if p3 == module17.BackupCode then
			return data.enterBackupCodeText
		end

		if p3 == module17.Phone then
			return data.enterPhoneNumberText
		end

		return data.enterEmailAddressText
	elseif p4 == module11.Phone then
		return data.enterEmailAddressText
	else
		return data.enterPhoneOrAnotherEmailText
	end
end

local function resolveInitialRecoveryMethodInputType(p2, p3, list)
	if p3 and module21() and p2 ~= nil and list and table.find(list, p2) ~= nil then
		return p2
	end

	return deriveInitialRecoveryMethodInputType(p3, list)
end

local function createElementIf(p2, callback)
	if p2 then
		return callback()
	end

	return nil
end

return function(p2)
	local v5 = module.useContext(module5)

	local v6 = useStyle()
	local v7 = useTokens()
	local v8 = useDesignTokens()
	local v9 = useDispatch()
	local v10 = useRoactService(roactNetworking)

	local state, setState = module.useState("")
	local state2, setState2 = module.useState("")

	local state3, setState3 = module.useState("")
	local state4, setState4 = module.useState(1)

	local state5, setState5 = module.useState(false)
	local state6, setState6 = module.useState("")

	local state7, setState7 = module.useState(Vector2.new(0, 0))

	local param = p2.navigation.getParam("userID")
	local v11 = p2.navigation.getParam("isSecondContactMethodVerification") or false
	local v12 = p2.navigation.getParam("previousRecoveryMethod") or ""
	local param2 = p2.navigation.getParam("previousRecoveryMethodTypes")
	local param3 = p2.navigation.getParam("nextRecoveryMethodTypes")
	local v13 = p2.navigation.getParam("closeRecoveryOnBack") or false

	local param4 = p2.navigation.getParam("recoveryMethodInputTypeOverride")

	local v14 = derivePreviousContactMethodType(v11, param2)
	local v15

	if v11 and v14 == module11.Phone then
		v15 = { module17.Email }
	else
		v15 = { module17.Email, module17.Phone }
	end

	if module21() then
		v15 = recoveryMethodTypesToInputTypes(param3)
	end

	local v16 = not v11 or v15 and table.find(v15, module17.Phone) ~= nil

	local v17 = not v11 or v15 and table.find(v15, module17.Email) ~= nil

	local v18 = v15
	local v19

	if v11 and module21() and param4 ~= nil and v18 and table.find(v18, param4) ~= nil then
		v19 = param4
	else
		v19 = deriveInitialRecoveryMethodInputType(v11, v18)
	end

	local state8, setState8 = module.useState(v19)

	local function resetSendCodeFormAfterNavigate()
		setState8(v19)
		setState3("")
		setState5(false)
		setState6("")
	end

	module.useEffect(function()
		local param5 = p2.navigation.getParam("recoveryMethodInputTypeOverride")

		if param5 ~= nil and v15 and table.find(v15, param5) ~= nil then
			setState8(param5)
			setState3("")
		end
	end, { param4 })

	local v20 = not (param == nil) and param ~= 0
	local v21 = v20 and not v11
	local v22 = module21() and v11

	useClearFocusOnUnmount()

	module.useEffect(function()
		if v20 then
			getUserById(v10, param):andThen(function(p3)
				setState2(p3.name)
				setState(p3.displayName)
			end):catch(function(p3)
				logger:warning("Error getting user info: {}", p3)
			end)
		end
	end, {})

	local function fn(fn2)
		setState5(true)
		setState6("")
		local identifierType = module14.getIdentifierType(state3, state8 == module17.Phone)

		local identifierTypeToContactMethodType = module14.identifierTypeToContactMethodType(identifierType)
		local formatIdentifier = module14.formatIdentifier(
			state3,
			identifierType,
			v5.state.phonePrefixList[state4]
		)

		module20.sendContactMethodSentEvent(v5.state.recoverySessionId, identifierType)
		v9(module6(v10, {
			recoverySessionId = v5.state.recoverySessionId,
			contactMethod = formatIdentifier,
			contactMethodType = identifierTypeToContactMethodType,
			contactMethodNumber = v11 and 1 or 0
		})):andThen(function(p3)
			if not p3.isError then
				fn2(identifierType, identifierTypeToContactMethodType, state3)

				return
			end

			logger:warning("Error sending code: {}", HttpService:JSONEncode(p3))
			setState6(p3.errorKey or module8.UnknownErrorKey)
			setState5(false)
		end)
	end

	local function fn2(p3, p4, p5)
		if v20 then
			p2.navigation.navigate(module18.VerifyCodeScreen, {
				identifierInfo = {
					identifierType = module15.Username,
					contactMethodType = p4,
					userId = param,
					username = state2,
					displayName = state
				},
				contactMethodNumber = v11 and 1 or 0
			})
		else
			p2.navigation.navigate(module18.VerifyCodeScreen, {
				identifierInfo = {
					identifierType = p3,
					contactMethodType = p4,
					contactMethod = p5
				},
				contactMethodNumber = v11 and 1 or 0
			})
		end

		setState8(v19)
		setState3("")
		setState5(false)
		setState6("")
	end

	local function handleContinueRecoveryAfterBackupVerify(p3)
		if p3 == nil then
			setState6(module8.UnknownErrorKey)
			setState5(false)
		elseif p3.recoveryState == module19.RECOVERY_STATE_ACCOUNT_VERIFIED then
			local v23 = param

			if module22() and v5.state.recover2sv and not v5.state.recoverPassword then
				v5.utils.handleUpdatePassword(v5.state.recoverySessionId, v23, state2, "", "", function(p4)
					setState6(p4 or module8.UnknownErrorKey)
					setState5(false)
				end, v5.utils.launchAppOrGoBack)

				return
			end

			p2.navigation.navigate(module18.ChooseAccountScreen, { userID = v23 })
			setState8(v19)
			setState3("")
			setState5(false)
			setState6("")
		else
			setState6(module8.UnknownErrorKey)
			setState5(false)
		end
	end

	local function attemptVerifyBackupCode()
		if not v20 then
			setState6(module8.UnknownErrorKey)
			return
		end

		setState5(true)
		setState6("")

		v9(module7(v10, {
			recoverySessionId = v5.state.recoverySessionId,
			backupCode = state3
		})):andThen(function(p3)
			if not p3.isError then
				v5.utils.handleContinueRecovery(
					v5.state.recoverySessionId,
					param,
					handleContinueRecoveryAfterBackupVerify,
					function(p4)
						setState6(module8.UnknownErrorKey)
						setState5(false)
					end,
					function()
						setState6(module8.UnknownErrorKey)
						setState5(false)
					end
				)

				return
			end

			logger:warning("Error verifying backup code: {}", HttpService:JSONEncode(p3))
			setState6(p3.errorKey or module8.UnknownErrorKey)
			setState5(false)
		end)
	end

	local function fn3(p3)
		if state7 ~= p3.AbsoluteSize then
			setState7(p3.AbsoluteSize)
		end
	end

	local v24 = {
		recoveryHeadingText = "Authentication.AccountRecovery.Heading.RobloxAccountRecovery",
		secondMethodHeadingText = "Authentication.AccountRecovery.Heading.EnterSecondMethod",
		previousMethodVerifiedText = {
			"Authentication.AccountRecovery.Label.PreviousContactMethodVerification",
			contactMethod = v12
		},
		enterPhoneOrAnotherEmailText = "Authentication.AccountRecovery.Description.EnterPhoneOrAnotherEmail",
		enterEmailAddressText = "Authentication.AccountRecovery.Description.EnterEmailAddress",
		enterBackupCodeText = "Authentication.AccountRecovery.Description.EnterABackupCode",
		enterPhoneNumberText = "Authentication.AccountRecovery.Description.EnterPhoneNumberSecondMethod",
		phoneText = "Authentication.AccountRecovery.LabelPhone",
		emailText = "Authentication.AccountRecovery.LabelEmail",
		backupCodeText = "Authentication.AccountRecovery.Label.BackupCode",
		nextButtonText = "Authentication.AccountRecovery.Action.Next",
		sendCodeButtonText = "Authentication.AccountRecovery.Action.SendCode",
		orText = "Authentication.AccountRecovery.Label.Or",
		usePhoneInsteadText = "Authentication.AccountRecovery.Action.UsePhoneInstead",
		useEmailInsteadText = "Authentication.AccountRecovery.Action.UseEmailInstead",
		useEmailActionText = "Authentication.AccountRecovery.Action.UseEmail",
		useBackupCodeActionText = "Authentication.AccountRecovery.Action.UseBackupCode",
		usePhoneActionText = "Authentication.AccountRecovery.Action.UsePhone",
		useAnotherMethodText = "Authentication.AccountRecovery.Action.UseAnotherMethod",
		enterContactMethodAssociatedWithYourAccountText = "Authentication.AccountRecovery.Description.EnterContactMethodAssociatedWithYourAccount",
		sendCodeContactMethodConfirmation = "Authentication.AccountRecovery.Description.SendCodeContactMethodConfirmation",
		errorText = 0
	}
	local v25 = if state6 ~= "" then state6 else nil
	v24.errorText = v25
	local v26 = useLocalization(v24)

	local v27 = {
		enterBackupCodeText = v26.enterBackupCodeText,
		enterPhoneNumberText = v26.enterPhoneNumberText,
		enterEmailAddressText = v26.enterEmailAddressText,
		enterPhoneOrAnotherEmailText = v26.enterPhoneOrAnotherEmailText
	}
	local v28

	if v22 then
		if state8 == module17.BackupCode then
			v28 = v27.enterBackupCodeText
		else
			v28 = if state8 == module17.Phone then v27.enterPhoneNumberText else v27.enterEmailAddressText
		end
	elseif v14 == module11.Phone then
		v28 = v27.enterEmailAddressText
	else
		v28 = v27.enterPhoneOrAnotherEmailText
	end

	local function fn4()
		if v15 and #v15 > 2 then
			return v26.useAnotherMethodText
		end

		if not v15 or #v15 ~= 2 then
			return ""
		end

		if state8 == module17.Email then
			return v16 and v26.usePhoneActionText or v26.useBackupCodeActionText
		end

		if state8 == module17.BackupCode then
			return v16 and v26.usePhoneActionText or v26.useEmailActionText
		end

		return v17 and v26.useEmailActionText or v26.useBackupCodeActionText
	end

	local function onActivated()
		if v15 and #v15 > 2 then
			p2.navigation.navigate(module18.ChooseVerificationMethodScreen, {
				sendCodeRouteParams = {
					userID = param,
					isSecondContactMethodVerification = v11,
					previousRecoveryMethod = v12,
					previousRecoveryMethodTypes = param2,
					nextRecoveryMethodTypes = param3,
					closeRecoveryOnBack = v13
				}
			})

			setState3("")
		elseif v15 and #v15 == 2 then
			local v29

			if state8 == module17.Email then
				v29 = v16 and module17.Phone or module17.BackupCode
			elseif state8 == module17.BackupCode then
				v29 = v16 and module17.Phone or module17.Email
			else
				v29 = v17 and module17.Email or module17.BackupCode
			end

			module20.sendRecoveryMethodInputSwitchEvent(v5.state.recoverySessionId, v29, "sendCode")

			setState8(v29)
			setState3("")
		end
	end

	local v29

	if v22 and state8 == module17.BackupCode then
		v29 = #state3 ~= module8.BackupCodeLength
	else
		v29 = #state3 < 3
	end

	local center, v30

	if module23() then
		center = Enum.HorizontalAlignment.Center
		v30 = module.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(module8.ContentMaxWidth, 1e999)
		})
	end

	local createElement = module.createElement
	local v32 = {
		includeStatusBar = true,
		BackgroundColor3 = v6.Theme.BackgroundDefault.Color
	}
	local v33 = {
		UIPadding = module.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v8.Size.Size_200),
			PaddingLeft = UDim.new(0, v8.Size.Size_300),
			PaddingRight = UDim.new(0, v8.Size.Size_300),
			PaddingBottom = UDim.new(0, v8.Size.Size_200)
		}),
		Wrapper = 0
	}

	local createElement2 = module.createElement
	local v35 = {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0)
	}
	local v36 = {
		UIListLayout = module.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = center
		}),
		Header = module.createElement(module10, {
			LayoutOrder = 1,
			onBackActivated = function()
				if v13 then
					v5.parentNavigation.goBack()
				else
					p2.navigation.goBack()
				end
			end,
			backButtonDisabled = state5,
			recoveryHeadingText = v11 and v26.secondMethodHeadingText or v26.recoveryHeadingText,
			currentComponent = "sendCode",
			recoverySessionId = v5.state.recoverySessionId
		}),
		Content = 0
	}

	local createElement3 = module.createElement
	local v38 = {
		LayoutOrder = 2,
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0)
	}
	local children = {
		UISizeConstraint = v30,
		UIListLayout = module.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical
		}),
		PreScrollContent = module.createElement("Frame", {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0),
			[module.Change.AbsoluteSize] = fn3
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
		InputsOverflowScrollView = 0
	}

	local createElement5 = module.createElement
	local v41 = {
		LayoutOrder = 2,
		scroll = {
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.new(1, 0, 0, 0),
			ScrollingDirection = Enum.ScrollingDirection.Y,
			scrollBarVisibility = visibility.Always
		},
		Size = UDim2.new(1, 0, 1, -state7.Y)
	}
	local children2 = {
		UIPadding = module.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v8.Size.Size_200),
			PaddingRight = UDim.new(0, v8.Size.Size_200)
		}),
		UIListLayout = module.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, v8.Size.Size_50)
		}),
		UserHeader = 0,
		UserHeaderSpacing = 0,
		BodyText = 0,
		SecondContactMethodText = 0,
		SecondContactMethodTextSpacing = 0,
		PhoneDropdown = 0,
		PhoneDropdownSpacing = 0,
		ContactMethodLabel = 0,
		ContactMethodLabelSpacing = 0,
		ContactMethodField = 0,
		ErrorTextSpacing = 0,
		ErrorTextLabel = 0,
		NextButtonSpacing = 0,
		NextButton = 0,
		SwitchSecondMethodSpacing = 0,
		SwitchSecondMethodButton = 0,
		DividerSpacing = 0,
		SwitchInputDivider = 0,
		SwitchInputButtonSpacing = 0,
		SwitchInputButton = 0,
		Modal = 0
	}

	local v42 = if v21 then module.createElement(module12, {
		LayoutOrder = 2,
		userId = param,
		displayName = state,
		username = state2
	}) else nil
	children2.UserHeader = v42

	local function fn5()
		return module.createElement("Frame", {
			LayoutOrder = 3,
			Size = UDim2.new(1, 0, 0, v7.Size.Size_300),
			BackgroundTransparency = 1
		})
	end

	local v43 = if v21 then fn5() else nil

	children2.UserHeaderSpacing = v43

	children2.BodyText = not v11 and module.createElement(text, {
		LayoutOrder = 4,
		Text = v21 and v26.enterContactMethodAssociatedWithYourAccountText or v26.sendCodeContactMethodConfirmation,
		TextWrapped = true,
		fontStyle = v7.Typography.BodyMedium,
		textStyle = v7.Color.Content.Default,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		padding = { bottom = UDim.new(0, v7.Size.Size_300) }
	})

	children2.SecondContactMethodText = v11 and module.createElement(systemBanner, {
		LayoutOrder = 5,
		severity = alertSeverity.Info,
		variant = alertVariant.Standard,
		title = v26.previousMethodVerifiedText,
		description = v28
	})

	children2.SecondContactMethodTextSpacing = v11
		and module.createElement("Frame", {
			LayoutOrder = 6,
			Size = UDim2.new(1, 0, 0, v7.Size.Size_400),
			BackgroundTransparency = 1
		})
	local v44

	if state8 == module17.Phone then
		v44 = v16 and module.createElement(module9, {
			LayoutOrder = 7,
			value = state4,
			onChange = function(p3)
				setState4(p3)
			end,
			phonePrefixList = v5.state.phonePrefixList,
			topOffset = v8.Size.Size_1600 * 3
		})
	else
		v44 = false
	end

	children2.PhoneDropdown = v44

	children2.PhoneDropdownSpacing = state8 == module17.Phone
		and v16
		and module.createElement("Frame", {
			LayoutOrder = 8,
			Size = UDim2.new(1, 0, 0, v8.Size.Size_500),
			BackgroundTransparency = 1
		})

	local createElement6 = module.createElement
	local v48

	if state8 == module17.Phone then
		v48 = v26.phoneText
	else
		v48 = if state8 == module17.BackupCode then v26.backupCodeText else v26.emailText
	end

	children2.ContactMethodLabel = createElement6(styledTextLabel, {
		layoutOrder = 9,
		text = v48,
		fontStyle = v7.Typography.TitleMedium,
		colorStyle = v6.Theme.TextEmphasis,
		automaticSize = Enum.AutomaticSize.XY
	})

	children2.ContactMethodLabelSpacing = module.createElement("Frame", {
		LayoutOrder = 10,
		Size = UDim2.new(1, 0, 0, v8.Size.Size_100),
		BackgroundTransparency = 1
	})

	local createElement7 = module.createElement
	local v50 = {
		LayoutOrder = 11,
		text = state3,
		label = "",
		width = UDim.new(1, 0),
		textInputType = 0,
		onChanged = 0,
		isDisabled = 0,
		size = 0
	}
	local v51

	if state8 == module17.Phone then
		v51 = Enum.TextInputType.Phone
	elseif state8 == module17.BackupCode then
		v51 = Enum.TextInputType.NoSuggestions
	else
		v51 = Enum.TextInputType.Email
	end

	v50.textInputType = v51
	function v50.onChanged(p3)
		if state6 ~= "" then
			setState6("")
		end

		setState3(p3)
	end
	v50.isDisabled = state5
	v50.size = inputSize.Medium
	children2.ContactMethodField = createElement7(textInput, v50)

	children2.ErrorTextSpacing = module.createElement("Frame", {
		LayoutOrder = 12,
		Size = UDim2.new(1, 0, 0, v7.Size.Size_200),
		BackgroundTransparency = 1
	})

	children2.ErrorTextLabel = module.createElement(text, {
		Text = v26.errorText or "",
		fontStyle = v7.Typography.CaptionSmall,
		textStyle = v7.Color.System.Alert,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		LayoutOrder = 13
	})

	children2.NextButtonSpacing = module.createElement("Frame", {
		LayoutOrder = 14,
		Size = UDim2.new(1, 0, 0, v7.Size.Size_300),
		BackgroundTransparency = 1
	})

	children2.NextButton = module.createElement(button, {
		LayoutOrder = 15,
		variant = buttonVariant.Emphasis,
		size = inputSize.Medium,
		text = v20 and v26.nextButtonText or v26.sendCodeButtonText,
		width = UDim.new(1, 0),
		onActivated = function()
			if v22 and state8 == module17.BackupCode then
				attemptVerifyBackupCode()
			else
				fn(fn2)
			end
		end,
		isDisabled = v29,
		isLoading = state5
	})
	local v52

	if v22 then
		if #(v15 or {}) > 1 then
			v52 = module.createElement("Frame", {
				LayoutOrder = 16,
				Size = UDim2.new(1, 0, 0, v7.Size.Size_700),
				BackgroundTransparency = 1
			})
		else
			v52 = false
		end
	else
		v52 = v22
	end

	children2.SwitchSecondMethodSpacing = v52
	local v53

	if v22 then
		if #(v15 or {}) > 1 then
			v53 = module.createElement(button, {
				LayoutOrder = 17,
				variant = buttonVariant.Standard,
				size = inputSize.Medium,
				text = fn4(),
				width = UDim.new(1, 0),
				onActivated = onActivated,
				isDisabled = state5
			})
		else
			v53 = false
		end
	else
		v53 = v22
	end

	children2.SwitchSecondMethodButton = v53

	children2.DividerSpacing = v16
		and not v22
		and module.createElement("Frame", {
			LayoutOrder = 18,
			Size = UDim2.new(1, 0, 0, v7.Size.Size_900),
			BackgroundTransparency = 1
		})

	children2.SwitchInputDivider = v16
		and not v22
		and module.createElement(
			"Frame",
			{
				LayoutOrder = 19,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			},
			{
				LabelContainer = module.createElement("Frame", {
					BackgroundColor3 = v6.Theme.BackgroundDefault.Color,
					BackgroundTransparency = 0,
					BorderSizePixel = 0,
					Position = UDim2.new(0.5, 0, 0, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					AutomaticSize = Enum.AutomaticSize.XY,
					ZIndex = 2
				}, {
					UIPadding = module.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, v8.Size.Size_200),
						PaddingRight = UDim.new(0, v8.Size.Size_200),
						PaddingTop = UDim.new(0, v8.Size.Size_50),
						PaddingBottom = UDim.new(0, v8.Size.Size_50)
					}),
					Label = module.createElement(text, {
						Text = v26.orText,
						fontStyle = v7.Typography.LabelMedium,
						textStyle = v7.Color.ActionStandard.Foreground,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						TextXAlignment = Enum.TextXAlignment.Center,
						TextYAlignment = Enum.TextYAlignment.Center
					})
				}),
				Divider = module.createElement(divider, {
					variant = dividerVariant.Default,
					orientation = orientation.Horizontal,
					ZIndex = 1
				})
			}
		)

	children2.SwitchInputButtonSpacing = v16
		and not v22
		and module.createElement("Frame", {
			LayoutOrder = 20,
			Size = UDim2.new(1, 0, 0, v7.Size.Size_700),
			BackgroundTransparency = 1
		})

	children2.SwitchInputButton = v16 and not v22 and module.createElement(button, {
		LayoutOrder = 21,
		variant = buttonVariant.Standard,
		size = inputSize.Medium,
		text = state8 == module17.Phone and v26.useEmailInsteadText or v26.usePhoneInsteadText,
		width = UDim.new(1, 0),
		onActivated = function()
			local v54 = if state8 == module17.Phone then module17.Email else module17.Phone
			module20.sendSwitchedInputEvent(v5.state.recoverySessionId, v54 == module17.Phone, "sendCode")

			setState8(v54)
			setState3("")
		end,
		isDisabled = state5
	})

	children2.Modal = module22() and module13(v5.state.modalStateAndProps)
	children.InputsOverflowScrollView = createElement5(scrollView, v41, children2)
	v36.Content = createElement3("Frame", v38, children)
	v33.Wrapper = createElement2("Frame", v35, v36)
	return createElement(fullscreenPageWithSafeArea, v32, v33)
end
