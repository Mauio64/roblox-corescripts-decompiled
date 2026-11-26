local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/Foundation")
local AuthCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AuthCommon")
local AuthSignup = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AuthSignup")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/SharedFlags")
local UsernameFieldWithSuggestions = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Components/UsernameFieldWithSuggestions")
local AccountUpgradeFieldError = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Components/AccountUpgradeFieldError")
local AccountUpgradeField = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/AccountUpgradeField")
require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Utils/resolveFieldStates")

local getFFlagAuthCollapsingValidatorFoundationInput = SharedFlags.GetFFlagAuthCollapsingValidatorFoundationInput

local collapsingTextInputValidator = AuthSignup.Components.CollapsingTextInputValidator
local passwordValidator = AuthSignup.Thunks.PasswordValidator

local view = Foundation.View
local text = Foundation.Text
local icon = Foundation.Icon
local inputLabel = Foundation.InputLabel
local textInput = Foundation.TextInput
local chip = Foundation.Chip

local inputSize = Foundation.Enums.InputSize
local inputLabelSize = Foundation.Enums.InputLabelSize
local chipSize = Foundation.Enums.ChipSize
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize

local uiConstants = AuthCommon.Common.UIConstants
local userGender = AuthCommon.Enums.UserGender
local formatBoldRichText = AuthCommon.Utils.formatBoldRichText

