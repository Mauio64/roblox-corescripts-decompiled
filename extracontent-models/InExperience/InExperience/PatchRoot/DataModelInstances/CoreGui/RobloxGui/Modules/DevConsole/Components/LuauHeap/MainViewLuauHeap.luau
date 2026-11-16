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

local extended = Roact.PureComponent:extend("MainViewLuauHeap")

local CoreGui = game:GetService("CoreGui")
CoreGui:WaitForChild("RobloxGui")
local function filterNode(clone, value: string?)
	if value == nil then
		return false
	end

	local clone2 = table.clone(clone)
	local v

	if clone2.Name == nil then
		v = false
	else
		v = string.find(string.lower(clone2.Name), string.lower(value), 1, true) ~= nil
	end

	if clone2.Source ~= nil then
		local v2 = string.find(string.lower(clone2.Source), string.lower(value), 1, true) ~= nil
		v = v or v2
	end

	if clone2.Paths ~= nil then
		for _, path in clone2.Paths do
			for _, v2 in path do
				local v3 = string.find(string.lower(v2), string.lower(value), 1, true) ~= nil
				v = v or v3
			end
		end
	end

	if clone2.Roots ~= nil then
		local clones = {}

		for _, root in clone2.Roots do
			local clone3 = table.clone(root)
			local v2 = filterNode(clone3, value)

			if v2 then
				table.insert(clones, clone3)
			end

			v = v or v2
		end

		clone2.Roots = clones
	end

	if clone2.Children ~= nil then
		local children = {}

		for _, child in clone2.Children do
			local v2 = filterNode(table.clone(child), value)

			if v2 then
				table.insert(children, child)
			end

			v = v or v2
		end

		clone2.Children = children
	end

	return if v then clone2 else nil
end

local function filterHeapReportsStatEntryList(items, value: string?)
	if value == nil then
		return items
	end

	local clones = {}

	for _, item in items do
		if string.find(string.lower(item.Name), string.lower(value), 1, true) == nil then
			continue
		end

		table.insert(clones, (table.clone(item)))
	end

	return clones
end

local function filterHeapReportGraph(graph, value: string?, p: number)
	if value == nil then
		return graph
	end

	local clone = table.clone(graph)
	local children = {}

	for _, child in clone.Children do
		local v = filterHeapReportGraph(child, value, p + 1)

		if v then
			table.insert(children, v)
		end
	end

	clone.Children = children

	if p == 0 then
		return clone
	end

	local v = #children > 0

	if string.find(string.lower(clone.Name), string.lower(value), 1, true) ~= nil or v then
		return clone
	end

	return nil
end

local function filterUniqueRefEntryPath(item, value: string?)
	if value == nil then
		return item
	end

	local result = {}

	for _, item2 in item do
		if string.find(string.lower(item2), string.lower(value), 1, true) == nil then
			continue
		end

		table.insert(result, item2)
	end

	return if #result > 0 then result else nil
end

local function filterUniqueRefEntryPathList(paths, value: string?)
	if value == nil then
		return paths
	end

	local result = {}

	for _, item in paths do
		local v = filterUniqueRefEntryPath(item, value)

		if v then
			table.insert(result, v)
		end
	end

	return result
end

local function filterUniqueRefEntry(root, value: string?)
	if value == nil then
		return root
	end

	local clone = table.clone(root)

	local v = string.find(string.lower(clone.Name), string.lower(value), 1, true) ~= nil

	local paths = filterUniqueRefEntryPathList(clone.Paths, value)

	clone.Paths = paths

	return if #paths > 0 or v then clone else nil
end

local function filterUniqueRefReport(refs, p: string?)
	if p == nil or refs == nil then
		return refs
	end

	local clone = table.clone(refs)
	local roots = {}

	for _, root in clone.Roots do
		local v = filterUniqueRefEntry(root, p)

		if v then
			table.insert(roots, v)
		end
	end

	clone.Roots = roots
	return clone
end

local function filterSnapshots(items, p: string?, _: number)
	if p == nil then
		return items
	end

	local clones = {}

	for _, item in items do
		local clone = table.clone(item)

		clone.TagBreakdown = filterHeapReportsStatEntryList(clone.TagBreakdown, p)

		clone.MemcatBreakdown = filterHeapReportsStatEntryList(clone.MemcatBreakdown, p)

		clone.UserdataBreakdown = filterHeapReportsStatEntryList(clone.UserdataBreakdown, p)

		clone.Graph = filterHeapReportGraph(clone.Graph, p, 0)

		if clone.Refs then
			clone.Refs = filterUniqueRefReport(clone.Refs, p)
		end

		table.insert(clones, clone)
	end

	return clones
end

