local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local UIBlox = require(parent2.UIBlox)
local Foundation = require(parent2.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local useTokens = Foundation.Hooks.useTokens
local SharedFlags = require(parent2.SharedFlags)
local FFlagFontFacePlayerList = SharedFlags.FFlagFontFacePlayerList
local FormatStatString = require(parent.Common.FormatStatString)
local useStyle = UIBlox.Core.Style.useStyle
local useLayoutValues = require(parent.Common.useLayoutValues)

local FFlagRemoveNewPlayerListOverlay = require(parent.Flags.FFlagRemoveNewPlayerListOverlay)
local FFlagEnableMobilePlayerListOnConsole = require(parent.Flags.FFlagEnableMobilePlayerListOnConsole)

return React.memo(function(props)
	local v = useStyle()
	local v2 = useLayoutValues()
	local v3

	if FFlagFontFacePlayerList then
		v3 = useTokens()
	end

	local textDefault = v.Theme.TextDefault
	local textStyle = props.textStyle
	local color

	if textStyle then
		color = textStyle.Color
	else
		color = textDefault.Color
	end

	local transparency

	if textStyle then
		transparency = textStyle.Transparency
	else
		transparency = textDefault.Transparency
	end

	local strokeColor

	if textStyle then
		strokeColor = textStyle.StrokeColor
	else
		strokeColor = nil
	end

	local strokeTransparency

	if textStyle and textStyle.StrokeTransparency then
		strokeTransparency = textStyle.StrokeTransparency
	else
		strokeTransparency = nil
	end

	local textSize, v4

	if v2.IsTenFoot then
		textSize = v2.StatTextSize

		if FFlagFontFacePlayerList then
			v4 = normalizeFontFace(v2.StatFont)
		else
			v4 = v2.StatFont
		end

		if props.isTeamEntry then
			if FFlagFontFacePlayerList then
				v4 = normalizeFontFace(v2.TeamStatFont)
			else
				v4 = v2.TeamStatFont
			end
		end
	else
		if FFlagFontFacePlayerList then
			v4 = normalizeFontFace(v3.Typography.CaptionLarge.Font)
		else
			v4 = v.Font.CaptionHeader.Font
		end

		if FFlagEnableMobilePlayerListOnConsole then
			textSize = v2.StatTextSize
		else
			textSize = v.Font.CaptionHeader.RelativeSize * v.Font.BaseSize
		end
	end

	local v5 = React.useMemo(function()
		local v5 = {
			Text = props.statValue:map(function(p)
				return FormatStatString(p)
			end),
			Size = props.showStatTitle and UDim2.fromScale(1, 0.5) or UDim2.fromScale(1, 1),
			Position = props.showStatTitle and UDim2.fromScale(0, 0.5) or UDim2.fromScale(0, 0),
			Font = 0,
			FontFace = 0,
			TextSize = 0,
			TextColor3 = 0,
			TextTransparency = 0,
			TextStrokeColor3 = 0,
			TextStrokeTransparency = 0,
			TextTruncate = 0,
			BackgroundTransparency = 1
		}
		local font

		if not FFlagFontFacePlayerList then
			font = v4
		end

		v5.Font = font
		local fontFace

		if FFlagFontFacePlayerList then
			fontFace = v4
		end

		v5.FontFace = fontFace
		v5.TextSize = textSize
		v5.TextColor3 = color
		v5.TextTransparency = transparency
		v5.TextStrokeColor3 = strokeColor
		v5.TextStrokeTransparency = strokeTransparency
		v5.TextTruncate = Enum.TextTruncate.AtEnd
		return v5
	end, { props.showStatTitle, v4, textSize, color, transparency, strokeColor, strokeTransparency })

	local createElement = React.createElement
	local v6 = {
		Size = UDim2.new(0, v2.StatEntrySizeX, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		BorderSizePixel = 0,
		LayoutOrder = props.layoutOrder,
		BackgroundTransparency = not props.backgroundStyle and 1 or props.backgroundStyle.Transparency,
		BackgroundColor3 = 0
	}
	local backgroundColor

	if props.backgroundStyle then
		backgroundColor = props.backgroundStyle.Color
	end

	v6.BackgroundColor3 = backgroundColor
	local playerStatDisplay

	if props.showStatTitle and props.statName then
		local createElement2 = React.createElement
		local v7 = { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0 }

		local createElement3 = React.createElement
		local v8 = {
			Text = props.statName,
			Size = UDim2.fromScale(1, 0.5),
			Position = UDim2.fromScale(0, 0),
			Font = 0,
			FontFace = 0,
			TextSize = 0,
			TextColor3 = 0,
			TextTransparency = 0,
			TextStrokeColor3 = 0,
			TextStrokeTransparency = 0,
			TextTruncate = 0,
			BackgroundTransparency = 1
		}
		local font

		if not FFlagFontFacePlayerList then
			font = v2.TitleStatFont
		end

		v8.Font = font
		local fontFace

		if FFlagFontFacePlayerList then
			fontFace = normalizeFontFace(v2.TitleStatFont)
		end

		v8.FontFace = fontFace
		v8.TextSize = textSize
		v8.TextColor3 = color
		v8.TextTransparency = transparency
		v8.TextStrokeColor3 = strokeColor
		v8.TextStrokeTransparency = strokeTransparency
		v8.TextTruncate = Enum.TextTruncate.AtEnd
		playerStatDisplay = createElement2("Frame", v7, {
			StatTitle = createElement3("TextLabel", v8),
			StatText = React.createElement("TextLabel", v5)
		})
	else
		playerStatDisplay = React.createElement("TextLabel", v5)
	end

	local doubleOverLay

	if not (FFlagRemoveNewPlayerListOverlay or not (props.doubleOverlay and props.overlayStyle)) then
		doubleOverLay = React.createElement("Frame", {
			ZIndex = 1,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = props.overlayStyle.Transparency,
			BackgroundColor3 = props.overlayStyle.Color,
			BorderSizePixel = 0
		})
	end

	local overlayFrame

	if not (FFlagRemoveNewPlayerListOverlay or not props.overlayStyle) then
		overlayFrame = React.createElement("Frame", {
			ZIndex = 2,
			Size = UDim2.new(1, 0, 1, 0),
			BorderSizePixel = 0,
			BackgroundTransparency = props.overlayStyle.Transparency,
			BackgroundColor3 = props.overlayStyle.Color
		})
	end

	return createElement("Frame", v6, {
		PlayerStatDisplay = playerStatDisplay,
		DoubleOverLay = doubleOverLay,
		OverlayFrame = overlayFrame
	})
end)
