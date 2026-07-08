local CorePackages = game:GetService("CorePackages")

game:GetService("ScriptContext")

local HttpService = game:GetService("HttpService")
local HeapProfilerService = game:GetService("HeapProfilerService")
local Players = game:GetService("Players")
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local memoize = AppCommonLib.memoize
local Components = script.Parent.Parent.Parent.Components
local DataConsumer = require(Components.DataConsumer)
local UtilAndTab = require(Components.UtilAndTab)
local BoxButton = require(Components.BoxButton)
local LuauHeapView = require(script.Parent.LuauHeapView)

require(script.Parent.LuauHeapTypes)

local Actions = script.Parent.Parent.Parent.Actions
local SetLuauHeapState = require(Actions.SetLuauHeapState)
local SetLuauHeapProfileTarget = require(Actions.SetLuauHeapProfileTarget)
local Constants = require(script.Parent.Parent.Parent.Constants)
local MainRowPadding = Constants.GeneralFormatting.MainRowPadding
local v19 = Roact.PureComponent:extend("MainViewLuauHeap")

game:GetService("CoreGui"):WaitForChild("RobloxGui")

local function filterNode(p1, s1: string?) -- line: 34
	-- upvalues: filterNode (copy)
	if s1 == nil then
		return false
	end

	local v32 = table.clone(p1)
	local v33 = v32.Name ~= nil and string.find(string.lower(v32.Name), string.lower(s1), 1, true) ~= nil

	if v32.Source ~= nil then
		local v34 = string.find(string.lower(v32.Source), string.lower(s1), 1, true) ~= nil

		v33 = v33 or v34
	end

	if v32.Paths ~= nil then
		for _, v36 in v32.Paths do
			for _, v38 in v36 do
				local v39 = string.find(string.lower(v38), string.lower(s1), 1, true) ~= nil

				v33 = v33 or v39
			end
		end
	end

	if v32.Roots ~= nil then
		local t1 = {}

		for _, v42 in v32.Roots do
			local v43 = table.clone(v42)
			local v44 = filterNode(v43, s1)

			if v44 then
				table.insert(t1, v43)
			end

			v33 = v33 or v44
		end

		v32.Roots = t1
	end

	if v32.Children ~= nil then
		local t2 = {}

		for _, v47 in v32.Children do
			local v48 = table.clone(v47)
			local v49 = filterNode(v48, s1)

			if v49 then
				table.insert(t2, v47)
			end

			v33 = v33 or v49
		end

		v32.Children = t2
	end

	if v33 then
		return v32
	end

	return nil
end
local function filterHeapReportsStatEntryList(t3: {[any]: any}, s2: string?) -- line: 93
	if s2 == nil then
		return t3
	end

	local t4 = {}

	for _, v54 in t3 do
		if string.find(string.lower(v54.Name), string.lower(s2), 1, true) ~= nil then
			table.insert(t4, (table.clone(v54)))
		end
	end

	return t4
end
local function filterHeapReportGraph(p2, s3: string?, n1: number) -- line: 112
	-- upvalues: filterHeapReportGraph (copy)
	if s3 == nil then
		return p2
	end

	local v58 = table.clone(p2)
	local t5 = {}

	for _, v61 in v58.Children do
		local v62 = filterHeapReportGraph(v61, s3, n1 + 1)

		if v62 then
			table.insert(t5, v62)
		end
	end

	v58.Children = t5

	if n1 == 0 then
		return v58
	end

	local v63 = #t5 > 0

	if string.find(string.lower(v58.Name), string.lower(s3), 1, true) ~= nil then
		v63 = true
	end

	if v63 then
		return v58
	end

	return nil
end
local function filterUniqueRefEntryPath(p3, s4: string?) -- line: 143
	if s4 == nil then
		return p3
	end

	local t6 = {}

	for _, v68 in p3 do
		if string.find(string.lower(v68), string.lower(s4), 1, true) ~= nil then
			table.insert(t6, v68)
		end
	end

	if #t6 > 0 then
		return t6
	end

	return nil
