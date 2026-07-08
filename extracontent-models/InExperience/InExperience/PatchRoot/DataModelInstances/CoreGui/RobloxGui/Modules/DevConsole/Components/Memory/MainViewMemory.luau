local CorePackages = game:GetService("CorePackages")
local Stats = game:GetService("Stats")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Components = script.Parent.Parent.Parent.Components
local ClientMemory = require(Components.Memory.ClientMemory)
local ServerMemory = require(Components.Memory.ServerMemory)
local UtilAndTab = require(Components.UtilAndTab)
local DataConsumer = require(Components.DataConsumer)
local Actions = script.Parent.Parent.Parent.Actions
local ClientMemoryUpdateSearchFilter = require(Actions.ClientMemoryUpdateSearchFilter)
local ServerMemoryUpdateSearchFilter = require(Actions.ServerMemoryUpdateSearchFilter)
local Constants = require(script.Parent.Parent.Parent.Constants)
local MainRowPadding = Constants.GeneralFormatting.MainRowPadding
local v15 = game:DefineFastFlag("DevConsoleMemoryTrackingAlert", false)
local v16 = Roact.Component:extend("LogButton")

function v16.init(p1) -- line: 25
	function p1.onAction() -- line: 26
		-- upvalues: p1 (copy)
		local v41 = p1.props.isClientView and p1.props.ClientMemoryData or p1.props.ServerMemoryData
		local s1 = "\n"

		local function line(p2) -- line: 29
			-- upvalues: s1 (ref)
			s1 ..= p2 .. "\n"
		end

		s1 ..= "Name                                       Min   Max" .. "\n"
		s1 ..= "----------------------------------------   ---   ---" .. "\n"

		local function recurseMemoryTree(p3, p4, p5) -- line: 36
			-- upvalues: s1 (ref), recurseMemoryTree (copy)
			local v55 = string.format("%s %s %s %3d   %3d", string.rep(" ", p5), p3, string.rep(" ", 40 - p5 - #p3), p4.min, p4.max)

			s1 ..= v55 .. "\n"

			if p4.children then
				for k, v in pairs(p4.children) do
					recurseMemoryTree(k, v, p5 + 2)
				end
			end
		end

		recurseMemoryTree("Memory", v41._memoryData.Memory, 0)
		print(s1)
	end
end
function v16.render(p6) -- line: 58
	-- upvalues: Roact (copy), Constants (copy)
	return Roact.createElement("TextButton", {
		Text = "Log",
		Visible = true,
		BorderSizePixel = 1,
		BackgroundColor3 = Constants.Color.UnselectedGray,
		TextColor3 = Constants.Color.Text,
		[Roact.Event.Activated] = p6.onAction
	})
end

local u17 = DataConsumer(v16, "ClientMemoryData", "ServerMemoryData")
local v18 = Roact.Component:extend("MainViewMemory")

function v18.init(p7) -- line: 71
	-- upvalues: Roact (copy)
	function p7.onUtilTabHeightChanged(p8) -- line: 72
		-- upvalues: p7 (copy)
		p7:setState({
			utilTabHeight = p8
		})
	end
	function p7.onClientButton() -- line: 78
		-- upvalues: p7 (copy)
		p7:setState({
			isClientView = true
		})
	end
	function p7.onServerButton() -- line: 82
		-- upvalues: p7 (copy)
		p7:setState({
			isClientView = false
		})
	end
	function p7.onSearchTermChanged(p9) -- line: 86
		-- upvalues: p7 (copy)
		if p7.state.isClientView then
			p7.props.dispatchClientMemoryUpdateSearchFilter(p9, {})

			return
		end

		p7.props.dispatchServerMemoryUpdateSearchFilter(p9, {})
	end

	p7.utilRef = Roact.createRef()
	p7.state = {
		utilTabHeight = 0,
		isClientView = true
	}
end
function v18.didMount(p10) -- line: 102
	p10:setState({
		utilTabHeight = p10.utilRef.current.Size.Y.Offset
	})
end
function v18.didUpdate(p11) -- line: 109
	local YOffset = p11.utilRef.current.Size.Y.Offset

	if YOffset ~= p11.state.utilTabHeight then
		p11:setState({
			utilTabHeight = YOffset
		})
	end
end

local function shouldDisplayMemoryWarning() -- line: 120
	-- upvalues: Stats (copy)
	return not Stats.MemoryTrackingEnabled
end

function v18.render(p12) -- line: 124
	-- upvalues: v15 (copy), Stats (copy), Roact (copy), MainRowPadding (copy), UtilAndTab (copy), u17 (ref), Constants (copy), ClientMemory (copy), ServerMemory (copy)
	local t1 = {}
	local size = p12.props.size
	local isDeveloperView = p12.props.isDeveloperView
	local formFactor = p12.props.formFactor
	local tabList = p12.props.tabList
	local utilTabHeight = p12.state.utilTabHeight
	local isClientView = p12.state.isClientView
	local v36 = isClientView and p12.props.clientSearchTerm or p12.props.serverSearchTerm
	local v37 = false

	if v15 then
		v37 = not Stats.MemoryTrackingEnabled
	end

	t1.UIListLayout = Roact.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, MainRowPadding)
	})
	t1.UtilAndTab = Roact.createElement(UtilAndTab, {
		layoutOrder = 1,
		windowWidth = size.X.Offset,
		formFactor = formFactor,
		tabList = tabList,
		isClientView = isClientView,
		searchTerm = v36,
		refForParent = p12.utilRef,
		onHeightChanged = p12.onUtilTabHeightChanged,
		onClientButton = isDeveloperView and p12.onClientButton,
		onServerButton = isDeveloperView and p12.onServerButton,
		onSearchTermChanged = p12.onSearchTermChanged
	}, { u17 and Roact.createElement(u17, {
		isClientView = isClientView
	}) })

	if v37 then
		t1.MemoryHeader = Roact.createElement("TextLabel", {
			Text = "Memory category counters are disabled. Restart the client with the MicroProfiler on to guarantee counters are enabled.",
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, 20),
			Position = UDim2.new(0, 0, 0, 0),
			TextColor3 = Constants.Color.Text,
			BackgroundColor3 = Color3.new(1, 0, 0)
		})
	end

	if utilTabHeight > 0 then
		if isClientView then
			t1.ClientMemory = Roact.createElement(ClientMemory, {
				layoutOrder = 3,
				size = UDim2.new(1, 0, 1, -utilTabHeight),
				searchTerm = v36
			})
		else
			t1.ServerMemory = Roact.createElement(ServerMemory, {
				layoutOrder = 3,
				size = UDim2.new(1, 0, 1, -utilTabHeight),
				searchTerm = v36
			})
		end
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = 4,
		Size = size,
		BackgroundColor3 = Constants.Color.BaseGray
	}, t1)
end

local function mapStateToProps(p13, _) -- line: 198
	return {
		clientSearchTerm = p13.MemoryData.clientSearchTerm,
		clientTypeFilters = p13.MemoryData.clientTypeFilters,
		serverSearchTerm = p13.MemoryData.serverSearchTerm,
		serverTypeFilters = p13.MemoryData.serverTypeFilters
	}
end
local function mapDispatchToProps(p15) -- line: 207
	-- upvalues: ClientMemoryUpdateSearchFilter (copy), ServerMemoryUpdateSearchFilter (copy)
	return {
		dispatchClientMemoryUpdateSearchFilter = function(p16, p17) -- line: 209
			-- upvalues: p15 (copy), ClientMemoryUpdateSearchFilter (copy)
			p15(ClientMemoryUpdateSearchFilter(p16, p17))
		end,
		dispatchServerMemoryUpdateSearchFilter = function(p18, p19) -- line: 213
			-- upvalues: p15 (copy), ServerMemoryUpdateSearchFilter (copy)
			p15(ServerMemoryUpdateSearchFilter(p18, p19))
		end
	}
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, mapDispatchToProps)(v18)
