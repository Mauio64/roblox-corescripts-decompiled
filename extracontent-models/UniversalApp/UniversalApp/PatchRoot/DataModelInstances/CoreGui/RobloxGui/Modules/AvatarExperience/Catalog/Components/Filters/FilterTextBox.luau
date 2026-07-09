local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local v10 = Images["component_assets/circle_17_stroke_1"]
local rect = Rect.new(8, 8, 8, 8)

local function FilterTextBox(p1) -- line: 36
	-- upvalues: useStyle (copy), useSelectionCursor (copy), CursorKind (copy), React (copy), ImageSetLabel (copy), v10 (copy), rect (copy), Focusable (copy)
	local v14 = useStyle()
	local Font = v14.Font
	local Theme = v14.Theme
	local v17 = useSelectionCursor(CursorKind.InputFields)

	local function onTextChanged(p2) -- line: 42
		-- upvalues: p1 (copy)
		local p2Text = p2.Text

		if p1.onTextChanged then
			p1.onTextChanged(p2Text)
		end
	end

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundTransparency = Theme.UIMuted.Transparency,
		BackgroundColor3 = Theme.UIMuted.Color,
		Size = if not p1.width then UDim2.new(1, 0, 0, 30) else UDim2.new(p1.width.Scale, p1.width.Offset, 0, 30),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		LayoutOrder = p1.layoutOrder
	}, {
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, 8)
		}),
		Outline = React.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Image = v10,
			ImageColor3 = Theme.UIDefault.Color,
			ImageTransparency = Theme.UIDefault.Transparency,
			ScaleType = Enum.ScaleType.Slice,
			Size = UDim2.new(1, 0, 0, 30),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			SliceCenter = rect
		}),
		Textbox = React.createElement(Focusable.TextBox, {
			Text = p1.text,
			BackgroundTransparency = 1,
			ClearTextOnFocus = false,
			Font = Font.Header2.Font,
			TextSize = Font.BaseSize * Font.CaptionBody.RelativeSize,
			PlaceholderColor3 = Theme.PlaceHolder.Color,
			PlaceholderText = p1.placeholderText,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.new(1, -16, 1, 0),
			TextColor3 = Theme.TextDefault.Color,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			OverlayNativeInput = true,
			[React.Change.Text] = onTextChanged,
			[React.Event.Focused] = p1.onFocused,
			SelectionImageObject = v17,
			ref = p1.textBoxRef,
			NextSelectionLeft = p1.NextSelectionLeft,
			NextSelectionRight = p1.NextSelectionRight,
			NextSelectionUp = p1.NextSelectionUp,
			NextSelectionDown = p1.NextSelectionDown
		})
	})
end

return FilterTextBox
