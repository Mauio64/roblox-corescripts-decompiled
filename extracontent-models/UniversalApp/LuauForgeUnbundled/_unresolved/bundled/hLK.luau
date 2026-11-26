local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local AuthCommon = require("@game/CorePackages/Workspace/Packages/AuthCommon")
local textInputBoxWithBorder = AuthCommon.Components.TextInputBoxWithBorder
local authStatefulRoundCornerBorder = AuthCommon.Components.AuthStatefulRoundCornerBorder

local module2 = require("@luauforge/bundled/hLJ")
local useStyle = UIBlox.Core.Style.useStyle
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

return function(props)
	local v5 = useStyle()
	local v6 = useLocalization({
		Year = "CommonUI.Controls.Label.Year",
		Birthday = "Authentication.SignUp.Label.Birthday"
	})

	local state, setState = React.useState(0)
	local state2, setState2 = React.useState("")
	local state3, setState3 = React.useState(false)

	local state4, setState4 = React.useState(false)

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
			props.onMonthAndYearChange(state, (tonumber(state2)))
		end
	end, { state, state2, state3 })

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
	local v11 = {
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
			Padding = UDim.new(0, 0)
		}),
		MonthFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.new(0.5, -18, 0, props.textInputHeight + 24),
			ZIndex = 2
		}, {
			UIPadding = React.createElement("UIPadding", { PaddingTop = UDim.new(0, 2) }),
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, 6)
			}),
			Label = React.createElement("TextLabel", {
				Text = v6.Birthday,
				FontFace = normalizeFontFace(v5.Tokens.Typography.CaptionLarge.Font),
				TextSize = v5.Font.BaseSize * v5.Font.CaptionHeader.RelativeSize,
				TextColor3 = v5.Theme.TextEmphasis.Color,
				TextTransparency = v5.Theme.TextEmphasis.Transparency,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1,
				LayoutOrder = 0
			}),
			MonthDropdown = React.createElement(module2, {
				layoutOrder = 1,
				size = UDim2.new(1, 0, 0, props.textInputHeight),
				textInputHeight = props.textInputHeight,
				onMonthSelected = function(p2)
					setState(p2)
					props.onMonthInputConfirmed()
				end,
				shouldExpandRight = true,
				screenSize = props.screenSize
			})
		}),
		Padding = React.createElement("Frame", {
			Size = UDim2.new(0, 36, 0, props.textInputHeight + 24),
			BackgroundTransparency = 1,
			LayoutOrder = 2
		}),
		YearFrame = 0
	}

	local createElement3 = React.createElement
	local v13 = {
		BackgroundTransparency = 1,
		LayoutOrder = 3,
		Size = UDim2.new(0.5, -18, 0, props.textInputHeight + 24)
	}
	local v14 = {
		UIPadding = React.createElement("UIPadding", { PaddingTop = UDim.new(0, 22) }),
		YearInput = 0
	}

	local createElement4 = React.createElement
	local v16 = {
		textInputType = Enum.TextInputType.Number,
		textInputHeight = props.textInputHeight,
		textInputListPadding = 6,
		placeholderText = v6.Year,
		borderState = 0,
		onChangeTextCallback = 0,
		onFocused = 0,
		onFocusLost = 0,
		textBoxRef = 0,
		layoutOrder = 2
	}
	local v17

	if props.errorText == "" then
		if state4 then
			v17 = authStatefulRoundCornerBorder.BorderState.Focused
		else
			v17 = authStatefulRoundCornerBorder.BorderState.Default
		end
	else
		v17 = authStatefulRoundCornerBorder.BorderState.Error
	end

	v16.borderState = v17
	v16.onChangeTextCallback = fn
	v16.onFocused = fn2
	v16.onFocusLost = fn3
	v16.textBoxRef = props.textBoxRef
	v14.YearInput = createElement4(textInputBoxWithBorder, v16)
	v11.YearFrame = createElement3("Frame", v13, v14)
	children.InputFrame = createElement2("Frame", v10, v11)
	local v18

	if props.errorText == "" then
		v18 = false
	else
		v18 = React.createElement("TextLabel", {
			Text = props.errorText,
			FontFace = normalizeFontFace(v5.Tokens.Typography.BodySmall.Font),
			TextSize = v5.Font.BaseSize * v5.Font.CaptionBody.RelativeSize,
			TextColor3 = v5.Theme.Alert.Color,
			TextTransparency = v5.Theme.TextDefault.Transparency,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			ZIndex = 0,
			LayoutOrder = 2
		})
	end

	children.ErrorText = v18

	local createElement5 = React.createElement
	local v21 = if props.errorText == "" then UDim2.new(0, 0, 0, 21) else UDim2.new(0, 0, 0, 6)
	children.ValuePropPadding = createElement5("Frame", {
		Size = v21,
		BackgroundTransparency = 1,
		LayoutOrder = 3
	})
	return createElement("Frame", v8, children)
end
