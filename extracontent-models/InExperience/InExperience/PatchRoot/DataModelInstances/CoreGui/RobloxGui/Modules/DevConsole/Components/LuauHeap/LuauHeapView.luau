local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local Components = script.Parent.Parent.Parent.Components
local HeaderButton = require(Components.HeaderButton)
local BannerButton = require(Components.BannerButton)
local CellLabel = require(Components.CellLabel)
local BoxButton = require(Components.BoxButton)
local LuauHeapViewEntry = require(script.Parent.LuauHeapViewEntry)
local LuauHeapViewStatEntry = require(script.Parent.LuauHeapViewStatEntry)
local LuauHeapViewRefEntry = require(script.Parent.LuauHeapViewRefEntry)
require(script.Parent.LuauHeapTypes)

local Actions = script.Parent.Parent.Parent.Actions
local SetLuauHeapActiveSnapshot = require(Actions.SetLuauHeapActiveSnapshot)
local SetLuauHeapCompareSnapshot = require(Actions.SetLuauHeapCompareSnapshot)

local Constants = require(script.Parent.Parent.Parent.Constants)

local LineWidth = Constants.GeneralFormatting.LineWidth
local LineColor = Constants.GeneralFormatting.LineColor
local HeaderFrameHeight = Constants.GeneralFormatting.HeaderFrameHeight
local EntryFrameHeight = Constants.GeneralFormatting.EntryFrameHeight

local ValueCellWidth = Constants.LuauHeapFormatting.ValueCellWidth
local CellPadding = Constants.LuauHeapFormatting.CellPadding
local ValuePadding = Constants.LuauHeapFormatting.ValuePadding
local SnapshotWidth = Constants.LuauHeapFormatting.SnapshotWidth
local SnapshotHighlightSize = Constants.LuauHeapFormatting.SnapshotHighlightSize
local TabsHeight = Constants.LuauHeapFormatting.TabsHeight
local TabButtonWidth = Constants.LuauHeapFormatting.TabButtonWidth
local TabButtonHeight = Constants.LuauHeapFormatting.TabButtonHeight
local TabButtonPad = Constants.LuauHeapFormatting.TabButtonPad
local TabHighlightHeight = Constants.LuauHeapFormatting.TabHighlightHeight
local TableHintHeight = Constants.LuauHeapFormatting.TableHintHeight

local v = {
	graph = {
		hint = "Graph displays the size of the objects in Luau VM aggregated by the shortest path from the root Engine references to them.\n\t\tMost important root references are ModuleScript tables and functions connected to signals or the task scheduler.",
		headers = { "Name", "Size", "Self" },
		initFragmentSource = function(object)
			return object:renderChildren()
		end
	},
	tag = {
		hint = "This memory breakdown displays how much memory is used by Luau VM types.",
		headers = { "Name", "Size", "Count" },
		initFragmentSource = function(object)
			return object:renderChildrenStats("TagBreakdown")
		end
	},
	memcat = {
		hint = [[
Memory separated by the category at the time of allocation.
		Memory category is assigned to the thread performing the allocation, not the script.
		Default value is based on the script name. Custom value can be assigned using 'debug.setmemorycategory' API.]],
		headers = { "Name", "Size", "Count" },
		initFragmentSource = function(object)
			return object:renderChildrenStats("MemcatBreakdown")
		end
	},
	userdata = {
		hint = "This breakdown shows how much memory inside Luau VM is taken by custom Roblox engine classes.\n\t\tFor DataModel classes like 'Part' this does not include the memory taken inside the engine itself.",
		headers = { "Name", "Size", "Count" },
		initFragmentSource = function(object)
			return object:renderChildrenStats("UserdataBreakdown")
		end
	},
	[game:GetEngineFeature("UnparentedInstances") and "UniqueRefs" or "refs"] = {
		hint = [[
This view shows engine DataModel instances that are only referenced by Luau VM and are not directly parented to the DataModel.
		For each instance, it will show the set of paths that make it accessible and prevent garbage collection.
		Most often, engine Luau references come from ModuleScript tables, active signal connections and active coroutines in the task scheduler.]],
		headers = { "Name", "Count", "Total Instances" },
		initFragmentSource = function(object)
			return object:renderChildrenRefs()
		end
	}
}

if game:GetEngineFeature("UnparentedInstances") then
	v.UnparentedRefs = {
		hint = [[
This view shows engine DataModel instances that are not parented to any instance (and are also not unique references).
		For each instance, it will show the set of paths that make it accessible and prevent garbage collection.
		]],
		headers = { "Name", "Count", "Total Instances" },
		initFragmentSource = function(object)
			return object:renderUnparentedRefs()
		end
	}
