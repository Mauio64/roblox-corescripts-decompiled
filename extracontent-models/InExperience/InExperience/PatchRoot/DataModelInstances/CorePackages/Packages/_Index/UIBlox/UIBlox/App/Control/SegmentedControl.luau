local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local core = parent.Core

local Roact = require(parent2.Roact)
local t = require(parent2.t)
local Cryo = require(parent2.Cryo)
local withStyle = require(parent.Core.Style.withStyle)
local Otter = require(parent2.Otter)
local Images = require(parent.App.ImageSet.Images)

local RoactGamepad = require(parent2.RoactGamepad)

local ControlState = require(core.Control.Enum.ControlState)
local SegmentedControlTabName = require(script.Parent.SegmentedControlTabName)
local ImageSetComponent = require(core.ImageSet.ImageSetComponent)
local getContentStyle = require(core.Button.getContentStyle)
local getIconSize = require(parent.App.ImageSet.getIconSize)
local IconSize = require(parent.App.ImageSet.Enum.IconSize)
local GetTextSize = require(parent.Core.Text.GetTextSize)
local GetFontFromFontStyle = require(parent.Core.Text.GetFontFromFontStyle)

local iconSize = getIconSize(IconSize.Medium)
local v = { frequency = 10, dampingRatio = 1 }

local component_assetscircle_17 = Images["component_assets/circle_17"]
local v2 = { [ControlState.Default] = "BackgroundUIDefault" }

local v3 = { [ControlState.Default] = "Divider" }

local v4 = { [ControlState.Default] = "UIEmphasis" }

local iconStateColorMap = {
	[ControlState.Default] = "SecondaryDefault",
	[ControlState.Hover] = "SecondaryOnHover"
}

