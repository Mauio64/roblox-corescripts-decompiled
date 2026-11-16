local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local cursorKind = UIBlox.App.SelectionImage.CursorKind
local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local component_assetscircle_17_stroke_1 = images["component_assets/circle_17_stroke_1"]
local rect = Rect.new(8, 8, 8, 8)

local function FilterTextBox(props)
	local v5 = useStyle()
	local font = v5.Font
	local theme = v5.Theme
	local v6 = useSelectionCursor(cursorKind.InputFields)

	local function onTextChanged(p2)
		local text = p2.Text

		if props.onTextChanged then
			props.onTextChanged(text)
		end
	end

	local createElement = React.createElement
	local v8 = {
		BackgroundTransparency = theme.UIMuted.Transparency,
		BackgroundColor3 = theme.UIMuted.Color,
		Size = 0,
		AnchorPoint = 0,
		Position = 0,
		BorderSizePixel = 0,
		LayoutOrder = 0
	}
	local v9 = if props.width then UDim2.new(props.width.Scale, props.width.Offset, 0, 30) else UDim2.new(1, 0, 0, 30)
	v8.Size = v9

	v8.AnchorPoint = Vector2.new(0.5, 0.5)
	v8.Position = UDim2.fromScale(0.5, 0.5)

	v8.LayoutOrder = props.layoutOrder
	return createElement("Frame", v8, {
		UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
		Outline = React.createElement(imageSetLabel, {
			BackgroundTransparency = 1,
			Image = component_assetscircle_17_stroke_1,
			ImageColor3 = theme.UIDefault.Color,
			ImageTransparency = theme.UIDefault.Transparency,
			LayoutOrder = 1,
			ScaleType = Enum.ScaleType.Slice,
			Size = UDim2.new(1, 0, 0, 30),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			SliceCenter = rect
		}),
		Textbox = React.createElement(focusable.TextBox, {
			Text = props.text,
			BackgroundTransparency = 1,
			ClearTextOnFocus = false,
			Font = font.Header2.Font,
			TextSize = font.BaseSize * font.CaptionBody.RelativeSize,
			PlaceholderColor3 = theme.PlaceHolder.Color,
			PlaceholderText = props.placeholderText,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.new(1, -16, 1, 0),
			TextColor3 = theme.TextDefault.Color,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			OverlayNativeInput = true,
			[React.Change.Text] = onTextChanged,
			[React.Event.Focused] = props.onFocused,
			SelectionImageObject = v6,
			ref = props.textBoxRef,
			NextSelectionLeft = props.NextSelectionLeft,
			NextSelectionRight = props.NextSelectionRight,
			NextSelectionUp = props.NextSelectionUp,
			NextSelectionDown = props.NextSelectionDown
		})
	})
end

return FilterTextBox
