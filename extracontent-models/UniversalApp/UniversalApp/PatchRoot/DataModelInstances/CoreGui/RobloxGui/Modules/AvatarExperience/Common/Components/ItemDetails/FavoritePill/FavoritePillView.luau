local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local Enums = Foundation.Enums
local IconName = Enums.IconName
local IconSize = Enums.IconSize
local IconVariant = Enums.IconVariant

local function FavoritePillView(t1: {[any]: any}) -- line: 37
	-- upvalues: React (copy), Foundation (copy), IconName (copy), IconVariant (copy), IconSize (copy)
	if t1.favoritesCount == nil then
		return React.createElement(Foundation.Skeleton, {
			testId = "FavoritePillSkeleton",
			Size = UDim2.fromOffset(120, 36),
			LayoutOrder = t1.LayoutOrder
		})
	end

	return React.createElement(Foundation.View, {
		tag = "row align-x-center align-y-center gap-xsmall auto-xy padding-small radius-circle bg-surface-300",
		Text = "",
		onActivated = t1.onActivated,
		isDisabled = t1.isDisabled,
		LayoutOrder = t1.LayoutOrder,
		testId = t1.testId or "FavoritePillView"
	}, {
		Icon = React.createElement(Foundation.Icon, {
			LayoutOrder = 1,
			testId = "FavoritePillIcon",
			name = IconName.Star,
			variant = if t1.isFavorited ~= true then IconVariant.Regular else IconVariant.Filled,
			size = IconSize.Medium
		}),
		Label = React.createElement(Foundation.Text, {
			tag = "auto-xy text-caption-large text-align-x-left text-truncate-none content-emphasis",
			LayoutOrder = 2,
			Text = `{ t1.formatCount(t1.favoritesCount) } { t1.favoritesLabel }`
		})
	})
end

return React.memo(FavoritePillView)
