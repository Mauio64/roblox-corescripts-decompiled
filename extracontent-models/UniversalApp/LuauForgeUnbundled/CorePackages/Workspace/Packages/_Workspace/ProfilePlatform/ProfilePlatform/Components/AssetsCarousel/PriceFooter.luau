local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UIBlox")
local normalizeFontFace = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation").Utility.normalizeFontFace

local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useStyle = UIBlox.Core.Style.useStyle
local images = UIBlox.App.ImageSet.Images

local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization")
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/TextKeys")
local useLocalization = Localization.Hooks.useLocalization

local FFlagProfilePlatformFixResaleLimitedPrice = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformFixResaleLimitedPrice")

local iconscommonrobux = images["icons/common/robux"]

local function PriceFooter(props)
	local v5 = useStyle()
	local font = v5.Font
	local theme = v5.Theme
	local v6 = font.BaseSize * font.SubHeader1.RelativeSize
	local vector2 = Vector2.new(v6, v6)

	local v7 = useLocalization({
		freeText = TextKeys.CatalogLabelFree,
		offSaleText = TextKeys.CatalogLabelOffSale
	})

	local v8 = nil
	local flag = false

	if props.isOffSale then
		if FFlagProfilePlatformFixResaleLimitedPrice and props.lowestResalePrice and props.lowestResalePrice > 0 then
			v8 = tostring(props.lowestResalePrice)
			flag = true
		else
			v8 = v7.offSaleText
		end
	elseif props.price == 0 then
		v8 = v7.freeText
	elseif props.price then
		v8 = tostring(props.price)
		flag = true
	end

	local createElement = React.createElement
	local v10 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 20),
		Position = UDim2.fromOffset(0, -4)
	}
	local v11 = {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, 4)
		}),
		Icon = 0,
		Text = 0
	}

	local v12 = if flag then React.createElement(imageSetLabel, {
		LayoutOrder = 1,
		BackgroundTransparency = 1,
		Image = iconscommonrobux,
		ImageColor3 = theme.IconEmphasis.Color,
		ImageTransparency = theme.IconEmphasis.Transparency,
		Size = UDim2.fromOffset(vector2.X, vector2.Y)
	}) else nil
	v11.Icon = v12

	v11.Text = React.createElement("TextLabel", {
		LayoutOrder = 2,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, not flag and 0 or -(vector2.X + 4), 1, 0),
		FontFace = normalizeFontFace(v5.Tokens.Typography.TitleLarge.Font),
		TextColor3 = theme.SecondaryContent.Color,
		TextTransparency = theme.SecondaryContent.Transparency,
		TextSize = v6,
		Text = v8,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center
	})
	return createElement("Frame", v10, v11)
end

return PriceFooter
