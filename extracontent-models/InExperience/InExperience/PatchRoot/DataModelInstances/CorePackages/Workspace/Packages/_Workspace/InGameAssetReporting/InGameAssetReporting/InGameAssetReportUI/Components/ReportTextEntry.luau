local parent = script:FindFirstAncestor("InGameAssetReporting").Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local useStyle = UIBlox.Core.Style.useStyle

local function ReportTextEntry(props)
	local v = useStyle()
	local font = v.Font.Body.Font
	local baseSize = v.Font.BaseSize
	local theme = v.Theme

	local createElement = React.createElement
	local v2 = {
		Size = UDim2.new(1, 0, 0, 60),
		BackgroundTransparency = v.Theme.BackgroundDefault.Transparency,
		BackgroundColor3 = v.Theme.BackgroundDefault.Color,
		LayoutOrder = 1
	}

	local v3 = {
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 10),
			PaddingRight = UDim.new(0, 10),
			PaddingTop = UDim.new(0, 10),
			PaddingBottom = UDim.new(0, 10)
		}),
		UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
		ReportCommentTextBox = 0
	}

	local createElement2 = React.createElement
	local v4 = {}
	v4.Size = UDim2.new(1, 0, 0, 40)
	v4.Position = UDim2.new(0, 0, 0, 0)
	v4.AnchorPoint = Vector2.new(0, 0)
	v4.BackgroundColor3 = theme.BackgroundDefault.Color
	v4.PlaceholderText = props.placeholderText

	if FoundationFontFaceMigration then
		font = nil
	end

	v4.Font = font
	local fontFace

	if FoundationFontFaceMigration then
		fontFace = normalizeFontFace(v.Tokens.Typography.BodyLarge.Font)
	end

	v4.FontFace = fontFace

	v4.Text = props.text
	v4.TextSize = baseSize
	v4.TextColor3 = theme.TextDefault.Color
	v4.TextTransparency = theme.TextDefault.Transparency
	v4.TextXAlignment = Enum.TextXAlignment.Left
	v4.TextYAlignment = Enum.TextYAlignment.Top
	v4.BackgroundTransparency = theme.BackgroundDefault.Transparency
	v4.BorderSizePixel = 0
	v4.LayoutOrder = 1
	v4.RichText = false
	v4.MultiLine = true
	v4.TextWrapped = true
	v4.ClearTextOnFocus = false
	v4.OverlayNativeInput = true
	v4.ClipsDescendants = true
	v4[React.Change.Text] = function(p)
		if props.text ~= p.Text then
			props.onUpdate(p.Text)
		end
	end

	v3.ReportCommentTextBox = createElement2("TextBox", v4)
	return createElement("Frame", v2, v3)
end

return ReportTextEntry
