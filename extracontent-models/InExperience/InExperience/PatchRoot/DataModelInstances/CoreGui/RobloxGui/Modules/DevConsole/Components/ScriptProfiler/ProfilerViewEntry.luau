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
local v23 = Roact.PureComponent:extend("ProfilerViewEntry")

local function mapDispatchToProps(p1) -- line: 39
	-- upvalues: SetScriptProfilerRoot (copy)
	return {
		dispatchSetScriptProfilerRoot = function(p2, p3, s1: string?) -- line: 41
			-- upvalues: p1 (copy), SetScriptProfilerRoot (copy)
			p1(SetScriptProfilerRoot(p2, p3, s1))
		end
	}
end

local v25 = RoactRodux.UNSTABLE_connect2(nil, mapDispatchToProps)(v23)

local function BorderedCellLabel(t1: {[any]: any}) -- line: 59
	-- upvalues: Roact (copy), CellLabel (copy), LineWidth (copy), ValuePadding (copy), LineColor (copy)
	return Roact.createFragment({
		Label = Roact.createElement(CellLabel, {
			text = t1.text,
			size = t1.size,
			pos = t1.pos
		}),
		LeftBorder = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(UDim.new(0, LineWidth), t1.size.Y),
			Position = UDim2.fromOffset(-ValuePadding, 0) + t1.pos,
			AnchorPoint = Vector2.new(0, 0),
			BackgroundColor3 = LineColor
		})
	})
end
local function getNodeName(p4) -- line: 76
	local depth = p4.depth
	local data = p4.data
	local functionId = p4.functionId
	local _ = data.Functions[functionId]
	local v35 = (depth ~= 0 or functionId ~= 0) and "<anonymous>" or "<root>"
	local nodeName = p4.nodeName

	if not nodeName or #nodeName == 0 then
		return v35
	end

	return nodeName
end

function v23.init(p5) -- line: 90
	p5.state = {
		showTooltip = false,
		expanded = p5.props.depth == 0 or p5.props.expandedNodes[p5.props.nodeId],
		tooltipPos = UDim2.fromOffset(0, 0)
	}

	function p5.onButtonPress() -- line: 97
		-- upvalues: p5 (copy)
		p5.props.expandedNodes[p5.props.nodeId] = not p5.state.expanded
		p5:setState(function(_) -- line: 100
			-- upvalues: p5 (copy)
			return {
				expanded = not p5.state.expanded
			}
		end)
	end
	function p5.onMouseEnter(_, p8, p9) -- line: 107
		-- upvalues: p5 (copy)
		p5:setState({
			showTooltip = true,
			tooltipPos = UDim2.fromOffset(p8, p9)
		})
	end
	function p5.onMouseMove(_, p11, p12) -- line: 114
		-- upvalues: p5 (copy)
		p5:setState({
			showTooltip = true,
			tooltipPos = UDim2.fromOffset(p11, p12)
		})
	end
	function p5.onMouseLeave() -- line: 121
		-- upvalues: p5 (copy)
		p5:setState({
			showTooltip = false
		})
	end
	function p5.onMouse2Click() -- line: 127
		-- upvalues: p5 (copy)
		local dispatchSetScriptProfilerRoot = p5.props.dispatchSetScriptProfilerRoot
		local nodeId = p5.props.nodeId
		local functionId = p5.props.functionId
		local props = p5.props
		local depth = props.depth
		local data = props.data
		local functionId2 = props.functionId
		local _ = data.Functions[functionId2]
		local v120 = (depth ~= 0 or functionId2 ~= 0) and "<anonymous>" or "<root>"
		local nodeName = props.nodeName

		if not nodeName or #nodeName == 0 then
			nodeName = v120
		end

		dispatchSetScriptProfilerRoot(nodeId, functionId, nodeName)
	end
