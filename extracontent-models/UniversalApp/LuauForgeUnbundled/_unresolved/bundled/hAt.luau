local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local AuthCommon = require("@game/CorePackages/Workspace/Packages/AuthCommon")
local textInputBoxWithBorder = AuthCommon.Components.TextInputBoxWithBorder
local authStatefulRoundCornerBorder = AuthCommon.Components.AuthStatefulRoundCornerBorder

local module2 = require("@luauforge/bundled/hAu")
local useStyle = UIBlox.Core.Style.useStyle
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

return function(props)
	local v5 = useStyle()
	local v6 = useLocalization({
		Age = "Authentication.SignUp.Label.Age",
		Month = "Authentication.SignUp.Label.Month"
	})

	local state, setState = React.useState(0)
	local state2, setState2 = React.useState("")
	local state3, setState3 = React.useState(false)
	local state4, setState4 = React.useState(false)

	local function onMonthSelected(p2)
		setState(p2)
		props.onMonthInputConfirmed()
	end

	local function fn(p2)
		if not state3 then
			setState3(true)
		end

		if props.textBoxRef and props.textBoxRef.current then
			local text = props.textBoxRef.current.Text

			if string.len(text) > 2 then
				props.textBoxRef.current.Text = string.sub(text, 1, 2)
			end
		end

		setState2(props.textBoxRef.current.Text)
	end

	local function fn2()
		setState4(true)
		props.onFocused()
	end

	local function fn3()
		setState4(false)
		props.onFocusLost()
	end

	React.useEffect(function()
		if state3 and state > 0 then
			props.onAgeAndMonthChange(tonumber(state2), state)
		end
	end, { state, state2, state3 })

	React.useEffect(function()
		if props.textBoxRef and props.textBoxRef.current then
			props.textBoxRef.current:CaptureFocus()
		end
	end, { props.textBoxRef.current })

	local createElement = React.createElement
	local v8 = {
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}
	local children = {
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, 0)
		}),
		InputFrame = 0,
		ErrorText = 0,
		ValuePropPadding = 0
	}

	local createElement2 = React.createElement
	local v10 = {
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}
	local children2 = {
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Padding = UDim.new(0, 0)
		}),
		MonthFrame = 0,
		Padding = 0,
		AgeFrame = 0
	}

	local createElement3 = React.createElement
	local v12 = {
		BackgroundTransparency = 1,
		ZIndex = 2,
		LayoutOrder = 3,
		Size = UDim2.new(0.5, -18, 0, props.textInputHeight + 24)
	}
	local children3 = {
		UIPadding = React.createElement("UIPadding", { PaddingTop = UDim.new(0, 2) }),
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, 6)
		}),
		MonthLabel = 0,
		MonthDropdown = 0
	}

	local createElement4 = React.createElement
	local v14 = {
		Text = v6.Month,
		Font = 0,
		FontFace = 0,
		TextSize = 0,
		TextColor3 = 0,
		TextTransparency = 0,
		Size = 0,
		AutomaticSize = 0,
		TextXAlignment = 0,
		BackgroundTransparency = 1,
		ZIndex = 0,
		LayoutOrder = 0
	}
	local v15 = if not foundationFontFaceMigration then v5.Font.CaptionHeader.Font else nil
	v14.Font = v15

	local v16 = if foundationFontFaceMigration then normalizeFontFace(v5.Tokens.Typography.CaptionLarge.Font) else nil
	v14.FontFace = v16

	v14.TextSize = v5.Font.BaseSize * v5.Font.CaptionHeader.RelativeSize
	v14.TextColor3 = v5.Theme.TextEmphasis.Color
	v14.TextTransparency = v5.Theme.TextEmphasis.Transparency
	v14.Size = UDim2.new(1, 0, 0, 0)
	v14.AutomaticSize = Enum.AutomaticSize.Y
	v14.TextXAlignment = Enum.TextXAlignment.Left
	children3.MonthLabel = createElement4("TextLabel", v14)

	children3.MonthDropdown = React.createElement(module2, {
		layoutOrder = 1,
		size = UDim2.new(1, 0, 0, props.textInputHeight),
		textInputHeight = props.textInputHeight,
		onMonthSelected = onMonthSelected,
		shouldExpandRight = false,
		screenSize = props.screenSize
	})
	children2.MonthFrame = createElement3("Frame", v12, children3)

	children2.Padding = React.createElement("Frame", {
		Size = UDim2.new(0, 36, 0, props.textInputHeight + 24),
		BackgroundTransparency = 1,
		LayoutOrder = 2
	})

	local createElement5 = React.createElement
	local v18 = {
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		Size = UDim2.new(0.5, -18, 0, props.textInputHeight + 24)
	}

	local createElement6 = React.createElement
	local v21 = {
		textInputType = Enum.TextInputType.Number,
		textInputHeight = props.textInputHeight,
		textInputListPadding = 6,
		placeholderText = v6.Age,
		labelText = v6.Age,
		borderState = 0,
		onChangeTextCallback = 0,
		onFocused = 0,
		onFocusLost = 0,
		textBoxRef = 0,
		layoutOrder = 2
	}
	local v22

	if props.errorText == "" then
		if state4 then
			v22 = authStatefulRoundCornerBorder.BorderState.Focused
		else
			v22 = authStatefulRoundCornerBorder.BorderState.Default
		end
	else
		v22 = authStatefulRoundCornerBorder.BorderState.Error
	end

	v21.borderState = v22
	v21.onChangeTextCallback = fn
	v21.onFocused = fn2
	v21.onFocusLost = fn3
	v21.textBoxRef = props.textBoxRef
	children2.AgeFrame = createElement5("Frame", v18, {
		AgeInput = createElement6(textInputBoxWithBorder, v21)
	})
	children.InputFrame = createElement2("Frame", v10, children2)
	local v23

	if props.errorText == "" then
		v23 = false
	else
		local createElement7 = React.createElement
		local v25 = {
			Text = props.errorText,
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
			LayoutOrder = 2
		}
		local v26 = if not foundationFontFaceMigration then v5.Font.CaptionBody.Font else nil
		v25.Font = v26

		local v27 = if foundationFontFaceMigration then normalizeFontFace(v5.Tokens.Typography.BodySmall.Font) else nil
		v25.FontFace = v27

		v25.TextSize = v5.Font.BaseSize * v5.Font.CaptionBody.RelativeSize
		v25.TextColor3 = v5.Theme.Alert.Color
		v25.TextTransparency = v5.Theme.TextDefault.Transparency
		v25.TextXAlignment = Enum.TextXAlignment.Left

		v25.Size = UDim2.new(1, 0, 0, 0)
		v25.AutomaticSize = Enum.AutomaticSize.Y
		v23 = createElement7("TextLabel", v25)
	end

	children.ErrorText = v23

	local createElement7 = React.createElement
	local v26 = if props.errorText == "" then UDim2.new(0, 0, 0, 21) else UDim2.new(0, 0, 0, 6)
	children.ValuePropPadding = createElement7("Frame", {
		Size = v26,
		BackgroundTransparency = 1,
		LayoutOrder = 3
	})
	return createElement("Frame", v8, children)
end
