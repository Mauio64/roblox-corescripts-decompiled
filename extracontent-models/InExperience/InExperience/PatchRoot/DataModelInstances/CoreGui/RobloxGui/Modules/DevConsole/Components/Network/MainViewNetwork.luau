local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local Components = script.Parent.Parent.Parent.Components
local ClientNetwork = require(Components.Network.ClientNetwork)
local ServerNetwork = require(Components.Network.ServerNetwork)
local UtilAndTab = require(Components.UtilAndTab)

local Actions = script.Parent.Parent.Parent.Actions
local ClientNetworkUpdateSearchFilter = require(Actions.ClientNetworkUpdateSearchFilter)
local ServerNetworkUpdateSearchFilter = require(Actions.ServerNetworkUpdateSearchFilter)
local SetActiveTab = require(Actions.SetActiveTab)

local Constants = require(script.Parent.Parent.Parent.Constants)
local MainRowPadding = Constants.GeneralFormatting.MainRowPadding

local extended = Roact.Component:extend("MainViewNetwork")

function extended:init()
	function self.onUtilTabHeightChanged(utilTabHeight)
		self:setState({ utilTabHeight = utilTabHeight })
	end

	function self.onClientButton()
		self.props.dispatchSetActiveTab("Network", true)
	end

	function self.onServerButton()
		self.props.dispatchSetActiveTab("Network", false)
	end

	function self.onSearchTermChanged(p)
		if self.props.isClientView then
			self.props.dispatchClientNetworkUpdateSearchFilter(p, {})
		else
			self.props.dispatchServerNetworkUpdateSearchFilter(p, {})
		end
	end

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

function extended.render(props)
	local children = {}
	local size = props.props.size
	local formFactor = props.props.formFactor
	local tabList = props.props.tabList
	local isClientView = props.props.isClientView

	local utilTabHeight = props.state.utilTabHeight
	local clientSearchTerm = isClientView and props.props.clientSearchTerm or props.props.serverSearchTerm

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
		onClientButton = props.onClientButton,
		onServerButton = props.onServerButton,
		onSearchTermChanged = props.onSearchTermChanged
	})

	if utilTabHeight > 0 then
		if isClientView then
			children.ClientNetwork = Roact.createElement(ClientNetwork, {
				size = UDim2.new(1, 0, 1, -utilTabHeight),
				searchTerm = clientSearchTerm,
				layoutOrder = 2
			})
		else
			children.ServerNetwork = Roact.createElement(ServerNetwork, {
				size = UDim2.new(1, 0, 1, -utilTabHeight),
				searchTerm = clientSearchTerm,
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
	return {
		isClientView = p.MainView.isClientView,
		clientSearchTerm = p.NetworkData.clientSearchTerm,
		serverSearchTerm = p.NetworkData.serverSearchTerm
	}
end

local function mapDispatchToProps(callback)
	return {
		dispatchClientNetworkUpdateSearchFilter = function(p, p2)
			callback(ClientNetworkUpdateSearchFilter(p, p2))
		end,
		dispatchServerNetworkUpdateSearchFilter = function(p, p2)
			callback(ServerNetworkUpdateSearchFilter(p, p2))
		end,
		dispatchSetActiveTab = function(p, p2)
			callback(SetActiveTab(p, p2))
		end
	}
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, mapDispatchToProps)(extended)
