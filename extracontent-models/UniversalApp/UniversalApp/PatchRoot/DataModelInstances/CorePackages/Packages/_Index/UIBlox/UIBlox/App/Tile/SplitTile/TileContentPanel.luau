local ParentParent = script.Parent.Parent.Parent.Parent
local Core = ParentParent.Core
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local useStyle = require(Core.Style.useStyle)
local useTextSizeOffset = require(ParentParent.Core.Style.useTextSizeOffset)

require(ParentParent.App.Style.Fonts)
require(ParentParent.App.Style.StyleTypes)

local setDefault = require(ParentParent.Utility.setDefault)

local function TileContentPanel(t1: {[any]: any}) -- line: 44
	-- upvalues: useStyle (copy), useTextSizeOffset (copy), setDefault (copy), React (copy)
	local v10 = useStyle()
	local Settings = v10.Settings
	local v12 = useTextSizeOffset()
	local v13 = not Settings.ReducedMotion and 8 or 6
	local contentTitle = t1.contentTitle
	local contentFooter = t1.contentFooter
	local v16 = setDefault(t1.textLineCount, 2)
	local v17 = setDefault(t1.hasSidePadding, true)
	local v18, v19, v20, v21

	if t1.outerPadding == nil or type(t1.outerPadding) == "number" then
		v18 = setDefault(t1.outerPadding, v13)
		v19 = v18
		v20 = v18
		v21 = v18
	else
		v18 = setDefault(t1.outerPadding.Left, v13)
		v19 = setDefault(t1.outerPadding.Right, v13)
		v20 = setDefault(t1.outerPadding.Top, v13)
		v21 = setDefault(t1.outerPadding.Bottom, v13)
	end

	local v22 = setDefault(t1.titlePadding, v13)
	local panelHeight = t1.panelHeight
	local footerHeight = t1.footerHeight
	local Font = v10.Font
	local v26 = setDefault(t1.titleFont, Font.Header2)
	local Theme = v10.Theme
	local v28 = (Font.BaseSize + v12) * v26.RelativeSize * v16
	local TextEmphasis = Theme.TextEmphasis

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(UDim.new(1, 0), panelHeight)
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v22)
		}),
		Padding = React.createElement("UIPadding", {
			PaddingLeft = if not v17 then nil else UDim.new(0, v18),
			PaddingRight = if not v17 then nil else UDim.new(0, v19),
			PaddingTop = UDim.new(0, v20),
			PaddingBottom = UDim.new(0, v21)
		}),
		TitleText = if not (v16 > 0) or (not contentTitle or not (string.len(contentTitle) > 0)) then nil else React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			TextWrapped = true,
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = contentTitle,
			Font = v26.Font,
			TextSize = Font.BaseSize * v26.RelativeSize,
			TextTransparency = TextEmphasis.Transparency,
			TextColor3 = TextEmphasis.Color,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top
		}, {
			UISizeConstraint = React.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(1e999, v28)
			})
		}),
		ContentFooter = if not contentFooter then nil else React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 2,
			Size = UDim2.new(UDim.new(1, 0), footerHeight)
		}, { contentFooter })
	})
end

return TileContentPanel
