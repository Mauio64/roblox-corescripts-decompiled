local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local formFactor = require("@luauforge/bundled/dDI").Enums.FormFactor
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
local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")
local Foundation = require(CorePackages.Packages.Foundation)
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local v5

if foundationFontFaceMigration then
	local FitFrame = require(CorePackages.Packages.FitFrame)
	v5 = FitFrame.FitTextLabel
else
	v5 = require("@luauforge/bundled/fpE")
end

local Foundation2 = require(CorePackages.Packages.Foundation)
local useTextSizeOffset = Foundation2.Hooks.useTextSizeOffset

local module2 = require("@luauforge/bundled/fTi")
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens

local useAnimatedScrollToSelection = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useAnimatedScrollToSelection

local AuthCommon = require("@game/CorePackages/Workspace/Packages/AuthCommon")

local module4 = require("@luauforge/bundled/hAA")
require("@game/CorePackages/Packages/_Index/RoduxShareLinks/RoduxShareLinks/Enums/LinkStatus")

local module5 = require("@luauforge/bundled/fTO")
local module6 = require("@luauforge/bundled/hAB")
local module7 = require("@luauforge/bundled/hAE")
local module8 = require("@luauforge/bundled/fTR")
local module9 = require("@luauforge/bundled/hAw")
local module10 = require("@luauforge/bundled/hAG")
local module11 = require("@luauforge/bundled/fTS")
local module12 = require("@luauforge/bundled/fTK")
local module13 = require("@luauforge/bundled/fNe")
local module14 = require("@luauforge/bundled/hAq")
local module15 = require("@luauforge/bundled/hAH")
local authBackgroundContainer = AuthCommon.Components.AuthBackgroundContainer

local module16 = require("@luauforge/bundled/dYW")

local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppPolicy")
local useSignUpPageNavigationBindings = AuthCommon.Hooks.useSignUpPageNavigationBindings

local dateHelper = require("@luauforge/bundled/fAu").DateHelper

local getFFlagEnableTextFieldContentType = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableTextFieldContentType
local module18 = require("@luauforge/bundled/hAK")

local getFFlagLuaAppEnable10ftSignUpView = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagLuaAppEnable10ftSignUpView
local getFFlagEnableAuditForSso = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableAuditForSso

local fFlagAuthValidatorRebindTextBoxRef = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAuthValidatorRebindTextBoxRef
local module19 = require("@luauforge/bundled/fTT")

local udim = UDim2.new(0, 36, 0, 36)

local vector2 = Vector2.new(540, 1080)
local vector2_2 = Vector2.new(850, 1080)

local defineFastFlag = game:DefineFastFlag("EnableUsernameNextSelectionDown", false)

local defineFastFlag2 = game:DefineFastFlag("AuthRefactorConsoleDisclaimerText", false)

