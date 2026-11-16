local parent = script.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent
local parent4 = parent3.Parent

local React = require(parent4.React)
local Foundation = require(parent4.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local InputLabel = require(parent.InputLabel)
local HelperText = require(parent.HelperText)
local ImageSetComponent = require(parent3.Core.ImageSet.ImageSetComponent)
require(parent2.ImageSet.ImagesTypes)

local useStyle = require(parent3.Core.Style.useStyle)
local useCursor = require(parent3.App.SelectionCursor.useCursor)
local UIBloxConfig = require(parent3.UIBloxConfig)

local v = { width = UDim.new(0, 400) }

local function TextField(props)
	local tokens = useStyle().Tokens

	local ref = React.useRef(nil)
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)

	local thick = tokens.Stroke.Thick
	local size_400 = tokens.Size.Size_400

	local standard = tokens.Stroke.Standard
	local v2 = math.ceil(standard) * 2
	local thick2 = tokens.Stroke.Thick
	local v3 = math.ceil(thick2) * 2

	local selectionImageObject = useCursor(UDim.new(0, tokens.Radius.Medium), thick, thick)
	local selectionImageObject2 = useCursor(UDim.new(0.5), size_400 / 2, thick)

	local width = if props.width == nil then v.width else props.width

	local function canUseTextInputType()
		local success, result = pcall(function()
			local CoreGui = game:GetService("CoreGui")
			local _name = CoreGui.Name
			return CoreGui
		end)

		return success and result ~= nil
	end

	local function getTextBoxWidthOffset() -- 1 equivalent call inferred from this helper
		local textBoxWidthOffset = 0

		if props.iconLeading then
			textBoxWidthOffset = textBoxWidthOffset - size_400 - tokens.Gap.Small * 2
		end

		if props.iconButton then
			textBoxWidthOffset = textBoxWidthOffset - size_400 - tokens.Gap.Small * 2
		end

		return textBoxWidthOffset
	end

	local function onTextChange(p)
		if p == nil then
			props.onChange("")
		else
			props.onChange(p.Text)
		end
	end

	local function onFocusGained()
		if props.disabled and ref.current then
			ref.current:ReleaseFocus()
			return
		end

		setState2(true)

		if props.onFocusGained then
			props.onFocusGained()
		end
	end

	local function onFocusLost()
		setState2(false)
	end

	local createElement = React.createElement
	local v4 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(width, UDim.new(0, 0)),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = props.LayoutOrder
	}
	local v5 = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, tokens.Size.Size_100)
		}),
		InputLabel = 0,
		InputCanvas = 0,
		HelperText = 0
	}
	local inputLabel

	if props.label then
		inputLabel = React.createElement(InputLabel, {
			text = props.label,
			required = props.required,
			LayoutOrder = 1
		})
	end

	v5.InputLabel = inputLabel

	local createElement2 = React.createElement
	local v6 = {
		Size = UDim2.new(1, 0, 0, tokens.Size.Size_1200),
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		GroupTransparency = props.disabled and 0.68 or 0
	}

	local createElement3 = React.createElement
	local v7 = {
		Size = UDim2.new(1, -v2, 1, -v2),
		Position = UDim2.new(0, v2 / 2, 0, v2 / 2),
		BackgroundTransparency = 1,
		Selectable = not props.disabled,
		Image = "",
		SelectionImageObject = selectionImageObject,
		[React.Event.Activated] = function()
			if ref.current then
				ref.current:CaptureFocus()
			end
		end,
		[React.Event.MouseEnter] = function()
			setState(true)
		end,
		[React.Event.MouseLeave] = function()
			setState(false)
		end
	}
	local children = {
		Corner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, tokens.Radius.Medium)
		}),
		Border = 0,
		BorderFrame = 0
	}

	local createElement4 = React.createElement
	local color

	if props.error then
		color = tokens.Color.ActionAlert.Border.Color3
	else
		color = tokens.Color.Stroke.Emphasis.Color3
	end

	local transparency

	if props.error then
		transparency = tokens.Color.ActionAlert.Border.Transparency
	else
		transparency = state2 and 0 or tokens.Color.Stroke.Emphasis.Transparency
	end

	children.Border = createElement4("UIStroke", {
		Color = color,
		Transparency = transparency,
		Thickness = standard
	})

	local createElement5 = React.createElement
	local v8 = {
		Size = UDim2.new(1, -v3, 1, -v3),
		Position = UDim2.new(0, v3 / 2, 0, v3 / 2),
		BackgroundTransparency = 1
	}

	local children2 = {
		Corner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, tokens.Radius.Medium - v3 / 2)
		}),
		Focus = 0,
		Padding = 0,
		Layout = 0,
		IconLeading = 0,
		TextBox = 0,
		IconButton = 0
	}
	local focus

	if not (props.disabled or not (state or state2)) then
		focus = React.createElement("UIStroke", {
			Color = tokens.Color.Stroke.Emphasis.Color3,
			Transparency = 0.88,
			Thickness = thick2
		})
	end

	children2.Focus = focus

	children2.Padding = React.createElement("UIPadding", {
		PaddingLeft = UDim.new(0, tokens.Size.Size_300),
		PaddingRight = UDim.new(0, tokens.Size.Size_300)
	})

	children2.Layout = React.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, tokens.Gap.Small * 2)
	})
	local iconLeading

	if props.iconLeading then
		iconLeading = React.createElement(ImageSetComponent.Label, {
			BackgroundTransparency = 1,
			Image = props.iconLeading,
			Size = UDim2.new(0, size_400, 0, size_400),
			ImageColor3 = tokens.Color.Content.Muted.Color3,
			ImageTransparency = tokens.Color.Content.Muted.Transparency,
			LayoutOrder = 1
		})
	end

	children2.IconLeading = iconLeading

	local createElement6 = React.createElement
	local v9 = {}
	v9.ref = ref
	v9.Text = props.text
	local success, result = pcall(function()
		local CoreGui = game:GetService("CoreGui")
		local _name = CoreGui.Name
		return CoreGui
	end)
	local textInputType

	if success and result ~= nil then
		textInputType = props.textInputType or nil
	end

	v9.TextInputType = textInputType
	v9.ClearTextOnFocus = false
	v9.Size = UDim2.new(1, getTextBoxWidthOffset(), 1, 0) -- inferred equivalent call
	v9.TextEditable = not props.disabled
	v9.BackgroundTransparency = 1
	v9.TextXAlignment = Enum.TextXAlignment.Left
	v9.TextYAlignment = Enum.TextYAlignment.Center
	v9.FontFace = normalizeFontFace(tokens.Typography.BodyLarge.Font)
	local openTypeFeatures

	if UIBloxConfig.enableOpenTypeSupport and props.openTypeFeatures then
		openTypeFeatures = props.openTypeFeatures
	end

	v9.OpenTypeFeatures = openTypeFeatures

	v9.TextSize = tokens.Typography.BodyLarge.FontSize
	v9.LineHeight = 1
	v9.TextColor3 = tokens.Color.Content.Emphasis.Color3
	v9.TextTransparency = tokens.Color.Content.Emphasis.Transparency
	v9.PlaceholderText = props.placeholder
	v9.PlaceholderColor3 = tokens.Color.Content.Default.Color3
	v9.ClipsDescendants = true
	v9.Selectable = false
	v9.LayoutOrder = 2

	v9[React.Event.Focused] = onFocusGained
	v9[React.Event.FocusLost] = onFocusLost
	v9[React.Change.Text] = onTextChange
	children2.TextBox = createElement6("TextBox", v9)
	local iconButton

	if props.iconButton then
		local createElement7 = React.createElement
		local button = ImageSetComponent.Button
		local v10 = {
			BackgroundTransparency = 1,
			["Image"] = props.iconButton,
			Size = UDim2.new(0, size_400, 0, size_400),
			ImageColor3 = tokens.Color.Content.Muted.Color3,
			Selectable = not props.disabled,
			SelectionImageObject = selectionImageObject2,
			LayoutOrder = 3
		}

		local activated = React.Event.Activated
		local v11

		if not props.disabled then
			v11 = props.onButtonPress
		end

		v10[activated] = v11
		iconButton = createElement7(button, v10)
	end

	children2.IconButton = iconButton
	children.BorderFrame = createElement5("Frame", v8, children2)
	v5.InputCanvas = createElement2("CanvasGroup", v6, {
		Input = createElement3("ImageButton", v7, children)
	})
	local helperText

	if props.hint then
		helperText = React.createElement(HelperText, {
			text = props.hint,
			error = props.error,
			LayoutOrder = 3
		})
	end

	v5.HelperText = helperText
	return createElement("Frame", v4, v5)
end

return TextField
