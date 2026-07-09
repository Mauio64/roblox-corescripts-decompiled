local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local useUiModeInfo = require(CorePackages.Workspace.Packages.RobloxAppHooks).useUiModeInfo
local UiMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).UiMode
local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local Images = UIBlox.App.ImageSet.Images
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local GetImageData = require(CorePackages.Workspace.Packages.RobloxAppAssets).GetImageData
local FitChildren = require(Modules.LuaApp.FitChildren)
local FitTextLabel = require(Modules.LuaApp.Components.FitTextLabel)
local useTextSizeOffset = require(CorePackages.Packages.Foundation).Hooks.useTextSizeOffset
local useLocalization = require(Modules.LuaApp.Hooks.useLocalization)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local useAnimatedScrollToSelection = require(CorePackages.Workspace.Packages.RobloxAppHooks).useAnimatedScrollToSelection
local AuthCommon = require(CorePackages.Workspace.Packages.AuthCommon)
local UsernameValidationContext = require(Modules.LuaApp.Enum.UsernameValidationContext)

require(Modules.LuaApp.Components.Authentication.Enum.InputValidity)

local AuthBirthdayBar = require(Modules.LuaApp.Components.Authentication.AuthBirthdayBar)
local GenderDropdownSelector = require(Modules.LuaApp.Components.Authentication.GenderDropdownSelector)
local BirthdateDropdownSelector = require(Modules.LuaApp.Components.Authentication.BirthdateDropdownSelector)
local CollapsingTextInputValidator = require(Modules.LuaApp.Components.Authentication.CollapsingTextInputValidator)
local SuggestionsFrame = require(Modules.LuaApp.Components.Authentication.SuggestionsFrame)
local UsernameSuggestor = require(Modules.LuaApp.Thunks.Authentication.UsernameSuggestor)
local SignUpGenderSelector = require(Modules.LuaApp.Components.Authentication.SignUpGenderSelector)
local TitleAndParagraph = require(Modules.LuaApp.Components.Authentication.TitleAndParagraph)
local DisclaimerLinks = require(Modules.LuaApp.Components.Authentication.DisclaimerLinks)
local ContactInfoField = require(Modules.LuaApp.Components.Authentication.ContactInfoField)
local BackgroundFill = AuthCommon.Components.BackgroundFill
local AuthBackgroundContainer = AuthCommon.Components.AuthBackgroundContainer
local FullscreenPageWithSafeArea = require(Modules.LuaApp.Components.FullscreenPageWithSafeArea)
local useAppPolicy = require(Modules.LuaApp.Hooks.useAppPolicy)
local useSignUpPageNavigationBindings = AuthCommon.Hooks.useSignUpPageNavigationBindings
local DateHelper = require(CorePackages.Workspace.Packages.Time).DateHelper
local GetFFlagEnableTextFieldContentType = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableTextFieldContentType
local GetFFlagRefactorAuthPageForTenFoot = require(Modules.LuaApp.Flags.GetFFlagRefactorAuthPageForTenFoot)
local GetFFlagLuaAppEnable10ftSignUpView = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagLuaAppEnable10ftSignUpView
local GetFFlagEnableAuditForSso = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableAuditForSso
local GetFIntLuaLoginGenderSelector = require(Modules.LuaApp.Flags.GetFIntLuaLoginGenderSelector)
local FFlagEnableLeftNavOnConsole = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableLeftNavOnConsole
local useAuthBackgroundContainerVariant = AuthCommon.Hooks.useAuthBackgroundContainerVariant
local uDim2 = UDim2.new(0, 36, 0, 36)
local vector2 = Vector2.new(540, 1080)
local vector2_2 = Vector2.new(850, 1080)
local v51 = game:DefineFastFlag("EnableUsernameNextSelectionDown", false)
local v52 = game:DefineFastFlag("AuthRefactorConsoleDisclaimerText", false)

