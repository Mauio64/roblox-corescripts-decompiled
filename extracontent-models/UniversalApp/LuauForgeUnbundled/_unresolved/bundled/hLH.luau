local CorePackages = game:GetService("CorePackages")

local AuthCommon = require("@game/CorePackages/Workspace/Packages/AuthCommon")
local textInputBoxWithBorder = AuthCommon.Components.TextInputBoxWithBorder
local authStatefulRoundCornerBorder = AuthCommon.Components.AuthStatefulRoundCornerBorder

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local useStyle = UIBlox.Core.Style.useStyle
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

local module2 = require("@luauforge/bundled/hLI")
local module3 = require("@luauforge/bundled/hLK")

local module4 = require("@luauforge/bundled/fzS")
local module5 = require("@luauforge/bundled/grb")

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

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		ZIndex = 4
	}, {
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
		ValueProp = state2 and React.createElement("TextLabel", {
			Text = v7.helpText,
			FontFace = normalizeFontFace(v6.Tokens.Typography.BodySmall.Font),
			TextSize = v6.Font.BaseSize * v6.Font.CaptionBody.RelativeSize,
			TextColor3 = v6.Theme.TextDefault.Color,
			TextTransparency = v6.Theme.TextDefault.Transparency,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			ZIndex = 0,
			LayoutOrder = 6
		})
	})
end

return (require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices.connect({ analytics = module5 })(BirthdayField))
