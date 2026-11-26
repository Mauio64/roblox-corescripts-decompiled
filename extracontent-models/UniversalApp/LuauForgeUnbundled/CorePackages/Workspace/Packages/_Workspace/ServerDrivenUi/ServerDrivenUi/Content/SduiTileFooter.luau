local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Foundation")
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/TextSize")

local function SduiTileFooter(props)
	local layoutOrder = props.layoutOrder
	local anchorPoint = props.anchorPoint
	local automaticSize = props.automaticSize
	local size = props.size
	local zIndex = props.zIndex
	local position = props.position
	local v5 = props.selectable

	local textSizeOffset = module4.getTextSizeStore(false).getTextSizeOffset(false)

	local v6 = useTokens()

	local fontStyle = props.fontStyle or v6.Typography.BodyMedium
	local fontFace = normalizeFontFace(fontStyle.Font)
	local textColor = props.textColor or v6.Color.Content.Default.Color3
	local udim

	if props.iconWidth then
		udim = UDim2.new(0, props.iconWidth, 0, props.iconWidth)
	else
		udim = UDim2.new(0, v6.Size.Size_350, 0, v6.Size.Size_350)
	end

	local iconColor = props.iconColor or textColor
	local v7 = math.ceil(fontStyle.LineHeight * fontStyle.FontSize + textSizeOffset)

	local textIconGap = props.textIconGap or v6.Gap.XSmall
	local sectionGap = props.sectionGap or v6.Gap.Small

	local v8 = props.onActivated ~= nil

	if
		props.leftIcon
		or props.leftIconComponent
		or props.rightIcon
		or props.rightIconComponent
		or props.rightText
		or v8
	then
		local v9 = props.rightIcon ~= nil or props.rightIconComponent ~= nil or props.rightText ~= nil

		local createElement = React.createElement
		local tag = React.Tag
		local v12 = if props.testId then `data-testid={props.testId}` else nil
		local v11 = {
			[tag] = v12,
			Position = position,
			AnchorPoint = anchorPoint,
			AutomaticSize = automaticSize or Enum.AutomaticSize.X,
			Size = size or UDim2.new(0, 0, 0, v7),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = layoutOrder,
			ZIndex = zIndex,
			Text = v8 and "" or nil,
			TextTransparency = v8 and 1 or nil,
			AutoButtonColor = if v8 then false else nil
		}

		local activated = React.Event.Activated
		local v14 = if v8 then props.onActivated else nil
		v11[activated] = v14
		v11.Active = v8

		if v5 == nil then
			v5 = false
		end

		v11.Selectable = v5
		local v15 = {
			["UIListLayout"] = nil,
			["UIListLayout"] = nil,
			["UIListLayout"] = nil,
			["UIListLayout"] = nil,
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.Name,
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, textIconGap),
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center
			})
		}

		local v16 = props.leftIconComponent

		if not v16 then
			if props.leftIcon then
				v16 = React.createElement(imageSetLabel, {
					LayoutOrder = 1,
					Size = udim,
					BackgroundTransparency = 1,
					ImageColor3 = iconColor,
					ImageTransparency = 0,
					Image = props.leftIcon
				}) or nil
			else
				v16 = nil
			end
		end

		v15["1_LeftIcon"] = v16

		local createElement2 = React.createElement
		local v18 = {
			BackgroundTransparency = 1,
			Text = props.leftText or "",
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(0, 0, 0, v7),
			FontFace = fontFace,
			TextSize = fontStyle.FontSize,
			TextTransparency = 0,
			TextColor3 = textColor,
			TextWrapped = false,
			TextTruncate = Enum.TextTruncate.SplitWord,
			TextXAlignment = Enum.TextXAlignment.Left,
			LayoutOrder = 2
		}

		local v20 = if props.leftTextFlexMode then React.createElement("UIFlexItem", {
			FlexMode = props.leftTextFlexMode
		}) or nil else nil

		local v21 = if v9 then React.createElement("UIPadding", {
			PaddingRight = UDim.new(0, sectionGap - textIconGap)
		}) else nil
		v15["2_LeftText"] = createElement2("TextLabel", v18, {
			UIFlexItem = v20,
			UIPadding = v21
		})

		local v22 = props.rightIconComponent

		if not v22 then
			if props.rightIcon then
				v22 = React.createElement(imageSetLabel, {
					LayoutOrder = 3,
					Size = udim,
					BackgroundTransparency = 1,
					ImageColor3 = iconColor,
					ImageTransparency = 0,
					Image = props.rightIcon
				}) or nil
			else
				v22 = nil
			end
		end

		v15["3_RightIcon"] = v22

		local v23 = if props.rightText then React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Text = props.rightText or "",
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(0, 0, 0, v7),
			FontFace = fontFace,
			TextSize = fontStyle.FontSize,
			TextTransparency = 0,
			TextColor3 = textColor,
			TextWrapped = false,
			TextTruncate = Enum.TextTruncate.SplitWord,
			TextXAlignment = Enum.TextXAlignment.Left,
			LayoutOrder = 4
		}, {
			UIFlexItem = React.createElement("UIFlexItem", {
				FlexMode = props.rightTextFlexMode or Enum.UIFlexMode.Shrink
			})
		}) or nil else nil
		v15["4_RightText"] = v23
		return createElement(v8 and "TextButton" or "Frame", v11, v15)
	else
		local createElement = React.createElement
		local tag = React.Tag
		local v11 = if props.testId then `data-testid={props.testId}` else nil
		return createElement("TextLabel", {
			[tag] = v11,
			Position = position,
			AnchorPoint = anchorPoint,
			AutomaticSize = automaticSize or Enum.AutomaticSize.X,
			Size = size or UDim2.new(0, 0, 0, v7),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = layoutOrder,
			ZIndex = zIndex,
			Text = props.leftText or "",
			FontFace = fontFace,
			TextSize = fontStyle.FontSize,
			TextTransparency = 0,
			TextColor3 = textColor,
			TextWrapped = false,
			TextTruncate = Enum.TextTruncate.SplitWord,
			TextXAlignment = Enum.TextXAlignment.Left
		}, {
			UIFlexItem = props.leftTextFlexMode and React.createElement("UIFlexItem", {
				FlexMode = props.leftTextFlexMode
			}) or nil
		})
	end
end

return React.memo(SduiTileFooter)