function extended:getState(flag: boolean)
	return if flag then self.props.client else self.props.server
end

function extended:getActiveState()
	return self.props.isClientView, self:getState(self.props.isClientView)
end

function extended:init()
	function self.onUtilTabHeightChanged(utilTabHeight)
		self:setState({ utilTabHeight = utilTabHeight })
	end

	self.version = 0

	function self.dispatchSetLuauHeapState(flag: boolean, p)
		self.version += 1
		self.props.dispatchSetLuauHeapState(flag, p)
	end
	function self.onClientButton()
		self.props.dispatchSetLuauHeapProfileTarget(true)
	end

	function self.onServerButton()
		self.props.dispatchSetLuauHeapProfileTarget(false)
	end

	self.filterSnapshots = memoize(filterSnapshots)

	function self.onCreateSnapshot()
		local activeState, v = self:getActiveState()
		local success, result

		if activeState then
			success, result = pcall(
				HeapProfilerService.ClientRequestDataAsync,
				HeapProfilerService,
				Players.LocalPlayer
			)
		else
			success, result = pcall(HeapProfilerService.ServerRequestDataAsync, HeapProfilerService)
		end

		if not success then
			warn(result)
			return
		end

		local jsonDecode = HttpService:JSONDecode(result)
		local report = jsonDecode.Report
		report.Refs = jsonDecode.Refs

		local clone = table.clone(v)

		table.insert(clone.snapshots, report)

		clone.active = #clone.snapshots

		self.dispatchSetLuauHeapState(activeState, clone)
	end

	function self.onClearSnapshots()
		local activeState, v = self:getActiveState()

		local clone = table.clone(v)

		table.clear(clone.snapshots)
		clone.active = 0

		self.dispatchSetLuauHeapState(activeState, clone)
	end

	self.utilRef = Roact.createRef()

	self.state = { searchTerm = nil, utilTabHeight = 0 }

	function self.onSearchTermChanged(searchTerm: string?)
		if searchTerm == nil or searchTerm == "" then
			self:setState({ searchTerm = Roact.None })
		else
			self:setState({ searchTerm = searchTerm })
		end
	end
end

function extended.didMount(object)
	object:setState({ utilTabHeight = object.utilRef.current.Size.Y.Offset })
end

function extended.willUnmount(_) end

function extended.didUpdate(object)
	local size = object.utilRef.current.Size

	if size.Y.Offset ~= object.state.utilTabHeight then
		object:setState({ utilTabHeight = size.Y.Offset })
	end
end

function extended:render()
	local size = self.props.size
	local formFactor = self.props.formFactor
	local tabList = self.props.tabList

	local utilTabHeight = self.state.utilTabHeight

	local activeState, v = self:getActiveState()

	return Roact.createElement(
		"Frame",
		{
			Size = size,
			BackgroundColor3 = Constants.Color.BaseGray,
			BackgroundTransparency = 1,
			LayoutOrder = 3
		},
		{
			UIListLayout = Roact.createElement("UIListLayout", {
				Padding = UDim.new(0, MainRowPadding),
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			UtilAndTab = Roact.createElement(UtilAndTab, {
				windowWidth = size.X.Offset,
				formFactor = formFactor,
				tabList = tabList,
				layoutOrder = 1,
				isClientView = activeState,
				onClientButton = self.onClientButton,
				onServerButton = self.onServerButton,
				refForParent = self.utilRef,
				onHeightChanged = self.onUtilTabHeightChanged,
				onSearchTermChanged = self.onSearchTermChanged
			}, {
				Roact.createElement(BoxButton, {
					text = "Create Snapshot",
					onClicked = self.onCreateSnapshot
				}),
				Roact.createElement(BoxButton, {
					text = "Clear Snapshots",
					onClicked = self.onClearSnapshots
				})
			}),
			LuauHeapView = Roact.createElement(LuauHeapView, {
				size = UDim2.new(1, 0, 1, -utilTabHeight),
				layoutOrder = 2,
				data = self.filterSnapshots(v.snapshots, self.state.searchTerm, self.version),
				activeSnapshot = v.active,
				compareSnapshot = v.compare
			})
		}
	)
end

local function mapStateToProps(p, _)
	return {
		isClientView = p.LuauHeap.isClientView,
		client = p.LuauHeap.client,
		server = p.LuauHeap.server
	}
end

local function mapDispatchToProps(callback)
	return {
		dispatchSetLuauHeapState = function(flag: boolean, p)
			callback(SetLuauHeapState(flag, p))
		end,
		dispatchSetLuauHeapProfileTarget = function(flag: boolean)
			callback(SetLuauHeapProfileTarget(flag))
		end
	}
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, mapDispatchToProps)(DataConsumer(extended, "LuauHeapData"))
