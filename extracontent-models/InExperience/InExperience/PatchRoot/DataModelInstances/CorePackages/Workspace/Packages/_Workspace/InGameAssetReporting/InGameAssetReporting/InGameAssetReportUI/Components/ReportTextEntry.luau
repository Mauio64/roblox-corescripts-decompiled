local parent = script:FindFirstAncestor("InGameAssetReporting").Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local useStyle = UIBlox.Core.Style.useStyle

local function ReportTextEntry(props)
	local v = useStyle()
	local baseSize = v.Font.BaseSize
	local theme = v.Theme

	return React.createElement(
		"Frame",
		{
			Size = UDim2.new(1, 0, 0, 60),
			BackgroundTransparency = v.Theme.BackgroundDefault.Transparency,
			BackgroundColor3 = v.Theme.BackgroundDefault.Color,
			LayoutOrder = 1
		},
		{
			UIPadding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 10),
				PaddingRight = UDim.new(0, 10),
				PaddingTop = UDim.new(0, 10),
				PaddingBottom = UDim.new(0, 10)
			}),
			UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
			ReportCommentTextBox = React.createElement("TextBox", {
				Size = UDim2.new(1, 0, 0, 40),
				Position = UDim2.new(0, 0, 0, 0),
				AnchorPoint = Vector2.new(0, 0),
				BackgroundColor3 = theme.BackgroundDefault.Color,
				PlaceholderText = props.placeholderText,
				FontFace = normalizeFontFace(v.Tokens.Typography.BodyLarge.Font),
				Text = props.text,
				TextSize = baseSize,
				TextColor3 = theme.TextDefault.Color,
				TextTransparency = theme.TextDefault.Transparency,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				BackgroundTransparency = theme.BackgroundDefault.Transparency,
				BorderSizePixel = 0,
				LayoutOrder = 1,
				RichText = false,
				MultiLine = true,
				TextWrapped = true,
				ClearTextOnFocus = false,
				OverlayNativeInput = true,
				ClipsDescendants = true,
				[React.Change.Text] = function(p)
					if props.text ~= p.Text then
						props.onUpdate(p.Text)
					end
				end
			})
		}
	)
end

return ReportTextEntry
