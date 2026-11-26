local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local formFactor = require("@luauforge/bundled/dGN").Enums.FormFactor
local useUiModeInfo = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useUiModeInfo
local uiMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").UiMode

local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local images = UIBlox.App.ImageSet.Images
local imageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local button = UIBlox.App.Button.Button
local buttonType = UIBlox.App.Button.Enum.ButtonType

local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local getImageData = require("@game/CorePackages/Workspace/Packages/RobloxAppAssets").GetImageData
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FitFrame = require(CorePackages.Packages.FitFrame)
local fitTextLabel = FitFrame.FitTextLabel

local Foundation2 = require(CorePackages.Packages.Foundation)
local useTextSizeOffset = Foundation2.Hooks.useTextSizeOffset

local module = require("@luauforge/bundled/gxM")
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens

local useAnimatedScrollToSelection = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useAnimatedScrollToSelection

local AuthCommon = require("@game/CorePackages/Workspace/Packages/AuthCommon")

local module3 = require("@luauforge/bundled/hLP")
require("@game/CorePackages/Packages/_Index/RoduxShareLinks/RoduxShareLinks/Enums/LinkStatus")

local module4 = require("@luauforge/bundled/gyM")
local module5 = require("@luauforge/bundled/hLQ")
local module6 = require("@luauforge/bundled/hLU")
local module7 = require("@luauforge/bundled/gyP")
local module8 = require("@luauforge/bundled/hLL")
local module9 = require("@luauforge/bundled/hLW")
local module10 = require("@luauforge/bundled/gyQ")
local module11 = require("@luauforge/bundled/gyI")
local module12 = require("@luauforge/bundled/grz")
local module13 = require("@luauforge/bundled/hLF")
local module14 = require("@luauforge/bundled/hLX")
local authBackgroundContainer = AuthCommon.Components.AuthBackgroundContainer

local module15 = require("@luauforge/bundled/ect")

local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppPolicy")
local useSignUpPageNavigationBindings = AuthCommon.Hooks.useSignUpPageNavigationBindings

local dateHelper = require("@luauforge/bundled/geM").DateHelper

local getFFlagEnableTextFieldContentType = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableTextFieldContentType
local module17 = require("@luauforge/bundled/hMa")

local getFFlagLuaAppEnable10ftSignUpView = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagLuaAppEnable10ftSignUpView
local getFFlagEnableAuditForSso = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableAuditForSso

local fFlagAuthValidatorRebindTextBoxRef = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAuthValidatorRebindTextBoxRef
local module18 = require("@luauforge/bundled/gyR")

local udim = UDim2.new(0, 36, 0, 36)

local vector2 = Vector2.new(540, 1080)
local vector2_2 = Vector2.new(850, 1080)

local module19 = require("@luauforge/bundled/hMb")

local defineFastFlag = game:DefineFastFlag("AuthRefactorConsoleDisclaimerText", false)

local module20 = require("@luauforge/bundled/hLT")

