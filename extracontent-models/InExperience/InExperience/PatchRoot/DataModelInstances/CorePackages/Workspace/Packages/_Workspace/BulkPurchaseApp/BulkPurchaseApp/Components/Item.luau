local Parent = script:FindFirstAncestor("BulkPurchaseApp").Parent
local React = require(Parent.React)
local StyledTextLabel = require(Parent.UIBlox).App.Text.StyledTextLabel
local useDesignTokens = require(Parent.Style).useDesignTokens
local FFlagReplaceMissingDesignTokens = require(Parent.SharedFlags).FFlagReplaceMissingDesignTokens
local Box = require(script.Parent.Box)

local function mapTokens(p1) -- line: 14
	local Size_1200 = p1.Size.Size_1200
	local Size_200 = p1.Size.Size_200

	return {
		fontStyle = p1.Typography.BodyLarge,
		colorStyle = p1.Color.Content.Default,
		imageRightMargin = p1.Size.Size_300,
		imageBoxSize = Size_1200,
		imageBoxPadding = Size_200,
		imageBoxTransparency = p1.Color.Common.Shimmer.Transparency,
		imageBoxBackgroundColor = p1.Color.Common.Shimmer.Color3,
		imageBoxCornerRadius = p1.Radius.Medium,
		imageSize = Size_1200 - Size_200 * 2
	}
end
local function Item(t1: {[any]: any}) -- line: 38
	-- upvalues: useDesignTokens (copy), mapTokens (copy), React (copy), Box (copy), StyledTextLabel (copy), FFlagReplaceMissingDesignTokens (copy)
	local v13 = useDesignTokens(mapTokens)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, v13.imageBoxSize),
		LayoutOrder = t1.LayoutOrder
	}, {
		ImageBox = React.createElement(Box, {
			BorderSizePixel = 0,
			Size = UDim2.fromOffset(v13.imageBoxSize, v13.imageBoxSize),
			BackgroundTransparency = v13.imageBoxTransparency,
			BackgroundColor3 = v13.imageBoxBackgroundColor,
			padding = {
				v13.imageBoxPadding,
				v13.imageBoxPadding,
				v13.imageBoxPadding,
				v13.imageBoxPadding
			},
			cornerRadius = UDim.new(0, v13.imageBoxCornerRadius)
		}, {
			Image = React.createElement("ImageLabel", {
				Image = t1.image,
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(v13.imageSize, v13.imageSize),
				[React.Tag] = "data-testid=BulkPurchaseApp_ItemImage"
			})
		}),
		LineItem = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.fromOffset(v13.imageBoxSize + v13.imageRightMargin, 0),
			Size = UDim2.new(1, -(v13.imageBoxSize + v13.imageRightMargin), 1, 0)
		}, React.createElement(StyledTextLabel, {
			fontStyle = v13.fontStyle,
			colorStyle = v13.colorStyle,
			text = t1.name,
			textTruncate = Enum.TextTruncate.AtEnd,
			textYAlignment = Enum.TextYAlignment.Top,
			size = UDim2.new(0.66, 0, 1, 0),
			lineHeight = if not FFlagReplaceMissingDesignTokens then v13.fontStyle.lineHeight else v13.fontStyle.LineHeight
		}), React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(1, 0),
			Size = UDim2.new(0.33, 0, 1, 0),
			Position = UDim2.new(1, 0, 0, 0)
		}, t1.endSlot))
	})
end

return Item