end
local function filterUniqueRefEntryPathList(t7: {[any]: any}, s5: string?) -- line: 162
	-- upvalues: filterUniqueRefEntryPath (copy)
	if s5 == nil then
		return t7
	end

	local t8 = {}

	for _, v73 in t7 do
		local v74 = filterUniqueRefEntryPath(v73, s5)

		if v74 then
			table.insert(t8, v74)
		end
	end

	return t8
end
local function filterUniqueRefEntry(p4, s6: string?) -- line: 182
	-- upvalues: filterUniqueRefEntryPathList (copy)
	if s6 == nil then
		return p4
	end

	local v77 = table.clone(p4)
	local v78 = string.find(string.lower(v77.Name), string.lower(s6), 1, true) ~= nil and true
	local v79 = filterUniqueRefEntryPathList(v77.Paths, s6)

	v77.Paths = v79

	if #v79 > 0 then
		v78 = true
	end

	if v78 then
		return v77
	end

	return nil
end
local function filterUniqueRefReport(p5, s7: string?) -- line: 211
	-- upvalues: filterUniqueRefEntry (copy)
	if s7 == nil or p5 == nil then
		return p5
	end

	local v82 = table.clone(p5)
	local t9 = {}

	for _, v85 in v82.Roots do
		local v86 = filterUniqueRefEntry(v85, s7)

		if v86 then
			table.insert(t9, v86)
		end
	end

	v82.Roots = t9

	return v82
end
local function filterSnapshots(t10: {[any]: any}, s8: string?, _: number) -- line: 230
	-- upvalues: filterHeapReportsStatEntryList (copy), filterHeapReportGraph (copy), filterUniqueRefReport (copy)
	if s8 == nil then
		return t10
	end

	local t11 = {}

	for _, v92 in t10 do
		local v93 = table.clone(v92)

		v93.TagBreakdown = filterHeapReportsStatEntryList(v93.TagBreakdown, s8)
		v93.MemcatBreakdown = filterHeapReportsStatEntryList(v93.MemcatBreakdown, s8)
		v93.UserdataBreakdown = filterHeapReportsStatEntryList(v93.UserdataBreakdown, s8)
		v93.Graph = filterHeapReportGraph(v93.Graph, s8, 0)

		if v93.Refs then
			v93.Refs = filterUniqueRefReport(v93.Refs, s8)
		end

		table.insert(t11, v93)
	end

	return t11
end

function v19.getState(t12: {[any]: any}, b1: boolean) -- line: 258
	if b1 then
		return t12.props.client
	end

	return t12.props.server
end
function v19.getActiveState(p6) -- line: 262
	return p6.props.isClientView, p6:getState(p6.props.isClientView)
end
function v19.init(p7) -- line: 266
	-- upvalues: memoize (copy), filterSnapshots (copy), HeapProfilerService (copy), Players (copy), HttpService (copy), Roact (copy)
	function p7.onUtilTabHeightChanged(p8) -- line: 267
		-- upvalues: p7 (copy)
		p7:setState({
			utilTabHeight = p8
		})
	end

	p7.version = 0

	function p7.dispatchSetLuauHeapState(b2: boolean, p9) -- line: 275
		-- upvalues: p7 (copy)
		p7.version = p7.version + 1
		p7.props.dispatchSetLuauHeapState(b2, p9)
	end
	function p7.onClientButton() -- line: 279
		-- upvalues: p7 (copy)
		p7.props.dispatchSetLuauHeapProfileTarget(true)
	end
	function p7.onServerButton() -- line: 283
		-- upvalues: p7 (copy)
		p7.props.dispatchSetLuauHeapProfileTarget(false)
	end

	p7.filterSnapshots = memoize(filterSnapshots)

	function p7.onCreateSnapshot() -- line: 289
		-- upvalues: p7 (copy), HeapProfilerService (copy), Players (copy), HttpService (copy)
		local v115, v116 = p7:getActiveState()
		local ok, result

		if v115 then
			ok, result = pcall(HeapProfilerService.ClientRequestDataAsync, HeapProfilerService, Players.LocalPlayer)
		else
			ok, result = pcall(HeapProfilerService.ServerRequestDataAsync, HeapProfilerService)
		end

		if not ok then
			warn(result)

			return
		end

		local data = HttpService:JSONDecode(result)
		local Report = data.Report

		Report.Refs = data.Refs

		local v121 = table.clone(v116)

		table.insert(v121.snapshots, Report)
		v121.active = #v121.snapshots
		p7.dispatchSetLuauHeapState(v115, v121)
	end
	function p7.onClearSnapshots() -- line: 317
		-- upvalues: p7 (copy)
		local v122, v123 = p7:getActiveState()
		local v124 = table.clone(v123)

		table.clear(v124.snapshots)
		v124.active = 0
		p7.dispatchSetLuauHeapState(v122, v124)
	end

	p7.utilRef = Roact.createRef()
	p7.state = {
		searchTerm = nil,
		utilTabHeight = 0
	}

	function p7.onSearchTermChanged(s9: string?) -- line: 335
		-- upvalues: p7 (copy), Roact (copy)
		if s9 == nil or s9 == "" then
			p7:setState({
				searchTerm = Roact.None
			})

			return
		end

		p7:setState({
			searchTerm = s9
		})
	end
