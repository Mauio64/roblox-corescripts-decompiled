local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local useCursor = UIBlox.App.SelectionCursor.useCursor
local useStyle = UIBlox.Core.Style.useStyle

local function CommentTextField(props)
	local state, setState = React.useState("")
	local selectionImageObject = useCursor()
	local v = useStyle()
	local baseSize = v.Font.BaseSize
	local theme = v.Theme

	local v2 = React.useCallback(function(state2)
		local text = state2.Text

		if not state2.TextFits then
			state2.Text = state

			return
		end

		setState(text)
		props.onUpdate(text)
	end)

	local createElement = React.createElement
	local v3 = {
		Size = UDim2.new(1, 0, 0, 60),
		BackgroundTransparency = 0,
		BackgroundColor3 = 0,
		LayoutOrder = 0,
		AutomaticSize = 0
	}
	local backgroundTransparency

	if props.backgroundTransparency == nil then
		backgroundTransparency = v.Theme.BackgroundDefault.Transparency
	else
		backgroundTransparency = props.backgroundTransparency
	end

	v3.BackgroundTransparency = backgroundTransparency

	v3.BackgroundColor3 = props.backgroundColor3 or v.Theme.BackgroundDefault.Color
	v3.LayoutOrder = props.layoutOrder
	v3.AutomaticSize = Enum.AutomaticSize.Y
	return createElement("Frame", v3, {
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 10),
			PaddingRight = UDim.new(0, 10),
			PaddingTop = UDim.new(0, 10),
			PaddingBottom = UDim.new(0, 10)
		}),
		UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
		CommentField = React.createElement("TextBox", {
			Size = UDim2.new(1, 0, 0, 40),
			AutomaticSize = Enum.AutomaticSize.Y,
			Position = UDim2.new(0, 0, 0, 0),
			AnchorPoint = Vector2.new(0, 0),
			BackgroundColor3 = props.backgroundColor3 or theme.BackgroundDefault.Color,
			PlaceholderText = props.placeholderText,
			FontFace = normalizeFontFace(v.Tokens.Typography.BodyLarge.Font),
			SelectionImageObject = selectionImageObject,
			Text = props.text,
			TextSize = baseSize,
			TextColor3 = theme.TextDefault.Color,
			TextTransparency = theme.TextDefault.Transparency,
			TextXAlignment = props.textXAlignment or Enum.TextXAlignment.Left,
			TextYAlignment = props.textYAlignment or Enum.TextYAlignment.Top,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 1,
			RichText = false,
			MultiLine = true,
			TextWrapped = true,
			TextTruncate = Enum.TextTruncate.SplitWord,
			ClearTextOnFocus = false,
			OverlayNativeInput = true,
			ClipsDescendants = true,
			Interactable = props.interactable,
			[React.Change.Text] = v2
		})
	})
end

return CommentTextField
