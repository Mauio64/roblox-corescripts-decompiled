local CorePackages = game:GetService("CorePackages")

local AuthCommon = require("@game/CorePackages/Workspace/Packages/AuthCommon")
local textInputBoxWithBorder = AuthCommon.Components.TextInputBoxWithBorder
local authStatefulRoundCornerBorder = AuthCommon.Components.AuthStatefulRoundCornerBorder

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local useStyle = UIBlox.Core.Style.useStyle
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

local module2 = require("@luauforge/bundled/hAt")
local module3 = require("@luauforge/bundled/hAv")

local module4 = require("@luauforge/bundled/fsy")
local module5 = require("@luauforge/bundled/fMG")

local v5 = { Age = 1, AgeMonth = 2, MonthYear = 3 }

local function BirthdayField(props)
	local v6 = useStyle()
	local v7 = useLocalization({
		ageLabel = "Authentication.SignUp.Label.Age",
		helpText = "Authentication.SignUp.Description.BirthdayValuePropC",
		errorMessage = "Authentication.SignUp.Response.InvalidBirthday"
	})

	local state, setState = React.useState(authStatefulRoundCornerBorder.BorderState.Default)
	local state2, setState2 = React.useState(false)

	local function onChangeTextCallback()
		if props.ageTextFieldRef and props.ageTextFieldRef.current then
			local text = props.ageTextFieldRef.current.Text

			if string.len(text) > 2 then
				props.ageTextFieldRef.current.Text = string.sub(text, 1, 2)
			end
		end

		props.onAgeChange(props.ageTextFieldRef.current.Text)
	end

	local function onFocused()
		if not props.hasBirthdayError and props.variant == 1 then
			setState(authStatefulRoundCornerBorder.BorderState.Focused)
		end

		props.analytics.reportAgeFocus(module4.Context.SinglePageSignUpScreen)
		setState2(true)
	end

	local function onFocusLost()
		if not props.hasBirthdayError and props.variant == 1 then
			setState(authStatefulRoundCornerBorder.BorderState.Default)
		end

		setState2(false)
	end

	local function onFocused2()
		props.analytics.reportYearFocus(module4.Context.SinglePageSignUpScreen)
		setState2(true)
	end

	local function onFocusLost2()
		setState2(false)
	end

	local function onMonthInputConfirmed()
		props.analytics.reportButtonClicked(
			module4.Context.SinglePageSignUpScreen,
			module4.Button.ConfirmBirthdayMonth
		)
	end

	React.useEffect(function()
		if props.hasBirthdayError then
			setState(authStatefulRoundCornerBorder.BorderState.Error)
		else
			setState(authStatefulRoundCornerBorder.BorderState.Default)
		end
	end, { props.hasBirthdayError })

	React.useEffect(function()
		if props.variant == 1 and props.ageTextFieldRef and props.ageTextFieldRef.current then
			props.ageTextFieldRef.current:CaptureFocus()
		end
	end, { props.variant, props.ageTextFieldRef.current })

	local createElement = React.createElement
	local v9 = {
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		ZIndex = 4
	}

	local v10 = {
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, -10)
		}),
		AgeInput = props.variant == 1 and React.createElement(textInputBoxWithBorder, {
			textInputType = Enum.TextInputType.Number,
			textInputHeight = props.textInputHeight,
			textInputListPadding = 6,
			placeholderText = v7.ageLabel,
			labelText = v7.ageLabel,
			borderState = state,
			onChangeTextCallback = onChangeTextCallback,
			errorText = props.hasBirthdayError and v7.errorMessage or "",
			layoutOrder = 3,
			onFocused = onFocused,
			onFocusLost = onFocusLost,
			textBoxRef = props.ageTextFieldRef
		}),
		AgeAndMonthInput = props.variant == 2 and React.createElement(module2, {
			layoutOrder = 3,
			errorText = props.hasBirthdayError and v7.errorMessage or "",
			textInputHeight = props.textInputHeight,
			onAgeAndMonthChange = props.onAgeAndMonthChange,
			onFocused = onFocused,
			onFocusLost = onFocusLost,
			onMonthInputConfirmed = onMonthInputConfirmed,
			screenSize = props.screenSize,
			textBoxRef = props.ageTextFieldRef
		}),
		MonthAndYearInput = props.variant == 3 and React.createElement(module3, {
			layoutOrder = 3,
			errorText = props.hasBirthdayError and v7.errorMessage or "",
			textInputHeight = props.textInputHeight,
			onMonthAndYearChange = props.onMonthAndYearChange,
			onFocused = onFocused2,
			onFocusLost = onFocusLost2,
			onMonthInputConfirmed = onMonthInputConfirmed,
			screenSize = props.screenSize,
			textBoxRef = props.ageTextFieldRef
		}),
		Padding = props.hasBirthdayError and React.createElement("Frame", {
			Size = UDim2.new(0, 0, 0, 21),
			BackgroundTransparency = 1,
			LayoutOrder = 5
		}),
		ValueProp = 0
	}

	if state2 then
		local createElement2 = React.createElement
		local v15 = {
			Text = v7.helpText,
			Font = 0,
			FontFace = 0,
			TextSize = 0,
			TextColor3 = 0,
			TextTransparency = 0,
			TextXAlignment = 0,
			TextWrapped = true,
			Size = 0,
			AutomaticSize = 0,
			BackgroundTransparency = 1,
			ZIndex = 0,
			LayoutOrder = 6
		}
		local v16 = if not foundationFontFaceMigration then v6.Font.CaptionBody.Font else nil
		v15.Font = v16

		local v17 = if foundationFontFaceMigration then normalizeFontFace(v6.Tokens.Typography.BodySmall.Font) else nil
		v15.FontFace = v17

		v15.TextSize = v6.Font.BaseSize * v6.Font.CaptionBody.RelativeSize
		v15.TextColor3 = v6.Theme.TextDefault.Color
		v15.TextTransparency = v6.Theme.TextDefault.Transparency
		v15.TextXAlignment = Enum.TextXAlignment.Left

		v15.Size = UDim2.new(1, 0, 0, 0)
		v15.AutomaticSize = Enum.AutomaticSize.Y
		state2 = createElement2("TextLabel", v15)
	end

	v10.ValueProp = state2
	return createElement("Frame", v9, v10)
end

return (require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices.connect({ analytics = module5 })(BirthdayField))
