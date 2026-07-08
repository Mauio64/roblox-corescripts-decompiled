local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local ScriptProfilerService = game:GetService("ScriptProfilerService")
local Players = game:GetService("Players")
local Immutable = require(script.Parent.Parent.Parent.Immutable)
local Components = script.Parent.Parent.Parent.Components
local UtilAndTab = require(Components.UtilAndTab)
local BoxButton = require(Components.BoxButton)
local DropDown = require(Components.DropDown)
local ProfilerView = require(script.Parent.ProfilerView)
local ProfilerFunctionsView = require(script.Parent.ProfilerFunctionsView)

require(script.Parent.ProfilerDataFormatV2)

local ProfilerExportView = require(script.Parent.ProfilerExportView)
local MobileSettingsView = require(script.Parent.MobileSettingsView)
local ProfilerUtil = require(script.Parent.ProfilerUtil)
local getPluginFlag = ProfilerUtil.getPluginFlag
local getDurations = ProfilerUtil.getDurations
local formatFrequency = ProfilerUtil.formatFrequency
local Actions = script.Parent.Parent.Parent.Actions
local SetScriptProfilerState = require(Actions.SetScriptProfilerState)
local SetIsProfiling = require(script.Parent.Actions.SetIsProfiling)
local SetData = require(script.Parent.Actions.SetData)
local SetThreads = require(script.Parent.Actions.SetThreads)
local SetTimerState = require(script.Parent.Actions.SetTimerState)
local ClearStateForNewProfilingSession = require(script.Parent.Actions.ClearStateForNewProfilingSession)
local SetAverage = require(script.Parent.Actions.SetAverage)
local SetFrequency = require(script.Parent.Actions.SetFrequency)
local SetDataView = require(script.Parent.Actions.SetDataView)
local SetLiveUpdate = require(script.Parent.Actions.SetLiveUpdate)
local SetShowPlugins = require(script.Parent.Actions.SetShowPlugins)
local SetShowGC = require(script.Parent.Actions.SetShowGC)
local SetSearchData = require(script.Parent.Actions.SetSearchData)
local Constants = require(script.Parent.Parent.Parent.Constants)
local MainRowPadding = Constants.GeneralFormatting.MainRowPadding
local SmallFrameHeight = Constants.UtilityBarFormatting.SmallFrameHeight
local MainWindowHeader = Constants.Font.MainWindowHeader
local MainWindowHeader2 = Constants.DefaultFontSize.MainWindowHeader
local ColorText = Constants.Color.Text
local UnselectedGray = Constants.Color.UnselectedGray
local v40 = Roact.PureComponent:extend("MainViewScriptProfiler")
local v41 = game:DefineFastFlag("ScriptProfilerShowPlugins2", false)
local v42 = game:DefineFastInt("ScriptProfilerLiveUpdateIntervalMS", 1000)
local t1 = {
	"Callgraph",
	"Functions"
}

local function annotateSearchFilterNodes(p1, t2: {[any]: any}, t3: {[any]: any}, n1: number, n2: number, b1: boolean) -- line: 64
	-- upvalues: annotateSearchFilterNodes (copy)
	local v59 = p1.Nodes[n2]

	if not v59.Children then
		t3[n2] = n1 > 0 and t2[n1] or b1

		return n1 > 0 and t2[n1]
	end

	local Children = v59.Children
	local v61 = false

	if n1 > 0 and t2[n1] then
		t3[n2] = true

		for k, v in pairs(Children) do
			t3[v] = true
			annotateSearchFilterNodes(p1, t2, t3, k, v, true)
		end

		return true
	end

	for k, v in pairs(Children) do
		local v66 = annotateSearchFilterNodes(p1, t2, t3, k, v, b1)

		v61 = v61 or v66
	end

	if v61 or b1 then
		t3[n2] = true
	end

	return v61
