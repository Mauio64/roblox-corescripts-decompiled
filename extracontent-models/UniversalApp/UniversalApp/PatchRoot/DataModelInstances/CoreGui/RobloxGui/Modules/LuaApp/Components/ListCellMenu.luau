local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(Modules.Common.Roact)
local RoactRodux = require(Modules.Common.RoactRodux)
local FitChildren = require(Modules.LuaApp.FitChildren)
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local ListCell = require(Modules.LuaApp.Components.ListCell)
local withTheme_DEPRECATED = require(Modules.LuaApp.withTheme_DEPRECATED)
local rect = Rect.new(8, 8, 9, 9)
local v10 = Roact.PureComponent:extend("ListCellMenu")

v10.defaultProps = {
	itemHeight = 66,
	maxHeight = 10000,
	visibleItem = 5.58
}

function v10.init(p1) -- line: 26
	-- upvalues: FormFactor (copy)
	function p1.onCanvasSizeChanged(p2) -- line: 27
		-- upvalues: p1 (copy), FormFactor (copy)
		local YOffset = p2.CanvasSize.Y.Offset
		local maxHeight = p1.props.maxHeight
		local formFactor = p1.props.formFactor
		local itemHeight = p1.props.itemHeight
		local screenHeight = p1.props.screenHeight
		local visibleItem = p1.props.visibleItem
		local v30 = if formFactor ~= FormFactor.COMPACT then math.min(maxHeight, screenHeight * 0.5) else math.min(maxHeight, visibleItem * itemHeight)

		if YOffset <= v30 then
			p2.ScrollingEnabled = false
		else
			p2.ScrollingEnabled = true
			YOffset = v30
		end

		p2.Size = UDim2.new(0, p1.props.width, 0, YOffset)
	end
end
function v10.render(p3) -- line: 52
	-- upvalues: Roact (copy), ListCell (copy), FitChildren (copy), rect (copy)
	local items = p3.props.items
	local layoutOrder = p3.props.layoutOrder
	local uDim2 = UDim2.new(0, p3.props.width, 0, 0)
	local ContextualMenu = p3.props.appTheme.ContextualMenu
	local t1 = {
		Layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		})
	}
	local n1 = 0

	for i, v in ipairs(items) do
		n1 += 1
		t1["Item_" .. i] = Roact.createElement(ListCell, {
			item = v,
			layoutOrder = n1
		})

		if i < #items then
			n1 += 1
			t1["Divider_" .. i] = Roact.createElement("Frame", {
				BackgroundTransparency = 0,
				BorderSizePixel = 0,
				BackgroundColor3 = ContextualMenu.Divider.Color,
				LayoutOrder = n1,
				Size = UDim2.new(1, 0, 0, 1)
			})
		end
	end

	return Roact.createElement(FitChildren.FitImageLabel, {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Image = "LuaApp/buttons/buttonFill",
		Position = UDim2.new(0.5, 0, 0, 0),
		AnchorPoint = Vector2.new(0.5, 0),
		ImageColor3 = ContextualMenu.Background.Color,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = rect,
		fitAxis = FitChildren.FitAxis.Both,
		LayoutOrder = layoutOrder
	}, {
		ScrollingFrame = Roact.createElement(FitChildren.FitScrollingFrame, {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = 0,
			Size = uDim2,
			fitFields = {
				CanvasSize = FitChildren.FitAxis.Height
			},
			[Roact.Change.CanvasSize] = p3.onCanvasSizeChanged
		}, t1)
	})
end

return (withTheme_DEPRECATED((RoactRodux.connect(function(p4, _) -- line: 110
	return {
		formFactor = p4.FormFactor,
		screenWidth = p4.ScreenSize.X,
		screenHeight = p4.ScreenSize.Y
	}
end)(v10))))
