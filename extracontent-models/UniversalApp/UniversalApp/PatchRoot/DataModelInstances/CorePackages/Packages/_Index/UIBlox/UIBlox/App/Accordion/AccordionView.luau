local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Roact = require(ParentParentParent.Roact)
local t = require(ParentParentParent.t)
local SpringAnimatedItem = require(ParentParent.Utility.SpringAnimatedItem)
local t1 = {
	dampingRatio = 1,
	frequency = 3.5
}
local v7 = Roact.PureComponent:extend("AccordionView")

v7.validateProps = t.strictInterface({
	items = t.table,
	itemWidth = t.number,
	itemHeight = t.number,
	renderItem = t.callback,
	placeholderColor = t.Color3,
	placeholderBaseTransparency = t.number,
	collapseButtonSize = t.number,
	renderCollapseButton = t.callback,
	LayoutOrder = t.optional(t.integer),
	maxItemsInCompactView = t.numberPositive,
	onExpand = t.optional(t.callback),
	onCollapse = t.optional(t.callback)
})
v7.defaultProps = {
	maxItemsInCompactView = 3
}

function v7.init(p1) -- line: 48
	-- upvalues: Roact (copy)
	p1.state = {
		expanded = false,
		isExpandButtonPressed = false
	}

	function p1.onExpandButtonActivated() -- line: 54
		-- upvalues: p1 (copy)
		if p1.props.onExpand then
			p1.props.onExpand()
		end

		p1:setState({
			expanded = true,
			isExpandButtonPressed = false
		})
	end
	function p1.onCollapseButtonActivated() -- line: 64
		-- upvalues: p1 (copy)
		if p1.props.onCollapse then
			p1.props.onCollapse()
		end

		p1:setState({
			expanded = false
		})
	end
	function p1.onExpandButtonInputBegan(_, p3) -- line: 73
		-- upvalues: p1 (copy)
		if p3.UserInputState == Enum.UserInputState.Begin and (p3.UserInputType == Enum.UserInputType.Touch or p3.UserInputType == Enum.UserInputType.MouseButton1) then
			p1:setState({
				isExpandButtonPressed = true
			})
		end
	end
	function p1.onExpandButtonInputEnded() -- line: 87
		-- upvalues: p1 (copy)
		if p1.state.isExpandButtonPressed then
			p1:setState({
				isExpandButtonPressed = false
			})
		end
	end

	p1.rootFrameRef = Roact.createRef()

	function p1.onListLayoutAbsoluteContentSizeChanged(p4) -- line: 97
		-- upvalues: p1 (copy)
		if p1.rootFrameRef.current then
			local itemWidth = p1.props.itemWidth
			local v47 = p1:getCompactTotalHeight()

			p1.rootFrameRef.current.Size = UDim2.new(0, itemWidth, 0, (math.max(p4.AbsoluteContentSize.Y, v47)))
		end
	end
end
function v7.getCompactTotalHeight(p5) -- line: 108
	local items = p5.props.items
	local itemHeight = p5.props.itemHeight
	local maxItemsInCompactView = p5.props.maxItemsInCompactView
	local v13 = #items

	if v13 == 0 then
		return 0
	end

	return itemHeight + (math.min(maxItemsInCompactView, v13) - 1) * 10
end
function v7.getLayoutInfo(p6) -- line: 121
	local items = p6.props.items
	local itemWidth = p6.props.itemWidth
	local itemHeight = p6.props.itemHeight
	local placeholderBaseTransparency = p6.props.placeholderBaseTransparency
	local maxItemsInCompactView = p6.props.maxItemsInCompactView
	local expanded = p6.state.expanded
	local t2 = {}
	local v22 = #items
	local v23 = math.min(maxItemsInCompactView, v22)
	local n1 = 0

	if v23 > 1 then
		n1 = (1 - placeholderBaseTransparency) / (v23 - 1)
	end

	for i = 1, v22 do
		if expanded then
			t2[i] = {
				placeholderTransparency = 1,
				itemTransparency = 0,
				width = itemWidth,
				height = itemHeight
			}
		elseif i == 1 then
			t2[i] = {
				placeholderTransparency = 1,
				itemTransparency = 0,
				width = itemWidth,
				height = itemHeight
			}
		elseif i <= maxItemsInCompactView then
			t2[i] = {
				height = 10,
				itemTransparency = 1,
				width = itemWidth - (i - 1) * 20,
				placeholderTransparency = placeholderBaseTransparency + n1 * (i - 2)
			}
		else
			t2[i] = {
				height = 0,
				placeholderTransparency = 1,
				itemTransparency = 1,
				width = itemWidth - (i - 1) * 20
			}
		end
	end

	return t2
