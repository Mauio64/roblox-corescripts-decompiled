local Parent = script:FindFirstAncestor("BulkPurchaseApp").Parent
local React = require(Parent.React)
local useDesignTokens = require(Parent.Style).useDesignTokens
local UIBlox = require(Parent.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(Parent.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local useCursor = UIBlox.App.SelectionCursor.useCursor

local function FullPagePromptScrollList(t1: {[any]: any}) -- line: 17
	-- upvalues: useDesignTokens (copy), useCursor (copy), FFlagRenameDeprecatedUIBloxTokens (copy), React (copy)
	local v9 = useDesignTokens()
	local v10 = useCursor(UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v9.Semantic.Radius.Small else v9.Radius.Small), if not FFlagRenameDeprecatedUIBloxTokens then v9.Global.Space_100 else v9.Size.Size_200)
	local v11 = if not FFlagRenameDeprecatedUIBloxTokens then v9.Global.Space_175 else v9.Size.Size_350
	local v12, v13 = React.useBinding(false)

	return React.createElement("ScrollingFrame", {
		LayoutOrder = t1.LayoutOrder,
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Size = t1.size,
		ScrollBarThickness = if not FFlagRenameDeprecatedUIBloxTokens then v9.Global.Size_50 else v9.Size.Size_100,
		ScrollBarImageColor3 = ((if not FFlagRenameDeprecatedUIBloxTokens then v9.Semantic.Color.Ui.Emphasis else v9.Color.Shift.Shift_400)).Color3,
		ScrollBarImageTransparency = ((if not FFlagRenameDeprecatedUIBloxTokens then v9.Semantic.Color.Ui.Emphasis else v9.Color.Shift.Shift_400)).Transparency,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.new(1, -v11, 0, 0),
		SelectionImageObject = v10,
		Selectable = v12,
		[React.Change.AbsoluteCanvasSize] = function(p1) -- line: 55
			-- upvalues: v13 (copy)
			v13(p1.AbsoluteCanvasSize.Y > p1.AbsoluteWindowSize.Y)
		end
	}, React.createElement("UIPadding", {
		PaddingRight = UDim.new(0, v11)
	}), React.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		Padding = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v9.Global.Space_300 else v9.Size.Size_600)
	}), t1.children)
end

return FullPagePromptScrollList
