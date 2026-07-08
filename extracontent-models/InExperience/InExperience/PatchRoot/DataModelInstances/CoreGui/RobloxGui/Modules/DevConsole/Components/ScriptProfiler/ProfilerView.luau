local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local ProfilerUtil = require(script.Parent.ProfilerUtil)
local getDurations = ProfilerUtil.getDurations
local formatSessionLength = ProfilerUtil.formatSessionLength

require(script.Parent.ProfilerDataFormatV2)

local Components = script.Parent.Parent.Parent.Components
local HeaderButton = require(Components.HeaderButton)
local ProfilerViewEntry = require(script.Parent.ProfilerViewEntry)
local Constants = require(script.Parent.Parent.Parent.Constants)
local LineWidth = Constants.GeneralFormatting.LineWidth
local LineColor = Constants.GeneralFormatting.LineColor
local HeaderFrameHeight = Constants.GeneralFormatting.HeaderFrameHeight
local _ = Constants.GeneralFormatting.EntryFrameHeight
local _ = Constants.GeneralFormatting.NoResultSearchStr
local HeaderNames = Constants.ScriptProfilerFormatting.HeaderNames
local ValueCellWidth = Constants.ScriptProfilerFormatting.ValueCellWidth
local CellPadding = Constants.ScriptProfilerFormatting.CellPadding
local ValuePadding = Constants.ScriptProfilerFormatting.ValuePadding
local v19 = Roact.PureComponent:extend("ProfilerView")

function v19.renderChildren(p1) -- line: 29
	-- upvalues: getDurations (copy), Roact (copy), ProfilerViewEntry (copy)
	local data = p1.props.data

	assert(data.Version == 2)

	local v22 = getDurations(data, 0)
	local n1 = 1

	if p1.props.average > 0 and p1.props.sessionLength then
		n1 = p1.props.sessionLength / 1000 / p1.props.average
	end

	return Roact.createElement(ProfilerViewEntry, {
		layoutOrder = 0,
		depth = 0,
		data = data,
		nodeId = p1.props.rootNode,
		functionId = p1.props.rootFunc,
		nodeName = p1.props.rootNodeName,
		average = n1,
		searchTerm = p1.props.searchTerm,
		searchFilter = p1.props.searchFilter,
		showPlugins = p1.props.showPlugins,
		pluginOffsets = p1.props.pluginOffsets,
		showGC = p1.props.showGC,
		gcNodeOffsets = p1.props.gcNodeOffsets,
		pluginGCOffsets = p1.props.pluginGCOffsets,
		expandedNodes = p1.props.expandedNodes,
		percentageRatio = if not p1.props.showAsPercentages then nil else v22 / 100
	})
end
function v19.render(p2) -- line: 62
	-- upvalues: Roact (copy), Constants (copy), formatSessionLength (copy), HeaderFrameHeight (copy), HeaderButton (copy), ValueCellWidth (copy), ValuePadding (copy), CellPadding (copy), LineColor (copy), HeaderNames (copy), LineWidth (copy)
	local layoutOrder = p2.props.layoutOrder
	local size = p2.props.size
	local v27 = nil

	if p2.props.profiling and not p2.props.data then
		v27 = Roact.createElement("TextLabel", {
			Text = "Press Stop to Finish Profiling",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			TextColor3 = Constants.Color.Text,
			LayoutOrder = layoutOrder
		})
	elseif not p2.props.data then
		v27 = Roact.createElement("TextLabel", {
			Text = "Start Profiling to View Data",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			TextColor3 = Constants.Color.Text,
			LayoutOrder = layoutOrder
		})
	end

	local v28 = formatSessionLength(p2.props.sessionLength)

	if v28 then
		v28 = "Session Duration: " .. v28
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = size,
		LayoutOrder = layoutOrder
	}, {
		SessionInfo = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, HeaderFrameHeight)
		}, {
			Name = Roact.createElement(HeaderButton, {
				text = v28 or "Session Info",
				size = UDim2.new(1 - ValueCellWidth * 2, -ValuePadding - CellPadding, 0, HeaderFrameHeight),
				pos = UDim2.new(0, CellPadding, 0, 0)
			}),
			TopHorizontal = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 1),
				BackgroundColor3 = LineColor
			})
		}),
		Header = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, HeaderFrameHeight),
			Position = UDim2.new(0, 0, 0, HeaderFrameHeight)
		}, {
			Name = Roact.createElement(HeaderButton, {
				text = HeaderNames[1],
				size = UDim2.new(1 - ValueCellWidth * 2, -ValuePadding - CellPadding, 0, HeaderFrameHeight),
				pos = UDim2.new(0, CellPadding, 0, 0),
				sortfunction = p2.onSortChanged
			}),
			Inclusive = Roact.createElement(HeaderButton, {
				text = HeaderNames[2],
				size = UDim2.new(ValueCellWidth, -CellPadding, 0, HeaderFrameHeight),
				pos = UDim2.new(1 - ValueCellWidth * 2, ValuePadding, 0, 0),
				sortfunction = p2.onSortChanged
			}),
			Self = Roact.createElement(HeaderButton, {
				text = HeaderNames[3],
				size = UDim2.new(ValueCellWidth, -CellPadding, 0, HeaderFrameHeight),
				pos = UDim2.new(1 - ValueCellWidth, ValuePadding, 0, 0),
				sortfunction = p2.onSortChanged
			}),
			TopHorizontal = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 1),
				BackgroundColor3 = LineColor
			}),
			LowerHorizontal = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, LineWidth),
				Position = UDim2.new(0, 0, 1, 0),
				BackgroundColor3 = LineColor
			}),
			Vertical1 = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				Size = UDim2.new(0, LineWidth, 1, 0),
				Position = UDim2.new(1 - ValueCellWidth, 0, 0, 0),
				BackgroundColor3 = LineColor
			}),
			Vertical2 = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				Size = UDim2.new(0, LineWidth, 1, 0),
				Position = UDim2.new(1 - ValueCellWidth * 2, 0, 0, 0),
				BackgroundColor3 = LineColor
			})
		}),
		Entries = Roact.createElement("ScrollingFrame", {
			BackgroundTransparency = 1,
			ScrollBarThickness = 5,
			Size = UDim2.new(1, 0, 1, -HeaderFrameHeight * 2),
			Position = UDim2.new(0, 0, 0, HeaderFrameHeight * 2),
			VerticalScrollBarInset = Enum.ScrollBarInset.None,
			CanvasSize = UDim2.fromScale(0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y
		}, {
			Layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical
			}),
			Children = v27 or Roact.createFragment(p2:renderChildren())
		})
	})
end

return v19
