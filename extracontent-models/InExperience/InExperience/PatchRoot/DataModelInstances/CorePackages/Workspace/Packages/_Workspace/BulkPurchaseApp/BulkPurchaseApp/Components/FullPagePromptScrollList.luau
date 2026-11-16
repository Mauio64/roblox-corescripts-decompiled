local parent = script:FindFirstAncestor("BulkPurchaseApp").Parent
local React = require(parent.React)
local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens
local UIBlox = require(parent.UIBlox)

local useCursor = UIBlox.App.SelectionCursor.useCursor

local function FullPagePromptScrollList(props)
	local v = useDesignTokens()
	local selectionImageObject = useCursor(UDim.new(0, v.Radius.Small), v.Size.Size_200)
	local size_350 = v.Size.Size_350
	local selectable, v2 = React.useBinding(false)

	return React.createElement("ScrollingFrame", {
		LayoutOrder = props.LayoutOrder,
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Size = props.size,
		ScrollBarThickness = v.Size.Size_100,
		ScrollBarImageColor3 = v.Color.Shift.Shift_400.Color3,
		ScrollBarImageTransparency = v.Color.Shift.Shift_400.Transparency,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.new(1, -size_350, 0, 0),
		SelectionImageObject = selectionImageObject,
		Selectable = selectable,
		[React.Change.AbsoluteCanvasSize] = function(p)
			v2(p.AbsoluteCanvasSize.Y > p.AbsoluteWindowSize.Y)
		end
	}, React.createElement("UIPadding", { PaddingRight = UDim.new(0, size_350) }), React.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		Padding = UDim.new(0, v.Size.Size_600)
	}), props.children)
end

return FullPagePromptScrollList
