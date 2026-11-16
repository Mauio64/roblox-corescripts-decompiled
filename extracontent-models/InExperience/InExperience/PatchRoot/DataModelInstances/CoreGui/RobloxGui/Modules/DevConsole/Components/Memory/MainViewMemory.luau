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

local defineFastFlag = game:DefineFastFlag("DevConsoleMemoryTrackingAlert", false)

local extended = Roact.Component:extend("LogButton")
function extended:init()
	function self.onAction()
		local clientMemoryData = self.props.isClientView and self.props.ClientMemoryData or self.props.ServerMemoryData
		local v = "\n"
		local function line(p) -- 1 equivalent call inferred from this helper
			v ..= p .. "\n"
		end

		v ..= "Name                                       Min   Max\n"
		v ..= "----------------------------------------   ---   ---\n"
		local function recurseMemoryTree(list, memory, count)
			line(string.format( -- inferred equivalent call
				"%s %s %s %3d   %3d",
				string.rep(" ", count),
				list,
				string.rep(" ", 40 - count - #list),
				memory.min,
				memory.max
			))

			if memory.children then
				for k, child in pairs(memory.children) do
					recurseMemoryTree(k, child, count + 2)
				end
			end
		end
		recurseMemoryTree("Memory", clientMemoryData._memoryData.Memory, 0)
		print(v)
	end
end

function extended.render(p)
	return Roact.createElement("TextButton", {
		Text = "Log",
		Visible = true,
		BorderSizePixel = 1,
		BackgroundColor3 = Constants.Color.UnselectedGray,
		TextColor3 = Constants.Color.Text,
		[Roact.Event.Activated] = p.onAction
	})
end

local dataConsumer = DataConsumer(extended, "ClientMemoryData", "ServerMemoryData")

local extended2 = Roact.Component:extend("MainViewMemory")
function extended2:init()
	function self.onUtilTabHeightChanged(utilTabHeight)
		self:setState({ utilTabHeight = utilTabHeight })
	end

	function self.onClientButton()
		self:setState({ isClientView = true })
	end

	function self.onServerButton()
		self:setState({ isClientView = false })
	end

	function self.onSearchTermChanged(p)
		if self.state.isClientView then
			self.props.dispatchClientMemoryUpdateSearchFilter(p, {})
		else
			self.props.dispatchServerMemoryUpdateSearchFilter(p, {})
		end
	end

	self.utilRef = Roact.createRef()

	self.state = { utilTabHeight = 0, isClientView = true }
end

function extended2.didMount(object)
	object:setState({ utilTabHeight = object.utilRef.current.Size.Y.Offset })
end

function extended2.didUpdate(object)
	local offset = object.utilRef.current.Size.Y.Offset

	if offset ~= object.state.utilTabHeight then
		object:setState({ utilTabHeight = offset })
	end
end

local function shouldDisplayMemoryWarning(): boolean -- 1 equivalent call inferred from this helper
	return not Stats.MemoryTrackingEnabled
end

function extended2.render(props)
	local children = {}
	local size = props.props.size
	local isDeveloperView = props.props.isDeveloperView
	local formFactor = props.props.formFactor
	local tabList = props.props.tabList

	local utilTabHeight = props.state.utilTabHeight
	local isClientView = props.state.isClientView
	local clientSearchTerm = isClientView and props.props.clientSearchTerm or props.props.serverSearchTerm
	local v

	if defineFastFlag then
		v = shouldDisplayMemoryWarning() -- inferred equivalent call
	else
		v = false
	end

	children.UIListLayout = Roact.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, MainRowPadding)
	})

	children.UtilAndTab = Roact.createElement(UtilAndTab, {
		windowWidth = size.X.Offset,
		formFactor = formFactor,
		tabList = tabList,
		isClientView = isClientView,
		searchTerm = clientSearchTerm,
		layoutOrder = 1,
		refForParent = props.utilRef,
		onHeightChanged = props.onUtilTabHeightChanged,
		onClientButton = isDeveloperView and props.onClientButton,
		onServerButton = isDeveloperView and props.onServerButton,
		onSearchTermChanged = props.onSearchTermChanged
	}, { dataConsumer and Roact.createElement(dataConsumer, { isClientView = isClientView }) })

	if v then
		children.MemoryHeader = Roact.createElement("TextLabel", {
			Size = UDim2.new(1, 0, 0, 20),
			Position = UDim2.new(0, 0, 0, 0),
			Text = "Memory category counters are disabled. Restart the client with the MicroProfiler on to guarantee counters are enabled.",
			TextColor3 = Constants.Color.Text,
			BackgroundColor3 = Color3.new(1, 0, 0),
			LayoutOrder = 2
		})
	end

	if utilTabHeight > 0 then
		if isClientView then
			children.ClientMemory = Roact.createElement(ClientMemory, {
				size = UDim2.new(1, 0, 1, -utilTabHeight),
				searchTerm = clientSearchTerm,
				layoutOrder = 3
			})
		else
			children.ServerMemory = Roact.createElement(ServerMemory, {
				size = UDim2.new(1, 0, 1, -utilTabHeight),
				searchTerm = clientSearchTerm,
				layoutOrder = 3
			})
		end
	end

	return Roact.createElement(
		"Frame",
		{
			Size = size,
			BackgroundColor3 = Constants.Color.BaseGray,
			BackgroundTransparency = 1,
			LayoutOrder = 4
		},
		children
	)
end

local function mapStateToProps(p, _)
	return {
		clientSearchTerm = p.MemoryData.clientSearchTerm,
		clientTypeFilters = p.MemoryData.clientTypeFilters,
		serverSearchTerm = p.MemoryData.serverSearchTerm,
		serverTypeFilters = p.MemoryData.serverTypeFilters
	}
end

local function mapDispatchToProps(callback)
	return {
		dispatchClientMemoryUpdateSearchFilter = function(p, p2)
			callback(ClientMemoryUpdateSearchFilter(p, p2))
		end,
		dispatchServerMemoryUpdateSearchFilter = function(p, p2)
			callback(ServerMemoryUpdateSearchFilter(p, p2))
		end
	}
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, mapDispatchToProps)(extended2)
