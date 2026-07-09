local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)
local withStyle = UIBlox.Style.withStyle
local SpringAnimatedItem = UIBlox.Utility.SpringAnimatedItem
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local v9 = Roact.PureComponent:extend("NavHighlight")
local v10 = Images["component_assets/triangleUp_16"]
local t1 = {
	dampingRatio = 1,
	frequency = 3.5
}
local vector2 = Vector2.new(20, 8)

local function mapAnimatedValuesToProps(p1) -- line: 23
	return {
		Size = UDim2.new(0, p1.width, 1, 0),
		Position = UDim2.fromOffset(p1.position, 0)
	}
end

v9.validateProps = t.strictInterface({
	useArrowHighlight = t.optional(t.boolean),
	selectedCategoryButtonInstance = t.optional(t.Instance),
	scrollingFrameRef = t.table
})

function v9.render(p2) -- line: 38
	-- upvalues: withStyle (copy), Roact (copy), ImageSetLabel (copy), vector2 (copy), v10 (copy), SpringAnimatedItem (copy), mapAnimatedValuesToProps (copy), t1 (copy)
	local useArrowHighlight = p2.props.useArrowHighlight
	local n1 = 0
	local n2 = 0

	if p2.props.selectedCategoryButtonInstance then
		local selectedCategoryButtonInstance = p2.props.selectedCategoryButtonInstance

		if selectedCategoryButtonInstance then
			n1 = selectedCategoryButtonInstance.AbsoluteSize.X
			n2 = selectedCategoryButtonInstance.AbsolutePosition.X
		end
	end

	local v20 = p2.props.scrollingFrameRef:getValue()

	if v20 then
		n2 = n2 + v20.CanvasPosition.X - v20.AbsolutePosition.X
	end

	return withStyle(function(p3) -- line: 60
		-- upvalues: useArrowHighlight (copy), Roact (copy), ImageSetLabel (copy), vector2 (copy), v10 (copy), SpringAnimatedItem (copy), n1 (ref), n2 (ref), mapAnimatedValuesToProps (copy), t1 (copy)
		local Theme = p3.Theme
		local t2 = {
			Highlight = not useArrowHighlight and Roact.createElement("Frame", {
				BorderSizePixel = 0,
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.new(0, 0, 1, 0),
				Size = UDim2.new(1, 0, 0, 3),
				BackgroundColor3 = Theme.IconEmphasis.Color,
				BackgroundTransparency = Theme.IconEmphasis.Transparency
			}),
			ArrowHighlight = useArrowHighlight and Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 1),
				Position = UDim2.new(0.5, 0, 1, 0),
				Size = UDim2.new(0, vector2.X, 0, vector2.Y),
				Image = v10,
				ImageColor3 = Theme.BackgroundContrast.Color,
				ImageTransparency = Theme.BackgroundContrast.Transparency
			})
		}

		return Roact.createElement(SpringAnimatedItem.AnimatedFrame, {
			regularProps = {
				BackgroundTransparency = 1
			},
			animatedValues = {
				width = n1,
				position = n2
			},
			mapValuesToProps = mapAnimatedValuesToProps,
			springOptions = t1
		}, t2)
	end)
end

return v9
