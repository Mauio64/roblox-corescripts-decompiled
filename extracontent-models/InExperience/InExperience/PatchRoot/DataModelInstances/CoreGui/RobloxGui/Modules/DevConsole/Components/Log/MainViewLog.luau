local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local Components = script.Parent.Parent.Parent.Components
local ClientLog = require(Components.Log.ClientLog)
local ServerLog = require(Components.Log.ServerLog)
local UtilAndTab = require(Components.UtilAndTab)
local DataConsumer = require(Components.DataConsumer)

local Actions = script.Parent.Parent.Parent.Actions
local SetActiveTab = require(Actions.SetActiveTab)

local Constants = require(script.Parent.Parent.Parent.Constants)
local MainRowPadding = Constants.GeneralFormatting.MainRowPadding

local MsgTypeNamesOrdered = Constants.MsgTypeNamesOrdered

local extended = Roact.PureComponent:extend("MainViewLog")

function extended:init()
	function self.onUtilTabHeightChanged(utilTabHeight)
		self:setState({ utilTabHeight = utilTabHeight })
	end

	function self.onClientButton()
		self.props.dispatchSetActiveTab("Log", true)
	end

	function self.onServerButton()
		self.props.dispatchSetActiveTab("Log", false)
	end

	function self.onCheckboxChanged(p, p2)
		if self.props.isClientView then
			self.props.ClientLogData:setFilter(p, p2)
		else
			self.props.ServerLogData:setFilter(p, p2)
		end
	end

	function self.filterUpdated()
		if self.forceUpdate then
			self:forceUpdate()
		else
			self:setState({})
		end
	end

	function self.onSearchTermChanged(p)
		if self.props.isClientView then
			self.props.ClientLogData:setSearchTerm(p)
		else
			self.props.ServerLogData:setSearchTerm(p)
		end
	end

	self.clientFilterConnection = self.props.ClientLogData:filterUpdatedSignal():Connect(self.filterUpdated)

	self.serverFilterConnection = self.props.ServerLogData:filterUpdatedSignal():Connect(self.filterUpdated)

	self.utilRef = Roact.createRef()

	self.state = { utilTabHeight = 0 }
end

function extended.didMount(object)
	object:setState({ utilTabHeight = object.utilRef.current.Size.Y.Offset })
end

function extended.didUpdate(object)
	local size = object.utilRef.current.Size

	if size.Y.Offset ~= object.state.utilTabHeight then
		object:setState({ utilTabHeight = size.Y.Offset })
	end
end

function extended:willUnmount()
	if self.clientFilterConnection then
		self.clientFilterConnection:Disconnect()
		self.clientFilterConnection = nil
	end

	if self.serverFilterConnection then
		self.serverFilterConnection:Disconnect()
		self.serverFilterConnection = nil
	end
end

function extended.render(props)
	local size = props.props.size
	local formFactor = props.props.formFactor
	local isDeveloperView = props.props.isDeveloperView
	local tabList = props.props.tabList
	local isClientView = props.props.isClientView

	local utilTabHeight = props.state.utilTabHeight
	local searchTerm

	if isClientView then
		searchTerm = props.props.ClientLogData:getSearchTerm()
	else
		searchTerm = props.props.ServerLogData:getSearchTerm()
	end

	local children = {}

	children.UIListLayout = Roact.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, MainRowPadding)
	})
	local v

	if isClientView then
		v = props.props.ClientLogData:getFilters()
	else
		v = props.props.ServerLogData:getFilters()
	end

	local orderedCheckboxState = {}

	for i, name in ipairs(MsgTypeNamesOrdered) do
		orderedCheckboxState[i] = { name = name, state = v[name] }
	end

	children.UtilAndTab = Roact.createElement(UtilAndTab, {
		windowWidth = size.X.Offset,
		formFactor = formFactor,
		tabList = tabList,
		orderedCheckboxState = orderedCheckboxState,
		isClientView = isClientView,
		searchTerm = searchTerm,
		layoutOrder = 1,
		refForParent = props.utilRef,
		onClientButton = isDeveloperView and props.onClientButton,
		onServerButton = isDeveloperView and props.onServerButton,
		onCheckboxChanged = props.onCheckboxChanged,
		onSearchTermChanged = props.onSearchTermChanged
	})

	if utilTabHeight > 0 then
		if isClientView then
			children.ClientLog = Roact.createElement(ClientLog, {
				size = UDim2.new(1, 0, 1, -utilTabHeight),
				layoutOrder = 2
			})
		else
			children.ServerLog = Roact.createElement(ServerLog, {
				size = UDim2.new(1, 0, 1, -utilTabHeight),
				layoutOrder = 2
			})
		end
	end

	return Roact.createElement(
		"Frame",
		{
			Size = size,
			BackgroundColor3 = Constants.Color.BaseGray,
			BackgroundTransparency = 1,
			LayoutOrder = 3
		},
		children
	)
end

local function mapStateToProps(p, _)
	return { isClientView = p.MainView.isClientView }
end

local function mapDispatchToProps(callback)
	return {
		dispatchSetActiveTab = function(p, p2)
			callback(SetActiveTab(p, p2))
		end
	}
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, mapDispatchToProps)(DataConsumer(extended, "ClientLogData", "ServerLogData"))
