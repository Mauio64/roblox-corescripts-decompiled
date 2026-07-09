local MultiPageSignup = script:FindFirstAncestor("MultiPageSignup")
local MultiPageSignupParent = MultiPageSignup.Parent
local React = require(MultiPageSignupParent.React)
local useDesignTokens = require(MultiPageSignupParent.Style).useDesignTokens
local useDispatch = require(MultiPageSignupParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useRoactService = require(MultiPageSignupParent.RobloxAppHooks).useRoactService
local useLocalization = require(MultiPageSignupParent.Localization).Hooks.useLocalization
local debounce = require(MultiPageSignup.Utils.debounce)
local useShowDisclaimerLinks = require(MultiPageSignup.Hooks.useShowDisclaimerLinks)
local RoactNetworking = require(MultiPageSignupParent.RoactServiceTags).RoactNetworking
local UIBlox = require(MultiPageSignupParent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local PillGroup = UIBlox.App.Control.PillGroup
local GetFFlagEnableSignupFoundationText = require(MultiPageSignupParent.SharedFlags).GetFFlagEnableSignupFoundationText
local Foundation = require(MultiPageSignupParent.Foundation)
local FoundationText = Foundation.Text
local TextInput = Foundation.TextInput
local UserActivationFramework = require(MultiPageSignupParent.UserActivationFramework)
local ActivationFrameworkWrapper = UserActivationFramework.Components.ActivationFrameworkWrapper
local PayloadKey = UserActivationFramework.Enums.PayloadKey
local FullPageActivationFrameworkContext = UserActivationFramework.Context.FullPageActivationFrameworkContext
local CallbackStatus = UserActivationFramework.Enums.CallbackStatus
local AuthSignup = require(MultiPageSignupParent.AuthSignup)
local UsernameValidator = AuthSignup.Thunks.UsernameValidator
local UsernameSuggestor = AuthSignup.Thunks.UsernameSuggestor
local UsernameSuggestionScrollView = AuthSignup.Components.UsernameSuggestionScrollView
local cleanUsernameForSuggestions = require(MultiPageSignup.Utils.cleanUsernameForSuggestions)
local AuthCommon = require(MultiPageSignupParent.AuthCommon)
local UsernameValidationContext = AuthCommon.Enums.UsernameValidationContext
local UsernameIssue = AuthCommon.Enums.UsernameIssue
local IssueCondition = AuthCommon.Enums.IssueCondition
local DisclaimerLinks = AuthCommon.Components.DisclaimerLinks
local AuthAnalytics = require(MultiPageSignupParent.AuthAnalytics)
local EventStreamConstants = AuthAnalytics.EventStreamConstants
local authMsgShown = AuthAnalytics.Events.authMsgShown
local authButtonClick = AuthAnalytics.Events.authButtonClick
local authModalShown = AuthAnalytics.Events.authModalShown
local authClientError = AuthAnalytics.Events.authClientError
local SharedFlags = require(MultiPageSignupParent.SharedFlags)
local v41 = game:DefineFastFlag("UseFoundationUsernameSuggestion", false)
local GetFFlagEnableMultiPageSignupV2Updates = SharedFlags.GetFFlagEnableMultiPageSignupV2Updates
local RegisterPreauthPasskey = AuthCommon.Thunks.RegisterPreauthPasskey
local getCredentialsProtocolAvailability = require(MultiPageSignup.Utils.getCredentialsProtocolAvailability)
local Promise = require(MultiPageSignupParent.Promise)
local RoactAppExperiment = require(MultiPageSignupParent.RoactAppExperiment)
local FStringLuaMultiPageSignupIxpLayer = SharedFlags.FStringLuaMultiPageSignupIxpLayer
local v48 = game:DefineFastFlag("HideMultipageUsernameAutofillSignupExperiment2", false)
local t1 = {
	UsernameIssue.LengthTooShortOrTooLong,
	UsernameIssue.ContainsInvalidCharacter,
	UsernameIssue.MultipleUnderscores,
	UsernameIssue.BoundingUnderscore,
	UsernameIssue.Inappropriate,
	UsernameIssue.AlreadyInUse,
	UsernameIssue.ContainsPII
}
local t2 = {
	[UsernameIssue.LengthTooShortOrTooLong] = "Authentication.SignUp.Label.Error.UsernameLengthTooShortOrTooLong",
	[UsernameIssue.ContainsInvalidCharacter] = "Authentication.SignUp.Label.Error.UsernameContainsInvalidCharacter",
	[UsernameIssue.MultipleUnderscores] = "Authentication.SignUp.Label.Error.UsernameContainsMultipleUnderscores",
	[UsernameIssue.BoundingUnderscore] = "Authentication.SignUp.Label.Error.UsernameContainsBoundingUnderscore",
	[UsernameIssue.Inappropriate] = "Authentication.SignUp.Label.Error.UsernameInappropriate",
	[UsernameIssue.AlreadyInUse] = "Authentication.SignUp.Label.Error.UsernameAlreadyInUse",
	[UsernameIssue.ContainsPII] = "Authentication.SignUp.Label.Error.UsernameContainsPII"
}

game:DefineFastInt("DefaultUsernameDebounceMs", 700)

return function(t3: {[any]: any}) -- line: 96
	-- upvalues: React (copy), FullPageActivationFrameworkContext (copy), useStyle (copy), useDesignTokens (copy), useDispatch (copy), useRoactService (copy), RoactNetworking (copy), RoactAppExperiment (copy), FStringLuaMultiPageSignupIxpLayer (copy), UsernameValidator (copy), useShowDisclaimerLinks (copy), PayloadKey (copy), GetFFlagEnableMultiPageSignupV2Updates (copy), debounce (copy), t1 (copy), IssueCondition (copy), UsernameValidationContext (copy), cleanUsernameForSuggestions (copy), UsernameSuggestor (copy), authMsgShown (copy), EventStreamConstants (copy), useLocalization (copy), t2 (copy), GetFFlagEnableSignupFoundationText (copy), FoundationText (copy), StyledTextLabel (copy), v41 (copy), UsernameSuggestionScrollView (copy), authButtonClick (copy), PillGroup (copy), RegisterPreauthPasskey (copy), authModalShown (copy), authClientError (copy), Promise (copy), getCredentialsProtocolAvailability (copy), v48 (copy), ActivationFrameworkWrapper (copy), CallbackStatus (copy), DisclaimerLinks (copy), TextInput (copy)
	local v52 = React.useContext(FullPageActivationFrameworkContext)
	local activationFrameworkState = v52.activationFrameworkState
	local v54 = useStyle()
	local v55 = useDesignTokens()
	local v56 = useDispatch()
	local v57 = useRoactService(RoactNetworking)
	local v58 = RoactAppExperiment.useBrowserTrackerExperiment({ FStringLuaMultiPageSignupIxpLayer }, function(p1) -- line: 107
		-- upvalues: FStringLuaMultiPageSignupIxpLayer (copy)
		local v87 = p1[FStringLuaMultiPageSignupIxpLayer] or {}

		return {
			shouldMultipageDisableUsernameAutofill = v87.shouldMultipageDisableUsernameAutofill or false,
			shouldCleanUsernameSuggestionInput = v87.shouldCleanUsernameSuggestionInput or false,
			shouldDisableClearingUsernameSuggestions = v87.shouldDisableClearingUsernameSuggestions or false,
			shouldPromptPasskey = v87.shouldPromptPasskey or false
		}
	end)
	local v59, v60 = React.useState("")
	local v61, v62 = React.useState(game:GetFastInt("DefaultUsernameDebounceMs") / 1000)
	local v63, v64 = React.useState(UsernameValidator.getDefaultIssues())
	local v65, v66 = React.useState({})
	local v67, v68 = React.useState(false)
	local v69 = useShowDisclaimerLinks()
	local v70, v71 = React.useState(false)
	local v72 = React.useRef(nil)
	local v73, v74 = React.useState(false)
	local v75, v76 = React.useState(false)
	local v77 = activationFrameworkState.payloadTable[PayloadKey.SignupBirthdayTimestampUtc]

	React.useEffect(function() -- line: 134
		-- upvalues: v72 (copy)
		if v72.current and v72.current.focus then
			v72.current.focus()
		end
	end, {})
	React.useEffect(function() -- line: 140
		-- upvalues: GetFFlagEnableMultiPageSignupV2Updates (copy), v70 (copy), v72 (copy), v71 (copy)
		if GetFFlagEnableMultiPageSignupV2Updates() and v70 then
			if v72.current and v72.current.focus then
				v72.current.focus()
			end

			v71(false)
		end
	end, { v70 })

	local v78 = React.useCallback(debounce(function(p2) -- line: 153
		-- upvalues: v60 (copy)
		v60(p2)
	end, v61), {
		v60,
		v61
	})
	local v79 = React.useCallback(function() -- line: 159
		-- upvalues: t1 (copy), v63 (copy), IssueCondition (copy)
		for _, v in ipairs(t1) do
			if v63[v] == IssueCondition.Problematic then
				return v
			end
		end

		return nil
	end, { v63 })

	React.useEffect(function() -- line: 177
		-- upvalues: v58 (copy), cleanUsernameForSuggestions (copy), v59 (copy), UsernameSuggestor (copy), v57 (copy), v77 (copy), UsernameValidationContext (copy), v66 (copy)
		local v91 = if not v58.shouldCleanUsernameSuggestionInput then v59 else cleanUsernameForSuggestions(v59)

		UsernameSuggestor.suggestUsernames(v57, v91, v77, UsernameValidationContext.Signup):andThen(function(p3) -- line: 187
			-- upvalues: v58 (copy), v66 (copy)
			if v58.shouldDisableClearingUsernameSuggestions then
				if #p3.suggestions > 0 then
					v66(p3.suggestions)

					return
				end
			elseif p3.shouldUpdateState then
				v66(p3.suggestions)
			end
		end)
	end, { v59 })
	React.useEffect(function() -- line: 201
		-- upvalues: v79 (copy), v67 (copy), v59 (copy), authMsgShown (copy), t3 (copy), activationFrameworkState (copy), EventStreamConstants (copy)
		local str = tostring(v79())

		if str and v67 and #v59 > 0 then
			authMsgShown(t3.namespace, activationFrameworkState.currentState, EventStreamConstants.Field.Username, str)
		end
	end, { v63 })
	React.useEffect(function() -- line: 215
		-- upvalues: v56 (copy), UsernameValidator (copy), v57 (copy), v59 (copy), v63 (copy), v77 (copy), UsernameValidationContext (copy), v64 (copy), v68 (copy), v62 (copy)
		v56(UsernameValidator.validateFunction(v57, v59, v63, {
			birthday = v77,
			context = UsernameValidationContext.Signup
		})):andThen(function(p4) -- line: 216
			-- upvalues: v64 (copy), v68 (copy), v59 (copy), v62 (copy)
			v64(p4.IssueCondition)
			v68(#v59 > 0)

			if p4.InputValid then
				v62(0.2)
			end
		end)
	end, { v59 })

	local v80 = v79()
	local v81 = v80 and (v67 and #v59 > 0)
	local v82 = v81 and #v65 > 0
	local v83 = useLocalization({
		username = "Authentication.Login.Label.Username",
		usernameSuggestionHeaderText = "Authentication.SignUp.Label.MaybeTryOneOfThese",
		noRealNamePlaceholderText = "Authentication.SignUp.Message.Username.NoRealNameUse",
		usernameRule1 = "Authentication.SignUp.Description.UsernameRule1",
		usernameRule2 = "Authentication.SignUp.Description.UsernameRule2",
		errorText = v80 and t2[v80]
	})

	local function v84() -- line: 316
		-- upvalues: v58 (copy), v74 (copy), v75 (copy), RegisterPreauthPasskey (copy), v57 (copy), v59 (copy), authModalShown (copy), EventStreamConstants (copy), PayloadKey (copy), authClientError (copy), Promise (copy)
		if v58.shouldPromptPasskey then
			v74(true)

			if v75 then
				local _, v98 = RegisterPreauthPasskey(v57, v59):andThen(function(p5) -- line: 321
					-- upvalues: authModalShown (copy), EventStreamConstants (copy), PayloadKey (copy)
					if p5 then
						authModalShown(EventStreamConstants.Context.MultiPageSignupPreauthPasskeyCreatedIdentifierPage, EventStreamConstants.State.Success)

						return {
							[PayloadKey.SignupPasskeySessionId] = p5.sessionId,
							[PayloadKey.SignupPasskeyResult] = p5.result
						}
					end

					authModalShown(EventStreamConstants.Context.MultiPageSignupPreauthPasskeyCreatedIdentifierPage, EventStreamConstants.State.Unknown)

					return nil
				end, function(p6) -- line: 338
					-- upvalues: authModalShown (copy), EventStreamConstants (copy), authClientError (copy)
					if p6.name then
						authModalShown(EventStreamConstants.Context.MultiPageSignupPreauthPasskeyCreatedIdentifierPage, p6.name)

						if type(p6.body) == "string" then
							authClientError(EventStreamConstants.Context.MultiPageSignupPreauthPasskeyCreatedIdentifierPage, p6.body, p6.source)

							return
						end
					else
						authModalShown(EventStreamConstants.Context.MultiPageSignupPreauthPasskeyCreatedIdentifierPage, EventStreamConstants.State.Unknown)
					end
				end):await()

				return Promise.resolve(v98)
			end

			return Promise.reject()
		end

		return Promise.reject()
	end

	React.useEffect(function() -- line: 367
		-- upvalues: activationFrameworkState (copy), v58 (copy), getCredentialsProtocolAvailability (copy), t3 (copy), v52 (copy), v76 (copy)
		if not activationFrameworkState.payloadTable or not v58.shouldPromptPasskey then
			return
		end

		local v99, _, _ = getCredentialsProtocolAvailability(activationFrameworkState.payloadTable, t3.namespace, v52.dispatch)

		v76(v99)
	end, {
		activationFrameworkState.payloadTable,
		v58.shouldPromptPasskey
	})

	local v85 = v48 and v58.shouldMultipageDisableUsernameAutofill

	return React.createElement(ActivationFrameworkWrapper, {
		titleTextKey = "Authentication.SignUp.Header.UsernamePage4",
		bodyTextKey = "Authentication.SignUp.Description.UsernameHelpV2",
		headingTextKey = "Authentication.SignUp.Action.CreateAccount",
		namespace = t3.namespace,
		primaryButton = {
			buttonTextKey = "Authentication.SignUp.Action.NextWord",
			shouldShowButton = true,
			isButtonEnabled = #v59 > 0 and (v67 and (not v81 and not v73)),
			onButtonClicked = function() -- line: 393
				-- upvalues: PayloadKey (copy), v59 (copy), v84 (copy), v74 (copy), CallbackStatus (copy)
				local t4 = {
					[PayloadKey.SignupUsername] = v59
				}
				local v103, v104 = v84():andThen(function(p7) -- line: 396
					return p7
				end):await()

				v74(false)

				if v103 and v104 then
					for k, v in pairs(v104) do
						t4[k] = v
					end

					t4[PayloadKey.SignupPassword] = ""
				end

				return {
					payloadAddendum = t4,
					status = CallbackStatus.Success
				}
			end
		},
		navigation = t3.navigation,
		subFooterContent = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 0, 1, 0),
			AnchorPoint = Vector2.new(0, 1),
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Bottom,
				FillDirection = Enum.FillDirection.Vertical
			}),
			DisclaimerLinks = if not v69 then nil else React.createElement(DisclaimerLinks, {
				ctx = t3.namespace,
				state = activationFrameworkState.currentState
			})
		})
	}, {
		Content = React.createElement("Frame", {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0)
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, v55.Size.Size_50)
			}),
			UsernameInputLabel = if not GetFFlagEnableSignupFoundationText() then React.createElement(StyledTextLabel, {
				layoutOrder = 1,
				text = v83.username,
				fontStyle = v54.Font.Body,
				colorStyle = v54.Theme.TextDefault,
				automaticSize = Enum.AutomaticSize.XY
			}) else React.createElement(FoundationText, {
				LayoutOrder = 1,
				tag = "text-body-small auto-xy",
				Text = v83.username
			}),
			IdentifierLabelSpacing = React.createElement("Frame", {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, v55.Size.Size_100)
			}),
			UsernameTextInput = React.createElement(TextInput, {
				LayoutOrder = 3,
				label = "",
				textInputType = if not v85 then Enum.TextInputType.Username else nil,
				width = UDim.new(1, 0),
				text = v59,
				placeholder = v83.noRealNamePlaceholderText,
				onChanged = function(p8) -- line: 469
					-- upvalues: v78 (copy)
					v78(p8)
				end,
				hasError = v81,
				iconTrailing = if not v81 then nil else {
					name = "icons/navigation/close",
					onActivated = function() -- line: 477
						-- upvalues: authButtonClick (copy), v52 (copy), EventStreamConstants (copy), v60 (copy), v66 (copy), v62 (copy), GetFFlagEnableMultiPageSignupV2Updates (copy), v71 (copy)
						authButtonClick(v52.activationFrameworkState.namespace, EventStreamConstants.Button.ClearUsernameField, v52.activationFrameworkState.currentState)
						v60("")
						v66({})
						v62(game:GetFastInt("DefaultUsernameDebounceMs") / 1000)

						if GetFFlagEnableMultiPageSignupV2Updates() then
							v71(true)
						end
					end
				},
				textBoxRef = v72
			}),
			TextSpacing = React.createElement("Frame", {
				LayoutOrder = 4,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, v55.Size.Size_100)
			}),
			AdditionalText = (function(n1: number) -- line: 242
				-- upvalues: GetFFlagEnableSignupFoundationText (copy), React (copy), FoundationText (copy), v81 (copy), v83 (copy), v54 (copy), StyledTextLabel (copy), v55 (copy)
				local v94 = if not GetFFlagEnableSignupFoundationText() then React.createElement(StyledTextLabel, {
					textWrapped = true,
					text = not v81 and "" or v83.errorText,
					fontStyle = v54.Font.BodySmall,
					colorStyle = v54.Theme.Alert,
					automaticSize = Enum.AutomaticSize.XY
				}) else React.createElement(FoundationText, {
					TextWrapped = true,
					tag = "text-body-small auto-xy",
					Text = not v81 and "" or v83.errorText,
					textStyle = {
						Color3 = v54.Theme.Alert.Color,
						Transparency = v54.Theme.Alert.Transparency
					}
				})
				local Size_400 = v55.Size.Size_400

				return React.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = n1,
					Size = UDim2.new(1, 0, 0, Size_400)
				}, { v94 })
			end)(5),
			SuggestionsLabelSpacing = v82 and React.createElement("Frame", {
				LayoutOrder = 6,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, v55.Size.Size_400)
			}),
			SuggestionsLabel = v82 and if not GetFFlagEnableSignupFoundationText() then React.createElement(StyledTextLabel, {
				layoutOrder = 7,
				text = v83.usernameSuggestionHeaderText,
				fontStyle = v54.Font.Body,
				colorStyle = v54.Theme.TextDefault,
				automaticSize = Enum.AutomaticSize.XY
			}) else React.createElement(FoundationText, {
				LayoutOrder = 7,
				tag = "text-body-small auto-xy",
				Text = v83.usernameSuggestionHeaderText
			}),
			UsernameSuggestion = v82 and (function(n2: number) -- line: 275
				-- upvalues: v41 (copy), React (copy), UsernameSuggestionScrollView (copy), v59 (copy), v65 (copy), v52 (copy), v60 (copy), v66 (copy), authButtonClick (copy), EventStreamConstants (copy), PillGroup (copy)
				if v41 then
					return React.createElement(UsernameSuggestionScrollView, {
						inputUsername = v59,
						suggestionUsernames = v65,
						eventContext = tostring(v52.activationFrameworkState.namespace),
						onUsernameSelected = function(p9) -- line: 281
							-- upvalues: v60 (copy), v66 (copy), authButtonClick (copy), v52 (copy), EventStreamConstants (copy)
							v60(p9)
							v66({})
							authButtonClick(v52.activationFrameworkState.namespace, EventStreamConstants.Button.UsernameSuggestion, p9)
						end,
						layoutOrder = n2
					})
				end

				return React.createElement(PillGroup, {
					layoutOrder = 8,
					leftPadding = 0,
					pills = v65,
					onSelectionChanged = function(p10) -- line: 297
						-- upvalues: v60 (copy), v66 (copy), authButtonClick (copy), v52 (copy), EventStreamConstants (copy)
						if #p10 == 1 then
							if #p10[1] == 0 then
								return
							end

							local v112 = p10[1]

							v60(v112)
							v66({})
							authButtonClick(v52.activationFrameworkState.namespace, EventStreamConstants.Button.UsernameSuggestion, v112)
						end
					end
				})
			end)(8)
		})
	})
end
