local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)

local Components = script.Parent.Parent.Parent.Components
local CellLabel = require(Components.CellLabel)
local BannerButton = require(Components.BannerButton)
local Tooltip = require(Components.Tooltip)

require(script.Parent.LuauHeapTypes)

local Constants = require(script.Parent.Parent.Parent.Constants)
local LineWidth = Constants.GeneralFormatting.LineWidth
local LineColor = Constants.GeneralFormatting.LineColor

local GraphEntryFrameHeight = Constants.LuauHeapFormatting.GraphEntryFrameHeight
local DepthIndent = Constants.LuauHeapFormatting.DepthIndent
local ValueCellWidth = Constants.LuauHeapFormatting.ValueCellWidth
local CellPadding = Constants.LuauHeapFormatting.CellPadding
local ValuePadding = Constants.LuauHeapFormatting.ValuePadding

local extended = Roact.PureComponent:extend("LuauHeapViewEntry")

local function BorderedCellLabel(props)
	return Roact.createFragment({
		Label = Roact.createElement(CellLabel, {
			text = props.text,
			size = props.size,
			pos = props.pos,
			richText = true
		}),
		LeftBorder = Roact.createElement("Frame", {
			Size = UDim2.new(UDim.new(0, LineWidth), props.size.Y),
			Position = UDim2.fromOffset(-ValuePadding, 0) + props.pos,
			AnchorPoint = Vector2.new(0, 0),
			BackgroundColor3 = LineColor,
			BorderSizePixel = 0
		})
	})
end

function extended:init()
	self.state = {
		expanded = self.props.depth == 0,
		expandedEllipsis = false,
		showTooltip = false,
		tooltipPos = UDim2.fromOffset(0, 0)
	}

	function self.onButtonPress()
		self:setState(function(p)
			return {
				expanded = not p.expanded
			}
		end)
	end

	function self.onExpandEllipsis()
		self:setState({ expandedEllipsis = true })
	end

	function self.onMouseEnter(_, p, p2)
		self:setState({ showTooltip = true, tooltipPos = UDim2.fromOffset(p, p2) })
	end

	function self.onMouseMove(_, p, p2)
		self:setState({ showTooltip = true, tooltipPos = UDim2.fromOffset(p, p2) })
	end

	function self.onMouseLeave()
		self:setState({ showTooltip = false })
	end
end

function extended:renderChildren(list, list2)
	if not self.state.expanded then
		return {}
	end

	local v

	if #list == 0 then
		if list2 == nil then
			v = false
		else
			v = #list2 ~= 0
		end
	else
		v = true
	end

	if not v then
		return {}
	end

	local totalSize = self.props.data.TotalSize

	local depth = self.props.depth + 1

	local function getCompareInfo(p)
		if list2 then
			for _, item in ipairs(list2) do
				if p.Name == item.Name then
					return item
				end
			end
		end

		return nil
	end

	local count = 0
	local children = {}
	local total = 0
	local total2 = 0

	for _, item in ipairs(list) do
		local compare

		if list2 then
			local flag = true

			for _, item2 in ipairs(list2) do
				if item.Name == item2.Name then
					compare = item2
					flag = false
					break
				end
			end

			if flag then
				compare = nil
			end
		else
			local item2 = nil
			compare = item2
		end

		if item.TotalSize <= 128 and #list > 4 and not self.state.expandedEllipsis then
			total += item.TotalSize

			if compare then
				total2 += compare.TotalSize
			end
		else
			count += 1

			children[count] = Roact.createElement(extended, {
				layoutOrder = totalSize - item.TotalSize,
				depth = depth,
				data = item,
				compare = compare
			})
		end
	end

	if total > 0 then
		count += 1

		children[count] = Roact.createElement(extended, {
			layoutOrder = totalSize,
			depth = depth,
			data = { Size = total, TotalSize = total, Name = "...", Children = {} },
			compare = list2 and { Size = total2, TotalSize = total2, Name = "...", Children = {} } or nil,
			customButtonPress = self.onExpandEllipsis
		})
	end

	if not list2 then
		return children
	end

	for _, item in ipairs(list2) do
		local v2 = false

		for _, item2 in ipairs(list) do
			if item2.Name == item.Name then
				v2 = true
				break
			end
		end

		if v2 then
			continue
		end

		local v3 = {
			Size = 0,
			TotalSize = 0,
			["Name"] = item.Name,
			Source = item.Source,
			Children = {}
		}

		count += 1

		children[count] = Roact.createElement(extended, {
			layoutOrder = totalSize,
			depth = depth,
			data = v3,
			compare = item
		})
	end

	return children