end

local extended = Roact.PureComponent:extend("LuauHeapView")

function extended:renderSnapshotList()
	local children = {}

	for k, _ in self.props.data do
		local createElement = Roact.createElement
		local v2 = {
			size = UDim2.new(1, 0, 0, EntryFrameHeight),
			inset = 0,
			isExpanded = false,
			isExpandable = false,
			layoutOrder = k,
			onButtonPress = function()
				self.props.dispatchSetLuauHeapActiveSnapshot(k)
			end
		}
		local v3 = {
			name = Roact.createElement(CellLabel, {
				text = `Snapshot #{k}`,
				size = UDim2.new(UDim.new(1, 0), UDim.new(1, 0)),
				pos = UDim2.new(0, CellPadding, 0, 0)
			}),
			HorizontalHighlightTop = 0,
			HorizontalHighlightBottom = 0,
			HorizontalHighlightLeft = 0,
			HorizontalHighlightRight = 0,
			Compare = 0
		}
		local horizontalHighlightTop

		if self.props.activeSnapshot == k then
			horizontalHighlightTop = Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, SnapshotHighlightSize),
				BackgroundColor3 = LineColor
			})
		end

		v3.HorizontalHighlightTop = horizontalHighlightTop
		local horizontalHighlightBottom

		if self.props.activeSnapshot == k then
			horizontalHighlightBottom = Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, SnapshotHighlightSize),
				Position = UDim2.new(0, 0, 1, -SnapshotHighlightSize),
				BackgroundColor3 = LineColor
			})
		end

		v3.HorizontalHighlightBottom = horizontalHighlightBottom
		local horizontalHighlightLeft

		if self.props.activeSnapshot == k then
			horizontalHighlightLeft = Roact.createElement("Frame", {
				Size = UDim2.new(0, SnapshotHighlightSize, 1, 0),
				BackgroundColor3 = LineColor
			})
		end

		v3.HorizontalHighlightLeft = horizontalHighlightLeft
		local horizontalHighlightRight

		if self.props.activeSnapshot == k then
			horizontalHighlightRight = Roact.createElement("Frame", {
				Size = UDim2.new(0, SnapshotHighlightSize, 1, 0),
				Position = UDim2.new(1, -SnapshotHighlightSize, 0, 0),
				BackgroundColor3 = LineColor
			})
		end

		v3.HorizontalHighlightRight = horizontalHighlightRight
		local compare

		if self.props.activeSnapshot ~= k then
			compare = Roact.createElement(BoxButton, {
				text = "Compare",
				size = UDim2.new(0.3, -6, 1, -6),
				pos = UDim2.new(0.7, 3, 0, 3),
				onClicked = function()
					self.props.dispatchSetLuauHeapCompareSnapshot(k)
				end
			})
		end

		v3.Compare = compare
		children[k] = createElement(BannerButton, v2, v3)
	end

	return children
end

function extended:renderChildren()
	local v2 = self.props.data[self.props.activeSnapshot]
	local v3 = self.props.data[self.props.compareSnapshot]

	local createElement = Roact.createElement
	local v4

	if v2 then
		v4 = v2.Graph
	end

	local compare

	if v3 then
		compare = v3.Graph
	end

	return createElement(LuauHeapViewEntry, {
		layoutOrder = 0,
		depth = 0,
		data = v4,
		compare = compare
	})
end

function extended:renderChildrenStats(p)
	local v2 = self.props.data[self.props.activeSnapshot]
	local v3 = self.props.data[self.props.compareSnapshot]

	local v4 = v2[p]
	local v5

	if v3 then
		v5 = v3[p]
	end

	local children = {}

	for k, v6 in v4 do
		local compare = nil

		if v5 then
			for _, v7 in ipairs(v5) do
				if v6.Name == v7.Name then
					compare = v7
					break
				end
			end
		end

		children[k] = Roact.createElement(LuauHeapViewStatEntry, {
			layoutOrder = -v6.Size,
			depth = 0,
			data = v6,
			compare = compare
		})
	end

	return children
end

function extended:renderUnparentedRefs()
	local refs = self.props.data[self.props.activeSnapshot].Refs

	if not refs then
		return {}
	end

	local unparentedReferences = refs.UnparentedReferences

	if not unparentedReferences then
		return {}
	end

	local children = {}

	for k, unparentedReference in unparentedReferences do
		children[k] = Roact.createElement(LuauHeapViewRefEntry, {
			layoutOrder = -unparentedReference.Instances,
			depth = 0,
			data = unparentedReference
		})
	end

	return children
