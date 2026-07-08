local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local React = require(Parent.React)
local useTokens = require(Parent.Foundation).Hooks.useTokens

require(Parent.SduiCompat)

local SduiPlaceholder = require(script.Parent.SduiPlaceholder)

local function SduiPlaceholderTile(t1: {[any]: any}) -- line: 45
	-- upvalues: useTokens (copy), React (copy), SduiPlaceholder (copy)
	local v7 = useTokens()
	local UIScale = v7.Config.UI.Scale
	local v9 = (not t1.imageAspectRatio or not (t1.imageAspectRatio > 0)) and 1 or t1.imageAspectRatio
	local v10 = t1.lineGap or v7.Gap.XSmall
	local v11 = (t1.lineHeight or 8) * UIScale
	local v12 = math.max(t1.titleLineCount or 1, 0)
	local v13 = math.clamp(t1.titleLineWidthFraction or 0.7, 0, 1)
	local v14 = math.clamp(t1.subtitleLineWidthFraction or 0.55, 0, 1)
	local t2 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v10)
		})
	}

	for i = 1, v12 do
		t2[`TitleLine{ i }`] = React.createElement(SduiPlaceholder, {
			backgroundStyle = t1.backgroundStyle,
			cornerRadius = t1.cornerRadius,
			layoutOrder = i,
			size = UDim2.new(v13, 0, 0, v11),
			transparencyBinding = t1.transparencyBinding
		})
	end

	if t1.showSubtitle then
		t2.SubtitleLine = React.createElement(SduiPlaceholder, {
			backgroundStyle = t1.backgroundStyle,
			cornerRadius = t1.cornerRadius,
			layoutOrder = v12 + 1,
			size = UDim2.new(v14, 0, 0, v11),
			transparencyBinding = t1.transparencyBinding
		})
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = t1.layoutOrder,
		Position = t1.position,
		Size = t1.size or UDim2.fromScale(1, 1),
		ZIndex = t1.zIndex
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v7.Gap.Medium)
		}),
		ImageWrapper = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 1 / v9, 0),
			SizeConstraint = Enum.SizeConstraint.RelativeXX
		}, {
			UIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint", {
				AspectRatio = v9
			}),
			ImagePlaceholder = React.createElement(SduiPlaceholder, {
				backgroundStyle = t1.backgroundStyle,
				cornerRadius = t1.imageCornerRadius,
				size = UDim2.fromScale(1, 1),
				transparencyBinding = t1.transparencyBinding
			})
		}),
		LineContainer = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 2,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0)
		}, t2)
	})
end

return React.memo(SduiPlaceholderTile)
