local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local useStyle = UIBlox.Core.Style.useStyle

local function ReportTextEntry(props)
	local v = useStyle()
	local fontSize_400 = v.Tokens.FontSize.FontSize_400
	local theme = v.Theme

	return React.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 40 + v.Tokens.Size.Size_600 + 20),
		BackgroundTransparency = v.Theme.BackgroundDefault.Transparency,
		BackgroundColor3 = v.Theme.BackgroundUIDefault.Color,
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 10),
			PaddingRight = UDim.new(0, 10),
			PaddingTop = UDim.new(0, 10),
			PaddingBottom = UDim.new(0, 10)
		}),
		UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
		AbuseReportsText = React.createElement("TextBox", {
			Size = UDim2.new(1, 0, 0, 40 + v.Tokens.Size.Size_600),
			AutomaticSize = Enum.AutomaticSize.Y,
			Position = UDim2.new(0, 0, 0, 0),
			AnchorPoint = Vector2.new(0, 0),
			BackgroundColor3 = theme.BackgroundUIDefault.Color,
			PlaceholderText = props.placeholderText,
			FontFace = normalizeFontFace(v.Tokens.Typography.BodyLarge.Font),
			Text = props.text,
			TextSize = fontSize_400,
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
			[React.Event.FocusLost] = function() end,
			[React.Event.Focused] = function() end,
			[React.Change.AbsoluteSize] = function() end,
			[React.Change.Text] = function(p)
				if props.text ~= p.Text then
					props.onUpdate(p.Text)
				end
			end
		})
	})
end

return ReportTextEntry
