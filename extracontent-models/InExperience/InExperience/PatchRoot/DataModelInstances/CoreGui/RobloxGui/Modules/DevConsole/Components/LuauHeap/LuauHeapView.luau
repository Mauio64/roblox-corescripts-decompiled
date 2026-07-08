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
local _ = Constants.LuauHeapFormatting.TabButtonPad
local TabHighlightHeight = Constants.LuauHeapFormatting.TabHighlightHeight
local TableHintHeight = Constants.LuauHeapFormatting.TableHintHeight
local t1 = {
	graph = {
		hint = "Graph displays the size of the objects in Luau VM aggregated by the shortest path from the root Engine references to them.\n\t\tMost important root references are ModuleScript tables and functions connected to signals or the task scheduler.",
		headers = {
			"Name",
			"Size",
			"Self"
		},
		initFragmentSource = function(p1) -- line: 47
			return p1:renderChildren()
		end
	},
	tag = {
		hint = "This memory breakdown displays how much memory is used by Luau VM types.",
		headers = {
			"Name",
			"Size",
			"Count"
		},
		initFragmentSource = function(p2) -- line: 55
			return p2:renderChildrenStats("TagBreakdown")
		end
	},
	memcat = {
		hint = "Memory separated by the category at the time of allocation.\n\t\tMemory category is assigned to the thread performing the allocation, not the script.\n\t\tDefault value is based on the script name. Custom value can be assigned using 'debug.setmemorycategory' API.",
		headers = {
			"Name",
			"Size",
			"Count"
		},
		initFragmentSource = function(p3) -- line: 65
			return p3:renderChildrenStats("MemcatBreakdown")
		end
	},
	userdata = {
		hint = "This breakdown shows how much memory inside Luau VM is taken by custom Roblox engine classes.\n\t\tFor DataModel classes like 'Part' this does not include the memory taken inside the engine itself.",
		headers = {
			"Name",
			"Size",
			"Count"
		},
		initFragmentSource = function(p4) -- line: 74
			return p4:renderChildrenStats("UserdataBreakdown")
		end
	},
	[not game:GetEngineFeature("UnparentedInstances") and "refs" or "UniqueRefs"] = {
		hint = "This view shows engine DataModel instances that are only referenced by Luau VM and are not directly parented to the DataModel.\n\t\tFor each instance, it will show the set of paths that make it accessible and prevent garbage collection.\n\t\tMost often, engine Luau references come from ModuleScript tables, active signal connections and active coroutines in the task scheduler.",
		headers = {
			"Name",
			"Count",
			"Total Instances"
		},
		initFragmentSource = function(p5) -- line: 84
			return p5:renderChildrenRefs()
		end
	}
}

if game:GetEngineFeature("UnparentedInstances") then
	t1.UnparentedRefs = {
		hint = "This view shows engine DataModel instances that are not parented to any instance (and are also not unique references).\n\t\tFor each instance, it will show the set of paths that make it accessible and prevent garbage collection.\n\t\t",
		headers = {
			"Name",
			"Count",
			"Total Instances"
		},
		initFragmentSource = function(p6) -- line: 97
			return p6:renderUnparentedRefs()
		end
	}
end

local v32 = Roact.PureComponent:extend("LuauHeapView")

function v32.renderSnapshotList(p7) -- line: 105
	-- upvalues: Roact (copy), BannerButton (copy), EntryFrameHeight (copy), CellLabel (copy), CellPadding (copy), SnapshotHighlightSize (copy), LineColor (copy), BoxButton (copy)
	local t2 = {}

	for v42, _ in p7.props.data do
		t2[v42] = Roact.createElement(BannerButton, {
			inset = 0,
			isExpanded = false,
			isExpandable = false,
			size = UDim2.new(1, 0, 0, EntryFrameHeight),
			layoutOrder = v42,
			onButtonPress = function() -- line: 117
				-- upvalues: p7 (copy), v42 (copy)
				p7.props.dispatchSetLuauHeapActiveSnapshot(v42)
			end
		}, {
			name = Roact.createElement(CellLabel, {
				text = `Snapshot #{ v42 }`,
				size = UDim2.new(UDim.new(1, 0), UDim.new(1, 0)),
				pos = UDim2.new(0, CellPadding, 0, 0)
			}),
			HorizontalHighlightTop = if v42 ~= p7.props.activeSnapshot then nil else Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, SnapshotHighlightSize),
				BackgroundColor3 = LineColor
			}),
			HorizontalHighlightBottom = if v42 ~= p7.props.activeSnapshot then nil else Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, SnapshotHighlightSize),
				Position = UDim2.new(0, 0, 1, -SnapshotHighlightSize),
				BackgroundColor3 = LineColor
			}),
			HorizontalHighlightLeft = if v42 ~= p7.props.activeSnapshot then nil else Roact.createElement("Frame", {
				Size = UDim2.new(0, SnapshotHighlightSize, 1, 0),
				BackgroundColor3 = LineColor
			}),
			HorizontalHighlightRight = if v42 ~= p7.props.activeSnapshot then nil else Roact.createElement("Frame", {
				Size = UDim2.new(0, SnapshotHighlightSize, 1, 0),
				Position = UDim2.new(1, -SnapshotHighlightSize, 0, 0),
				BackgroundColor3 = LineColor
			}),
			Compare = if v42 == p7.props.activeSnapshot then nil else Roact.createElement(BoxButton, {
				text = "Compare",
				size = UDim2.new(0.3, -6, 1, -6),
				pos = UDim2.new(0.7, 3, 0, 3),
				onClicked = function() -- line: 162
					-- upvalues: p7 (copy), v42 (copy)
					p7.props.dispatchSetLuauHeapCompareSnapshot(v42)
				end
			})
		})
	end

	return t2