end
local function generateSearchFilters(p2, s1: string) -- line: 109
	-- upvalues: ProfilerUtil (copy), annotateSearchFilterNodes (copy)
	if s1 == "" then
		return nil, nil
	end

	local data = p2.data

	if not data then
		return nil, nil
	end

	local t4 = table.create(#data.Functions, false)

	for v71, v72 in data.Functions do
		local v73 = ProfilerUtil.getName(data, v72)

		if v73 and string.find(v73, s1, 1, true) then
			t4[v71] = true
		end
	end

	local t5 = table.create(#data.Nodes, false)

	for _, v76 in data.Categories do
		local NodeId = v76.NodeId
		local v78 = data.Nodes[NodeId]

		if not v78.Children then
			t5[NodeId] = false
		else
			local Children = v78.Children
			local v80 = false

			for k, v in pairs(Children) do
				local v83 = annotateSearchFilterNodes(data, t4, t5, k, v, false)

				v80 = v80 or v83
			end

			if v80 then
				t5[NodeId] = true
			end
		end
	end

	for v84, v85 in data.Functions do
		if t4[v84] ~= true and not ProfilerUtil.getName(data, v85) then
			local v86 = ProfilerUtil.getSourceName(data, v85)

			if v86 and string.find(v86, s1, 1, true) then
				t4[v84] = true
			end
		end
	end

	return t4, t5
end
local function generatePluginDurationOffsets(t6: {[any]: any}, p3) -- line: 153
	-- upvalues: getPluginFlag (copy), getDurations (copy)
	if p3 then
		assert(p3.Version == 2)

		local t7 = table.create(#p3.Categories, 0)
		local t8 = table.create(#p3.Categories, 0)
		local n3 = 0
		local n4 = 0

		for v93, v94 in p3.Categories do
			local n5 = 0
			local n6 = 0
			local Children = p3.Nodes[v94.NodeId].Children

			if Children then
				for k, v in pairs(Children) do
					local _ = p3.Functions[k]

					if getPluginFlag(p3, p3.Functions[k]) then
						n5 += getDurations(p3, v)

						if #t6 > 0 then
							n6 += t6[v]
						end
					end
				end
			end

			t7[v93] = n5
			t8[v93] = n6
			n3 += n5
			n4 += n6
		end

		t7.Total = n3
		t8.Total = n3

		return t7, t8
	end

	return {}, {}
end
local function getGCOverhead(t9: {[any]: any}, t10: {[any]: any}, p4, p5, p6) -- line: 203
	-- upvalues: getGCOverhead (copy)
	local v106 = p4.Nodes[p5]
	local n7 = 0

	if v106.Children then
		for k, v in pairs(v106.Children) do
			local v110 = if k ~= p6 then getGCOverhead(t9, t10, p4, v, p6) else p4.Nodes[v].TotalDuration

			t9[k] = t9[k] + v110
			t10[v] = v110
			n7 += v110
		end
	end

	return n7
end
local function generateGCOverheadOffsets(p7) -- line: 231
	-- upvalues: getGCOverhead (copy)
	if p7 and p7.GCFuncId then
		local GCFuncId = p7.GCFuncId
		local t11 = table.create(#p7.Functions, 0)
		local t12 = table.create(#p7.Nodes, 0)
		local n8 = 0

		for _, v117 in p7.Categories do
			local NodeId = v117.NodeId
			local v119 = getGCOverhead(t11, t12, p7, NodeId, GCFuncId)

			n8 += v119
			t12[NodeId] = v119
		end

		t12.Total = n8

		return t11, t12
	end

	return {}, {}
end

function v40.getActiveState(p8) -- line: 259
	local isClientView = p8.props.isClientView

	if p8.props.isClientView then
		return isClientView, p8.props.client
	end

	return isClientView, p8.props.server
end
function v40.getState(p9, p10) -- line: 263
	if p10 then
		return p9.props.client
	end

	return p9.props.server
end
function v40.UpdateState(p11, p12, p13) -- line: 267
	if p12 then
		p11.props.dispatchSetScriptProfilerState(nil, nil, p13, nil)

		return
	end

	p11.props.dispatchSetScriptProfilerState(nil, nil, nil, p13)
end

local function OnNewProfilingData(p14, p15, s2: string?) -- line: 275
	-- upvalues: ScriptProfilerService (copy), generateGCOverheadOffsets (copy), v41 (copy), generatePluginDurationOffsets (copy)
	p14.serializedData = s2
	p14.data = ScriptProfilerService:DeserializeJSON(s2)

	local v130, v131 = generateGCOverheadOffsets(p14.data)

	p14.gcFunctionOffsets = v130
	p14.gcNodeOffsets = v131

	if v41 then
		local v132, v133 = generatePluginDurationOffsets(p14.gcNodeOffsets, p14.data)

		p14.pluginOffsets = v132
		p14.pluginGCOffsets = v133
	end

	local v134 = not p14.data and 0 or #p14.data.Nodes
	local v135 = not p15.data and 0 or #p15.data.Nodes
	local t13 = table.create(v134, false)
	local expandedNodes = p15.expandedNodes

	table.move(expandedNodes, 1, v135, 1, t13)
	p14.expandedNodes = t13
end

function v40.init(p16) -- line: 293
	-- upvalues: ScriptProfilerService (copy), Players (copy), v42 (copy), generateSearchFilters (copy), Roact (copy)
	local function StartScriptProfiling(p17, p18) -- line: 294
		-- upvalues: ScriptProfilerService (copy), Players (copy)
		if p17 then
			ScriptProfilerService:ClientStart(Players.LocalPlayer, p18.frequency)

			return
		end

		ScriptProfilerService:ServerStart(p18.frequency)
	end
	local function StopScriptProfiling(p19) -- line: 302
		-- upvalues: ScriptProfilerService (copy), Players (copy)
		if p19 then
			ScriptProfilerService:ClientStop(Players.LocalPlayer)
		else
			ScriptProfilerService:ServerStop()
		end

		return nil
	end
	local function RequestNewData(p20) -- line: 311
		-- upvalues: ScriptProfilerService (copy), Players (copy)
		if p20 then
			ScriptProfilerService:ClientRequestData(Players.LocalPlayer)

			return
		end

		ScriptProfilerService:ServerRequestData()
	end
	local function StopTimedProfiling(p21) -- line: 319
		-- upvalues: p16 (copy), ScriptProfilerService (copy), Players (copy)
		if p16:getState(p21).isProfiling then
			if p21 then
				ScriptProfilerService:ClientStop(Players.LocalPlayer)
			else
				ScriptProfilerService:ServerStop()
			end

			p16.props.dispatchSetIsProfiling(p21, false)

			if p21 then
				ScriptProfilerService:ClientRequestData(Players.LocalPlayer)

				return
			end

			ScriptProfilerService:ServerRequestData()
		end
	end

	function p16.onUtilTabHeightChanged(p22) -- line: 331
		-- upvalues: p16 (copy)
		p16:setState({
			utilTabHeight = p22
		})
	end

	local function UpdateTimedProfilingTimer(p23) -- line: 337
		-- upvalues: p16 (copy)
		while task.wait(0.5) do
			local timedProfilingCountdown = p16:getState(p23).timedProfilingCountdown

			if timedProfilingCountdown <= 0 then
				return
			end

			p16.props.dispatchSetTimer(p23, {
				timedProfilingCountdown = timedProfilingCountdown - 0.5
			})
		end
	end
	local function LiveUpdate(p24) -- line: 352
		-- upvalues: v42 (copy), p16 (copy), ScriptProfilerService (copy), Players (copy)
		while task.wait(v42 / 1000) do
			if p16:getState(p24).liveUpdate then
				if p24 then
					ScriptProfilerService:ClientRequestData(Players.LocalPlayer)
				else
					ScriptProfilerService:ServerRequestData()
				end
			end
		end
	end

	function p16.onBeginProfile() -- line: 362
		-- upvalues: p16 (copy), ScriptProfilerService (copy), Players (copy), UpdateTimedProfilingTimer (copy), LiveUpdate (copy)
		local v211, v212 = p16:getActiveState()

		if v211 then
			ScriptProfilerService:ClientStart(Players.LocalPlayer, v212.frequency)
		else
			ScriptProfilerService:ServerStart(v212.frequency)
		end

		p16.props.dispatchSetIsProfiling(v211, true)
		p16.props.dispatchClearStateForNewSession(v211)

		local t14 = {}

		if v212.timedProfilingDuration > 0 then
			p16.props.dispatchSetTimer(v211, {
				timedProfilingCountdown = v212.timedProfilingDuration
			})
			t14.timedProfilingThread = task.delay(v212.timedProfilingDuration, function() -- line: 375
				-- upvalues: v211 (copy), p16 (copy), ScriptProfilerService (copy), Players (copy)
				local v272 = v211

				if p16:getState(v272).isProfiling then
					if v272 then
						ScriptProfilerService:ClientStop(Players.LocalPlayer)
					else
						ScriptProfilerService:ServerStop()
					end

					p16.props.dispatchSetIsProfiling(v272, false)

					if v272 then
						ScriptProfilerService:ClientRequestData(Players.LocalPlayer)

						return
					end

					ScriptProfilerService:ServerRequestData()
				end
			end)
			t14.timedProfilingTimerThread = task.spawn(function() -- line: 379
				-- upvalues: UpdateTimedProfilingTimer (copy), v211 (copy)
				UpdateTimedProfilingTimer(v211)
			end)
		end

		t14.liveUpdateThread = task.spawn(LiveUpdate, v211)
		p16.props.dispatchSetThreads(v211, t14)
	end
	function p16.onEndProfile() -- line: 389
		-- upvalues: p16 (copy), ScriptProfilerService (copy), Players (copy)
		local v214, v215 = p16:getActiveState()

		if v214 then
			ScriptProfilerService:ClientStop(Players.LocalPlayer)
		else
			ScriptProfilerService:ServerStop()
		end

		local t15 = {}

		if v215.timedProfilingThread then
			task.cancel(v215.timedProfilingThread)
			t15.timedProfilingThread = nil
		end

		if v215.timedProfilingTimerThread then
			task.cancel(v215.timedProfilingTimerThread)
			t15.timedProfilingTimerThread = nil
		end

		if v215.liveUpdateThread then
			task.cancel(v215.liveUpdateThread)
			t15.liveUpdateThread = nil
		end

		p16.props.dispatchSetThreads(v214, {})
		p16.props.dispatchSetIsProfiling(v214, false)

		if v214 then
			ScriptProfilerService:ClientRequestData(Players.LocalPlayer)

			return
		end

		ScriptProfilerService:ServerRequestData()
	end
	function p16.toggleTimedProfiling() -- line: 417
		-- upvalues: p16 (copy)
		local v217, v218 = p16:getActiveState()
		local timedProfilingDuration = v218.timedProfilingDuration
		local v220 = if timedProfilingDuration ~= 0 then if timedProfilingDuration ~= 60 then timedProfilingDuration ~= 300 and 0 or 600 else 300 else 60

		p16.props.dispatchSetTimer(v217, {
			timedProfilingDuration = v220
		})
	end
	function p16.toggleAverage() -- line: 435
		-- upvalues: p16 (copy)
		local v221, v222 = p16:getActiveState()
		local average = v222.average
		local v224 = if average ~= 0 then if average ~= 1 then if average ~= 60 then average ~= 300 and 0 or 600 else 300 else 60 else 1

		p16.props.dispatchSetAverage(v221, v224)
	end
	function p16.toggleUnits() -- line: 455
		-- upvalues: p16 (copy)
		p16.props.dispatchSetScriptProfilerState(nil, not p16.props.usePercentages, nil, nil)
	end
	function p16.toggleFrequency() -- line: 459
		-- upvalues: p16 (copy)
		local v225, v226 = p16:getActiveState()
		local v227 = v226.frequency ~= 1000 and 1000 or 10000

		p16.props.dispatchSetFrequency(v225, v227)
	end
	function p16.onClientButton() -- line: 473
		-- upvalues: p16 (copy)
		p16.props.dispatchSetScriptProfilerState(true)
	end
	function p16.onServerButton() -- line: 477
		-- upvalues: p16 (copy)
		p16.props.dispatchSetScriptProfilerState(false)
	end
	function p16.dataViewDropDownCallback(p25) -- line: 481
		-- upvalues: p16 (copy)
		local v229, v230 = p16:getActiveState()
		local isFunctionsView = v230.isFunctionsView

		if p25 == 1 then
			isFunctionsView = false
		elseif p25 == 2 then
			isFunctionsView = true
		end

		p16.props.dispatchSetDataView(v229, isFunctionsView)
	end
	function p16.onCheckboxChanged(p26, p27) -- line: 495
		-- upvalues: p16 (copy)
		local isClientView = p16.props.isClientView

		if p26 == "Live" then
			p16.props.dispatchSetLiveUpdate(isClientView, p27)

			return
		end

		if p26 == "Plugins" then
			p16.props.dispatchSetShowPlugins(isClientView, p27)

			return
		end

		if p26 == "GC" then
			p16.props.dispatchSetShowGC(isClientView, p27)
		end
	end
	function p16.onSearchTermChanged(p28) -- line: 507
		-- upvalues: p16 (copy), generateSearchFilters (copy)
		local v236, v237 = p16:getActiveState()
		local v238, v239 = generateSearchFilters(v237, p28)

		p16.props.dispatchSetSearchData(v236, {
			searchTerm = p28,
			searchFilterFlat = v238 or {},
			searchFilterGraph = v239 or {}
		})
	end

	p16.utilRef = Roact.createRef()
	p16.state = {
		utilTabHeight = 0
	}
end
function v40.didMount(p29) -- line: 525
	-- upvalues: ScriptProfilerService (copy), OnNewProfilingData (copy)
	p29:setState({
		utilTabHeight = p29.utilRef.current.Size.Y.Offset
	})
	p29.scriptProfilerConnection = ScriptProfilerService.OnNewData:Connect(function(p30, p31) -- line: 531
		-- upvalues: p29 (copy), OnNewProfilingData (copy)
		local v242 = p30 ~= nil
		local v243 = p29:getState(v242)
		local t16 = {}

		OnNewProfilingData(t16, v243, p31)
		p29.props.dispatchSetData(v242, t16)
	end)
end
function v40.willUnmount(p32) -- line: 543
	p32.scriptProfilerConnection:Disconnect()
	p32.scriptProfilerConnection = nil
end
function v40.didUpdate(p33) -- line: 548
	local currentSize = p33.utilRef.current.Size

	if currentSize.Y.Offset ~= p33.state.utilTabHeight then
		p33:setState({
			utilTabHeight = currentSize.Y.Offset
		})
	end
end

local function formatTimer(n9: number?) -- line: 557
	-- upvalues: ProfilerUtil (copy)
	local v150 = ProfilerUtil.formatTimer(n9)

	if v150 ~= "" then
		return ": " .. v150
	end

	return v150
end

function v40.renderUtilButtons(p34, p35, p36, p37) -- line: 567
	-- upvalues: Roact (copy), BoxButton (copy), formatFrequency (copy), MainWindowHeader2 (copy), ColorText (copy), MainWindowHeader (copy), Constants (copy), UnselectedGray (copy), ProfilerUtil (copy), DropDown (copy), SmallFrameHeight (copy), t1 (copy)
	local isProfiling = p35.isProfiling
	local t17 = {}

	table.insert(t17, Roact.createElement(BoxButton, {
		text = not isProfiling and "Start" or "Stop",
		onClicked = isProfiling and p34.onEndProfile or p34.onBeginProfile
	}))

	if not p37 then
		table.insert(t17, Roact.createElement(BoxButton, {
			text = not p34.props.usePercentages and "Unit: ms" or "Unit: %",
			onClicked = p34.toggleUnits
		}))
	end

	if not p37 then
		table.insert(t17, Roact.createElement("TextButton", {
			Text = "Freq: " .. formatFrequency(p35.frequency),
			TextSize = MainWindowHeader2,
			TextColor3 = ColorText,
			Font = MainWindowHeader,
			AutoButtonColor = true,
			BackgroundColor3 = if not isProfiling then UnselectedGray else Constants.Color.InactiveBox,
			BackgroundTransparency = 0,
			[Roact.Event.Activated] = function() -- line: 608
				-- upvalues: isProfiling (copy), p34 (copy)
				if not isProfiling then
					p34.toggleFrequency()
				end
			end
		}))
	end

	if not p37 then
		local createElement = Roact.createElement
		local t18 = {}
		local v159 = if not isProfiling then p35.timedProfilingDuration else p35.timedProfilingCountdown
		local v160 = ProfilerUtil.formatTimer(v159)

		t18.Text = "Time" .. if v160 == "" then v160 else ": " .. v160
		t18.TextSize = MainWindowHeader2
		t18.TextColor3 = ColorText
		t18.Font = MainWindowHeader
		t18.AutoButtonColor = true
		t18.BackgroundColor3 = if not isProfiling then UnselectedGray else Constants.Color.InactiveBox
		t18.BackgroundTransparency = 0
		t18[Roact.Event.Activated] = function() -- line: 631
			-- upvalues: isProfiling (copy), p34 (copy)
			if not isProfiling then
				p34.toggleTimedProfiling()
			end
		end
		table.insert(t17, createElement("TextButton", t18))
	end

	if not p37 then
		local createElement = Roact.createElement
		local t19 = {}
		local average = p35.average
		local v164 = ProfilerUtil.formatTimer(average)

		t19.Text = "Average" .. if v164 == "" then v164 else ": " .. v164
		t19.TextSize = MainWindowHeader2
		t19.TextColor3 = ColorText
		t19.Font = MainWindowHeader
		t19.AutoButtonColor = true
		t19.BackgroundColor3 = if not isProfiling then UnselectedGray else Constants.Color.InactiveBox
		t19.BackgroundTransparency = 0
		t19[Roact.Event.Activated] = function() -- line: 653
			-- upvalues: isProfiling (copy), p34 (copy)
			if not isProfiling then
				p34.toggleAverage()
			end
		end
		table.insert(t17, createElement("TextButton", t19))
	end

	if not p37 then
		table.insert(t17, Roact.createElement(BoxButton, {
			text = "Export",
			onClicked = p34.props.dispatchStartExport
		}))
	end

	if not p37 then
		table.insert(t17, Roact.createElement(DropDown, {
			buttonSize = UDim2.new(0, 100, 0, SmallFrameHeight),
			dropDownList = t1,
			selectedIndex = not p35.isFunctionsView and 1 or 2,
			onSelection = p34.dataViewDropDownCallback
		}))
	end

	if p36 then
		table.insert(t17, Roact.createElement(BoxButton, {
			text = "More...",
			onClicked = function() -- line: 689
				-- upvalues: p34 (copy)
				p34.props.dispatchShowMobileSettings()
			end
		}))
	end

	return t17
end
function v40.renderUtilAndTab(t20: {[any]: any}, t21: {[any]: any}, t22: {[any]: any}) -- line: 699
	-- upvalues: Roact (copy), UtilAndTab (copy), Immutable (copy)
	local size = t20.props.size
	local formFactor = t20.props.formFactor
	local tabList = t20.props.tabList

	return Roact.createElement(UtilAndTab, Immutable.JoinDictionaries({
		layoutOrder = 1,
		windowWidth = size.X.Offset,
		formFactor = formFactor,
		tabList = tabList,
		refForParent = t20.utilRef,
		onHeightChanged = t20.onUtilTabHeightChanged
	}, t21), t22)
end
function v40.renderExportView(p38) -- line: 719
	-- upvalues: Roact (copy), Constants (copy), MainRowPadding (copy), BoxButton (copy), ProfilerExportView (copy)
	local size = p38.props.size
	local utilTabHeight = p38.state.utilTabHeight

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
		UtilAndTab = p38:renderUtilAndTab({}, { Roact.createElement(BoxButton, {
			text = "Exit",
			onClicked = p38.props.dispatchFinishedExporting
		}) }),
		ExportView = Roact.createElement(ProfilerExportView, {
			size = UDim2.new(1, 0, 1, -utilTabHeight)
		})
	})
end
function v40.renderMobileSettingsUI(p39) -- line: 748
	-- upvalues: Roact (copy), Constants (copy), MainRowPadding (copy), BoxButton (copy), MobileSettingsView (copy)
	local size = p39.props.size
	local utilTabHeight = p39.state.utilTabHeight

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
		UtilAndTab = p39:renderUtilAndTab({}, {
			Roact.createElement(BoxButton, {
				text = "Export",
				onClicked = p39.props.dispatchStartExport
			}),
			Roact.createElement(BoxButton, {
				text = "Exit",
				onClicked = p39.props.dispatchHideMobileSettings
			})
		}),
		MobileSettingsView = Roact.createElement(MobileSettingsView, {
			size = UDim2.new(1, 0, 1, -utilTabHeight)
		})
	})
end
function v40.renderProfilerView(p40, p41, p42, p43, p44) -- line: 783
	-- upvalues: Roact (copy), Constants (copy), MainRowPadding (copy), ProfilerFunctionsView (copy), ProfilerView (copy), v41 (copy)
	local isProfiling = p42.isProfiling
	local data = p42.data
	local usePercentages = p40.props.usePercentages
	local isFunctionsView = p42.isFunctionsView
	local rootNode = p42.rootNode
	local rootNodeName = p42.rootNodeName
	local rootFunc = p42.rootFunc
	local size = p40.props.size
	local utilTabHeight = p40.state.utilTabHeight
	local v191 = nil

	if data and (data.SessionStartTime and data.SessionEndTime) then
		v191 = data.SessionEndTime - data.SessionStartTime
	end

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
		UtilAndTab = p40:renderUtilAndTab({
			isClientView = p41,
			onClientButton = p40.onClientButton,
			onServerButton = p40.onServerButton,
			orderedCheckboxState = p44,
			onCheckboxChanged = p40.onCheckboxChanged,
			onSearchTermChanged = p40.onSearchTermChanged,
			searchTerm = p42.searchTerm
		}, p43),
		ProfilerView = Roact.createElement(if not isFunctionsView then ProfilerView else ProfilerFunctionsView, {
			layoutOrder = 2,
			size = UDim2.new(1, 0, 1, -utilTabHeight),
			searchFilter = if not isFunctionsView then p42.searchFilterGraph else p42.searchFilterFlat,
			data = data,
			profiling = isProfiling,
			showAsPercentages = usePercentages,
			sessionLength = v191,
			rootNode = rootNode,
			rootFunc = rootFunc,
			rootNodeName = rootNodeName,
			average = p42.average,
			showPlugins = p42.showPlugins or not v41,
			pluginOffsets = p42.pluginOffsets,
			showGC = p42.showGC,
			gcFunctionOffsets = p42.gcFunctionOffsets,
			gcNodeOffsets = p42.gcNodeOffsets,
			pluginGCOffsets = p42.pluginGCOffsets,
			expandedNodes = if not isFunctionsView then p42.expandedNodes else nil
		})
	})
