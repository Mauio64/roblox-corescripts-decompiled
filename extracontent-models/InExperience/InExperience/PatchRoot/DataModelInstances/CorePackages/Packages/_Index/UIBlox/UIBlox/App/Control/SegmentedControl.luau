local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Core = ParentParent.Core
local Roact = require(ParentParentParent.Roact)
local t = require(ParentParentParent.t)
local Cryo = require(ParentParentParent.Cryo)
local withStyle = require(ParentParent.Core.Style.withStyle)
local Otter = require(ParentParentParent.Otter)
local Images = require(ParentParent.App.ImageSet.Images)
local RoactGamepad = require(ParentParentParent.RoactGamepad)
local ControlState = require(Core.Control.Enum.ControlState)
local SegmentedControlTabName = require(script.Parent.SegmentedControlTabName)
local ImageSetComponent = require(Core.ImageSet.ImageSetComponent)
local getContentStyle = require(Core.Button.getContentStyle)
local getIconSize = require(ParentParent.App.ImageSet.getIconSize)
local IconSize = require(ParentParent.App.ImageSet.Enum.IconSize)
local GetTextSize = require(ParentParent.Core.Text.GetTextSize)
local v18 = getIconSize(IconSize.Medium)
local t1 = {
	frequency = 10,
	dampingRatio = 1
}
local v20 = Images["component_assets/circle_17"]
local t2 = {
	[ControlState.Default] = "BackgroundUIDefault"
}
local t3 = {
	[ControlState.Default] = "Divider"
}
local t4 = {
	[ControlState.Default] = "UIEmphasis"
}
local t5 = {
	[ControlState.Default] = "SecondaryDefault",
	[ControlState.Hover] = "SecondaryOnHover"
}
local v25 = Roact.Component:extend("SegmentedControl")