end
function v32.renderChildren(p8) -- line: 173
	-- upvalues: Roact (copy), LuauHeapViewEntry (copy)
	local v45 = p8.props.data[p8.props.activeSnapshot]
	local v46 = p8.props.data[p8.props.compareSnapshot]

	return Roact.createElement(LuauHeapViewEntry, {
		layoutOrder = 0,
		depth = 0,
		data = if not v45 then nil else v45.Graph,
		compare = if not v46 then nil else v46.Graph
	})
end
function v32.renderChildrenStats(p9, p10) -- line: 185
	-- upvalues: Roact (copy), LuauHeapViewStatEntry (copy)
	local v49 = p9.props.data[p9.props.activeSnapshot]
	local v50 = p9.props.data[p9.props.compareSnapshot]
	local v51 = v49[p10]
	local v52 = if not v50 then nil else v50[p10]
	local t3 = {}

	for v54, v55 in v51 do
		local v56 = nil

		if v52 then
			for _, v in ipairs(v52) do
				if v55.Name == v.Name then
					v56 = v

					break
				end
			end
		end

		t3[v54] = Roact.createElement(LuauHeapViewStatEntry, {
			depth = 0,
			layoutOrder = -v55.Size,
			data = v55,
			compare = v56
		})
	end

	return t3
end
function v32.renderUnparentedRefs(p11) -- line: 217
	-- upvalues: Roact (copy), LuauHeapViewRefEntry (copy)
	local Refs = p11.props.data[p11.props.activeSnapshot].Refs

	if not Refs then
		return {}
	end

	local UnparentedReferences = Refs.UnparentedReferences

	if not UnparentedReferences then
		return {}
	end

	local t4 = {}

	for v63, v64 in UnparentedReferences do
		t4[v63] = Roact.createElement(LuauHeapViewRefEntry, {
			depth = 0,
			layoutOrder = -v64.Instances,
			data = v64
		})
	end

	return t4
end
function v32.renderChildrenRefs(p12) -- line: 242
	-- upvalues: Roact (copy), LuauHeapViewRefEntry (copy)
	local Refs = p12.props.data[p12.props.activeSnapshot].Refs

	if not Refs then
		return {}
	end

	assert(Refs)

	local t5 = {}

	for v68, v69 in Refs.Roots do
		t5[v68] = Roact.createElement(LuauHeapViewRefEntry, {
			depth = 0,
			layoutOrder = -v69.Instances,
			data = v69
		})
	end

	return t5
