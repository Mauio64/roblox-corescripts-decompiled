local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local useTokens = require(Parent.Foundation).Hooks.useTokens
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local TextSize = require(Parent.TextSize)

local function SduiTileFooter(t1: {[any]: any}) -- line: 59
	-- upvalues: TextSize (copy), useTokens (copy), React (copy), ImageSetLabel (copy)
	local layoutOrder = t1.layoutOrder
	local anchorPoint = t1.anchorPoint
	local automaticSize = t1.automaticSize
	local size = t1.size
	local zIndex = t1.zIndex
	local position = t1.position
	local selectable = t1.selectable
	local v16 = TextSize.getTextSizeStore(false).getTextSizeOffset(false)
	local v17 = useTokens()
	local v18 = t1.fontStyle or v17.Typography.BodyMedium
	local v19 = t1.textColor or v17.Color.Content.Default.Color3
	local v20 = if not t1.iconWidth then UDim2.new(0, v17.Size.Size_350, 0, v17.Size.Size_350) else UDim2.new(0, t1.iconWidth, 0, t1.iconWidth)
	local v21 = t1.iconColor or v19
	local v22 = math.ceil(v18.LineHeight * v18.FontSize + v16)
	local v23 = t1.textIconGap or v17.Gap.XSmall
	local v24 = t1.sectionGap or v17.Gap.Small
	local v25 = t1.onActivated ~= nil

	if not t1.leftIcon and (not t1.leftIconComponent and (not t1.rightIcon and (not t1.rightIconComponent and not t1.rightText))) and not v25 then
		return React.createElement("TextLabel", {
			[React.Tag] = if not t1.testId then nil else `data-testid={ t1.testId }`,
			Position = position,
			AnchorPoint = anchorPoint,
			AutomaticSize = automaticSize or Enum.AutomaticSize.X,
			Size = size or UDim2.new(0, 0, 0, v22),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = layoutOrder,
			ZIndex = zIndex,
			Text = t1.leftText or "",
			Font = v18.Font,
			TextSize = v18.FontSize,
			TextTransparency = 0,
			TextColor3 = v19,
			TextWrapped = false,
			TextTruncate = Enum.TextTruncate.SplitWord,
			TextXAlignment = Enum.TextXAlignment.Left
		}, {
			UIFlexItem = t1.leftTextFlexMode and React.createElement("UIFlexItem", {
				FlexMode = t1.leftTextFlexMode
			}) or nil
		})
	end

	local v26 = t1.rightIcon ~= nil or (t1.rightIconComponent ~= nil or t1.rightText ~= nil)

	return React.createElement(not v25 and "Frame" or "TextButton", {
		[React.Tag] = if not t1.testId then nil else `data-testid={ t1.testId }`,
		Position = position,
		AnchorPoint = anchorPoint,
		AutomaticSize = automaticSize or Enum.AutomaticSize.X,
		Size = size or UDim2.new(0, 0, 0, v22),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = layoutOrder,
		ZIndex = zIndex,
		Text = if not v25 then nil else "",
		TextTransparency = if not v25 then nil else 1,
		AutoButtonColor = not v25 and nil,
		[React.Event.Activated] = if not v25 then nil else t1.onActivated,
		Active = v25,
		Selectable = selectable ~= nil and selectable
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.Name,
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, v23),
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		["1_LeftIcon"] = t1.leftIconComponent or (t1.leftIcon and React.createElement(ImageSetLabel, {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			ImageTransparency = 0,
			Size = v20,
			ImageColor3 = v21,
			Image = t1.leftIcon
		}) or nil),
		["2_LeftText"] = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			TextTransparency = 0,
			TextWrapped = false,
			LayoutOrder = 2,
			Text = t1.leftText or "",
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(0, 0, 0, v22),
			Font = v18.Font,
			TextSize = v18.FontSize,
			TextColor3 = v19,
			TextTruncate = Enum.TextTruncate.SplitWord,
			TextXAlignment = Enum.TextXAlignment.Left
		}, {
			UIFlexItem = t1.leftTextFlexMode and React.createElement("UIFlexItem", {
				FlexMode = t1.leftTextFlexMode
			}) or nil,
			UIPadding = if not v26 then nil else React.createElement("UIPadding", {
				PaddingRight = UDim.new(0, v24 - v23)
			})
		}),
		["3_RightIcon"] = t1.rightIconComponent or (t1.rightIcon and React.createElement(ImageSetLabel, {
			LayoutOrder = 3,
			BackgroundTransparency = 1,
			ImageTransparency = 0,
			Size = v20,
			ImageColor3 = v21,
			Image = t1.rightIcon
		}) or nil),
		["4_RightText"] = t1.rightText and React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			TextTransparency = 0,
			TextWrapped = false,
			LayoutOrder = 4,
			Text = t1.rightText or "",
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(0, 0, 0, v22),
			Font = v18.Font,
			TextSize = v18.FontSize,
			TextColor3 = v19,
			TextTruncate = Enum.TextTruncate.SplitWord,
			TextXAlignment = Enum.TextXAlignment.Left
		}, {
			UIFlexItem = React.createElement("UIFlexItem", {
				FlexMode = t1.rightTextFlexMode or Enum.UIFlexMode.Shrink
			})
		}) or nil
	})
end

return React.memo(SduiTileFooter)
