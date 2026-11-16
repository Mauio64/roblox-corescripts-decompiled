local AccountUpgrade = script:FindFirstAncestor("AccountUpgrade")
local parent = AccountUpgrade.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local AuthCommon = require(parent.AuthCommon)
local AuthSignup = require(parent.AuthSignup)
local SharedFlags = require(parent.SharedFlags)
local UsernameFieldWithSuggestions = require(script.Parent.UsernameFieldWithSuggestions)
local AccountUpgradeFieldError = require(script.Parent.AccountUpgradeFieldError)
local AccountUpgradeField = require(AccountUpgrade.AccountUpgradeField)
require(AccountUpgrade.Utils.resolveFieldStates)

local GetFFlagAuthCollapsingValidatorFoundationInput = SharedFlags.GetFFlagAuthCollapsingValidatorFoundationInput

local CollapsingTextInputValidator = AuthSignup.Components.CollapsingTextInputValidator
local PasswordValidator = AuthSignup.Thunks.PasswordValidator

local View = Foundation.View
local Text = Foundation.Text
local Icon = Foundation.Icon
local InputLabel = Foundation.InputLabel
local TextInput = Foundation.TextInput
local Chip = Foundation.Chip

local InputSize = Foundation.Enums.InputSize
local InputLabelSize = Foundation.Enums.InputLabelSize
local ChipSize = Foundation.Enums.ChipSize
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize

local UIConstants = AuthCommon.Common.UIConstants
local UserGender = AuthCommon.Enums.UserGender
local formatBoldRichText = AuthCommon.Utils.formatBoldRichText

