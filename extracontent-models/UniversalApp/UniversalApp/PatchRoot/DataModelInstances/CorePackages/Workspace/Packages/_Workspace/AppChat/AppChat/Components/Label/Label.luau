local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent

require(AppChat.types)

local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local memo = React.memo
local UIBlox = require(AppChatParent.UIBlox)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useStyle = UIBlox.Core.Style.useStyle
local t1 = {
	bodyText = ""
}

local function Label(t2: {[any]: any}) -- line: 32
	-- upvalues: Cryo (copy), t1 (copy), useStyle (copy), React (copy), ImageSetLabel (copy)
	local v12 = Cryo.Dictionary.join(t1, t2)
	local v13 = useStyle()
	local v14 = v12.style or v13
	local Size_100 = v14.Tokens.Size.Size_100
	local Size_150 = v14.Tokens.Size.Size_150
	local Size_300 = v14.Tokens.Size.Size_300

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundColor3 = v12.backgroundColor3 or v14.Theme.BackgroundDefault.Color,
		BackgroundTransparency = v12.backgroundTransparency or v14.Theme.BackgroundDefault.Transparency,
		Size = UDim2.new(0, 0, 0, v14.Tokens.Size.Size_500),
		LayoutOrder = v12.layoutOrder
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, Size_100)
		}),
		ContentPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, Size_100),
			PaddingRight = UDim.new(0, Size_150),
			PaddingBottom = UDim.new(0, Size_100),
			PaddingTop = UDim.new(0, Size_100)
		}),
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, v14.Tokens.Radius.Small)
		}),
		IconImage = if not v12.iconImage then nil else React.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.new(0, Size_300, 0, Size_300),
			Image = v12.iconImage,
			ImageColor3 = v12.imageColor3 or v14.Theme.IconEmphasis.Color,
			ImageTransparency = v12.imageTransparency or v14.Theme.IconEmphasis.Transparency
		}),
		BodyText = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			AutomaticSize = Enum.AutomaticSize.X,
			Font = v14.Font.Body.Font,
			Size = UDim2.new(0, 0, 1, 0),
			Text = v12.bodyText,
			TextColor3 = v12.bodyTextColor3 or v14.Theme.TextEmphasis.Color,
			TextSize = v14.Tokens.FontSize.FontSize_250,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center
		})
	})
end

return memo(Label)
