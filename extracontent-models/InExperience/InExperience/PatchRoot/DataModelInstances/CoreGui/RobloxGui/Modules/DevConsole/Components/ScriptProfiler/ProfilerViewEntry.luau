local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

require(script.Parent.ProfilerDataFormatV2)
local ProfilerUtil = require(script.Parent.ProfilerUtil)

local getDurations = ProfilerUtil.getDurations
local getNativeFlag = ProfilerUtil.getNativeFlag
local getPluginFlag = ProfilerUtil.getPluginFlag
local standardizeChildren = ProfilerUtil.standardizeChildren

local Components = script.Parent.Parent.Parent.Components
local CellLabel = require(Components.CellLabel)
local BannerButton = require(Components.BannerButton)
local Tooltip = require(Components.Tooltip)

local Actions = script.Parent.Parent.Parent.Actions
local SetScriptProfilerRoot = require(Actions.SetScriptProfilerRoot)

local Constants = require(script.Parent.Parent.Parent.Constants)
local LineWidth = Constants.GeneralFormatting.LineWidth
local LineColor = Constants.GeneralFormatting.LineColor

local EntryFrameHeight = Constants.GeneralFormatting.EntryFrameHeight
local DepthIndent = Constants.ScriptProfilerFormatting.DepthIndent
local ValueCellWidth = Constants.ScriptProfilerFormatting.ValueCellWidth
local CellPadding = Constants.ScriptProfilerFormatting.CellPadding
local ValuePadding = Constants.ScriptProfilerFormatting.ValuePadding

local extended = Roact.PureComponent:extend("ProfilerViewEntry")

local function mapDispatchToProps(callback)
	return {
		dispatchSetScriptProfilerRoot = function(p, p2, p3: string?)
			callback(SetScriptProfilerRoot(p, p2, p3))
		end
	}
end

local v = RoactRodux.UNSTABLE_connect2(nil, mapDispatchToProps)(extended)

