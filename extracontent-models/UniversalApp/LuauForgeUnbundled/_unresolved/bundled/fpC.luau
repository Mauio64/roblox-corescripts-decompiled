local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
local Cryo = require(CorePackages.Packages.Cryo)
local UIBlox = require(CorePackages.Packages.UIBlox)
local cursorKind = UIBlox.App.SelectionImage.CursorKind
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local withStyle = UIBlox.Style.withStyle

local searchConstants = require("@luauforge/bundled/dpZ").Modules.Personalization.Search.SearchConstants

local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")
local module2 = require("@luauforge/bundled/fpD")

local extended = Roact.PureComponent:extend("SearchBarListPicker")

local SEARCH_MARGIN = searchConstants.SEARCH_MARGIN

extended.validateProps = t.strictInterface({
	items = t.array(t.any),
	width = t.UDim,
	height = t.optional(t.UDim),
	layoutOrder = t.optional(t.integer),
	forwardRef = t.optional(t.table),
	BackgroundTransparency = t.optional(t.number),
	removeAdditionalMargins = t.optional(t.boolean),
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	formFactor = t.optional(t.string),
	screenHeight = t.optional(t.integer),
	topBarHeight = t.optional(t.number),
	globalGuiInset = t.optional(t.table)
})

function extended:init()
	self.focusableRefs = RoactGamepad.createRefCache()
end

function extended:renderWithProviders(callback)
	local items = self.props.items
	local layoutOrder = self.props.layoutOrder

	local screenHeight = self.props.screenHeight
	local topBarHeight = self.props.topBarHeight
	local globalGuiInset = self.props.globalGuiInset
	local height = self.props.height
	local udim

	if height then
		udim = UDim2.new(self.props.width.Scale, self.props.width.Offset, height.Scale, height.Offset)
	else
		udim = UDim2.new(
			self.props.width.Scale,
			self.props.width.Offset,
			0,
			screenHeight - globalGuiInset.top - topBarHeight - globalGuiInset.bottom
		)
	end

	local children = {}
	children.Layout = Roact.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder
	})

	children.TopPadding = Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 5),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = 0
	})

	local function getAdjacentIndexRef(p3, p4)
		local v5 = p3 + p4

		if v5 < 1 then
			return self.props.NextSelectionUp
		end

		if #items < v5 then
			return self.props.NextSelectionDown or self.focusableRefs[p3]
		end

		return self.focusableRefs[v5]
	end

	local function getItemIndexRef(p3)
		return p3 >= 1 and p3 <= #items and self.focusableRefs[p3] or nil
	end

	local forwardRef = self.props.forwardRef

	if #self.props.items > 0 then
		self.focusableRefs[1] = forwardRef
	end

	for i, item in ipairs(items) do
		local createElement = Roact.createElement
		local v5 = focusable[module2]
		local v6 = {
			["item"] = nil,
			["item"] = nil,
			["item"] = nil,
			["item"] = nil,
			["item"] = nil,
			["item"] = nil,
			item = item,
			layoutOrder = i,
			separatorEnabled = i < #items
		}
		local v7 = i + -1
		local v8

		if v7 < 1 then
			v8 = self.props.NextSelectionUp
		elseif #items < v7 then
			v8 = self.props.NextSelectionDown or self.focusableRefs[i]
		else
			v8 = self.focusableRefs[v7]
		end

		v6.NextSelectionUp = v8
		local v9 = i + 1
		local v10

		if v9 < 1 then
			v10 = self.props.NextSelectionUp
		elseif #items < v9 then
			v10 = self.props.NextSelectionDown or self.focusableRefs[i]
		else
			v10 = self.focusableRefs[v9]
		end

		v6.NextSelectionDown = v10
		v6.NextSelectionRight = self.props.NextSelectionRight
		v6.NextSelectionLeft = self.props.NextSelectionLeft
		v6.SelectionImageObject = callback(cursorKind.RoundedRectNoInset)
		local ref = Roact.Ref
		local v11 = i >= 1 and i <= #items
		local v12 = if v11 then self.focusableRefs[i] or nil else nil

		v6[ref] = v12
		children[i] = createElement(v5, v6)
	end

	return withStyle(function(p3)
		local backgroundTransparency = self.props.BackgroundTransparency
			or p3.Theme.BackgroundDefault.Transparency
		local v5

		if self.props.removeAdditionalMargins then
			v5 = udim
		else
			v5 = udim + UDim2.fromOffset(SEARCH_MARGIN * 2, 0)
		end

		local v6

		if self.props.removeAdditionalMargins then
			v6 = UDim2.new(1, 0, 1, 0)
		else
			v6 = udim - UDim2.new(0, SEARCH_MARGIN * 2, 0, 0)
		end

		return Roact.createElement(focusable.Frame, {
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.fromScale(0.5, 0),
			Size = v5,
			BackgroundColor3 = p3.Theme.BackgroundDefault.Color,
			BackgroundTransparency = backgroundTransparency,
			BorderSizePixel = 0,
			LayoutOrder = layoutOrder,
			SelectionGroup = true,
			SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
			SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
			SelectionBehaviorRight = Enum.SelectionBehavior.Stop
		}, {
			list = Roact.createElement(FitChildren.FitScrollingFrame, {
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.fromScale(0.5, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = p3.Theme.BackgroundDefault.Color,
				BackgroundTransparency = backgroundTransparency,
				LayoutOrder = layoutOrder,
				ScrollBarThickness = 0,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				ElasticBehavior = Enum.ElasticBehavior.Always,
				Size = v6,
				fitFields = { CanvasSize = FitChildren.FitAxis.Height },
				Selectable = false
			}, children)
		})
	end)
end

function extended:render()
	return withSelectionCursorProvider(function(p2)
		return self:renderWithProviders(p2)
	end)
end

local v5 = RoactRodux.connect(function(data, p2)
	return {
		formFactor = data.FormFactor,
		screenHeight = data.ScreenSize.Y,
		topBarHeight = data.TopBar.topBarHeight,
		globalGuiInset = data.GlobalGuiInset
	}
end)(extended)

return Roact.forwardRef(function(p2, p3)
	return Roact.createElement(v5, Cryo.Dictionary.join(p2, { forwardRef = p3 }))
end)
