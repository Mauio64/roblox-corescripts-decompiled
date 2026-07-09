local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local UIBlox = require(ProfilePlatformParent.UIBlox)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useStyle = UIBlox.Core.Style.useStyle
local Images = UIBlox.App.ImageSet.Images
local Localization = require(ProfilePlatformParent.Localization)
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local useLocalization = Localization.Hooks.useLocalization
local FFlagProfilePlatformFixResaleLimitedPrice = require(ProfilePlatform.Flags.FFlagProfilePlatformFixResaleLimitedPrice)
local v12 = Images["icons/common/robux"]

local function PriceFooter(t1: {[any]: any}) -- line: 27
	-- upvalues: useStyle (copy), useLocalization (copy), TextKeys (copy), FFlagProfilePlatformFixResaleLimitedPrice (copy), React (copy), ImageSetLabel (copy), v12 (copy)
	local v15 = useStyle()
	local Font = v15.Font
	local Theme = v15.Theme
	local v18 = Font.BaseSize * Font.SubHeader1.RelativeSize
	local vector2 = Vector2.new(v18, v18)
	local v20 = useLocalization({
		freeText = TextKeys.CatalogLabelFree,
		offSaleText = TextKeys.CatalogLabelOffSale
	})
	local str = nil
	local v22 = false

	if t1.isOffSale then
		if FFlagProfilePlatformFixResaleLimitedPrice and t1.lowestResalePrice and t1.lowestResalePrice > 0 then
			str = tostring(t1.lowestResalePrice)
			v22 = true
		else
			str = v20.offSaleText
		end
	elseif t1.price == 0 then
		str = v20.freeText
	elseif t1.price then
		str = tostring(t1.price)
		v22 = true
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 20),
		Position = UDim2.fromOffset(0, -4)
	}, {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, 4)
		}),
		Icon = if not v22 then nil else React.createElement(ImageSetLabel, {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			Image = v12,
			ImageColor3 = Theme.IconEmphasis.Color,
			ImageTransparency = Theme.IconEmphasis.Transparency,
			Size = UDim2.fromOffset(vector2.X, vector2.Y)
		}),
		Text = React.createElement("TextLabel", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, not v22 and 0 or -(vector2.X + 4), 1, 0),
			Font = Font.SubHeader1.Font,
			TextColor3 = Theme.SecondaryContent.Color,
			TextTransparency = Theme.SecondaryContent.Transparency,
			TextSize = v18,
			Text = str,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center
		})
	})
end

return PriceFooter
