local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(Modules.Common.Roact)
local RoactRodux = require(Modules.Common.RoactRodux)
local withStyle = require(CorePackages.Packages.UIBlox).Style.withStyle
local FitChildren = require(Modules.LuaApp.FitChildren)
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local ListPickerItem = require(Modules.LuaApp.Components.ListPickerItem)

game:DefineFastInt("AutomaticSizingListPickerHotfix", 0)

local v9 = Roact.PureComponent:extend("ListPicker")

v9.defaultProps = {
	itemHeight = 54,
	maxHeight = 10000,
	visibleItem = 5.58,
	Selectable = false
}

function v9.init(p1) -- line: 29
	-- upvalues: FormFactor (copy)
	function p1.onCanvasSizeChanged(p2) -- line: 30
		-- upvalues: p1 (copy), FormFactor (copy)
		local YOffset = p2.CanvasSize.Y.Offset
		local maxHeight = p1.props.maxHeight
		local formFactor = p1.props.formFactor
		local itemHeight = p1.props.itemHeight
		local screenHeight = p1.props.screenHeight
		local visibleItem = p1.props.visibleItem
		local v30 = if formFactor ~= FormFactor.COMPACT then math.min(maxHeight, screenHeight * 0.5) else math.min(maxHeight, visibleItem * itemHeight)

		if YOffset <= v30 then
			p1:setState({
				scrollingEnabled = false,
				canvasSizeYOffset = YOffset
			})

			return
		end

		p1:setState({
			scrollingEnabled = true,
			canvasSizeYOffset = v30
		})
	end

	p1:setState({
		scrollingEnabled = false,
		canvasSizeYOffset = 0
	})
end
function v9.render(p3) -- line: 63
	-- upvalues: Roact (copy), ListPickerItem (copy), withStyle (copy), FitChildren (copy)
	local items = p3.props.items
	local layoutOrder = p3.props.layoutOrder
	local width = p3.props.width
	local canvasSizeYOffset = p3.state.canvasSizeYOffset
	local scrollingEnabled = p3.state.scrollingEnabled
	local uDim2 = UDim2.fromOffset(width, canvasSizeYOffset)
	local t1 = {
		Layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		})
	}

	for i, v in ipairs(items) do
		t1[i] = Roact.createElement(ListPickerItem, {
			item = v,
			layoutOrder = i,
			separatorEnabled = i < #items
		})
	end

	return withStyle(function(p4) -- line: 87
		-- upvalues: Roact (copy), FitChildren (copy), layoutOrder (copy), uDim2 (copy), scrollingEnabled (copy), p3 (copy), t1 (copy)
		return Roact.createElement(FitChildren.FitScrollingFrame, {
			BorderSizePixel = 0,
			BackgroundColor3 = p4.Theme.BackgroundUIDefault.Color,
			BackgroundTransparency = p4.Theme.BackgroundUIDefault.Transparency,
			LayoutOrder = layoutOrder,
			ScrollBarThickness = 0,
			Size = uDim2,
			ScrollingEnabled = scrollingEnabled,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			fitFields = {
				CanvasSize = FitChildren.FitAxis.Height
			},
			[Roact.Change.CanvasSize] = p3.onCanvasSizeChanged,
			Selectable = p3.props.Selectable
		}, t1)
	end)
end

return (RoactRodux.connect(function(p5, _) -- line: 106
	return {
		formFactor = p5.FormFactor,
		screenWidth = p5.ScreenSize.X,
		screenHeight = p5.ScreenSize.Y
	}
end)(v9))