local function BorderedCellLabel(props)
	return Roact.createFragment({
		Label = Roact.createElement(CellLabel, {
			text = props.text,
			size = props.size,
			pos = props.pos
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

local function getNodeName(data)
	local depth = data.depth
	local data2 = data.data
	local functionId = data.functionId

	local _ = data2.Functions[functionId]

	local v2 = depth == 0 and functionId == 0 and "<root>" or "<anonymous>"
	local nodeName = data.nodeName
	return if nodeName and #nodeName ~= 0 then nodeName else v2
end

function extended:init()
	self.state = {
		expanded = self.props.depth == 0 or self.props.expandedNodes[self.props.nodeId],
		showTooltip = false,
		tooltipPos = UDim2.fromOffset(0, 0)
	}

	function self.onButtonPress()
		self.props.expandedNodes[self.props.nodeId] = not self.state.expanded

		self:setState(function(_)
			return {
				expanded = not self.state.expanded
			}
		end)
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

	function self.onMouse2Click()
		local dispatchSetScriptProfilerRoot = self.props.dispatchSetScriptProfilerRoot
		local nodeId = self.props.nodeId
		local functionId = self.props.functionId
		local props = self.props
		local depth = props.depth
		local data = props.data
		local functionId2 = props.functionId

		local _ = data.Functions[functionId2]

		local v2 = depth == 0 and functionId2 == 0 and "<root>" or "<anonymous>"
		local v3 = props.nodeName

		if v3 then
			if #v3 == 0 then
				v3 = v2
			end
		else
			v3 = v2
		end

		dispatchSetScriptProfilerRoot(nodeId, functionId, v3)
	end
end

function extended:renderChildren(items)
	local children = {}

	if not self.state.expanded then
		return children
	end

	local percentageRatio = self.props.percentageRatio
	local durations = getDurations(self.props.data, self.props.nodeId)
	local depth = self.props.depth + 1
	local average = self.props.average
	local searchTerm = self.props.searchTerm
	local searchFilter = self.props.searchFilter
	local showPlugins = self.props.showPlugins
	local showGC = self.props.showGC
	local gcNodeOffsets = self.props.gcNodeOffsets
	local expandedNodes = self.props.expandedNodes

	local data = self.props.data
	local gcFuncId = data.GCFuncId

	if items then
		for k, item in pairs(items) do
			if not ((not (#searchFilter > 0) or searchFilter[item]) and (showGC or k ~= gcFuncId)) then
				continue
			end

			local _ = data.Nodes[item]
			local v2 = data.Functions[k]

			if not (showPlugins or not getPluginFlag(data, v2)) then
				continue
			end

			local durations2 = getDurations(data, item)
			children[k] = Roact.createElement(v, {
				layoutOrder = (durations - durations2) * 1000000,
				depth = depth,
				data = data,
				nodeId = item,
				functionId = k,
				nodeName = v2.Name,
				average = average,
				percentageRatio = percentageRatio,
				searchTerm = searchTerm,
				searchFilter = searchFilter,
				showPlugins = showPlugins,
				showGC = showGC,
				gcNodeOffsets = gcNodeOffsets,
				expandedNodes = expandedNodes
			})
		end

		return children
	elseif self.props.nodeId == 0 then
		assert(items == nil)

		for k, category in data.Categories do
			if not (not (#searchFilter > 0) or searchFilter[category.NodeId]) then
				continue
			end

			local _ = data.Nodes[category.NodeId]
			local durations2 = getDurations(data, category.NodeId)

			local pluginOffset = self.props.pluginOffsets[k]
			local pluginGCOffset = self.props.pluginGCOffsets[k]

			if not showPlugins then
				durations2 -= pluginOffset

				if showGC then
					durations2 -= pluginGCOffset
				end
			end

			children[k] = Roact.createElement(v, {
				layoutOrder = (durations - durations2) * 1000000,
				depth = depth,
				data = data,
				nodeId = category.NodeId,
				functionId = nil,
				nodeName = category.Name,
				average = average,
				percentageRatio = percentageRatio,
				searchTerm = searchTerm,
				searchFilter = searchFilter,
				showPlugins = showPlugins,
				pluginOffset = pluginOffset,
				pluginGCOffset = pluginGCOffset,
				showGC = showGC,
				gcNodeOffsets = gcNodeOffsets,
				expandedNodes = expandedNodes
			})
		end
	end

	return children
end

function extended:renderValues(list)
	local udim = UDim2.new(ValueCellWidth, -ValuePadding, 0, EntryFrameHeight)
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

	local size = props.size or UDim2.new(1, 0, 0, EntryFrameHeight)
	local depth = props.depth
	local layoutOrder = props.layoutOrder or 0
	local inset = depth * DepthIndent
	local percentageRatio = props.percentageRatio
	local data = props.data
	local showPlugins = props.showPlugins
	local showGC = props.showGC

	local nodeId = props.nodeId
	local functionId = props.functionId
	local v2 = data.Functions[functionId]
	local node = data.Nodes[nodeId]

	local durations, v3 = getDurations(data, nodeId)

	local v4 = durations / self.props.average
	local v5 = v3 / self.props.average

	local v6 = standardizeChildren(data, node)

	if not showPlugins then
		if nodeId == 0 then
			v4 -= self.props.pluginOffsets.Total or 0

			if showGC then
				v4 -= self.props.pluginGCOffsets.Total or 0
			end
		else
			v4 -= self.props.pluginOffset or 0

			if showGC then
				v4 -= self.props.pluginGCOffset or 0
			end
		end
	end

	if not showGC then
		local gcNodeOffsets = props.gcNodeOffsets

		if nodeId == 0 then
			v4 -= gcNodeOffsets.Total or 0
		else
			v4 -= gcNodeOffsets[nodeId] or 0
		end
	end

	local v7, v8

	if percentageRatio then
		if percentageRatio == 0 then
			v7 = "N/A"
			v8 = "N/A"
		else
			v7 = string.format("%.3f%%", v4 / percentageRatio)
			v8 = string.format("%.3f%%", v5 / percentageRatio)
		end
	else
		v7 = string.format("%.3f", v4 * 1000)
		v8 = string.format("%.3f", v5 * 1000)
	end

	local v9 = { v7, v8 }
	local depth2 = props.depth
	local data2 = props.data
	local functionId2 = props.functionId

	local _ = data2.Functions[functionId2]

	local v10 = depth2 == 0 and functionId2 == 0 and "<root>" or "<anonymous>"
	local text = props.nodeName

	if text then
		if #text == 0 then
			text = v10
		end
	else
		text = v10
	end

	local sourceLocationString = ProfilerUtil.getSourceLocationString(data, v2, text)

	local nativeFlag = getNativeFlag(data, v2)

	if getPluginFlag(data, v2) then
		text ..= " <plugin>"
	end

	if nativeFlag then
		text ..= " <native>"
	end

	local udim = UDim.new(1 - ValueCellWidth * #v9, -inset)

	local createElement = Roact.createElement
	local v11 = {
		Size = size,
		BackgroundTransparency = 1,
		LayoutOrder = layoutOrder,
		AutomaticSize = Enum.AutomaticSize.Y
	}
	local tooltip

	if self.state.showTooltip then
		tooltip = Roact.createElement(Tooltip, {
			text = sourceLocationString,
			pos = self.state.tooltipPos
		})
	end

	return createElement("Frame", v11, {
		tooltip = tooltip,
		layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		button = Roact.createElement(BannerButton, {
			size = UDim2.new(1, 0, 0, EntryFrameHeight),
			inset = inset,
			isExpanded = self.state.expanded,
			isExpandable = v6 and next(v6) ~= nil and true or depth == 0,
			onButtonPress = self.onButtonPress,
			onMouseEnter = self.onMouseEnter,
			onMouseLeave = self.onMouseLeave,
			onMouseMove = self.onMouseMove,
			onMouse2Click = self.onMouse2Click,
			layoutOrder = -1
		}, {
			name = Roact.createElement(CellLabel, {
				text = text,
				size = UDim2.new(udim, UDim.new(1, 0)),
				pos = UDim2.new(0, CellPadding + inset, 0, 0)
			}),
			values = Roact.createFragment(self:renderValues(v9))
		}),
		children = Roact.createFragment(self:renderChildren(v6))
	})
end

return v
