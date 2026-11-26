local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/React")
local normalizeFontFace = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Foundation").Utility.normalizeFontFace

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/UIBlox")
local useStyle = UIBlox.Core.Style.useStyle
local colors = UIBlox.App.Style.Colors

local function PhoneVerificationStatusOverlay(p2)
	local v5 = useStyle()
	return React.createElement(
		"Frame",
		{
			BackgroundTransparency = 0.3,
			BackgroundColor3 = colors.Black,
			Size = UDim2.new(1, 0, 1, 0)
		},
		{
			MiddleContent = React.createElement(
				"Frame",
				{
					Size = UDim2.new(1, 0, 1, 0),
					BorderSizePixel = 0,
					BackgroundTransparency = 1
				},
				{
					ListLayout = React.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						Padding = UDim.new(0, 24)
					}),
					Image = p2.image,
					Padding = React.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, v5.Tokens.Size.Size_600),
						PaddingRight = UDim.new(0, v5.Tokens.Size.Size_600)
					}),
					VerifyingText = React.createElement("TextLabel", {
						AutomaticSize = Enum.AutomaticSize.XY,
						TextSize = v5.Font.BaseSize * v5.Font.Header1.RelativeSize,
						TextColor3 = colors.White,
						Text = p2.text,
						FontFace = normalizeFontFace(v5.Tokens.Typography.HeadingSmall.Font),
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
