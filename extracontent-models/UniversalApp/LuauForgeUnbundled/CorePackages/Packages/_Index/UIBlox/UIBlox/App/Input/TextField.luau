local module = require("@luauforge/bundled/fGi")
local react = module.React
local uiBlox = module.UIBlox
local useStyle = uiBlox.Core.Style.useStyle
local useCursor = uiBlox.App.SelectionCursor.useCursor
local foundation = module.Foundation
local normalizeFontFace = foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = foundation.Utility.Flags.FoundationFontFaceMigration

local function InputField(props)
	local v5 = useStyle()
	local v6 = foundation.Hooks.useTokens()
	local v7 = {
		Base = {
			ContentColor = v5.Tokens.Color.Content.Default,
			Typography = v5.Tokens.Typography.CaptionSmall
		}
	}

	local typography = v7.Base.Typography

	local ref = react.useRef(nil)
	local state, setState = react.useState(false)

	local v8 = {
		Base = {
			Field = {
				BorderColor = v5.Tokens.Color.Stroke.Emphasis,
				BorderRadius = v5.Tokens.Radius.Medium,
				Typography = v5.Tokens.Typography.BodyLarge,
				Spacing = {
					Leading = v5.Tokens.Size.Size_300,
					Trailing = v5.Tokens.Size.Size_300
				},
				Gap = v5.Tokens.Gap.Small
			},
			FieldValue = { ContentColor = v5.Tokens.Color.Content.Emphasis }
		},
		Error = {
			Field = { BorderColor = v5.Tokens.Color.ActionAlert.Border }
		},
		Disabled = {
			Field = { Opacity = 0.32 }
		}
	}

	local v9 = useCursor(UDim.new(0, v8.Base.Field.BorderRadius), 2, 2)

	local function startFocus()
		if props.disabled and ref.current then
			ref.current:ReleaseFocus()
		else
			setState(true)
		end
	end

	local function endFocus()
		setState(false)
	end

	local function hasError()
		return props.errorMessage and string.len(props.errorMessage) > 0
	end

	local createElement = react.createElement
	local v11 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = props.LayoutOrder
	}
	local v12 = {
		Layout = react.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v5.Tokens.Size.Size_100)
		}),
		InputCanvas = 0,
		HelperText = 0
	}

	local createElement2 = react.createElement
	local v14 = {
		Size = UDim2.new(1, 0, 0, 48),
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		GroupTransparency = not props.disabled and 0 or 1 - v8.Disabled.Field.Opacity
	}

	local createElement3 = react.createElement
	local v17 = {
		Size = UDim2.new(1, -2, 1, -2),
		Position = UDim2.new(0, 1, 0, 1),
		BackgroundTransparency = 1,
		Selectable = not props.disabled,
		Image = "",
		ImageColor3 = v5.Theme.BackgroundUIContrast.Color,
		SelectionImageObject = v9,
		[react.Event.Activated] = function()
			if ref.current then
				ref.current:CaptureFocus()
			end
		end
	}
	local children = {
		Corner = react.createElement("UICorner", {
			CornerRadius = UDim.new(0, v8.Base.Field.BorderRadius)
		}),
		Border = 0,
		BorderFrame = 0
	}

	local createElement4 = react.createElement
	local v20 = if props.errorMessage and string.len(props.errorMessage) > 0 then v8.Error.Field.BorderColor.Color3 else v8.Base.Field.BorderColor.Color3
	local v21 = if props.errorMessage and string.len(props.errorMessage) > 0 then v8.Error.Field.BorderColor.Transparency else state and 0 or v8.Base.Field.BorderColor.Transparency
	children.Border = createElement4("UIStroke", {
		Color = v20,
		Transparency = v21,
		Thickness = 1
	})

	local createElement5 = react.createElement
	local v23 = {
		Size = UDim2.new(1, -4, 1, -4),
		Position = UDim2.new(0, 2, 0, 2),
		BackgroundTransparency = 1
	}

	local children2 = {
		Corner = react.createElement("UICorner", {
			CornerRadius = UDim.new(0, v8.Base.Field.BorderRadius - 2)
		}),
		Focus = 0,
		Padding = 0,
		Layout = 0,
		TextBox = 0
	}

	local v24 = if not (props.disabled or not state) then react.createElement("UIStroke", {
		Color = v8.Base.Field.BorderColor.Color3,
		Transparency = 0.88,
		Thickness = 3
	}) else nil
	children2.Focus = v24

	children2.Padding = react.createElement("UIPadding", {
		PaddingLeft = UDim.new(0, v8.Base.Field.Spacing.Leading),
		PaddingRight = UDim.new(0, v8.Base.Field.Spacing.Trailing)
	})

	children2.Layout = react.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, v8.Base.Field.Gap * 2)
	})

	local createElement6 = react.createElement
	local v26 = {}
	v26.ref = ref
	v26.Text = props.text
	v26.TextInputType = props.textInputType or Enum.TextInputType.Default
	v26.ClearTextOnFocus = false
	v26.Size = UDim2.new(1, 0, 1, 0)
	v26.TextEditable = not props.disabled
	v26.BackgroundTransparency = 1
	v26.TextXAlignment = Enum.TextXAlignment.Left
	v26.TextYAlignment = Enum.TextYAlignment.Center

	local v27 = if not foundationFontFaceMigration then v8.Base.Field.Typography.Font else nil
	v26.Font = v27

	local v28 = if foundationFontFaceMigration then normalizeFontFace(v6.Typography.BodyLarge.Font) else nil
	v26.FontFace = v28

	v26.TextSize = v8.Base.Field.Typography.FontSize
	v26.LineHeight = 1
	v26.TextColor3 = v8.Base.FieldValue.ContentColor.Color3
	v26.TextTransparency = v8.Base.FieldValue.ContentColor.Transparency
	v26.PlaceholderText = props.placeholder
	v26.ClipsDescendants = true
	v26.LayoutOrder = 1

	v26[react.Event.Focused] = startFocus
	v26[react.Event.FocusLost] = endFocus
	v26[react.Change.Text] = props.onChange
	children2.TextBox = createElement6("TextBox", v26)
	children.BorderFrame = createElement5("Frame", v23, children2)
	v12.InputCanvas = createElement2("CanvasGroup", v14, {
		Input = createElement3("ImageButton", v17, children)
	})
	local v29

	if props.errorMessage and string.len(props.errorMessage) > 0 then
		local createElement7 = react.createElement
		local v31 = {
			Text = props.errorMessage,
			TextTransparency = v7.Base.ContentColor.Transparency,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextWrapped = true,
			BackgroundTransparency = 1,
			TextColor3 = v6.Color.System.Alert.Color3,
			Font = 0,
			FontFace = 0,
			TextSize = 0,
			LineHeight = 0,
			Size = 0,
			AutomaticSize = 0,
			LayoutOrder = 2
		}
		local v32 = if not foundationFontFaceMigration then typography.Font else nil
		v31.Font = v32

		local v33 = if foundationFontFaceMigration then normalizeFontFace(v6.Typography.CaptionSmall.Font) else nil
		v31.FontFace = v33

		v31.TextSize = typography.FontSize
		v31.LineHeight = typography.LineHeight
		v31.Size = UDim2.new(1, 0, 0, 0)
		v31.AutomaticSize = Enum.AutomaticSize.Y
		v29 = createElement7("TextLabel", v31)
	end

	v12.HelperText = v29
	return createElement("Frame", v11, v12)
end

return InputField
