require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/types")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local memo = React.memo

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox")
local normalizeFontFace = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation").Utility.normalizeFontFace
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useStyle = UIBlox.Core.Style.useStyle

local v5 = { bodyText = "" }

local function Label(p2)
	local joined = Cryo.Dictionary.join(v5, p2)
	local v6 = useStyle()
	local style = joined.style or v6

	local size_100 = style.Tokens.Size.Size_100
	local size_150 = style.Tokens.Size.Size_150
	local size_300 = style.Tokens.Size.Size_300

	local createElement = React.createElement
	local v8 = {
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundColor3 = joined.backgroundColor3 or style.Theme.BackgroundDefault.Color,
		BackgroundTransparency = joined.backgroundTransparency or style.Theme.BackgroundDefault.Transparency,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 0, 0, style.Tokens.Size.Size_500),
		LayoutOrder = joined.layoutOrder
	}
	local v9 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, size_100)
		}),
		ContentPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, size_100),
			PaddingRight = UDim.new(0, size_150),
			PaddingBottom = UDim.new(0, size_100),
			PaddingTop = UDim.new(0, size_100)
		}),
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, style.Tokens.Radius.Small)
		}),
		IconImage = 0,
		BodyText = 0
	}

	local v10 = if joined.iconImage then React.createElement(imageSetLabel, {
		Size = UDim2.new(0, size_300, 0, size_300),
		BackgroundTransparency = 1,
		Image = joined.iconImage,
		ImageColor3 = joined.imageColor3 or style.Theme.IconEmphasis.Color,
		ImageTransparency = joined.imageTransparency or style.Theme.IconEmphasis.Transparency,
		LayoutOrder = 1
	}) else nil
	v9.IconImage = v10

	v9.BodyText = React.createElement("TextLabel", {
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 1,
		FontFace = normalizeFontFace(style.Tokens.Typography.BodyLarge.Font),
		LayoutOrder = 2,
		Size = UDim2.new(0, 0, 1, 0),
		Text = joined.bodyText,
		TextColor3 = joined.bodyTextColor3 or style.Theme.TextEmphasis.Color,
		TextSize = style.Tokens.FontSize.FontSize_250,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center
	})
	return createElement("Frame", v8, v9)
end

return memo(Label)