return function(props)
	local v6 = useStyle()
	local v7 = useUiModeInfo()
	local v8 = module15()
	local v9 = module18() and v7.uiMode == uiMode.TenFoot and true or v7.uiMode == uiMode.VR
	local v10 = getFFlagLuaAppEnable10ftSignUpView() or v7.uiMode == uiMode.VR
	local v11 = if v10 then useDesignTokens() else nil
	local signUpView = if v10 and v11 then v11.LuaApps.SignUpView else nil
	local v12 = useAppPolicy(function(p2)
		return p2.getPlatformAccountName()
	end)

	local v13 = module2({
		signUpHeadingText = v8.signUpHeading,
		signUpText = v8.signUpButton,
		usernamePlaceholder = "Authentication.SignUp.Message.Username.NoRealNameUse",
		passwordPlaceholder = "Authentication.SignUp.Label.PasswordPlaceholder",
		unknownError = "Feature.Reauthentication.Message.Error.Default"
	})

	local v14 = useSelector(function(p2)
		return p2.FormFactor
	end) == formFactor.WIDE
	local ref = React.useRef(nil)
	local v15 = ReactFocusNavigation.useFocusedGuiObject()
	local v16 = ReactFocusNavigation.useFocusGuiObject()
	local v17 = useSignUpPageNavigationBindings()
	local v18, v19

	if v9 then
		v18, v19 = ReactFocusNavigation.useDefaultFocusBehavior()
	else
		v18, v19 = ReactFocusNavigation.useDefaultFocusBehavior(v17)
	end

	local state, setState = React.useState(false)
	local v20 = React.useCallback(function()
		setState(true)
	end)
	local v21 = React.useCallback(function()
		setState(false)
	end)
	local v22 = React.useCallback(function()
		return React.createElement(authBackgroundContainer, {
			showImage = v14,
			fallbackBackgroundColor = v6.Theme.BackgroundUIDefault.Color
		})
	end, { v14, v6 })

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

	if v14 then
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
	local v36 = v6.Font.BaseSize * v6.Font.Header1.RelativeSize
	local v37 = v6.Font.BaseSize * v6.Font.CaptionBody.RelativeSize
	local v38 = 5
	local v39 = 1
	local v40 = nil

	local v41 = { {} }
	local v42

	if v9 and v12 then
		if defineFastFlag2 then
			v42 = {
				{
					"Authentication.SignUp.Description.VerificationLinkingText",
					platform = v12
				}
			}
		else
			v42 = { "Authentication.SignUp.Description.VerificationLinkingText" }

			v41 = {
				{ platform = v12 }
			}
		end
	else
		v42 = { "Authentication.SignUp.Description.VerificationPage" }
	end

	if v10 and signUpView then
		v25 = signUpView.marginTop
		v37 = signUpView.textCaptionHeaderSize
		v36 = signUpView.textHeaderSize
		v35 = signUpView.buttonHeight
		v38 = signUpView.contentPadding
		v39 = signUpView.headerPadding
		v40 = { Size = UDim2.fromScale(1, 1), TextSize = signUpView.buttonTextSize }
	end

	React.useEffect(function()
		if v15 and ref.current then
			v16(ref.current)
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
		Size = UDim2.new(1, 0, 1, -(49 + (v14 and v27 and 12 or 0) + v25 + v43)),
		[React.Change.CanvasSize] = props.onSignUpContentFrameCanvasSizeChange,
		[React.Event.SelectionChanged] = v45,
		ref = props.signUpContentFrameRef,
		LayoutOrder = 3,
		Selectable = false,
		BackgroundTransparency = 1
	}

	local createElement = React.createElement
	local v49 = if v7.uiMode == uiMode.TenFoot then v6.Theme.BackgroundDefault.Color else nil
	local v48 = {
		BackgroundColor3 = v49,
		BackgroundTransparency = v7.uiMode ~= uiMode.TenFoot and 1 or v6.Theme.BackgroundDefault.Transparency,
		includeStatusBar = true,
		buttonRef = v19,
		renderFullscreenBackground = 0
	}

	if v9 then
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
		ImageColor3 = v6.Theme.BackgroundUIDefault.Color,
		ImageTransparency = v9 and 1 or 0,
		ClipsDescendants = true
	}

	local v53 = if v10 then React.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		Padding = UDim.new(0, v39)
	}) else nil
	local children = {
		ContainerListLayout = v53,
		SizeConstraint = React.createElement("UISizeConstraint", {
			MaxSize = if v9 then vector2_2 else vector2
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

	local v59 = if v10 then Enum.AutomaticSize.Y else nil
	v58.AutomaticSize = v59
	local v61

	if v7.uiMode == uiMode.VR or not v10 then
		v61 = React.createElement(imageSetButton, {
			Size = udim,
			AutoButtonColor = false,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 12, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			ScaleType = Enum.ScaleType.Fit,
			Image = images["icons/navigation/close"],
			ImageColor3 = v6.Theme.UIEmphasis.Color,
			ImageTransparency = 0,
			[React.Event.Activated] = props.navigateBack,
			ref = ref
		})
	end

	local v62 = v13.signUpHeadingText

	if v62 then
		local createElement5 = React.createElement
		local v64 = {
			Position = UDim2.new(0, 0, 0.5, 0),
			Size = UDim2.new(1, 0, 0, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			fitAxis = 0,
			width = 0,
			BackgroundTransparency = 1,
			Text = 0,
			TextWrapped = true,
			Font = 0,
			TextSize = 0,
			TextColor3 = 0,
			TextTransparency = 0,
			TextXAlignment = 0
		}
		local v65 = if not foundationFontFaceMigration then FitChildren.FitAxis.Height else nil
		v64.fitAxis = v65
		local v66 = if foundationFontFaceMigration then UDim.new(1, 0) else nil
		v64.width = v66

		v64.Text = v13.signUpHeadingText or ""

		local v67 = if foundationFontFaceMigration then normalizeFontFace(v6.Tokens.Typography.CaptionLarge.Font) else v6.Font.CaptionHeader.Font
		v64.Font = v67

		v64.TextSize = v36
		v64.TextColor3 = v6.Theme.TextEmphasis.Color
		v64.TextTransparency = v6.Theme.TextEmphasis.Transparency
		v64.TextXAlignment = Enum.TextXAlignment.Center
		v62 = createElement5(v5, v64)
	end

	children.HeaderFrame = createElement4("Frame", v58, {
		BackButton = v61,
		Title = v62
	})

	local v63 = if not v10 then React.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 1),
		Position = UDim2.new(0.5, 0, 0, 48),
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundTransparency = 0,
		BackgroundColor3 = v6.Theme.UIEmphasis.Color,
		LayoutOrder = 2
	}) else nil
	children.Divider = v63

	local createElement5 = React.createElement
	local children2 = {
		ContentPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 24),
			PaddingRight = UDim.new(0, 24),
			PaddingTop = UDim.new(0, v14 and 25 or 48)
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

	local v65 = if not v9 then React.createElement(module5, {
		layoutOrder = 1,
		onBirthdaySelected = props.onBirthdaySelected,
		onBirthdayFocused = props.onBirthdayFocused,
		autoFocusOnMount = v27,
		buttonRef = v18,
		enableAuditContentCapture = getFFlagEnableAuditForSso()
	}) else nil
	children2.BirthdayBar = v65

	local v66 = if v9 then React.createElement("Frame", {
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, 140),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 2,
		ref = v18
	}, {
		BirthdayPicker = React.createElement(module7, {
			onBirthdaySelected = props.onBirthdaySelected,
			alignment = Enum.HorizontalAlignment.Left,
			layoutOrder = 1,
			enableAuditContentCapture = getFFlagEnableAuditForSso()
		}),
		GenderSelector = React.createElement(module6, {
			onGenderChanged = props.onGenderChanged,
			alignment = Enum.HorizontalAlignment.Right,
			layoutOrder = 2,
			enableAuditContentCapture = getFFlagEnableAuditForSso()
		})
	}) else nil
	children2.BirthdayGenderPicker = v66

	children2.ContactInfoField = v27 and React.createElement(module14, {
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
					BackgroundColor3 = v6.Theme.UIDefault.Color,
					AnchorPoint = Vector2.new(0.5, 0)
				})
			}
		)

	local createElement6 = React.createElement
	local v68 = {
		layoutOrder = 4,
		titleTextKey = "Authentication.Login.Label.Username",
		summaryErrorTextKey = v32,
		prerequisiteMet = birthday and true or false,
		textInputType = username,
		onInputTextChanged = props.onUsernameTextChanged,
		onInputTextValidated = v23 and props.onUsernameTextValidated or props.onUsernameTextChanged,
		validator = props.UsernameValidator,
		placeholderText = v13.usernamePlaceholder,
		validatorAdditionalProps = {
			birthday = birthday and birthday:FormatForEndpoint() or "",
			context = module4.Signup
		},
		textBoxFocusedCallback = props.onUsernameTextBoxFocused,
		textBoxFocusLostCallback = props.onTextBoxFocusLost,
		focusedTextBoxPositionChangedCallback = props.onFocusedTextBoxPositionChanged,
		returnKeyType = Enum.ReturnKeyType.Next,
		onReturnPressedFromOnScreenKeyboard = props.onUsernameTextChangeCompletedFromKeyboard,
		onAnimationStateChangeCallback = props.onAnimationStateChangeCallback,
		textBoxRef = props.usernameTextFieldRef,
		pillClicked = state,
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

	local v69 = if defineFastFlag and not v23 then props.passwordTextFieldRef else nil
	v68.NextSelectionDown = v69

	v68.enableAuditContentCapture = getFFlagEnableAuditForSso()
	children2.UsernameValidator = createElement6(module8, v68)

	if v23 then
		local createElement7 = React.createElement
		local v71 = {
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
			loadingSuggestions = 0
		}
		local v72 = if fFlagAuthValidatorRebindTextBoxRef then props.username else nil
		v71.usernameText = v72
		v71.usernameValid = props.usernameValid
		v71.birthday = birthday and birthday:FormatForEndpoint() or ""
		v71.suggest = module10
		v71.context = module4.Signup
		v71.pillClicked = state
		v71.updatePillClicked = v20
		v71.resetPillClicked = v21
		v71.issueCondition = props.issueCondition
		v71.usernameSuggestionClicked = props.usernameSuggestionClicked
		v71.usernameSuggestionsShown = props.usernameSuggestionsShown
		v71.shouldSuggest = props.shouldSuggest
		v71.updateSuggestionControlState = props.updateSuggestionControlState
		v71.useRefreshButton = props.useRefreshButton
		v71.logRefreshButtonClicked = props.logRefreshButtonClicked
		v71.loadSuggestions = props.loadSuggestions
		v71.finishSuggestions = props.finishSuggestions
		v71.loadingSuggestions = props.loadingSuggestions
		v23 = createElement7(module9, v71)
	end

	children2.SuggestionsFrame = v23

	children2.PasswordValidator = React.createElement(module8, {
		disabled = props.birthdayFocused,
		layoutOrder = 5,
		titleTextKey = "CommonUI.Messages.Label.Password",
		summaryErrorTextKey = v33,
		prerequisiteMet = not v31,
		textInputType = Enum.TextInputType.Password,
		onInputTextChanged = props.onPasswordTextChanged,
		onInputTextValidated = props.onPasswordTextChanged,
		validator = props.PasswordValidator,
		placeholderText = v13.passwordPlaceholder,
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
		IsKeyboardOverlayUsed = v7.uiMode ~= uiMode.VR,
		enableAuditContentCapture = getFFlagEnableAuditForSso()
	})
	local v70

	if not v9 then
		if module19() == 2 then
			v70 = false
		else
			v70 = React.createElement(module11, {
				layoutOrder = 7,
				onGenderChanged = props.onGenderChanged,
				enableAuditContentCapture = getFFlagEnableAuditForSso()
			})
		end
	end

	children2.GenderSelector = v70

	local v71 = if not v9 then React.createElement("Frame", {
		LayoutOrder = 8,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 38)
	}) else nil
	children2.Spacing = v71
	local v72

	if props.signUpError then
		local createElement7 = React.createElement
		local v74 = {
			LayoutOrder = 9,
			Size = UDim2.new(1, 0, 0, 0),
			fitAxis = 0,
			width = 0,
			BackgroundTransparency = 1,
			Text = 0,
			TextWrapped = true,
			Font = 0,
			TextSize = 0,
			TextColor3 = 0,
			TextTransparency = 0,
			TextXAlignment = 0
		}
		local v75 = if not foundationFontFaceMigration then FitChildren.FitAxis.Height else nil
		v74.fitAxis = v75
		local v76 = if foundationFontFaceMigration then UDim.new(1, 0) else nil
		v74.width = v76

		v74.Text = v13.unknownError

		local v77 = if foundationFontFaceMigration then normalizeFontFace(v6.Tokens.Typography.BodySmall.Font) else v6.Font.CaptionBody.Font
		v74.Font = v77

		v74.TextSize = v37
		v74.TextColor3 = v6.Theme.Alert.Color
		v74.TextTransparency = v6.Theme.TextDefault.Transparency
		v74.TextXAlignment = Enum.TextXAlignment.Left
		v72 = createElement7(v5, v74)
	end

	children2.ErrorLabel = v72

	children2.SignUpPageButton = React.createElement(button, {
		buttonType = buttonType.PrimaryContextual,
		layoutOrder = 10,
		size = UDim2.new(1, 0, 0, v35),
		text = v13.signUpText,
		isDisabled = not props.isSignUpButtonEnabled,
		isLoading = props.isSignUpInProgress,
		onActivated = props.onSignUpClick,
		buttonTextOverride = v40
	})

	children2.DisclaimerText = React.createElement(module12, {
		layoutOrder = 11,
		textXAlignment = Enum.TextXAlignment.Center,
		paragraphTextKeys = v42,
		paragraphTextArgs = v41,
		enableAuditContentCapture = getFFlagEnableAuditForSso()
	})

	children2.DisclaimerLinks = React.createElement(module13, {
		isDualLayout = v10,
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
		and v14
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
					ImageColor3 = v6.Theme.UIDefault.Color
				})
			}
		)
	v50.Container = createElement2(imageSetLabel, v52, children)
	return createElement(module16, v48, v50)
end