local extended = Roact.Component:extend("SegmentedControl")
extended.validateProps = t.strictInterface({
	tabs = function(list)
		local v5, v6 = t.array(t.strictInterface({
			tabName = t.string,
			isDisabled = t.optional(t.boolean),
			icon = t.optional(t.table)
		}))(list)

		if not v5 then
			return v5, v6
		end

		local v7, v8 = t.numberMin(2)(#list)

		if not v7 then
			return v7, v8
		end

		local v9, v10 = t.numberMax(4)(#list)

		if v9 then
			return true
		end

		return v9, v10
	end,
	width = t.UDim,
	height = t.optional(t.number),
	maxWidth = t.optional(t.number),
	selectedTabIndex = t.number,
	onTabActivated = t.callback,
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	layoutOrder = t.optional(t.number)
})

extended.defaultProps = { height = 44 }

function extended:init()
	self.rootRef = Roact.createRef()
	self.tabRefs = RoactGamepad.createRefCache()

	local binding, setSelectedBackgroundPositionX = Roact.createBinding(0)
	self.selectedBackgroundPositionX = binding
	self.setSelectedBackgroundPositionX = setSelectedBackgroundPositionX
	self.selectedBackgroundMotor = Otter.createSingleMotor(4)
	self.selectedBackgroundMotor:onStep(function(p)
		self.setSelectedBackgroundPositionX(p)
	end)

	self:setState({ tabWidth = 0, computedMinFrameWidth = 0 })

	function self.onTabActivated(p)
		self.props.onTabActivated(p)
	end

	function self.setSize(p)
		local tabWidth = math.floor((math.max(p.AbsoluteSize.X, self.state.computedMinFrameWidth) - 8) / #self.props.tabs)
		self.selectedBackgroundMotor:setGoal(Otter.spring(4 + tabWidth * (self.props.selectedTabIndex - 1), v))

		self:setState({ tabWidth = tabWidth })
	end
end

function extended.render(object)
	return withStyle(function(p)
		local controlState = object.state.controlState
		local count = #object.props.tabs
		local v5

		if object.props.tabs[object.props.selectedTabIndex].isDisabled then
			v5 = ControlState.Disabled or controlState
		else
			v5 = controlState
		end

		local contentStyle = getContentStyle(v2, controlState, p)
		local contentStyle2 = getContentStyle(v3, controlState, p)

		local contentStyle3 = getContentStyle(v4, v5, p)
		local tabWidth = object.state.tabWidth
		local v6 = not object.props.icon and 0 or iconSize

		local height = object.props.height
		local v7 = object.props.height - 12
		local v8 = object.props.height - 16

		local v9 = p.Font.Header2.RelativeSize * p.Font.BaseSize

		if object.state.computedMinFrameWidth == 0 then
			local maxX = 0

			for i = 1, count do
				local tabName = object.props.tabs[i].tabName
				maxX = math.max(
					maxX,
					GetTextSize(tabName, v9, GetFontFromFontStyle(p.Font.Header2), Vector2.new(1e999, 1e999)).X
				)
			end

			local v10 = maxX + 8
			local v11 = (v6 + 80) * count + 8
			local v12 = (v6 + v10) * count + 8
			local computedMinFrameWidth

			if object.props.maxWidth then
				computedMinFrameWidth = math.min(v12, object.props.maxWidth)
			else
				computedMinFrameWidth = math.max(v12, v11)
			end

			object:setState({ computedMinFrameWidth = computedMinFrameWidth })
		end

		local v10 = {}

		for i = 1, count - 1 do
			if i ~= object.props.selectedTabIndex and i ~= object.props.selectedTabIndex - 1 then
				table.insert(v10, i, Roact.createElement("Frame", {
					Size = UDim2.fromOffset(1, v8),
					BackgroundTransparency = contentStyle2.Transparency,
					BackgroundColor3 = contentStyle2.Color,
					Position = UDim2.fromOffset(4 + tabWidth * i, (height - v8) / 2)
				}))
			end
		end

		return RoactGamepad.withFocusController(function(p2)
			local function fn()
				p2.moveFocusTo(object.rootRef)
			end

			local function fn2(p3) -- 3 equivalent calls inferred from this helper
				if p3 > 1 then
					p2.moveFocusTo(object.tabRefs[p3 - 1])
				end
			end
			local function fn3(p3) -- 3 equivalent calls inferred from this helper
				if p3 < count then
					p2.moveFocusTo(object.tabRefs[p3 + 1])
				end
			end

			local mapped = Cryo.List.map(object.props.tabs, function(props, layoutOrder)
				local createElement = Roact.createElement
				local frame = RoactGamepad.Focusable.Frame
				local v11 = {
					key = props.tabName,
					LayoutOrder = layoutOrder,
					Size = UDim2.fromOffset(tabWidth, height),
					BackgroundTransparency = 1,
					[Roact.Ref] = object.tabRefs[layoutOrder]
				}
				local nextSelectionLeft

				if layoutOrder > 1 then
					nextSelectionLeft = object.tabRefs[layoutOrder - 1] or nil
				end

				v11.NextSelectionLeft = nextSelectionLeft
				local nextSelectionRight

				if layoutOrder < count then
					nextSelectionRight = object.tabRefs[layoutOrder + 1] or nil
				end

				v11.NextSelectionRight = nextSelectionRight
				v11.inputBindings = {
					LeaveA = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonA, fn),
					LeaveB = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonB, fn),
					SelectNext1 = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonR1, function()
						fn3(layoutOrder) -- inferred equivalent call
					end),
					SelectPre1 = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonL1, function()
						fn2(layoutOrder) -- inferred equivalent call
					end),
					SelectNext2 = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonR2, function()
						fn3(layoutOrder) -- inferred equivalent call
					end),
					SelectPre2 = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonL2, function()
						fn2(layoutOrder) -- inferred equivalent call
					end),
					SelectNext3 = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonR3, function()
						fn3(layoutOrder) -- inferred equivalent call
					end),
					SelectPre3 = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonL3, function()
						fn2(layoutOrder) -- inferred equivalent call
					end)
				}
				return createElement(frame, v11, {
					Tab = Roact.createElement(SegmentedControlTabName, {
						text = props.tabName,
						onActivated = function()
							object.onTabActivated(layoutOrder)
						end,
						Size = UDim2.fromScale(1, 1),
						isDisabled = props.isDisabled,
						isSelectedStyle = object.props.selectedTabIndex == layoutOrder,
						icon = props.icon,
						iconStateColorMap = iconStateColorMap
					})
				})
			end)

			return Roact.createElement(
				"Frame",
				{
					Size = UDim2.new(object.props.width.Scale, object.props.width.Offset, 0, height),
					BackgroundTransparency = 1,
					[Roact.Change.AbsoluteSize] = object.setSize,
					LayoutOrder = object.props.layoutOrder
				},
				{
					SizeConstraint = Roact.createElement("UISizeConstraint", {
						MinSize = Vector2.new(object.state.computedMinFrameWidth, height),
						MaxSize = Vector2.new(640, height)
					}),
					Background = Roact.createElement(ImageSetComponent.Label, {
						Size = UDim2.new(1, 0, 0, v7),
						Position = UDim2.fromOffset(0, (height - v7) / 2),
						BackgroundTransparency = 1,
						Image = component_assetscircle_17,
						ImageColor3 = contentStyle.Color,
						ImageTransparency = contentStyle.Transparency,
						LayoutOrder = 1,
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(8, 8, 9, 9),
						ZIndex = 1
					}),
					Dividers = Roact.createElement(RoactGamepad.Focusable.Frame, {
						Size = UDim2.new(1, 0, 0, height),
						Position = UDim2.fromOffset(0, 0),
						BackgroundTransparency = 1,
						ZIndex = 2,
						NextSelectionLeft = object.props.NextSelectionLeft,
						NextSelectionRight = object.props.NextSelectionRight,
						NextSelectionUp = object.props.NextSelectionUp,
						NextSelectionDown = object.props.NextSelectionDown,
						[Roact.Ref] = object.rootRef,
						inputBindings = {
							Enter = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonA, function()
								p2.moveFocusTo(object.tabRefs[object.props.selectedTabIndex])
							end)
						}
					}, v10),
					SelectedBackground = Roact.createElement(ImageSetComponent.Label, {
						Size = UDim2.fromOffset(tabWidth, v8),
						Position = object.selectedBackgroundPositionX:map(function(p3)
							return UDim2.fromOffset(p3, (height - v8) / 2)
						end),
						BackgroundTransparency = 1,
						Image = component_assetscircle_17,
						ImageColor3 = contentStyle3.Color,
						ImageTransparency = contentStyle3.Transparency,
						LayoutOrder = 2,
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(8, 8, 9, 9),
						ZIndex = 4
					}),
					TabContainer = Roact.createElement(RoactGamepad.Focusable.Frame, {
						Size = UDim2.fromScale(1, 1),
						BackgroundTransparency = 1,
						Position = UDim2.fromScale(0, 0),
						ZIndex = 5,
						defaultChild = object.tabRefs[object.props.selectedTabIndex]
					}, {
						TabLayout = Roact.createElement("UIListLayout", {
							VerticalAlignment = Enum.VerticalAlignment.Center,
							FillDirection = Enum.FillDirection.Horizontal,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							SortOrder = Enum.SortOrder.LayoutOrder
						}),
						Roact.createFragment(mapped)
					})
				}
			)
		end)
	end)
end

function extended.didUpdate(data, p)
	if p.selectedTabIndex ~= data.props.selectedTabIndex then
		data.selectedBackgroundMotor:setGoal(Otter.spring(
			4 + data.state.tabWidth * (data.props.selectedTabIndex - 1),
			v
		))
	end
end

return extended
