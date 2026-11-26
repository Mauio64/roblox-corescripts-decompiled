local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/ego")
local useSheetNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/FoundationFork/Sheet/useSheetNavigation")

local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle

local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")
local formFactor = require("@luauforge/bundled/dGN").Enums.FormFactor
local module4 = require("@luauforge/bundled/hPA")

game:DefineFastInt("AutomaticSizingListPickerHotfix", 0)

local extended = module.PureComponent:extend("ListPicker")

extended.defaultProps = {
	itemHeight = 54,
	maxHeight = 10000,
	visibleItem = 5.58,
	Selectable = false
}

function extended:init()
	function self.onCanvasSizeChanged(p2)
		local offset = p2.CanvasSize.Y.Offset
		local maxHeight = self.props.maxHeight
		local formFactor2 = self.props.formFactor
		local itemHeight = self.props.itemHeight
		local screenHeight = self.props.screenHeight
		local visibleItem = self.props.visibleItem
		local v5

		if formFactor2 == formFactor.COMPACT then
			v5 = math.min(maxHeight, visibleItem * itemHeight)
		else
			v5 = math.min(maxHeight, screenHeight * 0.5)
		end

		if offset <= v5 then
			self:setState({ scrollingEnabled = false, canvasSizeYOffset = offset })
		else
			self:setState({ scrollingEnabled = true, canvasSizeYOffset = v5 })
		end
	end

	self:setState({ scrollingEnabled = false, canvasSizeYOffset = 0 })
end

function extended.render(props)
	local items = props.props.items
	local layoutOrder = props.props.layoutOrder
	local width = props.props.width
	local canvasSizeYOffset = props.state.canvasSizeYOffset
	local scrollingEnabled = props.state.scrollingEnabled
	local udim = UDim2.fromOffset(width, canvasSizeYOffset)

	local children = {}
	children.Layout = module.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder
	})

	for i, item in ipairs(items) do
		children[i] = module.createElement(module4, {
			item = item,
			layoutOrder = i,
			separatorEnabled = i < #items
		})
	end

	return withStyle(function(p2)
		return module.createElement(FitChildren.FitScrollingFrame, {
			BorderSizePixel = 0,
			BackgroundColor3 = p2.Theme.BackgroundUIDefault.Color,
			BackgroundTransparency = p2.Theme.BackgroundUIDefault.Transparency,
			LayoutOrder = layoutOrder,
			ScrollBarThickness = 0,
			Size = udim,
			ScrollingEnabled = scrollingEnabled,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			fitFields = { CanvasSize = FitChildren.FitAxis.Height },
			[module.Change.CanvasSize] = props.onCanvasSizeChanged,
			Selectable = props.props.Selectable
		}, children)
	end)
end

return (useSheetNavigation.connect(function(p2, p3)
	return {
		formFactor = p2.FormFactor,
		screenWidth = p2.ScreenSize.X,
		screenHeight = p2.ScreenSize.Y
	}
end)(extended))
