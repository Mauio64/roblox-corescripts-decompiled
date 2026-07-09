local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local LoadableImage = UIBlox.App.Loading.LoadableImage
local withStyle = UIBlox.Style.withStyle
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local v8 = Roact.PureComponent:extend("ItemTileIcon")

v8.defaultProps = {
	hasRoundedCorners = false
}

function v8.render(p1) -- line: 15
	-- upvalues: Roact (copy), LoadableImage (copy), ImageSetLabel (copy), Images (copy), withStyle (copy)
	local propsImage = p1.props.Image
	local hasRoundedCorners = p1.props.hasRoundedCorners

	return withStyle(function(p2) -- line: 19
		-- upvalues: Roact (copy), LoadableImage (copy), propsImage (copy), hasRoundedCorners (copy), ImageSetLabel (copy), Images (copy)
		local Theme = p2.Theme
		local v14 = Roact.createElement(LoadableImage, {
			useShimmerAnimationWhileLoading = true,
			Size = UDim2.new(1, 0, 1, 0),
			Image = propsImage
		})

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			LoadableImage = v14,
			RoundedCornersOverlay = hasRoundedCorners and Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				ZIndex = 2,
				Image = Images["component_assets/circle_17_mask"],
				ImageColor3 = Theme.BackgroundDefault.Color,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(8, 8, 9, 9),
				Size = UDim2.new(1, 0, 1, 0)
			})
		})
	end)
end

return v8