v25.validateProps = t.strictInterface({
	tabs = function(p1) -- line: 49
		-- upvalues: t (copy)
		local v27, v28 = t.array(t.strictInterface({
			tabName = t.string,
			isDisabled = t.optional(t.boolean),
			icon = t.optional(t.table)
		}))(p1)

		if not v27 then
			return v27, v28
		end

		local v29, v30 = t.numberMin(2)(#p1)

		if not v29 then
			return v29, v30
		end

		local v31, v32 = t.numberMax(4)(#p1)

		if not v31 then
			return v31, v32
		end

		return true
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
v25.defaultProps = {
	height = 44
}

function v25.init(p2) -- line: 112
	-- upvalues: Roact (copy), RoactGamepad (copy), Otter (copy), t1 (copy)
	p2.rootRef = Roact.createRef()
	p2.tabRefs = RoactGamepad.createRefCache()

	local v34, v35 = Roact.createBinding(0)

	p2.selectedBackgroundPositionX = v34
	p2.setSelectedBackgroundPositionX = v35
	p2.selectedBackgroundMotor = Otter.createSingleMotor(4)
	p2.selectedBackgroundMotor:onStep(function(p3) -- line: 118
		-- upvalues: p2 (copy)
		p2.setSelectedBackgroundPositionX(p3)
	end)
	p2:setState({
		tabWidth = 0,
		computedMinFrameWidth = 0
	})

	function p2.onTabActivated(p4) -- line: 127
		-- upvalues: p2 (copy)
		p2.props.onTabActivated(p4)
	end
	function p2.setSize(p5) -- line: 131
		-- upvalues: p2 (copy), Otter (copy), t1 (copy)
		local v42 = math.floor((math.max(p5.AbsoluteSize.X, p2.state.computedMinFrameWidth) - 8) / #p2.props.tabs)

		p2.selectedBackgroundMotor:setGoal(Otter.spring(4 + v42 * (p2.props.selectedTabIndex - 1), t1))
		p2:setState({
			tabWidth = v42
		})
	end
end
function v25.render(p6) -- line: 144
	-- upvalues: withStyle (copy), ControlState (copy), getContentStyle (copy), t2 (copy), t3 (copy), t4 (copy), v18 (copy), GetTextSize (copy), Roact (copy), RoactGamepad (copy), Cryo (copy), SegmentedControlTabName (copy), t5 (copy), ImageSetComponent (copy), v20 (copy)
	return withStyle(function(p7) -- line: 145
		-- upvalues: p6 (copy), ControlState (copy), getContentStyle (copy), t2 (copy), t3 (copy), t4 (copy), v18 (copy), GetTextSize (copy), Roact (copy), RoactGamepad (copy), Cryo (copy), SegmentedControlTabName (copy), t5 (copy), ImageSetComponent (copy), v20 (copy)
		local controlState = p6.state.controlState
		local v45 = #p6.props.tabs
		local v46 = p6.props.tabs[p6.props.selectedTabIndex].isDisabled and ControlState.Disabled or controlState
		local v47 = getContentStyle(t2, controlState, p7)
		local v48 = getContentStyle(t3, controlState, p7)
		local v49 = getContentStyle(t4, v46, p7)
		local tabWidth = p6.state.tabWidth
		local v51 = not p6.props.icon and 0 or v18
		local height = p6.props.height
		local v53 = p6.props.height - 12
		local v54 = p6.props.height - 16
		local v55 = p7.Font.Header2.RelativeSize * p7.Font.BaseSize

		if p6.state.computedMinFrameWidth == 0 then
			local n1 = 0

			for i = 1, v45 do
				local tabName = p6.props.tabs[i].tabName

				n1 = math.max(n1, GetTextSize(tabName, v55, Enum.Font.BuilderSans, Vector2.new(1e999, 1e999)).X)
			end

			local v59 = n1 + 8
			local v60 = (v51 + 80) * v45 + 8
			local v61 = (v51 + v59) * v45 + 8

			p6:setState({
				computedMinFrameWidth = if not p6.props.maxWidth then math.max(v61, v60) else math.min(v61, p6.props.maxWidth)
			})
		end

		local t6 = {}

		for i = 1, v45 - 1 do
			if i ~= p6.props.selectedTabIndex and i ~= p6.props.selectedTabIndex - 1 then
				table.insert(t6, i, Roact.createElement("Frame", {
					Size = UDim2.fromOffset(1, v54),
					BackgroundTransparency = v48.Transparency,
					BackgroundColor3 = v48.Color,
					Position = UDim2.fromOffset(4 + tabWidth * i, (height - v54) / 2)
				}))
			end
		end

		return RoactGamepad.withFocusController(function(p8) -- line: 204
			-- upvalues: p6 (copy), v45 (copy), Cryo (copy), Roact (copy), RoactGamepad (copy), tabWidth (copy), height (copy), SegmentedControlTabName (copy), t5 (copy), ImageSetComponent (copy), v53 (copy), v20 (copy), v47 (copy), t6 (copy), v54 (copy), v49 (copy)
			local function v65() -- line: 215
				-- upvalues: p8 (copy), p6 (copy)
				p8.moveFocusTo(p6.rootRef)
			end

			local v66 = Cryo.List.map(p6.props.tabs, function(p9, p10) -- line: 220
				-- upvalues: Roact (copy), RoactGamepad (copy), tabWidth (copy), height (copy), p6 (copy), v45 (copy), v65 (copy), p8 (copy), SegmentedControlTabName (copy), t5 (copy)
				return Roact.createElement(RoactGamepad.Focusable.Frame, {
					key = p9.tabName,
					LayoutOrder = p10,
					Size = UDim2.fromOffset(tabWidth, height),
					BackgroundTransparency = 1,
					[Roact.Ref] = p6.tabRefs[p10],
					NextSelectionLeft = p10 > 1 and p6.tabRefs[p10 - 1] or nil,
					NextSelectionRight = p10 < v45 and p6.tabRefs[p10 + 1] or nil,
					inputBindings = {
						LeaveA = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonA, v65),
						LeaveB = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonB, v65),
						SelectNext1 = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonR1, function() -- line: 232
							-- upvalues: p10 (copy), v45 (copy), p8 (copy), p6 (copy)
							local v72 = p10

							if v72 < v45 then
								p8.moveFocusTo(p6.tabRefs[v72 + 1])
							end
						end),
						SelectPre1 = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonL1, function() -- line: 235
							-- upvalues: p10 (copy), p8 (copy), p6 (copy)
							local v73 = p10

							if v73 > 1 then
								p8.moveFocusTo(p6.tabRefs[v73 - 1])
							end
						end),
						SelectNext2 = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonR2, function() -- line: 238
							-- upvalues: p10 (copy), v45 (copy), p8 (copy), p6 (copy)
							local v74 = p10

							if v74 < v45 then
								p8.moveFocusTo(p6.tabRefs[v74 + 1])
							end
						end),
						SelectPre2 = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonL2, function() -- line: 241
							-- upvalues: p10 (copy), p8 (copy), p6 (copy)
							local v75 = p10

							if v75 > 1 then
								p8.moveFocusTo(p6.tabRefs[v75 - 1])
							end
						end),
						SelectNext3 = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonR3, function() -- line: 244
							-- upvalues: p10 (copy), v45 (copy), p8 (copy), p6 (copy)
							local v76 = p10

							if v76 < v45 then
								p8.moveFocusTo(p6.tabRefs[v76 + 1])
							end
						end),
						SelectPre3 = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonL3, function() -- line: 247
							-- upvalues: p10 (copy), p8 (copy), p6 (copy)
							local v77 = p10

							if v77 > 1 then
								p8.moveFocusTo(p6.tabRefs[v77 - 1])
							end
						end)
					}
				}, {
					Tab = Roact.createElement(SegmentedControlTabName, {
						text = p9.tabName,
						onActivated = function() -- line: 254
							-- upvalues: p6 (copy), p10 (copy)
							p6.onTabActivated(p10)
						end,
						Size = UDim2.fromScale(1, 1),
						isDisabled = p9.isDisabled,
						isSelectedStyle = p10 == p6.props.selectedTabIndex,
						icon = p9.icon,
						iconStateColorMap = t5
					})
				})
			end)

			return Roact.createElement("Frame", {
				Size = UDim2.new(p6.props.width.Scale, p6.props.width.Offset, 0, height),
				BackgroundTransparency = 1,
				[Roact.Change.AbsoluteSize] = p6.setSize,
				LayoutOrder = p6.props.layoutOrder
			}, {
				SizeConstraint = Roact.createElement("UISizeConstraint", {
					MinSize = Vector2.new(p6.state.computedMinFrameWidth, height),
					MaxSize = Vector2.new(640, height)
				}),
				Background = Roact.createElement(ImageSetComponent.Label, {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					ZIndex = 1,
					Size = UDim2.new(1, 0, 0, v53),
					Position = UDim2.fromOffset(0, (height - v53) / 2),
					Image = v20,
					ImageColor3 = v47.Color,
					ImageTransparency = v47.Transparency,
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(8, 8, 9, 9)
				}),
				Dividers = Roact.createElement(RoactGamepad.Focusable.Frame, {
					Size = UDim2.new(1, 0, 0, height),
					Position = UDim2.fromOffset(0, 0),
					BackgroundTransparency = 1,
					ZIndex = 2,
					NextSelectionLeft = p6.props.NextSelectionLeft,
					NextSelectionRight = p6.props.NextSelectionRight,
					NextSelectionUp = p6.props.NextSelectionUp,
					NextSelectionDown = p6.props.NextSelectionDown,
					[Roact.Ref] = p6.rootRef,
					inputBindings = {
						Enter = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonA, function() -- line: 301
							-- upvalues: p8 (copy), p6 (copy)
							p8.moveFocusTo(p6.tabRefs[p6.props.selectedTabIndex])
						end)
					}
				}, t6),
				SelectedBackground = Roact.createElement(ImageSetComponent.Label, {
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					ZIndex = 4,
					Size = UDim2.fromOffset(tabWidth, v54),
					Position = p6.selectedBackgroundPositionX:map(function(p11) -- line: 309
						-- upvalues: height (copy), v54 (copy)
						return UDim2.fromOffset(p11, (height - v54) / 2)
					end),
					Image = v20,
					ImageColor3 = v49.Color,
					ImageTransparency = v49.Transparency,
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(8, 8, 9, 9)
				}),
				TabContainer = Roact.createElement(RoactGamepad.Focusable.Frame, {
					BackgroundTransparency = 1,
					ZIndex = 5,
					Size = UDim2.fromScale(1, 1),
					Position = UDim2.fromScale(0, 0),
					defaultChild = p6.tabRefs[p6.props.selectedTabIndex]
				}, {
					TabLayout = Roact.createElement("UIListLayout", {
						VerticalAlignment = Enum.VerticalAlignment.Center,
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder
					}),
					Roact.createFragment(v66)
				})
			})
		end)
	end)
end
function v25.didUpdate(p12, p13) -- line: 342
	-- upvalues: Otter (copy), t1 (copy)
	if p13.selectedTabIndex ~= p12.props.selectedTabIndex then
		p12.selectedBackgroundMotor:setGoal(Otter.spring(4 + p12.state.tabWidth * (p12.props.selectedTabIndex - 1), t1))
	end
end

return v25