end
function v40.render(p45) -- line: 847
	-- upvalues: Constants (copy), v41 (copy)
	if p45.props.isExporting then
		return p45:renderExportView()
	end

	if p45.props.isShowingMobileSettings then
		return p45:renderMobileSettingsUI()
	end

	local formFactor = p45.props.formFactor
	local v194, v195 = p45:getActiveState()
	local t23 = {}
	local n10 = 1
	local v198 = formFactor == Constants.FormFactor.Small

	if not v198 then
		t23[1] = {
			name = "Live",
			state = v195.liveUpdate
		}

		if v41 then
			n10 += 1
			t23[n10] = {
				name = "Plugins",
				state = v195.showPlugins
			}
		end

		t23[n10 + 1] = {
			name = "GC",
			state = v195.showGC
		}
	end

	return p45:renderProfilerView(v194, v195, p45:renderUtilButtons(v195, v198, v198), t23)
end

local function mapStateToProps(p46, _) -- line: 882
	return {
		isClientView = p46.ScriptProfiler.isClientView,
		usePercentages = p46.ScriptProfiler.usePercentages,
		isExporting = p46.ScriptProfiler.isExporting,
		isShowingMobileSettings = p46.ScriptProfiler.isShowingMobileSettings,
		client = p46.ScriptProfiler.client,
		server = p46.ScriptProfiler.server
	}