end

function extended:renderChildrenRefs()
	local refs = self.props.data[self.props.activeSnapshot].Refs

	if not refs then
		return {}
	end

	assert(refs)

	local children = {}

	for k, root in refs.Roots do
		children[k] = Roact.createElement(LuauHeapViewRefEntry, {
			layoutOrder = -root.Instances,
			depth = 0,
			data = root
		})
	end

	return children
end

function extended:createTabSelector(size, position)
	local function onTabSelected(activeTab) -- 1 equivalent call inferred from this helper
		self:setState({ activeTab = activeTab })
	end

	local function createButton(activeTab, text, p)
		return Roact.createElement(BoxButton, {
			text = text,
			size = UDim2.new(0, TabButtonWidth, 0, TabButtonHeight),
			pos = UDim2.new(0, TabButtonWidth * p, 0, 0),
			onClicked = function()
				onTabSelected(activeTab) -- inferred equivalent call
			end
		})
	end

	local function createHighlight(p, p2)
		if self.state.activeTab == p then
			return (Roact.createElement("Frame", {
				Size = UDim2.new(0, TabButtonWidth, 0, TabHighlightHeight),
				Position = UDim2.new(0, TabButtonWidth * p2, 0, TabButtonHeight - TabHighlightHeight),
				BorderSizePixel = 0,
				BackgroundColor3 = Constants.Color.HighlightBlue,
				ZIndex = 10
			}))
		end

		return nil
	end

	if game:GetEngineFeature("UnparentedInstances") then
		return Roact.createElement("Frame", {
			Size = size,
			Position = position,
			BackgroundTransparency = 1
		}, {
			Graph = createButton("graph", "Graph", 0),
			GraphHighlight = createHighlight("graph", 0),
			Tags = createButton("tag", "Object Tags", 1),
			TagHighlight = createHighlight("tag", 1),
			Memcat = createButton("memcat", "Memory Categories", 2),
			MemcatHighlight = createHighlight("memcat", 2),
			Userdata = createButton("userdata", "Object Classes", 3),
			UserdataHighlight = createHighlight("userdata", 3),
			Refs = createButton("UniqueRefs", "Unique References", 4),
			RefHighlight = createHighlight("UniqueRefs", 4),
			UnparentedInstances = createButton("UnparentedRefs", "Unparented Instances", 5),
			UnparentedHighlight = createHighlight("UnparentedRefs", 5)
		})
	end

	return Roact.createElement("Frame", {
		Size = size,
		Position = position,
		BackgroundTransparency = 1
	}, {
		Graph = createButton("graph", "Graph", 0),
		GraphHighlight = createHighlight("graph", 0),
		Tags = createButton("tag", "Object Tags", 1),
		TagHighlight = createHighlight("tag", 1),
		Memcat = createButton("memcat", "Memory Categories", 2),
		MemcatHighlight = createHighlight("memcat", 2),
		Userdata = createButton("userdata", "Object Classes", 3),
		UserdataHighlight = createHighlight("userdata", 3),
		Refs = createButton("refs", "Unique References", 4),
		RefHighlight = createHighlight("refs", 4),
		UnparentedInstances = createButton("UnparentedRefs", "Unparented Instances", 5),
		UnparentedHighlight = createHighlight("UnparentedRefs", 5)
	})
end

function extended:createStatsTableHeader(p, p2, list)
	local createElement = Roact.createElement
	local v2 = {
		Size = UDim2.new(1 - SnapshotWidth, 0, 0, HeaderFrameHeight),
		Position = UDim2.new(SnapshotWidth, 0, p, p2),
		BackgroundTransparency = 1
	}
	local first

	if list[1] then
		first = Roact.createElement(HeaderButton, {
			text = list[1],
			size = UDim2.new(1 - ValueCellWidth * 2, -ValuePadding - CellPadding, 0, HeaderFrameHeight),
			pos = UDim2.new(0, CellPadding, 0, 0),
			sortfunction = self.onSortChanged
		})
	end

	local second

	if list[2] then
		second = Roact.createElement(HeaderButton, {
			text = list[2],
			size = UDim2.new(ValueCellWidth, -CellPadding, 0, HeaderFrameHeight),
			pos = UDim2.new(1 - ValueCellWidth * 2, ValuePadding, 0, 0),
			sortfunction = self.onSortChanged
		})
	end

	local third

	if list[3] then
		third = Roact.createElement(HeaderButton, {
			text = list[3],
			size = UDim2.new(ValueCellWidth, -CellPadding, 0, HeaderFrameHeight),
			pos = UDim2.new(1 - ValueCellWidth, ValuePadding, 0, 0),
			sortfunction = self.onSortChanged
		})
	end

	return createElement("Frame", v2, {
		First = first,
		Second = second,
		Third = third,
		TopHorizontal = Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, 1),
			BackgroundColor3 = LineColor,
			BorderSizePixel = 0
		}),
		LowerHorizontal = Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, LineWidth),
			Position = UDim2.new(0, 0, 1, 0),
			BackgroundColor3 = LineColor,
			BorderSizePixel = 0
		}),
		Vertical1 = Roact.createElement("Frame", {
			Size = UDim2.new(0, LineWidth, 1, 0),
			Position = UDim2.new(1 - ValueCellWidth, 0, 0, 0),
			BackgroundColor3 = LineColor,
			BorderSizePixel = 0
		}),
		Vertical2 = Roact.createElement("Frame", {
			Size = UDim2.new(0, LineWidth, 1, 0),
			Position = UDim2.new(1 - ValueCellWidth * 2, 0, 0, 0),
			BackgroundColor3 = LineColor,
			BorderSizePixel = 0
		})
	})