local function AccountUpgradeFields(props)
	local form = props.form
	local v5 = props.size == inputSize.Large
	local v6 = if v5 then inputSize.Large else inputSize.Medium
	local v7 = if v5 then inputLabelSize.Large else inputLabelSize.Medium
	local v8 = if v5 then chipSize.Large else chipSize.Medium
	local v9 = Foundation.Hooks.useTokens()
	local v10 = form.gender == userGender.Female
	local v11 = form.gender == userGender.Male

	local fFlagAuthCollapsingValidatorFoundationInput = getFFlagAuthCollapsingValidatorFoundationInput()

	local color3 = v9.Color.Content.Default.Color3
	local fieldStates = form.fieldStates
	local v12 = props.boldLabels == true or form.boldFieldLabels == true
	local function labelText(p2)
		if v12 then
			return (formatBoldRichText(p2))
		end

		return p2
	end

	local createElement = React.createElement
	local v14 = {
		tag = "col gap-large size-full-0 auto-y",
		LayoutOrder = props.LayoutOrder
	}
	local v16

	if fieldStates[AccountUpgradeField.Birthday] ~= nil then
		local createElement2 = React.createElement

		local createElement3 = React.createElement
		local birthdayLabel = form.birthdayLabel

		if v12 then
			birthdayLabel = formatBoldRichText(birthdayLabel)
		end

		local children = {
			Label = createElement3(inputLabel, {
				Text = birthdayLabel,
				RichText = v12,
				isRequired = true,
				size = v7,
				LayoutOrder = 1,
				testId = "AccountUpgradeBirthdayLabel"
			}),
			BirthdayButton = 0
		}

		local createElement4 = React.createElement
		local v22 = {
			tag = {
				["row flex-between align-y-center padding-medium stroke-standard stroke-position-inner radius-medium stroke-emphasis"] = true,
				["size-full-1000"] = not v5,
				["size-full-1200"] = v5
			},
			onActivated = form.onBirthdayActivated,
			LayoutOrder = 2,
			testId = "AccountUpgradeBirthdayField"
		}

		local createElement5 = React.createElement
		local v25 = if form.birthdayText == "" then form.birthdayPlaceholder else form.birthdayText
		children.BirthdayButton = createElement4(view, v22, {
			Text = createElement5(text, {
				Text = v25,
				tag = {
					["auto-xy text-align-x-left"] = true,
					["text-body-medium"] = not v5,
					["text-body-large"] = v5,
					["content-emphasis"] = form.birthdayText ~= "",
					["content-muted"] = form.birthdayText == ""
				},
				LayoutOrder = 1
			}),
			CalendarIcon = React.createElement(icon, {
				name = iconName.Calendar,
				size = iconSize.Small,
				style = v9.Color.Content.Muted,
				LayoutOrder = 2,
				testId = "AccountUpgradeBirthdayIcon"
			})
		})
		v16 = createElement2(view, {
			tag = "col gap-small size-full-0 auto-y",
			LayoutOrder = 1
		}, children)
	end

	local v17 = if fieldStates[AccountUpgradeField.Username] ~= nil then React.createElement(UsernameFieldWithSuggestions, {
		LayoutOrder = 2,
		titleTextKey = form.usernameTitleTextKey,
		isTitleBold = v12,
		inputSize = v6,
		titleSize = v7,
		summaryErrorTextKey = form.usernameSummaryErrorTextKey,
		isPrerequisiteMet = form.isUsernamePrerequisiteMet,
		validatorAdditionalProps = form.usernameValidatorAdditionalProps,
		placeholderText = form.usernamePlaceholder,
		username = form.username,
		prefilledUsername = form.prefilledUsername,
		suggestions = form.usernameSuggestions,
		suggestionPrompt = form.usernameSuggestionPrompt,
		eventContext = form.usernameSuggestionEventContext,
		onSuggestionSelected = form.onUsernameSuggestionSelected,
		pillClicked = form.pillClicked,
		updatePillClicked = form.updatePillClicked,
		resetPillClicked = form.resetPillClicked,
		onTextChanged = form.onUsernameChanged,
		onTextValidated = form.onUsernameValidated,
		onFocused = form.onUsernameFocused,
		onIssueConditionChanged = form.onUsernameIssueConditionChanged,
		useFoundationTextInput = fFlagAuthCollapsingValidatorFoundationInput,
		contentGap = v9.Gap.Small,
		colorContentOverride = color3
	}) else nil
	local v18

	if fieldStates[AccountUpgradeField.Password] ~= nil then
		local createElement2 = React.createElement

		local createElement3 = React.createElement
		local v23 = {
			layoutOrder = 1,
			titleTextKey = form.passwordTitleTextKey,
			summaryErrorTextKey = form.passwordSummaryErrorTextKey,
			prerequisiteMet = form.isPasswordPrerequisiteMet,
			placeholderText = form.passwordPlaceholder,
			textInputType = 0,
			returnKeyType = 0,
			validator = 0,
			validatorAdditionalProps = 0,
			onInputTextChanged = 0,
			onInputTextValidated = 0,
			textBoxFocusedCallback = 0,
			useFoundationTextInput = 0,
			useFoundationTitle = true,
			foundationInputSize = 0,
			foundationTitleSize = 0,
			foundationTitleIsRequired = true,
			foundationTitleIsBold = 0,
			foundationIconTrailing = 0,
			paddingTopOverride = 0,
			contentGapOverride = 0,
			useTrailingPadding = true,
			colorContentOverride = 0
		}
		local v24 = if form.hidePassword then Enum.TextInputType.Password else Enum.TextInputType.PasswordShown
		v23.textInputType = v24

		v23.returnKeyType = Enum.ReturnKeyType.Next
		v23.validator = passwordValidator
		v23.validatorAdditionalProps = form.passwordValidatorAdditionalProps
		v23.onInputTextChanged = form.onPasswordChanged
		v23.onInputTextValidated = form.onPasswordValidated
		v23.textBoxFocusedCallback = form.onPasswordFocused
		v23.useFoundationTextInput = fFlagAuthCollapsingValidatorFoundationInput

		v23.foundationInputSize = v6
		v23.foundationTitleSize = v7

		v23.foundationTitleIsBold = v12

		local v26 = if form.hidePassword then uiConstants.HIDE_PASSWORD_ICON else uiConstants.SHOW_PASSWORD_ICON
		v23.foundationIconTrailing = {
			name = v26,
			onActivated = form.onPasswordVisibilityToggle
		}

		v23.contentGapOverride = v9.Gap.Small

		v23.colorContentOverride = color3
		v18 = createElement2(
			view,
			{
				tag = "col size-full-0 auto-y",
				LayoutOrder = 3,
				testId = "AccountUpgradePasswordField"
			},
			{
				Validator = createElement3(collapsingTextInputValidator, v23)
			}
		)
	end

	local v19

	if fieldStates[AccountUpgradeField.Email] ~= nil then
		local createElement2 = React.createElement

		local createElement3 = React.createElement
		local emailLabel = form.emailLabel

		if v12 then
			emailLabel = formatBoldRichText(emailLabel)
		end

		v19 = createElement2(view, {
			tag = "col gap-small size-full-0 auto-y",
			LayoutOrder = 4
		}, {
			Label = createElement3(inputLabel, {
				Text = emailLabel,
				RichText = v12,
				size = v7,
				LayoutOrder = 1,
				testId = "AccountUpgradeEmailLabel"
			}),
			Input = React.createElement(textInput, {
				text = form.email,
				placeholder = form.emailPlaceholder,
				textInputType = Enum.TextInputType.Email,
				onChanged = form.onEmailChanged,
				hasError = form.emailError ~= nil and form.emailError ~= "",
				label = "",
				width = UDim.new(1, 0),
				size = v6,
				LayoutOrder = 2,
				testId = "AccountUpgradeEmailInput"
			}),
			Error = React.createElement(AccountUpgradeFieldError, {
				text = form.emailError,
				LayoutOrder = 3
			})
		})
	end

	local v20

	if fieldStates[AccountUpgradeField.Gender] ~= nil then
		local createElement2 = React.createElement

		local createElement3 = React.createElement
		local genderLabel = form.genderLabel

		if v12 then
			genderLabel = formatBoldRichText(genderLabel)
		end

		v20 = createElement2(view, {
			tag = "col gap-small size-full-0 auto-y",
			LayoutOrder = 5
		}, {
			Label = createElement3(inputLabel, {
				Text = genderLabel,
				RichText = v12,
				size = v7,
				LayoutOrder = 1,
				testId = "AccountUpgradeGenderLabel"
			}),
			Options = React.createElement(
				view,
				{ tag = "row gap-small size-full-0 auto-y", LayoutOrder = 2 },
				{
					Female = React.createElement(chip, {
						text = form.femaleText,
						leading = iconName.HeadFemale,
						size = v8,
						isChecked = v10,
						onActivated = function()
							local onGenderChanged = form.onGenderChanged
							local v25 = if v10 then userGender.Unknown else userGender.Female
							onGenderChanged(v25)
						end,
						LayoutOrder = 1,
						testId = "AccountUpgradeGenderFemale"
					}),
					Male = React.createElement(chip, {
						text = form.maleText,
						leading = iconName.HeadMale,
						size = v8,
						isChecked = v11,
						onActivated = function()
							local onGenderChanged = form.onGenderChanged
							local v25 = if v11 then userGender.Unknown else userGender.Male
							onGenderChanged(v25)
						end,
						LayoutOrder = 2,
						testId = "AccountUpgradeGenderMale"
					})
				}
			)
		})
	end

	return createElement(view, v14, {
		BirthdayField = v16,
		UsernameField = v17,
		PasswordField = v18,
		EmailField = v19,
		GenderField = v20
	})
end

return AccountUpgradeFields