end
function v19.didMount(p10) -- line: 348
	p10:setState({
		utilTabHeight = p10.utilRef.current.Size.Y.Offset
	})
end
function v19.willUnmount(_) -- line: 355
end
function v19.didUpdate(p12) -- line: 358
	local currentSize = p12.utilRef.current.Size

	if currentSize.Y.Offset ~= p12.state.utilTabHeight then
		p12:setState({
			utilTabHeight = currentSize.Y.Offset
		})
	end
end
function v19.render(p13) -- line: 367
	-- upvalues: Roact (copy), Constants (copy), MainRowPadding (copy), UtilAndTab (copy), BoxButton (copy), LuauHeapView (copy)
	local size = p13.props.size
	local formFactor = p13.props.formFactor
	local tabList = p13.props.tabList
	local utilTabHeight = p13.state.utilTabHeight
	local v107, v108 = p13:getActiveState()

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = 3,
		Size = size,
		BackgroundColor3 = Constants.Color.BaseGray
	}, {
		UIListLayout = Roact.createElement("UIListLayout", {
			Padding = UDim.new(0, MainRowPadding),
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		UtilAndTab = Roact.createElement(UtilAndTab, {
			layoutOrder = 1,
			windowWidth = size.X.Offset,
			formFactor = formFactor,
			tabList = tabList,
			isClientView = v107,
			onClientButton = p13.onClientButton,
			onServerButton = p13.onServerButton,
			refForParent = p13.utilRef,
			onHeightChanged = p13.onUtilTabHeightChanged,
			onSearchTermChanged = p13.onSearchTermChanged
		}, {
			Roact.createElement(BoxButton, {
				text = "Create Snapshot",
				onClicked = p13.onCreateSnapshot
			}),
			Roact.createElement(BoxButton, {
				text = "Clear Snapshots",
				onClicked = p13.onClearSnapshots
			})
		}),
		LuauHeapView = Roact.createElement(LuauHeapView, {
			layoutOrder = 2,
			size = UDim2.new(1, 0, 1, -utilTabHeight),
			data = p13.filterSnapshots(v108.snapshots, p13.state.searchTerm, p13.version),
			activeSnapshot = v108.active,
			compareSnapshot = v108.compare
		})
	})
end

local function mapStateToProps(p14, _) -- line: 423
	return {
		isClientView = p14.LuauHeap.isClientView,
		client = p14.LuauHeap.client,
		server = p14.LuauHeap.server
	}
end
local function mapDispatchToProps(p16) -- line: 432
	-- upvalues: SetLuauHeapState (copy), SetLuauHeapProfileTarget (copy)
	return {
		dispatchSetLuauHeapState = function(b3: boolean, p17) -- line: 434
			-- upvalues: p16 (copy), SetLuauHeapState (copy)
			p16(SetLuauHeapState(b3, p17))
		end,
		dispatchSetLuauHeapProfileTarget = function(b4: boolean) -- line: 437
			-- upvalues: p16 (copy), SetLuauHeapProfileTarget (copy)
			p16(SetLuauHeapProfileTarget(b4))
		end
	}
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, mapDispatchToProps)(DataConsumer(v19, "LuauHeapData"))
