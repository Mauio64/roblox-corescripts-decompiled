local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local scriptParentParentParent = scriptParentParent.Parent
local scriptParentParentParentParent = scriptParentParentParent.Parent
local React = require(scriptParentParentParentParent.React)
local InputLabel = require(scriptParent.InputLabel)
local HelperText = require(scriptParent.HelperText)
local ImageSetComponent = require(scriptParentParentParent.Core.ImageSet.ImageSetComponent)

require(scriptParentParent.ImageSet.ImagesTypes)

local useStyle = require(scriptParentParentParent.Core.Style.useStyle)
local useCursor = require(scriptParentParentParent.App.SelectionCursor.useCursor)
local UIBloxConfig = require(scriptParentParentParent.UIBloxConfig)
local t1 = {
	width = UDim.new(0, 400)
}

local function TextField(t2: {[any]: any}) -- line: 54
	-- upvalues: useStyle (copy), React (copy), useCursor (copy), t1 (copy), InputLabel (copy), ImageSetComponent (copy), UIBloxConfig (copy), HelperText (copy)
	local Tokens = useStyle().Tokens
	local v16 = React.useRef(nil)
	local v17, v18 = React.useState(false)
	local v19, v20 = React.useState(false)
	local TextField2 = Tokens.Component.TextField
	local Focus = Tokens.Semantic.Stroke.Focus
	local Small = Tokens.Semantic.Icon.Size.Small
	local Input = Tokens.Semantic.Stroke.Input
	local v25 = math.ceil(Input) * 2
	local Focus2 = Tokens.Semantic.Stroke.Focus
	local v27 = math.ceil(Focus2) * 2
	local v28 = useCursor(UDim.new(0, TextField2.Base.Field.BorderRadius), Focus, Focus)
	local v29 = useCursor(UDim.new(0.5), Small / 2, Focus)
	local v30 = if t2.width == nil then t1.width else t2.width

	local function canUseTextInputType() -- line: 80
		local ok, result = pcall(function() -- line: 81
			local CoreGui = game:GetService("CoreGui")
			local _ = CoreGui.Name

			return CoreGui
		end)

		return ok and result ~= nil
	end
	local function getTextBoxWidthOffset() -- line: 89
		-- upvalues: t2 (copy), Small (copy), TextField2 (copy)
		local n1 = 0

		if t2.iconLeading then
			n1 = n1 - Small - TextField2.Base.Field.Gap * 2
		end

		if t2.iconButton then
			n1 = n1 - Small - TextField2.Base.Field.Gap * 2
		end

		return n1
	end
	local function onTextChange(p1) -- line: 102
		-- upvalues: t2 (copy)
		if p1 == nil then
			t2.onChange("")

			return
		end

		t2.onChange(p1.Text)
	end
	local function onFocusGained() -- line: 110
		-- upvalues: t2 (copy), v16 (copy), v20 (copy)
		if t2.disabled and v16.current then
			v16.current:ReleaseFocus()

			return
		end

		v20(true)

		if t2.onFocusGained then
			t2.onFocusGained()
		end
	end
	local function onFocusLost() -- line: 121
		-- upvalues: v20 (copy)
		v20(false)
	end

	local createElement = React.createElement
	local t3 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(v30, UDim.new(0, 0)),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = t2.LayoutOrder
	}
	local t4 = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, Tokens.Component.InputLabel.Base.Spacing.Bottom)
		}),
		InputLabel = if not t2.label then nil else React.createElement(InputLabel, {
			LayoutOrder = 1,
			text = t2.label,
			required = t2.required
		})
	}
	local createElement2 = React.createElement
	local t5 = {
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		Size = UDim2.new(1, 0, 0, Tokens.Global.Size_600),
		GroupTransparency = not t2.disabled and 0 or 1 - TextField2.Disabled.Field.Opacity
	}
	local t6 = {}
	local createElement3 = React.createElement
	local t7 = {
		Size = UDim2.new(1, -v25, 1, -v25),
		Position = UDim2.new(0, v25 / 2, 0, v25 / 2),
		BackgroundTransparency = 1,
		Selectable = not t2.disabled,
		Image = "",
		SelectionImageObject = v28,
		[React.Event.Activated] = function() -- line: 159
			-- upvalues: v16 (copy)
			if v16.current then
				v16.current:CaptureFocus()
			end
		end,
		[React.Event.MouseEnter] = function() -- line: 164
			-- upvalues: v18 (copy)
			v18(true)
		end,
		[React.Event.MouseLeave] = function() -- line: 167
			-- upvalues: v18 (copy)
			v18(false)
		end
	}
	local t8 = {
		Corner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, TextField2.Base.Field.BorderRadius)
		}),
		Border = React.createElement("UIStroke", {
			Color = if not t2.error then TextField2.Base.Field.BorderColor.Color3 else TextField2.Error.Field.BorderColor.Color3,
			Transparency = if not t2.error then if not v19 then TextField2.Base.Field.BorderColor.Transparency else 0 else TextField2.Error.Field.BorderColor.Transparency,
			Thickness = Input
		})
	}
	local createElement4 = React.createElement
	local t9 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -v27, 1, -v27),
		Position = UDim2.new(0, v27 / 2, 0, v27 / 2)
	}
	local t10 = {
		Corner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, TextField2.Base.Field.BorderRadius - v27 / 2)
		}),
		Focus = if t2.disabled or not v17 and not v19 then nil else React.createElement("UIStroke", {
			Color = TextField2.Base.Field.BorderColor.Color3,
			Transparency = Tokens.Global.Opacity_12,
			Thickness = Focus2
		}),
		Padding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, TextField2.Base.Field.Spacing.Leading),
			PaddingRight = UDim.new(0, TextField2.Base.Field.Spacing.Trailing)
		}),
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, TextField2.Base.Field.Gap * 2)
		}),
		IconLeading = if not t2.iconLeading then nil else React.createElement(ImageSetComponent.Label, {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Image = t2.iconLeading,
			Size = UDim2.new(0, Small, 0, Small),
			ImageColor3 = TextField2.Base.IconLeading.ContentColor.Color3,
			ImageTransparency = TextField2.Base.IconLeading.ContentColor.Transparency
		})
	}
	local createElement5 = React.createElement
	local t11 = {
		ref = v16,
		Text = t2.text
	}
	local ok, result = pcall(function() -- line: 81
		local CoreGui = game:GetService("CoreGui")
		local _ = CoreGui.Name

		return CoreGui
	end)

	t11.TextInputType = ok and result ~= nil and t2.textInputType or nil
	t11.ClearTextOnFocus = false

	local new = UDim2.new
	local n2 = 0

	if t2.iconLeading then
		n2 = n2 - Small - TextField2.Base.Field.Gap * 2
	end

	if t2.iconButton then
		n2 = n2 - Small - TextField2.Base.Field.Gap * 2
	end

	t11.Size = new(1, n2, 1, 0)
	t11.TextEditable = not t2.disabled
	t11.BackgroundTransparency = 1
	t11.TextXAlignment = Enum.TextXAlignment.Left
	t11.TextYAlignment = Enum.TextYAlignment.Center
	t11.Font = TextField2.Base.Field.Typography.Font
	t11.OpenTypeFeatures = if not UIBloxConfig.enableOpenTypeSupport or not t2.openTypeFeatures then nil else t2.openTypeFeatures
	t11.TextSize = TextField2.Base.Field.Typography.FontSize
	t11.LineHeight = 1
	t11.TextColor3 = TextField2.Base.FieldValue.ContentColor.Color3
	t11.TextTransparency = TextField2.Base.FieldValue.ContentColor.Transparency
	t11.PlaceholderText = t2.placeholder
	t11.PlaceholderColor3 = Tokens.Semantic.Color.Text.Default.Color3
	t11.ClipsDescendants = true
	t11.Selectable = false
	t11.LayoutOrder = 2
	t11[React.Event.Focused] = onFocusGained
	t11[React.Event.FocusLost] = onFocusLost
	t11[React.Change.Text] = onTextChange
	t10.TextBox = createElement5("TextBox", t11)
	t10.IconButton = if not t2.iconButton then nil else React.createElement(ImageSetComponent.Button, {
		BackgroundTransparency = 1,
		Image = t2.iconButton,
		Size = UDim2.new(0, Small, 0, Small),
		ImageColor3 = TextField2.Base.IconLeading.ContentColor.Color3,
		Selectable = not t2.disabled,
		SelectionImageObject = v29,
		LayoutOrder = 3,
		[React.Event.Activated] = if t2.disabled then nil else t2.onButtonPress
	})
	t8.BorderFrame = createElement4("Frame", t9, t10)
	t6.Input = createElement3("ImageButton", t7, t8)
	t4.InputCanvas = createElement2("CanvasGroup", t5, t6)
	t4.HelperText = if not t2.hint then nil else React.createElement(HelperText, {
		LayoutOrder = 3,
		text = t2.hint,
		error = t2.error
	})

	return createElement("Frame", t3, t4)
end

return TextField
