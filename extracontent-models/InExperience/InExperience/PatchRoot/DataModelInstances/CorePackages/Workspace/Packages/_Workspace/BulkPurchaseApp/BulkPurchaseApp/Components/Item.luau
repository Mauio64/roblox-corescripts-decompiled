local parent = script:FindFirstAncestor("BulkPurchaseApp").Parent
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens

local SharedFlags = require(parent.SharedFlags)

local FFlagReplaceMissingDesignTokens = SharedFlags.FFlagReplaceMissingDesignTokens

local Box = require(script.Parent.Box)

local function mapTokens(data)
	local size_1200 = data.Size.Size_1200
	local size_200 = data.Size.Size_200

	return {
		fontStyle = data.Typography.BodyLarge,
		colorStyle = data.Color.Content.Default,
		imageRightMargin = data.Size.Size_300,
		imageBoxSize = size_1200,
		imageBoxPadding = size_200,
		imageBoxTransparency = data.Color.Common.Shimmer.Transparency,
		imageBoxBackgroundColor = data.Color.Common.Shimmer.Color3,
		imageBoxCornerRadius = data.Radius.Medium,
		imageSize = size_1200 - size_200 * 2
	}
end

local function Item(props)
	local v = useDesignTokens(mapTokens)

	local createElement = React.createElement
	local v2 = {
		Size = UDim2.new(1, 0, 0, v.imageBoxSize),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = props.LayoutOrder
	}
	local children = {
		ImageBox = React.createElement(Box, {
			Size = UDim2.fromOffset(v.imageBoxSize, v.imageBoxSize),
			BorderSizePixel = 0,
			BackgroundTransparency = v.imageBoxTransparency,
			BackgroundColor3 = v.imageBoxBackgroundColor,
			padding = { v.imageBoxPadding, v.imageBoxPadding, v.imageBoxPadding, v.imageBoxPadding },
			cornerRadius = UDim.new(0, v.imageBoxCornerRadius)
		}, {
			Image = React.createElement("ImageLabel", {
				Image = props.image,
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(v.imageSize, v.imageSize),
				[React.Tag] = "data-testid=BulkPurchaseApp_ItemImage"
			})
		}),
		LineItem = 0
	}

	local createElement2 = React.createElement

	local v3 = {
		Position = UDim2.fromOffset(v.imageBoxSize + v.imageRightMargin, 0),
		Size = UDim2.new(1, -(v.imageBoxSize + v.imageRightMargin), 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}

	local createElement3 = React.createElement
	local v4 = {
		fontStyle = v.fontStyle,
		colorStyle = v.colorStyle,
		text = props.name,
		textTruncate = Enum.TextTruncate.AtEnd,
		textYAlignment = Enum.TextYAlignment.Top,
		size = UDim2.new(0.66, 0, 1, 0),
		lineHeight = 0
	}
	local lineHeight

	if FFlagReplaceMissingDesignTokens then
		lineHeight = v.fontStyle.LineHeight
	else
		lineHeight = v.fontStyle.lineHeight
	end

	v4.lineHeight = lineHeight
	children.LineItem = createElement2("Frame", v3, createElement3(StyledTextLabel, v4), React.createElement("Frame", {
		AnchorPoint = Vector2.new(1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(0.33, 0, 1, 0),
		Position = UDim2.new(1, 0, 0, 0)
	}, props.endSlot))
	return createElement("Frame", v2, children)
end

return Item
