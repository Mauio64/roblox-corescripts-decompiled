require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/types")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local memo = React.memo

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
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

	local createElement2 = React.createElement
	local v12 = {
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 1,
		Font = 0,
		FontFace = 0,
		LayoutOrder = 2,
		Size = 0,
		Text = 0,
		TextColor3 = 0,
		TextSize = 0,
		TextXAlignment = 0,
		TextYAlignment = 0
	}

	local v13 = if not foundationFontFaceMigration then style.Font.Body.Font else nil
	v12.Font = v13

	local v14 = if foundationFontFaceMigration then normalizeFontFace(style.Tokens.Typography.BodyLarge.Font) else nil
	v12.FontFace = v14

	v12.Size = UDim2.new(0, 0, 1, 0)
	v12.Text = joined.bodyText
	v12.TextColor3 = joined.bodyTextColor3 or style.Theme.TextEmphasis.Color
	v12.TextSize = style.Tokens.FontSize.FontSize_250
	v12.TextXAlignment = Enum.TextXAlignment.Left
	v12.TextYAlignment = Enum.TextYAlignment.Center
	v9.BodyText = createElement2("TextLabel", v12)
	return createElement("Frame", v8, v9)
end

return memo(Label)