end
function v32.createTabSelector(p13, p14, p15) -- line: 267
	-- upvalues: Roact (copy), BoxButton (copy), TabButtonWidth (copy), TabButtonHeight (copy), TabHighlightHeight (copy), Constants (copy)
	local function onTabSelected(p16) -- line: 268
		-- upvalues: p13 (copy)
		p13:setState({
			activeTab = p16
		})
	end
	local function createButton(p17, p18, p19) -- line: 274
		-- upvalues: Roact (copy), BoxButton (copy), TabButtonWidth (copy), TabButtonHeight (copy), p13 (copy)
		return Roact.createElement(BoxButton, {
			text = p18,
			size = UDim2.new(0, TabButtonWidth, 0, TabButtonHeight),
			pos = UDim2.new(0, TabButtonWidth * p19, 0, 0),
			onClicked = function() -- line: 279
				-- upvalues: p17 (copy), p13 (copy)
				local v95 = p17

				p13:setState({
					activeTab = v95
				})
			end
		})
	end
	local function createHighlight(p20, p21) -- line: 285
		-- upvalues: p13 (copy), Roact (copy), TabButtonWidth (copy), TabHighlightHeight (copy), TabButtonHeight (copy), Constants (copy)
		if p20 == p13.state.activeTab then
			return (Roact.createElement("Frame", {
				BorderSizePixel = 0,
				ZIndex = 10,
				Size = UDim2.new(0, TabButtonWidth, 0, TabHighlightHeight),
				Position = UDim2.new(0, TabButtonWidth * p21, 0, TabButtonHeight - TabHighlightHeight),
				BackgroundColor3 = Constants.Color.HighlightBlue
			}))
		end

		return nil
	end

	if game:GetEngineFeature("UnparentedInstances") then
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = p14,
			Position = p15
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
		BackgroundTransparency = 1,
		Size = p14,
		Position = p15
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
function v32.createStatsTableHeader(p22, p23, p24, p25) -- line: 347
	-- upvalues: Roact (copy), SnapshotWidth (copy), HeaderFrameHeight (copy), HeaderButton (copy), ValueCellWidth (copy), ValuePadding (copy), CellPadding (copy), LineColor (copy), LineWidth (copy)
	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1 - SnapshotWidth, 0, 0, HeaderFrameHeight),
		Position = UDim2.new(SnapshotWidth, 0, p23, p24)
	}, {
		First = if not p25[1] then nil else Roact.createElement(HeaderButton, {
			text = p25[1],
			size = UDim2.new(1 - ValueCellWidth * 2, -ValuePadding - CellPadding, 0, HeaderFrameHeight),
			pos = UDim2.new(0, CellPadding, 0, 0),
			sortfunction = p22.onSortChanged
		}),
		Second = if not p25[2] then nil else Roact.createElement(HeaderButton, {
			text = p25[2],
			size = UDim2.new(ValueCellWidth, -CellPadding, 0, HeaderFrameHeight),
			pos = UDim2.new(1 - ValueCellWidth * 2, ValuePadding, 0, 0),
			sortfunction = p22.onSortChanged
		}),
		Third = if not p25[3] then nil else Roact.createElement(HeaderButton, {
			text = p25[3],
			size = UDim2.new(ValueCellWidth, -CellPadding, 0, HeaderFrameHeight),
			pos = UDim2.new(1 - ValueCellWidth, ValuePadding, 0, 0),
			sortfunction = p22.onSortChanged
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
	})
end
function v32.init(p26) -- line: 403
	p26.state = {
		activeTab = "graph"
	}
end
function v32.render(p27) -- line: 409
	-- upvalues: t1 (copy), Roact (copy), Constants (copy), HeaderButton (copy), SnapshotWidth (copy), CellPadding (copy), HeaderFrameHeight (copy), TabsHeight (copy), TableHintHeight (copy)
	local layoutOrder = p27.props.layoutOrder
	local size = p27.props.size
	local v84 = nil
	local v85 = t1[p27.state.activeTab]

	if not p27.props.data or #p27.props.data == 0 then
		v84 = Roact.createElement("TextLabel", {
			Text = "Capture a Snapshot to view details",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			TextColor3 = Constants.Color.Text,
			LayoutOrder = layoutOrder
		})
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = size,
		LayoutOrder = layoutOrder
	}, {
		SnapshotHeader = Roact.createElement(HeaderButton, {
			text = "Snapshots",
			size = UDim2.new(SnapshotWidth, -CellPadding, 0, HeaderFrameHeight),
			pos = UDim2.new(0, CellPadding, 0, 0)
		}),
		Snapshots = Roact.createElement("ScrollingFrame", {
			BackgroundTransparency = 1,
			ScrollBarThickness = 5,
			Size = UDim2.new(SnapshotWidth, -4, 1, -HeaderFrameHeight),
			Position = UDim2.new(0, 2, 0, HeaderFrameHeight),
			VerticalScrollBarInset = Enum.ScrollBarInset.None,
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
			Children = Roact.createFragment(p27:renderSnapshotList())
		}),
		Tabs = p27:createTabSelector(UDim2.new(1 - SnapshotWidth, 0, 0, TabsHeight), UDim2.new(SnapshotWidth, 0, 0, 0)),
		Hint = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1 - SnapshotWidth, 0, 0, TableHintHeight),
			Position = UDim2.new(SnapshotWidth, 0, 0, TabsHeight),
			Text = v85.hint,
			TextColor3 = Constants.Color.Text
		}),
		Headers = p27:createStatsTableHeader(0, TabsHeight + TableHintHeight, v85.headers),
		Entries = Roact.createElement("ScrollingFrame", {
			BackgroundTransparency = 1,
			ScrollBarThickness = 5,
			Size = UDim2.new(1 - SnapshotWidth, 0, 1, -(TabsHeight + TableHintHeight + HeaderFrameHeight)),
			Position = UDim2.new(SnapshotWidth, 0, 0, TabsHeight + TableHintHeight + HeaderFrameHeight),
			VerticalScrollBarInset = Enum.ScrollBarInset.None,
			CanvasSize = UDim2.fromScale(0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y
		}, {
			Layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Children = v84 or Roact.createFragment(v85.initFragmentSource(p27))
		})
	})
end

local function mapDispatchToProps(p28) -- line: 491
	-- upvalues: SetLuauHeapActiveSnapshot (copy), SetLuauHeapCompareSnapshot (copy)
	return {
		dispatchSetLuauHeapActiveSnapshot = function(n1: number) -- line: 493
			-- upvalues: p28 (copy), SetLuauHeapActiveSnapshot (copy)
			p28(SetLuauHeapActiveSnapshot(n1))
		end,
		dispatchSetLuauHeapCompareSnapshot = function(n2: number) -- line: 496
			-- upvalues: p28 (copy), SetLuauHeapCompareSnapshot (copy)
			p28(SetLuauHeapCompareSnapshot(n2))
		end
	}
end

return RoactRodux.UNSTABLE_connect2(nil, mapDispatchToProps)(v32)
