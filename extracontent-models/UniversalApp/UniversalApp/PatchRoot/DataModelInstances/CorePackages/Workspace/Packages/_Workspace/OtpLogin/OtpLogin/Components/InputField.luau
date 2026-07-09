local ParentParent = script.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local React = dependencies.React
local UIBlox = dependencies.UIBlox
local useStyle = UIBlox.Core.Style.useStyle
local useCursor = UIBlox.App.SelectionCursor.useCursor
local Foundation = dependencies.Foundation
local FFlagLuaAppFixCursorHooks = dependencies.SharedFlags.FFlagLuaAppFixCursorHooks

local function InputField(t1: {[any]: any}) -- line: 21
	-- upvalues: useStyle (copy), Foundation (copy), React (copy), FFlagLuaAppFixCursorHooks (copy), useCursor (copy)
	local v11 = useStyle()
	local v12 = Foundation.Hooks.useTokens()
	local HelperText = v11.Tokens.Component.HelperText
	local Typography = HelperText.Base.Typography
	local v15 = React.useRef(nil)
	local v16, v17 = React.useState(false)
	local TextField = v11.Tokens.Component.TextField
	local v19 = if not FFlagLuaAppFixCursorHooks then nil else useCursor(UDim.new(0, TextField.Base.Field.BorderRadius), 2, 2)

	local function startFocus() -- line: 35
		-- upvalues: t1 (copy), v15 (copy), v17 (copy)
		if t1.disabled and v15.current then
			v15.current:ReleaseFocus()

			return
		end

		v17(true)
	end
	local function endFocus() -- line: 43
		-- upvalues: v17 (copy)
		v17(false)
	end
	local function hasError() -- line: 47
		-- upvalues: t1 (copy)
		return t1.errorMessage and string.len(t1.errorMessage) > 0
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = t1.LayoutOrder
	}, {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v11.Tokens.Size.Size_100)
		}),
		InputCanvas = React.createElement("CanvasGroup", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, 48),
			GroupTransparency = not t1.disabled and 0 or 1 - TextField.Disabled.Field.Opacity
		}, {
			Input = React.createElement("ImageButton", {
				Size = UDim2.new(1, -2, 1, -2),
				Position = UDim2.new(0, 1, 0, 1),
				BackgroundTransparency = 1,
				Selectable = not t1.disabled,
				Image = "",
				ImageColor3 = v11.Theme.BackgroundUIContrast.Color,
				SelectionImageObject = if not FFlagLuaAppFixCursorHooks then useCursor(UDim.new(0, TextField.Base.Field.BorderRadius), 2, 2) else v19,
				[React.Event.Activated] = function() -- line: 79
					-- upvalues: v15 (copy)
					if v15.current then
						v15.current:CaptureFocus()
					end
				end
			}, {
				Corner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, TextField.Base.Field.BorderRadius)
				}),
				Border = React.createElement("UIStroke", {
					Thickness = 1,
					Color = if not (t1.errorMessage and string.len(t1.errorMessage) > 0) then TextField.Base.Field.BorderColor.Color3 else TextField.Error.Field.BorderColor.Color3,
					Transparency = if not (t1.errorMessage and string.len(t1.errorMessage) > 0) then if not v16 then TextField.Base.Field.BorderColor.Transparency else 0 else TextField.Error.Field.BorderColor.Transparency
				}),
				BorderFrame = React.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, -4, 1, -4),
					Position = UDim2.new(0, 2, 0, 2)
				}, {
					Corner = React.createElement("UICorner", {
						CornerRadius = UDim.new(0, TextField.Base.Field.BorderRadius - 2)
					}),
					Focus = if t1.disabled or not v16 then nil else React.createElement("UIStroke", {
						Transparency = 0.88,
						Thickness = 3,
						Color = TextField.Base.Field.BorderColor.Color3
					}),
					Padding = React.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, TextField.Base.Field.Spacing.Leading),
						PaddingRight = UDim.new(0, TextField.Base.Field.Spacing.Trailing)
					}),
					Layout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, TextField.Base.Field.Gap * 2)
					}),
					TextBox = React.createElement("TextBox", {
						ref = v15,
						Text = t1.text,
						TextInputType = t1.textInputType or Enum.TextInputType.Default,
						ClearTextOnFocus = false,
						Size = UDim2.new(1, 0, 1, 0),
						TextEditable = not t1.disabled,
						BackgroundTransparency = 1,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center,
						Font = TextField.Base.Field.Typography.Font,
						TextSize = TextField.Base.Field.Typography.FontSize,
						LineHeight = 1,
						TextColor3 = TextField.Base.FieldValue.ContentColor.Color3,
						TextTransparency = TextField.Base.FieldValue.ContentColor.Transparency,
						PlaceholderText = t1.placeholder,
						ClipsDescendants = true,
						LayoutOrder = 1,
						[React.Event.Focused] = startFocus,
						[React.Event.FocusLost] = endFocus,
						[React.Change.Text] = t1.onChange
					})
				})
			})
		}),
		HelperText = if not (t1.errorMessage and string.len(t1.errorMessage) > 0) then nil else React.createElement("TextLabel", {
			TextWrapped = true,
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Text = t1.errorMessage,
			TextTransparency = HelperText.Base.ContentColor.Transparency,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextColor3 = v12.Color.System.Alert.Color3,
			Font = Typography.Font,
			TextSize = Typography.FontSize,
			LineHeight = Typography.LineHeight,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		})
	})
end

return InputField