return function(t1: {[any]: any}) -- line: 173
	-- upvalues: useStyle (copy), useUiModeInfo (copy), GetFFlagRefactorAuthPageForTenFoot (copy), UiMode (copy), GetFFlagLuaAppEnable10ftSignUpView (copy), useDesignTokens (copy), useAppPolicy (copy), useLocalization (copy), useSelector (copy), FormFactor (copy), React (copy), ReactFocusNavigation (copy), useSignUpPageNavigationBindings (copy), useAuthBackgroundContainerVariant (copy), AuthBackgroundContainer (copy), BackgroundFill (copy), GetFFlagEnableTextFieldContentType (copy), v52 (copy), useTextSizeOffset (copy), useAnimatedScrollToSelection (copy), FullscreenPageWithSafeArea (copy), FFlagEnableLeftNavOnConsole (copy), ImageSetLabel (copy), GetImageData (copy), vector2_2 (copy), vector2 (copy), ImageSetButton (copy), uDim2 (copy), Images (copy), FitTextLabel (copy), FitChildren (copy), AuthBirthdayBar (copy), GetFFlagEnableAuditForSso (copy), BirthdateDropdownSelector (copy), GenderDropdownSelector (copy), ContactInfoField (copy), DateHelper (copy), CollapsingTextInputValidator (copy), UsernameValidationContext (copy), v51 (copy), SuggestionsFrame (copy), UsernameSuggestor (copy), GetFIntLuaLoginGenderSelector (copy), SignUpGenderSelector (copy), Button (copy), ButtonType (copy), TitleAndParagraph (copy), DisclaimerLinks (copy)
	local v54 = useStyle()
	local v55 = useUiModeInfo()
	local v56 = GetFFlagRefactorAuthPageForTenFoot() and v55.uiMode == UiMode.TenFoot or v55.uiMode == UiMode.VR
	local v57 = GetFFlagLuaAppEnable10ftSignUpView() or v55.uiMode == UiMode.VR
	local v58 = if not v57 then nil else useDesignTokens()
	local v59 = if not v57 or not v58 then nil else v58.LuaApps.SignUpView
	local v60 = useAppPolicy(function(p1) -- line: 181
		return p1.getPlatformAccountName()
	end)
	local v61 = useLocalization({
		signUpText = "Authentication.SignUp.Action.CreateAccount",
		usernamePlaceholder = "Authentication.SignUp.Message.Username.NoRealNameUse",
		passwordPlaceholder = "Authentication.SignUp.Label.PasswordPlaceholder",
		unknownError = "Feature.Reauthentication.Message.Error.Default"
	})
	local v62 = useSelector(function(p2) -- line: 192
		return p2.FormFactor
	end) == FormFactor.WIDE
	local v63 = React.useRef(nil)
	local v64 = ReactFocusNavigation.useFocusedGuiObject()
	local v65 = ReactFocusNavigation.useFocusGuiObject()
	local v66 = useSignUpPageNavigationBindings()
	local v67, v68

	if not v56 then
		v67, v68 = ReactFocusNavigation.useDefaultFocusBehavior(v66)
	else
		v67, v68 = ReactFocusNavigation.useDefaultFocusBehavior()
	end

	local v69, v70 = React.useState(false)
	local v71 = React.useCallback(function() -- line: 209
		-- upvalues: v70 (copy)
		v70(true)
	end)
	local v72 = React.useCallback(function() -- line: 212
		-- upvalues: v70 (copy)
		v70(false)
	end)
	local v73 = useAuthBackgroundContainerVariant()
	local v74 = React.useCallback(function() -- line: 216
		-- upvalues: v73 (copy), React (copy), AuthBackgroundContainer (copy), v62 (copy), v54 (copy), BackgroundFill (copy)
		if v73 then
			return React.createElement(AuthBackgroundContainer, {
				showImage = v62,
				fallbackBackgroundColor = v54.Theme.BackgroundUIDefault.Color
			})
		end

		return React.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = not v62 and 0 or 1,
			BackgroundColor3 = v54.Theme.BackgroundUIDefault.Color
		}, {
			Background = v62 and React.createElement(BackgroundFill, {
				Image = "rbxasset://textures/ui/LuaApp/graphic/Auth/GridBackground.jpg"
			}),
			Mask = v62 and React.createElement("ImageLabel", {
				ZIndex = 2,
				BackgroundTransparency = 0.5,
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundColor3 = Color3.new(0, 0, 0)
			})
		})
	end, {
		v62,
		v54,
		v73
	})
	local v75 = t1.useUsernameSuggestions()
	local birthday = t1.birthday
	local n1 = 0
	local n2 = 0
	local v79 = t1.onScreenKeyboardHeight > 0
	local v80 = t1.useVerifiedSignup()
	local v81 = (not v62 or not v80) and 0 or 12
	local v82 = true
	local v83 = true
	local v84 = not t1.validUsernameEntered()
	local s1 = "Authentication.SignUp.Label.ErrorsWithUsername"
	local s2 = "Authentication.SignUp.Label.ErrorsWithPassword"

	if not birthday then
		s1 = "Authentication.SignUp.Response.BirthdayMustBeSetFirst"
		s2 = s1
		v84 = true
		v82 = false
	elseif v84 then
		s2 = "Authentication.SignUp.Response.UsernameMustBeSetFirst"
		v83 = false
	end

	if v62 then
		if v79 then
			n1 = t1.onScreenKeyboardHeight + 10
		else
			n1 = 48
			n2 = 24
		end
	end

	local v87 = GetFFlagEnableTextFieldContentType() and Enum.TextInputType.Username or Enum.TextInputType.NoSuggestions
	local n3 = 36
	local v89 = v54.Font.BaseSize * v54.Font.Header1.RelativeSize
	local v90 = v54.Font.BaseSize * v54.Font.CaptionBody.RelativeSize
	local n4 = 5
	local n5 = 1
	local t4 = nil
	local t2 = { "Authentication.SignUp.Description.VerificationPage" }
	local t3 = {{}}

	if v56 and v60 then
		if v52 then
			t2 = {{
				"Authentication.SignUp.Description.VerificationLinkingText",
				platform = v60
			}}
		else
			t2 = { "Authentication.SignUp.Description.VerificationLinkingText" }
			t3 = {{
				platform = v60
			}}
		end
	end

	if v57 and v59 then
		n2 = v59.marginTop
		v90 = v59.textCaptionHeaderSize
		v89 = v59.textHeaderSize
		n3 = v59.buttonHeight
		n4 = v59.contentPadding
		n5 = v59.headerPadding
		t4 = {
			Size = UDim2.fromScale(1, 1),
			TextSize = v59.buttonTextSize
		}
	end

	React.useEffect(function() -- line: 327
		-- upvalues: v64 (copy), v63 (copy), v65 (copy)
		if v64 and v63.current then
			v65(v63.current)
		end
	end, {})

	local v96 = useTextSizeOffset()
	local v97, v98 = useAnimatedScrollToSelection(Enum.ScrollingDirection.Y, n1 + 49 + v96)
	local t5 = {
		BorderSizePixel = 0,
		CanvasSize = UDim2.new(1, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasPosition = v97,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ScrollBarImageTransparency = 1,
		Position = UDim2.new(0.5, 0, 0, 49),
		AnchorPoint = Vector2.new(0.5, 0),
		Size = UDim2.new(1, 0, 1, -(49 + v81 + n2 + v96)),
		[React.Change.CanvasSize] = t1.onSignUpContentFrameCanvasSizeChange,
		[React.Event.SelectionChanged] = v98,
		ref = t1.signUpContentFrameRef,
		LayoutOrder = 3,
		Selectable = false,
		BackgroundTransparency = 1
	}

	return React.createElement(FullscreenPageWithSafeArea, {
		includeStatusBar = true,
		BackgroundColor3 = if not FFlagEnableLeftNavOnConsole or v55.uiMode ~= UiMode.TenFoot then nil else v54.Theme.BackgroundDefault.Color,
		BackgroundTransparency = (not FFlagEnableLeftNavOnConsole or v55.uiMode ~= UiMode.TenFoot) and 1 or v54.Theme.BackgroundDefault.Transparency,
		buttonRef = v68,
		renderFullscreenBackground = if not v56 then v74 else nil
	}, {
		UserInputSink = t1.isSignUpInProgress and React.createElement("ImageButton", {
			ZIndex = 2,
			BackgroundTransparency = 1,
			Image = "",
			Size = UDim2.new(1, 0, 1, 0)
		}),
		Container = React.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			Size = UDim2.new(1, 0, 1, -n1),
			Position = UDim2.new(0.5, 0, 0, n2),
			AnchorPoint = Vector2.new(0.5, 0),
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(9, 9, 9, 9),
			Image = GetImageData("LuaApp/buttons/buttonFill") or "LuaApp/buttons/buttonFill",
			ImageColor3 = v54.Theme.BackgroundUIDefault.Color,
			ImageTransparency = not v56 and 0 or 1
		}, {
			ContainerListLayout = if not v57 then nil else React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				Padding = UDim.new(0, n5)
			}),
			SizeConstraint = React.createElement("UISizeConstraint", {
				MaxSize = if not v56 then vector2 else vector2_2
			}),
			HeaderFrame = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, 48),
				Position = UDim2.new(0.5, 0, 0, 0),
				AnchorPoint = Vector2.new(0.5, 0),
				AutomaticSize = if not v57 then nil else Enum.AutomaticSize.Y
			}, {
				BackButton = if v55.uiMode ~= UiMode.VR and v57 then nil else React.createElement(ImageSetButton, {
					Size = uDim2,
					AutoButtonColor = false,
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 12, 0.5, 0),
					AnchorPoint = Vector2.new(0, 0.5),
					ScaleType = Enum.ScaleType.Fit,
					Image = Images["icons/navigation/close"],
					ImageColor3 = v54.Theme.UIEmphasis.Color,
					ImageTransparency = 0,
					[React.Event.Activated] = t1.navigateBack,
					ref = v63
				}),
				Title = v61.signUpText and React.createElement(FitTextLabel, {
					BackgroundTransparency = 1,
					TextWrapped = true,
					Position = UDim2.new(0, 0, 0.5, 0),
					Size = UDim2.new(1, 0, 0, 0),
					AnchorPoint = Vector2.new(0, 0.5),
					fitAxis = FitChildren.FitAxis.Height,
					Text = v61.signUpText or "",
					Font = v54.Font.CaptionHeader.Font,
					TextSize = v89,
					TextColor3 = v54.Theme.TextEmphasis.Color,
					TextTransparency = v54.Theme.TextEmphasis.Transparency,
					TextXAlignment = Enum.TextXAlignment.Center
				})
			}),
			Divider = if v57 then nil else React.createElement("Frame", {
				BackgroundTransparency = 0,
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, 1),
				Position = UDim2.new(0.5, 0, 0, 48),
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundColor3 = v54.Theme.UIEmphasis.Color
			}),
			SignUpContentFrame = React.createElement("ScrollingFrame", t5, {
				ContentPadding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 24),
					PaddingRight = UDim.new(0, 24),
					PaddingTop = UDim.new(0, not v62 and 48 or 25)
				}),
				ListLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = UDim.new(0, n4)
				}),
				BirthdayBar = if not v56 then React.createElement(AuthBirthdayBar, {
					layoutOrder = 1,
					onBirthdaySelected = t1.onBirthdaySelected,
					onBirthdayFocused = t1.onBirthdayFocused,
					autoFocusOnMount = v80,
					buttonRef = v67,
					enableAuditContentCapture = GetFFlagEnableAuditForSso()
				}) else nil,
				BirthdayGenderPicker = if not v56 then nil else React.createElement("Frame", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					ZIndex = 2,
					Size = UDim2.new(1, 0, 0, 140),
					ref = v67
				}, {
					BirthdayPicker = React.createElement(BirthdateDropdownSelector, {
						layoutOrder = 1,
						onBirthdaySelected = t1.onBirthdaySelected,
						alignment = Enum.HorizontalAlignment.Left,
						enableAuditContentCapture = GetFFlagEnableAuditForSso()
					}),
					GenderSelector = React.createElement(GenderDropdownSelector, {
						layoutOrder = 2,
						onGenderChanged = t1.onGenderChanged,
						alignment = Enum.HorizontalAlignment.Right,
						enableAuditContentCapture = GetFFlagEnableAuditForSso()
					})
				}),
				ContactInfoField = v80 and React.createElement(ContactInfoField, {
					layoutOrder = 2,
					Under13 = birthday and DateHelper:isRecentOrFutureDate(birthday.Month, birthday.Day, birthday.Year + 13),
					SetContactMethod = t1.SetContactMethod,
					SetPhoneNumber = t1.SetPhoneNumber,
					SetEmail = t1.SetEmail,
					contactMethod = t1.contactMethod,
					phoneCountryCodeSelectorCallback = t1.phoneCountryCodeSelectorCallback
				}),
				BackgroundPanel = v80 and React.createElement("Frame", {
					LayoutOrder = 3,
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 0, 0, 6)
				}, {
					LightPanel = React.createElement("Frame", {
						BorderSizePixel = 0,
						Size = UDim2.new(0, 100000, 0, 100000),
						Position = UDim2.new(0, 0, 1, 0),
						BackgroundColor3 = v54.Theme.UIDefault.Color,
						AnchorPoint = Vector2.new(0.5, 0)
					})
				}),
				UsernameValidator = React.createElement(CollapsingTextInputValidator, {
					layoutOrder = 4,
					titleTextKey = "Authentication.Login.Label.Username",
					summaryErrorTextKey = s1,
					prerequisiteMet = not not birthday,
					textInputType = v87,
					onInputTextChanged = t1.onUsernameTextChanged,
					onInputTextValidated = v75 and t1.onUsernameTextValidated or t1.onUsernameTextChanged,
					validator = t1.UsernameValidator,
					placeholderText = v61.usernamePlaceholder,
					validatorAdditionalProps = {
						birthday = birthday and birthday:FormatForEndpoint() or "",
						context = UsernameValidationContext.Signup
					},
					textBoxFocusedCallback = t1.onUsernameTextBoxFocused,
					textBoxFocusLostCallback = t1.onTextBoxFocusLost,
					focusedTextBoxPositionChangedCallback = t1.onFocusedTextBoxPositionChanged,
					returnKeyType = Enum.ReturnKeyType.Next,
					onReturnPressedFromOnScreenKeyboard = t1.onUsernameTextChangeCompletedFromKeyboard,
					onAnimationStateChangeCallback = t1.onAnimationStateChangeCallback,
					textBoxRef = t1.usernameTextFieldRef,
					pillClicked = v69,
					updatePillClicked = v71,
					resetPillClicked = v72,
					issueCondition = t1.issueCondition,
					updateIssueCondition = t1.updateIssueCondition,
					loadingSuggestions = t1.loadingSuggestions,
					tokens = v59,
					showDetailedError = v82,
					NextSelectionDown = if not v51 or v75 then nil else t1.passwordTextFieldRef,
					enableAuditContentCapture = GetFFlagEnableAuditForSso()
				}),
				SuggestionsFrame = v75 and React.createElement(SuggestionsFrame, {
					layoutOrder = 4,
					textBoxRef = t1.usernameTextFieldRef,
					usernameValid = t1.usernameValid,
					birthday = birthday and birthday:FormatForEndpoint() or "",
					suggest = UsernameSuggestor,
					context = UsernameValidationContext.Signup,
					pillClicked = v69,
					updatePillClicked = v71,
					resetPillClicked = v72,
					issueCondition = t1.issueCondition,
					usernameSuggestionClicked = t1.usernameSuggestionClicked,
					usernameSuggestionsShown = t1.usernameSuggestionsShown,
					shouldSuggest = t1.shouldSuggest,
					updateSuggestionControlState = t1.updateSuggestionControlState,
					useRefreshButton = t1.useRefreshButton,
					logRefreshButtonClicked = t1.logRefreshButtonClicked,
					loadSuggestions = t1.loadSuggestions,
					finishSuggestions = t1.finishSuggestions,
					loadingSuggestions = t1.loadingSuggestions
				}),
				PasswordValidator = React.createElement(CollapsingTextInputValidator, {
					layoutOrder = 5,
					titleTextKey = "CommonUI.Messages.Label.Password",
					disabled = t1.birthdayFocused,
					summaryErrorTextKey = s2,
					prerequisiteMet = not v84,
					textInputType = Enum.TextInputType.Password,
					onInputTextChanged = t1.onPasswordTextChanged,
					onInputTextValidated = t1.onPasswordTextChanged,
					validator = t1.PasswordValidator,
					placeholderText = v61.passwordPlaceholder,
					validatorAdditionalProps = {
						username = t1.username
					},
					returnKeyType = Enum.ReturnKeyType.Next,
					textBoxFocusedCallback = t1.onPasswordTextBoxFocused,
					textBoxFocusLostCallback = t1.onTextBoxFocusLost,
					focusedTextBoxPositionChangedCallback = t1.onFocusedTextBoxPositionChanged,
					onReturnPressedFromOnScreenKeyboard = t1.onPasswordTextChangeCompletedFromKeyboard,
					onAnimationStateChangeCallback = t1.onAnimationStateChangeCallback,
					textBoxRef = t1.passwordTextFieldRef,
					centralOverlayBlocksInput = v80,
					captureFocusOnTapStart = not t1.isCountryCodeSearchVisible,
					tokens = v59,
					showDetailedError = v83,
					IsKeyboardOverlayUsed = v55.uiMode ~= UiMode.VR,
					enableAuditContentCapture = GetFFlagEnableAuditForSso()
				}),
				GenderSelector = if not v56 then GetFIntLuaLoginGenderSelector() ~= 2 and React.createElement(SignUpGenderSelector, {
					layoutOrder = 7,
					onGenderChanged = t1.onGenderChanged,
					enableAuditContentCapture = GetFFlagEnableAuditForSso()
				}) else nil,
				Spacing = if v56 then nil else React.createElement("Frame", {
					LayoutOrder = 8,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 38)
				}),
				ErrorLabel = if not t1.signUpError then nil else React.createElement(FitTextLabel, {
					LayoutOrder = 9,
					BackgroundTransparency = 1,
					TextWrapped = true,
					Size = UDim2.new(1, 0, 0, 0),
					fitAxis = FitChildren.FitAxis.Height,
					Text = v61.unknownError,
					Font = v54.Font.CaptionBody.Font,
					TextSize = v90,
					TextColor3 = v54.Theme.Alert.Color,
					TextTransparency = v54.Theme.TextDefault.Transparency,
					TextXAlignment = Enum.TextXAlignment.Left
				}),
				SignUpPageButton = React.createElement(Button, {
					layoutOrder = 10,
					buttonType = ButtonType.PrimaryContextual,
					size = UDim2.new(1, 0, 0, n3),
					text = v61.signUpText,
					isDisabled = not t1.isSignUpButtonEnabled,
					isLoading = t1.isSignUpInProgress,
					onActivated = t1.onSignUpClick,
					buttonTextOverride = t4
				}),
				DisclaimerText = React.createElement(TitleAndParagraph, {
					layoutOrder = 11,
					textXAlignment = Enum.TextXAlignment.Center,
					paragraphTextKeys = t2,
					paragraphTextArgs = t3,
					enableAuditContentCapture = GetFFlagEnableAuditForSso()
				}),
				DisclaimerLinks = React.createElement(DisclaimerLinks, {
					LayoutOrder = 12,
					isDualLayout = v57,
					fillDirection = Enum.FillDirection.Horizontal,
					enableAuditContentCapture = GetFFlagEnableAuditForSso()
				}),
				ScrollPadding = v79 and React.createElement("Frame", {
					LayoutOrder = 13,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, t1.onScreenKeyboardHeight * 2)
				})
			}),
			Footer = v80 and (v62 and React.createElement("Frame", {
				BackgroundTransparency = 1,
				ClipsDescendants = true,
				Size = UDim2.new(1, 0, 0, 12),
				Position = UDim2.new(0, 0, 1, -12)
			}, {
				Rounding = React.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 2, 0),
					Position = UDim2.new(0, 0, -1, 0),
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(9, 9, 9, 9),
					Image = GetImageData("LuaApp/buttons/buttonFill") or "LuaApp/buttons/buttonFill",
					ImageColor3 = v54.Theme.UIDefault.Color
				})
			}))
		})
	})
end
