local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)

local withStyle = UIBlox.Style.withStyle
local springAnimatedItem = UIBlox.Utility.SpringAnimatedItem
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local images = UIBlox.App.ImageSet.Images

local extended = Roact.PureComponent:extend("NavHighlight")

local component_assetstriangleUp_16 = images["component_assets/triangleUp_16"]

local v5 = { dampingRatio = 1, frequency = 3.5 }

local vector2 = Vector2.new(20, 8)

local function mapAnimatedValuesToProps(p2)
	return {
		Size = UDim2.new(0, p2.width, 1, 0),
		Position = UDim2.fromOffset(p2.position, 0)
	}
end

extended.validateProps = t.strictInterface({
	useArrowHighlight = t.optional(t.boolean),
	selectedCategoryButtonInstance = t.optional(t.Instance),
	scrollingFrameRef = t.table
})

function extended.render(p2)
	local useArrowHighlight = p2.props.useArrowHighlight

	local v6 = 0
	local v7 = 0

	if p2.props.selectedCategoryButtonInstance then
		local selectedCategoryButtonInstance = p2.props.selectedCategoryButtonInstance

		if selectedCategoryButtonInstance then
			v6 = selectedCategoryButtonInstance.AbsoluteSize.X
			v7 = selectedCategoryButtonInstance.AbsolutePosition.X
		end
	end

	local value = p2.props.scrollingFrameRef:getValue()

	if value then
		v7 = v7 + value.CanvasPosition.X - value.AbsolutePosition.X
	end

	return withStyle(function(p3)
		local theme = p3.Theme

		local v8 = {
			Highlight = not useArrowHighlight and Roact.createElement("Frame", {
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.new(0, 0, 1, 0),
				Size = UDim2.new(1, 0, 0, 3),
				BorderSizePixel = 0,
				BackgroundColor3 = theme.IconEmphasis.Color,
				BackgroundTransparency = theme.IconEmphasis.Transparency
			}),
			ArrowHighlight = useArrowHighlight and Roact.createElement(imageSetLabel, {
				AnchorPoint = Vector2.new(0.5, 1),
				BackgroundTransparency = 1,
				Position = UDim2.new(0.5, 0, 1, 0),
				Size = UDim2.new(0, vector2.X, 0, vector2.Y),
				Image = component_assetstriangleUp_16,
				ImageColor3 = theme.BackgroundContrast.Color,
				ImageTransparency = theme.BackgroundContrast.Transparency
			})
		}

		return Roact.createElement(springAnimatedItem.AnimatedFrame, {
			regularProps = { BackgroundTransparency = 1 },
			animatedValues = { width = v6, position = v7 },
			mapValuesToProps = mapAnimatedValuesToProps,
			springOptions = v5
		}, v8)
	end)
end

return extended
