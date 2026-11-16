local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local Roact = require(parent2.Roact)
local t = require(parent2.t)
local SpringAnimatedItem = require(parent.Utility.SpringAnimatedItem)

local springOptions = { dampingRatio = 1, frequency = 3.5 }

local extended = Roact.PureComponent:extend("AccordionView")

extended.validateProps = t.strictInterface({
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

extended.defaultProps = { maxItemsInCompactView = 3 }

function extended:init()
	self.state = { expanded = false, isExpandButtonPressed = false }

	function self.onExpandButtonActivated()
		if self.props.onExpand then
			self.props.onExpand()
		end

		self:setState({ expanded = true, isExpandButtonPressed = false })
	end

	function self.onCollapseButtonActivated()
		if self.props.onCollapse then
			self.props.onCollapse()
		end

		self:setState({ expanded = false })
	end

	function self.onExpandButtonInputBegan(_, p)
		if
			p.UserInputState == Enum.UserInputState.Begin
			and (p.UserInputType == Enum.UserInputType.Touch or p.UserInputType == Enum.UserInputType.MouseButton1)
		then
			self:setState({ isExpandButtonPressed = true })
		end
	end

	function self.onExpandButtonInputEnded()
		if self.state.isExpandButtonPressed then
			self:setState({ isExpandButtonPressed = false })
		end
	end

	self.rootFrameRef = Roact.createRef()

	function self.onListLayoutAbsoluteContentSizeChanged(p)
		if self.rootFrameRef.current then
			local itemWidth = self.props.itemWidth
			local compactTotalHeight = self:getCompactTotalHeight()

			self.rootFrameRef.current.Size = UDim2.new(
				0,
				itemWidth,
				0,
				(math.max(p.AbsoluteContentSize.Y, compactTotalHeight))
			)
		end
	end
end

function extended:getCompactTotalHeight()
	local items = self.props.items
	local itemHeight = self.props.itemHeight
	local maxItemsInCompactView = self.props.maxItemsInCompactView
	local count = #items

	if count == 0 then
		return 0
	end

	return itemHeight + (math.min(maxItemsInCompactView, count) - 1) * 10
end

function extended:getLayoutInfo()
	local items = self.props.items
	local itemWidth = self.props.itemWidth
	local itemHeight = self.props.itemHeight
	local placeholderBaseTransparency = self.props.placeholderBaseTransparency
	local maxItemsInCompactView = self.props.maxItemsInCompactView
	local expanded = self.state.expanded

	local count = #items
	local v = math.min(maxItemsInCompactView, count)

	local v2 = not (v > 1) and 0 or (1 - placeholderBaseTransparency) / (v - 1)
	local layoutInfo = {}

	for i = 1, count do
		if expanded then
			layoutInfo[i] = {
				width = itemWidth,
				height = itemHeight,
				placeholderTransparency = 1,
				itemTransparency = 0
			}
		elseif i == 1 then
			layoutInfo[1] = {
				width = itemWidth,
				height = itemHeight,
				placeholderTransparency = 1,
				itemTransparency = 0
			}
		elseif i <= maxItemsInCompactView then
			layoutInfo[i] = {
				width = itemWidth - (i - 1) * 20,
				height = 10,
				placeholderTransparency = placeholderBaseTransparency + v2 * (i - 2),
				itemTransparency = 1
			}
		else
			layoutInfo[i] = {
				width = itemWidth - (i - 1) * 20,
				height = 0,
				placeholderTransparency = 1,
				itemTransparency = 1
			}
		end
	end

	return layoutInfo
end

function extended:render()
	local items = self.props.items
	local count = #items

	if count == 0 then
		return nil
	end

	local layoutOrder = self.props.LayoutOrder
	local itemWidth = self.props.itemWidth
	local renderItem = self.props.renderItem
	local placeholderColor = self.props.placeholderColor
	local collapseButtonSize = self.props.collapseButtonSize
	local renderCollapseButton = self.props.renderCollapseButton

	local expanded = self.state.expanded
	local isExpandButtonPressed = self.state.isExpandButtonPressed

	local layoutInfo = self:getLayoutInfo()

	local children = {
		Layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, expanded and 10 or 0),
			[Roact.Change.AbsoluteContentSize] = self.onListLayoutAbsoluteContentSizeChanged
		}),
		Scaler = Roact.createElement(SpringAnimatedItem.AnimatedUIScale, {
			springOptions = springOptions,
			animatedValues = {
				scale = isExpandButtonPressed and 0.9 or 1
			},
			mapValuesToProps = function(p)
				return { Scale = p.scale }
			end
		}),
		CollapseButton = Roact.createElement(SpringAnimatedItem.AnimatedFrame, {
			springOptions = springOptions,
			animatedValues = {
				sizeOffsetY = expanded and collapseButtonSize + 1 or 0
			},
			mapValuesToProps = function(p)
				return {
					Size = UDim2.new(0, collapseButtonSize, 0, p.sizeOffsetY)
				}
			end,
			regularProps = {
				BackgroundTransparency = 1,
				ClipsDescendants = true,
				[Roact.Children] = {
					ButtonMoveContainer = Roact.createElement(SpringAnimatedItem.AnimatedFrame, {
						springOptions = springOptions,
						animatedValues = {
							positionOffsetY = expanded and 0 or collapseButtonSize / 2
						},
						mapValuesToProps = function(p)
							return {
								Position = UDim2.new(0, 0, 0, p.positionOffsetY)
							}
						end,
						regularProps = {
							Size = UDim2.new(0, collapseButtonSize, 0, collapseButtonSize),
							BackgroundTransparency = 1,
							[Roact.Children] = {
								Button = renderCollapseButton(self.onCollapseButtonActivated)
							}
						}
					})
				}
			}
		})
	}

	for i, _ in ipairs(items) do
		local v = layoutInfo[i]

		local v2 = "Item" .. tostring(i)
		children[v2] = Roact.createElement(SpringAnimatedItem.AnimatedFrame, {
			springOptions = springOptions,
			animatedValues = { width = v.width, height = v.height },
			mapValuesToProps = function(p)
				return {
					Size = UDim2.new(0, p.width, 0, p.height)
				}
			end,
			regularProps = {
				Size = UDim2.new(1, 0, 0, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = i + 1,
				ZIndex = count + 1 - i,
				ClipsDescendants = true,
				[Roact.Children] = {
					Item = renderItem(items[i], v.itemTransparency, springOptions),
					Placeholder = Roact.createElement(SpringAnimatedItem.AnimatedFrame, {
						key = "Placeholder",
						springOptions = springOptions,
						animatedValues = { transparency = v.placeholderTransparency },
						mapValuesToProps = function(p)
							return { BackgroundTransparency = p.transparency }
						end,
						regularProps = {
							Size = UDim2.new(1, 0, 1, 0),
							BackgroundColor3 = placeholderColor,
							BorderSizePixel = 0
						}
					})
				}
			}
		})
	end

	local clickToExpandButton = count > 1 and not expanded
	local createElement = Roact.createElement
	local rootFrameRefsByRef = {
		Size = UDim2.new(0, itemWidth, 0, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = layoutOrder,
		[Roact.Ref] = self.rootFrameRef
	}
	local v = {
		ContentFrame = Roact.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1
			},
			children
		),
		ClickToExpandButton = 0
	}

	if clickToExpandButton then
		clickToExpandButton = Roact.createElement("TextButton", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = count + 1,
			Text = "",
			[Roact.Event.Activated] = self.onExpandButtonActivated,
			[Roact.Event.InputBegan] = self.onExpandButtonInputBegan,
			[Roact.Event.InputEnded] = self.onExpandButtonInputEnded
		})
	end

	v.ClickToExpandButton = clickToExpandButton
	return createElement("Frame", rootFrameRefsByRef, v)
end

return extended