end
function v23.renderChildren(p13, p14) -- line: 132
	-- upvalues: getDurations (copy), getPluginFlag (copy), Roact (copy), v25 (copy)
	local t2 = {}

	if p13.state.expanded then
		local percentageRatio = p13.props.percentageRatio
		local v42 = getDurations(p13.props.data, p13.props.nodeId)
		local v43 = p13.props.depth + 1
		local average = p13.props.average
		local searchTerm = p13.props.searchTerm
		local searchFilter = p13.props.searchFilter
		local showPlugins = p13.props.showPlugins
		local showGC = p13.props.showGC
		local gcNodeOffsets = p13.props.gcNodeOffsets
		local expandedNodes = p13.props.expandedNodes
		local data = p13.props.data
		local GCFuncId = data.GCFuncId

		if p14 then
			for k, v in pairs(p14) do
				if (not (#searchFilter > 0) or searchFilter[v]) and (showGC or k ~= GCFuncId) then
					local _ = data.Nodes[v]
					local v56 = data.Functions[k]

					if showPlugins or not getPluginFlag(data, v56) then
						local v57 = getDurations(data, v)

						t2[k] = Roact.createElement(v25, {
							layoutOrder = (v42 - v57) * 1000000,
							depth = v43,
							data = data,
							nodeId = v,
							functionId = k,
							nodeName = v56.Name,
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
				end
			end

			return t2
		end

		if p13.props.nodeId == 0 then
			assert(p14 == nil)

			for v58, v59 in data.Categories do
				if not (#searchFilter > 0) or searchFilter[v59.NodeId] then
					local _ = data.Nodes[v59.NodeId]
					local v61 = getDurations(data, v59.NodeId)
					local v62 = p13.props.pluginOffsets[v58]
					local v63 = p13.props.pluginGCOffsets[v58]

					if not showPlugins then
						v61 -= v62

						if showGC then
							v61 -= v63
						end
					end

					t2[v58] = Roact.createElement(v25, {
						functionId = nil,
						layoutOrder = (v42 - v61) * 1000000,
						depth = v43,
						data = data,
						nodeId = v59.NodeId,
						nodeName = v59.Name,
						average = average,
						percentageRatio = percentageRatio,
						searchTerm = searchTerm,
						searchFilter = searchFilter,
						showPlugins = showPlugins,
						pluginOffset = v62,
						pluginGCOffset = v63,
						showGC = showGC,
						gcNodeOffsets = gcNodeOffsets,
						expandedNodes = expandedNodes
					})
				end
			end
		end
	end

	return t2
end
function v23.renderValues(_, p16) -- line: 231
	-- upvalues: ValueCellWidth (copy), ValuePadding (copy), EntryFrameHeight (copy), Roact (copy), BorderedCellLabel (copy)
	local t3 = {}
	local uDim2 = UDim2.new(ValueCellWidth, -ValuePadding, 0, EntryFrameHeight)
	local uDim2_2 = UDim2.new(1 - ValueCellWidth * #p16, ValuePadding, 0, 0)

	for i, v in ipairs(p16) do
		t3[tostring(i)] = Roact.createElement(BorderedCellLabel, {
			text = tostring(v),
			size = uDim2,
			pos = uDim2_2 + UDim2.fromScale(ValueCellWidth * (i - 1), 0)
		})
	end

	return t3
end
function v23.render(p17) -- line: 246
	-- upvalues: EntryFrameHeight (copy), DepthIndent (copy), getDurations (copy), standardizeChildren (copy), ProfilerUtil (copy), getNativeFlag (copy), getPluginFlag (copy), ValueCellWidth (copy), Roact (copy), Tooltip (copy), BannerButton (copy), CellLabel (copy), CellPadding (copy)
	local props = p17.props
	local v73 = props.size or UDim2.new(1, 0, 0, EntryFrameHeight)
	local depth = props.depth
	local v75 = props.layoutOrder or 0
	local v76 = depth * DepthIndent
	local percentageRatio = props.percentageRatio
	local data = props.data
	local showPlugins = props.showPlugins
	local showGC = props.showGC
	local nodeId = props.nodeId
	local functionId = props.functionId
	local v83 = data.Functions[functionId]
	local v84 = data.Nodes[nodeId]
	local v85, v86 = getDurations(data, nodeId)
	local v87 = v85 / p17.props.average
	local v88 = v86 / p17.props.average
	local v89 = standardizeChildren(data, v84)

	if not showPlugins then
		if nodeId == 0 then
			v87 -= p17.props.pluginOffsets.Total or 0

			if showGC then
				v87 -= p17.props.pluginGCOffsets.Total or 0
			end
		else
			v87 -= p17.props.pluginOffset or 0

			if showGC then
				v87 -= p17.props.pluginGCOffset or 0
			end
		end
	end

	if not showGC then
		local gcNodeOffsets = props.gcNodeOffsets

		v87 = if nodeId ~= 0 then v87 - (gcNodeOffsets[nodeId] or 0) else v87 - (gcNodeOffsets.Total or 0)
	end

	local s2, s3

	if percentageRatio then
		if percentageRatio == 0 then
			s2 = "N/A"
			s3 = "N/A"
		else
			s2 = string.format("%.3f%%", v87 / percentageRatio)
			s3 = string.format("%.3f%%", v88 / percentageRatio)
		end
	else
		s2 = string.format("%.3f", v87 * 1000)
		s3 = string.format("%.3f", v88 * 1000)
	end

	local t4 = {
		s2,
		s3
	}
	local depth2 = props.depth
	local data2 = props.data
	local functionId3 = props.functionId
	local _ = data2.Functions[functionId3]
	local v98 = (depth2 ~= 0 or functionId3 ~= 0) and "<anonymous>" or "<root>"
	local nodeName = props.nodeName

	if not nodeName or #nodeName == 0 then
		nodeName = v98
	end

	local v100 = ProfilerUtil.getSourceLocationString(data, v83, nodeName)
	local v101 = getNativeFlag(data, v83)

	if getPluginFlag(data, v83) then
		nodeName ..= " <plugin>"
	end

	if v101 then
		nodeName ..= " <native>"
	end

	local uDim = UDim.new(1 - ValueCellWidth * #t4, -v76)

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = v73,
		LayoutOrder = v75,
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		tooltip = if not p17.state.showTooltip then nil else Roact.createElement(Tooltip, {
			text = v100,
			pos = p17.state.tooltipPos
		}),
		layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		button = Roact.createElement(BannerButton, {
			layoutOrder = -1,
			size = UDim2.new(1, 0, 0, EntryFrameHeight),
			inset = v76,
			isExpanded = p17.state.expanded,
			isExpandable = v89 and next(v89) ~= nil or depth == 0,
			onButtonPress = p17.onButtonPress,
			onMouseEnter = p17.onMouseEnter,
			onMouseLeave = p17.onMouseLeave,
			onMouseMove = p17.onMouseMove,
			onMouse2Click = p17.onMouse2Click
		}, {
			name = Roact.createElement(CellLabel, {
				text = nodeName,
				size = UDim2.new(uDim, UDim.new(1, 0)),
				pos = UDim2.new(0, CellPadding + v76, 0, 0)
			}),
			values = Roact.createFragment(p17:renderValues(t4))
		}),
		children = Roact.createFragment(p17:renderChildren(v89))
	})
end

return v25