end

function extended:init()
	self.state = { activeTab = "graph" }
end

function extended:render()
	local layoutOrder = self.props.layoutOrder
	local size = self.props.size

	local v2 = v[self.state.activeTab]
	local v3

	if not (self.props.data and #self.props.data ~= 0) then
		v3 = Roact.createElement("TextLabel", {
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			Text = "Capture a Snapshot to view details",
			TextColor3 = Constants.Color.Text,
			BackgroundTransparency = 1,
			LayoutOrder = layoutOrder
		})
	end

	return Roact.createElement("Frame", {
		Size = size,
		BackgroundTransparency = 1,
		LayoutOrder = layoutOrder
	}, {
		SnapshotHeader = Roact.createElement(HeaderButton, {
			text = "Snapshots",
			size = UDim2.new(SnapshotWidth, -CellPadding, 0, HeaderFrameHeight),
			pos = UDim2.new(0, CellPadding, 0, 0)
		}),
		Snapshots = Roact.createElement("ScrollingFrame", {
			Size = UDim2.new(SnapshotWidth, -4, 1, -HeaderFrameHeight),
			Position = UDim2.new(0, 2, 0, HeaderFrameHeight),
			BackgroundTransparency = 1,
			VerticalScrollBarInset = Enum.ScrollBarInset.None,
			ScrollBarThickness = 5,
			CanvasSize = UDim2.fromScale(0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y
		}, {
			Layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Stroke = Roact.createElement("UIStroke", {
				Thickness = 2,
				Color = Color3.new(0.6, 0.6, 0.6)
			}),
			Children = Roact.createFragment(self:renderSnapshotList())
		}),
		Tabs = self:createTabSelector(UDim2.new(1 - SnapshotWidth, 0, 0, TabsHeight), UDim2.new(SnapshotWidth, 0, 0, 0)),
		Hint = Roact.createElement("TextLabel", {
			Size = UDim2.new(1 - SnapshotWidth, 0, 0, TableHintHeight),
			Position = UDim2.new(SnapshotWidth, 0, 0, TabsHeight),
			Text = v2.hint,
			TextColor3 = Constants.Color.Text,
			BackgroundTransparency = 1
		}),
		Headers = self:createStatsTableHeader(0, TabsHeight + TableHintHeight, v2.headers),
		Entries = Roact.createElement("ScrollingFrame", {
			Size = UDim2.new(1 - SnapshotWidth, 0, 1, -(TabsHeight + TableHintHeight + HeaderFrameHeight)),
			Position = UDim2.new(SnapshotWidth, 0, 0, TabsHeight + TableHintHeight + HeaderFrameHeight),
			BackgroundTransparency = 1,
			VerticalScrollBarInset = Enum.ScrollBarInset.None,
			ScrollBarThickness = 5,
			CanvasSize = UDim2.fromScale(0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y
		}, {
			Layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Children = v3 or Roact.createFragment(v2.initFragmentSource(self))
		})
	})
end

local function mapDispatchToProps(callback)
	return {
		dispatchSetLuauHeapActiveSnapshot = function(p: number)
			callback(SetLuauHeapActiveSnapshot(p))
		end,
		dispatchSetLuauHeapCompareSnapshot = function(p: number)
			callback(SetLuauHeapCompareSnapshot(p))
		end
	}
end

return RoactRodux.UNSTABLE_connect2(nil, mapDispatchToProps)(extended)
