local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Foundation")
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
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
	local font = if not foundationFontFaceMigration then fontStyle.Font else nil
	local v7 = if foundationFontFaceMigration then normalizeFontFace(fontStyle.Font) else nil
	local textColor = props.textColor or v6.Color.Content.Default.Color3
	local udim

	if props.iconWidth then
		udim = UDim2.new(0, props.iconWidth, 0, props.iconWidth)
	else
		udim = UDim2.new(0, v6.Size.Size_350, 0, v6.Size.Size_350)
	end

	local iconColor = props.iconColor or textColor
	local v8 = math.ceil(fontStyle.LineHeight * fontStyle.FontSize + textSizeOffset)

	local textIconGap = props.textIconGap or v6.Gap.XSmall
	local sectionGap = props.sectionGap or v6.Gap.Small

	local v9 = props.onActivated ~= nil

	if
		props.leftIcon
		or props.leftIconComponent
		or props.rightIcon
		or props.rightIconComponent
		or props.rightText
		or v9
	then
		local v10 = props.rightIcon ~= nil or props.rightIconComponent ~= nil or props.rightText ~= nil

		local createElement = React.createElement
		local tag = React.Tag
		local v13 = if props.testId then `data-testid={props.testId}` else nil
		local v12 = {
			[tag] = v13,
			Position = position,
			AnchorPoint = anchorPoint,
			AutomaticSize = automaticSize or Enum.AutomaticSize.X,
			Size = size or UDim2.new(0, 0, 0, v8),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = layoutOrder,
			ZIndex = zIndex,
			Text = v9 and "" or nil,
			TextTransparency = v9 and 1 or nil,
			AutoButtonColor = if v9 then false else nil
		}

		local activated = React.Event.Activated
		local v15 = if v9 then props.onActivated else nil
		v12[activated] = v15
		v12.Active = v9

		if v5 == nil then
			v5 = false
		end

		v12.Selectable = v5
		local v16 = {
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

		local v17 = props.leftIconComponent

		if not v17 then
			if props.leftIcon then
				v17 = React.createElement(imageSetLabel, {
					LayoutOrder = 1,
					Size = udim,
					BackgroundTransparency = 1,
					ImageColor3 = iconColor,
					ImageTransparency = 0,
					Image = props.leftIcon
				}) or nil
			else
				v17 = nil
			end
		end

		v16["1_LeftIcon"] = v17

		local createElement2 = React.createElement
		local v19 = {
			BackgroundTransparency = 1,
			Text = props.leftText or "",
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(0, 0, 0, v8),
			Font = font,
			FontFace = v7,
			TextSize = fontStyle.FontSize,
			TextTransparency = 0,
			TextColor3 = textColor,
			TextWrapped = false,
			TextTruncate = Enum.TextTruncate.SplitWord,
			TextXAlignment = Enum.TextXAlignment.Left,
			LayoutOrder = 2
		}

		local v21 = if props.leftTextFlexMode then React.createElement("UIFlexItem", {
			FlexMode = props.leftTextFlexMode
		}) or nil else nil

		local v22 = if v10 then React.createElement("UIPadding", {
			PaddingRight = UDim.new(0, sectionGap - textIconGap)
		}) else nil
		v16["2_LeftText"] = createElement2("TextLabel", v19, {
			UIFlexItem = v21,
			UIPadding = v22
		})

		local v23 = props.rightIconComponent

		if not v23 then
			if props.rightIcon then
				v23 = React.createElement(imageSetLabel, {
					LayoutOrder = 3,
					Size = udim,
					BackgroundTransparency = 1,
					ImageColor3 = iconColor,
					ImageTransparency = 0,
					Image = props.rightIcon
				}) or nil
			else
				v23 = nil
			end
		end

		v16["3_RightIcon"] = v23

		local v24 = if props.rightText then React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Text = props.rightText or "",
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(0, 0, 0, v8),
			Font = font,
			FontFace = v7,
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
		v16["4_RightText"] = v24
		return createElement(v9 and "TextButton" or "Frame", v12, v16)
	else
		local createElement = React.createElement
		local tag = React.Tag
		local v12 = if props.testId then `data-testid={props.testId}` else nil
		return createElement("TextLabel", {
			[tag] = v12,
			Position = position,
			AnchorPoint = anchorPoint,
			AutomaticSize = automaticSize or Enum.AutomaticSize.X,
			Size = size or UDim2.new(0, 0, 0, v8),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = layoutOrder,
			ZIndex = zIndex,
			Text = props.leftText or "",
			Font = font,
			FontFace = v7,
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
