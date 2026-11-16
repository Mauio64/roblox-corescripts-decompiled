local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation").Hooks.useTokens
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCompat")

local SduiPlaceholder = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiPlaceholder")

local function SduiPlaceholderTile(props)
	local v5 = useTokens()
	local scale = v5.Config.UI.Scale

	local v6 = not (props.imageAspectRatio and props.imageAspectRatio > 0) and 1 or props.imageAspectRatio

	local lineGap = props.lineGap or v5.Gap.XSmall
	local v7 = (props.lineHeight or 8) * scale

	local v8 = math.max(props.titleLineCount or 1, 0)
	local v9 = math.clamp(props.titleLineWidthFraction or 0.7, 0, 1)

	local v10 = math.clamp(props.subtitleLineWidthFraction or 0.55, 0, 1)

	local children = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, lineGap)
		})
	}

	for i = 1, v8 do
		children[`TitleLine{i}`] = React.createElement(SduiPlaceholder, {
			backgroundStyle = props.backgroundStyle,
			cornerRadius = props.cornerRadius,
			layoutOrder = i,
			size = UDim2.new(v9, 0, 0, v7),
			transparencyBinding = props.transparencyBinding
		})
	end

	if props.showSubtitle then
		children.SubtitleLine = React.createElement(SduiPlaceholder, {
			backgroundStyle = props.backgroundStyle,
			cornerRadius = props.cornerRadius,
			layoutOrder = v8 + 1,
			size = UDim2.new(v10, 0, 0, v7),
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
			Padding = UDim.new(0, v5.Gap.Medium)
		}),
		ImageWrapper = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 1 / v6, 0),
			SizeConstraint = Enum.SizeConstraint.RelativeXX
		}, {
			UIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint", {
				AspectRatio = v6
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
