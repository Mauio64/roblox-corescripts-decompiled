local AccountUpgrade = script:FindFirstAncestor("AccountUpgrade")
local parent = AccountUpgrade.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local AuthAnalytics = require(parent.AuthAnalytics)
local AuthSignup = require(parent.AuthSignup)

local EventStreamConstants = AuthAnalytics.EventStreamConstants

local usernameSuggestionShown = AuthAnalytics.Events.usernameSuggestionShown
local FFlagAccountUpgradeOAuthTelemetry = require(AccountUpgrade.Flags.FFlagAccountUpgradeOAuthTelemetry)

local CollapsingTextInputValidator = AuthSignup.Components.CollapsingTextInputValidator
local UsernameValidator = AuthSignup.Thunks.UsernameValidator

local View = Foundation.View
local Text = Foundation.Text
local Chip = Foundation.Chip

local InputSize = Foundation.Enums.InputSize
local InputLabelSize = Foundation.Enums.InputLabelSize

local function UsernameSuggestionList(props)
	local children = {}

	for i, suggestionUsername in ipairs(props.suggestionUsernames) do
		children[`Suggestion{i}`] = React.createElement(Chip, {
			text = suggestionUsername,
			onActivated = function()
				props.onUsernameSelected(suggestionUsername)
			end,
			LayoutOrder = i
		})
	end

	React.useEffect(function()
		usernameSuggestionShown(
			props.eventContext,
			props.inputUsername,
			props.suggestionUsernames,
			EventStreamConstants.Field.Username
		)
	end, {})

	local createElement = React.createElement
	local v = {
		tag = "row align-y-top gap-small size-full-0 auto-y padding-top-large",
		LayoutOrder = props.LayoutOrder,
		testId = "AccountUpgradeUsernameSuggestions"
	}
	local prompt

	if not (props.promptText == nil or props.promptText == "") then
		prompt = React.createElement(Text, {
			Text = props.promptText,
			tag = "auto-xy text-body-small text-align-x-left content-emphasis",
			LayoutOrder = 1,
			testId = "AccountUpgradeUsernameSuggestionsPrompt"
		})
	end

	return createElement(View, v, {
		Prompt = prompt,
		Options = React.createElement(View, {
			tag = "col align-x-left gap-small auto-xy",
			LayoutOrder = 2
		}, children)
	})
end

local function UsernameFieldWithSuggestions(props)
	local ref = React.useRef(nil)
	local onSuggestionSelected = props.onSuggestionSelected
	local updatePillClicked = props.updatePillClicked
	local onUsernameSelected = React.useCallback(function(text: string)
		if updatePillClicked ~= nil then
			updatePillClicked()
		end

		local current = ref.current

		if current ~= nil then
			current.Text = text
		end

		if onSuggestionSelected ~= nil then
			onSuggestionSelected(text)
		end
	end, { onSuggestionSelected, updatePillClicked })
	local suggestions = props.suggestions or {}
	local v

	if #suggestions > 0 then
		v = onSuggestionSelected ~= nil
	else
		v = false
	end

	local createElement = React.createElement
	local v2 = {
		tag = "col size-full-0 auto-y",
		LayoutOrder = props.LayoutOrder,
		testId = "AccountUpgradeUsernameField"
	}

	local v3 = {
		Validator = React.createElement(CollapsingTextInputValidator, {
			layoutOrder = 1,
			titleTextKey = props.titleTextKey,
			summaryErrorTextKey = props.summaryErrorTextKey,
			prerequisiteMet = props.isPrerequisiteMet,
			placeholderText = props.placeholderText,
			prefilledText = props.prefilledUsername,
			textInputType = Enum.TextInputType.Username,
			returnKeyType = Enum.ReturnKeyType.Next,
			validator = UsernameValidator,
			validatorAdditionalProps = props.validatorAdditionalProps,
			onInputTextChanged = props.onTextChanged,
			onInputTextValidated = props.onTextValidated,
			textBoxFocusedCallback = props.onFocused,
			updateIssueCondition = props.onIssueConditionChanged,
			textBoxRef = ref,
			pillClicked = props.pillClicked,
			resetPillClicked = props.resetPillClicked,
			useFoundationTextInput = props.useFoundationTextInput,
			useFoundationTitle = true,
			foundationInputSize = props.inputSize or InputSize.Medium,
			foundationTitleSize = props.titleSize or InputLabelSize.Medium,
			foundationTitleIsRequired = true,
			foundationTitleIsBold = props.isTitleBold,
			paddingTopOverride = 0,
			contentGapOverride = props.contentGap,
			useTrailingPadding = true,
			colorContentOverride = props.colorContentOverride
		}),
		Suggestions = 0
	}
	local suggestions2

	if v then
		local createElement2 = React.createElement
		local v4 = {
			inputUsername = props.username,
			suggestionUsernames = suggestions,
			promptText = props.suggestionPrompt,
			eventContext = 0,
			onUsernameSelected = 0,
			LayoutOrder = 2
		}
		local eventContext

		if FFlagAccountUpgradeOAuthTelemetry and props.eventContext then
			eventContext = props.eventContext
		else
			eventContext = EventStreamConstants.Context.SinglePageSignUpScreen
		end

		v4.eventContext = eventContext

		v4.onUsernameSelected = onUsernameSelected
		suggestions2 = createElement2(UsernameSuggestionList, v4)
	end

	v3.Suggestions = suggestions2
	return createElement(View, v2, v3)
end

return UsernameFieldWithSuggestions