local function AccountUpgradeFields(props)
	local form = props.form
	local v = props.size == InputSize.Large
	local v2 = if v then InputSize.Large else InputSize.Medium
	local v3 = if v then InputLabelSize.Large else InputLabelSize.Medium
	local size = if v then ChipSize.Large else ChipSize.Medium
	local v4 = Foundation.Hooks.useTokens()
	local isChecked = form.gender == UserGender.Female
	local isChecked2 = form.gender == UserGender.Male

	local fFlagAuthCollapsingValidatorFoundationInput = GetFFlagAuthCollapsingValidatorFoundationInput()

	local color3 = v4.Color.Content.Default.Color3
	local fieldStates = form.fieldStates
	local v5 = props.boldLabels == true or form.boldFieldLabels == true
	local function labelText(p: string) -- 3 equivalent calls inferred from this helper
		if v5 then
			return (formatBoldRichText(p))
		end

		return p
	end

	local createElement = React.createElement
	local v6 = { tag = "col gap-large size-full-0 auto-y", LayoutOrder = props.LayoutOrder }
	local birthdayField

	if fieldStates[AccountUpgradeField.Birthday] ~= nil then
		local createElement2 = React.createElement

		local children = {
			Label = React.createElement(InputLabel, {
				Text = labelText(form.birthdayLabel), -- inferred equivalent call
				RichText = v5,
				isRequired = true,
				size = v3,
				LayoutOrder = 1,
				testId = "AccountUpgradeBirthdayLabel"
			}),
			BirthdayButton = 0
		}

		local createElement3 = React.createElement
		local v7 = {
			tag = {
				["row flex-between align-y-center padding-medium stroke-standard stroke-position-inner radius-medium stroke-emphasis"] = true,
				["size-full-1000"] = not v,
				["size-full-1200"] = v
			},
			onActivated = form.onBirthdayActivated,
			LayoutOrder = 2,
			testId = "AccountUpgradeBirthdayField"
		}

		local createElement4 = React.createElement
		local text

		if form.birthdayText == "" then
			text = form.birthdayPlaceholder
		else
			text = form.birthdayText
		end

		children.BirthdayButton = createElement3(View, v7, {
			Text = createElement4(Text, {
				Text = text,
				tag = {
					["auto-xy text-align-x-left"] = true,
					["text-body-medium"] = not v,
					["text-body-large"] = v,
					["content-emphasis"] = form.birthdayText ~= "",
					["content-muted"] = form.birthdayText == ""
				},
				LayoutOrder = 1
			}),
			CalendarIcon = React.createElement(Icon, {
				name = IconName.Calendar,
				size = IconSize.Small,
				style = v4.Color.Content.Muted,
				LayoutOrder = 2,
				testId = "AccountUpgradeBirthdayIcon"
			})
		})
		birthdayField = createElement2(View, {
			tag = "col gap-small size-full-0 auto-y",
			LayoutOrder = 1
		}, children)
	end

	local usernameField

	if fieldStates[AccountUpgradeField.Username] ~= nil then
		usernameField = React.createElement(UsernameFieldWithSuggestions, {
			LayoutOrder = 2,
			titleTextKey = form.usernameTitleTextKey,
			isTitleBold = v5,
			inputSize = v2,
			titleSize = v3,
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
			contentGap = v4.Gap.Small,
			colorContentOverride = color3
		})
	end

	local passwordField

	if fieldStates[AccountUpgradeField.Password] ~= nil then
		local createElement2 = React.createElement

		local createElement3 = React.createElement
		local v7 = {
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
		local textInputType

		if form.hidePassword then
			textInputType = Enum.TextInputType.Password
		else
			textInputType = Enum.TextInputType.PasswordShown
		end

		v7.textInputType = textInputType

		v7.returnKeyType = Enum.ReturnKeyType.Next
		v7.validator = PasswordValidator
		v7.validatorAdditionalProps = form.passwordValidatorAdditionalProps
		v7.onInputTextChanged = form.onPasswordChanged
		v7.onInputTextValidated = form.onPasswordValidated
		v7.textBoxFocusedCallback = form.onPasswordFocused
		v7.useFoundationTextInput = fFlagAuthCollapsingValidatorFoundationInput

		v7.foundationInputSize = v2
		v7.foundationTitleSize = v3

		v7.foundationTitleIsBold = v5
		local name

		if form.hidePassword then
			name = UIConstants.HIDE_PASSWORD_ICON
		else
			name = UIConstants.SHOW_PASSWORD_ICON
		end

		v7.foundationIconTrailing = { name = name, onActivated = form.onPasswordVisibilityToggle }

		v7.contentGapOverride = v4.Gap.Small

		v7.colorContentOverride = color3
		passwordField = createElement2(
			View,
			{
				tag = "col size-full-0 auto-y",
				LayoutOrder = 3,
				testId = "AccountUpgradePasswordField"
			},
			{
				Validator = createElement3(CollapsingTextInputValidator, v7)
			}
		)
	end

	local emailField

	if fieldStates[AccountUpgradeField.Email] ~= nil then
		emailField = React.createElement(View, {
			tag = "col gap-small size-full-0 auto-y",
			LayoutOrder = 4
		}, {
			Label = React.createElement(InputLabel, {
				Text = labelText(form.emailLabel), -- inferred equivalent call
				RichText = v5,
				size = v3,
				LayoutOrder = 1,
				testId = "AccountUpgradeEmailLabel"
			}),
			Input = React.createElement(TextInput, {
				text = form.email,
				placeholder = form.emailPlaceholder,
				textInputType = Enum.TextInputType.Email,
				onChanged = form.onEmailChanged,
				hasError = form.emailError ~= nil and form.emailError ~= "",
				label = "",
				width = UDim.new(1, 0),
				size = v2,
				LayoutOrder = 2,
				testId = "AccountUpgradeEmailInput"
			}),
			Error = React.createElement(AccountUpgradeFieldError, {
				text = form.emailError,
				LayoutOrder = 3
			})
		})
	end

	local genderField

	if fieldStates[AccountUpgradeField.Gender] ~= nil then
		genderField = React.createElement(View, {
			tag = "col gap-small size-full-0 auto-y",
			LayoutOrder = 5
		}, {
			Label = React.createElement(InputLabel, {
				Text = labelText(form.genderLabel), -- inferred equivalent call
				RichText = v5,
				size = v3,
				LayoutOrder = 1,
				testId = "AccountUpgradeGenderLabel"
			}),
			Options = React.createElement(View, {
				tag = "row gap-small size-full-0 auto-y",
				LayoutOrder = 2
			}, {
				Female = React.createElement(Chip, {
					text = form.femaleText,
					leading = IconName.HeadFemale,
					size = size,
					isChecked = isChecked,
					onActivated = function()
						local onGenderChanged = form.onGenderChanged
						local v7

						if isChecked then
							v7 = UserGender.Unknown
						else
							v7 = UserGender.Female
						end

						onGenderChanged(v7)
					end,
					LayoutOrder = 1,
					testId = "AccountUpgradeGenderFemale"
				}),
				Male = React.createElement(Chip, {
					text = form.maleText,
					leading = IconName.HeadMale,
					size = size,
					isChecked = isChecked2,
					onActivated = function()
						local onGenderChanged = form.onGenderChanged
						local v7

						if isChecked2 then
							v7 = UserGender.Unknown
						else
							v7 = UserGender.Male
						end

						onGenderChanged(v7)
					end,
					LayoutOrder = 2,
					testId = "AccountUpgradeGenderMale"
				})
			})
		})
	end

	return createElement(View, v6, {
		BirthdayField = birthdayField,
		UsernameField = usernameField,
		PasswordField = passwordField,
		EmailField = emailField,
		GenderField = genderField
	})
end

return AccountUpgradeFields
