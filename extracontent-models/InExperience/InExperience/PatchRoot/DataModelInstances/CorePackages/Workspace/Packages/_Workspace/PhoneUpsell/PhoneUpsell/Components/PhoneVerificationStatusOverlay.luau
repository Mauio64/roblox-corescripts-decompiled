local parent = script:FindFirstAncestor("PhoneUpsell").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local UIBlox = require(parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local Colors = UIBlox.App.Style.Colors

local function PhoneVerificationStatusOverlay(p)
	local v = useStyle()
	return React.createElement(
		"Frame",
		{
			BackgroundTransparency = 0.3,
			BackgroundColor3 = Colors.Black,
			Size = UDim2.new(1, 0, 1, 0)
		},
		{
			MiddleContent = React.createElement(
				"Frame",
				{ Size = UDim2.new(1, 0, 1, 0), BorderSizePixel = 0, BackgroundTransparency = 1 },
				{
					ListLayout = React.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						Padding = UDim.new(0, 24)
					}),
					Image = p.image,
					Padding = React.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, v.Tokens.Size.Size_600),
						PaddingRight = UDim.new(0, v.Tokens.Size.Size_600)
					}),
					VerifyingText = React.createElement("TextLabel", {
						AutomaticSize = Enum.AutomaticSize.XY,
						TextSize = v.Font.BaseSize * v.Font.Header1.RelativeSize,
						TextColor3 = Colors.White,
						Text = p.text,
						FontFace = normalizeFontFace(v.Tokens.Typography.HeadingSmall.Font),
						LayoutOrder = 1,
						BackgroundTransparency = 1,
						TextWrapped = true
					})
				}
			)
		}
	)
end

return PhoneVerificationStatusOverlay
