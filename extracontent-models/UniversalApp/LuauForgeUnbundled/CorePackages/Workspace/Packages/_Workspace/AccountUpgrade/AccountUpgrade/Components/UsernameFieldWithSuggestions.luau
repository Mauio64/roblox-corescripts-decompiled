local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/Foundation")
local AuthAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AuthAnalytics")
local AuthSignup = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AuthSignup")

local eventStreamConstants = AuthAnalytics.EventStreamConstants

local usernameSuggestionShown = AuthAnalytics.Events.usernameSuggestionShown
local FFlagAccountUpgradeOAuthTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Flags/FFlagAccountUpgradeOAuthTelemetry")

local collapsingTextInputValidator = AuthSignup.Components.CollapsingTextInputValidator
local usernameValidator = AuthSignup.Thunks.UsernameValidator

local view = Foundation.View
local text = Foundation.Text
local chip = Foundation.Chip

local inputSize = Foundation.Enums.InputSize
local inputLabelSize = Foundation.Enums.InputLabelSize

local function UsernameSuggestionList(props)
	local children = {}

	for i, suggestionUsername in ipairs(props.suggestionUsernames) do
		children[`Suggestion{i}`] = React.createElement(chip, {
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
			eventStreamConstants.Field.Username
		)
	end, {})

	local createElement = React.createElement
	local v6 = {
		tag = "row align-y-top gap-small size-full-0 auto-y padding-top-large",
		LayoutOrder = props.LayoutOrder,
		testId = "AccountUpgradeUsernameSuggestions"
	}

	local v8 = if props.promptText ~= nil and props.promptText ~= "" then React.createElement(text, {
		Text = props.promptText,
		tag = "auto-xy text-body-small text-align-x-left content-emphasis",
		LayoutOrder = 1,
		testId = "AccountUpgradeUsernameSuggestionsPrompt"
	}) else nil
	return createElement(view, v6, {
		Prompt = v8,
		Options = React.createElement(
			view,
			{ tag = "col align-x-left gap-small auto-xy", LayoutOrder = 2 },
			children
		)
	})
end

local function UsernameFieldWithSuggestions(props)
	local ref = React.useRef(nil)
	local onSuggestionSelected = props.onSuggestionSelected
	local updatePillClicked = props.updatePillClicked
	local v5 = React.useCallback(function(text2)
		if updatePillClicked ~= nil then
			updatePillClicked()
		end

		local current = ref.current

		if current ~= nil then
			current.Text = text2
		end

		if onSuggestionSelected ~= nil then
			onSuggestionSelected(text2)
		end
	end, { onSuggestionSelected, updatePillClicked })
	local suggestions = props.suggestions or {}
	local v6 = #suggestions > 0 and onSuggestionSelected ~= nil

	local createElement = React.createElement
	local v8 = {
		tag = "col size-full-0 auto-y",
		LayoutOrder = props.LayoutOrder,
		testId = "AccountUpgradeUsernameField"
	}

	local v9 = {
		Validator = React.createElement(collapsingTextInputValidator, {
			layoutOrder = 1,
			titleTextKey = props.titleTextKey,
			summaryErrorTextKey = props.summaryErrorTextKey,
			prerequisiteMet = props.isPrerequisiteMet,
			placeholderText = props.placeholderText,
			prefilledText = props.prefilledUsername,
			textInputType = Enum.TextInputType.Username,
			returnKeyType = Enum.ReturnKeyType.Next,
			validator = usernameValidator,
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
			foundationInputSize = props.inputSize or inputSize.Medium,
			foundationTitleSize = props.titleSize or inputLabelSize.Medium,
			foundationTitleIsRequired = true,
			foundationTitleIsBold = props.isTitleBold,
			paddingTopOverride = 0,
			contentGapOverride = props.contentGap,
			useTrailingPadding = true,
			colorContentOverride = props.colorContentOverride
		}),
		Suggestions = 0
	}
	local v10

	if v6 then
		local createElement2 = React.createElement
		local v12 = {
			inputUsername = props.username,
			suggestionUsernames = suggestions,
			promptText = props.suggestionPrompt,
			eventContext = 0,
			onUsernameSelected = 0,
			LayoutOrder = 2
		}
		local v13 = if FFlagAccountUpgradeOAuthTelemetry and props.eventContext then props.eventContext else eventStreamConstants.Context.SinglePageSignUpScreen
		v12.eventContext = v13

		v12.onUsernameSelected = v5
		v10 = createElement2(UsernameSuggestionList, v12)
	end

	v9.Suggestions = v10
	return createElement(view, v8, v9)
end

return UsernameFieldWithSuggestions