return function(props)
	local v5 = useStyle()
	local v6 = useUiModeInfo()
	local v7 = module14()
	local v8 = module17() and v6.uiMode == uiMode.TenFoot and true or v6.uiMode == uiMode.VR
	local v9 = getFFlagLuaAppEnable10ftSignUpView() or v6.uiMode == uiMode.VR
	local v10 = if v9 then useDesignTokens() else nil
	local signUpView = if v9 and v10 then v10.LuaApps.SignUpView else nil
	local v11 = useAppPolicy(function(p2)
		return p2.getPlatformAccountName()
	end)

	local v12 = module({
		signUpHeadingText = v7.signUpHeading,
		signUpText = v7.signUpButton,
		usernamePlaceholder = "Authentication.SignUp.Message.Username.NoRealNameUse",
		passwordPlaceholder = "Authentication.SignUp.Label.PasswordPlaceholder",
		unknownError = "Feature.Reauthentication.Message.Error.Default"
	})

	local v13 = useSelector(function(p2)
		return p2.FormFactor
	end) == formFactor.WIDE
	local ref = React.useRef(nil)
	local v14 = ReactFocusNavigation.useFocusedGuiObject()
	local v15 = ReactFocusNavigation.useFocusGuiObject()
	local v16 = useSignUpPageNavigationBindings()
	local v17, v18

	if v8 then
		v17, v18 = ReactFocusNavigation.useDefaultFocusBehavior()
	else
		v17, v18 = ReactFocusNavigation.useDefaultFocusBehavior(v16)
	end

	local state, v19

	if module20 then
		local setState
		state, setState = React.useState(false)
		v19 = setState
		React.useEffect(function()
			if not v8 then
				setState(false)
			end
		end, { v8 })
	else
		state = false
	end

	local state2, setState = React.useState(false)

	local state3, setState2 = React.useState(false)
	local v20 = React.useCallback(function()
		setState2(true)
	end)
	local v21 = React.useCallback(function()
		setState2(false)
	end)
	local v22 = React.useCallback(function()
		return React.createElement(authBackgroundContainer, {
			showImage = v13,
			fallbackBackgroundColor = v5.Theme.BackgroundUIDefault.Color
		})
	end, { v13, v5 })

	local v23 = props.useUsernameSuggestions()

	local birthday = props.birthday

	local v24 = 0
	local v25 = 0
	local v26 = props.onScreenKeyboardHeight > 0
	local v27 = props.useVerifiedSignup()

	local v29 = true
	local v30 = true

	local v31 = not props.validUsernameEntered()

	local v32 = "Authentication.SignUp.Label.ErrorsWithUsername"
	local v33 = "Authentication.SignUp.Label.ErrorsWithPassword"

	if birthday then
		if v31 then
			v33 = "Authentication.SignUp.Response.UsernameMustBeSetFirst"
			v30 = false
		end
	else
		v32 = "Authentication.SignUp.Response.BirthdayMustBeSetFirst"
		v33 = v32
		v29 = false
		v31 = true
	end

	if v13 then
		if v26 then
			v24 = props.onScreenKeyboardHeight + 10
		else
			v24 = 48
			v25 = 24
		end
	end

	local username = getFFlagEnableTextFieldContentType() and Enum.TextInputType.Username
		or Enum.TextInputType.NoSuggestions

	local v35 = 36
	local v36 = v5.Font.BaseSize * v5.Font.Header1.RelativeSize
	local v37 = v5.Font.BaseSize * v5.Font.CaptionBody.RelativeSize
	local v38 = 5
	local v39 = 1
	local v40 = nil

	local v41 = { {} }
	local v42

	if v8 and v11 then
		if defineFastFlag then
			v42 = {
				{
					"Authentication.SignUp.Description.VerificationLinkingText",
					platform = v11
				}
			}
		else
			v42 = { "Authentication.SignUp.Description.VerificationLinkingText" }

			v41 = {
				{ platform = v11 }
			}
		end
	else
		v42 = { "Authentication.SignUp.Description.VerificationPage" }
	end

	if v9 and signUpView then
		v25 = signUpView.marginTop
		v37 = signUpView.textCaptionHeaderSize
		v36 = signUpView.textHeaderSize
		v35 = signUpView.buttonHeight
		v38 = signUpView.contentPadding
		v39 = signUpView.headerPadding
		v40 = { Size = UDim2.fromScale(1, 1), TextSize = signUpView.buttonTextSize }
	end

	React.useEffect(function()
		if v14 and ref.current then
			v15(ref.current)
		end
	end, {})

	local v43 = useTextSizeOffset()
	local v44, v45 = useAnimatedScrollToSelection(Enum.ScrollingDirection.Y, v24 + 49 + v43)

	local v46 = {
		BorderSizePixel = 0,
		CanvasSize = UDim2.new(1, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasPosition = v44,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ScrollBarImageTransparency = 1,
		Position = UDim2.new(0.5, 0, 0, 49),
		AnchorPoint = Vector2.new(0.5, 0),
		Size = UDim2.new(1, 0, 1, -(49 + (v13 and v27 and 12 or 0) + v25 + v43)),
		[React.Change.CanvasSize] = props.onSignUpContentFrameCanvasSizeChange,
		[React.Event.SelectionChanged] = v45,
		ref = props.signUpContentFrameRef,
		LayoutOrder = 3,
		Selectable = false,
		BackgroundTransparency = 1
	}

	if module20 and state then
		v46.ScrollingEnabled = false
		v46[React.Event.SelectionChanged] = nil
	end

	local createElement = React.createElement
	local v49 = if v6.uiMode == uiMode.TenFoot then v5.Theme.BackgroundDefault.Color else nil
	local v48 = {
		BackgroundColor3 = v49,
		BackgroundTransparency = v6.uiMode ~= uiMode.TenFoot and 1 or v5.Theme.BackgroundDefault.Transparency,
		includeStatusBar = true,
		buttonRef = v18,
		renderFullscreenBackground = 0
	}

	if v8 then
		v22 = nil
	end

	v48.renderFullscreenBackground = v22
	local v50 = {
		UserInputSink = props.isSignUpInProgress and React.createElement("ImageButton", {
			ZIndex = 2,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Image = ""
		}),
		Container = 0
	}

	local createElement2 = React.createElement
	local v52 = {
		Size = UDim2.new(1, 0, 1, -v24),
		Position = UDim2.new(0.5, 0, 0, v25),
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundTransparency = 1,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(9, 9, 9, 9),
		Image = getImageData("LuaApp/buttons/buttonFill") or "LuaApp/buttons/buttonFill",
		ImageColor3 = v5.Theme.BackgroundUIDefault.Color,
		ImageTransparency = v8 and 1 or 0,
		ClipsDescendants = true
	}

	local v53 = if v9 then React.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		Padding = UDim.new(0, v39)
	}) else nil
	local children = {
		ContainerListLayout = v53,
		SizeConstraint = React.createElement("UISizeConstraint", {
			MaxSize = if v8 then vector2_2 else vector2
		}),
		HeaderFrame = 0,
		Divider = 0,
		SignUpContentFrame = 0,
		Footer = 0
	}

	local createElement4 = React.createElement
	local v58 = {
		Size = UDim2.new(1, 0, 0, 48),
		Position = UDim2.new(0.5, 0, 0, 0),
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		AutomaticSize = 0
	}

	local v59 = if v9 then Enum.AutomaticSize.Y else nil
	v58.AutomaticSize = v59
	local v61

	if v6.uiMode == uiMode.VR or not v9 then
		v61 = React.createElement(imageSetButton, {
			Size = udim,
			AutoButtonColor = false,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 12, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			ScaleType = Enum.ScaleType.Fit,
			Image = images["icons/navigation/close"],
			ImageColor3 = v5.Theme.UIEmphasis.Color,
			ImageTransparency = 0,
			[React.Event.Activated] = props.navigateBack,
			ref = ref
		})
	end

	children.HeaderFrame = createElement4("Frame", v58, {
		BackButton = v61,
		Title = v12.signUpHeadingText and React.createElement(fitTextLabel, {
			Position = UDim2.new(0, 0, 0.5, 0),
			Size = UDim2.new(1, 0, 0, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			width = UDim.new(1, 0),
			BackgroundTransparency = 1,
			Text = v12.signUpHeadingText or "",
			TextWrapped = true,
			Font = normalizeFontFace(v5.Tokens.Typography.CaptionLarge.Font),
			TextSize = v36,
			TextColor3 = v5.Theme.TextEmphasis.Color,
			TextTransparency = v5.Theme.TextEmphasis.Transparency,
			TextXAlignment = Enum.TextXAlignment.Center
		})
	})

	local v62 = if not v9 then React.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 1),
		Position = UDim2.new(0.5, 0, 0, 48),
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundTransparency = 0,
		BackgroundColor3 = v5.Theme.UIEmphasis.Color,
		LayoutOrder = 2
	}) else nil
	children.Divider = v62

	local createElement5 = React.createElement
	local children2 = {
		ContentPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 24),
			PaddingRight = UDim.new(0, 24),
			PaddingTop = UDim.new(0, v13 and 25 or 48)
		}),
		ListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, v38)
		}),
		BirthdayBar = 0,
		BirthdayGenderPicker = 0,
		ContactInfoField = 0,
		BackgroundPanel = 0,
		UsernameValidator = 0,
		SuggestionsFrame = 0,
		PasswordValidator = 0,
		GenderSelector = 0,
		Spacing = 0,
		ErrorLabel = 0,
		SignUpPageButton = 0,
		DisclaimerText = 0,
		DisclaimerLinks = 0,
		ScrollPadding = 0
	}

	local v64 = if not v8 then React.createElement(module4, {
		layoutOrder = 1,
		onBirthdaySelected = props.onBirthdaySelected,
		onBirthdayFocused = props.onBirthdayFocused,
		autoFocusOnMount = v27,
		buttonRef = v17,
		enableAuditContentCapture = getFFlagEnableAuditForSso()
	}) else nil
	children2.BirthdayBar = v64
	local v65

	if v8 then
		local createElement6 = React.createElement
		local v67 = {
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, 140),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 2,
			ref = v17
		}

		local children3 = {
			BirthdayPicker = React.createElement(module6, {
				onBirthdaySelected = props.onBirthdaySelected,
				alignment = Enum.HorizontalAlignment.Left,
				layoutOrder = 1,
				enableAuditContentCapture = getFFlagEnableAuditForSso(),
				onMenuOpenChange = if module20 then v19 else nil
			}),
			GenderSelector = 0
		}

		local createElement8 = React.createElement
		local v72 = {
			onGenderChanged = props.onGenderChanged,
			alignment = Enum.HorizontalAlignment.Right,
			layoutOrder = 2,
			enableAuditContentCapture = getFFlagEnableAuditForSso(),
			onMenuOpenChange = 0
		}

		if not module20 then
			v19 = nil
		end

		v72.onMenuOpenChange = v19
		children3.GenderSelector = createElement8(module5, v72)
		v65 = createElement6("Frame", v67, children3)
	end

	children2.BirthdayGenderPicker = v65

	children2.ContactInfoField = v27 and React.createElement(module13, {
		layoutOrder = 2,
		Under13 = birthday and dateHelper:isRecentOrFutureDate(
			birthday.Month,
			birthday.Day,
			birthday.Year + 13
		),
		SetContactMethod = props.SetContactMethod,
		SetPhoneNumber = props.SetPhoneNumber,
		SetEmail = props.SetEmail,
		contactMethod = props.contactMethod,
		phoneCountryCodeSelectorCallback = props.phoneCountryCodeSelectorCallback
	})

	children2.BackgroundPanel = v27
		and React.createElement(
			"Frame",
			{
				Size = UDim2.new(0, 0, 0, 6),
				LayoutOrder = 3,
				BackgroundTransparency = 1
			},
			{
				LightPanel = React.createElement("Frame", {
					BorderSizePixel = 0,
					Size = UDim2.new(0, 100000, 0, 100000),
					Position = UDim2.new(0, 0, 1, 0),
					BackgroundColor3 = v5.Theme.UIDefault.Color,
					AnchorPoint = Vector2.new(0.5, 0)
				})
			}
		)

	local createElement6 = React.createElement
	local v67 = {
		layoutOrder = 4,
		titleTextKey = "Authentication.Login.Label.Username",
		summaryErrorTextKey = v32,
		prerequisiteMet = birthday and true or false,
		textInputType = username,
		onInputTextChanged = props.onUsernameTextChanged,
		onInputTextValidated = v23 and props.onUsernameTextValidated or props.onUsernameTextChanged,
		validator = props.UsernameValidator,
		placeholderText = v12.usernamePlaceholder,
		validatorAdditionalProps = {
			birthday = birthday and birthday:FormatForEndpoint() or "",
			context = module3.Signup
		},
		textBoxFocusedCallback = props.onUsernameTextBoxFocused,
		textBoxFocusLostCallback = props.onTextBoxFocusLost,
		focusedTextBoxPositionChangedCallback = props.onFocusedTextBoxPositionChanged,
		returnKeyType = Enum.ReturnKeyType.Next,
		onReturnPressedFromOnScreenKeyboard = props.onUsernameTextChangeCompletedFromKeyboard,
		onAnimationStateChangeCallback = props.onAnimationStateChangeCallback,
		textBoxRef = props.usernameTextFieldRef,
		pillClicked = state3,
		updatePillClicked = v20,
		resetPillClicked = v21,
		issueCondition = props.issueCondition,
		updateIssueCondition = props.updateIssueCondition,
		loadingSuggestions = props.loadingSuggestions,
		tokens = signUpView,
		showDetailedError = v29,
		NextSelectionDown = 0,
		enableAuditContentCapture = 0
	}

	local v68 = if module19 and not state2 then props.passwordTextFieldRef else nil
	v67.NextSelectionDown = v68

	v67.enableAuditContentCapture = getFFlagEnableAuditForSso()
	children2.UsernameValidator = createElement6(module7, v67)

	if v23 then
		local createElement7 = React.createElement
		local v70 = {
			layoutOrder = 4,
			textBoxRef = props.usernameTextFieldRef,
			usernameText = 0,
			usernameValid = 0,
			birthday = 0,
			suggest = 0,
			context = 0,
			pillClicked = 0,
			updatePillClicked = 0,
			resetPillClicked = 0,
			issueCondition = 0,
			usernameSuggestionClicked = 0,
			usernameSuggestionsShown = 0,
			shouldSuggest = 0,
			updateSuggestionControlState = 0,
			useRefreshButton = 0,
			logRefreshButtonClicked = 0,
			loadSuggestions = 0,
			finishSuggestions = 0,
			loadingSuggestions = 0,
			onShowSuggestionsChanged = 0
		}
		local v71 = if fFlagAuthValidatorRebindTextBoxRef then props.username else nil
		v70.usernameText = v71
		v70.usernameValid = props.usernameValid
		v70.birthday = birthday and birthday:FormatForEndpoint() or ""
		v70.suggest = module9
		v70.context = module3.Signup
		v70.pillClicked = state3
		v70.updatePillClicked = v20
		v70.resetPillClicked = v21
		v70.issueCondition = props.issueCondition
		v70.usernameSuggestionClicked = props.usernameSuggestionClicked
		v70.usernameSuggestionsShown = props.usernameSuggestionsShown
		v70.shouldSuggest = props.shouldSuggest
		v70.updateSuggestionControlState = props.updateSuggestionControlState
		v70.useRefreshButton = props.useRefreshButton
		v70.logRefreshButtonClicked = props.logRefreshButtonClicked
		v70.loadSuggestions = props.loadSuggestions
		v70.finishSuggestions = props.finishSuggestions
		v70.loadingSuggestions = props.loadingSuggestions

		if not module19 then
			setState = nil
		end

		v70.onShowSuggestionsChanged = setState
		v23 = createElement7(module8, v70)
	end

	children2.SuggestionsFrame = v23

	children2.PasswordValidator = React.createElement(module7, {
		disabled = props.birthdayFocused,
		layoutOrder = 5,
		titleTextKey = "CommonUI.Messages.Label.Password",
		summaryErrorTextKey = v33,
		prerequisiteMet = not v31,
		textInputType = Enum.TextInputType.Password,
		onInputTextChanged = props.onPasswordTextChanged,
		onInputTextValidated = props.onPasswordTextChanged,
		validator = props.PasswordValidator,
		placeholderText = v12.passwordPlaceholder,
		validatorAdditionalProps = { username = props.username },
		returnKeyType = Enum.ReturnKeyType.Next,
		textBoxFocusedCallback = props.onPasswordTextBoxFocused,
		textBoxFocusLostCallback = props.onTextBoxFocusLost,
		focusedTextBoxPositionChangedCallback = props.onFocusedTextBoxPositionChanged,
		onReturnPressedFromOnScreenKeyboard = props.onPasswordTextChangeCompletedFromKeyboard,
		onAnimationStateChangeCallback = props.onAnimationStateChangeCallback,
		textBoxRef = props.passwordTextFieldRef,
		centralOverlayBlocksInput = v27,
		captureFocusOnTapStart = not props.isCountryCodeSearchVisible,
		tokens = signUpView,
		showDetailedError = v30,
		IsKeyboardOverlayUsed = v6.uiMode ~= uiMode.VR,
		enableAuditContentCapture = getFFlagEnableAuditForSso()
	})
	local v69

	if not v8 then
		if module18() == 2 then
			v69 = false
		else
			v69 = React.createElement(module10, {
				layoutOrder = 7,
				onGenderChanged = props.onGenderChanged,
				enableAuditContentCapture = getFFlagEnableAuditForSso()
			})
		end
	end

	children2.GenderSelector = v69

	local v70 = if not v8 then React.createElement("Frame", {
		LayoutOrder = 8,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 38)
	}) else nil
	children2.Spacing = v70

	local v71 = if props.signUpError then React.createElement(fitTextLabel, {
		LayoutOrder = 9,
		Size = UDim2.new(1, 0, 0, 0),
		width = UDim.new(1, 0),
		BackgroundTransparency = 1,
		Text = v12.unknownError,
		TextWrapped = true,
		Font = normalizeFontFace(v5.Tokens.Typography.BodySmall.Font),
		TextSize = v37,
		TextColor3 = v5.Theme.Alert.Color,
		TextTransparency = v5.Theme.TextDefault.Transparency,
		TextXAlignment = Enum.TextXAlignment.Left
	}) else nil
	children2.ErrorLabel = v71

	children2.SignUpPageButton = React.createElement(button, {
		buttonType = buttonType.PrimaryContextual,
		layoutOrder = 10,
		size = UDim2.new(1, 0, 0, v35),
		text = v12.signUpText,
		isDisabled = not props.isSignUpButtonEnabled,
		isLoading = props.isSignUpInProgress,
		onActivated = props.onSignUpClick,
		buttonTextOverride = v40
	})

	children2.DisclaimerText = React.createElement(module11, {
		layoutOrder = 11,
		textXAlignment = Enum.TextXAlignment.Center,
		paragraphTextKeys = v42,
		paragraphTextArgs = v41,
		enableAuditContentCapture = getFFlagEnableAuditForSso()
	})

	children2.DisclaimerLinks = React.createElement(module12, {
		isDualLayout = v9,
		fillDirection = Enum.FillDirection.Horizontal,
		LayoutOrder = 12,
		enableAuditContentCapture = getFFlagEnableAuditForSso()
	})

	children2.ScrollPadding = v26 and React.createElement("Frame", {
		LayoutOrder = 13,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, props.onScreenKeyboardHeight * 2)
	})
	children.SignUpContentFrame = createElement5("ScrollingFrame", v46, children2)

	children.Footer = v27
		and v13
		and React.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 0, 12),
				Position = UDim2.new(0, 0, 1, -12),
				BackgroundTransparency = 1,
				ClipsDescendants = true
			},
			{
				Rounding = React.createElement(imageSetLabel, {
					Size = UDim2.new(1, 0, 2, 0),
					Position = UDim2.new(0, 0, -1, 0),
					BackgroundTransparency = 1,
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(9, 9, 9, 9),
					Image = getImageData("LuaApp/buttons/buttonFill") or "LuaApp/buttons/buttonFill",
					ImageColor3 = v5.Theme.UIDefault.Color
				})
			}
		)
	v50.Container = createElement2(imageSetLabel, v52, children)
	return createElement(module15, v48, v50)
end
