local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local TextSize = require(parent.TextSize)

local function SduiTileFooter(props)
	local layoutOrder = props.layoutOrder
	local anchorPoint = props.anchorPoint
	local automaticSize = props.automaticSize
	local size = props.size
	local zIndex = props.zIndex
	local position = props.position
	local selectable = props.selectable

	local textSizeOffset = TextSize.getTextSizeStore(false).getTextSizeOffset(false)

	local v = useTokens()

	local fontStyle = props.fontStyle or v.Typography.BodyMedium
	local font

	if not FoundationFontFaceMigration then
		font = fontStyle.Font
	end

	local fontFace

	if FoundationFontFaceMigration then
		fontFace = normalizeFontFace(fontStyle.Font)
	end

	local textColor = props.textColor or v.Color.Content.Default.Color3
	local udim

	if props.iconWidth then
		udim = UDim2.new(0, props.iconWidth, 0, props.iconWidth)
	else
		udim = UDim2.new(0, v.Size.Size_350, 0, v.Size.Size_350)
	end

	local iconColor = props.iconColor or textColor
	local v2 = math.ceil(fontStyle.LineHeight * fontStyle.FontSize + textSizeOffset)

	local textIconGap = props.textIconGap or v.Gap.XSmall
	local sectionGap = props.sectionGap or v.Gap.Small

	local active = props.onActivated ~= nil

	if
		props.leftIcon
		or props.leftIconComponent
		or props.rightIcon
		or props.rightIconComponent
		or props.rightText
		or active
	then
		local v3 = props.rightIcon ~= nil or props.rightIconComponent ~= nil or props.rightText ~= nil

		local createElement = React.createElement
		local tag = React.Tag
		local v4

		if props.testId then
			v4 = `data-testid={props.testId}`
		end

		local v5 = {
			[tag] = v4,
			Position = position,
			AnchorPoint = anchorPoint,
			AutomaticSize = automaticSize or Enum.AutomaticSize.X,
			Size = size or UDim2.new(0, 0, 0, v2),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = layoutOrder,
			ZIndex = zIndex,
			Text = active and "" or nil,
			TextTransparency = active and 1 or nil,
			AutoButtonColor = not active and nil
		}

		local activated = React.Event.Activated
		local v6

		if active then
			v6 = props.onActivated
		end

		v5[activated] = v6
		v5.Active = active

		if selectable == nil then
			selectable = false
		end

		v5.Selectable = selectable
		local v7 = {
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

		local _1_LeftIcon = props.leftIconComponent

		if not _1_LeftIcon then
			if props.leftIcon then
				_1_LeftIcon = React.createElement(ImageSetLabel, {
					LayoutOrder = 1,
					Size = udim,
					BackgroundTransparency = 1,
					ImageColor3 = iconColor,
					ImageTransparency = 0,
					Image = props.leftIcon
				}) or nil
			else
				_1_LeftIcon = nil
			end
		end

		v7["1_LeftIcon"] = _1_LeftIcon

		local createElement2 = React.createElement
		local v8 = {
			BackgroundTransparency = 1,
			Text = props.leftText or "",
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(0, 0, 0, v2),
			Font = font,
			FontFace = fontFace,
			TextSize = fontStyle.FontSize,
			TextTransparency = 0,
			TextColor3 = textColor,
			TextWrapped = false,
			TextTruncate = Enum.TextTruncate.SplitWord,
			TextXAlignment = Enum.TextXAlignment.Left,
			LayoutOrder = 2
		}
		local uiFlexItem

		if props.leftTextFlexMode then
			uiFlexItem = React.createElement("UIFlexItem", { FlexMode = props.leftTextFlexMode }) or nil
		end

		local uiPadding

		if v3 then
			uiPadding = React.createElement("UIPadding", {
				PaddingRight = UDim.new(0, sectionGap - textIconGap)
			})
		end

		v7["2_LeftText"] = createElement2("TextLabel", v8, {
			UIFlexItem = uiFlexItem,
			UIPadding = uiPadding
		})

		local _3_RightIcon = props.rightIconComponent

		if not _3_RightIcon then
			if props.rightIcon then
				_3_RightIcon = React.createElement(ImageSetLabel, {
					LayoutOrder = 3,
					Size = udim,
					BackgroundTransparency = 1,
					ImageColor3 = iconColor,
					ImageTransparency = 0,
					Image = props.rightIcon
				}) or nil
			else
				_3_RightIcon = nil
			end
		end

		v7["3_RightIcon"] = _3_RightIcon
		local _4_RightText

		if props.rightText then
			_4_RightText = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				Text = props.rightText or "",
				AutomaticSize = Enum.AutomaticSize.X,
				Size = UDim2.new(0, 0, 0, v2),
				Font = font,
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
			}) or nil
		end

		v7["4_RightText"] = _4_RightText
		return createElement(active and "TextButton" or "Frame", v5, v7)
	else
		local createElement = React.createElement
		local tag = React.Tag
		local v3

		if props.testId then
			v3 = `data-testid={props.testId}`
		end

		return createElement("TextLabel", {
			[tag] = v3,
			Position = position,
			AnchorPoint = anchorPoint,
			AutomaticSize = automaticSize or Enum.AutomaticSize.X,
			Size = size or UDim2.new(0, 0, 0, v2),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = layoutOrder,
			ZIndex = zIndex,
			Text = props.leftText or "",
			Font = font,
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
