local Parent = script:FindFirstAncestor("BulkPurchaseApp").Parent
local React = require(Parent.React)
local StyledTextLabel = require(Parent.UIBlox).App.Text.StyledTextLabel
local useDesignTokens = require(Parent.Style).useDesignTokens
local SharedFlags = require(Parent.SharedFlags)
local FFlagRenameDeprecatedUIBloxTokens = SharedFlags.FFlagRenameDeprecatedUIBloxTokens
local FFlagReplaceMissingDesignTokens = SharedFlags.FFlagReplaceMissingDesignTokens
local Box = require(script.Parent.Box)

local function mapTokens(p1) -- line: 15
	-- upvalues: FFlagRenameDeprecatedUIBloxTokens (copy)
	local v12 = if not FFlagRenameDeprecatedUIBloxTokens then p1.Global.Size_600 else p1.Size.Size_1200
	local v13 = if not FFlagRenameDeprecatedUIBloxTokens then p1.Global.Space_100 else p1.Size.Size_200

	return {
		fontStyle = if not FFlagRenameDeprecatedUIBloxTokens then p1.Semantic.Typography.Body else p1.Typography.BodyLarge,
		colorStyle = if not FFlagRenameDeprecatedUIBloxTokens then p1.Semantic.Color.Text.Default else p1.Color.Content.Default,
		imageRightMargin = if not FFlagRenameDeprecatedUIBloxTokens then p1.Global.Space_150 else p1.Size.Size_300,
		imageBoxSize = v12,
		imageBoxPadding = v13,
		imageBoxTransparency = ((if not FFlagRenameDeprecatedUIBloxTokens then p1.Semantic.Color.Common.Placeholder else p1.Color.Common.Shimmer)).Transparency,
		imageBoxBackgroundColor = ((if not FFlagRenameDeprecatedUIBloxTokens then p1.Semantic.Color.Common.Placeholder else p1.Color.Common.Shimmer)).Color3,
		imageBoxCornerRadius = if not FFlagRenameDeprecatedUIBloxTokens then p1.Semantic.Radius.Medium else p1.Radius.Medium,
		imageSize = v12 - v13 * 2
	}
end
local function Item(t1: {[any]: any}) -- line: 55
	-- upvalues: useDesignTokens (copy), mapTokens (copy), React (copy), Box (copy), StyledTextLabel (copy), FFlagReplaceMissingDesignTokens (copy)
	local v15 = useDesignTokens(mapTokens)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, v15.imageBoxSize),
		LayoutOrder = t1.LayoutOrder
	}, {
		ImageBox = React.createElement(Box, {
			BorderSizePixel = 0,
			Size = UDim2.fromOffset(v15.imageBoxSize, v15.imageBoxSize),
			BackgroundTransparency = v15.imageBoxTransparency,
			BackgroundColor3 = v15.imageBoxBackgroundColor,
			padding = {
				v15.imageBoxPadding,
				v15.imageBoxPadding,
				v15.imageBoxPadding,
				v15.imageBoxPadding
			},
			cornerRadius = UDim.new(0, v15.imageBoxCornerRadius)
		}, {
			Image = React.createElement("ImageLabel", {
				Image = t1.image,
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(v15.imageSize, v15.imageSize),
				[React.Tag] = "data-testid=BulkPurchaseApp_ItemImage"
			})
		}),
		LineItem = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.fromOffset(v15.imageBoxSize + v15.imageRightMargin, 0),
			Size = UDim2.new(1, -(v15.imageBoxSize + v15.imageRightMargin), 1, 0)
		}, React.createElement(StyledTextLabel, {
			fontStyle = v15.fontStyle,
			colorStyle = v15.colorStyle,
			text = t1.name,
			textTruncate = Enum.TextTruncate.AtEnd,
			textYAlignment = Enum.TextYAlignment.Top,
			size = UDim2.new(0.66, 0, 1, 0),
			lineHeight = if not FFlagReplaceMissingDesignTokens then v15.fontStyle.lineHeight else v15.fontStyle.LineHeight
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