end
function v7.render(p7) -- line: 175
	-- upvalues: Roact (copy), SpringAnimatedItem (copy), t1 (copy)
	local items = p7.props.items
	local v28 = #items

	if v28 == 0 then
		return nil
	end

	local propsLayoutOrder = p7.props.LayoutOrder
	local itemWidth = p7.props.itemWidth
	local renderItem = p7.props.renderItem
	local placeholderColor = p7.props.placeholderColor
	local collapseButtonSize = p7.props.collapseButtonSize
	local renderCollapseButton = p7.props.renderCollapseButton
	local expanded = p7.state.expanded
	local isExpandButtonPressed = p7.state.isExpandButtonPressed
	local v37 = p7:getLayoutInfo()
	local t3 = {
		Layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, not expanded and 0 or 10),
			[Roact.Change.AbsoluteContentSize] = p7.onListLayoutAbsoluteContentSizeChanged
		}),
		Scaler = Roact.createElement(SpringAnimatedItem.AnimatedUIScale, {
			springOptions = t1,
			animatedValues = {
				scale = not isExpandButtonPressed and 1 or 0.9
			},
			mapValuesToProps = function(p8) -- line: 208
				return {
					Scale = p8.scale
				}
			end
		}),
		CollapseButton = Roact.createElement(SpringAnimatedItem.AnimatedFrame, {
			springOptions = t1,
			animatedValues = {
				sizeOffsetY = expanded and collapseButtonSize + 1 or 0
			},
			mapValuesToProps = function(p9) -- line: 221
				-- upvalues: collapseButtonSize (copy)
				return {
					Size = UDim2.new(0, collapseButtonSize, 0, p9.sizeOffsetY)
				}
			end,
			regularProps = {
				BackgroundTransparency = 1,
				ClipsDescendants = true,
				[Roact.Children] = {
					ButtonMoveContainer = Roact.createElement(SpringAnimatedItem.AnimatedFrame, {
						springOptions = t1,
						animatedValues = {
							positionOffsetY = if not expanded then collapseButtonSize / 2 else 0
						},
						mapValuesToProps = function(p10) -- line: 235
							return {
								Position = UDim2.new(0, 0, 0, p10.positionOffsetY)
							}
						end,
						regularProps = {
							Size = UDim2.new(0, collapseButtonSize, 0, collapseButtonSize),
							BackgroundTransparency = 1,
							[Roact.Children] = {
								Button = renderCollapseButton(p7.onCollapseButtonActivated)
							}
						}
					})
				}
			}
		})
	}

	for i, _ in ipairs(items) do
		local v41 = v37[i]

		t3["Item" .. tostring(i)] = Roact.createElement(SpringAnimatedItem.AnimatedFrame, {
			springOptions = t1,
			animatedValues = {
				width = v41.width,
				height = v41.height
			},
			mapValuesToProps = function(p11) -- line: 262
				return {
					Size = UDim2.new(0, p11.width, 0, p11.height)
				}
			end,
			regularProps = {
				Size = UDim2.new(1, 0, 0, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = i + 1,
				ZIndex = v28 + 1 - i,
				ClipsDescendants = true,
				[Roact.Children] = {
					Item = renderItem(items[i], v41.itemTransparency, t1),
					Placeholder = Roact.createElement(SpringAnimatedItem.AnimatedFrame, {
						key = "Placeholder",
						springOptions = t1,
						animatedValues = {
							transparency = v41.placeholderTransparency
						},
						mapValuesToProps = function(p12) -- line: 282
							return {
								BackgroundTransparency = p12.transparency
							}
						end,
						regularProps = {
							BorderSizePixel = 0,
							Size = UDim2.new(1, 0, 1, 0),
							BackgroundColor3 = placeholderColor
						}
					})
				}
			}
		})
	end

	local v42 = v28 > 1 and not expanded

	return Roact.createElement("Frame", {
		Size = UDim2.new(0, itemWidth, 0, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = propsLayoutOrder,
		[Roact.Ref] = p7.rootFrameRef
	}, {
		ContentFrame = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5)
		}, t3),
		ClickToExpandButton = v42 and Roact.createElement("TextButton", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = v28 + 1,
			Text = "",
			[Roact.Event.Activated] = p7.onExpandButtonActivated,
			[Roact.Event.InputBegan] = p7.onExpandButtonInputBegan,
			[Roact.Event.InputEnded] = p7.onExpandButtonInputEnded
		})
	})
end

return v7