end

function extended:renderValues(list)
	local udim = UDim2.new(ValueCellWidth, -ValuePadding, 0, GraphEntryFrameHeight)
	local udim2 = UDim2.new(1 - ValueCellWidth * #list, ValuePadding, 0, 0)
	local children = {}

	for i, item in ipairs(list) do
		children[tostring(i)] = Roact.createElement(BorderedCellLabel, {
			text = tostring(item),
			size = udim,
			pos = udim2 + UDim2.fromScale(ValueCellWidth * (i - 1), 0)
		})
	end

	return children
end

function extended:render()
	local props = self.props

	local size = props.size or UDim2.new(1, 0, 0, GraphEntryFrameHeight)
	local depth = props.depth
	local layoutOrder = props.layoutOrder or 0
	local inset = depth * DepthIndent

	local data = props.data
	local compare = props.compare
	local v

	if compare and compare.TotalSize ~= data.TotalSize then
		v = string.format(
			"%d <font color=\"#%s\">(%s%d)</font>",
			data.TotalSize,
			compare.TotalSize > data.TotalSize and "0f0" or "f00",
			compare.TotalSize > data.TotalSize and "" or "+",
			data.TotalSize - compare.TotalSize
		)
	else
		v = string.format("%.0f", data.TotalSize)
	end

	local v2

	if compare and compare.Size ~= data.Size then
		v2 = string.format(
			"%d <font color=\"#%s\">(%s%d)</font>",
			data.Size,
			compare.Size > data.Size and "0f0" or "f00",
			compare.Size > data.Size and "" or "+",
			data.Size - compare.Size
		)
	else
		v2 = string.format("%.0f", data.Size)
	end

	local v3 = { v, v2 }

	local text = depth == 0 and "<root>" or "<anonymous>"

	if data.Name and #data.Name ~= 0 then
		text = data.Name
	end

	local text2

	if data.Source and #data.Source ~= 0 then
		text2 = data.Source
	else
		text2 = text
	end

	local udim = UDim.new(1 - ValueCellWidth * #v3, -(CellPadding + inset))

	local isExpandable = #data.Children ~= 0
		or compare ~= nil and #compare.Children ~= 0
		or props.customButtonPress ~= nil
	local onButtonPress

	if props.customButtonPress then
		onButtonPress = props.customButtonPress
	else
		onButtonPress = self.onButtonPress
	end

	local createElement = Roact.createElement
	local v4 = {
		Size = size,
		BackgroundTransparency = 1,
		LayoutOrder = layoutOrder,
		AutomaticSize = Enum.AutomaticSize.Y
	}
	local tooltip

	if self.state.showTooltip then
		tooltip = Roact.createElement(Tooltip, { text = text2, pos = self.state.tooltipPos })
	end

	local children = {
		tooltip = tooltip,
		layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		button = Roact.createElement(BannerButton, {
			size = UDim2.new(1, 0, 0, GraphEntryFrameHeight),
			inset = inset,
			isExpanded = self.state.expanded,
			isExpandable = isExpandable,
			onButtonPress = onButtonPress,
			onMouseEnter = self.onMouseEnter,
			onMouseLeave = self.onMouseLeave,
			onMouseMove = self.onMouseMove,
			layoutOrder = -1
		}, {
			name = Roact.createElement(CellLabel, {
				text = text,
				size = UDim2.new(udim, UDim.new(1, 0)),
				pos = UDim2.new(0, CellPadding + inset, 0, 0),
				textTruncate = Enum.TextTruncate.SplitWord,
				textWrapped = false
			}),
			values = Roact.createFragment(self:renderValues(v3))
		}),
		children = 0
	}

	local createFragment = Roact.createFragment
	local children2 = data.Children
	local v5

	if compare then
		v5 = compare.Children
	end

	children.children = createFragment(self:renderChildren(children2, v5))
	return createElement("Frame", v4, children)
end

return extended
