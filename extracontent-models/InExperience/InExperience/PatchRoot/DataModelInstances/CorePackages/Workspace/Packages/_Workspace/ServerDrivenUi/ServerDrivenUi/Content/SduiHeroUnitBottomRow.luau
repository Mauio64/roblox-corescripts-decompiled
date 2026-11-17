local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")

local parent = ServerDrivenUi.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppAlignHeroUnitBottomRowCtaButton = SharedFlags.FFlagLuaAppAlignHeroUnitBottomRowCtaButton
local FFlagLuaAppHeroUnitSecondaryLabelText = require(ServerDrivenUi.FFlagLuaAppHeroUnitSecondaryLabelText)

local function SduiHeroUnitBottomRow(props)
	local layoutOrder = props.layoutOrder
	local zIndex = props.zIndex
	local position = props.position

	local v = useTokens()
	local v2

	if FFlagLuaAppHeroUnitSecondaryLabelText then
		v2 = v.Typography.CaptionSmall
	else
		v2 = v.Typography.BodySmall
	end

	local color3

	if FFlagLuaAppHeroUnitSecondaryLabelText then
		color3 = v.DarkMode.Content.Muted.Color3
	else
		color3 = v.Color.Extended.Gray.Gray_400.Color3
	end

	local fontSize, size_400, v3, fontFace, fontFace2

	if FFlagLuaAppHeroUnitSecondaryLabelText then
		fontSize = v2.FontSize
		size_400 = v.Size.Size_400
		v3 = v.Size.Size_2500 * 3
		fontFace = React.useMemo(function()
			return (normalizeFontFace(v2.Font))
		end, { v2.Font })
		fontFace2 = React.useMemo(function()
			local v4 = fontFace
			return Font.new(v4.Family, Enum.FontWeight.SemiBold, v4.Style)
		end, { fontFace })
	else
		fontSize = nil
		size_400 = nil
		fontFace2 = nil
		fontFace = nil
		v3 = nil
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
				Size = UDim2.new(0, 0, 0, v2.FontSize * v2.LineHeight),
				BackgroundTransparency = 1,
				Text = props.labelText,
				TextSize = v2.FontSize,
				FontFace = normalizeFontFace(v2.Font),
				TextColor3 = color3,
				TextXAlignment = Enum.TextXAlignment.Right,
				TextTruncate = Enum.TextTruncate.SplitWord,
				AnchorPoint = Vector2.new(1, 1),
				Position = UDim2.new(1, 0, 1, 0)
			})
		end

		local labelText = props.labelText
		local secondaryLabelText = props.secondaryLabelText
		local textSize = fontSize
		local v4 = size_400
		local createElement = React.createElement
		local v5 = {
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(1, 1),
			Position = UDim2.new(1, 0, 1, 0)
		}
		local v6 = {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			MaturityLabel = 0,
			SecondaryLabel = 0
		}
		local maturityLabel

		if labelText and labelText ~= "" then
			maturityLabel = React.createElement("TextLabel", {
				AutomaticSize = Enum.AutomaticSize.X,
				Size = UDim2.new(0, 0, 0, v2.FontSize * v2.LineHeight),
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Text = labelText,
				TextSize = v2.FontSize,
				FontFace = fontFace2,
				TextColor3 = color3,
				TextXAlignment = Enum.TextXAlignment.Right,
				TextTruncate = Enum.TextTruncate.SplitWord
			})
		end

		v6.MaturityLabel = maturityLabel
		local secondaryLabel

		if secondaryLabelText and secondaryLabelText ~= "" then
			secondaryLabel = React.createElement("TextLabel", {
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, v4),
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Text = secondaryLabelText,
				TextSize = textSize,
				LineHeight = v2.LineHeight,
				FontFace = fontFace,
				TextColor3 = color3,
				TextXAlignment = Enum.TextXAlignment.Right,
				TextWrapped = true,
				TextTruncate = Enum.TextTruncate.SplitWord
			}, {
				UISizeConstraint = React.createElement("UISizeConstraint", {
					MaxSize = Vector2.new(v3, (math.max(v4, textSize * v2.LineHeight * 2)))
				})
			})
		end

		v6.SecondaryLabel = secondaryLabel
		return createElement("Frame", v5, v6)
	end

	local rightLabelContent = props.rightLabelContent
	local labelText = props.labelText
	local secondaryLabelText

	if FFlagLuaAppHeroUnitSecondaryLabelText then
		secondaryLabelText = props.secondaryLabelText
	end

	local v4

	if FFlagLuaAppHeroUnitSecondaryLabelText then
		v4 = fontSize
	end

	local v5

	if FFlagLuaAppHeroUnitSecondaryLabelText then
		v5 = size_400
	end

	local v6

	if FFlagLuaAppHeroUnitSecondaryLabelText then
		v6 = v3
	end

	local v7

	if FFlagLuaAppHeroUnitSecondaryLabelText then
		v7 = fontFace
	end

	local v8

	if FFlagLuaAppHeroUnitSecondaryLabelText then
		v8 = fontFace2
	end

	local label = useMemo(fn, {
		rightLabelContent,
		labelText,
		v2,
		color3,
		secondaryLabelText,
		v4,
		v5,
		v6,
		v7,
		v8
	})

	local createElement = React.createElement
	local v9 = {
		["Size"] = UDim2.new(1, 0, 0, v.Size.Size_1000),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = layoutOrder,
		ZIndex = zIndex,
		Position = position
	}

	local tag = React.Tag
	local v10

	if props.testId then
		v10 = `data-testid={props.testId}`
	end

	v9[tag] = v10

	local createElement2 = React.createElement
	local v11 = {
		FillDirection = Enum.FillDirection.Horizontal,
		VerticalAlignment = Enum.VerticalAlignment.Bottom,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		SortOrder = Enum.SortOrder.LayoutOrder,
		ItemLineAlignment = 0
	}
	local itemLineAlignment

	if FFlagLuaAppAlignHeroUnitBottomRowCtaButton then
		itemLineAlignment = Enum.ItemLineAlignment.Automatic
	else
		itemLineAlignment = Enum.ItemLineAlignment.Center
	end

	v11.ItemLineAlignment = itemLineAlignment
	local children = {
		UIListLayout = createElement2("UIListLayout", v11),
		CTAButtonContainer = 0,
		LabelContainer = 0
	}
	local ctaButtonContainer

	if FFlagLuaAppAlignHeroUnitBottomRowCtaButton then
		ctaButtonContainer = props.ctaButton
	else
		ctaButtonContainer = React.createElement(
			"Frame",
			{
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 1
			},
			{ ButtonContent = props.ctaButton }
		)
	end

	children.CTAButtonContainer = ctaButtonContainer

	children.LabelContainer = React.createElement(
		"Frame",
		{
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0)
		},
		{
			UIFlexItem = React.createElement("UIFlexItem", { FlexMode = Enum.UIFlexMode.Fill }),
			Label = label
		}
	)
	return createElement("Frame", v9, children)
end

return React.memo(SduiHeroUnitBottomRow)
