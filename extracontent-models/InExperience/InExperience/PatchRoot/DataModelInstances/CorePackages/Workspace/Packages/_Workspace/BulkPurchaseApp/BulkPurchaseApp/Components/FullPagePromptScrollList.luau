local Parent = script:FindFirstAncestor("BulkPurchaseApp").Parent
local React = require(Parent.React)
local useDesignTokens = require(Parent.Style).useDesignTokens
local useCursor = require(Parent.UIBlox).App.SelectionCursor.useCursor

local function FullPagePromptScrollList(t1: {[any]: any}) -- line: 15
	-- upvalues: useDesignTokens (copy), useCursor (copy), React (copy)
	local v7 = useDesignTokens()
	local v8 = useCursor(UDim.new(0, v7.Radius.Small), v7.Size.Size_200)
	local Size_350 = v7.Size.Size_350
	local v10, v11 = React.useBinding(false)

	return React.createElement("ScrollingFrame", {
		LayoutOrder = t1.LayoutOrder,
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Size = t1.size,
		ScrollBarThickness = v7.Size.Size_100,
		ScrollBarImageColor3 = v7.Color.Shift.Shift_400.Color3,
		ScrollBarImageTransparency = v7.Color.Shift.Shift_400.Transparency,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.new(1, -Size_350, 0, 0),
		SelectionImageObject = v8,
		Selectable = v10,
		[React.Change.AbsoluteCanvasSize] = function(p1) -- line: 35
			-- upvalues: v11 (copy)
			v11(p1.AbsoluteCanvasSize.Y > p1.AbsoluteWindowSize.Y)
		end
	}, React.createElement("UIPadding", {
		PaddingRight = UDim.new(0, Size_350)
	}), React.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		Padding = UDim.new(0, v7.Size.Size_600)
	}), t1.children)
end

return FullPagePromptScrollList
