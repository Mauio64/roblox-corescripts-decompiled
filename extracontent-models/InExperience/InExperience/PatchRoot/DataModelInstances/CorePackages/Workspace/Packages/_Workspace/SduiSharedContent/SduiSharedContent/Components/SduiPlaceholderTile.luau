local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
require(parent.SduiCompat)

local SduiPlaceholder = require(script.Parent.SduiPlaceholder)

local function SduiPlaceholderTile(props)
	local v = useTokens()
	local scale = v.Config.UI.Scale

	local aspectRatio = not (props.imageAspectRatio and props.imageAspectRatio > 0) and 1 or props.imageAspectRatio

	local lineGap = props.lineGap or v.Gap.XSmall
	local v2 = (props.lineHeight or 8) * scale

	local v3 = math.max(props.titleLineCount or 1, 0)
	local v4 = math.clamp(props.titleLineWidthFraction or 0.7, 0, 1)

	local v5 = math.clamp(props.subtitleLineWidthFraction or 0.55, 0, 1)

	local children = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, lineGap)
		})
	}

	for i = 1, v3 do
		children[`TitleLine{i}`] = React.createElement(SduiPlaceholder, {
			backgroundStyle = props.backgroundStyle,
			cornerRadius = props.cornerRadius,
			layoutOrder = i,
			size = UDim2.new(v4, 0, 0, v2),
			transparencyBinding = props.transparencyBinding
		})
	end

	if props.showSubtitle then
		children.SubtitleLine = React.createElement(SduiPlaceholder, {
			backgroundStyle = props.backgroundStyle,
			cornerRadius = props.cornerRadius,
			layoutOrder = v3 + 1,
			size = UDim2.new(v5, 0, 0, v2),
			transparencyBinding = props.transparencyBinding
		})
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = props.layoutOrder,
		Position = props.position,
		Size = props.size or UDim2.fromScale(1, 1),
		ZIndex = props.zIndex
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v.Gap.Medium)
		}),
		ImageWrapper = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 1 / aspectRatio, 0),
			SizeConstraint = Enum.SizeConstraint.RelativeXX
		}, {
			UIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint", {
				AspectRatio = aspectRatio
			}),
			ImagePlaceholder = React.createElement(SduiPlaceholder, {
				backgroundStyle = props.backgroundStyle,
				cornerRadius = props.imageCornerRadius,
				size = UDim2.fromScale(1, 1),
				transparencyBinding = props.transparencyBinding
			})
		}),
		LineContainer = React.createElement("Frame", {
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 2,
			Size = UDim2.fromScale(1, 0)
		}, children)
	})
end

return React.memo(SduiPlaceholderTile)
