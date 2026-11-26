local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Foundation")
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local fFlagLuaAppAlignHeroUnitBottomRowCtaButton = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppAlignHeroUnitBottomRowCtaButton
local FFlagLuaAppHeroUnitSecondaryLabelText = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/FFlagLuaAppHeroUnitSecondaryLabelText")

local function SduiHeroUnitBottomRow(props)
	local layoutOrder = props.layoutOrder
	local zIndex = props.zIndex
	local position = props.position

	local v5 = useTokens()

	local v6 = if FFlagLuaAppHeroUnitSecondaryLabelText then v5.Typography.CaptionSmall else v5.Typography.BodySmall
	local color3

	if FFlagLuaAppHeroUnitSecondaryLabelText then
		color3 = v5.DarkMode.Content.Muted.Color3
	else
		color3 = v5.Color.Extended.Gray.Gray_400.Color3
	end

	local fontSize, size_400, v7, v8, v9

	if FFlagLuaAppHeroUnitSecondaryLabelText then
		fontSize = v6.FontSize
		size_400 = v5.Size.Size_400
		v7 = v5.Size.Size_2500 * 3
		v8 = React.useMemo(function()
			return normalizeFontFace(v6.Font)
		end, { v6.Font })
		v9 = React.useMemo(function()
			local v10 = v8
			return Font.new(v10.Family, Enum.FontWeight.SemiBold, v10.Style)
		end, { v8 })
	else
		fontSize = nil
		size_400 = nil
		v9 = nil
		v8 = nil
		v7 = nil
	end

	local useMemo = React.useMemo
	local function fn()
		if props.rightLabelContent then
			return React.createElement("Frame", {
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				AnchorPoint = Vector2.new(1, 1),
				Position = UDim2.new(1, 0, 1, 0)
			}, { Content = props.rightLabelContent })
		end

		if
			(not props.labelText or props.labelText == "")
			and (not FFlagLuaAppHeroUnitSecondaryLabelText or not props.secondaryLabelText or props.secondaryLabelText == "")
		then
			return nil
		end

		if not FFlagLuaAppHeroUnitSecondaryLabelText then
			return React.createElement("TextLabel", {
				AutomaticSize = Enum.AutomaticSize.X,
				Size = UDim2.new(0, 0, 0, v6.FontSize * v6.LineHeight),
				BackgroundTransparency = 1,
				Text = props.labelText,
				TextSize = v6.FontSize,
				FontFace = normalizeFontFace(v6.Font),
				TextColor3 = color3,
				TextXAlignment = Enum.TextXAlignment.Right,
				TextTruncate = Enum.TextTruncate.SplitWord,
				AnchorPoint = Vector2.new(1, 1),
				Position = UDim2.new(1, 0, 1, 0)
			})
		end

		local labelText = props.labelText
		local secondaryLabelText = props.secondaryLabelText
		local v10 = fontSize
		local v11 = size_400
		local createElement = React.createElement
		local v13 = {
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(1, 1),
			Position = UDim2.new(1, 0, 1, 0)
		}
		local v14 = {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			MaturityLabel = 0,
			SecondaryLabel = 0
		}

		local v15 = if labelText and labelText ~= "" then React.createElement("TextLabel", {
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(0, 0, 0, v6.FontSize * v6.LineHeight),
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Text = labelText,
			TextSize = v6.FontSize,
			FontFace = v9,
			TextColor3 = color3,
			TextXAlignment = Enum.TextXAlignment.Right,
			TextTruncate = Enum.TextTruncate.SplitWord
		}) else nil
		v14.MaturityLabel = v15

		local v16 = if secondaryLabelText and secondaryLabelText ~= "" then React.createElement("TextLabel", {
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, v11),
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Text = secondaryLabelText,
			TextSize = v10,
			LineHeight = v6.LineHeight,
			FontFace = v8,
			TextColor3 = color3,
			TextXAlignment = Enum.TextXAlignment.Right,
			TextWrapped = true,
			TextTruncate = Enum.TextTruncate.SplitWord
		}, {
			UISizeConstraint = React.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(v7, (math.max(v11, v10 * v6.LineHeight * 2)))
			})
		}) else nil
		v14.SecondaryLabel = v16
		return createElement("Frame", v13, v14)
	end

	local rightLabelContent = props.rightLabelContent
	local labelText = props.labelText

	local secondaryLabelText = if FFlagLuaAppHeroUnitSecondaryLabelText then props.secondaryLabelText else nil
	local v11 = if FFlagLuaAppHeroUnitSecondaryLabelText then fontSize else nil
	local v12 = if FFlagLuaAppHeroUnitSecondaryLabelText then size_400 else nil
	local v13 = if FFlagLuaAppHeroUnitSecondaryLabelText then v7 else nil
	local v14 = if FFlagLuaAppHeroUnitSecondaryLabelText then v8 else nil
	local v16 = useMemo(fn, {
		rightLabelContent,
		labelText,
		v6,
		color3,
		secondaryLabelText,
		v11,
		v12,
		v13,
		v14,
		if FFlagLuaAppHeroUnitSecondaryLabelText then v9 else nil
	})

	local createElement = React.createElement
	local v18 = {
		["Size"] = UDim2.new(1, 0, 0, v5.Size.Size_1000),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = layoutOrder,
		ZIndex = zIndex,
		Position = position
	}

	local tag = React.Tag
	local v19 = if props.testId then `data-testid={props.testId}` else nil
	v18[tag] = v19

	local createElement2 = React.createElement
	local v21 = {
		FillDirection = Enum.FillDirection.Horizontal,
		VerticalAlignment = Enum.VerticalAlignment.Bottom,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		SortOrder = Enum.SortOrder.LayoutOrder,
		ItemLineAlignment = 0
	}

	local v22 = if fFlagLuaAppAlignHeroUnitBottomRowCtaButton then Enum.ItemLineAlignment.Automatic else Enum.ItemLineAlignment.Center
	v21.ItemLineAlignment = v22
	local children = {
		UIListLayout = createElement2("UIListLayout", v21),
		CTAButtonContainer = 0,
		LabelContainer = 0
	}

	local v23 = if fFlagLuaAppAlignHeroUnitBottomRowCtaButton then props.ctaButton else React.createElement(
		"Frame",
		{
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 1
		},
		{ ButtonContent = props.ctaButton }
	)
	children.CTAButtonContainer = v23

	children.LabelContainer = React.createElement(
		"Frame",
		{
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0)
		},
		{
			UIFlexItem = React.createElement("UIFlexItem", {
				FlexMode = Enum.UIFlexMode.Fill
			}),
			Label = v16
		}
	)
	return createElement("Frame", v18, children)
end

return React.memo(SduiHeroUnitBottomRow)
