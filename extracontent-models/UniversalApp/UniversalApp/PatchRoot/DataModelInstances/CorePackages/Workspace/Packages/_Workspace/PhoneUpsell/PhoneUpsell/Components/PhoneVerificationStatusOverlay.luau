local Parent = script:FindFirstAncestor("PhoneUpsell").Parent
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local Colors = UIBlox.App.Style.Colors

local function PhoneVerificationStatusOverlay(t1: {[any]: any}) -- line: 17
	-- upvalues: useStyle (copy), React (copy), Colors (copy)
	local v8 = useStyle()

	return React.createElement("Frame", {
		BackgroundTransparency = 0.3,
		BackgroundColor3 = Colors.Black,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		MiddleContent = React.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			ListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 24)
			}),
			Image = t1.image,
			Padding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, v8.Tokens.Size.Size_600),
				PaddingRight = UDim.new(0, v8.Tokens.Size.Size_600)
			}),
			VerifyingText = React.createElement("TextLabel", {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				TextWrapped = true,
				AutomaticSize = Enum.AutomaticSize.XY,
				TextSize = v8.Font.BaseSize * v8.Font.Header1.RelativeSize,
				TextColor3 = Colors.White,
				Text = t1.text,
				Font = v8.Font.Header1.Font
			})
		})
	})
end

return PhoneVerificationStatusOverlay
