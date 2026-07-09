local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local CollapsingTextInputValidator = require(Modules.LuaApp.Components.Authentication.CollapsingTextInputValidator)
local UniversalDisplayNameValidator = require(Modules.LuaApp.Thunks.Authentication.UniversalDisplayNameValidator)
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local InputValidity = require(CorePackages.Workspace.Packages.AuthCommon).Enums.InputValidity
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local GetUsernameRecommendationFromDisplayName = require(Modules.LuaApp.Http.Requests.GetUsernameRecommendationFromDisplayName)
local PostUsernameRecommendationFromDisplayName = require(Modules.LuaApp.Http.Requests.PostUsernameRecommendationFromDisplayName)
local EventStreamConstants = require(Modules.LuaApp.EventStreamConstants)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local useEffectOnMount = RoactUtils.Hooks.useEffectOnMount
local useEffectOnce = RoactUtils.Hooks.useEffectOnce
local FFlagSignupDisplayNameLogging = require(Modules.LuaApp.Components.Authentication.Flags.FFlagSignupDisplayNameLogging)
local v17 = game:DefineFastFlag("UsernameDisplayNameRecommendationPostSwitch", false)

game:DefineFastInt("DisplayNameDebounceInMilliseconds", 500)

return function(t1: {[any]: any}) -- line: 63
	-- upvalues: React (copy), useLocalization (copy), useRoactService (copy), RoactNetworking (copy), InputValidity (copy), FFlagSignupDisplayNameLogging (copy), EventStreamConstants (copy), GetUsernameRecommendationFromDisplayName (copy), v17 (copy), PostUsernameRecommendationFromDisplayName (copy), useEffectOnMount (copy), useEffectOnce (copy), CollapsingTextInputValidator (copy), UniversalDisplayNameValidator (copy)
	local v19, v20 = React.useState(false)
	local v21, v22 = React.useState(nil)
	local v23, v24 = React.useState(false)
	local v25 = useLocalization({
		displayNamePlaceholder = "Feature.DisplayName.Label.SignUpAgedUpDisplayName"
	})
	local v26 = useRoactService(RoactNetworking)
	local v27 = React.useCallback(function(s1: string, p1, b1: boolean) -- line: 74
		-- upvalues: t1 (copy), v22 (copy), v20 (copy), InputValidity (copy), FFlagSignupDisplayNameLogging (copy), EventStreamConstants (copy), v21 (copy)
		t1.onDisplayNameTextChanged(s1, p1, b1)
		v22(s1)
		v20(p1 == InputValidity.Valid)
		t1.updateBypassDisplayNameField(b1)

		if FFlagSignupDisplayNameLogging then
			t1.authEventAnalytics.reportAuthFormInteraction(EventStreamConstants.Context.SinglePageSignUpScreen, EventStreamConstants.Field.DisplayName, EventStreamConstants.ActionType.Submit, p1, v21)
		end
	end, {
		t1.onDisplayNameTextChanged,
		t1.updateBypassDisplayNameField
	})
	local v28 = React.useMemo(function() -- line: 92
		-- upvalues: t1 (copy)
		return {
			birthday = t1.birthday
		}
	end, { t1.birthday })
	local u29 = GetUsernameRecommendationFromDisplayName

	if v17 then
		u29 = PostUsernameRecommendationFromDisplayName
	end

	if t1.mockGetUsernameRecommendationFromDisplayName then
		u29 = t1.mockGetUsernameRecommendationFromDisplayName
	end

	local v30 = not t1.bypassDisplayNameField and "Feature.DisplayName.Label.ErrorsWithAgedUpDisplayName" or "Feature.DisplayName.Label.ValidationFailed"

	React.useEffect(function() -- line: 114
		-- upvalues: t1 (copy), v19 (copy), v24 (copy), v21 (copy), u29 (ref), v26 (copy), FFlagSignupDisplayNameLogging (copy), EventStreamConstants (copy)
		if t1.bypassDisplayNameField then
			t1.setUsernameRecommendation("")

			return
		end

		if v19 and not t1.shouldDisableRecommendation then
			v24(true)
			task.spawn(function() -- line: 123
				-- upvalues: v21 (copy), t1 (copy), u29 (ref), v26 (copy), v24 (copy), FFlagSignupDisplayNameLogging (copy), EventStreamConstants (copy)
				local v36 = v21
				local birthday = t1.birthday

				u29(v26, v36, birthday):andThen(function(p2) -- line: 125
					-- upvalues: v24 (copy), FFlagSignupDisplayNameLogging (copy), t1 (copy), EventStreamConstants (copy), v21 (copy)
					v24(false)

					local v39 = p2 and (not not p2[1] and (not not p2[1].suggestedUsernames and p2[1].suggestedUsernames[1])) or ""

					if FFlagSignupDisplayNameLogging then
						t1.authEventAnalytics.reportUsernameSuggestionShown(EventStreamConstants.Context.SinglePageSignUpScreen, v21, if v39 == "" then {} else p2[1].suggestedUsernames, EventStreamConstants.Field.DisplayName)
					end

					t1.setUsernameRecommendation(v39)
				end):catch(function(_) -- line: 144
					-- upvalues: FFlagSignupDisplayNameLogging (copy), t1 (copy), EventStreamConstants (copy), v24 (copy)
					if FFlagSignupDisplayNameLogging then
						t1.authEventAnalytics.reportUsernameGenerationFailed(EventStreamConstants.Context.SinglePageSignUpScreen, EventStreamConstants.State.ReportUsernameGenerationFailed)
					end

					v24(false)
					t1.setUsernameRecommendation("")
				end)
			end)
		end
	end, {
		v19,
		v21,
		t1.shouldDisableRecommendation,
		t1.bypassDisplayNameField
	})

	if FFlagSignupDisplayNameLogging then
		useEffectOnMount(function() -- line: 167
			-- upvalues: t1 (copy), EventStreamConstants (copy)
			t1.authEventAnalytics.reportDisplayNameFieldLoaded(EventStreamConstants.Context.SinglePageSignUpScreen, EventStreamConstants.Field.DisplayName, EventStreamConstants.ActionType.Shown)
		end)
		useEffectOnce(function() -- line: 175
			-- upvalues: t1 (copy), EventStreamConstants (copy)
			t1.authEventAnalytics.reportDisplayNameFieldBypassed(EventStreamConstants.Context.SinglePageSignUpScreen, EventStreamConstants.State.BypassDisplayNameField)
		end, t1.bypassDisplayNameField)
	end

	return React.createElement(CollapsingTextInputValidator, {
		prerequisiteMet = true,
		titleTextKey = "Feature.DisplayName.Label.AgedUpNameField",
		debounceTime = (game:GetFastInt("DisplayNameDebounceInMilliseconds") or 500) / 1000,
		focusedTextBoxPositionChangedCallback = t1.focusedTextBoxPositionChangedCallback,
		showDetailedError = t1.bypassDisplayNameField,
		layoutOrder = t1.layoutOrder,
		onAnimationStateChangeCallback = t1.onAnimationStateChangeCallback,
		onInputTextValidated = v27,
		onReturnPressedFromOnScreenKeyboard = t1.onReturnPressedFromOnScreenKeyboard,
		pillClicked = t1.pillClicked,
		placeholderText = v25.displayNamePlaceholder,
		resetPillClicked = t1.resetPillClicked,
		returnKeyType = Enum.ReturnKeyType.Next,
		summaryErrorTextKey = v30,
		textBoxFocusedCallback = t1.textBoxFocusedCallback,
		textBoxFocusLostCallback = t1.textBoxFocusLostCallback,
		textBoxRef = t1.textBoxRef,
		textInputType = Enum.TextInputType.NoSuggestions,
		updatePillClicked = t1.updatePillClicked,
		validator = UniversalDisplayNameValidator,
		validatorAdditionalProps = v28,
		hasFieldFailed = t1.bypassDisplayNameField,
		shouldShowLoadingIcon = v23
	})
end