end
local function mapDispatchToProps(p48) -- line: 894
	-- upvalues: SetScriptProfilerState (copy), SetIsProfiling (copy), SetData (copy), SetThreads (copy), SetTimerState (copy), ClearStateForNewProfilingSession (copy), SetAverage (copy), SetFrequency (copy), SetDataView (copy), SetLiveUpdate (copy), SetShowPlugins (copy), SetShowGC (copy), SetSearchData (copy)
	return {
		dispatchSetScriptProfilerState = function(p49, p50, p51, p52) -- line: 896
			-- upvalues: p48 (copy), SetScriptProfilerState (copy)
			p48(SetScriptProfilerState(p49, p50, p51, p52))
		end,
		dispatchSetIsProfiling = function(p53, p54) -- line: 900
			-- upvalues: p48 (copy), SetIsProfiling (copy)
			p48(SetIsProfiling(p53, p54))
		end,
		dispatchSetData = function(p55, p56) -- line: 904
			-- upvalues: p48 (copy), SetData (copy)
			p48(SetData(p55, p56))
		end,
		dispatchSetThreads = function(p57, p58) -- line: 908
			-- upvalues: p48 (copy), SetThreads (copy)
			p48(SetThreads(p57, p58))
		end,
		dispatchSetTimer = function(p59, p60) -- line: 912
			-- upvalues: p48 (copy), SetTimerState (copy)
			p48(SetTimerState(p59, p60))
		end,
		dispatchClearStateForNewSession = function(p61) -- line: 916
			-- upvalues: p48 (copy), ClearStateForNewProfilingSession (copy)
			p48(ClearStateForNewProfilingSession(p61))
		end,
		dispatchSetAverage = function(p62, p63) -- line: 920
			-- upvalues: p48 (copy), SetAverage (copy)
			p48(SetAverage(p62, p63))
		end,
		dispatchSetFrequency = function(p64, p65) -- line: 924
			-- upvalues: p48 (copy), SetFrequency (copy)
			p48(SetFrequency(p64, p65))
		end,
		dispatchSetDataView = function(p66, p67) -- line: 928
			-- upvalues: p48 (copy), SetDataView (copy)
			p48(SetDataView(p66, p67))
		end,
		dispatchSetLiveUpdate = function(p68, p69) -- line: 932
			-- upvalues: p48 (copy), SetLiveUpdate (copy)
			p48(SetLiveUpdate(p68, p69))
		end,
		dispatchSetShowPlugins = function(p70, p71) -- line: 936
			-- upvalues: p48 (copy), SetShowPlugins (copy)
			p48(SetShowPlugins(p70, p71))
		end,
		dispatchSetShowGC = function(p72, p73) -- line: 940
			-- upvalues: p48 (copy), SetShowGC (copy)
			p48(SetShowGC(p72, p73))
		end,
		dispatchSetSearchData = function(p74, p75) -- line: 944
			-- upvalues: p48 (copy), SetSearchData (copy)
			p48(SetSearchData(p74, p75))
		end,
		dispatchStartExport = function() -- line: 948
			-- upvalues: p48 (copy), SetScriptProfilerState (copy)
			p48(SetScriptProfilerState(nil, nil, nil, nil, true))
		end,
		dispatchFinishedExporting = function() -- line: 952
			-- upvalues: p48 (copy), SetScriptProfilerState (copy)
			p48(SetScriptProfilerState(nil, nil, nil, nil, false))
		end,
		dispatchShowMobileSettings = function() -- line: 956
			-- upvalues: p48 (copy), SetScriptProfilerState (copy)
			p48(SetScriptProfilerState(nil, nil, nil, nil, nil, true))
		end,
		dispatchHideMobileSettings = function() -- line: 960
			-- upvalues: p48 (copy), SetScriptProfilerState (copy)
			p48(SetScriptProfilerState(nil, nil, nil, nil, nil, false))
		end
	}
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, mapDispatchToProps)(v40)
