local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local t = require(CorePackages.Packages.t)

local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)

local fitFrameVertical = AvatarExperienceDeps.RoactFitComponents.FitFrameVertical

local numberLocalization = require("@game/CorePackages/Workspace/Packages/Localization").NumberLocalization
local module = require("@luauforge/bundled/dwM")

local module2 = require("@luauforge/bundled/eeH")
local module3 = require("@luauforge/bundled/edB")
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local skeleton = Foundation.Skeleton

local statWidget = UIBlox.App.Indicator.StatWidget
local iconsactionsfavoriteOn = UIBlox.App.ImageSet.Images["icons/actions/favoriteOn"]

local wrapped = module.wrap(t.strictInterface({
	favoritesCount = t.optional(t.integer),
	listPadding = t.optional(t.integer),
	width = t.optional(t.number),
	Position = t.optional(t.UDim2),
	LayoutOrder = t.optional(t.integer)
}))

local function ItemStatistics(props)
	assert(wrapped(props))

	local layoutOrder = props.LayoutOrder or 0
	local position = props.Position or UDim2.new(0, 0, 0, 0)
	local width = props.width or 0
	local listPadding = props.listPadding or 10

	local favoritesCount = props.favoritesCount

	local v5 = module2(module3)

	if not favoritesCount then
		return React.createElement(skeleton, {
			Position = position,
			Size = UDim2.new(0, width, 0, 70),
			LayoutOrder = layoutOrder
		})
	end

	local v6 = width - listPadding * 2

	local formatted = v5:Format("Feature.Catalog.Label.Favorites")
	local abbreviate = numberLocalization.abbreviate(favoritesCount, v5:GetLocale())

	return React.createElement("Frame", {
		Size = UDim2.new(0, width, 0, 70),
		Position = position,
		LayoutOrder = layoutOrder,
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}, {
		ItemStatisticsSection = React.createElement(fitFrameVertical, {
			width = UDim.new(0, width),
			contentPadding = UDim.new(0, listPadding),
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundTransparency = 1,
			LayoutOrder = 0,
			Position = UDim2.new(0, 0, 0.5, 0)
		}, {
			FavoritesSection = React.createElement(statWidget, {
				icon = iconsactionsfavoriteOn,
				countText = abbreviate,
				labelText = formatted,
				size = UDim2.new(0, v6, 1, 0),
				layoutOrder = 0
			})
		})
	})
end

return ItemStatistics
