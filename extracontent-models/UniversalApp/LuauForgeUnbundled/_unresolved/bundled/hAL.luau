local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local module = require("@luauforge/bundled/fTR")
local module2 = require("@luauforge/bundled/hAM")
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local inputValidity = require("@game/CorePackages/Workspace/Packages/AuthCommon").Enums.InputValidity
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local module3 = require("@luauforge/bundled/eda")

local module4 = require("@luauforge/bundled/hAN")

local module5 = require("@luauforge/bundled/hAO")
local module6 = require("@luauforge/bundled/fsy")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local useEffectOnMount = RoactUtils.Hooks.useEffectOnMount
local useEffectOnce = RoactUtils.Hooks.useEffectOnce

local module8 = require("@luauforge/bundled/fMR")

local defineFastFlag = game:DefineFastFlag("UsernameDisplayNameRecommendationPostSwitch", false)

game:DefineFastInt("DisplayNameDebounceInMilliseconds", 500)

return function(props)
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(nil)
	local state3, setState3 = React.useState(false)

	local v5 = useLocalization({
		displayNamePlaceholder = "Feature.DisplayName.Label.SignUpAgedUpDisplayName"
	})

	local v6 = useRoactService(module3)

	local v7 = React.useCallback(function(p2, p3, p4)
		props.onDisplayNameTextChanged(p2, p3, p4)
		setState2(p2)
		setState(p3 == inputValidity.Valid)
		props.updateBypassDisplayNameField(p4)

		if module8 then
			props.authEventAnalytics.reportAuthFormInteraction(
				module6.Context.SinglePageSignUpScreen,
				module6.Field.DisplayName,
				module6.ActionType.Submit,
				p3,
				state2
			)
		end
	end, { props.onDisplayNameTextChanged, props.updateBypassDisplayNameField })

	local v8 = React.useMemo(function()
		return { birthday = props.birthday }
	end, { props.birthday })

	local v9 = module4

	if defineFastFlag then
		v9 = module5
	end

	if props.mockGetUsernameRecommendationFromDisplayName then
		v9 = props.mockGetUsernameRecommendationFromDisplayName
	end

	local v10 = props.bypassDisplayNameField and "Feature.DisplayName.Label.ValidationFailed"
		or "Feature.DisplayName.Label.ErrorsWithAgedUpDisplayName"

	React.useEffect(function()
		if props.bypassDisplayNameField then
			props.setUsernameRecommendation("")
		elseif state and not props.shouldDisableRecommendation then
			setState3(true)

			task.spawn(function()
				v9(v6, state2, props.birthday):andThen(function(list)
					setState3(false)

					local v12 = list
						and list[1]
						and list[1].suggestedUsernames
						and list[1].suggestedUsernames[1]
						or ""

					if module8 then
						props.authEventAnalytics.reportUsernameSuggestionShown(
							module6.Context.SinglePageSignUpScreen,
							state2,
							v12 == "" and {} or list[1].suggestedUsernames,
							module6.Field.DisplayName
						)
					end

					props.setUsernameRecommendation(v12)
				end):catch(function(p2)
					if module8 then
						props.authEventAnalytics.reportUsernameGenerationFailed(
							module6.Context.SinglePageSignUpScreen,
							module6.State.ReportUsernameGenerationFailed
						)
					end

					setState3(false)

					props.setUsernameRecommendation("")
				end)
			end)
		end
	end, {
		state,
		state2,
		props.shouldDisableRecommendation,
		props.bypassDisplayNameField
	})

	if module8 then
		useEffectOnMount(function()
			props.authEventAnalytics.reportDisplayNameFieldLoaded(
				module6.Context.SinglePageSignUpScreen,
				module6.Field.DisplayName,
				module6.ActionType.Shown
			)
		end)

		useEffectOnce(function()
			props.authEventAnalytics.reportDisplayNameFieldBypassed(
				module6.Context.SinglePageSignUpScreen,
				module6.State.BypassDisplayNameField
			)
		end, props.bypassDisplayNameField)
	end

	return React.createElement(module, {
		debounceTime = (game:GetFastInt("DisplayNameDebounceInMilliseconds") or 500) / 1000,
		focusedTextBoxPositionChangedCallback = props.focusedTextBoxPositionChangedCallback,
		showDetailedError = props.bypassDisplayNameField,
		layoutOrder = props.layoutOrder,
		onAnimationStateChangeCallback = props.onAnimationStateChangeCallback,
		onInputTextValidated = v7,
		onReturnPressedFromOnScreenKeyboard = props.onReturnPressedFromOnScreenKeyboard,
		pillClicked = props.pillClicked,
		placeholderText = v5.displayNamePlaceholder,
		prerequisiteMet = true,
		resetPillClicked = props.resetPillClicked,
		returnKeyType = Enum.ReturnKeyType.Next,
		summaryErrorTextKey = v10,
		textBoxFocusedCallback = props.textBoxFocusedCallback,
		textBoxFocusLostCallback = props.textBoxFocusLostCallback,
		textBoxRef = props.textBoxRef,
		textInputType = Enum.TextInputType.NoSuggestions,
		titleTextKey = "Feature.DisplayName.Label.AgedUpNameField",
		updatePillClicked = props.updatePillClicked,
		validator = module2,
		validatorAdditionalProps = v8,
		hasFieldFailed = props.bypassDisplayNameField,
		shouldShowLoadingIcon = state3
	})
end
