local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local useCursor = UIBlox.App.SelectionCursor.useCursor
local useStyle = UIBlox.Core.Style.useStyle

local function CommentTextField(props)
	local state, setState = React.useState("")
	local selectionImageObject = useCursor()
	local v = useStyle()
	local font = v.Font.Body.Font
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
	local v4 = {
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 10),
			PaddingRight = UDim.new(0, 10),
			PaddingTop = UDim.new(0, 10),
			PaddingBottom = UDim.new(0, 10)
		}),
		UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
		CommentField = 0
	}

	local createElement2 = React.createElement
	local v5 = {}
	v5.Size = UDim2.new(1, 0, 0, 40)
	v5.AutomaticSize = Enum.AutomaticSize.Y
	v5.Position = UDim2.new(0, 0, 0, 0)
	v5.AnchorPoint = Vector2.new(0, 0)
	v5.BackgroundColor3 = props.backgroundColor3 or theme.BackgroundDefault.Color
	v5.PlaceholderText = props.placeholderText

	if FoundationFontFaceMigration then
		font = nil
	end

	v5.Font = font
	local fontFace

	if FoundationFontFaceMigration then
		fontFace = normalizeFontFace(v.Tokens.Typography.BodyLarge.Font)
	end

	v5.FontFace = fontFace

	v5.SelectionImageObject = selectionImageObject
	v5.Text = props.text
	v5.TextSize = baseSize
	v5.TextColor3 = theme.TextDefault.Color
	v5.TextTransparency = theme.TextDefault.Transparency
	v5.TextXAlignment = props.textXAlignment or Enum.TextXAlignment.Left
	v5.TextYAlignment = props.textYAlignment or Enum.TextYAlignment.Top
	v5.BackgroundTransparency = 1
	v5.BorderSizePixel = 0
	v5.LayoutOrder = 1
	v5.RichText = false
	v5.MultiLine = true
	v5.TextWrapped = true
	v5.TextTruncate = Enum.TextTruncate.SplitWord
	v5.ClearTextOnFocus = false
	v5.OverlayNativeInput = true
	v5.ClipsDescendants = true
	v5.Interactable = props.interactable
	v5[React.Change.Text] = v2
	v4.CommentField = createElement2("TextBox", v5)
	return createElement("Frame", v3, v4)
end

return CommentTextField
