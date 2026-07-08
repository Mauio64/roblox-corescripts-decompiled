local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local UIBlox = require(ParentParentParent.UIBlox)
local FormatStatString = require(ParentParent.Common.FormatStatString)
local useStyle = UIBlox.Core.Style.useStyle
local useLayoutValues = require(ParentParent.Common.useLayoutValues)
local FFlagRemoveNewPlayerListOverlay = require(ParentParent.Flags.FFlagRemoveNewPlayerListOverlay)
local FFlagEnableMobilePlayerListOnConsole = require(ParentParent.Flags.FFlagEnableMobilePlayerListOnConsole)

return React.memo(function(t1: {[any]: any}) -- line: 36
	-- upvalues: useStyle (copy), useLayoutValues (copy), FFlagEnableMobilePlayerListOnConsole (copy), React (copy), FormatStatString (copy), FFlagRemoveNewPlayerListOverlay (copy)
	local v11 = useStyle()
	local v12 = useLayoutValues()
	local TextDefault = v11.Theme.TextDefault
	local textStyle = t1.textStyle
	local v15 = if not textStyle then TextDefault.Color else textStyle.Color
	local v16 = if not textStyle then TextDefault.Transparency else textStyle.Transparency
	local v17 = if not textStyle then nil else textStyle.StrokeColor
	local v18 = if not textStyle or not textStyle.StrokeTransparency then nil else textStyle.StrokeTransparency
	local CaptionHeaderFont, u20

	if not v12.IsTenFoot then
		CaptionHeaderFont = v11.Font.CaptionHeader.Font
		u20 = if not FFlagEnableMobilePlayerListOnConsole then v11.Font.CaptionHeader.RelativeSize * v11.Font.BaseSize else v12.StatTextSize
	else
		u20 = v12.StatTextSize
		CaptionHeaderFont = v12.StatFont

		if t1.isTeamEntry then
			CaptionHeaderFont = v12.TeamStatFont
		end
	end

	local v21 = React.useMemo(function() -- line: 63
		-- upvalues: t1 (copy), FormatStatString (copy), CaptionHeaderFont (ref), u20 (ref), v15 (copy), v16 (copy), v17 (copy), v18 (copy)
		return {
			BackgroundTransparency = 1,
			Text = t1.statValue:map(function(p1) -- line: 65
				-- upvalues: FormatStatString (copy)
				return FormatStatString(p1)
			end),
			Size = t1.showStatTitle and UDim2.fromScale(1, 0.5) or UDim2.fromScale(1, 1),
			Position = t1.showStatTitle and UDim2.fromScale(0, 0.5) or UDim2.fromScale(0, 0),
			Font = CaptionHeaderFont,
			TextSize = u20,
			TextColor3 = v15,
			TextTransparency = v16,
			TextStrokeColor3 = v17,
			TextStrokeTransparency = v18,
			TextTruncate = Enum.TextTruncate.AtEnd
		}
	end, {
		t1.showStatTitle,
		CaptionHeaderFont,
		u20,
		v15,
		v16,
		v17,
		v18
	})

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		Size = UDim2.new(0, v12.StatEntrySizeX, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		LayoutOrder = t1.layoutOrder,
		BackgroundTransparency = not t1.backgroundStyle and 1 or t1.backgroundStyle.Transparency,
		BackgroundColor3 = if not t1.backgroundStyle then nil else t1.backgroundStyle.Color
	}, {
		PlayerStatDisplay = if not t1.showStatTitle or not t1.statName then React.createElement("TextLabel", v21) else React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			StatTitle = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				Text = t1.statName,
				Size = UDim2.fromScale(1, 0.5),
				Position = UDim2.fromScale(0, 0),
				Font = v12.TitleStatFont,
				TextSize = u20,
				TextColor3 = v15,
				TextTransparency = v16,
				TextStrokeColor3 = v17,
				TextStrokeTransparency = v18,
				TextTruncate = Enum.TextTruncate.AtEnd
			}),
			StatText = React.createElement("TextLabel", v21)
		}),
		DoubleOverLay = if FFlagRemoveNewPlayerListOverlay or (not t1.doubleOverlay or not t1.overlayStyle) then nil else React.createElement("Frame", {
			ZIndex = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = t1.overlayStyle.Transparency,
			BackgroundColor3 = t1.overlayStyle.Color
		}),
		OverlayFrame = if FFlagRemoveNewPlayerListOverlay or not t1.overlayStyle then nil else React.createElement("Frame", {
			ZIndex = 2,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = t1.overlayStyle.Transparency,
			BackgroundColor3 = t1.overlayStyle.Color
		})
	})
end)
