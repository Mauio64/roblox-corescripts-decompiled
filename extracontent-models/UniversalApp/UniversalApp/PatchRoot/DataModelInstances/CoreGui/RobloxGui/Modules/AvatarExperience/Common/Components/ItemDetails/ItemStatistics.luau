local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local t = require(CorePackages.Packages.t)
local FitFrameVertical = require(CorePackages.Packages.AvatarExperienceDeps).RoactFitComponents.FitFrameVertical
local NumberLocalization = require(CorePackages.Workspace.Packages.Localization).NumberLocalization
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local RoactLocalization = require(Modules.LuaApp.Services.RoactLocalization)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Skeleton = require(CorePackages.Packages.Foundation).Skeleton
local StatWidget = UIBlox.App.Indicator.StatWidget
local v13 = UIBlox.App.ImageSet.Images["icons/actions/favoriteOn"]
local v14 = ArgCheck.wrap(t.strictInterface({
	favoritesCount = t.optional(t.integer),
	listPadding = t.optional(t.integer),
	width = t.optional(t.number),
	Position = t.optional(t.UDim2),
	LayoutOrder = t.optional(t.integer)
}))

local function ItemStatistics(t1: {[any]: any}) -- line: 42
	-- upvalues: v14 (copy), useRoactService (copy), RoactLocalization (copy), React (copy), Skeleton (copy), NumberLocalization (copy), FitFrameVertical (copy), StatWidget (copy), v13 (copy)
	assert(v14(t1))

	local v17 = t1.LayoutOrder or 0
	local v18 = t1.Position or UDim2.new(0, 0, 0, 0)
	local v19 = t1.width or 0
	local v20 = t1.listPadding or 10
	local favoritesCount = t1.favoritesCount
	local v22 = useRoactService(RoactLocalization)

	if not favoritesCount then
		return (React.createElement(Skeleton, {
			Position = v18,
			Size = UDim2.new(0, v19, 0, 70),
			LayoutOrder = v17
		}))
	end

	local v23 = v19 - v20 * 2
	local v24 = v22:Format("Feature.Catalog.Label.Favorites")
	local v25 = NumberLocalization.abbreviate(favoritesCount, v22:GetLocale())

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(0, v19, 0, 70),
		Position = v18,
		LayoutOrder = v17
	}, {
		ItemStatisticsSection = React.createElement(FitFrameVertical, {
			BackgroundTransparency = 1,
			LayoutOrder = 0,
			width = UDim.new(0, v19),
			contentPadding = UDim.new(0, v20),
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 0, 0.5, 0)
		}, {
			FavoritesSection = React.createElement(StatWidget, {
				layoutOrder = 0,
				icon = v13,
				countText = v25,
				labelText = v24,
				size = UDim2.new(0, v23, 1, 0)
			})
		})
	})
end

return ItemStatistics
